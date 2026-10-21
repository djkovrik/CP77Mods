# WolvenKit CLI

Local help inspected on 2026-10-21: `8.16.2-nightly.2025-08-04`. Resolve `<WOLVENKIT_CLI_ROOT>` from AGENTS.md; executable: `WolvenKit.CLI.exe`. Check `--version` and command `--help` when the installation differs.

## Selective extraction

PowerShell: set `$wk` to the executable, `$archive` to one archive, `$depot` to an evidenced internal backslash-separated path, and `$out` to a fresh research directory for that archive.

```powershell
$exact = '^' + [regex]::Escape($depot) + '$'
& $wk archive $archive --list --regex $exact
# Continue when the listing confirms the intended resource.
New-Item -ItemType Directory -Force -Path $out | Out-Null
& $wk extract $archive --outpath $out --regex $exact
$resource = Join-Path $out $depot
Get-Item -LiteralPath $resource
$jsonOut = Join-Path $out 'json'
New-Item -ItemType Directory -Force -Path $jsonOut | Out-Null
& $wk convert serialize $resource --outpath $jsonOut
Get-ChildItem -LiteralPath $jsonOut -Recurse -File
```

Inspect output size, JSON validity and relevant properties. The local probe observed errors with exit code 0, including `Invalid output directory` and `ConvertToText` with an empty JSON file. Create output directories first; neither an existing output file nor exit status alone proves success. Some payloads are not supported CR2W.

For discovery, `archive $archive --list --pattern '*.inkatlas'` lists a resource family. `--pattern` overrides `--regex`; use only the intended filter. Escape and anchor exact-path regexes. Supply explicit output and a narrow extraction filter: unfiltered extraction can unpack entire archives. Prefer positional inputs over deprecated `--path`. Input folders/lists are accepted; do not assume recursion or overwrite precedence. Separate outputs by source archive.

`extract $archive --outpath $out --hash $hash` advertises single-file hash extraction; help also mentions hash-list file input. These modes were not exercised in the probe. Preserve 64-bit hashes as strings, not floating-point numbers. `hash $depot` computes FNV1A; it neither reverses hashes nor proves existence. Preserve evidenced depot spelling. Unresolved names may appear as numeric `.bin` files.

## Capabilities from installed help

| Need | Command |
| --- | --- |
| Archive contents | `archive` / `archiveinfo`, `--list`, path filters; `--diff` advertises archive JSON for comparison |
| Cooked resources | `extract` / `unbundle`, filters or `--hash`, explicit `--outpath` |
| CR2W fields | `convert serialize` / `s` / `serialise`, `--outpath` or `--print`; `convert deserialize` rebuilds CR2W |
| Extract and export | `uncook` / `extract-and-export` / `unbundle-and-export`, filters, `--outpath`, separate `--raw`, `--uext`, `--serialize`, `--unbundle` |
| Export extracted resources | `export`, `--outpath`, optional `--gamepath`, texture `--uext` |
| Mod archive conflicts | `conflicts $gameRoot --structured`; explicit game root because default is working directory; not a full compatibility/load-order test |
| Path hashes | `hash` computes FNV1A |
| Creation when requested | `import` for raw inputs, `convert deserialize` for JSON, `pack` for resource folders; keep outputs separate from installed archives |
| Specialized conversion | `wwise --wem` advertises WEM-to-OGG; `oodle compress` / `decompress` |

`uncook` offers mesh exporter/type, material repository, LOD, experimental merged export and opus-hash options. Consult current help for enums: this build's mesh description disagrees with its displayed enum. Experimental merged export lacks re-import support. Texture defaults differ: `uncook` uses TGA; `export` uses DDS. Specify the desired format. `--forcebuffers` and `--DEBUG_decompress` are specialized operations, not inspection defaults. Prefer `convert` over deprecated `cr2w`.

Serialization supports CR2W, not arbitrary archive payloads. Export depends on resource type and dependencies. Preserve extracted binaries; JSON/media export does not prove lossless round trips or correct rendering.

Local evidence: `<MOD_SCRIPTS_ROOT>\docs\research\resource-researcher\wolvenkit-cli-investigation.md`. Capabilities above are help-derived unless that report records execution.
