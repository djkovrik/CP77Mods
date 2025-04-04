module VirtualAtelier.Helpers
import VendorPreview.Config.VirtualAtelierConfig
import VirtualAtelier.Logs.AtelierDebug

public abstract class AtelierItemsHelper {

  public static func ScaleItem(player: ref<PlayerPuppet>, itemData: ref<gameItemData>, quality: CName) -> Void {
    let itemType: gamedataItemType = itemData.GetItemType();

    // Skip scaling for a certain types of items
    if itemData.HasTag(n"Cyberware") || 
      Equals(itemType, gamedataItemType.Gen_CraftingMaterial) || 
      Equals(itemType, gamedataItemType.Con_Edible) || 
      Equals(itemType, gamedataItemType.Con_LongLasting) || 
      Equals(itemType, gamedataItemType.Con_Inhaler) || 
      Equals(itemType, gamedataItemType.Con_Injector) {
        AtelierDebug(s"Item scaling skipped: \(itemType)");
        return ;
    };

    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
    let qualityLevel: Float;
    let wasItemUpgradedMod: ref<gameStatModifierData>;
    let qualityMod: ref<gameStatModifierData>;
    let plusMod: ref<gameStatModifierData>;

    if itemData.HasTag(n"IconicWeapon") {
      qualityLevel = RPGManager.GetItemTierFromName(quality);
      wasItemUpgradedMod = RPGManager.CreateStatModifier(gamedataStatType.WasItemUpgraded, gameStatModifierType.Additive, qualityLevel);
      statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), wasItemUpgradedMod);

      qualityMod = RPGManager.CreateStatModifier(gamedataStatType.Quality, gameStatModifierType.Additive, -0.0);
      statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), qualityMod);

      plusMod = RPGManager.CreateStatModifierUsingCurve(gamedataStatType.IsItemPlus, gameStatModifierType.Additive, gamedataStatType.WasItemUpgraded, n"quality_curves", n"iconic_upgrades_amount_to_plus");
      statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), plusMod);
    } else {
      RPGManager.ForceItemTier(player, itemData, quality);
    };
  }

  public static func ScaleItemPrice(player: wref<PlayerPuppet>, vendor: wref<GameObject>, itemId: ItemID, itemQuality: CName) -> Int32 {
    let itemModParams: ItemModParams;
    itemModParams.itemID = itemId;
    itemModParams.quantity = 1;

    let itemData: ref<gameItemData> = Inventory.CreateItemData(itemModParams, player);
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
    let powerLevelPlayer: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.PowerLevel);

    AtelierDebug(s"   powerLevelPlayer \(ToString(powerLevelPlayer))");

    if (Cast<Int32>(powerLevelPlayer) < 1) {
      powerLevelPlayer = 1.0;
    };

    let qualMulti: Float = 1.0;

    AtelierDebug(s"   is iconic: \(ToString(RPGManager.IsItemIconic(itemData)))");
    AtelierDebug(s"   quality: \(ToString(itemQuality)))");

    if Equals(itemData.GetItemType(), gamedataItemType.Gen_Misc) {
      powerLevelPlayer = 1.0;
    };

    if (itemData.HasTag(n"Weapon")) {
      if (RPGManager.IsItemIconic(itemData)) {
        switch (itemQuality) {
          case n"Legendary":
            qualMulti = 0.23;
            break;
          case n"Epic":
              qualMulti = 0.149;
            break;
          case n"Rare":
            qualMulti = 0.1;
            break;
          case n"Uncommon":
            qualMulti = 0.05;
            break;
          case n"Common":
            qualMulti = 0.033;
            break;
          default:
            qualMulti = 0.1;
            break;
        };
      } else {
        switch (itemQuality) {
          case n"Legendary":
            qualMulti = 0.185;
            break;
          case n"Epic":
              qualMulti = 0.119;
            break;
          case n"Rare":
            qualMulti = 0.079;
            break;
          case n"Uncommon":
            qualMulti = 0.04;
            break;
          case n"Common":
            qualMulti = 0.026;
            break;
          default:
            qualMulti = 0.079;
            break;
        };
      };
    };
    
    if (itemData.HasTag(n"Clothing")) {
      if (RPGManager.IsItemIconic(itemData)) {
        switch (itemQuality) {
          case n"Legendary":
            qualMulti = 0.29;
            break;
          case n"Epic":
              qualMulti = 0.18;
            break;
          case n"Rare":
            qualMulti = 0.125;
            break;
          case n"Uncommon":
            qualMulti = 0.1025;
            break;
          case n"Common":
            qualMulti = 0.091;
            break;
          default:
            qualMulti = 0.125;
            break;
        };
      } else {
        switch (itemQuality) {
          case n"Legendary":
              qualMulti = 0.234;
              break;
          case n"Epic":
              qualMulti = 0.15;
              break;
          case n"Rare":
              qualMulti = 0.10;
              break;
          case n"Uncommon":
              qualMulti = 0.05;
              break;
          case n"Common":
              qualMulti = 0.033;
              break;
          default:
              qualMulti = 0.1;
              break;
        };
      };
      powerLevelPlayer = powerLevelPlayer * 0.1;
    };

    if ((itemData.HasTag(n"WeaponMod")) || (itemData.HasTag(n"FabricEnhancer")) || (itemData.HasTag(n"SoftwareShard")) || (itemData.HasTag(n"Fragment")) || (itemData.HasTag(n"Recipe"))) {
      powerLevelPlayer = 1.0;
      switch (itemQuality) {
        case n"Legendary":
          qualMulti = 7.0;
          break;
        case n"Epic":
          qualMulti = 4.5;
          break;
        case n"Rare":
          qualMulti = 3.0;
          break;
        case n"Uncommon":
          qualMulti = 1.5;
          break;
        case n"Common":
          qualMulti = 1.0;
          break;
        default:
          qualMulti = 3.0;
          break;
      };
    };
      
    if (itemData.HasTag(n"Cyberware")) {
      powerLevelPlayer = 1.0;
      if (RPGManager.IsItemIconic(itemData)) {
        qualMulti = 8.75;  
      } else {
          switch (itemQuality) {
            case n"Legendary":
              qualMulti = 7.0;
              break;
            case n"Epic":
              qualMulti = 4.0;
              break;
            case n"Rare":
              qualMulti = 2.5;
              break;
            case n"Uncommon":
              qualMulti = 1.5;
              break;
            case n"Common":
              qualMulti = 1.0;
              break;
            default:
              qualMulti = 2.5;
              break;
          };
      };
    };
    
    if ((itemData.HasTag(n"Grenade")) || (itemData.HasTag(n"Ammo")) || (itemData.HasTag(n"CraftingPart")) || (itemData.HasTag(n"Consumable")) || (itemData.HasTag(n"Junk"))) {
      if itemData.HasTag(n"skillbook") {
        qualMulti = 0.15;
      } else {
        powerLevelPlayer = 1.0;
      };
    };

    let price: Int32 = RPGManager.CalculateBuyPrice(player.GetGame(), vendor, itemData.GetID(), 1.0);
    AtelierDebug(s"   BasePrice: \(ToString(price))");
    AtelierDebug(s"   qualMulti: \(ToString(qualMulti))");
    AtelierDebug(s"   powerLevelPlayer \(ToString(powerLevelPlayer))");
    return RoundF((powerLevelPlayer * qualMulti) * Cast<Float>(price));
  }
}
