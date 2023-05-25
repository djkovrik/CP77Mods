import VirtualAtelier.Systems.VirtualAtelierPreviewManager
import VirtualAtelier.Systems.VirtualAtelierCartManager
import VirtualAtelier.Config.VirtualAtelierConfig
import Codeware.UI.*

@addField(WardrobeSetPreviewGameController) public let previewManager: wref<VirtualAtelierPreviewManager>;
@addField(WardrobeSetPreviewGameController) public let additionalData: ref<PreviewInventoryItemPreviewData>;
@addField(WardrobeSetPreviewGameController) public let isLeftMouseDown: Bool;
@addField(WardrobeSetPreviewGameController) public let previewActive: Bool;

@addField(FullscreenVendorGameController) public let isPreviewMode: Bool;
@addField(FullscreenVendorGameController) public let previewManager: wref<VirtualAtelierPreviewManager>;

@addField(BackpackMainGameController) public let previewItemPopupToken: ref<inkGameNotificationToken>;
@addField(BackpackMainGameController) public let isPreviewMode: Bool;

@addField(InventoryTooltipData) public let virtualInventoryItemData: InventoryItemData;
@addField(InventoryTooltipData) public let isVirtualItem: Bool;

@addField(InventoryItemDisplayController) public let cartIndicator: wref<inkWidget>;
@addField(InventoryItemDisplayController) public let quantityIndicator: wref<inkText>;
@addField(InventoryItemDisplayController) public let cartManager: wref<VirtualAtelierCartManager>;
@addField(InventoryItemDisplayController) public let previewManager: wref<VirtualAtelierPreviewManager>;

@addField(QuantityPickerPopupData) public let virtualItemPrice: Int32;
@addField(VendorPanelData) public let virtualStore: ref<VirtualShop>;
@addField(MinimalItemTooltipData) public let isVirtualItem: Bool;
@addField(gameItemData) public let isVirtualItem: Bool;
