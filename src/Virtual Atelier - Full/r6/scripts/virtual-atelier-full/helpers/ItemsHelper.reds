module VirtualAtelier.Helpers
import VendorPreview.Config.VirtualAtelierConfig
import VirtualAtelier.Logs.AtelierDebug

public abstract class AtelierItemsHelper {

  public static func ScaleItem(player: ref<PlayerPuppet>, itemData: ref<gameItemData>, quality: CName) -> Void {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
    let powerLevelPlayer: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.PowerLevel);
    let powerLevelMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.PowerLevel, gameStatModifierType.Additive, powerLevelPlayer);
    let qualityMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.Quality, gameStatModifierType.Additive, RPGManager.ItemQualityNameToValue(quality));
    statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.PowerLevel, true);
    statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), powerLevelMod);
    statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.Quality);
    statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), qualityMod);
    RPGManager.ForceItemQuality(player, itemData, quality);
  }

  public static func ScaleItemPrice(player: wref<PlayerPuppet>, vendor: wref<GameObject>, itemId: ItemID, itemQuality: CName) -> Int32 {
    let config: ref<VirtualAtelierConfig> = VirtualAtelierConfig.Get();
    let itemModParams: ItemModParams;
    itemModParams.itemID = itemId;
    itemModParams.quantity = 1;

    let itemData: ref<gameItemData> = Inventory.CreateItemData(itemModParams, player);
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
    let powerLevelPlayer: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.PowerLevel);

    AtelierDebug(s"   powerLevelPlayer \(ToString(powerLevelPlayer))", config);

    if (Cast<Int32>(powerLevelPlayer) < 1) {
      powerLevelPlayer = 1.0;
    };

    let qualMulti: Float = 1.0;

    AtelierDebug(s"   is iconic: \(ToString(RPGManager.IsItemIconic(itemData)))", config);
    AtelierDebug(s"   quality: \(ToString(itemQuality)))", config);

    if Equals(itemData.GetItemType(), gamedataItemType.Gen_Misc) {
      powerLevelPlayer = 1.0;
    };

    if (itemData.HasTag(n"Weapon")) {
      if (RPGManager.IsItemIconic(itemData)) {
        switch (itemQuality) {
          case n"Legendary":
            qualMulti = 2.3;
            break;
          case n"Epic":
              qualMulti = 1.49;
            break;
          case n"Rare":
            qualMulti = 1.0;
            break;
          case n"Uncommon":
            qualMulti = 0.5;
            break;
          case n"Common":
            qualMulti = 0.33;
            break;
          default:
            qualMulti = 1.0;
            break;
        };
      } else {
        switch (itemQuality) {
          case n"Legendary":
            qualMulti = 1.85;
            break;
          case n"Epic":
              qualMulti = 1.19;
            break;
          case n"Rare":
            qualMulti = 0.79;
            break;
          case n"Uncommon":
            qualMulti = 0.40;
            break;
          case n"Common":
            qualMulti = 0.26;
            break;
          default:
            qualMulti = 0.79;
            break;
        };
      };
    };
    
    if (itemData.HasTag(n"Clothing")) {
      if (RPGManager.IsItemIconic(itemData)) {
        switch (itemQuality) {
          case n"Legendary":
            qualMulti = 2.9;
            break;
          case n"Epic":
              qualMulti = 1.8;
            break;
          case n"Rare":
            qualMulti = 1.25;
            break;
          case n"Uncommon":
            qualMulti = 1.025;
            break;
          case n"Common":
            qualMulti = 0.91;
            break;
          default:
            qualMulti = 1.25;
            break;
        };
      } else {
        switch (itemQuality) {
          case n"Legendary":
              qualMulti = 2.34;
              break;
          case n"Epic":
              qualMulti = 1.5;
              break;
          case n"Rare":
              qualMulti = 1.0;
              break;
          case n"Uncommon":
              qualMulti = 0.5;
              break;
          case n"Common":
              qualMulti = 0.33;
              break;
          default:
              qualMulti = 1.0;
              break;
        };
      };
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
        qualMulti = 20.0;
      } else {
        powerLevelPlayer = 1.0;
      };
    };

    let price: Int32 = RPGManager.CalculateBuyPrice(player.GetGame(), vendor, itemData.GetID(), 1.0);
    AtelierDebug(s"   BasePrice: \(ToString(price))", config);
    AtelierDebug(s"   qualMulti: \(ToString(qualMulti))", config);
    AtelierDebug(s"   powerLevelPlayer \(ToString(powerLevelPlayer))", config);
    return RoundF((powerLevelPlayer * qualMulti) * Cast<Float>(price));
  }
}
