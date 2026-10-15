# Language And Patterns

Resolve all path aliases from the root AGENTS.md. The project instructions below are preserved from the original harness.

## Language Notes

- redscript is statically typed. Prefer explicit local variable, parameter, and return types when inference is not obvious from nearby game code.
- Common primitive and literal-facing types include `Bool`, `Int32`, `Uint32`, `Float`, `String`, `CName`, `ResRef`, `TweakDBID`, and `Variant`. Check the native types docs when using less common numeric widths or literal suffixes.
- Use redscript reference forms such as `ref<T>` and `wref<T>` according to the ownership and lifetime patterns in the original game scripts. Do not substitute Swift/C#/Kotlin reference assumptions.
- Use redscript array, map, constructor, callback, persistence, delay, and logging patterns from the wiki or existing scripts before inventing helper APIs.
- For downcasting, follow the documented safe downcasting pattern or an existing game/Codeware example. Do not invent Swift-style casts.
- For loops and conditionals, follow redscript syntax exactly. If unsure about loop form, check the loops wiki or copy a nearby game-source pattern.
- For strings, distinguish mutable `String` from hashed/name-like `CName`; do not build dynamic `CName`, `ResRef`, or `TweakDBID` values unless the API and examples support it.
- If adding a `module`, remember that module items need `public` exports and explicit imports to be visible elsewhere. Runtime names may be fully qualified by module path.
- Use conditional compilation only when the target environment or optional dependency really requires it, and verify the wiki syntax first.
- For math, random, and utility functions, prefer documented built-ins or existing game helpers. Check the relevant wiki page before guessing names or overloads.
- Treat Codeware and TweakXL as optional installed dependencies: use their APIs only when the script is intended to require them, and verify symbols against the local dependency `.reds` files.

## Language Feature Quick Reference

- Annotations patch existing game classes/functions, not modded ones. Do not use patch annotations on native functions. Prefer `@wrapMethod(ClassName)` with `wrappedMethod(...)` for composability, use `@replaceMethod(ClassName)` or `@replaceGlobal()` only when replacement is intentional, and use `@addMethod(ClassName)` / `@addField(ClassName)` for extensions.
- Intrinsics include `Equals`, `NotEquals`, `IsDefined`, `ToString`, `EnumInt`, `IntEnum`, `ToVariant`, `FromVariant`, and array helpers such as `ArraySize`, `ArrayPush`, `ArrayPop`, `ArrayClear`, `ArrayResize`, `ArrayContains`, `ArrayFindFirst`, `ArrayFindLast`, `ArrayCount`, `ArrayInsert`, `ArrayRemove`, `ArrayErase`, and `ArrayLast`. `FromVariant` can fail at runtime if the stored type does not match.
- Loops are `while` and `for elem in array`; redscript does not support `continue`. To skip the rest of an iteration, restructure the conditional or move the loop body into a helper function and `return`.
- Strings support interpolation with the `s"..."` prefix and `\(expr)`, regular concatenation with `+`, conversion through helpers such as `ToString`, `NameToString`, `StringToName`, `StringToFloat`, and `StringToInt`, and operations such as `StrContains`, `StrLen`, `StrFindFirst`, `StrReplace`, `StrSplit`, `StrUpper`, and `StrLower`.
- Modules start with `module Some.Path` at the top of the file. Module items are private to the module unless marked `public` and imported elsewhere. Without a module header, code is in global scope. Runtime names for module items are fully qualified by module path.
- Conditional compilation uses `@if(condition)` before imports, classes, methods, fields, wrappers, or replacements. Conditions may use `true`, `false`, logical operators `&&`, `||`, `!`, `?:`, and `ModuleExists("Some.Module")`. Gate optional imports and any code that references optional module symbols with the same condition.

## Common Patterns Quick Reference

- Safe downcasting uses `let value = source as TargetType;` followed by `if IsDefined(value) { ... }`. The `as` operator returns `null` on failed dynamic casts and keeps the same reference kind, such as `ref<T>` to `ref<U>` or `wref<T>` to `wref<U>`.
- redscript has no native constructors. Create instances with `new ClassName()` and assign fields, or define a static `Create(...) -> ref<ClassName>` helper when repeated initialization should be one-line and consistent.
- For map-like storage, prefer existing game map types when nearby code already uses them. `inkHashMap` stores `Uint64 -> ref<IScriptable>` and `inkWeakHashMap` stores `Uint64 -> wref<IScriptable>`; custom classes can be values when they extend `IScriptable`. Common keys include numeric `TweakDBID` values from `TDBID.ToNumber(t"...")`.
- Heterogeneous array literals work when the expected type is `array<Variant>`; literal elements are converted to `Variant`. Prefer an explicitly typed local `let values: array<Variant> = [...]` when inference could be ambiguous.
- Custom singleton-like systems extend `ScriptableSystem` and are accessed through `GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"Full.Module.SystemName") as SystemName`. Include the module namespace in the `CName` when the system class is declared in a module.
- Delayed work uses `DelayCallback` subclasses with a `Call()` method and a static `Create(...)` helper for captured data. Schedule with `GameInstance.GetDelaySystem(gameInstance).DelayCallback(callback, delaySeconds, isAffectedByTimeDilation)`. When the delayed work can become stale, be superseded, or need cleanup on uninitialize/reset/filter changes, store the returned `DelayID` in a field, cancel it with `CancelCallback(delayID)`, and reset the field to `GetInvalidDelayID()`. Token/version checks are still useful as a secondary guard for callbacks that may already be executing.
- Generic callbacks based on Codeware reflection require Codeware and should not be used in mods that are meant to stay vanilla-only. Store callback targets as `wref<IScriptable>`, method names as `CName`, arguments as `array<Variant>`, and mark callback target methods with `cb`. Static callback names use `n"ModuleName.ClassName::MethodName"`; omit `ModuleName` only for global-scope classes.
- Persistence applies to fields in classes extending `ScriptableSystem` or `PersistentState`. Mark every field that must be saved with `persistent`, including fields inside persisted class instances. Do not persist `String`, `Variant`, `ResRef`, or arrays of those types.
