import VendorPreview.ItemPreviewManager.VirtualAtelierPreviewManager
import VendorPreview.StoresManager.VirtualAtelierStoresSystem
import Codeware.UI.*
import VendorPreview.UI.*

@addField(WebPage) public let owner: wref<GameObject>;
@addField(WebPage) public let system: wref<VirtualAtelierStoresSystem>;
@addField(WebPage) public let stores: array<ref<VirtualShop>>;
@addField(WebPage) public let atelierPages: ref<inkCompoundWidget>;
@addField(WebPage) public let atelierTotalStores: Int32;
@addField(WebPage) public let atelierCurrentPageIndex: Int32;
@addField(WebPage) public let atelierTotalPages: Int32;
@addField(WebPage) public let navigationButtonPrev: ref<AtelierTextButton>;
@addField(WebPage) public let navigationButtonNext: ref<AtelierTextButton>;
@addField(WebPage) public let navigationLabel: ref<AtelierTextButton>;
@addField(WebPage) public let rootAtelierPanel: ref<inkVerticalPanel>;

@addField(WardrobeSetPreviewGameController) public let m_atelierSystem: wref<VirtualAtelierPreviewManager>;
@addField(WardrobeSetPreviewGameController) public let m_additionalData: ref<PreviewInventoryItemPreviewData>;
@addField(WardrobeSetPreviewGameController) public let m_isLeftMouseDown: Bool;
@addField(WardrobeSetPreviewGameController) public let m_atelierActive: Bool;

@addField(FullscreenVendorGameController) public let m_isPreviewMode: Bool;
@addField(FullscreenVendorGameController) public let m_currentTutorialsFact: Int32;
@addField(FullscreenVendorGameController) public let m_virtualStock: array<ref<VirtualStockItem>>;
@addField(FullscreenVendorGameController) public let m_storesManager: wref<VirtualAtelierStoresSystem>;
@addField(FullscreenVendorGameController) public let m_previewManager: wref<VirtualAtelierPreviewManager>;
@addField(FullscreenVendorGameController) public let m_searchInput: ref<HubTextInput>;

@addField(BackpackMainGameController) public let m_previewItemPopupToken: ref<inkGameNotificationToken>;
@addField(BackpackMainGameController) public let m_isPreviewMode: Bool;

@addField(InventoryTooltipData) public let virtualInventoryItemData: InventoryItemData;
@addField(InventoryTooltipData) public let isVirtualItem: Bool;

@addField(VendorDataView) public let m_isVirtual: Bool;
@addField(VendorDataView) public let m_searchQuery: String;

@addField(VendorPanelData) public let virtualStore: ref<VirtualShop>;
@addField(MinimalItemTooltipData) public let isVirtualItem: Bool;
@addField(gameItemData) public let isVirtualItem: Bool;
