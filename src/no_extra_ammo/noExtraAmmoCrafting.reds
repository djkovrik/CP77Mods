// Default game limits
@addMethod(CraftingSystem)
private func GetAmmoLimit_LHUD(id: TweakDBID) -> Int32 {
  switch (id) {
    case t"Ammo.RifleAmmo": return 700;
    case t"Ammo.HandgunAmmo": return 500;
    case t"Ammo.ShotgunAmmo": return 100;
    case t"Ammo.SniperRifleAmmo": return 100;
  };

  return 0;
}

// Single crafted pack size
@addMethod(CraftingSystem)
private func GetBulletAmmount_LHUD(id: TweakDBID) -> Int32 {
  switch (id) {
    case t"Ammo.RifleAmmo": return 48;
    case t"Ammo.HandgunAmmo": return 24;
    case t"Ammo.ShotgunAmmo": return 12;
    case t"Ammo.SniperRifleAmmo": return 8;
  };

  return 1;
}

// Current ammo count
@addMethod(CraftingSystem)
private func GetAmmoCount_LHUD(id: TweakDBID) -> Int32 {
  return GameInstance.GetTransactionSystem(this.m_playerCraftBook.GetOwner().GetGame()).GetItemQuantity(this.m_playerCraftBook.GetOwner(), ItemID.FromTDBID(id));
}

// Check if crafting available
@addMethod(CraftingSystem)
private func CanAmmoBeCrafted_LHUD(id: TweakDBID) -> Bool {
  let ammoCount: Int32 = this.GetAmmoCount_LHUD(id);
  let ammoLimit: Int32 = this.GetAmmoLimit_LHUD(id);
  return ammoCount < ammoLimit;
}

// Haxx quantity popup to disallow selection beyound the limit
@replaceMethod(CraftingSystem)
public final const func GetMaxCraftingAmount(itemData: wref<gameItemData>) -> Int32 {
  let currentQuantity: Int32;
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
  let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemData);
  let result: Int32 = 10000000;
  let i: Int32 = 0;
  while i < ArraySize(requiredIngredients) {
    currentQuantity = transactionSystem.GetItemQuantity(this.m_playerCraftBook.GetOwner(), ItemID.CreateQuery(requiredIngredients[i].id.GetID()));
    if currentQuantity > requiredIngredients[i].quantity {
      result = Min(result, currentQuantity / requiredIngredients[i].quantity);
    } else {
      return 0;
    };
    i += 1;
  };

  // Check the result over ammo capacity limit
  if Equals(itemData.GetItemType(), gamedataItemType.Con_Ammo) {
    let id: TweakDBID = ItemID.GetTDBID(itemData.GetID());
    let current: Int32 = this.GetAmmoCount_LHUD(id);
    let limit: Int32 = this.GetAmmoLimit_LHUD(id);
    let bulletAmount = this.GetBulletAmmount_LHUD(id);
    let remainedCapacity: Int32 = limit - current;
    let remainedQuantity: Int32 = remainedCapacity / bulletAmount + 1;

    if result > remainedQuantity { 
      result = remainedQuantity; 
    };
  };

  return result;
}

// Highlight with red if the limit reached
@replaceMethod(CraftingSystem)
public final const func CanItemBeCrafted(itemRecord: wref<Item_Record>) -> Bool {
  let quality: gamedataQuality;
  let result: Bool;
  let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemRecord);
  if Equals(itemRecord.ItemType().Type(), gamedataItemType.Prt_Program) {
    result = this.HasIngredients(requiredIngredients);
  } else {
    if Equals(itemRecord.ItemType().Type(), gamedataItemType.Con_Ammo) {
      result = this.HasIngredients(requiredIngredients) && this.CanCraftGivenQuality(itemRecord, quality) && this.CanAmmoBeCrafted_LHUD(itemRecord.GetID());
    } else {
      result = this.HasIngredients(requiredIngredients) && this.CanCraftGivenQuality(itemRecord, quality);
    };
  };
  return result;
}

// Block crafting button if the limit reached
@replaceMethod(CraftingSystem)
public final const func CanItemBeCrafted(itemData: wref<gameItemData>) -> Bool {
  let quality: gamedataQuality;
  let result: Bool;
  let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemData);
  if Equals(itemData.GetItemType(), gamedataItemType.Prt_Program) {
    result = this.HasIngredients(requiredIngredients);
  } else {
    if Equals(itemData.GetItemType(), gamedataItemType.Con_Ammo) {
      result = this.HasIngredients(requiredIngredients) && this.CanCraftGivenQuality(itemData, quality) && this.CanAmmoBeCrafted_LHUD(ItemID.GetTDBID(itemData.GetID()));
    } else {
      result = this.HasIngredients(requiredIngredients) && this.CanCraftGivenQuality(itemData, quality);
    };
  };
  return result;
}
