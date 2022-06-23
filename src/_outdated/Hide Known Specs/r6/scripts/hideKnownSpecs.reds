// -- Utils
// check for recipe tag in tags array
public static func HasRecipeTag(vendorItem: ref<VendorItem_Record>) -> Bool {
  let tags: array<CName>;
  let i: Int32;
  tags = vendorItem.Item().Tags();
  i = 0;
  while i < ArraySize(tags) {
    if Equals(tags[i], n"Recipe") {
      return true;
    };
    i += 1;
  };

  return false;
}

// extract crafted item id from the vendor item
public static func GetCraftedResultItemId(vendorItem: ref<VendorItem_Record>) -> TweakDBID {
  return TweakDBInterface.GetItemRecipeRecord(vendorItem.Item().GetID()).CraftingResult().Item().GetID();
}


// -- PlayerPuppet
@addMethod(PlayerPuppet)
public func IsRecipeKnown(vendorItem: ref<VendorItem_Record>) -> Bool {
  let craftingSystem: ref<CraftingSystem>;
  let recipes: array<ItemRecipe>;
  let targetId: TweakDBID;
  let i: Int32;

  craftingSystem = CraftingSystem.GetInstance(this.GetGame());
  recipes = craftingSystem.m_playerCraftBook.m_knownRecipes;
  targetId = GetCraftedResultItemId(vendorItem);
  i = 0;

  while i < ArraySize(recipes) {
    if Equals(recipes[i].targetItem, targetId) {
      return true;
    };
    i += 1;
  };

  return false;
}


// -- Vendor
@replaceMethod(Vendor)
private final const func PlayerCanBuy(itemStack: script_ref<SItemStack>) -> Bool {
  let availablePrereq: wref<IPrereq_Record>;
  let filterTags: array<CName>;
  let playerKnows: Bool;
  let i: Int32;
  let itemData: wref<gameItemData>;
  let viewPrereqs: array<wref<IPrereq_Record>>;
  let vendorItem: wref<VendorItem_Record> = TweakDBInterface.GetVendorItemRecord(Deref(itemStack).vendorItemID);
  vendorItem.GenerationPrereqs(viewPrereqs);
  // Recipe and state check
  if HasRecipeTag(vendorItem) {
    playerKnows = GetPlayer(this.m_gameInstance).IsRecipeKnown(vendorItem);
    if playerKnows {
      return false;
    };
  };
  if RPGManager.CheckPrereqs(viewPrereqs, GetPlayer(this.m_gameInstance)) {
    filterTags = this.m_vendorRecord.VendorFilterTags();
    itemData = GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemData(this.m_vendorObject, Deref(itemStack).itemID);
    availablePrereq = vendorItem.AvailabilityPrereq();
    Deref(itemStack).requirement = RPGManager.GetStockItemRequirement(vendorItem);
    if IsDefined(availablePrereq) {
      Deref(itemStack).isAvailable = RPGManager.CheckPrereq(availablePrereq, GetPlayer(this.m_gameInstance));
    };
    i = 0;
    while i < ArraySize(filterTags) {
      if IsDefined(itemData) && itemData.HasTag(filterTags[i]) {
        return false;
      };
      i += 1;
    };
    return true;
  };
  return false;
}
