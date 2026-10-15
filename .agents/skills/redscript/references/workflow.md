# Workflow

Resolve all path aliases from the root AGENTS.md. The project instructions below are preserved from the original harness.

## Domain

This project contains Cyberpunk 2077 `.reds` files written in redscript. redscript has Swift-like surface syntax, but it is not Swift. Do not assume Swift rules, standard library APIs, visibility semantics, generics, or type inference behavior unless redscript or the game scripts demonstrate them.

Most scripts here patch or extend the game's existing scripted classes. The primary workflow is:

1. Find the original game class, method, field, enum, or helper in `<GAME_SOURCES_ROOT>`.
2. Match the original signature exactly before wrapping or replacing behavior.
3. Prefer minimal, compatibility-friendly changes in the local `.reds` mod file.
4. Check installed scripts in this directory for existing patches to the same class or method.
5. When a change depends on broader class behavior, read the original class and nearby related scripts before deciding where to patch.

## Reference Sources

Use these local sources before guessing API names or method signatures:

- Game script sources: `<GAME_SOURCES_ROOT>\`
- Codeware script sources: `<CODEWARE_SCRIPTS_ROOT>\`
- ArchiveXL script sources: `<ARCHIVEXL_SCRIPTS_ROOT>\`
- TweakXL script sources: `<TWEAKXL_SCRIPTS_ROOT>\`
- Mod Settings script sources: `<MOD_SETTINGS_SCRIPTS_ROOT>\`
- Existing installed mods: `<MOD_SCRIPTS_ROOT>\`

Use the redscript wiki for language rules and common patterns:

- `https://wiki.redmodding.org/redscript/language/language-features/annotations`
- `https://wiki.redmodding.org/redscript/language/language-features/intrinsics`
- `https://wiki.redmodding.org/redscript/language/language-features/loops`
- `https://wiki.redmodding.org/redscript/language/language-features/strings`
- `https://wiki.redmodding.org/redscript/language/language-features/modules`
- `https://wiki.redmodding.org/redscript/language/language-features/conditional-compilation`
- `https://wiki.redmodding.org/redscript/language/native-types`
- `https://wiki.redmodding.org/redscript/language/built-in-functions/math`
- `https://wiki.redmodding.org/redscript/language/built-in-functions/random`
- `https://wiki.redmodding.org/redscript/language/built-in-functions/utilities`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/safe-downcasting`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/class-constructors`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/hash-maps`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/heterogeneous-array-literals`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/scriptable-systems-singletons`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/delaysystem-and-delaycallback`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/generic-callbacks`
- `https://wiki.redmodding.org/redscript/references-and-examples/common-patterns/persistence`
- `https://wiki.redmodding.org/redscript/references-and-examples/logging`

When an existing script uses one of these language features, first infer intent from nearby local code. When adding, changing, or relying on feature-specific syntax, verify against this quick reference and open the linked wiki page if anything is unclear or not covered here. Local game/mod sources are the authority for game APIs and signatures; the wiki is the authority for redscript language syntax and compiler features.

Use Codeware docs when touching Codeware APIs:

- `https://github.com/psiberx/cp2077-codeware/wiki`

Use TweakXL docs when touching TweakXL APIs:

- `https://github.com/psiberx/cp2077-tweak-xl/wiki/Script-Extensions`

## redscript Patch Rules

- Prefer `@wrapMethod(ClassName)` over `@replaceMethod(ClassName)` whenever both are viable. Wrappers compose better with other mods.
- Use `@replaceMethod` only when the full original method behavior must be replaced. Check for other replacements first, because only one replacement for a method is viable.
- Do not use `@wrapMethod`, `@replaceMethod`, or `@replaceGlobal` on native classes/functions.
- Every `@wrapMethod` must call `wrappedMethod(...)` so the original method and other wrappers in the chain still run. Use the exact original overload arguments.
- Suppress `wrappedMethod(...)` only when intentionally breaking original behavior; make that decision explicit in code/comments because it can break wrapper chains from other mods.
- Match original method names, parameters, return types, static/instance shape, and visibility as closely as redscript requires.
- Use `@addMethod` and `@addField` for extensions to existing classes instead of modifying copied game classes.
- `@addMethod` function names must be unique for the target class across installed `.reds` files. Search existing mods before adding one; duplicate added methods can crash the game.
- Never store the player instance as `ref<PlayerPuppet>` in mod-created classes or fields added with `@addField` to game classes. Use `wref<PlayerPuppet>` for stored player references.
- Keep patches narrowly scoped. Avoid copying large game methods unless a replacement is unavoidable.

## Syntax And Style

- Preserve the style of nearby `.reds` files and the target game's original script.
- Use explicit redscript types when ambiguity could break compilation.
- Remember literal prefixes: `n"..."` for `CName`, `r"..."` for `ResRef`, and `t"..."` for `TweakDBID`.
- Use `ref<T>`, `wref<T>`, arrays, casts, and downcasts according to redscript examples, not Swift habits.
- If a file starts with a `module` declaration, keep new public APIs/imports consistent with that namespace. If no module is present, understand that the file is in global scope.
- Prefer existing game helpers over new utility code when they already solve the problem. Use Codeware/TweakXL helpers only when the mod already depends on them or the change explicitly adds that dependency.

## Debug Logging

- For temporary debug logging in mods that already depend on Codeware or are compiled with Codeware available, prefer `ModLog(n"ModName", "Log string");`. The first argument is a mod-specific log name/channel, not a fixed severity string.
- If Codeware is not available or the mod should not depend on it, use vanilla `FTLog("Log string");` instead.
- Keep debug logs clearly identifiable with a mod-specific prefix, and remove or gate noisy temporary logs before finishing unless the user explicitly wants them kept.

## Search Workflow

Use `rg` first when available:

```powershell
rg "ClassOrMethodName" "<GAME_SOURCES_ROOT>"
rg "ClassOrMethodName" "<MOD_SCRIPTS_ROOT>"
rg "CodewareSymbol" "<CODEWARE_SCRIPTS_ROOT>"
rg "TweakXLSymbol" "<TWEAKXL_SCRIPTS_ROOT>"
```

Original game sources are stored as `.swift` files even though they describe redscript/game declarations. Search them as source references, not as Swift code.
