---
name: redmod
description: Author Cyberpunk 2077 REDmod script patches, navigate official game sources, migrate redscript mods, and validate or prepare mod.io cross-platform packages.
---

# REDmod

REDmod is CD PROJEKT RED's official tooling for building, deploying and packaging mods. In this project redscript remains the primary scripting approach; REDmod is the auxiliary target, especially for mod.io. Resolve aliases and follow specification, research, localization and call-cost rules from [AGENTS.md](../../../AGENTS.md). This skill uses local tools; reference URLs do not authorize connectors or publication.

1. Establish the target: legacy REDmod deployment or Update 2.5 cross-platform binary patches. Read [packaging-and-testing.md](references/packaging-and-testing.md) before creating a layout or running tools. These layouts and loading mechanisms differ.
2. For script work read [scripting-and-migration.md](references/scripting-and-migration.md). Search `<REDMOD_SCRIPTS_ROOT>` for the current official definition and inspect its signature, implementation and callees. Use `<GAME_SOURCES_ROOT>` for the community redscript view, not as the REDmod syntax authority.
3. For migration also read the source-side [redscript skill](../redscript/SKILL.md). Inventory each dependency and language feature before translating. Report preserved behavior, adaptations, unsupported features and unknowns. Full fidelity is an outcome to establish, not an assumption; removing functionality needs agreement in the authoritative specification.
4. Prefer annotation patches to whole-file replacements. In a REDmod wrapper call the original by its unqualified method name, e.g. `SetData(data, menu)`, not `wrappedMethod(...)` or `this.SetData(...)`. Preserve signature, call placement and return value.
5. For annotations and patch interaction read [annotations.md](references/annotations.md); for modules, conditional functions, persistent configuration or context-free game access read [modules-and-settings.md](references/modules-and-settings.md).
6. When compilation is available and within the requested scope, validate with the official tool, then distinguish legality validation, completed compilation with fresh output, patch loading, in-game acceptance and cross-platform acceptance. A preliminary success message alone is insufficient. The compilation hold was lifted after the owner confirmed an update on 2026-10-23; an isolated annotation/ModdingSystem smoke test compiled successfully. See the build reference for its exact scope. For in-game tests, follow its mandatory preparation and verification sequence: a full c77 package AND the matching binary/hash pair directly in c77, following the updated guide, including for script-only mods. Report runtime success only after an observed in-game result.

For archives or TweakDB changes read [cross-platform-content.md](references/cross-platform-content.md), then the local ArchiveXL/TweakXL/resource-researcher skills as appropriate. Installed PC frameworks do not establish console support. [sources.md](references/sources.md) records provenance and evidence limits.
