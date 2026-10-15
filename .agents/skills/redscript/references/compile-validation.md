# Compile Validation

Resolve all path aliases from the root AGENTS.md. The project instructions below are preserved from the original harness.

`<REDSCRIPT_CLI>` and `<BASE_REDSCRIPTS>` are required only for compile validation. If either path is missing, skip compile validation and report that it was not run.

`<CODEWARE_SCRIPTS_ROOT>`, `<ARCHIVEXL_SCRIPTS_ROOT>`, `<TWEAKXL_SCRIPTS_ROOT>`, and `<MOD_SETTINGS_SCRIPTS_ROOT>` are optional compile context roots. They are not dependencies of every mod. Keep their conventional paths here, but include them in compile `-s` arguments only when the path exists locally.

## Validation

- After edits, review changed `.reds` files for exact signatures, balanced braces, semicolons, and redscript-specific literals.
- Never write compile output to `<BASE_REDSCRIPTS>` / `<GAME_ROOT>\r6\cache\final.redscripts`. This is the original game script bundle used as the compile base; overwriting it can break startup by baking mod classes into the precompiled scripts and causing `SYM_REDEFINITION` errors. All compile validation must write only to `final_patched.redscripts` next to `<REDSCRIPT_CLI>`.
- When compile validation is useful, first check that `<REDSCRIPT_CLI>`, `<BASE_REDSCRIPTS>`, and the target `.reds` file or mod folder exist. If `<REDSCRIPT_CLI>` or `<BASE_REDSCRIPTS>` is missing, skip compile validation and report that it was not run.
- For a single-file mod, compile that `.reds` file as the first `-s`. For a multi-file mod, compile the mod folder as the first `-s`.
- Add optional dependency roots as extra `-s` arguments only when the local path exists: `<CODEWARE_SCRIPTS_ROOT>`, `<ARCHIVEXL_SCRIPTS_ROOT>`, `<TWEAKXL_SCRIPTS_ROOT>`, and `<MOD_SETTINGS_SCRIPTS_ROOT>`. Missing optional roots are not errors.
- Write patched output next to `<REDSCRIPT_CLI>` by deriving the output path from the CLI path. Do not write `final_patched.redscripts` into `<MOD_SCRIPTS_ROOT>`.
- Use this command shape:

```powershell
$redscriptCli = "<REDSCRIPT_CLI>"
$patchedOutput = Join-Path (Split-Path -Parent $redscriptCli) "final_patched.redscripts"

& $redscriptCli compile `
  -s "<target .reds file or mod folder>" `
  -s "<CODEWARE_SCRIPTS_ROOT if it exists>" `
  -s "<ARCHIVEXL_SCRIPTS_ROOT if it exists>" `
  -s "<TWEAKXL_SCRIPTS_ROOT if it exists>" `
  -s "<MOD_SETTINGS_SCRIPTS_ROOT if it exists>" `
  -b "<BASE_REDSCRIPTS>" `
  -o $patchedOutput
```

- Treat `Output successfully saved to ...final_patched.redscripts` as successful compilation; the output path may be absolute.
- Treat `Build failed` as failed compile validation. Fix errors that belong to the current mod scope.
- `WARN` output does not fail compilation. Ignore or briefly mention warnings outside the current mod scope, such as warnings from Codeware, ArchiveXL, TweakXL, or Mod Settings. Consider warnings inside the current mod scope and fix them only when they indicate a real issue or are part of the task.
- If runtime behavior depends on Cyberpunk 2077 launching, say clearly what was checked statically and what still needs in-game verification.
