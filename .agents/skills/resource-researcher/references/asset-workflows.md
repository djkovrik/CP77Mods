# Asset workflow findings from the modding guides

Use the branch relevant to the resource under investigation. Reviewed 2026-11-02. These are documentation-derived checks; no asset import, GUI operation or in-game behavior was tested in this review. The complete coverage register is [the wiki review](../../../../docs/research/wiki-guides/review.md).

## Renaming and isolated edits

A resource's depot path is its identity. Moving only a mesh can leave its edited material shared with vanilla/NPCs. Trace and isolate the dependencies actually being changed. WolvenKit's Rename with reference updates is preferable when available, followed by broken-reference validation and manual inspection of dynamic paths and sidecar files. Folder-wide replacement can affect unrelated references. Preserve the consumer's escaping rather than imposing one slash rule on all YAML, JSON and scripts. Check installed leftovers against the known package manifest before removing anything. [Custom paths][paths], [renaming][rename]

## Textures and atlases

Export a suitable existing texture before replacement and preserve raw/cooked path correspondence. Select a preset for the data's role: color/albedo, normal or UI. Confirm alpha, gamma/color space, compression and vertical orientation; normal maps are vector data, so a color-image flip is not a universal normal-map fix. The normal-map guide specifically calls for `isGamma` off. [Texture import][texture], [normal-map diagnosis][normal]

The general texture guide's square/power-of-two instruction is not a universal contract for every resource: existing CCXL eyebrow guidance explicitly allows rectangular textures. Inspect the target template and importer. Masklist images must have consistent dimensions and matching layer entries. A black/white result warrants inspecting settings and references; changing compression globally is not a default remedy.

An icon needs a cooked `.xbm`, an `.inkatlas` texture reference and the correct part rectangle/name. Raw PNG dimensions, tile dimensions and atlas texture dimensions are different constraints. Use [TweakXL icon guidance](../../tweak-xl/references/gameplay-and-icons.md) for record linkage. Menu tutorials rely heavily on screenshots; use actual widget hierarchy or a local inspector instead of inventing property paths from prose.

## Localization resource round trips

An extracted localization `.json` can still be binary CR2W; a serialized `.json.json` is readable tool output. Identify format before parsing. For an authorized text transformation, preserve identity fields, placeholders and markup; deserialize into a separate build tree, serialize back, and compare the intended resource data semantically. A `CR2W` header alone does not prove preservation. Keep onscreen keys distinct from subtitle string IDs and respect the project's requirement to obtain the mod's localization source directory. [Round-trip example][roundtrip]

## Audio discovery and replacement

Distinguish Wwise event identifiers, sound hashes, separate `.wem`, opus packages and localized voice-over variants. Export the selected source rather than assuming all audio is WEM. The opusinfo/opuspak replacement and event-metadata guides warn of shared-file conflicts; choose a compatible REDmod or Audioware approach when its capabilities and target support fit. Native effect playback, adding audio and replacing shared containers are different jobs. [Finding audio][audio], [SFX replacement][sfx], [event metadata][metadata]

## World and scene inspection

World Builder's editor representation must be exported/imported to native resources before judging native behavior. Root groups map to sectors; sector extents gate the nodes' own streaming distances. Keep distant sub-builds separate instead of expanding one sector across them. Inspect node type, stable unique NodeRefs and instance/device data along with resources. [Project structure][world], [export workflow][export]

Scene animation diagnosis follows the actual `resouresReferences` schema: align animation-set and animation-name indices, actor set IDs and event animation names. Actor IDs and performer IDs serve different references. The socket tutorial contradicts itself about a normal quest output; inspect each real node's sockets, not a universal numeric table. [Animation linkage][scene], [scene stub][stub], [socket guide][sockets]

For full vehicle/world/quest authoring, the coverage register points to the specialized guides. This inspection skill does not establish support for authoring every resource type or replace the required local tool/schema investigation.

[paths]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/items-equipment/custompathing-assets
[rename]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/items-equipment/moving-and-renaming-in-existing-projects
[texture]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/textures-and-luts/images-importing-editing-exporting
[normal]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/textures-and-luts/self-made-normal-maps/troubleshooting-normal-maps
[roundtrip]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/everything-else/how-i-uwu-transformed-cyberpunk-2077s-localization
[audio]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/sound/finding-an-audio-file
[sfx]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/sound/replacing-sounds-effects
[metadata]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/sound/audio-modding-basics
[world]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/world-editing/object-spawner/project-structure
[export]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/world-editing/object-spawner/exporting-from-object-spawner
[scene]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/quest/adding-animations
[stub]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/quest/creating-custom-scenes
[sockets]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/quest/name-and-ordinals-sockets-101
