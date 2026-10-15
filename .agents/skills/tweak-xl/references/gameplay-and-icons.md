# Gameplay records and icon integration

Sources: [T07, T10–T18](sources.md). Resolve exact record IDs from local sources before applying these patterns.

## Vendors

Vendor records reference `itemStock` entries of type `VendorItem`, which in turn reference item and quantity records. Append a new entry or named stock record; do not replace the complete inventory accidentally. `Vendors.Always_Present` is used by the documented example, but confirm the desired quantity/availability rule. Generated stock is cached; the guide uses a 24-hour in-game refresh to test changes. Distinguish an unloaded tweak from stale vendor inventory.

## Stats, abilities, effectors and prerequisites

Trace an item's `statModifiers`, `statModifierGroups`, attachment slots/blueprints, and `OnAttach` gameplay logic packages. Those packages may connect UI data, effectors and prerequisites. A label/icon change alone does not implement the gameplay effect. Check whether a value is additive, multiplicative or a conditional modifier rather than inferring units from its name.

Appending `Quality.IconicItem` is the guide's simple iconic-marking example; custom iconic behavior still requires the actual effects. Attachment slots are defined through item blueprints. Preserve existing modifiers and isolate shared children when only one item should change.

An `IPrereq_Record` stores condition parameters. Its `prereqClassName` identifies a script class deriving from `IScriptablePrereq`; include the module in the runtime name. Some prereqs maintain a `PrereqState` and listeners rather than simply evaluating a one-shot predicate. Read the class lifecycle, initialization and cleanup in game sources before changing or implementing it. `type` on a condition is not the same as YAML `$type`.

## Icons

| Purpose | Record connection |
| --- | --- |
| Inventory preview | Item `icon` inline mapping with `atlasResourcePath` and `atlasPartName`; TweakXL creates the UIIcon and sets `iconPath` |
| Explicit inventory icon | `UIIcon.<Name>` record; item `iconPath` uses the suffix after `UIIcon.` |
| Weapon HUD | `HUDWeaponIcons.<Name>` of UIIcon type; weapon `hudIcon` references the complete record ID |
| Character-creator option | `OptionsIcons` records connected from inkcc definitions; use the ArchiveXL CCXL guide |

An atlas resource path and part name must match a packed `.inkatlas` and its texture slots. TweakXL configures records; WolvenKit/resource tooling prepares `.inkatlas`/`.xbm`, and ArchiveXL handles relevant resource extensions. Never confuse a disk PNG with an installed game texture.

For preview authoring, prepare transparent item PNGs with a consistent camera/lighting and a meaningful variant name. The reviewed guide suggests clothing roughly 130–160 by 76–160, guns 320 by 80–160 and melee 320 by 60–145; use the actual target atlas constraints. WolvenKit's generator creates atlas textures that still must be imported. PNG names must match `atlasPartName`; preserve alpha and suitable UI texture settings. Gendered preview icons have a separate suffix workflow: do not overwrite it with an unconditional inline icon.

Test the intended HUD/inventory/customization surface, variant selection, transparency and missing-resource logs. Avoid turning a specific tutorial's optional photography mods into mandatory dependencies of the delivered mod.
