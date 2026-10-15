# CCXL character-creator additions

Sources: [A13–A22](sources.md). The source index links every specialized tutorial; open its exact resource/schema details when implementing that branch. This reference preserves the integration decisions and common failure points without copying the illustrated tutorials.

## Shared structure

`.xl` `customizations.male`/`female` points to `.inkcharcustomization` resources. Their options and groups refer to `.app` definitions, which connect mesh/morphtarget/material resources. Localization and icon records are separate links. Use depot paths and unique mod-specific names throughout; after a WolvenKit rename, inspect dynamic paths and resource-file paths manually because they may not be updated.

| Switcher mechanism | Meaning |
| --- | --- |
| `gameuiSwitcherInfo` | Cycles named options referencing appearance infos |
| `gameuiAppearanceInfo` | Selects appearance definitions; can expose icon/color options |
| `gameuiMorphInfo` | Selects morph names |

`uiSlot` identifies the slot occupied by an option; only one option can be active per slot. `uiSlots` lets a parent select nested slots. `link` and `linkController` coordinate switchers. Match option names to infos and their resource/definition names. Set `editTags` for the intended NewGame/HairDresser/Ripperdoc contexts, and check enabled/hidden/default selection.

For new switchers, choose the head/body/arms customization collection, define at least the intended on/off options, and add names to the appropriate groups. Head groups commonly include `FPP`, `TPP`, `TPP_photomode`, `character_customization`; body groups use `FPP_Body`, `TPP_Body`, `character_creation`. Arms have distinct gender/cyberware groups: consult the theory page rather than copying head groups. An off option with an unnecessary resource path can interfere with HairDresser/Ripperdoc behavior.

Reuse established modded switchers when appropriate. Do not change an existing switcher's index: competing entries at one index can hide each other. The index page documents tattoo groups 3300–3309; verify current installed registrations before choosing new ones.

## Hair and hair colors

- Hair additions use `.app` components directly rather than the clothing mesh-entity chain. Match skinned components to animated components' bind names; non-animated hair can bind to `root`. Multi-mesh hair needs corresponding component overrides and unique component names/IDs.
- A mod-owned hair `.app` can use explicit `partsOverrides` to disambiguate mesh appearances. Keep `partsValues` empty for the documented hair setup. This differs from attempting to resource-patch `partsOverrides`.
- Keep `@context` first, then the expected templates. Context mappings include `@long`/`LongBaseMaterial`, `@cap`/`CapBaseMaterial`, `@short`, `@braid`, `@curls`, `@dread`, `@beard`, `@brows`/`BrowsBaseMaterial` and `@lashes`/`LashesBaseMaterial`. Exact names enable extension mods. `@cap01` can fall back to `CapBaseMaterial`.
- Shared `.mi` ancestors hold non-dynamic texture properties. Keep dynamic `HairProfile` and cap `GradientMap` in the mesh where context is available; use appropriate soft references. Register every added `.app`/mesh in the proper player hair scope. Leave ArchiveXL's bundled fixes untouched.
- When extending a base hair switcher, follow the template's nameless extension/link rules to avoid replacing it. Check default, cyberware and FPP appearances, and localization names to prevent duplicate options.
- Hair-color additions connect `.hp`, cap-gradient `.xbm`, `.mi`, patch appearances, customization definitions, icons and TweakXL `OptionsIcons` records. Give colors globally unique names and keep them identical across these files. Include the color tag for hat-hair compatibility. If reusing one vanilla gradient, avoid adding duplicate vanilla eyebrow-color options.

## Tattoos

An additive tattoo can use a body-derived overlay mesh at a unique custom path. Fit/inflate the overlay to avoid clipping, connect the material and texture, then connect `.app`, customization definition and unique localization key. Never leave the edited body mesh at its original depot path inadvertently. Use the correct gender/body geometry and appropriate customization groups.

## Eyebrows

Each added style needs gender-specific `.app`, `.morphtarget` and `.mesh` resources; textures and `.mi` can be shared. Trace customization option -> appearance -> morph resource -> base mesh -> `@context`/`@brows` -> textures. Match component overrides and resolved dependencies. Include every new style in the switcher/groups and resource scopes. Eyebrow textures may be rectangular; do not enforce a universal square-texture rule.

## Eye textures

Match inkcc definitions, patch mesh appearance names, texture names and `OptionsIcons`/atlas parts. Keep dynamic Albedo paths intact after renaming. The documented eye UV workflow flips albedo vertically; normal maps are vector data and must not simply be flipped/combined like color images. Use correct normal import settings and verify custom roughness settings against the source template. Shared normal maps can use resource links.

Icons commonly use 160x160 with an optional 80x80 preview; match the current template. Black icons suggest broken record/part/path references; white icons can indicate compression settings. Inspect the full chain before blaming the texture. Test customization and gameplay rendering, not only the preview.

## Eyelashes

The reviewed tutorial requires ArchiveXL 1.26.3+, WolvenKit 8.17.1+, its core switcher mod, and Blender tooling. Check those prerequisites before applying it. A missing eyelash switcher is not fixed by editing a mesh alone.

Edit the eyelash morph submesh, export only the intended lash geometry, and import `.mesh` before `.morphtarget`. Use the correct gender's shape keys and armature; do not copy female eye keys onto the male rig directly. Multiple lash submeshes need matching chunk-material entries. Keep alpha textures as alpha data, update component/localization names and manually verify morphtarget paths in `.xl`. For safe removal in the documented workflow, select the vanilla lash option before uninstalling the addition.

## Extensibility and validation

For extensible styles, preserve the shared `.mi`/context layer and one mesh per style where the framework expects it. Packing multiple makeup styles into one mesh can prevent extensions. Validate references with available WolvenKit tools, then check logs and actual NewGame/HairDresser/Ripperdoc, FPP/TPP/photo mode, supported genders and color extensions. Never infer that a placeholder template working proves the renamed final assets work.
