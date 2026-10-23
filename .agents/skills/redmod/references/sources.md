# Sources and confidence

Reviewed 2026-10-22. All three requested developer articles were read through the browser; the ordinary web fetch could not retrieve them.

- [How-to: Create Mods for Cross-Platform Mod Support](https://mod.io/g/cyberpunk-2077/r/how-to-create-mods-for-cross-platform-mod-support): project diagram, script folder/cache, local loading, binary patches, blacklist, dependencies, syntax and intrinsic table. The linked project-layout image was inspected too.
- [Mod Content available in Cross-Platform Mod Support](https://mod.io/g/cyberpunk-2077/r/mod-content-available-in-cross-platform-mod-support): resource platform boundaries, ArchiveXL subset and TweakXL-like data operations.
- [Submitting Mods with REDmod](https://mod.io/g/cyberpunk-2077/r/submitting-mods-with-redmod): validation, account operations, creation/upload/editing, YAML/XL conversion. Resolve command-name and argument inconsistencies using installed help plus observed output.

Local evidence:

- `<REDMOD_EXE>` general help, `validate-mod-scripts -help`, `publish-cp -help`; `<REDMOD_ROOT>/bin/scc.exe -help` reports official compiler v1.2.2 on this installation.
- Current `<REDMOD_SCRIPTS_ROOT>` definitions and imported native declarations.
- User-provided sample packages Clear Skill Checks, Better Armor Tooltip, Easier Controller Sprint and Quickhack Loadouts: `.script` syntax, module annotation, method/field patches, original-by-name wrapper calls and generated cache pairs. Samples demonstrate usage; shipped binaries do not prove a fresh local compilation succeeds.
- [RealVendorNames migration evidence](../../../../docs/research/real-vendor-names/redmod-migration.md) and [toolchain baseline](../../../../docs/research/redmod/README.md).

Confidence boundaries: wrapper-by-name has multiple sample witnesses; RealVendorNames source was translated and compared statically, and its initial official compilation failed at native binding. The updated toolchain passed an isolated smoke test on 2026-10-23; RealVendorNames subsequently compiled successfully; after full c77 staging alongside patch_cache, the owner confirmed it works in game. Runtime evidence for RealVendorNames is the owner's successful retest after corrected staging; exhaustive acceptance cases, upload and console testing remain unverified.

Scripting guidance expanded 2026-10-23 from user-supplied language documentation. All necessary rules and adapted examples are embedded in this skill: local declaration scope and casts in [scripting-and-migration.md](scripting-and-migration.md), patch semantics in [annotations.md](annotations.md), and modules/configuration in [modules-and-settings.md](modules-and-settings.md). No external attachment is required. Malformed sample declarations were normalized; conditional functions remain explicitly experimental. These additions are documentation evidence, not successful compiler tests. The initial missing-source compilation hold was lifted by the owner after updating the distribution on 2026-10-23.

Updated local evidence: `core/systems/moddingSystem.script` and `GameInstance.GetModdingSystem` are present. The official compiler passed the isolated annotation/game-instance smoke test with fresh binary/hash output; see [the test record](../../../../docs/research/redmod/README.md#successful-compilation-after-update--2026-10-23). Only that test is compiler-verified, not all examples in these references.

