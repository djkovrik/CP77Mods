import ExtraWardrobeSlots.Utils.W

@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToInventory(evt: ref<ItemAddedEvent>) -> Bool {
  let wardrobeSystem: wref<WardrobeSystemExtra>;
  wrappedMethod(evt);
  if !ItemID.IsValid(evt.itemID) {
    return false;
  };
  wardrobeSystem = WardrobeSystemExtra.GetInstance(this.GetGame());
  if IsDefined(wardrobeSystem) && Equals(RPGManager.GetItemCategory(evt.itemID), gamedataItemCategory.Clothing) && !wardrobeSystem.IsItemBlacklisted(evt.itemID) {
    wardrobeSystem.StoreUniqueItemIDAndMarkNew(this.GetGame(), evt.itemID);
  };
}

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  WardrobeSystemExtra.GetInstance(this.GetGame()).MigrateOldWardrobe();
}
