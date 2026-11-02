# Community migration observations

Reviewed 2026-10-26 from the owner-supplied community conversion guide (including reports attributed to RMK and Deceptious). These are third-party compiler/runtime observations, not locally reproduced guarantees or universal restrictions across tool versions. Use the conservative adaptations below when relevant; validate the actual target and preserve behavior. [Review evidence](../../../../docs/research/redmod/community-conversion-review.md).

## Low-risk conversion practices

- Match official signatures, including event returns, optional/out/const and reference ownership. Prefer `function`, `event`, `optional`, `NULL`, `T"Record.ID"`, `R"resource/path"`, and explicit local types where inference fails. Do not mechanically preserve script_ref or erase every ref: our compiled map wrapper uses ref<WorldMapTooltipData>.
- Use `new MyClass` where construction with parentheses fails; return a typed empty array local instead of `[]`. For native Float parameters use floating literals such as 445.0. Use array<T> return types and block function bodies. Check virtual overrides for the required override keyword. Avoid the reserved identifier name; retain the author's naming style and check collisions.
- Locals are effectively function-scoped. Use distinct local names across branches and explicitly reset per-iteration state; declaration inside a loop alone is not a reset. For example, declare an array before the loop and call Clear() each iteration when a fresh collection is intended.
- Materialize returned arrays/structs before accessing array methods or struct fields if the compiler rejects temporaries. Account for possible collection copies and avoid repeating retrieval in per-item callbacks.
- Parenthesize operator expressions in generic casts: Cast<Int32>((a * b)). If a cast inside an array initializer fails, use a typed local or PushBack; verify numeric semantics rather than changing rounding or signedness casually.
- For embedded quotes, reported working forms include Unicode escape \u{22} and NameToString applied to a single-quoted CName literal containing a double quote. Do not assume community \" or hex escapes decode correctly; verify the displayed string, not only compilation.

```text
let values: array<Int32> = system.GetValues();
let found: Bool = values.Contains(3);
let size: Vector2 = widget.GetSize();
let height: Float = size.Y;
```

These examples illustrate adaptations and require actual target signatures. A reported absence of RoundF is contradicted by its declaration and calls in installed official sources; check the symbol and compile the use case instead of replacing its math blindly.

## Patch and runtime hazards

- Patching a mod-defined class reportedly compiles but crashes during loading. Modify classes owned by the mod directly. Prefer existing game classes as annotation targets; inspect importonly declarations, where added members reportedly disappear instead of producing a direct diagnostic.
- Prefix cancellation reportedly suppresses postfixes, contrary to the earlier official reference. Never place mandatory cleanup solely in a postfix after a cancellable prefix. Prefixes on non-void methods reportedly corrupt returned values; prefer a wrapper with an explicit return path when the result matters.
- Replacements reportedly may be skipped by same-class callers; wrappers may execute twice, and repeated script calls may stop reaching the patch. Test caller origin, repeated calls, return values and side effects for the actual hook. Do not add speculative deduplication guards that suppress legitimate calls. A wrapper is a useful alternative, not immunity to these reports.
- An enum created by casting, returned through a direct call, and then discarded reportedly crashes. In affected paths, cast and return through typed locals; test both consumed and discarded results. This is not a reason to rewrite every direct return.

```text
function ConvertKey(stored: Uint64) -> EInputKey {
  let numericValue: Int32 = Cast<Int32>(stored);
  let enumValue: EInputKey = (EInputKey)numericValue;
  return enumValue;
}
```

Visibility modifiers on standalone annotated members reportedly cause problems: omit public/private/protected while preserving required static/final/const and the target signature. Duplicate added methods have conflicting reported outcomes; never rely on either successful loading or last-one-wins resolution.

## Modules and conditionals

For a custom ScriptableSystem in a module, the reported lookup uses the bare class name (container.Get(n"MySystem")), not the module-qualified name. Check the returned reference before use and validate startup/restore behavior; vanilla bare-name lookups alone do not prove custom-module semantics.

Conditional compilation reports add constraints: two positive ModuleExists variants can fail silently; conditional addMethod supports only one version. Prefer simple complementary conditions for functions, a single conditional added method, and matching guards on callers. Do not add a second inverse addMethod variant merely to emulate a conditional function. Inspect the full final compile log on unexplained failures.

## Persistent configuration

Reported restart-safe types are Bool, Int32, Float, String and Uint64. Int64 keybind storage reportedly becomes Boolean or is lost, conflicting with the earlier Int64 documentation. Treat Uint64 as a candidate requiring a restart test; do not reinterpret existing persisted values without migration planning.

Names/types enumeration reportedly has different ordering and membership, including stale settings from removed mods. Never zip the arrays by index. Unknown-name lookups reportedly return an unsafe-to-cast Variant: verify membership before reading, cache enumeration outside repeated UI callbacks, and refresh it when registrations change. Explicitly save committed settings, then verify after restarting and loading another save. Reported storage is global across saves and survives uninstall; do not promise uninstall resets defaults. The reported PC file is Saved Games/CD Projekt Red/Cyberpunk 2077/EnabledMods.json under mods_config; editing it is a separate scoped action, not an automatic test step.

## Packaging and diagnostics

Use mod folder names without periods as a conservative convention: dotted folder names reportedly fail to load. This does not prohibit dots in filenames or module names.

The guide reports ScriptLog diagnostics with -logScripts and a global declaration:

```text
import function ScriptLog(const text : ref<string>);
```

Treat this as temporary isolated diagnostic code. Multiple mods declaring the import reportedly abort script-mod loading; check existing declarations and remove added imports/calls before release. Do not introduce logging imports just to prove a successful compile.

Keep the project's verified c77 setup and disable/restore BOTH redscript compiler files as described in packaging-and-testing.md. The community guide's shorter installation example does not supersede the tested flow. Preserve source scripts for cloud cooking; distinguish compile output from YAML/XL conversion performed by publishing tools.
