# TweakDB and TweakXL formats

Sources: [T01–T05, T08–T12](sources.md).

## Database model

TweakDB stores typed records and flats. A flat stores a scalar, supported structure or homogeneous array; a record groups properties. Free flats need not belong to a record. A `TweakDBID` is a hashed key/reference, not arbitrary display text, and runtime IDs do not inherently retain readable names.

Original `.tweak` files under `<TWEAKDB_SOURCES_ROOT>` use RED syntax: packages, `using`, typed groups and inheritance. Follow `package Items` plus a short declaration name to recover its full record name. The local export is a useful complete reference corpus supplied with REDmod; it is not a live dump of currently loaded mods and may lag the installed runtime patch. Check runtime data when version-sensitive details disagree.

## YAML authoring

Place mod `.yaml`/`.yml` under `<MOD_TWEAKS_ROOT>` with optional subdirectories. Existing record properties can use implicit types because the schema determines them. New free flats need unambiguous explicit types. Distinguish `String`, `CName`, localization keys, resource references and `TweakDBID`; similar-looking text is not interchangeable.

| Operation | Shape |
| --- | --- |
| Edit one flat | `Package.Record.property: value` |
| Edit selected properties | `Package.Record:` with only changed fields beneath it |
| Create | New unique name with `$type` |
| Clone | New unique name with `$base` referencing an existing record |
| Nested record | Inline mapping in a record-reference property; use `$type` for polymorphic relationships |
| Repeated definitions | Top-level `$instances` and `$(field)` placeholders |

`$type` accepts base, script or native record type names. `$base` is inheritance, not a promise to isolate referenced child records. Follow shared children before changing them.

Explicit forms include `n"Name"`/`CName("Name")`, `t"Package.Record"`/`TweakDBID("Package.Record")`, `r"path\asset.ext"`/`ResRef(...)`, and `LocKey(...)`/`LocKey#...`. TweakXL's `l"..."` localization form is not redscript syntax. Preserve the exact expected type and handle backslashes according to YAML quoting. `None` has special meaning for empty names/IDs; do not treat it as a universal deletion operator for every schema type.

## Arrays and reuse

An ordinary assigned array replaces its contents. For cooperative edits, prefer the operation that matches intent:

- `!append` / `!prepend`: insert an element.
- `!append-once` / `!prepend-once`: insert only if absent.
- `!append-from` / `!prepend-from`: merge another array's elements, discarding duplicates.
- `!remove`: remove a specified element.

Use a remove-plus-add when replacing a known modifier, after confirming its identity. Arrays are homogeneous. Inline appended records still need the correct type; a fresh generated inline identity is not automatically deduplicated by matching property values. Named records make identity and reuse explicit.

YAML anchors/aliases reuse definitions within the document. `$instances` templates work at top level, not as arbitrary nested template evaluation. Confirm generated record IDs remain unique and all substitutions resolve. ArchiveXL `{variant}`/`{material}` substitutions are a separate resource-time mechanism.

## Inline records and shared effects

Game-generated `_inlineN` names may change between patches. Locate their parent/nested definition and semantics rather than guessing an index. Editing a shared child can affect every parent that refers to it. Prefer a named mod-owned copy with the required fields and replace the target parent's reference while preserving other needed members. Merely assigning a property on a new `_inline0` name does not create a correctly typed isolated record.

## RED-format support

TweakXL also loads `.tweak` files in `<MOD_TWEAKS_ROOT>`, merging definitions rather than applying REDmod's whole-source replacement semantics. It supports packages/imports, typed flats, record inheritance and array `+=`/`-=`. Use this to understand existing RED-format mods; default new work to YAML unless the task or existing mod calls for RED. Do not copy an entire original game file merely because the parser accepts it.
