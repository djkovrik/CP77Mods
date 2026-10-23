# Official script sources and migration

## Navigate by target compiler

Use `rg --files <REDMOD_SCRIPTS_ROOT>` and `rg -n 'ClassName|MethodName' <REDMOD_SCRIPTS_ROOT> -g '*.script'`. The official tree contains `core` (engine declarations and common types), `cyberpunk` (gameplay/UI), `exec`, `samples`, `tests` and `mods`. A sample or `mods/codeware` entry is not proof that all Codeware APIs are supported. `import` declarations expose native implementation; their internal cost remains unknown.

Follow the class hierarchy and exact overload. Example: `cyberpunk/UI/fullscreen/map/worldMapTooltips.script` defines the tooltip data, base controller and concrete controllers; the police tooltip has its own implementation. `core/ui/widgetReference.script` declares Ink reference operations; `core/data/tweakDB.script`, `core/data/tweakDBID.script` and `core/systems/journalManager.script` declare the corresponding native APIs.

Read surrounding code and callees before patching. Compare current sources with any old full-file mod to extract only the mod's behavioral delta, then apply that delta to current APIs. Do not carry an old vanilla body forward. Search active scripts and other relevant installed layers for collisions; a sparse active installation does not establish future compatibility with mods stored in the repository.

## Syntax differences

Current samples use `@module "ModName"`, standalone annotation functions, `function`, `event`, `let`, `->` return types and parenthesized conditions. Official game sources also use `var`, `: ReturnType`, `weak<T>` syntax. `let` and `var` are interchangeable mutable declarations; both return-type forms are supported. Match the target dialect rather than treating community syntax as interchangeable. Examples below are documentation-derived, not individually compilation-tested; see the build reference for the successful smoke test and its limited scope.

| redscript | Official target guidance |
| --- | --- |
| `@wrapMethod(C)` + `wrappedMethod(args)` | Same annotation; call `MethodName(args)` inside that wrapper; return it when needed |
| `@addMethod`, `@replaceMethod`, `@addField` | Supported; added names must avoid collisions, replacements retain their conflict cost |
| `func`, `cb func` | `function`, `event`; verify callback signature and return convention |
| `script_ref<Struct>`, `Deref(data).field` | Official source uses `ref<Struct>`, `data.field`; inspect each signature |
| `ref<GameClass>` | Official signatures commonly use `GameClass` directly; do not globally erase `ref` because struct references differ |
| `module Some.Name` | `@module "Name"` at the file top; `@using "Other.Module"` imports a module; see [modules-and-settings.md](modules-and-settings.md) |
| `Equals(a,b)`, `NotEquals(a,b)` | `a == b`, `a != b` |
| `IsDefined(a)` | Reference truth test such as `if (a)` |
| String interpolation | Not supported by the official guide; use concatenation and supported conversions |
| `ToString(v)` | `v.ToString()` per guide; use verified typed helpers where appropriate |
| Enum/Variant intrinsics | Explicit casts or `as`, preserving conversion/failure semantics |
| `ArraySize(a)`, `ArrayPush(a,x)` | `a.Size()`, `a.PushBack(x)`; other array operations have method syntax |
| `for item in array` | Verify support; documented loops are `while (...)` and counter-controlled `for (...)` |

`@prefix` and `@postfix` are also documented; see [annotations.md](annotations.md) for forms, cancellation and patch ordering. Runtime conditional functions using `@if(ModuleExists(...))` are documented but unstable; they are not a blanket equivalent of redscript conditional compilation. The guide lists incomplete math support; verify actual symbols. For example, its table says `RoundMath` is unsupported while game sources call it; retain this uncertainty rather than silently rewriting numeric behavior. Commented sample code is not compiler evidence. If a future distribution has missing declarations, absence alone is not proof that a documented API is unsupported; verify the source/tool versions.

## Local declarations, returns, arrays and casts

```text
function ExampleValue() : Int32 {
  return 152;
}

function ExampleArrays() -> Void {
  let count: Int32 = 1;
  count = 2;
  var values: array<Int32> = [count, ExampleValue(), 4];
  var fixedValues: Int32[5] = [0, 1, 2, 3, 4];
  return;
}
```

An explicit `Void` function accepts a bare `return`, not a returned value. Array initializers accept expressions/function calls, including for fixed-size arrays. More initializers than a fixed array's capacity is a documented compile error; do not infer unspecified underfilled-array behavior.

Declarations may occur anywhere in a function. The detailed language semantics describe declarations as effectively hoisted: a variable declared in a branch may be visible outside it, even before its declaration. This contradicts the earlier web guide's block-scope wording. Declare and initialize before use, avoid shadowing, and assign on every path reaching a read; availability of a name does not imply that its initializer executed. Do not translate a block-scoped redscript algorithm relying on identical scope/lifetime semantics.

```text
function ExampleCast() -> EInputKey {
  var number: Int32 = 1;
  var boxed: Variant = number as Variant;
  boxed = ((Variant) number);
  let stored: Uint64 = Cast<Uint64>(72);
  let narrowed: Int32 = Cast<Int32>(stored);
  return (EInputKey)narrowed;
}
```

`as` and parenthesized casts are documented, as is `Cast<T>` for numeric conversion. The example illustrates syntax, not enum-range validation or guaranteed overflow/null behavior. Verify conversion semantics for the actual types. Use ordinary `function` declarations and valid identifiers in adapted examples; malformed declaration tokens and names beginning with digits are documentation defects, not additional language features.

Example shaped after the current game signature (full compilation must still be checked):

```text
@module "MyMapMod"

@wrapMethod(WorldMapTooltipController)
function SetData(const data: ref<WorldMapTooltipData>, menu: WorldMapMenuGameController) -> Void {
  SetData(data, menu);
  // Add only the intended post-processing here.
}
```

## Fidelity audit

Map each observable requirement and state/lifecycle path to its implementation. Separate vanilla API calls from Codeware services/reflection/RTTI/dynamic widgets, redscript compiler intrinsics, TweakXL script extensions, ArchiveXL runtime APIs, CET Lua, RED4ext DLLs and Mod Settings. A declaration or installed dependency is not a cross-platform capability guarantee. For each dependency choose a verified official equivalent, a portable redesign with the same behavior, or report a blocker. Keep unsupported features explicit; do not insert fake native declarations to make compilation appear successful.

Preserve ordering, early returns, optional/out/const parameters, reference ownership, null behavior, persistent state, localization and complexity. Inspect collection work hidden in callees and repeated callbacks. Reuse existing game localization keys during pure migration; follow the project's localization policy when changing text/resources.

The compiler enforces an engine-function blacklist for cross-platform scripts. Availability in PC sources does not imply permission on consoles. Dependency management is experimental and not integrated into the game's Update 2.5 mod.io flow; document required utility mods rather than promising automatic dependency installation.
