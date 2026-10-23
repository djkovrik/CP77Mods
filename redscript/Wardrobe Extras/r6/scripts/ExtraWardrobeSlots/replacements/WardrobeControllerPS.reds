@addField(WardrobeControllerPS)
protected persistent let m_clothingSetsExtra: array<ref<ClothingSetExtra>>;

@replaceMethod(WardrobeControllerPS)
protected final func InitializeWardrobeFromStash() -> Void {
  let i: Int32;
  let storageItems: array<ref<gameItemData>>;
  let wardrobeSystem: ref<WardrobeSystemExtra> = WardrobeSystemExtra.GetInstance(this.GetGameInstance());
  let dataManager: ref<VendorDataManager> = new VendorDataManager();
  dataManager.Initialize(GetPlayer(this.GetGameInstance()), PersistentID.ExtractEntityID(this.GetID()));
  storageItems = dataManager.GetStorageItems();
  i = 0;
  while i < ArraySize(storageItems) {
    if RPGManager.IsItemClothing(storageItems[i].GetID()) {
      wardrobeSystem.StoreUniqueItemIDAndMarkNew(this.GetGameInstance(), storageItems[i].GetID());
    };
    i += 1;
  };
}
