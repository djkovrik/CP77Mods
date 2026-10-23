# Cross-platform content boundary

Snapshot: developer documentation reviewed 2026-10-22, Update 2.5. Recheck the source for publication decisions as support evolves.

- Resource support is type-specific. Mesh/rig/animation data, textures, Ink resources, localization, streaming, quest/scene/journal/behavior data, effects and environment resources have documented cross-platform categories. The article has apparent extension/table typos; resolve exact formats through local resources/tools rather than copying misspellings.
- `.ent`, `.app`, `.morphtarget`, `.particle`, `.phys` and `.physicalscene` are currently PC-only in that guide. An archive accepted on PC is not necessarily console-compatible.
- The ArchiveXL-compatible subset lists Streaming, Journal, Localization, Customizations, Factories, Resource Scope and Resource Link. Resource Patch and Animations are unsupported there. This is configuration compatibility, not a promise of the complete PC ArchiveXL runtime.
- The TweakXL-like subset allows new records/flats, record cloning, flat changes and extra flats. Modified binary TweakDB files are unsupported; adding enums is not yet supported. Do not equate these data operations with the PC TweakXL script-extension API.

Read the local ArchiveXL/TweakXL skills for the relevant schema and resource-researcher for depot paths. Inspect every mod asset and configuration feature against the target platform. Preserve ArchiveXL localization instead of introducing a separate provider; obtain the mod's localization JSON directory when the project policy requires it.
