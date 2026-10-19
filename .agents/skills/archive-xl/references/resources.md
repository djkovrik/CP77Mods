# Resource loading and integration

Sources: [A01–A03](sources.md). The maintainer directs general usage documentation to the REDmodding wiki; use the repository and installed bundle to resolve version-specific details.

## Recognize the files

- `.archive` contains packed game resources; `.xl` or `.archive.xl` is a YAML loader configuration, usually beside the archive in `<ARCHIVE_MOD_ROOT>`. Matching the archive filename is conventional, not required by the reviewed wiki. REDmod packaging alternatively places them in `<GAME_ROOT>\mods\<mod>\archives`.
- Resource references inside configs are depot-relative paths such as `author\mod\appearances\item.app`, not absolute Windows paths. Plain source JSON/CSV is not automatically a cooked CR2W resource merely because its extension matches.
- Factories connect item entity names to resources; localization supplies displayed text. ArchiveXL can also support resource extensions for equipment/weapons, photo-mode content, world sectors and lipsync. For those specialized schemas, consult the actual relevant definition rather than extrapolating clothing examples.

## Follow the chain

For an item, inspect its TweakDB entity/appearance references, factory registration, root `.ent`, `.app` definitions, mesh components, `.mesh` appearances, materials and textures. A missing link can produce an invisible or default-looking item even when YAML parses.

Minimal configuration shape (illustrative depot paths):

```yaml
factories:
  - author\mod\factories\items.csv
localization:
  onscreens:
    en-us: author\mod\localization\en-us.json
```

The factory is a game `C2dArray` resource containing name/path/preload columns; it can register `.ent` or `.app` resources. Create/convert it with the appropriate resource tooling. This configuration registers the resource, not a new TweakDB item record.

Before working on localization text or keys, follow the [project localization policy](../../../../AGENTS.md#localization) to obtain and read the mod's JSON sources.

For new localization, use a unique secondary key. `femaleVariant` provides the default text when a male variant is absent. Editing existing translations uses their primary key. The first configured language is the fallback; order it deliberately and test unsupported-language fallback.

## Validation boundaries

Check indentation, duplicate keys, exact case, registration names, resource existence and all references after renaming. YAML tools must understand or preserve ArchiveXL tags such as `!include`/`!exclude`; ordinary safe-load rejection does not establish an invalid game config. Verify resource paths inside packed output, not only project filenames. Inspect framework logs and test the resulting asset in the game.
