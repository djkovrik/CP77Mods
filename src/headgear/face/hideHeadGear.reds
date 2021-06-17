// -- UTILS
public static func L(str: String) -> Void {
  // Log("> " + str);
}

public static func I(str: String) -> Void {
  // Log("! " + str);
}

public static func ToStr(itemId: ItemID) -> String {
  return TDBID.ToStringDEBUG(ItemID.GetTDBID(itemId));
}

public static func ItemDump(itemId: ItemID) -> String {
  return "IsHeadGear: " +  IsHeadGear(itemId) + ", IsTppHead: " + IsTppHead(itemId) + ", id: " + ToStr(itemId);
}

public static func IsTppHead(itemId: ItemID) -> Bool {
  return Equals(ItemID.GetTDBID(itemId), t"Items.PlayerMaTppHead") || Equals(ItemID.GetTDBID(itemId), t"Items.PlayerWaTppHead");
}

public static func IsHeadGear(itemId: ItemID) -> Bool {
  return Equals(EquipmentSystem.GetEquipAreaType(itemId), gamedataEquipmentArea.Head) || Equals(EquipmentSystem.GetEquipAreaType(itemId), gamedataEquipmentArea.Face);
}

public static func ShouldBeDisplayed(itemId: ItemID) -> Bool {
  return !IsHeadGear(itemId) || IsTppHead(itemId);
}

public static func ShouldBeHidden(itemId: ItemID) -> Bool {
  return IsHeadGear(itemId) && !IsTppHead(itemId);
}

public static func PrintPlayerStats(where: String, object: ref<GameObject>) -> Void {
  let statsSystem: ref<StatsSystem>;
  let armorValue: Float;
  let critChance: Float;
  let critDamage: Float;
  statsSystem = GameInstance.GetStatsSystem(object.GetGame());
  armorValue = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.Armor);
  critChance = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.CritChance);
  critDamage = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.CritDamage);
  I("Stats at " + where + " - armor: " + FloatToString(armorValue) + ", crit chance: " + FloatToString(critChance)+ ", crit damage: " + FloatToString(critDamage));
}


// -- EquipmentSystemPlayerData

@replaceMethod(EquipmentSystemPlayerData)
public final func OnEquipProcessVisualTags(itemID: ItemID) -> Void {
  let i: Int32;
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
  let itemEntity: wref<GameObject> = transactionSystem.GetItemInSlotByItemID(this.m_owner, itemID);
  let areaType: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemID);
  let tag: CName = this.GetVisualTagByAreaType(areaType);
  if NotEquals(tag, n"") && this.IsVisualTagActive(tag) {
    this.ClearItemAppearanceEvent(areaType);
  } else {
    if IsDefined(itemEntity) {
      i = 0;
      while i < ArraySize(this.m_clothingSlotsInfo) {
        if transactionSystem.MatchVisualTag(itemEntity, this.m_clothingSlotsInfo[i].visualTag, true) && !transactionSystem.IsSlotEmpty(this.m_owner, this.m_clothingSlotsInfo[i].equipSlot) {
          this.ClearItemAppearanceEvent(this.m_clothingSlotsInfo[i].areaType);
        };
        i += 1;
      };
      if Equals(areaType, gamedataEquipmentArea.OuterChest) && this.IsPartialVisualTagActive(itemID, transactionSystem) {
        this.m_isPartialVisualTagActive = true;
        this.UpdateInnerChest(transactionSystem);
      };
      if (!this.IsUnderwearHidden() || Equals(areaType, gamedataEquipmentArea.UnderwearBottom)) && (ItemID.IsValid(this.GetActiveItem(gamedataEquipmentArea.Legs)) || this.IsVisualTagActive(n"hide_L1")) {
        this.ClearItemAppearanceEvent(gamedataEquipmentArea.UnderwearBottom);
      };
      if this.IsBuildCensored() && (!this.IsUnderwearTopHidden() || Equals(areaType, gamedataEquipmentArea.UnderwearTop)) && (ItemID.IsValid(this.GetActiveItem(gamedataEquipmentArea.InnerChest)) || this.IsVisualTagActive(n"hide_T1")) {
        this.ClearItemAppearanceEvent(gamedataEquipmentArea.UnderwearTop);
      };
    };
  };

  // Forced ClearItemAppearanceEvent for head slot
  if ShouldBeHidden(itemID) {
    this.ClearItemAppearanceEvent(gamedataEquipmentArea.Head);
    this.ClearItemAppearanceEvent(gamedataEquipmentArea.Face);
  };
}

@replaceMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt addToInventory: Bool, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  L("EquipItem - " + ItemDump(itemID));
  let i: Int32;
  let audioEventFoley: ref<AudioEvent>;
  let audioEventFootwear: ref<AudioEvent>;
  let currentItem: ItemID;
  let currentItemData: wref<gameItemData>;
  let cyberwareType: CName;
  let equipArea: SEquipArea;
  let equipAreaIndex: Int32;
  let holsterItemID: ItemID;
  let i: Int32;
  let itemEntity: wref<ItemObject>;
  let packages: array<wref<GameplayLogicPackage_Record>>;
  let paperdollEquipData: SPaperdollEquipData;
  let placementSlot: TweakDBID;
  let transactionSystem: ref<TransactionSystem>;
  let weaponRecord: ref<WeaponItem_Record>;
  let itemData: wref<gameItemData> = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, itemID);
  if !this.IsEquippable(itemData) {
    return ;
  };
  if Equals(RPGManager.GetItemRecord(itemID).ItemType().Type(), gamedataItemType.Cyb_StrongArms) {
    this.HandleStrongArmsEquip(itemID);
  };
  equipAreaIndex = this.GetEquipAreaIndex(EquipmentSystem.GetEquipAreaType(itemID));
  equipArea = this.m_equipment.equipAreas[equipAreaIndex];
  currentItem = this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID;
  currentItemData = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, currentItem);
  if IsDefined(currentItemData) && currentItemData.HasTag(n"UnequipBlocked") {
    return ;
  };
  if this.IsItemOfCategory(itemID, gamedataItemCategory.Weapon) && equipArea.activeIndex == slotIndex && this.CheckWeaponAgainstGameplayRestrictions(itemID) && !blockActiveSlotsUpdate {
    this.SetSlotActiveItem(EquipmentManipulationRequestSlot.Right, itemID);
    this.SetLastUsedItem(itemID);
  } else {
    if this.IsItemOfCategory(itemID, gamedataItemCategory.Weapon) && forceEquipWeapon && this.CheckWeaponAgainstGameplayRestrictions(itemID) {
      this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID = itemID;
      this.SetSlotActiveItem(EquipmentManipulationRequestSlot.Right, itemID);
      this.UpdateEquipAreaActiveIndex(itemID);
      this.SetLastUsedItem(itemID);
    } else {
      this.UnequipItem(equipAreaIndex, slotIndex);
      cyberwareType = TweakDBInterface.GetCName(ItemID.GetTDBID(itemID) + t".cyberwareType", n"");
      i = 0;
      while i < ArraySize(this.m_equipment.equipAreas[equipAreaIndex].equipSlots) {
        if Equals(cyberwareType, TweakDBInterface.GetCName(ItemID.GetTDBID(this.m_equipment.equipAreas[equipAreaIndex].equipSlots[i].itemID) + t".cyberwareType", n"type")) {
          this.UnequipItem(equipAreaIndex, i);
        };
        i += 1;
      };
    };
  };
  if Equals(equipArea.areaType, gamedataEquipmentArea.ArmsCW) {
    this.UnequipItem(equipAreaIndex, slotIndex);
  };
  this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID = itemID;
  transactionSystem = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
  placementSlot = this.GetPlacementSlot(equipAreaIndex, slotIndex);
  if placementSlot == t"AttachmentSlots.WeaponRight" || placementSlot == t"AttachmentSlots.WeaponLeft" {
    weaponRecord = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(itemID));
    if IsDefined(weaponRecord) && IsDefined(weaponRecord.HolsteredItem()) {
      EquipmentSystemPlayerData.UpdateArmSlot(this.m_owner as PlayerPuppet, itemID, true);
    };
  };
  if placementSlot != t"AttachmentSlots.WeaponRight" && placementSlot != t"AttachmentSlots.WeaponLeft" && placementSlot != t"AttachmentSlots.Consumable" {
    if !transactionSystem.HasItemInSlot(this.m_owner, placementSlot, itemID) {
      transactionSystem.RemoveItemFromSlot(this.m_owner, placementSlot);
      transactionSystem.AddItemToSlot(this.m_owner, placementSlot, itemID);
    };
  };
  if Equals(RPGManager.GetItemRecord(itemID).ItemType().Type(), gamedataItemType.Clo_Feet) {
    audioEventFootwear = new AudioEvent();
    audioEventFootwear.eventName = n"equipFootwear";
    audioEventFootwear.nameData = RPGManager.GetItemRecord(itemID).MovementSound().AudioMovementName();
    this.m_owner.QueueEvent(audioEventFootwear);
  };
  audioEventFoley = new AudioEvent();
  audioEventFoley.eventName = n"equipItem";
  audioEventFoley.nameData = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)).AppearanceName();
  this.m_owner.QueueEvent(audioEventFoley);
  paperdollEquipData.equipArea = this.m_equipment.equipAreas[equipAreaIndex];
  paperdollEquipData.equipped = ShouldBeDisplayed(itemID); // <- tweaks visibility here
  paperdollEquipData.placementSlot = placementSlot;
  paperdollEquipData.slotIndex = slotIndex;
  this.ApplyEquipGLPs(itemID);
  this.UpdateWeaponWheel();
  this.UpdateQuickWheel();
  this.UpdateEquipmentUIBB(paperdollEquipData);
  i = 0;
  while i < ArraySize(this.m_hotkeys) {
    if this.m_hotkeys[i].IsCompatible(itemData.GetItemType()) {
      this.AssignItemToHotkey(itemData.GetID(), this.m_hotkeys[i].GetHotkey());
    };
    i += 1;
  };
  EquipmentSystem.GetInstance(this.m_owner).Debug_FillESSlotData(slotIndex, this.m_equipment.equipAreas[equipAreaIndex].areaType, itemID, this.m_owner);
  if ItemID.IsValid(currentItem) && currentItem != itemID {
    transactionSystem.OnItemRemovedFromEquipmentSlot(this.m_owner, currentItem);
  };
  transactionSystem.OnItemAddedToEquipmentSlot(this.m_owner, itemID);
  if this.IsItemOfCategory(itemID, gamedataItemCategory.Cyberware) {
    this.CheckCyberjunkieAchievement();
  };
}

// Tweak IsItemHidden to check headgear
@replaceMethod(EquipmentSystemPlayerData)
public final func IsItemHidden(id: ItemID) -> Bool {
  return ArrayContains(this.m_hiddenItems, id) || ShouldBeHidden(id);
}


// -- GameObject

// Clear head item slot to fix TPP hair displaying
@addMethod(GameObject)
public func ClearHeadGearSlot() -> Void {
  let transactionSystem: ref<TransactionSystem>;
  transactionSystem = GameInstance.GetTransactionSystem(this.GetGame());
  transactionSystem.RemoveItemFromSlot(this, t"AttachmentSlots.Head");
}

// Reequip headgear item
@addMethod(GameObject)
public func ReequipGear(area: gamedataEquipmentArea) -> Void {
  let equipmentSystem: ref<EquipmentSystemPlayerData>;
  let activeItemId: ItemID;
  let slotIndex: Int32;
  let unequipRequest: ref<UnequipRequest>;
  let equipRequest: ref<EquipRequest>;

  equipmentSystem = EquipmentSystem.GetData(GetPlayer(this.GetGame()));
  activeItemId = equipmentSystem.GetActiveItem(area);
  slotIndex = equipmentSystem.GetSlotIndex(activeItemId, area);

  if NotEquals(equipmentSystem, null) && NotEquals(activeItemId, null) {    
    L("Detected head item: " + ToStr(activeItemId));
    
    unequipRequest = new UnequipRequest();
    unequipRequest.slotIndex = slotIndex;
    unequipRequest.areaType = area;
    equipmentSystem.OnUnequipRequest(unequipRequest);

    equipRequest = new EquipRequest();
    equipRequest.slotIndex = slotIndex;
    equipRequest.itemID = activeItemId;
    equipmentSystem.OnEquipRequest(equipRequest);
  };
}

// -- EquipmentSystem

@replaceMethod(EquipmentSystem)
private final const func GetHairSuffix(itemId: ItemID, owner: wref<GameObject>, suffixRecord: ref<ItemsFactoryAppearanceSuffixBase_Record>) -> String {
  let customizationState: ref<gameuiICharacterCustomizationState>;
  let characterCustomizationSystem: ref<gameuiICharacterCustomizationSystem> = GameInstance.GetCharacterCustomizationSystem(owner.GetGame());
  let isMountedToVehicle: Bool = VehicleComponent.IsMountedToVehicle(owner.GetGame(), owner.GetEntityID());
  // Dirty hack: break hair suffux for vehicle TPP view to fix hair displaying on save loading
  if isMountedToVehicle {
    return "";
  };
  if (owner as PlayerPuppet) == null && !characterCustomizationSystem.HasCharacterCustomizationComponent(owner) {
    return "Bald";
  };
  customizationState = characterCustomizationSystem.GetState();
  if customizationState != null {
    if customizationState.HasTag(n"Short") {
      return "Short";
    };
    if customizationState.HasTag(n"Long") {
      return "Long";
    };
    if customizationState.HasTag(n"Dreads") {
      return "Dreads";
    };
    if customizationState.HasTag(n"Buzz") {
      return "Buzz";
    };
    return "Bald";
  };
  return "Error";
}

// -- PlayerPuppet

// Reequip headgear to make sure that all stats and mods applied
@replaceMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  this.SetInvisible(false);
  GameInstance.GetGodModeSystem(this.GetGame()).RemoveGodMode(this.GetEntityID(), gameGodModeType.Invulnerable, n"GracePeriodAfterSpawn");
  this.ReequipGear(gamedataEquipmentArea.Head);
  this.ReequipGear(gamedataEquipmentArea.Face);
  PrintPlayerStats("OnMakePlayerVisibleAfterSpawn", this);
}

// -- inkMotorcycleHUDGameController

// Clears head slot when mounted to vehicle, should fix TPP bald head
@replaceMethod(inkMotorcycleHUDGameController)
protected cb func OnVehicleMounted() -> Bool {
  let bbSys: ref<BlackboardSystem>;
  let playerPuppet: wref<PlayerPuppet>;
  let shouldConnect: Bool;
  let vehicle: wref<VehicleObject>;
  this.m_fluffBlinking = new inkAnimController();
  this.m_fluffBlinking.Select(this.m_lowerfluff_L).Select(this.m_lowerfluff_R).Interpolate(n"transparency", ToVariant(0.25), ToVariant(1.00)).Duration(0.50).Interpolate(n"transparency", ToVariant(1.00), ToVariant(0.25)).Delay(0.55).Duration(0.50).Type(inkanimInterpolationType.Linear).Mode(inkanimInterpolationMode.EasyIn);
  playerPuppet = this.GetOwnerEntity() as PlayerPuppet;
  vehicle = GetMountedVehicle(playerPuppet);
  bbSys = GameInstance.GetBlackboardSystem(playerPuppet.GetGame());
  if shouldConnect {
    this.m_vehicleBlackboard = vehicle.GetBlackboard();
    this.m_activeVehicleUIBlackboard = bbSys.Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  };
  if IsDefined(this.m_vehicleBlackboard) {
    this.m_vehicleBBStateConectionId = this.m_vehicleBlackboard.RegisterListenerInt(GetAllBlackboardDefs().Vehicle.VehicleState, this, n"OnVehicleStateChanged");
    this.m_speedBBConnectionId = this.m_vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnSpeedValueChanged");
    this.m_gearBBConnectionId = this.m_vehicleBlackboard.RegisterListenerInt(GetAllBlackboardDefs().Vehicle.GearValue, this, n"OnGearValueChanged");
    this.m_rpmValueBBConnectionId = this.m_vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.RPMValue, this, n"OnRpmValueChanged");
    this.m_leanAngleBBConnectionId = this.m_vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.BikeTilt, this, n"OnLeanAngleChanged");
    this.m_tppBBConnectionId = this.m_activeVehicleUIBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this, n"OnCameraModeChanged");
    this.m_playerStateBBConnectionId = this.m_activeVehicleUIBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_ActiveVehicleData.VehPlayerStateData, this, n"OnPlayerStateChanged");
  };

  if IsDefined(playerPuppet) {
    playerPuppet.ClearHeadGearSlot();
  };
}

// Reequips headgear when unmounted
@replaceMethod(inkMotorcycleHUDGameController)
protected cb func OnVehicleUnmounted() -> Bool {
  let playerPuppet: wref<PlayerPuppet>;
  playerPuppet = this.GetOwnerEntity() as PlayerPuppet;
  if IsDefined(this.m_vehicleBlackboard) {
    this.m_vehicleBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().Vehicle.VehicleState, this.m_vehicleBBStateConectionId);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this.m_speedBBConnectionId);
    this.m_vehicleBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().Vehicle.GearValue, this.m_gearBBConnectionId);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.RPMValue, this.m_rpmValueBBConnectionId);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.BikeTilt, this.m_leanAngleBBConnectionId);
    this.m_activeVehicleUIBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this.m_tppBBConnectionId);
    this.m_activeVehicleUIBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_ActiveVehicleData.VehPlayerStateData, this.m_playerStateBBConnectionId);
  };

  if IsDefined(playerPuppet) {
    playerPuppet.ReequipGear(gamedataEquipmentArea.Head);
  };
}


// -- TakeOverControlSystem

// Test fix bald head for hacked camera TPP view
@replaceMethod(TakeOverControlSystem)
private final const func EnablePlayerTPPRepresenation(enable: Bool) -> Void {
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  if IsDefined(player) {
    if enable {
      player.QueueEvent(new ActivateTPPRepresentationEvent());
      player.ClearHeadGearSlot();
      GameInstance.GetAudioSystem(this.GetGameInstance()).SetBDCameraListenerOverride(true);
      GameObject.StartEffectEvent(player, n"camera_mask");
    } else {
      player.QueueEvent(new DeactivateTPPRepresentationEvent());
      player.ReequipGear(gamedataEquipmentArea.Head);
      GameInstance.GetAudioSystem(this.GetGameInstance()).SetBDCameraListenerOverride(false);
      GameObject.StopEffectEvent(player, n"camera_mask");
    };
  };
}

// Test fix bald head for mirror TPP view
@replaceMethod(InteractiveDevice)
protected cb func OnPerformedAction(evt: ref<PerformedAction>) -> Bool {
  let playerPuppet: ref<PlayerPuppet>;
  let actionName: CName;
  let currentContext: GetActionsContext;
  let sDeviceAction: ref<ScriptableDeviceAction>;
  super.OnPerformedAction(evt);
  sDeviceAction = evt.m_action as ScriptableDeviceAction;
  if IsDefined(sDeviceAction) && this.GetDevicePS().HasActiveContext(gamedeviceRequestType.Direct) || this.GetDevicePS().HasActiveContext(gamedeviceRequestType.Remote) {
    currentContext = this.GetDevicePS().GenerateContext(sDeviceAction.GetRequestType(), Device.GetInteractionClearance(), sDeviceAction.GetExecutor());
    this.DetermineInteractionState(currentContext);
  };

  playerPuppet = (GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet);
  actionName = evt.m_action.actionName;

  if IsDefined(playerPuppet) && Equals(actionName, n"ForceON") {
    L("Device activated ");
    playerPuppet.ClearHeadGearSlot();
  } else {
    if IsDefined(playerPuppet) && Equals(actionName, n"ForceOFF") {
      L("Device deactivated");
      playerPuppet.ReequipGear(gamedataEquipmentArea.Head);
    };
  };
}
