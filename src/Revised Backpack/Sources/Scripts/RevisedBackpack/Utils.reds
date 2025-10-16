module RevisedBackpack

public abstract class RevisedBackpackUtils {
  public final static func ShowRevisedBackpackLogs() -> Bool = false

  public final static func GetItemIcon(data: ref<gameItemData>) -> CName {
    let type: gamedataItemType = data.GetItemType();

    switch type {
      case gamedataItemType.Clo_Face: return n"loot_face";
      case gamedataItemType.Clo_Feet: return n"loot_shoes";
      case gamedataItemType.Clo_Head: return n"loot_head";
      case gamedataItemType.Clo_InnerChest: return n"loot_chest";
      case gamedataItemType.Clo_Legs: return n"loot_pants";
      case gamedataItemType.Clo_OuterChest: return n"loot_jacket";
      case gamedataItemType.Clo_Outfit: return n"loot_outfit";
      case gamedataItemType.Con_Ammo: return n"loot_ammo";
      case gamedataItemType.Con_Edible: return n"loot_consumable";
      case gamedataItemType.Con_Inhaler: return n"loot_inhaler";
      case gamedataItemType.Con_Injector: return n"loot_inhaler";
      case gamedataItemType.Con_LongLasting: return n"medicine";
      case gamedataItemType.Con_Skillbook: return n"codex_character";
      case gamedataItemType.Cyb_Ability: return n"codex_character";
      case gamedataItemType.Cyb_HealingAbility: return n"codex_character";
      case gamedataItemType.Cyb_Launcher: return n"loot_cyberware";
      case gamedataItemType.Cyb_MantisBlades: return n"loot_cyberware";
      case gamedataItemType.Cyb_NanoWires: return n"loot_cyberware";
      case gamedataItemType.Cyb_StrongArms: return n"loot_cyberware";
      case gamedataItemType.Cyberware: return n"loot_cyberware";
      case gamedataItemType.CyberwareStatsShard: return n"codex_character";
      case gamedataItemType.CyberwareUpgradeShard: return n"codex_character";
      case gamedataItemType.Gad_Grenade: return n"loot_grenade";
      case gamedataItemType.Gen_CraftingMaterial: return n"loot_material";
      case gamedataItemType.Gen_DataBank: return n"retrieving";
      case gamedataItemType.Gen_Jewellery: return n"junk";
      case gamedataItemType.Gen_Junk: return n"junk";
      case gamedataItemType.Gen_Keycard: return n"skillcheck_token";
      case gamedataItemType.Gen_Misc: return n"resource";
      case gamedataItemType.Gen_MoneyShard: return n"OpenVendor";
      case gamedataItemType.Gen_Readable: return n"shard";
      case gamedataItemType.Gen_Tarot: return n"tarot_card";
      case gamedataItemType.GrenadeDelivery: return n"grenade";
      case gamedataItemType.Grenade_Core: return n"grenade";
      case gamedataItemType.Prt_AR_SMG_LMGMod: return n"mod";
      case gamedataItemType.Prt_BladeMod: return n"mod";
      case gamedataItemType.Prt_BluntMod: return n"mod";
      case gamedataItemType.Prt_BootsFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_Capacitor: return n"mod";
      case gamedataItemType.Prt_FabricEnhancer: return n"armor";
      case gamedataItemType.Prt_FaceFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_Fragment: return n"loot_fragment";
      case gamedataItemType.Prt_HandgunMod: return n"mod";
      case gamedataItemType.Prt_HandgunMuzzle: return n"loot_muzzle";
      case gamedataItemType.Prt_HeadFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_LongScope: return n"loot_targetting_system";
      case gamedataItemType.Prt_Magazine: return n"loot_magazine";
      case gamedataItemType.Prt_MeleeMod: return n"mod";
      case gamedataItemType.Prt_Mod: return n"mod";
      case gamedataItemType.Prt_Muzzle: return n"loot_muzzle";
      case gamedataItemType.Prt_OuterTorsoFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_PantsFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_PowerMod: return n"mod";
      case gamedataItemType.Prt_PowerSniperScope: return n"loot_targetting_system";
      case gamedataItemType.Prt_Precision_Sniper_RifleMod: return n"mod";
      case gamedataItemType.Prt_Program: return n"loot_program";
      case gamedataItemType.Prt_RangedMod: return n"mod";
      case gamedataItemType.Prt_Receiver: return n"loot_receiver";
      case gamedataItemType.Prt_RifleMuzzle: return n"loot_muzzle";
      case gamedataItemType.Prt_Scope: return n"loot_targetting_system";
      case gamedataItemType.Prt_ScopeRail: return n"loot_scope_rail";
      case gamedataItemType.Prt_ShortScope: return n"loot_targetting_system";
      case gamedataItemType.Prt_ShotgunMod: return n"mod";
      case gamedataItemType.Prt_SmartMod: return n"mod";
      case gamedataItemType.Prt_Stock: return n"loot_stock";
      case gamedataItemType.Prt_TargetingSystem: return n"loot_targetting_system";
      case gamedataItemType.Prt_TechMod: return n"mod";
      case gamedataItemType.Prt_TechSniperScope: return n"loot_targetting_system";
      case gamedataItemType.Prt_ThrowableMod: return n"mod";
      case gamedataItemType.Prt_TorsoFabricEnhancer: return n"armor";
      case gamedataItemType.Wea_AssaultRifle: return n"gun";
      case gamedataItemType.Wea_Axe: return n"melee";
      case gamedataItemType.Wea_Chainsword: return n"melee";
      case gamedataItemType.Wea_Fists: return n"Solo";
      case gamedataItemType.Wea_GrenadeLauncher: return n"gun";
      case gamedataItemType.Wea_Hammer: return n"melee";
      case gamedataItemType.Wea_Handgun: return n"gun";
      case gamedataItemType.Wea_HeavyMachineGun: return n"gun_heavy";
      case gamedataItemType.Wea_Katana: return n"melee";
      case gamedataItemType.Wea_Knife: return n"melee";
      case gamedataItemType.Wea_LightMachineGun: return n"gun";
      case gamedataItemType.Wea_LongBlade: return n"melee";
      case gamedataItemType.Wea_Machete: return n"melee";
      case gamedataItemType.Wea_Melee: return n"melee";
      case gamedataItemType.Wea_OneHandedClub: return n"melee";
      case gamedataItemType.Wea_PrecisionRifle: return n"gun";
      case gamedataItemType.Wea_Revolver: return n"gun";
      case gamedataItemType.Wea_Rifle: return n"gun";
      case gamedataItemType.Wea_ShortBlade: return n"melee";
      case gamedataItemType.Wea_Shotgun: return n"gun";
      case gamedataItemType.Wea_ShotgunDual: return n"gun";
      case gamedataItemType.Wea_SniperRifle: return n"gun";
      case gamedataItemType.Wea_SubmachineGun: return n"gun";
      case gamedataItemType.Wea_Sword: return n"melee";
      case gamedataItemType.Wea_TwoHandedClub: return n"melee";
    };

    return n"loot";
  }

  public final static func GetItemIconColor(data: ref<gameItemData>) -> CName {
    if data.HasTag(n"RangedWeapon") { return n"MainColors.MildBlue"; }
    if data.HasTag(n"MeleeWeapon") { return n"MainColors.MediumBlue"; }
    if data.HasTag(n"Clothing") { return n"MainColors.MildGreen"; }
    if data.HasTag(n"Consumable") { return n"MainColors.DarkGold"; }
    if data.HasTag(n"Grenade") { return n"MainColors.Green"; }
    if data.HasTag(n"itemPart") && !data.HasTag(n"Fragment") && !data.HasTag(n"SoftwareShard") { return n"MainColors.StreetCred"; }
    if data.HasTag(n"SoftwareShard") || data.HasTag(n"QuickhackCraftingPart") { return n"MainColors.FastTravel"; }
    if data.HasTag(n"Cyberware") || data.HasTag(n"Fragment") { return n"MainColors.MildOrange"; }
    if data.HasTag(n"Junk") { return n"MainColors.Grey"; }

    return n"MainColors.White";
  }

  public final static func GetItemLabelColor(isQuestItem: Bool, isIconic: Bool) -> CName {
    if isIconic { 
      return n"MainColors.Orange"; 
    } else if isQuestItem { 
      return n"MainColors.Yellow"; 
    };

    return n"MainColors.Red";
  }

  public final static func IsEquippable(item: ref<RevisedItemWrapper>, playerPuppet: wref<PlayerPuppet>) -> Bool {
    let data: ref<gameItemData> = item.data;
    let itemID: ItemID = data.GetID();
    let canEquip: Bool = false;
    let equipmentSystem: wref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(playerPuppet.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    let area: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemID);
  
    if RevisedBackpackUtils.IsWeapon(area) {
      canEquip = !(StatusEffectSystem.ObjectHasStatusEffectWithTag(playerPuppet, n"VehicleScene") || StatusEffectSystem.ObjectHasStatusEffectWithTag(playerPuppet, n"FirearmsNoSwitch") || InventoryGPRestrictionHelper.BlockedBySceneTier(playerPuppet) || !equipmentSystem.GetPlayerData(playerPuppet).IsEquippable(data));
    } else if RevisedBackpackUtils.IsClothes(area) {
      canEquip = true;
    };

    return canEquip;
  }

  public final static func CanToggleQuestTag(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return 
      NotEquals(type, gamedataItemType.Gad_Grenade) &&
      NotEquals(type, gamedataItemType.Con_Ammo) &&
      NotEquals(type, gamedataItemType.Con_Edible) &&
      NotEquals(type, gamedataItemType.Con_Inhaler) &&
      NotEquals(type, gamedataItemType.Con_Injector) &&
      NotEquals(type, gamedataItemType.Con_LongLasting) &&
      NotEquals(type, gamedataItemType.Con_Skillbook) &&
      NotEquals(type, gamedataItemType.Gen_MoneyShard) &&
      NotEquals(type, gamedataItemType.Gen_CraftingMaterial) &&
      !InventoryDataManagerV2.IsAttachmentType(type) &&
    true;
  }

  public final static func CanToggleCustomJunk(uiInventoryItem: ref<UIInventoryItem>) -> Bool {
    let data: ref<gameItemData> = uiInventoryItem.GetRealItemData();
    return RevisedBackpackUtils.CanToggleQuestTag(data) 
      && !data.HasTag(n"Junk") 
      && !uiInventoryItem.IsPlayerFavourite() 
      && !uiInventoryItem.IsEquipped() 
      && !uiInventoryItem.IsIconic();
  }

  public final static func CanDisassemble(gi: GameInstance, uiInventoryItem: ref<UIInventoryItem>) -> Bool {
    let settings: ref<RevisedBackpackSettings> = new RevisedBackpackSettings();
    let canItemBeDisassembled: Bool = RPGManager.CanItemBeDisassembled(gi, uiInventoryItem.GetRealItemData());
    let canDisassembleThisTier: Bool = true;
    if uiInventoryItem.IsIconic() {
      canDisassembleThisTier = settings.allowIconicsDisassemble;
    };

    return canItemBeDisassembled
      && canDisassembleThisTier
      && !uiInventoryItem.IsPlayerFavourite() 
      && !uiInventoryItem.IsEquipped();
  }

  private final static func IsWeapon(type: gamedataEquipmentArea) -> Bool {
    return 
         Equals(type, gamedataEquipmentArea.Weapon) 
      || Equals(type, gamedataEquipmentArea.WeaponHeavy) 
      || Equals(type, gamedataEquipmentArea.WeaponWheel) 
      || Equals(type, gamedataEquipmentArea.WeaponLeft);
  }

  private final static func IsClothes(type: gamedataEquipmentArea) -> Bool {
    return 
       Equals(type, gamedataEquipmentArea.Outfit) 
    || Equals(type, gamedataEquipmentArea.OuterChest) 
    || Equals(type, gamedataEquipmentArea.InnerChest) 
    || Equals(type, gamedataEquipmentArea.Legs) 
    || Equals(type, gamedataEquipmentArea.Feet) 
    || Equals(type, gamedataEquipmentArea.Head) 
    || Equals(type, gamedataEquipmentArea.Face) 
    || Equals(type, gamedataEquipmentArea.UnderwearTop) 
    || Equals(type, gamedataEquipmentArea.UnderwearBottom);
  }
}
