# Resource patches, scopes, links and materials

Sources: [A09–A12, A23–A24](sources.md). Examples use illustrative paths and require matching packed resources.

## Patch versus link

```yaml
resource:
  patch:
    author\mod\patch.mesh:
      - base\path\target.mesh
  link:
    author\mod\shared.mesh:
      - author\mod\alias.mesh
```

`patch` maps a source patch to targets receiving its data. `link` maps an existing resource to alternative depot paths redirected to it; it is not an OS filesystem symlink. Use links when different substituted paths should share identical geometry. Use patches when adding/changing supported parts of another resource.

Keep patch files at unique custom depot paths outside vanilla `base`/`ep1`, retaining only the intended changes. A stripped patch installed at the vanilla target path becomes a destructive whole-file replacement. For a mesh appearance patch, preserve the target appearance name but give the patch materials unique names and update their references. Remove irrelevant geometry buffers/parameters from the patch rather than carrying unrelated data.

The reviewed patch guide supports mesh appearances (not arbitrary direct material-definition replacement), entity appearances/components/entity/visual tags, and appearance components/partsValues/visual tags. `.app` `partsOverrides` are not patchable by that mechanism. This does not prohibit defining `partsOverrides` inside a mod-owned CCXL `.app`; those are different operations.

## Scopes

Define a uniquely named resource scope once when several patches share target sets:

```yaml
resource:
  scope:
    author_mod_refits.mesh:
      - author\mod\base_body.mesh
      - author\mod\refit.mesh
  patch:
    author\mod\materials.mesh:
      - author_mod_refits.mesh
```

Scopes are append-only: they cannot be overwritten or have members removed. Use `!exclude` on a particular use to filter a resource or another scope. Confirm supported include syntax and built-in scope names from `<ARCHIVEXL_BUNDLE_ROOT>` before editing. Photo-mode scopes are documented from 1.19. The scopes tutorial mixes a TweakXL pose-list example into its explanation; do not paste TweakDB record assignments into `.xl`.

## Dynamic materials

Dynamic materials require ArchiveXL 1.13+. A chunk assignment such as `red@fabric` selects the `@fabric` material template; `{material}` supplies the appearance-dependent prefix. Interpolated paths begin with `*` and use `Soft` flags, including base-material references where required. Keep static properties static.

Appearance expansion reuses a populated chunk list for subsequent empty appearances, replacing the template appearance name. For patch meshes, specify the intended template in the empty appearance's tags. Preserve submesh/chunk order and test every expanded appearance.

`@context` is a parameter container, placed first in material entries with a null base material. It can supply per-mesh `CpuNameU64` parameters used by dynamic materials; unresolved context parameters are ignored so base values can remain. Verify normalization and parameter spelling. Do not assume all context automatically crosses `.mi` boundaries; CCXL hair has additional rules in [character-creator.md](character-creator.md).

For multiple independent material variables, ArchiveXL 1.27+ supports `+`-separated material values addressed by `{material.1}`, `{material.2}`, etc. Build the expected appearance combinations explicitly. These are distinct from the item-level `{variant.1}` fields. Check the installed version before adopting this newer syntax.

Resource patching/linking are documented from 1.14. Treat these minimum versions as feature gates, not a claim about what is currently installed. Validate packed paths, scope membership and framework logs, then inspect the selected materials in game.
