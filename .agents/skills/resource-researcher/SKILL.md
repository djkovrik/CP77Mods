---
name: resource-researcher
description: Find Cyberpunk 2077 resources, trace depot paths from TweakDB or scripts, and inspect or selectively extract game and mod archives with local WolvenKit CLI.
---

# Resource Researcher

Resolve aliases from [root AGENTS.md](../../../AGENTS.md), including optional `<GAME_RESOURCES_ROOT>` and `<WOLVENKIT_CLI_ROOT>`. Follow its research destination, localization and external-tool policies. Use [ArchiveXL](../archive-xl/SKILL.md) for resource integration, [TweakXL](../tweak-xl/SKILL.md) for database definitions and [redscript](../redscript/SKILL.md) for script behavior when entering those layers.

## Find and trace

1. Establish starting evidence: depot path, resource hash, record/field, script reference or descriptive term. Read declaring context; record IDs, appearance names, localization keys and depot paths are distinct identifiers.
2. Check optional directories. Use `rg --files` with narrow globs for unpacked filenames, or join a known depot path to `<GAME_RESOURCES_ROOT>`. Search textual definitions with `rg -n -F` in relevant source/mod directories. The unpacked tree may be incomplete or older than installed archives.
3. Follow references as needed: record -> entity -> appearance -> mesh -> material -> texture, or script -> widget library -> atlas -> texture. Record fields and paths supporting each edge. Serialize selected CR2W files to JSON for structural inspection; binary text search is not equivalent.
4. Inspect archives when files are missing, provenance matters or overrides are suspected. Under `<GAME_ROOT>\archive\pc`, `content` is the base game, `ep1` is Phantom Liberty, and `mod` contains installed mods. Enumerate relevant `.archive` files explicitly rather than assuming recursion. Identify each provider when archives contain the same depot path; listing order does not prove runtime precedence.
5. Read [wolvenkit-cli.md](references/wolvenkit-cli.md) before CLI operations. Prefer one archive and one exact path, then a bounded candidate set. Extract into the research folder, separated by source archive. Keep installed archives and the shared unpacked snapshot intact.

## Completion

Save findings and supporting artifacts under `docs\research\<mod-name>`; use `docs\research\resource-researcher` for general tooling research. Record starting references, resolved paths/hashes, source archives or unpacked files, CLI version and commands, inspected properties and unresolved links. Unknown hashes and dynamic paths remain unresolved until supported by evidence; absence in one snapshot is not proof of absence from the game.

Verify output files and contents as well as diagnostics. Separate extraction/serialization from dependency completeness, visual correctness and in-game loading. Apply the project's specification workflow before moving from research to implementation or resource installation.
