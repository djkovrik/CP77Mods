# Modules, conditional functions and persistent configuration

Documentation-derived rules incorporated 2026-10-23; these complete examples have not been compilation/runtime-tested. After the distribution update, a separate smoke test compiled `GetGameInstanceFromEngine().GetModdingSystem()` successfully. The ModdingSystem declaration and five config API declarations are now present in `core/systems/moddingSystem.script`; config persistence, conditional functions and module imports still require their own validation.

## Modules and imports

Place module declarations and imports at the top, before classes/functions:

```text
@module "ExampleMod.Runtime"
@using "ExampleLibrary.Helpers"
```

Modules namespace custom classes/functions and support dependencies. Dotted names are supported. `@using` does not install, bundle or certify compatibility of a dependency; the referenced module must be provided through the target workflow. Do not assume redscript's `module`/`import` visibility rules or cross-mod member-collision handling carry over unchanged.

## Conditional functions and patches — unstable

`@if` can select function versions at runtime based on module presence. This feature is documented as unstable. A minimal complementary pair of new functions:

```text
@if(ModuleExists("ExampleLibrary.Runtime"))
function ExampleModHasLibrary() -> Bool {
  return true;
}

@if(!ModuleExists("ExampleLibrary.Runtime"))
function ExampleModHasLibrary() -> Bool {
  return false;
}
```

At most two versions of a function may be defined, and at most one is loaded. If both conditions match, the first declared version wins. If neither matches, no version loads. A third version exceeds the documented limit.

The documented compound grammar is unusual: conjunction/negation of module-name strings may occur INSIDE `ModuleExists`, with disjunction of tests outside:

```text
@if(ModuleExists("ExampleDep.UI" && "ExampleDep.Widgets") || ModuleExists("ExampleBundled.UI"))
function ExampleModHasUI() -> Bool {
  return true;
}
```

Negated module-name terms such as `"ExampleDep.UI" && !"ExampleConflict.UI"` are described as well. Preserve this as documented experimental syntax; do not silently rewrite it to a guessed generic Boolean grammar. Prefer simple complementary conditions where possible. A single conditional function like the compound example must only be called from a matching conditional context or have a complementary version.

Conditions can be combined with patch annotations:

```text
@if(ModuleExists("ExampleLibrary.Runtime"))
@wrapMethod(ExampleCounter)
function ReadValue() -> Int32 {
  return ReadValue();
}
```

Here `ExampleCounter.ReadValue` denotes an existing target such as the one in [annotations.md](annotations.md); this example illustrates annotation stacking, not a necessary no-op patch. If the condition fails, the patch is absent and the underlying method remains. In contrast, a new function or `@addMethod` may not exist at all. For those, provide an inverse-condition implementation or guard callers with the same condition, otherwise calls can crash or behave unexpectedly. Runtime selection is not proof that missing dependency types are exempt from compile-time resolution.

## Engine game-instance getter

```text
function ExampleModGetGame() -> GameInstance {
  return GetGameInstanceFromEngine();
}
```

This documented global getter obtains a game instance without a player or callback context. Use an already available game/context object when suitable. The getter's presence does not establish service readiness during startup, shutdown or menu transitions; preserve lifecycle checks. Its native cost is unknown.

## Persistent configuration through ModdingSystem

Adding fields to `ModdingSystem` creates disk-backed configuration that persists across saves/reloads. This mechanism is aimed at backend mod settings; it is not evidence of per-save gameplay-state ownership or a drop-in replacement for every redscript `persistent` field.

| Field type | Described UI setting kind |
| --- | --- |
| `Bool` | `BooleanToggle` |
| `Int32` | `IntSlider` |
| `Int64` | `KeybindsToggle` |
| `Float` | `FloatSlider` |
| `String` | `ComboToggle` |

Those are documented mappings, not numeric values for `gameModSettingType` or a complete UI schema. Array/object fields, default registration, slider bounds, combo choices, key encoding, save timing and migration/rename semantics are not specified. Establish those before promising a complete settings UI or porting existing saved state.

```text
@addField(ModdingSystem)
var exampleMod_enabled: Bool;

@addField(ModdingSystem)
var exampleMod_counter: Int32;

function ExampleModIncrementCounter() -> Void {
  var moddingSys: ModdingSystem = GetGameInstanceFromEngine().GetModdingSystem();
  if (moddingSys) {
    if (moddingSys.exampleMod_enabled) {
      moddingSys.exampleMod_counter += 1;
      moddingSys.SaveCurrentConfigsValue();
    }
  }
}
```

This example assumes a live game context and previously configured values; it does not define defaults. It shows a direct field write and an explicit save. Call disk persistence at deliberate commit points, not on every frame/slider tick; exact native I/O cost and automatic persistence timing remain unknown. Do not equate this API with Codeware services or the PC Mod Settings framework.

The system documents these five operations for custom settings UIs (signatures shown for reference; do not redeclare imports in a mod to conceal missing native bindings):

```text
GetAllModsConfigsNames() : array<CName>
GetAllModsConfigsTypes() : array<gameModSettingType>
GetModsConfigValueByName(name: CName) : Variant
SetModsConfigValueByName(name: CName, value: Variant)
SaveCurrentConfigsValue()
```

Names and types enumerate all mods' configuration. Filter to the intended mod, preserve the field's supported type when boxing/unboxing `Variant`, and avoid repeated global enumeration per UI row. The exact relationship/order of the two arrays, missing-name behavior and runtime name qualification are not specified here; verify them before indexing them as parallel arrays or hardcoding configuration names. These functions support discovery/read/write/save; they do not establish automatic widget creation or input binding registration.
