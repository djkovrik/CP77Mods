# Weapons, photo-mode poses and scene lipsync

Read when entering these resource chains; reviewed 2026-11-02 against the linked guides. Exact schemas and runtime behavior still require target-version validation.

## Weapon and projectile additions

Do not blindly reuse the clothing root-entity recipe for weapons. The weapon guide registers an `.app` directly in the factory, selects appearances using visual tags, and keeps the corresponding mesh entity through `baseEntity` for inventory/photo-mode behavior. Receiver variants can involve another `.app`. Validate one working appearance in FPP, inventory and photo mode before expanding it. [Weapon guide][weapon]

A thrown projectile is a separate factory registration pointing to an `.ent`; trace the item's/attack's `projectileTemplateName`, `useProjectileAppearance` and attack reference through to that entity. The held-weapon appearance working does not prove the projectile exists. [Projectile guide][projectile]

Inspect stale `resolvedDependencies` when original geometry unexpectedly wins; reconcile with the intended dependencies rather than applying a blanket deletion. Export/edit relevant LODs and test hit alignment separately from visible geometry.

## Photo-mode poses and NPVs

Two registrations are required: ArchiveXL loads the animation set onto the intended entity/scope; TweakXL defines the category/pose and appends it to the applicable character pose lists. Animation names must match the `.anims` entries and be mod-specific. Inspect `<ARCHIVEXL_BUNDLE_ROOT>/PhotoModeScope.xl`; local scopes include `photomode_wa.ent`, `photomode_ma.ent` and `photomode_mb.ent`. Scope membership does not automatically append UI pose records. [Pose integration][poses]

The pose article mixes legacy Nibbles-replacer paths with newer scopes and contradictory generator-version notes. The 2.3 update changes character-list names and leaves some entries blank. Resolve lists from the target database; preserve cooperative appends instead of pasting blank assignments. Do not assume an older character list covers the installed patch. [2.3 update][pose-update]

## Scene lipsync

The vanilla-lipsync generator guide requires WolvenKit Nightly 9.0.2-nightly.2026-09-09 or newer; this is a documented minimum, not a claim about the locally installed CLI. It copies existing vanilla NPC facial animation, not custom-audio lipsync. Check voice tags, speaker IDs, facial rigs, installed VO languages and line IDs/names. [Lipsync guide][lipsync]

Generation replaces the scene's lipsync-set list and recalculates actor assignments. Inspect existing custom links first, save the modified scene, verify generated `.anims`/`.lipmap` and language-specific `localization.lipmaps` registration, and inspect logs. Regeneration can leave obsolete files. Validate each intended language and actual actor animation in game. Follow the root localization policy before changing any mod text or localization keys.

[weapon]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/items-equipment/adding-new-items/weapons
[projectile]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/items-equipment/adding-new-items/weapons/throwing-weapons-projectiles
[poses]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/animations/animations/archivexl-adding-photo-mode-poses
[pose-update]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/animations/animations/archivexl-adding-photo-mode-poses/updating-photomode-pose-packs-for-2.3
[lipsync]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/quest/generating-vanilla-lipsync-animation-sets
