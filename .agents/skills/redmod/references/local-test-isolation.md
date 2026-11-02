# PC environment isolation for c77 tests

Apply this owner-required local convention when preparing a mod.io mod for in-game testing through `<GAME_ROOT>/r6/c77`, including script-only tests. It extends the existing redscript compiler suspension to RED4ext, CET and global PC archives. Updating this skill alone does not call for changing the installed environment.

## Targets

Paths below are relative to `<GAME_ROOT>`. Rename each existing target in place using the exact backup leaf name; keep the rest of the installation intact.

| Component | Original path | Temporary backup leaf name |
| --- | --- | --- |
| redscript compiler | `engine/tools/scc.exe` | `scc.exe.disabled-redmod-test` |
| redscript compiler library | `engine/tools/scc_lib.dll` | `scc_lib.dll.disabled-redmod-test` |
| RED4ext loader | `bin/x64/winmm.dll` | `winmm.dll.disabled-redmod-test` |
| CET ASI loader | `bin/x64/version.dll` | `version.dll.disabled-redmod-test` |
| Global PC archive directory | `archive/pc/mod` | `mod.disabled-redmod-test` |

The supplied RED4ext 1.31.0 ZIP contains `bin/x64/winmm.dll` and `red4ext/RED4ext.dll`; the CET 1.38.1 ZIP contains `bin/x64/version.dll` and `bin/x64/plugins/cyber_engine_tweaks.asi`. Disable their loader entry points, retaining the framework/plugin binaries, mods, configuration and data for restoration. Disabling `version.dll` also suspends other ASI plugins loaded through that proxy. This table describes these distributions; inspect a different installation's loader arrangement before assuming the same paths disable it.

Keep BOTH compiler targets even with RED4ext disabled: the library can be invoked independently of the EXE. Disabling compilation alone does not prove that previously compiled redscript code is absent. Continue the duplicate-feature and cache checks from [packaging-and-testing.md](packaging-and-testing.md).

Rename only the global `<GAME_ROOT>/archive/pc/mod` folder. Preserve the entire directory, including non-archive sidecar files; do not delete or individually relocate its contents. Leave `<GAME_ROOT>/r6/c77/<ModName>/archive/pc/mod` and other c77 package content active. This isolation also suspends RED4ext plugins such as Codeware, ArchiveXL and TweakXL; evaluate the c77 package against its supported cross-platform content rather than relying on those installed PC extensions.

## Prepare and verify

1. Close the game and confirm `Cyberpunk2077.exe` has exited before changing any target. Resolve all paths, inspect source and backup paths for every row, and check existing test journals before the first rename. Treat unexpected junctions/symlinks as a state to resolve before moving the directory.
2. Save a restoration journal under `docs/research/<mod-name>` with a test/build identifier, original presence/absence, absolute source/backup paths, and SHA-256 for each present file. For the archive directory, record a relative file inventory with sizes and modification times, including hidden files; a same-parent directory rename does not require copying or hashing every archive. Record each successful rename immediately so a partial failure remains recoverable.
3. An absent target with no backup is already absent: record it and preserve that state. An existing backup requires checking its provenance first. Reuse a documented pending isolation session without renaming it again or losing its original restoration obligations; unresolved provenance or simultaneous source/backup paths blocks preparation. Never overwrite a backup or create/download missing framework/compiler files.
4. Rename the applicable targets from the table. Use literal paths and same-parent leaf renames. If a rename or verification fails, stop preparation and restore changes already made for this attempt from the journal; report any remaining conflict.
5. Verify every originally present target is absent at its original path and present at its recorded backup path. Compare file SHA-256 values and the directory inventory with the journal. An originally absent component must remain absent. Only after all applicable targets pass these checks and package checks pass may the environment be called prepared for local testing.

Launch a fresh game process with `-LoadScriptMods` as described in the packaging reference. Correlate runtime evidence with this process and test time. With the loaders disabled, RED4ext/CET/redscript logs normally do not get new startup entries; their silence is not proof of patch loading or framework absence. Inspect loaded modules when available for unexpected `RED4ext.dll`, `cyber_engine_tweaks.asi` or renamed loader images; unexpected loading means isolation is unconfirmed and the actual loader route needs investigation. Check any fresh logs for successful redscript compilation or a redirect to `final.redscripts.modded`. Historical missing-library/CLI-fallback messages from RED4ext-enabled runs are not an expected success signal for this setup.

If preparation hands the test over to the user, retain the disabled state until the test ends, and report the journal location and pending restoration. Record only what was verified: filesystem preparation, observed framework loading, patch loading and in-game behavior are separate outcomes.

## Restore after testing

After the test finishes, fails or is cancelled, close the game and restore every successful rename owned by this test session, including any explicitly resumed pending session. Restore from the journal in reverse rename order. Preparation alone is not the end of a pending manual test.

Before each restoration, verify the recorded backup still matches its file hash or directory inventory and that its original path is free. If an update or another tool has recreated a file or `archive/pc/mod`, preserve both copies and resolve the conflict; do not overwrite, merge or delete either automatically. Restore only recorded changes: a component absent or independently disabled before this session must retain that pre-test state.

After restoration, verify all restored files at their original paths against the recorded SHA-256 values, compare the restored archive directory inventory, and confirm the corresponding backup paths are gone. Mark the journal restored only when every session-owned change is accounted for. Report remaining conflicts with exact paths and leave cleanup incomplete until resolved. Successful restoration here means the recorded filesystem state is restored; framework loading on the next normal launch still requires runtime evidence.
