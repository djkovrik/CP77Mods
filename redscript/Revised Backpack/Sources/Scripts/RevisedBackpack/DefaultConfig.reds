module RevisedBackpack

public abstract class RevisedBackpackDefaultConfig {

  public static final func Categories() -> array<ref<RevisedBackpackCategory>> {
    let newCategories: array<ref<RevisedBackpackCategory>>;

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        10,
        n"UI-Filters-AllItems",
        n"resource",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateAll()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        20,
        n"UI-Filters-RangedWeapons",
        n"gun",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateRangedWeapons()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        30,
        n"UI-Filters-MeleeWeapons",
        n"melee",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateMeleeWeapons()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        40,
        n"UI-Filters-Clothes",
        n"clothes",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateClothes()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        50,
        n"UI-Filters-Consumables",
        n"medicine",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateConsumables()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        60,
        n"UI-Filters-Grenades",
        n"grenade",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateGrenades()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        70,
        n"UI-Filters-Attachments",
        n"scope",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateAttachments()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        80,
        n"UI-Filters-Hacks",
        n"hacks",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicatePrograms()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        90,
        n"UI-Filters-Cyberware",
        n"ripperdoc",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateCyberware()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        95,
        n"Gameplay-Items-Item Type-Gen_CraftingMaterial",
        n"loot_material",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateCraftingParts()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        100,
        n"Mod-Revised-Quest-Items",
        n"minor_quest",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateQuest()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        110,
        n"UI-Filters-Junk",
        n"junk",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateJunk()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        120,
        n"Mod-Revised-New-Items",
        n"asterix",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateNew()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        130,
        n"Story-base-gameplay-gui-widgets-vehicle_control-vehicles_manager-Favorite",
        n"fav_star",
        r"base\\gameplay\\gui\\fullscreen\\ripperdoc\\assets\\cw_bars_assets.inkatlas",
        new RevisedCategoryPredicateFavorite()
      )
    );

    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        140,
        n"Mod-Revised-Column-Junk",
        n"tech",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateCustomJunk()
      )
    );

    return newCategories;
  }
}

// AllItems
private class RevisedCategoryPredicateAll extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    return true;
  }
}

// RangedWeapons
private class RevisedCategoryPredicateRangedWeapons extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"RangedWeapon");
  }
}

// MeleeWeapons
private class RevisedCategoryPredicateMeleeWeapons extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"MeleeWeapon") && !data.HasTag(n"Cyberware") ;
  }
}

// Clothes
private class RevisedCategoryPredicateClothes extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Clothing");
  }
}

// Consumables
private class RevisedCategoryPredicateConsumables extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Consumable");
  }
}

// Grenades
private class RevisedCategoryPredicateGrenades extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Grenade");
  }
}

// Attachments
private class RevisedCategoryPredicateAttachments extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"itemPart") && !data.HasTag(n"Fragment") && !data.HasTag(n"SoftwareShard");
  }
}

// Programs
private class RevisedCategoryPredicatePrograms extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"SoftwareShard") || data.HasTag(n"QuickhackCraftingPart");
  }
}

// Cyberware
private class RevisedCategoryPredicateCyberware extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Cyberware") || data.HasTag(n"Fragment");
  }
}

// Crafting materials
private class RevisedCategoryPredicateCraftingParts extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"CraftingPart");
  }
}


// Quest
private class RevisedCategoryPredicateQuest extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Quest") || data.HasTag(n"UnequipBlocked");
  }
}

// Junk
private class RevisedCategoryPredicateJunk extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Junk");
  }
}

// New
private class RevisedCategoryPredicateNew extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    return item.inventoryItem.IsNew();
  }
}

// Favorite
private class RevisedCategoryPredicateFavorite extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    return item.inventoryItem.IsPlayerFavourite();
  }
}

// Custom junk
private class RevisedCategoryPredicateCustomJunk extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    return item.customJunk;
  }
}
