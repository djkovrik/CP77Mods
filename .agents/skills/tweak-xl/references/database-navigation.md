# Local REDmod TweakDB navigation

Observed on 2026-10-15 under `<TWEAKDB_SOURCES_ROOT>`: 2,684 `.tweak` files. These are original RED-format record sources, not TweakXL YAML and not a live dump of installed mods. Browse here; author changes under `<MOD_TWEAKS_ROOT>` or in a mod's script integration.

## Main roots

- `base\gameplay\static_data\`: base-game records. Sibling files include `items.tweak`, `weapons.tweak`, `attacks.tweak`, `player.tweak`, `photomode.tweak`, `rpg_constants.tweak`, `time.tweak`, `scene.tweak`, `rumble.tweak`, `levelassignmentconfig.tweak`.
- `ep1\gameplay\static_data\database\`: expansion records. Search it as well as base for Phantom Liberty content and relationships.
- Outside `database`, base has `camera`, `input`, `npc`, `player_state_machine`, `vehicles`. These cover camera/input parameters, NPC behavior, state-machine definitions and vehicle systems such as traffic, AI, autopilot, destruction, lights and honking.

## Main database areas

All paths in this table are relative to `base\gameplay\static_data\database\`.

| Area | Where to begin |
| --- | --- |
| Items and equipment | `items\clothing` (face, feet, head, inner_chest, legs, outer_chest); `items\weapons` (ranged, melee, parts, blueprints, base/schema); `attachment_slot`, `equipment_areas` |
| Cyberware | `items\cyberware` (arms, eyes, hands, legs, frontal_cortex, cardiovascular_system, nervous_system, integumentary_system, musculoskeletal_system, immune_system, system_replacement, attunements, variants) |
| Consumables/crafting/economy | `items\consumables`, `items\crafting`, `items\prices`, `items\quality`, `items\ammo`, `items\gadgets`, `items\projectiles`; `vendors`, `loot`, `purchase_offers`, `quest_rewards` |
| Weapon behavior | `items\weapons` for item records; `weapons` for evolutions, FX packages, manufacturers and trigger modes; `attack`, `damage_types`, `weakspots` |
| Characters and NPCs | `characters\bases`, `characters\npcs\records`, `characters\npcs\stats`, `characters\player`, `characters\appearances`, `characters\subcharacters`; `factions`, `attitude`, `bounties` |
| AI and sensing | `ai\actions\library`, `ai\actions\packages`, `ai\archetype_data`, `ai\attack_patterns`, `ai\movement_policy`, `ai\reactions`, `ai\squads`, `ai\threattracking`; `senses`, `stimuli`, `vision_mode`, `targetingsystem` |
| Stats and progression | `stats` and its `stat_groups`, `weapon_stats`; `stat_pool`, `new_perks`, `perks`, `proficiencies`, `progression_builds`, `rpg_data`, `rpg_actions` |
| Conditions and effects | `prereqs` including `vision_mode`; `effectors`, `status_effect` including AI reactions; `gameplay_logic_packages`, `gmpl_abilities`, `object_actions` |
| Vehicles | `vehicles\cars`, `bikes`, `avs`, `archetypes`, `camera_setups`, `surfaces`, `weapons`, `fx`, `open_world`, `main_characters`, `quest`, `special` |
| UI and icons | `ui\icons` including `item_icons.tweak`, `hud_weapons.tweak`, `status_effect_icons.tweak`, `quickhacks_icons.tweak`, `generated`, `perks`, `new_perks`; `ui\items`, `ui\weapons_tooltip`, `ui\stat_maps`; filter icons are in `ui\icons\filters.tweak` |
| Customization and HUD | `ui\character_creation`, `ui\character_customization`, `ui\crosshairs`, `ui\dpad`; `hud`, `photomode`, `mappins`, `ui\mappin_ui`, `ui\world_map` |
| Devices/world/interactions | `devices`, `device_fx`, `device_quest_restrictions`, `interactions`, `network`, `props`, `attachable_objects`, `carriable`, `dynamic_spawn_system`, `sectors`, `environment`, `weather`, `workspots` |
| Narrative and presentation | `readables`, `codex`, `scanning`, `screenmessages`, `quest_system`, `scene_system`, `ui\quest`, `ui\radio`, `global_tv`, `advertisements`, `street_signs`, `fasttravel`, `fast_travel_bink_data` |
| Tests/legacy areas | `functional_tests`, `test_records`, `cpo`, `multiplayer`: existence does not prove active single-player use |

## Observed child directories

This compact inventory preserves actual spellings, including source typos. Use it to narrow searches, not as a list of guaranteed active game features.

### base

- `achievements`
- `advertisements`: `brands`
- `ai`: `actions`, `archetype_data`, `attack_patterns`, `cover_selection`, `debug`, `enums`, `item_conditions`, `lights`, `movement_policy`, `off_mesh_link_tags`, `reactions`, `squads`, `threattracking`, `time_between_hits`
- `aim_assist`
- `arcade_minigames`: `roach_race`, `shooter`, `tank`
- `attachable_objects`
- `attachment_slot`
- `attack`: `melee`
- `attitude`
- `bounties`
- `camera`: `scenes`
- `carriable`
- `characters`: `appearances`, `bases`, `npcs`, `player`, `subcharacters`
- `codex`
- `content_assignment`
- `cpo`: `ai`, `ai_director`, `attacks`, `attitude`, `chatters`, `devices`, `items`, `mappins`, `ping_system`, `progression_builds`, `status_effects`
- `curves`
- `damage_types`
- `device_fx`
- `device_quest_restrictions`
- `devices`
- `dynamic_spawn_system`
- `effectors`
- `environment`: `damage`, `lighting`
- `equipment_areas`
- `facials`
- `factions`
- `fast_travel_bink_data`
- `fasttravel`
- `focus_clues`
- `footsteps`
- `functional_tests`
- `fx_package`
- `gameplay_logic_packages`
- `global_tv`: `news`
- `gmpl_abilities`
- `gog_rewards`
- `hud`: `hudenhancers`
- `interactions`
- `items`: `ammo`, `category`, `check_type`, `clothing`, `consumables`, `crafting`, `cyberware`, `gadgets`, `misc`, `parent_attachment_type`, `prices`, `projectiles`, `quality`, `quest`, `splinters`, `tokens`, `type`, `weapons`
- `lookat_presets`
- `loot`: `ce`, `contextual`, `districts`, `factions`, `generic_loot`, `gym_ccl`, `gym_tech_gmpl`, `gym_ui`, `ma`, `main_quests`, `ms`, `side_quests`, `sts`
- `mappins`
- `materials`
- `minigame`: `enums`
- `minigame_v2`
- `movement_params`
- `multiplayer`
- `network`
- `new_perks`
- `object_actions`
- `perks`
- `personalities`
- `photomode`
- `prereqs`: `vision_mode`
- `prevention_system`
- `proficiencies`
- `progression_builds`
- `props`: `misc`, `quest`
- `purchase_offers`
- `queries`: `clothing`, `cyberware`
- `quest_rewards`
- `quest_system`
- `readables`: `generic`, `main_quests`, `minor_activities`, `minor_quests`, `side_quests`, `street_stories`, `world_stories`
- `rpg_actions`
- `rpg_data`
- `scanning`: `main_quests`, `mini_world_stories`, `minor_activities`, `minor_quests`, `side_quests`, `street_stories`
- `scene_system`
- `screenmessages`
- `sectors`
- `senses`
- `stat_pool`
- `stats`: `stat_groups`, `weapon_stats`
- `status_effect`: `status_effect_ai_reactions`
- `stimuli`
- `street_signs`: `higway_signs`, `metro_stations`, `signs`, `streets_names`
- `targetingsystem`
- `test_records`
- `ui`: `character_creation`, `character_customization`, `choice_caption`, `crosshairs`, `devices`, `dpad`, `elements`, `icons`, `icons_generation`, `internet`, `items`, `loading_screen`, `mappin_ui`, `npc`, `quest`, `radio`, `stat_maps`, `tutorials`, `weapons_tooltip`, `world_map`
- `vehicles`: `archetypes`, `avs`, `bikes`, `camera_setups`, `cars`, `fx`, `main_characters`, `open_world`, `quest`, `special`, `surfaces`, `weapons`
- `vendors`
- `vision_mode`
- `weakspots`: `effectors`
- `weapons`: `evolutions`, `fx_packages`, `manufacturers`, `trigger_modes`
- `weather`
- `workspots`

### ep1

- `advertisements`: `brands`
- `ai`: `actions`
- `attachable_objects`
- `attack`
- `attitude`
- `bounties`
- `characters`: `npcs`
- `content_assignment`
- `devices`: `fx`
- `dynamic_spawn_system`
- `effectors`
- `environment`: `damage`
- `factions`
- `fast_travel_bink_data`
- `fasttravel`
- `interactions`
- `items`: `clothing`, `misc`, `open_world`, `quest`, `weapons`
- `lookat_presets`
- `loot`
- `mappins`
- `minigame_v2`
- `object_actions`
- `progression_builds`
- `props`: `quest`
- `quest_rewards`
- `readables`: `dynamic_events`, `generic`, `main_quests`, `minor_quests`, `sandbox_activities`, `street_strories`, `world_encounters`, `world_stories`
- `scanning`: `main_quests`, `minor_quests`, `sandbox_activities`, `sts`, `world_encounters`, `world_stories`
- `screenmessages`
- `senses`
- `status_effect`
- `street_signs`: `street_names`
- `ui`: `crosshairs`, `devices`, `icons`, `loading_screen`, `mappin_ui`, `quest`
- `vehicles`: `main_characters`, `open_world`, `quest`
- `vendors`
- `weapons`
- `weather`


## Search and follow references

```powershell
rg --files -g '*.tweak' "<TWEAKDB_SOURCES_ROOT>\base\gameplay\static_data\database\items"
rg -n 'Preset_Lexington_Wilson|WilsonWeaponMod' "<TWEAKDB_SOURCES_ROOT>"
rg -n 'prereqClassName|YourRecordName' "<TWEAKDB_SOURCES_ROOT>"
rg -n 'YourRecordName' "<MOD_TWEAKS_ROOT>" "<MOD_SCRIPTS_ROOT>" "<CET_MODS_ROOT>"
```

The local Lexington example is under `base\gameplay\static_data\database\items\weapons\ranged\handguns\lexington\preset_base_lexington.tweak`. Follow its iconic mod into weapon-part definitions and the referenced gameplay logic package rather than copying the whole export. Check `package`, `using` and inherited values when an exact fully qualified name is not found as literal text. To understand runtime behavior, follow `prereqClassName`/effector classes into `<GAME_SOURCES_ROOT>` using the redscript skill.
