# Script extensions and validation

Sources: [T05–T07](sources.md). Load the redscript skill before changing `.reds` files.

## Lifecycle and writes

`ScriptableTweak` subclasses receive `protected cb func OnApply() -> Void` just after TweakDB initialization. `GameInstance` and game systems are not ready then. Keep player, UI and session work in an appropriate later lifecycle, not in `OnApply`.

`TweakDBInterface` extensions include generic flat/record access and record enumeration, counts, IDs and indexed access. Verify the installed overloads under `<TWEAKXL_SCRIPTS_ROOT>`. `GetRecords` returns collections; batch broad transformations once and avoid rescanning them in a per-record callback. If the implementation is native and unavailable, its complexity is unknown.

`TweakDBManager` supports `SetFlat`, `CreateRecord`, `CloneRecord`, `UpdateRecord`. After changing record properties with `SetFlat`, call `UpdateRecord` for that record to propagate them to existing record instances. Check Boolean results where failure affects subsequent work. Batch a record's property changes before updating it. New `CName`-based create/clone/set overloads can register readable names for CET; `TweakDBID`-only creation may leave hash-only display names.

Do not assume reapplying a script is harmless: account for repeated record creation, appended data and state changes. Establish idempotency or an explicit supported reload procedure. Runtime record changes may not rebuild already-spawned objects or cached inventories.

## Tools and checks

The documented CET console helpers are `TweakXL.Reload()` (file tweaks and scriptable tweaks), `TweakXL.ExecuteAll()`, `TweakXL.Execute("ClassName")` and `TweakXL.Version()`. These are Lua/console calls, not redscript syntax, and are development tools rather than a requirement to add CET to a mod. Use them only in an authorized runtime session and verify availability.

Inspect `<GAME_ROOT>\red4ext\plugins\TweakXL\TweakXL.log`. Static checks should cover duplicate YAML keys, indentation, custom tags, exact field types, foreign-key targets, generated names, array replacement versus mutation, and shared-child effects. A generic YAML loader needs custom-tag support; successful parsing does not establish TweakDB schema correctness.

For Script Extensions, also run the project's safe redscript compile validation when available. Verify actual loaded values, reload behavior and the gameplay result separately. For vendor changes account for stock refresh; for item stats compare the relevant equipped/spawned item; for icons verify the correct UI surface and asset chain.
