# Cyberpunk 2077 redscript Project Instructions

These instructions apply to all work under the Cyberpunk 2077 `r6\scripts` directory.

## Local Path Aliases

This file uses path aliases so it can be reused on machines with different install locations. When applying these instructions, resolve aliases to the local machine's paths:

- `<GAME_ROOT>` = `C:\Games\steamapps\common\Cyberpunk 2077`
- `<MOD_SCRIPTS_ROOT>` = `<GAME_ROOT>\r6\scripts`
- `<GAME_SOURCES_ROOT>` = `D:\Sources\other\redscript\sources`
- `<REDSCRIPT_CLI>` = `D:\Sources\other\redscript\redscript-cli.exe`
- `<BASE_REDSCRIPTS>` = `<GAME_ROOT>\r6\cache\final.redscripts`
- `<CODEWARE_SCRIPTS_ROOT>` = `<GAME_ROOT>\red4ext\plugins\Codeware\Scripts`
- `<ARCHIVEXL_SCRIPTS_ROOT>` = `<GAME_ROOT>\red4ext\plugins\ArchiveXL\Scripts`
- `<TWEAKXL_SCRIPTS_ROOT>` = `<GAME_ROOT>\red4ext\plugins\TweakXL\Scripts`
- `<MOD_SETTINGS_SCRIPTS_ROOT>` = `<GAME_ROOT>\red4ext\plugins\mod_settings`

If these instructions are copied to another PC, update the values above first. `<MOD_SCRIPTS_ROOT>` is the current Cyberpunk 2077 `r6\scripts` directory that contains installed `.reds` mods and this `AGENTS.md`; `<GAME_SOURCES_ROOT>` is the decompiled/original game script sources directory.

Relative paths such as `RevisedBackpack\RevisedBackpackController.reds` are relative to `<MOD_SCRIPTS_ROOT>` unless another root is stated.

`<REDSCRIPT_CLI>` and `<BASE_REDSCRIPTS>` are required only for compile validation. If either path is missing, skip compile validation and report that it was not run.

`<CODEWARE_SCRIPTS_ROOT>`, `<ARCHIVEXL_SCRIPTS_ROOT>`, `<TWEAKXL_SCRIPTS_ROOT>`, and `<MOD_SETTINGS_SCRIPTS_ROOT>` are optional compile context roots. They are not dependencies of every mod. Keep their conventional paths here, but include them in compile `-s` arguments only when the path exists locally.

## Domain

This project contains Cyberpunk 2077 `.reds` files written in redscript. redscript has Swift-like surface syntax, but it is not Swift. Do not assume Swift rules, standard library APIs, visibility semantics, generics, or type inference behavior unless redscript or the game scripts demonstrate them.

Most scripts here patch or extend the game's existing scripted classes. The primary workflow is:

1. Find the original game class, method, field, enum, or helper in `<GAME_SOURCES_ROOT>`.
2. Match the original signature exactly before wrapping or replacing behavior.
3. Prefer minimal, compatibility-friendly changes in the local `.reds` mod file.
4. Check installed scripts in this directory for existing patches to the same class or method.
5. When a change depends on broader class behavior, read the original class and nearby related scripts before deciding where to patch.

## Reference Sources

Use these local sources before guessing API names or method signatures:

- Game script sources: `<GAME_SOURCES_ROOT>\`
- Codeware script sources: `<CODEWARE_SCRIPTS_ROOT>\`
- ArchiveXL script sources: `<ARCHIVEXL_SCRIPTS_ROOT>\`
- TweakXL script sources: `<TWEAKXL_SCRIPTS_ROOT>\`
- Mod Settings script sources: `<MOD_SETTINGS_SCRIPTS_ROOT>\`
- Existing installed mods: `<MOD_SCRIPTS_ROOT>\`

Use the redscript wiki for language rules and common patterns:

- `https://wiki.redmodding.org/redscript/language/language-features/annotations`
- `https://wiki.redmodding.org/redscript/language/language-features/intrinsics`
- `https://wiki.redmodding.org/redscript/language/language-features/loops`
- `https://wiki.redmodding.org/redscript/language/language-features/strings`
- `https://wiki.redmodding.org/redscript/language/language-features/modules`
- `https://wiki.redmodding.org/redscript/language/language-features/conditional-compilation`
- `https://wiki.redmodding.org/redscript/language/native-types`
- `https://wiki.redmodding.org/redscript/language/built-in-functions/math`
- `https://wiki.redmodding.org/redscript/language/built-in-functions/random`
- `https://wiki.redmodding.org/redscript/language/built-in-functions/utilities`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/safe-downcasting`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/class-constructors`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/hash-maps`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/heterogeneous-array-literals`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/scriptable-systems-singletons`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/delaysystem-and-delaycallback`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/generic-callbacks`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/persistence`
- `https://wiki.redmodding.org/redscript/references-and-examples/logging`

Use Codeware docs when touching Codeware APIs:

- `https://github.com/psiberx/cp2077-codeware/wiki`

Use TweakXL docs when touching TweakXL APIs:

- `https://github.com/psiberx/cp2077-tweak-xl/wiki/Script-Extensions`

## redscript Patch Rules

- Prefer `@wrapMethod(ClassName)` over `@replaceMethod(ClassName)` whenever both are viable. Wrappers compose better with other mods.
- Use `@replaceMethod` only when the full original method behavior must be replaced. Check for other replacements first, because only one replacement for a method is viable.
- Do not use `@wrapMethod`, `@replaceMethod`, or `@replaceGlobal` on native classes/functions.
- Every `@wrapMethod` must call `wrappedMethod(...)` so the original method and other wrappers in the chain still run. Use the exact original overload arguments.
- Suppress `wrappedMethod(...)` only when intentionally breaking original behavior; make that decision explicit in code/comments because it can break wrapper chains from other mods.
- Match original method names, parameters, return types, static/instance shape, and visibility as closely as redscript requires.
- Use `@addMethod` and `@addField` for extensions to existing classes instead of modifying copied game classes.
- `@addMethod` function names must be unique for the target class across installed `.reds` files. Search existing mods before adding one; duplicate added methods can crash the game.
- Never store the player instance as `ref<PlayerPuppet>` in mod-created classes or fields added with `@addField` to game classes. Use `wref<PlayerPuppet>` for stored player references.
- Keep patches narrowly scoped. Avoid copying large game methods unless a replacement is unavoidable.

## Syntax And Style

- Preserve the style of nearby `.reds` files and the target game's original script.
- Use explicit redscript types when ambiguity could break compilation.
- Remember literal prefixes: `n"..."` for `CName`, `r"..."` for `ResRef`, and `t"..."` for `TweakDBID`.
- Use `ref<T>`, `wref<T>`, arrays, casts, and downcasts according to redscript examples, not Swift habits.
- If a file starts with a `module` declaration, keep new public APIs/imports consistent with that namespace. If no module is present, understand that the file is in global scope.
- Prefer existing game helpers over new utility code when they already solve the problem. Use Codeware/TweakXL helpers only when the mod already depends on them or the change explicitly adds that dependency.

## Debug Logging

- For temporary debug logging in mods that already depend on Codeware or are compiled with Codeware available, prefer `ModLog(n"ModName", "Log string");`. The first argument is a mod-specific log name/channel, not a fixed severity string.
- If Codeware is not available or the mod should not depend on it, use vanilla `FTLog("Log string");` instead.
- Keep debug logs clearly identifiable with a mod-specific prefix, and remove or gate noisy temporary logs before finishing unless the user explicitly wants them kept.

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

## Virtual List DataView/DataSource Pattern

When working with `inkVirtualListController`, `inkVirtualGridController`, or other virtual compound controllers, open a nearby vanilla/mod example before writing new list infrastructure.

Core references:

- `<GAME_SOURCES_ROOT>\core\ui\scriptableDataSource.swift` - `ScriptableDataView`, filtering, sorting.
- `<GAME_SOURCES_ROOT>\orphans.swift` - `inkVirtualCompoundController.SetSource(...)`, `SetClassifier(...)`, `ScriptableDataSource.Reset(...)`, `AppendItem(...)`, `RemoveItem(...)`, `GetArray()`, `Size()`, `GetItem(...)`.
- `<GAME_SOURCES_ROOT>\cyberpunk\UI\fullscreen\backpack\backpack_main.swift` - inventory-style setup with `BackpackDataView`, template classifier, and optional position provider.
- `<GAME_SOURCES_ROOT>\cyberpunk\UI\common\virtualNestedListController.swift`, `cyberpunk\UI\fullscreen\quest_log\questLog.swift`, and `cyberpunk\UI\fullscreen\codex\codexVirtualControllers.swift` - nested/grouped list patterns.

Installed examples:

- `RevisedBackpack\RevisedBackpackController.reds` / `RevisedBackpackDataView.reds` - full inventory list with filtering, sorting, selection, visible-row refresh.
- `VirtualCarDealer\autofixer\AutofixerVirtualController.reds` / `AutofixerItemDataView.reds` - simple sorted grid.
- `virtual-atelier-full\virtual-store\VirtualStoreController.reds` / `VirtualStoreDataView.reds` / `VirtualStoreTemplateClassifier.reds` - store grids, search, category filters, custom templates.
- `MetroPocketGuide\widget\TrackedRouteListController.reds` / `TrackedRouteDataView.reds` / `TrackedRouteItemClassifier.reds` - compact list with multiple row templates.

Usual setup:

1. Get the virtual list/grid controller from the ink widget.
2. Create `ref<ScriptableDataSource>`.
3. Create a `ScriptableDataView` subclass when filtering or sorting is needed, then call `dataView.SetSource(dataSource)`.
4. Create an `inkVirtualItemTemplateClassifier` subclass when rows use multiple templates; set it before or near `virtualController.SetSource(dataView)`.
5. Populate `array<ref<IScriptable>>`, call `dataSource.Reset(items)`, then run the view's filter/sort refresh if needed.
6. On detach/uninitialize, call `virtualController.SetSource(null)`, `SetClassifier(null)`, and `dataView.SetSource(null)` before nulling fields.

Responsibility rules:

- `ScriptableDataSource` owns raw items; `ScriptableDataView` owns visible/filter/sort state; the controller owns widgets, events, selection, and conversion into row data.
- Row data should be `IScriptable` wrapper/data classes, not raw structs.
- Template classifiers only map row data to template index via `ClassifyItem(data: Variant) -> Uint32`; convert/downcast defensively and return `0u` as the safe default.
- For inventory-derived lists, prefer extending `BackpackDataView` and overriding its extension points instead of reimplementing category/sort logic.
- Use `DataView.Size()` / `GetItem(index)` for visible filtered order; use `dataSource.GetArray()` when logic must inspect all backing items.
- Keep `ref<>` for DataSource/DataView/classifier ownership and `wref<>` for widget/controller references unless nearby code proves otherwise.

## Search Workflow

Use `rg` first when available:

```powershell
rg "ClassOrMethodName" "<GAME_SOURCES_ROOT>"
rg "ClassOrMethodName" "<MOD_SCRIPTS_ROOT>"
rg "CodewareSymbol" "<CODEWARE_SCRIPTS_ROOT>"
rg "TweakXLSymbol" "<TWEAKXL_SCRIPTS_ROOT>"
```

Original game sources are stored as `.swift` files even though they describe redscript/game declarations. Search them as source references, not as Swift code.

## Original Game Sources Navigation

Top-level source map for `<GAME_SOURCES_ROOT>`:

- `core\` - engine-level and reusable game primitives: entities, components, blackboards, events, gameplay prereqs/effectors, math/data helpers, systems, UI base controllers/widgets.
- `cyberpunk\` - Cyberpunk-specific gameplay scripts: player/NPC/puppet logic, items, damage, devices, UI screens, vehicles, systems, AI, quests, projectiles.
- `samples\` - sample devices, projectiles, persistence, vision mode, and Ink/UI examples. Use for patterns, not as authoritative gameplay behavior.
- `tests\` - test and functional-test scripts. Useful for edge examples only.
- `exec\` - small debug/exec helpers for damage/stats/stat pools.
- `orphans.swift` - large fallback file with enums, native/base classes, event/request types, and declarations that are not split into domain folders.

Use this folder guide before broad searches:

- `core\data` - `TweakDBID`, TweakDB, stats/string data primitives.
- `core\entity` - `Entity`, `GameObject`, entity IDs and base object behavior.
- `core\components` - common components, script components, lights, workspots, scanning/interaction-capable component bases.
- `core\events` - shared game events such as attachments, look-at, puppet, stimuli, IK target events.
- `core\gameplay\prereqs` - prerequisite checks for facts, stats, time, items, districts, status, and conditions.
- `core\gameplay\effectors` - effectors that apply items, status effects, quickhacks, shaders, stat changes, rewards, etc.
- `core\gameplay\conditions` - generic gameplay condition containers and checks.
- `core\systems` - base systems such as audio, blackboard, delay, stats, targeting, transaction, time, telemetry, plus `hud`, `prevention`, and `vision` subareas.
- `core\ui` - base Ink controllers, widgets, list/combo controllers, animation/interpolator helpers, video/input UI bases.
- `core\ai` - shared AI commands, actions, behavior delegates, covers, squads, expressions.
- `core\math` - arrays, vectors, colors, transforms, rotations, boxes, angles.
- `cyberpunk\player` - player puppet, combat controller, events, covers, disarm, state-machine (`psm`) logic.
- `cyberpunk\NPC` and `cyberpunk\puppet` - NPC/scripted puppet classes, puppet actions, puppet persistent state, hit reactions, components.
- `cyberpunk\ai` - Cyberpunk-specific AI commands, tasks, roles, conditions, delegates.
- `cyberpunk\items` - item base behavior, item actions, cyberware, consumables, melee/combat gadgets.
- `cyberpunk\damage` - attack data, damage system, hit processing, damage helpers.
- `cyberpunk\projectiles` - bullets, projectile launcher, melee/explosive/special projectile behavior.
- `cyberpunk\devices` - interactive world devices and controllers. Important subfolders include `core`, `masters`, `door`, `cameras`, `security`, `securityTurret`, `fastTravel`, `stash`, `skillChecks`, `traffic`, `vehicles`, `homeAppliances`, `vendingMachines`, and device `UI`.
- `cyberpunk\UI\common` - reusable UI helpers/controllers: animation helpers, button hints, generic buttons/messages, item/inventory display utilities, localization helpers, progress bars, tooltip animation, UI scriptable systems, widget state mapping.
- `cyberpunk\UI\menus` - generic menu controllers and menu item list controllers; also includes older inventory data/stat menu helpers.
- `cyberpunk\UI\fullscreen` - major fullscreen screens. Key subfolders: `backpack`, `crafting`, `vendor`, `ripperdoc`, `perks`, `stats`, `hub`, `map`, `quest_log`, `codex`, `notification`, `phone_sms`, `photoMode`, `pregame`, `settings`, `wardrobeDevice`, `fastTravel`, `loading_screen`, `time_management`.
- `cyberpunk\UI\fullscreen\backpack` - backpack main screen, equipment slot chooser popup, item filters, crafting material item controller, dropdown controllers.
- `cyberpunk\UI\fullscreen\crafting` - crafting main screen, item template classification, panel/popup/logic/skill controllers.
- `cyberpunk\UI\fullscreen\vendor` - fullscreen vendor controller, vendor hub/scenario, item filters, quantity picker, confirmation popup.
- `cyberpunk\UI\fullscreen\ripperdoc` - ripperdoc screen, cyberware minigrid, armor meters, money label, pulse/animation controllers.
- `cyberpunk\UI\fullscreen\perks`, `stats`, `hub`, `map`, `quest_log`, `codex` - progression screens, hub menu, world map/fast travel scenarios, quest log, codex/shard views.
- `cyberpunk\UI\inventory` - inventory data model and item views: `inventoryDataManagerV2`, item data/stats/requirements, item display controllers, item lists/managers, equipment/weapon slots, weapon/cyberware item choosers, filters, transmog/wardrobe buttons, UI inventory/item helpers.
- `cyberpunk\UI\tooltips` - tooltip data/providers/controllers for inventory, items, weapons, cyberware, cyberdeck/programs, materials, messages, randomized stats, tooltip manager and visual tooltip controller.
- `cyberpunk\UI\hud` - HUD-specific controllers. Subfolders cover custom HUDs, scanner UI, phone and phone dialer, vehicle radio/manager popups, cyberware breach, point-of-no-return rewards.
- `cyberpunk\UI\Player` - player stat HUD bars and lists: health, stamina, oxygen, net charges, buffs.
- `cyberpunk\UI\widgets` - reusable in-game widgets: minimap, notifications, quickhacks, health/nameplates, d-pad/input hints, wanted bar, timer, damage/stealth indicators, braindance, autodrive, car modding, CPO widgets.
- `cyberpunk\UI\weapons` - weapon HUD: weapon roster, weapon indicator, crouch indicator, crosshair container/base/specialized controllers under `weapons\crosshairs`.
- `cyberpunk\UI\mappins` - map/minimap marker UI: gameplay, interaction, quest, stealth, quickhack, ping, remote player, mappin containers/controllers/profiles/utils.
- `cyberpunk\UI\quests`, `radialWheel`, `miniGames`, `vehicles`, `interactions`, `subtitles`, `popups`, `damageDigits`, `cyberware` - smaller domain-specific UI controllers for those systems.
- `cyberpunk\systems` - Cyberpunk-specific scriptable systems such as equipment, first equip, data tracking, environment damage, autocraft, and market system.
- `cyberpunk\managers` - managers for bounty, cooldowns, NPCs, quick slots, RPG/gameplay helpers.
- `cyberpunk\vehicles` - metro/tank/vehicle-specific scripts; also check `cyberpunk\devices\vehicles` and `cyberpunk\UI\vehicles` for actions and HUD.
- `cyberpunk\network` - door/personnel/security network systems and controllers.
- `cyberpunk\interactions` and `cyberpunk\triggers` - scripted interaction conditions and world triggers.
- `cyberpunk\quest` - quest AI command categories and quest conditions; broader quest primitives may be in `core\quest` and `orphans.swift`.
- `cyberpunk\strike`, `takedown`, `timeDilation`, `randomization`, `activityCardsManager`, `photomode` - specialized gameplay helpers for those features.
- `cyberpunk\global` - global enums, functions, structs, localization helpers, and shared definitions.

When modifying an existing `.reds` file, inspect surrounding code before editing. When adding a new `.reds` file, choose a clear mod-specific filename and avoid collisions with installed mods.

## Validation

- After edits, review changed `.reds` files for exact signatures, balanced braces, semicolons, and redscript-specific literals.
- Never write compile output to `<BASE_REDSCRIPTS>` / `<GAME_ROOT>\r6\cache\final.redscripts`. This is the original game script bundle used as the compile base; overwriting it can break startup by baking mod classes into the precompiled scripts and causing `SYM_REDEFINITION` errors. All compile validation must write only to `final_patched.redscripts` next to `<REDSCRIPT_CLI>`.
- When compile validation is useful, first check that `<REDSCRIPT_CLI>`, `<BASE_REDSCRIPTS>`, and the target `.reds` file or mod folder exist. If `<REDSCRIPT_CLI>` or `<BASE_REDSCRIPTS>` is missing, skip compile validation and report that it was not run.
- For a single-file mod, compile that `.reds` file as the first `-s`. For a multi-file mod, compile the mod folder as the first `-s`.
- Add optional dependency roots as extra `-s` arguments only when the local path exists: `<CODEWARE_SCRIPTS_ROOT>`, `<ARCHIVEXL_SCRIPTS_ROOT>`, `<TWEAKXL_SCRIPTS_ROOT>`, and `<MOD_SETTINGS_SCRIPTS_ROOT>`. Missing optional roots are not errors.
- Write patched output next to `<REDSCRIPT_CLI>` by deriving the output path from the CLI path. Do not write `final_patched.redscripts` into `<MOD_SCRIPTS_ROOT>`.
- Use this command shape:

```powershell
$redscriptCli = "<REDSCRIPT_CLI>"
$patchedOutput = Join-Path (Split-Path -Parent $redscriptCli) "final_patched.redscripts"

& $redscriptCli compile `
  -s "<target .reds file or mod folder>" `
  -s "<CODEWARE_SCRIPTS_ROOT if it exists>" `
  -s "<ARCHIVEXL_SCRIPTS_ROOT if it exists>" `
  -s "<TWEAKXL_SCRIPTS_ROOT if it exists>" `
  -s "<MOD_SETTINGS_SCRIPTS_ROOT if it exists>" `
  -b "<BASE_REDSCRIPTS>" `
  -o $patchedOutput
```

- Treat `Output successfully saved to ...final_patched.redscripts` as successful compilation; the output path may be absolute.
- Treat `Build failed` as failed compile validation. Fix errors that belong to the current mod scope.
- `WARN` output does not fail compilation. Ignore or briefly mention warnings outside the current mod scope, such as warnings from Codeware, ArchiveXL, TweakXL, or Mod Settings. Consider warnings inside the current mod scope and fix them only when they indicate a real issue or are part of the task.
- If runtime behavior depends on Cyberpunk 2077 launching, say clearly what was checked statically and what still needs in-game verification.
