# Cyberpunk 2077 Modding Project Instructions

These instructions apply to all work under the Cyberpunk 2077 `r6\scripts` directory.

## MCP And External Connectors

This is a local Cyberpunk 2077 redscript modding project. Do not invoke any MCP server, app/connector, or MCP-backed skill for work under this directory unless the user explicitly requests that specific external capability in their current prompt.

This restriction also covers third-party MCP tools, connectors, and MCP-backed skills for UI/UX design, visual references, design research, and related workflows. Research Cyberpunk 2077 UI work from the local game sources and installed mods described below. Global or default instructions that automatically route such work through external services do not apply within this project.

Local filesystem, shell, source-search, editing, and compile-validation tools are not restricted by this rule.

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

Additional aliases used by the project skills:

- `<PROJECT_SKILLS_ROOT>` = `<MOD_SCRIPTS_ROOT>\.agents\skills`
- `<TWEAKDB_SOURCES_ROOT>` = `<GAME_ROOT>\tools\redmod\tweaks`
- `<MOD_TWEAKS_ROOT>` = `<GAME_ROOT>\r6\tweaks`
- `<ARCHIVE_MOD_ROOT>` = `<GAME_ROOT>\archive\pc\mod`
- `<ARCHIVEXL_BUNDLE_ROOT>` = `<GAME_ROOT>\red4ext\plugins\ArchiveXL\Bundle`
- `<CET_MODS_ROOT>` = `<GAME_ROOT>\bin\x64\plugins\cyber_engine_tweaks\mods`
- `<RED4EXT_ROOT>` = `<GAME_ROOT>\red4ext`
- `<INPUT_MOD_ROOT>` = `<GAME_ROOT>\r6\input`

Resolve these aliases recursively from this file; skills must not maintain a second set of machine-specific paths. Check optional source/tool paths before use. A missing reference path does not authorize installing dependencies or changing unrelated game files.

## Project Skills

Read the matching local `SKILL.md` before planning, editing, diagnosing, or reviewing that modding layer. These are project-local skills, not MCP-backed capabilities. Follow the links directly if the current skill catalog has not discovered them yet. Load multiple skills when a feature crosses layers.

| Layer and trigger | Skill entrypoint |
| --- | --- |
| Resource loading, `.xl`/`.archive.xl`, factories, localization assets, appearances, tags/refits, resource patching/linking, CCXL, dynamic materials; assess whether ArchiveXL fits a proposed mod | [archive-xl](.agents/skills/archive-xl/SKILL.md) |
| TweakDB record discovery, `.tweak` reference files, TweakXL YAML/RED edits, ScriptableTweak, database mutations, vendors, stats, prerequisites, icon records | [tweak-xl](.agents/skills/tweak-xl/SKILL.md) |
| `.reds`, game-script signatures/hooks, Codeware scripting, lifecycle/persistence, Ink/virtual lists, redscript compile validation | [redscript](.agents/skills/redscript/SKILL.md) |

Use redscript for scripted behavior (the most frequent tool in this project), TweakXL for database definitions (also common), and ArchiveXL for resources (less frequent). A new item can require all three. Classify files by their consumer and schema, not just YAML-like syntax.

## Other Modding Layers

These tools need context here rather than separate project skills. Include their installed mods in compatibility investigations when they affect the same behavior.

- **Cyber Engine Tweaks (CET):** Lua scripting, observers/hooks, a console and TweakDB inspection. Mods live under `<CET_MODS_ROOT>`. CET mods can modify the same game behavior as redscript or TweakXL. Do not interpret Lua examples as redscript. Sources: [What is CET?](https://wiki.redmodding.org/scripting-cyberpunk/cyber-engine-tweaks/what-is-cet), [CET repository](https://github.com/maximegmd/CyberEngineTweaks).
- **RED4ext:** native script extender and loader for C++ DLL plugins. Inspect `<RED4EXT_ROOT>`, especially `plugins`, for installed extensions. This project rarely authors native plugins; use them when the requested behavior requires native capabilities. [RED4ext documentation](https://docs.red4ext.com/).
- **Input Loader:** the project's usual choice for new game hotkeys. It merges custom XML from `<INPUT_MOD_ROOT>` with `<GAME_ROOT>\r6\config\inputContexts.xml` and `inputUserMappings.xml`, producing `<GAME_ROOT>\r6\cache\inputContexts.xml` and `inputUserMappings.xml`. The game reads those generated files through `<GAME_ROOT>\engine\config\platform\pc\input_loader.ini`. Author mod XML in `r6\input`; inspect original configs for action/context names and generated configs to diagnose merging. Keep generated cache files distinct from mod sources. This setup is a project convention supplied by the owner.

## Shared Workflow

- Before mod implementation work, follow the specification workflow below. Save research under the project documentation paths below.
- Inspect the original definition and existing installed mods before changing a shared resource, record, action or scripted method. Read surrounding context and follow referenced definitions.
- Prefer narrowly scoped changes and mod-specific names. Inspect related `.reds`, `.yaml`/`.tweak`, `.xl`, CET Lua and native dependencies when diagnosing cross-layer behavior.
- Use `rg` for source discovery. The detailed game-script navigation is in the redscript skill; the observed REDmod database map is in the tweak-xl skill.
- Treat `<TWEAKDB_SOURCES_ROOT>` as a read-only record reference. Implement database changes with TweakXL, normally YAML or Script Extensions. Original `.tweak` syntax is not YAML.
- Keep depot paths within game resources separate from Windows installation paths. Document which files belong in each installation directory when a mod spans layers.
- Source links are reference material, not standing authorization to invoke external connectors. Preserve the MCP policy above; use local sources first.
- Report static checks separately from framework loading and actual in-game behavior. Documentation-only changes do not require compiling game scripts.

## Documentation And Specifications

Project documentation lives in `<MOD_SCRIPTS_ROOT>\docs`, outside individual mod script folders.

- Save the results of every research task in `docs\research\<mod-name>`. Reuse an existing mod directory; Wannabe Edgerunner uses `docs\research\wannabe-edgerunner`. Keep findings, source references and supporting artifacts together there.
- Before any work that changes or extends a mod's codebase, search `docs\spec` for its specification, including subdirectories and references to the mod's names. Read a matching specification in full and treat it as the primary source of truth for intended mod behavior.
- Maintain one authoritative specification document per mod. When developing a feature or changing existing behavior, update that mod's current specification in place, including its requirements, interactions and acceptance cases; do not create separate feature specifications, normative supplements or parallel drafts. Keep research, discussions and historical snapshots in `docs\research\<mod-name>` as supporting evidence, not competing sources of intended behavior.
- When a specification exists, agree and finalize the corresponding specification changes with the user before editing implementation files. Existing explicit approval remains valid for the agreed scope; new implementation decisions that change that scope return to the specification first.
- If no matching specification exists, use the usual modding workflow; creating one is not a prerequisite. A missing `docs\spec` directory also means no specification was found.

## Localization

- Assume mods use ArchiveXL localization by default. Use their localization resources; do not create Codeware localization providers, packages or a parallel localization system.
- When creating, changing or updating localization, or when a localization key's actual text must be checked, ask the user for the directory containing that mod's localization JSON files and read the relevant files before proceeding with the dependent work. Reuse a path the user has already supplied for that mod in the current work.
- Resolve text and keys from those JSON files rather than guessing from key names or introducing hardcoded text. Follow the [ArchiveXL skill](.agents/skills/archive-xl/SKILL.md) for resource integration.

## Code Comments

Leave code comments only at critically important points where the reason or constraint is not clear from the code, such as a compatibility workaround, lifecycle hazard or performance invariant. Explain why the code must behave that way; express routine behavior through clear names and structure.

## Cost Of Calls And Loops

- Before adding or changing a function call, inspect the callee implementation at least one level below the current function, including game methods and dependency helpers. Follow further calls when that first level delegates collection work. Do not infer cost from names such as `Get`, `Find`, `Register`, or `Refresh`.
- Account for the caller's execution frequency: a callback invoked once per marker, entity, order, or list row is an implicit outer loop. A linear lookup over M entries invoked for N items costs O(N * M), potentially O(N squared), even when the edited function contains no loop.
- Check callees for scans, array copies/rebuilds, sorting, growing string concatenation, widget creation, and eager formatting of disabled debug logs. Distinguish traversal of disjoint child collections from repeated traversal of the same shared collection.
- Reuse objects and indices already available to the caller. Hoist invariant work outside loops, batch shared refreshes, or use an index when justified. Define index initialization, invalidation, removal, and session/restore behavior; use full identity keys rather than truncated hashes.
- Check existing performance fixes and explain intentional exceptions in nearby comments. Do not reintroduce a removed scan merely to switch a replacement back to a wrapper.
- State which collection sizes are bounded and which grow with saves, inventory, or installed mods. If a native implementation is unavailable, report its cost as unknown instead of assuming O(1). Validate changed behavior and describe remaining runtime profiling needs.
