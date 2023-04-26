import VendorPreview.ItemPreviewManager.VirtualAtelierPreviewManager
import VendorPreview.StoresManager.VirtualAtelierStoresSystem
import Codeware.UI.*

@addField(WardrobeSetPreviewGameController) public let m_atelierSystem: wref<VirtualAtelierPreviewManager>;
@addField(WardrobeSetPreviewGameController) public let m_additionalData: ref<PreviewInventoryItemPreviewData>;
@addField(WardrobeSetPreviewGameController) public let m_isLeftMouseDown: Bool;
@addField(WardrobeSetPreviewGameController) public let m_atelierActive: Bool;

@addField(FullscreenVendorGameController) public let m_buyAllPrice: Float;
@addField(FullscreenVendorGameController) public let m_calledForBuyAll: Bool;
@addField(FullscreenVendorGameController) public let m_isPreviewMode: Bool;
@addField(FullscreenVendorGameController) public let m_currentTutorialsFact: Int32;
@addField(FullscreenVendorGameController) public let m_virtualStock: array<ref<VirtualStockItem>>;
@addField(FullscreenVendorGameController) public let m_storesManager: wref<VirtualAtelierStoresSystem>;
@addField(FullscreenVendorGameController) public let m_previewManager: wref<VirtualAtelierPreviewManager>;
@addField(FullscreenVendorGameController) public let m_searchInput: wref<HubTextInput>;

@addField(BackpackMainGameController) public let m_previewItemPopupToken: ref<inkGameNotificationToken>;
@addField(BackpackMainGameController) public let m_isPreviewMode: Bool;

@addField(InventoryTooltipData) public let virtualInventoryItemData: InventoryItemData;
@addField(InventoryTooltipData) public let isVirtualItem: Bool;

@addField(VendorDataView) public let m_isVirtual: Bool;
@addField(VendorDataView) public let m_searchQuery: String;

@addField(VendorPanelData) public let virtualStore: ref<VirtualShop>;
@addField(MinimalItemTooltipData) public let isVirtualItem: Bool;
@addField(gameItemData) public let isVirtualItem: Bool;
