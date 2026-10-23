# Packaging, validation and loading

**Verified 2026-10-23 after the distribution update:** compilation is available again. An isolated module containing `@wrapMethod` (unqualified original call), `@addField`, `@addMethod`, and `GetGameInstanceFromEngine().GetModdingSystem()` passed with exit code 0, zero errors and zero warnings. Fresh `final.redscripts` (2279 bytes) and `final.redscripts.h64` (8 bytes) were generated. This verifies this compile path, not every language feature, runtime loading, persistence or console behavior. [Test source and log](../../../../docs/research/redmod/README.md#successful-compilation-after-update--2026-10-23).

## Select the layout

Legacy REDmod projects use `<GAME_ROOT>/mods/<ModName>/info.json` with a `scripts` tree and are combined by `deploy`. The old practice of mirroring whole game script files belongs to that workflow. Read the installed `deploy -help` for maintenance of a legacy package.

Update 2.5 cross-platform projects use a mod root containing only relevant content:

```text
ModName/
  r6/scripts/*.script
  r6/cache/                 generated binary patches and hash companions
  r6/tweaks/               optional tweaks
  archive/pc/mod/          optional archives and XL/JSON configuration
  Dependencies/           experimental script dependencies, when needed
```

Downloaded examples also contain `about.json` with `ModInfo.ModName` and `ModInfo.ModID`. The updated compiler generated this metadata automatically for the smoke package, using the folder name and ModID -1. Do not invent a server ID; preserve tool-generated metadata. Keep obsolete whole-file scripts and legacy metadata outside the new submission root. Preserve any useful historical copy outside the package.

## Validate locally

Resolve `<REDMOD_EXE>` and `<GAME_ROOT>` from AGENTS.md; pass the mod root, not its scripts subdirectory. Inspect `validate-mod-scripts -help` and `publish -help` when command behavior changes.

PowerShell example, with variables assigned to resolved paths:

```powershell
& $redmodExe validate-mod-scripts -root $gameRoot -compile -directory $modRoot
$compileExit = $LASTEXITCODE
Get-ChildItem -LiteralPath (Join-Path $modRoot 'r6/cache')
```

Use separate option/value arguments. On the 2026-10-22 installation, the documented `-root=<path>` / `-directory=<path>` form was ignored: it printed `No root specified` and a validation success without compiling. Separate arguments invoked compilation correctly. Detect this through output and fresh files, not just exit status.

Compile into the mod's cache, never over `<BASE_REDSCRIPTS>`. Record the exit code before another command changes it, inspect the entire log, and check fresh nonempty `final.redscripts` AND `final.redscripts.h64`. Samples additionally contain `master`, `profiling` and `final_noopts` pairs; those do not replace the required final pair. Failed runs may leave stale files: identify them by timestamps/hashes or use an isolated staging package.

If compilation fails before mod diagnostics, reproduce with a separate minimal module and retain both logs. On 2026-10-22 both RealVendorNames and an otherwise empty `@module "RedmodBaseline"` failed with missing native `ScriptGameInstance.GetModdingSystem`. That historical failure no longer reproduces in the updated smoke test on 2026-10-23. For a future recurrence, preserve sources and report the new failure rather than assuming this old diagnosis still applies. Do not change game/native declarations or substitute redscript CLI success for official validation.

## In-game local testing

Use the following sequence for every local cross-platform script-mod test, including script-only mods. Complete and verify preparation before calling the mod ready for testing.

1. **Build:** compile successfully with `validate-mod-scripts -compile`. Retain the log and exit code; verify fresh nonempty final binary/hash output. A failed build must not be deployed using stale files.
2. **Full package:** copy the complete current mod package into `<GAME_ROOT>/r6/c77/<ModName>/`, including `about.json`, `r6/scripts`, `r6/cache` and any applicable archive/tweak/dependency content. Preserve relative layout. This step is mandatory even when the mod has only scripts; `patch_cache` alone is not the complete local-test setup.
3. **Patch pair:** additionally copy that same build's `r6/cache/final.redscripts` and `final.redscripts.h64` into `<GAME_ROOT>/r6/patch_cache/` as `<ModName>.redscripts` and `<ModName>.redscripts.h64`. Never overwrite the base game cache.
4. **Verify installation:** enumerate the installed package and hash-compare its files with the prepared source package. Hash-compare both patch_cache files with the same build outputs. After every rebuild refresh BOTH installed locations; keep the binary and its hash companion together. Inspect existing files before replacing them and remove only confirmed obsolete files belonging to this mod, so old scripts or binaries do not survive an update.
5. **Avoid duplicates:** inspect active redscript, legacy REDmod and cross-platform copies of this feature. Disable duplicates reversibly within the authorized testing scope and record restoration steps. Do not disable unrelated mods merely because a test fails; record relevant compatibility hooks separately.
6. **Launch:** restart the game with `-LoadScriptMods`. Record the launch route and whether the flag is configured. For Steam/REDlauncher, enabled mods in the launcher do not by themselves prove the argument reached the game. If loading is uncertain, inspect the actual game's command line where available or compare with a direct executable launch using the flag. Never report argument propagation as verified solely from a launcher setting.
7. **Observe behavior:** exercise the mod's actual acceptance scenarios, not just successful startup. Record the tested build, launch conditions, visible result and who verified it. A user's explicit in-game confirmation is runtime evidence; absence of errors or successful compilation is not. Mark untested cases, compatibility and console behavior separately.

For a script-only package the required installed layout is:

```text
<GAME_ROOT>/r6/
  c77/<ModName>/
    about.json
    r6/scripts/<source>.script
    r6/cache/final.redscripts
    r6/cache/final.redscripts.h64
  patch_cache/
    <ModName>.redscripts
    <ModName>.redscripts.h64
```

**Completion states:** “compiled” requires build evidence; “prepared for local testing” requires steps 1–5 plus explicit launch instructions; “works in game” requires an observed result in step 7. Preparing a test does not authorize claiming its runtime outcome. Deployment still follows the user's requested scope.

**No-effect diagnosis:** first verify both installed locations, hashes, duplicates and launch conditions. Correlate logs with the specific test run; older failures from a different mod/framework setup do not establish the cause of the latest run. Establish whether the patch loaded before changing its behavior. If runtime loading cannot be observed, ask for a targeted repeat test and keep the cause unconfirmed.

**Observed case, 2026-10-23:** RealVendorNames compiled and had a valid patch_cache pair but showed no effect while its c77 package was absent. After copying the full package into c77, without changing or recompiling the script, the owner confirmed it worked in game. This supports the complete preparation flow; it is not proof of undocumented engine internals or exhaustive acceptance coverage. See [runtime diagnosis](../../../../docs/research/real-vendor-names/runtime-diagnosis.md).

For rollback, close the game, remove only this mod's c77 package and patch_cache pair, and restore any alternate implementation deliberately disabled for the test. Keep `-LoadScriptMods` if other patches require it. Successful PC testing does not certify cloud cooking or console behavior.

## Preparing and publishing

As verified on 2026-10-23, the updated tool exposes `publish`; the obsolete `publish-cp` returned general usage and exit 0 without preparing a package. Inspect installed help when the distribution changes. Installed help exposes `/mod /prepare -root <game> -directory <mod>` for compiling/compressing a package without uploading. Use a staging copy because preparation may generate files. Check its result before treating an archive as publishable.

### Upload ZIP layout

For a standalone cross-platform mod, package the base folder itself: the ZIP must contain exactly one enclosing `<ModName>/` directory, with `about.json`, `r6/` and other applicable content inside it. Use the parent of the mod folder as the archive-relative base. This is the project's packaging rule following the official documentation; keep it distinct from compiler input (the mod folder itself) and local installation (`r6/c77/<ModName>/`).

```text
RealVendorNames-modio.zip
  RealVendorNames/
    about.json
    r6/scripts/realVendorNames.script
    r6/cache/final.redscripts
    r6/cache/final.redscripts.h64
```

Before delivery, enumerate ZIP entries and verify the single mod-name prefix, with no extra parent directory or duplicate nesting. Read every entry back, check CRC and compare file hashes with the intended package; keep logs and the release manifest outside the ZIP. Packing only the contents of the mod folder would lose the required prefix for this workflow.

Basis: the [creation guide](https://mod.io/g/cyberpunk-2077/r/how-to-create-mods-for-cross-platform-mod-support) shows the project root; the [publishing guide, Step 6](https://mod.io/g/cyberpunk-2077/r/how-to-publish-a-mod-on-modio#heading-9) instructs authors to ZIP the base folder. Its alternative for collections of files in an existing game folder does not establish a flat-ZIP rule for standalone projects. Unpacked downloaded examples also do not establish the layout of a source-upload ZIP. The enclosing-folder rule is a documentation-based interpretation adopted for this project, not proof of cloud acceptance or rejection of other layouts.

RealVendorNames was manually repacked this way after `publish /mod /prepare` crashed with `0xC0000005`; no official generated ZIP or cloud validation was available to verify the interpretation. Preserve that distinction when reporting readiness. For eventual website submission, the guide requires **Cook a source file** to trigger cloud cooking. See the [package review](../../../../docs/research/real-vendor-names/modio-package.md#archive-root-review).

Publishing is a separate external mutation requiring the user's publication instruction. `/mod /create` creates a listing; `/edit` changes it; `/upload` uploads a revision with `-modid`. Verify exact arguments in installed help. `/login`, `/logout`, `/check-account` manage the mod.io account. Do not authenticate or upload just to validate a migration. The tool converts YAML/XL configuration to JSON during upload; verify converted content and the cross-platform subset. Cloud cooking recompiles binary patches; locally generated output is not proof of platform acceptance.
