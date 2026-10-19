---
name: archive-xl
description: Inspect and author Cyberpunk 2077 ArchiveXL resource configurations, appearances, tags and refits, resource patches and links, CCXL additions, and dynamic materials.
---


# ArchiveXL

Resolve aliases from [root AGENTS.md](../../../AGENTS.md); apply its specification workflow before implementation, research destination, localization policy, critical-comments rule and external-tool policy. Use this skill to identify ArchiveXL files, evaluate its capabilities for a mod, or change resource integration. ArchiveXL loads and extends resources; TweakXL handles database records and redscript handles scripted behavior.

## Workflow

1. Read [resources.md](references/resources.md) to identify the archive/config/resource chain, install location, factories and localization. Inspect the existing `.xl` and its referenced resources before editing.
2. Pick the relevant branch:
   - Clothing appearances, variants, tags, body refits or legacy conversion: [appearances-and-tags.md](references/appearances-and-tags.md).
   - Patching, scopes, links, dynamic materials or repeated material data: [patching-and-materials.md](references/patching-and-materials.md).
   - Character-creator options, switchers, hair/colors, tattoos, eyebrows, eyes or lashes: [character-creator.md](references/character-creator.md).
3. Check the installed ArchiveXL version and `<ARCHIVEXL_BUNDLE_ROOT>` definitions for version-sensitive features. Read bundled configs as reference; author mod-owned files rather than changing the framework bundle.
4. Trace every depot path and identifier across configuration, `.ent`, `.app`, `.mesh`, material/texture, localization and TweakDB. Search installed mods for collisions. Prefer unique paths and minimal patches over whole-resource replacement.
5. Validate YAML structure with custom tags supported, resource links with available WolvenKit validation, and inspect `<GAME_ROOT>\red4ext\plugins\ArchiveXL\ArchiveXL.log` after a game load. Dynamic paths need explicit runtime checks; a generic YAML parse or successful redscript compile does not validate ArchiveXL behavior.

Report what was inspected statically, what was actually packed/loaded and what remains to test in game. Test affected camera/body/appearance states and interactions with other mods; patching reduces conflicts but cannot guarantee their absence.

Load [tweak-xl](../tweak-xl/SKILL.md) for accompanying item/icon records and [redscript](../redscript/SKILL.md) for script API changes. [sources.md](references/sources.md) records all 24 requested sources, including the archived method and each CCXL tutorial.
