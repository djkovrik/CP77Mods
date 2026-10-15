---
name: tweak-xl
description: Find Cyberpunk 2077 TweakDB records and implement TweakXL YAML, RED-format or script-extension changes, including vendors, stats, prerequisites and icon records.
---


# TweakXL

Resolve aliases from [root AGENTS.md](../../../AGENTS.md); retain its connector and performance rules. TweakXL modifies TweakDB. It does not pack textures or implement arbitrary gameplay code by itself.

## Workflow

1. Use [database-navigation.md](references/database-navigation.md) to locate original `.tweak` definitions in `<TWEAKDB_SOURCES_ROOT>`. Inspect the containing package, imports, inheritance and referenced records, then search installed tweaks/scripts/CET for competing changes.
2. Read [formats-and-records.md](references/formats-and-records.md) before writing records. This project normally authors TweakXL YAML in `<MOD_TWEAKS_ROOT>`; original REDmod `.tweak` files are read-only reference data, not files to edit in place.
3. For vendor stock, stats, prerequisites, HUD or inventory icons, read [gameplay-and-icons.md](references/gameplay-and-icons.md). Follow the entire record/resource chain rather than copying a flat dump.
4. For dynamic changes or `ScriptableTweak`, read [script-extensions-and-validation.md](references/script-extensions-and-validation.md) and load [redscript](../redscript/SKILL.md). Verify installed API signatures under `<TWEAKXL_SCRIPTS_ROOT>` and inspect called helpers before making performance claims.
5. Validate changed types, references, inheritance and custom YAML tags; inspect the TweakXL log after actual loading, then test the affected behavior. A YAML parser or redscript compiler alone cannot prove a database tweak works.

Prefer a minimal property edit or compatible array mutation. Use mod-owned named records when shared or generated inline records would widen the change. Enumerating all records is collection work; avoid doing it per entity/row or on frequent callbacks.

Use [archive-xl](../archive-xl/SKILL.md) for accompanying `.xl`, factories/localization and archive resources. [sources.md](references/sources.md) indexes all 18 requested TweakXL/database/gameplay guides.
