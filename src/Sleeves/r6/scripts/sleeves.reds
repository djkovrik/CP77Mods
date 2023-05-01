module Sleeves
@if(ModuleExists("EquipmentEx"))
import EquipmentEx.OutfitSystem

public class SleevesConfig {

  @runtimeProperty("ModSettings.mod", "Sleeves")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Devices-Interactions-Disable")
  public let disabled: Bool = false;

  @runtimeProperty("ModSettings.mod", "Sleeves")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-Cyberware")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_NanoWires")
  public let compatNanoWires: Bool = true;

  @runtimeProperty("ModSettings.mod", "Sleeves")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-Cyberware")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_StrongArms")
  public let compatStrongArms: Bool = true;

  @runtimeProperty("ModSettings.mod", "Sleeves")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-Cyberware")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_Launcher")
  public let compatLauncher: Bool = true;

  @runtimeProperty("ModSettings.mod", "Sleeves")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-Cyberware")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_MantisBlades")
  public let compatMantis: Bool = false;

  @runtimeProperty("ModSettings.mod", "Sleeves")
  @runtimeProperty("ModSettings.category", "Gameplay-Items-Item Type-Gen_Misc")
  @runtimeProperty("ModSettings.displayName", "UI-Settings-Language-Debug")
  public let showDebugLogs: Bool = false;

  public static func IncompatibleCyberware() -> array<gamedataItemType> {
    let config: ref<SleevesConfig> = new SleevesConfig();
    let result: array<gamedataItemType>;
    if !config.compatNanoWires { ArrayPush(result, gamedataItemType.Cyb_NanoWires); }
    if !config.compatStrongArms { ArrayPush(result, gamedataItemType.Cyb_StrongArms); }
    if !config.compatLauncher { ArrayPush(result, gamedataItemType.Cyb_Launcher); }
    if !config.compatMantis { ArrayPush(result, gamedataItemType.Cyb_MantisBlades); }
    return result;
  }

  public static func IsModDisabled() -> Bool {
    let config: ref<SleevesConfig> = new SleevesConfig();
    return config.disabled;
  }

  public static func IsDebugLogsEnabled() -> Bool {
    let config: ref<SleevesConfig> = new SleevesConfig();
    return config.showDebugLogs;
  }
}

private class SleevesSlots {
  public static func Normal() -> array<TweakDBID> = [
    t"AttachmentSlots.Outfit",
    t"AttachmentSlots.Torso", 
    t"AttachmentSlots.Chest"
  ]

  public static func EqEx() -> array<TweakDBID> = [
    t"OutfitSlots.TorsoOuter",
    t"OutfitSlots.TorsoMiddle",
    t"OutfitSlots.TorsoInner",
    t"OutfitSlots.TorsoUnder",
    t"OutfitSlots.BodyOuter",
    t"OutfitSlots.BodyMiddle",
    t"OutfitSlots.BodyInner",
    t"OutfitSlots.BodyUnder"
  ]
}

// Equipment exclusion list
private class SleevesExclusions {
  public static func Has(itemID: ItemID) -> Bool {
    let id: TweakDBID = ItemID.GetTDBID(itemID);
    return
      Equals(id, t"Items.Q101_Recovery_Bandage_Outfit") ||  // Bandage Wrapping
      Equals(id, t"Items.Jacket_01_basic_02") ||            // Biker Vibe Composite-Lined Crystaljock Bomber
      Equals(id, t"Items.SQ030_Diving_Suit") ||             // Judy's Diving Suit
      Equals(id, t"Items.sq030_diving_suit_female") ||      // Judy's Diving Suit
      Equals(id, t"Items.sq030_diving_suit_male") ||        // Judy's Diving Suit
      Equals(id, t"Items.SQ030_Diving_Suit_NoShoes") ||     // Judy's Diving Suit
      Equals(id, t"Items.MQ049_martinez_jacket") ||         // David's Jacket
      Equals(id, t"Items.nd_alt_jacket_default") ||         // ND Alt's Jacket
      Equals(id, t"Items.nd_alt_jacket_black") ||           // ND Alt's Jacket
      Equals(id, t"Items.nd_alt_jacket_blue") ||            // ND Alt's Jacket
      Equals(id, t"Items.nd_alt_jacket_green") ||           // ND Alt's Jacket
      Equals(id, t"Items.nd_alt_jacket_pink") ||            // ND Alt's Jacket
      Equals(id, t"Items.nd_alt_jacket_red") ||             // ND Alt's Jacket
      Equals(id, t"Items.nd_alt_jacket_white") ||           // ND Alt's Jacket
      Equals(id, t"Items.nd_alt_jacket_burgundy") ||        // ND Alt's Jacket
      Equals(id, t"Items.nd_alt_jacket_brown") ||           // ND Alt's Jacket
    false;
  }
}

@if(ModuleExists("EquipmentEx"))
@addMethod(PlayerPuppet)
public func GetSleevesSlots() -> array<TweakDBID> {
  if OutfitSystem.GetInstance(this.GetGame()).IsActive() {
    return SleevesSlots.EqEx();
  };

  return SleevesSlots.Normal();
}

@if(!ModuleExists("EquipmentEx"))
@addMethod(PlayerPuppet)
public func GetSleevesSlots() -> array<TweakDBID> {
  return SleevesSlots.Normal();
}

private class SleevedSlotInfo {
  let itemID: ItemID;
  let appearance: CName;

  public static func Create(itemID: ItemID, appearance: CName) -> ref<SleevedSlotInfo> {
    let self: ref<SleevedSlotInfo> = new SleevedSlotInfo();
    self.itemID = itemID;
    self.appearance = appearance;
    return self;
  }
}

public class DelayedSleevesCallback extends DelayCallback {
  let sleevesSystem: ref<SleevesControlSystem>;
  public func Call() -> Void {
    this.sleevesSystem.RunAppearanceSwap();
  }
}

public class SleevesControlSystem extends ScriptableSystem {
  private let playerPuppet: wref<PlayerPuppet>;
  private let transactionSystem: wref<TransactionSystem>;
  private let delaySystem: wref<DelaySystem>;
  private let appearances: ref<inkHashMap>;
  private let hasLauncher: Bool;
  private let delayId: DelayID;

  public static func GetInstance(gi: GameInstance) -> ref<SleevesControlSystem> {
    let system: ref<SleevesControlSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"Sleeves.SleevesControlSystem") as SleevesControlSystem;
    return system;
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.playerPuppet = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    this.transactionSystem = GameInstance.GetTransactionSystem(request.owner.GetGame());
    this.delaySystem = GameInstance.GetDelaySystem(request.owner.GetGame());
    this.appearances = new inkHashMap();
    this.hasLauncher = false;
  }

  private final func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
    this.delaySystem.CancelCallback(this.delayId);
    this.playerPuppet = null;
    this.transactionSystem = null;
    this.delaySystem = null;
    this.appearances = null;
  }

  public func SetHasLauncher(value: Bool) -> Void {
    this.hasLauncher = value;
  }

  public func RunAppearanceSwapDelayed() -> Void {
    let callback: ref<DelayedSleevesCallback> = new DelayedSleevesCallback();
    callback.sleevesSystem = this;
    this.delaySystem.CancelCallback(this.delayId);
    this.delayId = this.delaySystem.DelayCallback(callback, 0.5);
  }

  public func RunAppearanceSwap() -> Void {
    if this.HasIncompatibleCyberware() || this.hasLauncher || SleevesConfig.IsModDisabled() {
      this.ResetItemAppearances();
      return ;
    };

    this.SwapTargetSlotsToTPP();
  }

  private func ResetItemAppearances() -> Void {
    let slots: array<TweakDBID> = this.playerPuppet.GetSleevesSlots();
    let itemObject: ref<ItemObject>;
    let itemID: ItemID;
    for slot in slots {
      itemObject = this.transactionSystem.GetItemInSlot(this.playerPuppet, slot);
      if IsDefined(itemObject) {
        itemID = itemObject.GetItemID();
        this.transactionSystem.ResetItemAppearance(this.playerPuppet, itemID);
      };
    };
  }

  private func SwapTargetSlotsToTPP() -> Void {
    let slots: array<TweakDBID> = this.playerPuppet.GetSleevesSlots();
    for slot in slots {
      if this.SwapItemAppearance(slot) {
        return ;
      };
    };
  }

  private func SwapItemAppearance(slot: TweakDBID) -> Bool {
    let itemObject: ref<ItemObject> = this.transactionSystem.GetItemInSlot(this.playerPuppet, slot);
    if !IsDefined(itemObject) {
      return false;
    };

    let itemID: ItemID = itemObject.GetItemID();
    if SleevesExclusions.Has(itemID) {
      return true;
    };

    let name: String = GetLocalizedTextByKey(RPGManager.GetItemRecord(itemID).DisplayName());
    let appearanceBase: CName = this.transactionSystem.GetItemAppearance(this.playerPuppet, itemID);
    let hasFpp: Bool = this.HasFppSuffux(appearanceBase);
    let hasPart: Bool = this.HasPartSuffux(appearanceBase);
    this.Log(s"Trying to swap \(name) at \(TDBID.ToStringDEBUG(slot))...");
    this.Log(s" - current appearance: \(appearanceBase)");

    let key: Uint64 = this.Hash(itemID);
    let info: ref<SleevedSlotInfo>;

    if this.appearances.KeyExist(key) {
      info = this.appearances.Get(key) as SleevedSlotInfo;
      this.Log(s" - existing appearance found: \(info.appearance)");
      this.transactionSystem.ChangeItemAppearanceByName(this.playerPuppet, itemID, info.appearance);
      return hasFpp;
    };

    this.Log(" - existing appearance not found, creating a new one...");
    this.Log(s" --- base: \(appearanceBase), has fpp: \(hasFpp), has part: \(hasPart)");
    let appearanceTpp: CName = this.SwapSuffixToTpp(appearanceBase);
    this.Log(s" --- TPP: \(appearanceTpp)");
    let appearanceFull: CName = this.SwapSuffixToFull(appearanceTpp);
    this.Log(s" --- FULL: \(appearanceFull)");
    this.appearances.Insert(key, SleevedSlotInfo.Create(itemID, appearanceFull));
    this.transactionSystem.ChangeItemAppearanceByName(this.playerPuppet, itemID, appearanceFull);
    this.Log(s" - new appearance applied: \(appearanceFull)");
    return hasFpp;
  }

  private func HasFppSuffux(appearance: CName) -> Bool {
    let appearanceString: String = NameToString(appearance);
    return StrContains(appearanceString, "&FPP");
  }

  private func SwapSuffixToTpp(appearance: CName) -> CName {
    let appearanceString: String = NameToString(appearance);
    let newAppearanceString: String;
    if this.HasFppSuffux(appearance) {
      newAppearanceString = StrReplace(appearanceString, "&FPP", "&TPP");
    } else {
      return appearance;
    };

    return StringToName(newAppearanceString);
  }

  private func HasPartSuffux(appearance: CName) -> Bool {
    let appearanceString: String = NameToString(appearance);
    return StrContains(appearanceString, "&Part");
  }

  private func SwapSuffixToFull(appearance: CName) -> CName {
    let appearanceString: String = NameToString(appearance);
    let newAppearanceString: String;
    if this.HasPartSuffux(appearance) {
      newAppearanceString = StrReplace(appearanceString, "&Part", "&Full");
    } else {
      return appearance;
    };

    return StringToName(newAppearanceString);
  }


  private final func Hash(itemID: ItemID) -> Uint64 {
    return ItemID.GetCombinedHash(itemID);
  }

  private final func IsCyberwareTypeIncompatible(type: gamedataItemType) -> Bool {
    for target in SleevesConfig.IncompatibleCyberware() {
      if Equals(target, type) {
        return true;
      };
    };

    return false;
  }

  private final func HasIncompatibleCyberware() -> Bool {
    let armsCW: gamedataItemType = RPGManager.GetItemType(EquipmentSystem.GetInstance(this.playerPuppet).GetActiveItem(this.playerPuppet, gamedataEquipmentArea.ArmsCW));
    return this.IsCyberwareTypeIncompatible(armsCW);
  }

  private func Log(str: String) -> Void {
    if SleevesConfig.IsDebugLogsEnabled() {
      LogChannel(n"DEBUG", s"Sleeves: \(str)");
    };
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  SleevesControlSystem.GetInstance(this.GetGame()).RunAppearanceSwapDelayed();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnEquipmentSystemWeaponManipulationRequest(request: ref<EquipmentSystemWeaponManipulationRequest>) -> Void {
  wrappedMethod(request);
  SleevesControlSystem.GetInstance(this.m_owner.GetGame()).RunAppearanceSwapDelayed();
}

@wrapMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  wrappedMethod(itemID, slotIndex, blockActiveSlotsUpdate, forceEquipWeapon);
  SleevesControlSystem.GetInstance(this.m_owner.GetGame()).RunAppearanceSwapDelayed();
}

@wrapMethod(EquipmentSystemPlayerData)
private final func UnequipItem(equipAreaIndex: Int32, opt slotIndex: Int32) -> Void {
  wrappedMethod(equipAreaIndex, slotIndex);
  SleevesControlSystem.GetInstance(this.m_owner.GetGame()).RunAppearanceSwapDelayed();
}

@wrapMethod(EquipmentSystemPlayerData)
private final func SendEquipAudioEvents(itemID: ItemID) -> Void {
  wrappedMethod(itemID);
  SleevesControlSystem.GetInstance(this.m_owner.GetGame()).RunAppearanceSwapDelayed();
}

@wrapMethod(EquipmentSystemPlayerData)
private final func SendUnequipAudioEvents(itemID: ItemID) -> Void {
  wrappedMethod(itemID);
  SleevesControlSystem.GetInstance(this.m_owner.GetGame()).RunAppearanceSwapDelayed();
}


// --- Cyberware helpers

@addMethod(UpperBodyTransition)
public final static func HasLauncherEquipped(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let weapon: ref<WeaponObject> = scriptInterface.GetTransactionSystem().GetItemInSlot(scriptInterface.executionOwner, t"AttachmentSlots.WeaponRight") as WeaponObject;
  let armsCW: gamedataItemType = RPGManager.GetItemType(EquipmentSystem.GetInstance(scriptInterface.executionOwner).GetActiveItem(scriptInterface.executionOwner, gamedataEquipmentArea.ArmsCW));
  let weaponType: gamedataItemType;
  if IsDefined(weapon) {
    weaponType = scriptInterface.GetTransactionSystem().GetItemData(scriptInterface.executionOwner, weapon.GetItemID()).GetItemType();
    if Equals(weaponType, gamedataItemType.Wea_Fists) && Equals(armsCW, gamedataItemType.Cyb_Launcher) {
      return true;
    };
  };
  return false;
}

@addMethod(UpperBodyEventsTransition)
private func UpdateCyberwareState(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let container: ref<ScriptableSystemsContainer> = GameInstance.GetScriptableSystemsContainer(scriptInterface.executionOwner.GetGame());
  let sleevesSystem: ref<SleevesControlSystem> =  container.Get(n"Sleeves.SleevesControlSystem") as SleevesControlSystem;
  let launcher: Bool = UpperBodyTransition.HasLauncherEquipped(scriptInterface);
  sleevesSystem.SetHasLauncher(launcher);
  sleevesSystem.RunAppearanceSwap();
}

@wrapMethod(UpperBodyEventsTransition)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.UpdateCyberwareState(scriptInterface);
}

@wrapMethod(UpperBodyEventsTransition)
protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.UpdateCyberwareState(scriptInterface);
}


// --- Refresh for vehicles

@wrapMethod(VehicleComponent)
protected final func OnVehicleCameraChange(state: Bool) -> Void {
  wrappedMethod(state);
  SleevesControlSystem.GetInstance(this.GetVehicle().GetGame()).RunAppearanceSwapDelayed();
}
