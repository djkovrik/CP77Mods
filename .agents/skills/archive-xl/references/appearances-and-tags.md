# Appearances, tags and body refits

Sources: [A02–A08](sources.md). Use this for clothing state selection and legacy conversion.

## Dynamic appearances

Enable `DynamicAppearance` in the root entity's `visualTagsSchema`. The root appearance name identifies the base appearance; the item's `appearanceName` can add `!variant`. Separate composite variant fields with `+` and address them from one-based `{variant.1}`, `{variant.2}` placeholders. The root and `.app` names must agree before the variant portion.

Interpolation requires a leading `*` in the value. A mesh path can select body/gender resources; `meshAppearance` can select a variant. Dynamic resource references require the appropriate `Soft` flag. TweakXL `$(color)` template substitution occurs in YAML; ArchiveXL `{variant}` and state interpolation occur in resources at runtime. They are different mechanisms.

| State | Common substitution values |
| --- | --- |
| `{gender}` | `w`, `m` |
| `{camera}` | `fpp`, `tpp` |
| `{body}` | `base_body` or the registered body tag's normalized value |
| `{arms}` | `base_arms`, `mantis_blades`, `monowire`, `projectile_launcher` |
| `{feet}` | `flat`, `lifted`, `high_heels`, `flat_shoes`; male support depends on the body/feet setup |
| `{sleeves}` | `full`, `part` |
| `{skin_color}`, `{hair_color}` | Character customization names |
| `{hair_type}` | Hair category supported by the installed implementation |

Conditions belong in appearance/component names, for example `&camera=tpp` or `&gender=w`. Prefer selecting an appearance or substituting one component's path over adding many hidden components: inactive components can still be attached to the player. For shared geometry, use resource links.

Selection favors a matching explicit variant with conditions, then variant alone, then state conditions by specificity, then the unconditional entry. Equal-priority matches follow definition order. Test fallback and missing combinations; do not assume a default-looking mesh proves the intended substitution succeeded.

During legacy conversion, preserve useful suffix behavior such as gender-specific preview icons. Convert variant records with TweakXL `$instances` if appropriate, simplify root appearances and `.app` definitions, then replace per-variant overrides with dynamic mesh appearance/path selection. Remove only overrides whose behavior has been replaced. Legacy `appearanceSuffixes` still matter when maintaining an existing mod.

## Visual tags

Tags are case-sensitive. Put them in `.app` `visualTags` or root `.ent` `visualTagsSchema`; a TweakDB gameplay tag is not automatically the same thing.

Vanilla tags include `hide_H1`, `hide_F1`, `hide_T1`, `hide_T2`, `hide_L1`, `hide_S1`, `hide_Hair`, `hide_Genitals` and `hide_T1part`. ArchiveXL adds body-region hiding, `force_Hair`, feet behavior and `AppearanceParts` for parts on non-equipment appearances. Verify the precise slot/body behavior locally. The old GitHub table incorrectly describes `hide_Arms` as hiding the head; the current tags page describes arms including hands.

`EmptyAppearance:FPP` belongs to legacy appearance setup; dynamic appearances can use `&camera=tpp`. Foot tags such as `HighHeels`, `FlatShoes`, `force_FlatFeet` depend on a suitable footwear base and gender/body support. Footstep tags include `Boots`, `Heels`, `Sneakers`, `Stilettos`, `Metal_feet`. Test both supported rigs rather than assuming a tag works universally.

Custom chunk visibility belongs in `.xl`, with unique tag and component names:

```yaml
overrides:
  tags:
    AuthorMod_ShowTrim:
      author_mod_trim: {show: [0, 1]}
    AuthorMod_HideTrim:
      author_mod_trim: {hide: [0, 1]}
```

Attach the chosen tag to the relevant appearance. `partsOverrides` can hide chunks; custom tags can also show them. Match chunk indices to the actual mesh. Body-framework shape-state tags and seam-fix tags are external compatibility contracts: inspect the installed body mod rather than inventing a universal tag.

## Body registration and refits

Current body-authoring approach (ArchiveXL 1.14+): register `player.bodyTypes`, make a minimal patch entity with a component named `Body:<RegisteredName>`, and patch only the appropriate player gender scope. Verify `player_wa.ent`/`player_ma.ent` definitions in the installed bundle. Clothing consumes the resulting `{body}`/`&body=...` value; it does not need to re-register the body.

Always provide a `base_body` case. Vanilla-shaped body mods may deliberately use it. Normalized tag values can have historical exceptions; verify actual registration rather than deriving names from marketing titles.

The archived guide adds a matching tag to a morph component or a `Body:<Name>` component to individual `.app` files. It remains documented for diagnosing old mods, but is superseded by entity patching and its male-file list is explicitly incomplete. Do not use that incomplete list as a new implementation recipe.

For refit issues, inspect body detection, the selected mesh/link, its appearance/materials and its inclusion in patch scopes. Test FPP/TPP, supported body genders, cyberarms, footwear and garment interactions.
