# Runtime, Codeware and documentation supplements

Read alongside the preserved workflow and language references. Source IDs below resolve in [sources.md](sources.md). This is a decision guide, not a substitute for installed API signatures.

## Setup, names and language details

- `.reds` files are compiled and merged into game scripts; there is no conventional mod `main`. Hooks and scriptable lifecycles provide entrypoints. IDE support and redscript-dap are optional development aids, not runtime dependencies. Keep this project's paths and compile command rather than adopting a tutorial's layout. [R01–R08]
- Fully qualified module names matter to reflection, systems, services and CET. `NameOf<MySystem>()` can resolve a qualified type name when supported by the installed compiler; otherwise use the explicit `n"Module.MySystem"` form. A namespace change requires auditing runtime references. [R15]
- Class-member visibility documents intent even where not enforced by the compiler; module export visibility does affect imports. Keep original visibility/modifiers in patches. `final` and `const` are not invitations to assume Swift semantics. [R20]
- Integer literal suffixes include `u`, `l`, `ul`; `Double` uses `d`. Match the API's exact width and use explicit casts where needed. The types page contains an out-of-range `Int8` example; use the stated range and compiler, not that literal. [R09]
- `ArraySort` accepts primitive arrays, not an arbitrary object comparator. `ArrayGrow` is also available. `FromVariant` requires the expected stored type. Inspect array-copy and scan costs before adding collection operations. [R11]
- Math has distinct integer/float helpers such as `Clamp`/`ClampF`; `LerpF` takes alpha first. String helpers include `StrReplace` versus `StrReplaceAll`, splits, slices and Unicode comparisons. Check the exact overload and return type locally. Random helpers include `RandF`, `RandRangeF`, `RandRange`, `RandDifferent` and `CalcSeed`; the page does not establish all range-bound semantics. [R21–R23]

## Choosing lifetime and persistence

| Owner | Lifetime and storage | Use |
| --- | --- | --- |
| `ScriptableSystem` | Game-session singleton; persistent fields belong to the save | Per-playthrough state and game-session behavior |
| `PersistentState` | Entity-associated saved state | State belonging to a particular entity |
| Codeware `ScriptableService` | Across game sessions; persistent fields are stored globally, outside saves | Process-wide services or explicitly global settings/state |

The original persistence rules remain valid for systems and persistent states. Codeware adds the service option above; do not accidentally move per-save state into global storage. Persist nested fields explicitly. `String`, `Variant`, `ResRef` and arrays of them are excluded. Saving without the mod can remove its system/state data; test reload and migration with appropriate test saves. [R16–R18, R32]

A service's `OnLoad` is for script initialization, not a ready player. `OnInitialize` makes game systems available; session/player readiness is separate. `OnReload` requires checking registration duplication. Release session-owned objects when the session ends; retain player objects only weakly. [R17, R32]

## Player attachment and cleanup

Prefer the explicit `PlayerSystem.RegisterPlayerPuppetAttachedCallback` and `RegisterPlayerPuppetDetachedCallback` pattern for player-instance changes. Store the returned IDs, unregister both on owner detach and reset IDs. Confirm callback signatures and immediate-callback behavior against local sources. The documented `ScriptableSystem.OnPlayerAttach`/`OnPlayerDetach` shortcut can miss detach and V/Johnny transitions. Test new game, load, reload, return to menu and player swaps. [R25]

Keep delayed-work `DelayID` cancellation/reset from the preserved rules. Weak targets and generation checks protect callbacks that can become stale. The generic reflection callback tutorial must be adapted to the actual `DelayCallback.Call` signature; do not copy its return-type variant blindly. [R30–R31]

## Codeware capability map

Use `<CODEWARE_SCRIPTS_ROOT>` as the authority for installed names and signatures; the reviewed wiki identifies itself as version 1.18.0. Browse only the relevant API rather than assuming all latest features are installed. [R32]

| Need | Capability and constraint |
| --- | --- |
| Session/entity/resource/input/widget events | `CallbackSystem`; select narrow targets, explicit run mode/lifetime where needed, and unregister or reset according to the owner lifetime. A service's default registration can survive sessions. |
| Spawn NPCs/vehicles | `DynamicEntitySystem` with a `recordID` for full game behavior; `templatePath` and `recordID` are alternatives. Decide `persistState`, `persistSpawn`, distance behavior and identity lifetime. Temporary IDs must not be reused across loads. |
| Static props | `StaticEntitySystem` offers explicit spawn/attach/detach/despawn without dynamic persistence or distance management. |
| World state | Weather override/reset, nodes/variants, communities and population spawners; scope changes and define restoration behavior. |
| Components and appearance | Enumerate/add components at an appropriate assembly stage. Loading a new mesh/appearance differs from refreshing properties without resource loading. |
| Player variants | Separate gameplay, customization, inventory and photo-mode puppets; choose the correct instance. |
| Ink UI | Layer/controller access, controller overrides when spawning, scripted `inkComponent`, and Codeware UI components. Preserve the project's virtual-row recycling rule. |
| Resources | Resource depot existence checks and asynchronous load tokens; check callback target/resource lifetime before use. Resource reference assignment APIs differ from plain `ResRef` values. |
| Localization | Follow the [project localization policy](../../../../AGENTS.md#localization) and use [ArchiveXL resources](../../archive-xl/references/resources.md). |
| Reflection | Inspect classes/properties/functions, check callable/status and variant types. Callback short names require `cb`; static names include the module/class. |
| Utilities | Hash, bit, vector and identifier conversions; inspect local support rather than inventing names or truncating identity keys. |

The wiki mixes `Entity/Attach` in its event table with `Entity/Attached` in some examples. Verify the installed event definitions before registering. Example snippets are illustrative, not verified project code.

## Logging and user hints

Keep the project's `ModLog(n"ModName", ...)` preference with Codeware and `FTLog` fallback without it. Confirm declarations exist before using logging natives: newer game versions may lack declarations used by old tutorials. Avoid shipping duplicate global native declarations from a copied `Logs.reds`. Gate expensive formatting and stack-trace collection before constructing messages. [R24]

Compiler hints are optional TOML files under `<GAME_ROOT>\r6\config\redsUserHints\<unique-mod-name>.toml`. Match an error code, provide a deduplication `id`, a `message`, and either `span_starts_with` or `line_contains`; scope with `file` when needed. Hints explain missing dependencies; they do not install them or replace compile validation. [R19]

## Reading tutorials critically

The hook tutorial illustrates how to trace a game event but annotates a proposed helper with `@wrapMethod` and dereferences a downcast before its null check. Follow the project's unique `@addMethod` rule for new helpers and check `IsDefined` first. The hash-map example also inconsistently names its local variable. Verify examples rather than reproducing those mistakes. [R07, R28]
