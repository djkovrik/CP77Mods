# Game Sources Navigation

Resolve all path aliases from the root AGENTS.md. The project instructions below are preserved from the original harness.

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
