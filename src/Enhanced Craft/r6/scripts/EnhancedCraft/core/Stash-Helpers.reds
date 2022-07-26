import EnhancedCraft.System.EnhancedCraftSystem

@wrapMethod(Stash)
protected cb func OnOpenStash(evt: ref<OpenStash>) -> Bool {
  wrappedMethod(evt);
  let storageItems: array<ref<gameItemData>>;
  let dataManager: ref<VendorDataManager> = new VendorDataManager();
  dataManager.Initialize(GetPlayer(this.GetGame()), this.GetEntityID());
  storageItems = dataManager.GetStorageItems();
  EnhancedCraftSystem.GetInstance(this.GetGame()).RefreshDataAndClearUnused(storageItems);
}
