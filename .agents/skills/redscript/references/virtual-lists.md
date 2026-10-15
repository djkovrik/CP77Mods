# Virtual Lists

Resolve all path aliases from the root AGENTS.md. The project instructions below are preserved from the original harness.

## Virtual List DataView/DataSource Pattern

When working with `inkVirtualListController`, `inkVirtualGridController`, or other virtual compound controllers, open a nearby vanilla/mod example before writing new list infrastructure.

Core references:

- `<GAME_SOURCES_ROOT>\core\ui\scriptableDataSource.swift` - `ScriptableDataView`, filtering, sorting.
- `<GAME_SOURCES_ROOT>\orphans.swift` - `inkVirtualCompoundController.SetSource(...)`, `SetClassifier(...)`, `ScriptableDataSource.Reset(...)`, `AppendItem(...)`, `RemoveItem(...)`, `GetArray()`, `Size()`, `GetItem(...)`.
- `<GAME_SOURCES_ROOT>\cyberpunk\UI\fullscreen\backpack\backpack_main.swift` - inventory-style setup with `BackpackDataView`, template classifier, and optional position provider.
- `<GAME_SOURCES_ROOT>\cyberpunk\UI\common\virtualNestedListController.swift`, `cyberpunk\UI\fullscreen\quest_log\questLog.swift`, and `cyberpunk\UI\fullscreen\codex\codexVirtualControllers.swift` - nested/grouped list patterns.

Installed examples:

- `RevisedBackpack\RevisedBackpackController.reds` / `RevisedBackpackDataView.reds` - full inventory list with filtering, sorting, selection, visible-row refresh.
- `VirtualCarDealer\autofixer\AutofixerVirtualController.reds` / `AutofixerItemDataView.reds` - simple sorted grid.
- `virtual-atelier-full\virtual-store\VirtualStoreController.reds` / `VirtualStoreDataView.reds` / `VirtualStoreTemplateClassifier.reds` - store grids, search, category filters, custom templates.
- `MetroPocketGuide\widget\TrackedRouteListController.reds` / `TrackedRouteDataView.reds` / `TrackedRouteItemClassifier.reds` - compact list with multiple row templates.

Usual setup:

1. Get the virtual list/grid controller from the ink widget.
2. Create `ref<ScriptableDataSource>`.
3. Create a `ScriptableDataView` subclass when filtering or sorting is needed, then call `dataView.SetSource(dataSource)`.
4. Create an `inkVirtualItemTemplateClassifier` subclass when rows use multiple templates; set it before or near `virtualController.SetSource(dataView)`.
5. Populate `array<ref<IScriptable>>`, call `dataSource.Reset(items)`, then run the view's filter/sort refresh if needed.
6. On detach/uninitialize, call `virtualController.SetSource(null)`, `SetClassifier(null)`, and `dataView.SetSource(null)` before nulling fields.

Responsibility rules:

- `ScriptableDataSource` owns raw items; `ScriptableDataView` owns visible/filter/sort state; the controller owns widgets, events, selection, and conversion into row data.
- Row data should be `IScriptable` wrapper/data classes, not raw structs.
- Template classifiers only map row data to template index via `ClassifyItem(data: Variant) -> Uint32`; convert/downcast defensively and return `0u` as the safe default.
- For inventory-derived lists, prefer extending `BackpackDataView` and overriding its extension points instead of reimplementing category/sort logic.
- Use `DataView.Size()` / `GetItem(index)` for visible filtered order; use `dataSource.GetArray()` when logic must inspect all backing items.
- Keep `ref<>` for DataSource/DataView/classifier ownership and `wref<>` for widget/controller references unless nearby code proves otherwise.
- Treat `inkVirtualCompoundItemController.OnUninitialize()` as part of virtual row recycling, not always final destruction. Do not unregister row self-callbacks such as `OnRelease`, `OnEnter`, `OnLeave`, `OnHold`, or `OnPress` there unless a nearby vanilla virtual item controller does the same and re-register behavior is proven. Removing those callbacks can break clicks/selection when recycled rows receive new data without a fresh `OnInitialize()`.
