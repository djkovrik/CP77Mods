# Annotation patches and their interaction

Documentation-derived semantics, incorporated 2026-10-23. Examples are explanatory alternatives, not one file to concatenate, and have not all been compiled. A separate smoke test on 2026-10-23 compiled a game-class wrapper, an added field and an added method; prefix/postfix, replacement and load-order semantics remain documentation-derived, not runtime-tested. Read the exact target signature and the project call-cost rules before adapting them.

## Add fields and methods

Annotations are top-level declarations targeting an existing class. Earlier documentation demonstrates mod-defined targets, but community tests report load-time crashes. Modify owned classes directly; annotation examples below use schematic existing-game targets, not classes to declare in the mod. Inspect importonly restrictions and [reported runtime hazards](community-migration-caveats.md#patch-and-runtime-hazards).

```text
@addField(ExampleCounter)
var myMod_bonus: Int32;

@addMethod(ExampleCounter)
function MyModReadBonus() -> Int32 {
  return this.myMod_bonus;
}
```

`@addField` adds a member; it is not automatically persistent configuration unless it participates in the ModdingSystem mechanism. `@addMethod` requires a new name for the target class. If two mods add a method with the same name, the documented consequence is failure to load all mods and fallback to the base game, not last-one-wins. Community reports observed loading despite duplicates but did not establish which implementation was called; collision behavior is not safe to depend on. Search the target, ancestors and installed mods for collisions; follow the author's established naming style, using prefixes only when that style is unclear; a module namespace does not excuse a collision on the patched class. Field-collision resolution is not specified here: prevent collisions rather than inventing a precedence rule.

## Wrap and replace

```text
@wrapMethod(ExampleCounter)
function ReadValue() -> Int32 {
  let originalValue: Int32 = ReadValue();
  return originalValue + 1;
}
```

The annotation targets the method with the matching name/signature. Call its unqualified name to enter the underlying chain. This is `ReadValue()`, not redscript's `wrappedMethod()` and not `this.ReadValue()`. The call can appear before or after custom work; preserve its arguments, result and intended count. Omitting the call does not preserve original behavior.

An alternative replacement:

```text
@replaceMethod(ExampleCounter)
function ReadValue() -> Int32 {
  return 20;
}
```

A replacement supplies the body and does not call the original. Among competing replacements the latest loaded replacement is used; earlier replacements are ignored. Use a wrapper when retaining the original behavior is required.

## Prefixes and postfixes

For a target with no parameters and no return value:

```text
@prefix(ExampleAction)
function Run() -> Void {
  return;
}

@postfix(ExampleAction)
function Run() -> Void {
  return;
}
```

The class-target form uses the target method's name. A prefix runs before the body and does not manually call it; a postfix runs afterward and likewise does not call it. A bare return from the void prefix just finishes that prefix; it is not the Boolean cancellation form.

The string-target forms allow distinct patch-function names:

```text
@prefix("ExampleAction.Run")
function MyModAllowRun() -> Bool {
  return false;
}

@postfix("ExampleAction.Run")
function MyModAfterRun() -> Void {
  return;
}
```

The custom-name prefix must return `Bool`. `true` permits remaining prefixes and the body to proceed; `false` skips the remaining prefixes and original/replacement body. Postfix execution after cancellation is disputed: the earlier official reference says it continues, but community tests report it is skipped. Do not rely on it for mandatory cleanup, or assume the body executed. The custom-name postfix does not have the prefix's Boolean control contract.

These examples intentionally avoid parameters and return values on the target. The available semantics do not establish how prefixes/postfixes receive parameters, resolve overloads, edit results or supply a skipped non-void body's return value. Do not import Harmony/redscript conventions such as special result parameters. Resolve those cases from updated target documentation/compiler evidence; use a wrapper with an explicit return path when suitable.

## Order and compatibility

When wrapper mod A loads before wrapper mod B, entry is `B -> A -> underlying method`. The documented nesting is:

```text
B before
  A before
    prefixes
      original OR latest replacement
    postfixes
  A after
B after
```

The diagram assumes each wrapper calls through once. Wrappers surround the prefix/body/postfix pipeline; saying wrappers run first does not move their post-call work ahead of postfixes. Prefix cancellation skips later prefixes and the body, with postfix execution disputed as described above. A wrapper that never calls through does not establish that the inner pipeline runs at all.

Patch application is load-order-dependent as well as patch-type-dependent. Do not infer a precise ordering among several prefixes or several postfixes from the wrapper examples alone, nor assume other mods' order is fixed. Account for suppression, replacement conflicts and post-processing that overwrites another mod's result in compatibility tests.
