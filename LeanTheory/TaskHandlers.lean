/-
Copyright (c) 2026 LeanTheory contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: LeanTheory contributors
-/
module

public import Lean
public import LeanTheory.Elaborate
public meta import LeanTheory.ResponseExt

/-!
# Tasks for checking and evaluating code

Two tasks for the `theory_loop` and `theory_server` executables, meant for automated use such as
evolutionary search, where many candidates are tried in turn:

* `check`: does the `"code"` compile? Reports structured messages, the new declarations and those
  using `sorry`;
* `eval`: elaborate the optional `"code"`, then evaluate the `"term"` in the environment it
  produces.

Both leave the shared environment unchanged unless the request sets `"modify_env": true`. They use
the frontend functions of `LeanTheory.Elaborate`, passing `modifyEnv` accordingly.
-/

public section

open Lean Meta Elab Term

namespace LeanTheory

/-- The optional field `"modify_env"` of a `check` or `eval` request (default `false`): whether the
definitions of the code are kept in the shared environment when the code has no errors. -/
def keepEnvField (source : Json) : Bool :=
  (source.getObjValAs? Bool "modify_env").toOption.getD false

/-- The number of lines of a prefix such as `defaultTop`, to report positions in submitted code. -/
def lineOffset (top : String) : Nat := (top.toList.filter (· == '\n')).length

/-- A message as JSON: severity, line and column in the submitted code (after `top`), and text. -/
def messageJson (msg : Message) (top : String := defaultTop) : IO Json := do
  let severity := match msg.severity with
    | .error => "error"
    | .warning => "warning"
    | .information => "info"
  return Json.mkObj [("severity", severity), ("line", toJson (msg.pos.line - lineOffset top)),
    ("column", toJson msg.pos.column), ("text", ← msg.data.toString)]

/-- Elaborate `code` and report whether it compiles: the messages, the new declarations (without
auxiliary ones such as `f.match_1`), and the declarations whose type or value uses `sorry`.
Code compiles when there are no errors and no `sorry`. The new declarations are kept only if
`keep` is true and there are no errors. -/
def checkCodeM (code : String) (keep : Bool := false) (top : String := defaultTop) :
    MetaM Json := do
  let oldEnv ← getEnv
  let (env, msgs) ←
    runFrontendM code (modifyEnv := fun m => keep && hasNoErrors m) (top := top)
  let messages ← msgs.toList.mapM (messageJson · top)
  let errors := msgs.toList.filter (·.severity == .error)
  let newDecls := env.constants.map₂.toList.filter fun (n, _) => !oldEnv.contains n
  let sorryDecls := newDecls.filterMap fun (n, c) =>
    if c.type.hasSorry || ((c.value? (allowOpaque := true)).map Expr.hasSorry).getD false then
      some n
    else none
  return Json.mkObj [("result", "ok"),
    ("compiles", toJson (errors.isEmpty && sorryDecls.isEmpty)),
    ("errors", toJson errors.length),
    ("declarations",
      toJson ((newDecls.map (·.1)).filter (!·.isInternalDetail) |>.map toString)),
    ("sorry", toJson (sorryDecls.map toString)),
    ("messages", toJson messages)]

/-- Task `check`: does the `"code"` compile? -/
@[response "check"] def responseCheck (source : Json) : TermElabM Json := do
  let .ok code := source.getObjValAs? String "code" | throwError "Missing 'code' field in JSON"
  checkCodeM code (keep := keepEnvField source)

/-- Elaborate `code`, then evaluate the `repr` of `term` in the environment it produces. If the
code has errors, nothing is evaluated. The definitions of the code are kept only if `keep` is true
and there are no errors; whatever elaborating the term adds is always discarded. -/
def evalWithCodeM (code term : String) (keep : Bool := false) (top : String := defaultTop) :
    TermElabM Json := do
  let (env, msgs) ←
    runFrontendM code (modifyEnv := fun m => keep && hasNoErrors m) (top := top)
  let messages ← msgs.toList.mapM (messageJson · top)
  unless hasNoErrors msgs do
    return Json.mkObj [("result", "error"), ("error", "the code has errors"),
      ("messages", toJson messages)]
  let fmt ← withoutModifyingEnv do
    setEnv env
    viewElabTerm term
  return Json.mkObj [("result", "ok"), ("output", fmt.pretty), ("messages", toJson messages)]

/-- Task `eval`: elaborate the optional `"code"`, then evaluate the `"term"`. -/
@[response "eval"] def responseEval (source : Json) : TermElabM Json := do
  let .ok term := source.getObjValAs? String "term" | throwError "Missing 'term' field in JSON"
  let code := (source.getObjValAs? String "code").toOption.getD ""
  evalWithCodeM code term (keep := keepEnvField source)

end LeanTheory
