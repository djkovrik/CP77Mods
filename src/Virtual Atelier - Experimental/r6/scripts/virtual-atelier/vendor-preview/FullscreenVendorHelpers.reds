import VendorPreview.ItemPreviewManager.VirtualAtelierPreviewManager

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreName() -> String {
  return this.m_vendorUserData.vendorData.virtualStore.storeName;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreID() -> CName {
  return this.m_vendorUserData.vendorData.virtualStore.storeID;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreItems() -> array<String> {
  return this.m_vendorUserData.vendorData.virtualStore.items;
}

@addMethod(FullscreenVendorGameController)
private final func GetIsVirtual() -> Bool {
  return Equals(this.m_vendorUserData.vendorData.data.vendorId, "VirtualVendor");
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreAtlasResource() -> ResRef {
  return this.m_vendorUserData.vendorData.virtualStore.atlasResource;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreTexturePart() -> CName {
  return this.m_vendorUserData.vendorData.virtualStore.texturePart;
}

@addMethod(FullscreenVendorGameController)
private final func SetPreviewStateActive(active: Bool) -> Void {
  this.m_previewManager.SetPreviewState(active);
}

// Darkcopse prices tweak
@addMethod(FullscreenVendorGameController)
private final func GetVirtualStorePrices() -> array<Int32> { 
  let items: array<String> = this.m_vendorUserData.vendorData.virtualStore.items;
  let prices: array<Int32> = this.m_vendorUserData.vendorData.virtualStore.prices;
  let defaultPrice = 0;

  if (ArraySize(prices) == 1) {
    defaultPrice = prices[0];
  };

  let i = 0;
  if (ArraySize(items) > ArraySize(prices)) {
    while (i < (ArraySize(items) - ArraySize(prices))) {
      ArrayPush(prices, defaultPrice); 
    };
  };

  return prices;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreQualities() -> array<CName> {
  let items: array<String> = this.m_vendorUserData.vendorData.virtualStore.items;
  let qualities: array<String> = this.m_vendorUserData.vendorData.virtualStore.qualities;
  let qualitiesCNames: array<CName> = [];

  let defaultQuality = n"Rare";
  // Darkcopse qualities tweak
  if (ArraySize(qualities) == 1) {
    defaultQuality = StringToName(qualities[0]);
  };

  let i: Int32 = 0;

  while (i < ArraySize(items)) {
    let itemQuality: String = qualities[i];

    if Equals(itemQuality, "") {
      ArrayPush(qualitiesCNames, defaultQuality);
    } else {
      let qualityCName: CName = StringToName(itemQuality);

      if IsNameValid(qualityCName) && !Equals(qualityCName, n"") {
        ArrayPush(qualitiesCNames, qualityCName);
      } else {
         ArrayPush(qualitiesCNames, defaultQuality);
      };
    };

    i += 1;
  };

  return qualitiesCNames;
}

// Darkcopse quantities tweak
@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreQuantities() -> array<Int32> {
  let items: array<String> = this.m_vendorUserData.vendorData.virtualStore.items;
  let quantities: array<Int32> = this.m_vendorUserData.vendorData.virtualStore.quantities;
  let i: Int32 = 0;
  if (ArraySize(items) > ArraySize(quantities)) {
    while (i < (ArraySize(items) - ArraySize(quantities))) {
      ArrayPush(quantities, 1); 
    };
  };
  return quantities;
}
