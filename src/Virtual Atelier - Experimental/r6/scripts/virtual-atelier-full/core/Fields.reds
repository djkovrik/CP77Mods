import VirtualAtelier.Systems.VirtualAtelierPreviewManager
import VirtualAtelier.Config.VirtualAtelierConfig
import Codeware.UI.*

@addField(WardrobeSetPreviewGameController) public let previewManager: wref<VirtualAtelierPreviewManager>;
@addField(WardrobeSetPreviewGameController) public let additionalData: ref<PreviewInventoryItemPreviewData>;
@addField(WardrobeSetPreviewGameController) public let isLeftMouseDown: Bool;
@addField(WardrobeSetPreviewGameController) public let atelierActive: Bool;

@addField(FullscreenVendorGameController) public let isPreviewMode: Bool;
@addField(FullscreenVendorGameController) public let previewManager: wref<VirtualAtelierPreviewManager>;

@addField(BackpackMainGameController) public let previewItemPopupToken: ref<inkGameNotificationToken>;
@addField(BackpackMainGameController) public let isPreviewMode: Bool;

@addField(InventoryTooltipData) public let virtualInventoryItemData: InventoryItemData;
@addField(InventoryTooltipData) public let isVirtualItem: Bool;

@addField(VendorDataView) public let isVirtual: Bool;
@addField(VendorDataView) public let searchQuery: String;

@addField(VendorPanelData) public let virtualStore: ref<VirtualShop>;
@addField(MinimalItemTooltipData) public let isVirtualItem: Bool;
@addField(gameItemData) public let isVirtualItem: Bool;
