---
name: redscript
description: Develop and review Cyberpunk 2077 redscript mods, game hooks, Codeware integrations, lifecycle and persistence, Ink lists, and safe compile validation.
---


# redscript

Use this for `.reds` behavior and scripting APIs. Resolve path aliases from [root AGENTS.md](../../../AGENTS.md); apply its specification workflow before implementation, research destination, localization policy, critical-comments rule, connector restrictions and cost-of-calls rules. Game reference sources use `.swift` extensions but are not Swift.

## Workflow

1. Read [workflow.md](references/workflow.md) for every scripting change or review. Find the original signature, inspect its implementation and callees, then check installed mods for collisions before choosing a hook.
2. Read [language-and-patterns.md](references/language-and-patterns.md) when writing or changing syntax, references, modules, callbacks, delayed work or saved state. These retain the existing project rules in full.
3. Read [runtime-and-codeware.md](references/runtime-and-codeware.md) for systems/services, player lifecycle, Codeware APIs, persistence, reflection, logging or compiler hints. It supplements the preserved rules with current documentation and known tutorial caveats.
4. Before navigating unfamiliar game code, use [game-sources-navigation.md](references/game-sources-navigation.md). For virtual lists/grids and row lifecycle, read [virtual-lists.md](references/virtual-lists.md) and its local examples before implementing infrastructure.
5. After code edits, follow [compile-validation.md](references/compile-validation.md). Never overwrite `<BASE_REDSCRIPTS>`; use only the prescribed output beside `<REDSCRIPT_CLI>`. Report unavailable validation and remaining in-game checks.

Prefer wrappers that preserve the exact overload and wrapper chain. Store player references as `wref<PlayerPuppet>`. Native API declarations do not make native functions patchable with script wrappers. Verify current APIs in local game/dependency sources, not tutorial snippets alone.

For `ScriptableTweak` and database writes also load [tweak-xl](../tweak-xl/SKILL.md). For `.xl` assets/localization/resource integration also load [archive-xl](../archive-xl/SKILL.md). Do not introduce either dependency merely because it is installed.

[sources.md](references/sources.md) indexes every requested redscript/Codeware source and the topics reviewed. Older wiki URLs retained in the original rules remain useful provenance; use the current equivalents in this index when an old URL no longer resolves.
