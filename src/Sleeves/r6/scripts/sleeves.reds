private class SleevesConfig {
  public static func Exclude(itemID: ItemID) -> Bool {
    let id: TweakDBID = ItemID.GetTDBID(itemID);
    return
      // You can add item records below:
      Equals(id, t"Items.Q101_Recovery_Bandage_Outfit") ||  // Bandage Wrapping
      Equals(id, t"Items.Jacket_01_basic_02") ||            // Biker Vibe Composite-Lined Crystaljock Bomber
      Equals(id, t"Items.SQ030_Diving_Suit") ||             // Judy's Diving Suit
      Equals(id, t"Items.sq030_diving_suit_female") ||      // Judy's Diving Suit
      Equals(id, t"Items.sq030_diving_suit_male") ||        // Judy's Diving Suit
      Equals(id, t"Items.SQ030_Diving_Suit_NoShoes") ||     // Judy's Diving Suit
      false;
  }
  public static func TargetSlots() -> array<gamedataEquipmentArea> = [
    // gamedataEquipmentArea.Head,
    // gamedataEquipmentArea.Face,
    // gamedataEquipmentArea.Legs,
    // gamedataEquipmentArea.Feet,
    gamedataEquipmentArea.InnerChest,
    gamedataEquipmentArea.OuterChest,
    gamedataEquipmentArea.Outfit
  ]
  public static func IncompatibleCyberware() -> array<gamedataItemType> = [
    // gamedataItemType.Cyb_NanoWires,
    // gamedataItemType.Cyb_StrongArms,
    gamedataItemType.Cyb_Launcher,
    gamedataItemType.Cyb_MantisBlades
  ]
}

// -- Swap substrings inside item appearance name
@addMethod(EquipmentSystemPlayerData)
private func SwapItemAppearance(itemID: ItemID, from: String, to: String) -> Void {
  if SleevesConfig.Exclude(itemID) {
    return ;
  };
  let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
  let appearanceString: String = ToString(ts.GetItemAppearance(this.m_owner, itemID));
  let newAppearanceString: String;
  if StrFindLast(appearanceString, from) != -1 {
    newAppearanceString = StrReplace(appearanceString, from, to);
    ts.ChangeItemAppearance(this.m_owner, itemID, StringToName(newAppearanceString));
    this.OnEquipProcessVisualTags(itemID);
  };
}

// -- Swap item appearance from target slots to FPP variant
@addMethod(EquipmentSystemPlayerData)
public func SwapTargetSlotsToFPP() -> Void {
  for slot in SleevesConfig.TargetSlots() {
    this.SwapItemAppearance(this.GetActiveItem(slot), "&TPP", "&FPP");
  };
}

// -- Swap item appearance from target slots to TPP variant
@addMethod(EquipmentSystemPlayerData)
public func SwapTargetSlotsToTPP() -> Void {
  for slot in SleevesConfig.TargetSlots() {
    this.SwapItemAppearance(this.GetActiveItem(slot), "&FPP", "&TPP");
  };
}

// -- Check if equipment slot must me switched to TPP appearance
private static func IsTargetSlot(slot: gamedataEquipmentArea) -> Bool {
  for target in SleevesConfig.TargetSlots() {
    if Equals(target, slot) {
      return true;
    };
  };
  return false;
}

// -- Set TPP variant for specified slots items on equip event
@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToSlot(evt: ref<ItemAddedToSlot>) -> Bool {
  wrappedMethod(evt);
  let targetItemId: ItemID = evt.GetItemID();
  let targetItemArea: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(targetItemId);
  let playerData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(this);
  if IsTargetSlot(targetItemArea) && IsDefined(playerData) {
    playerData.SwapTargetSlotsToTPP();
  };
}

// -- Check cyberware compatibility
@addMethod(EquipmentSystemPlayerData)
private final func IsCyberwareTypIncompatible(type: gamedataItemType) -> Bool {
  for target in SleevesConfig.IncompatibleCyberware() {
    if Equals(target, type) {
      return true;
    };
  };
}

// -- Check if player has incompatible arms cyberware
@addMethod(EquipmentSystemPlayerData)
private final func HasIncompatibleCyberware() -> Bool {
  let equipArea: SEquipArea = this.m_equipment.equipAreas[this.GetEquipAreaIndex(gamedataEquipmentArea.ArmsCW)];
  let i: Int32 = 0;
  let moduleID: ItemID;
  let moduleRecord: ref<Item_Record>;
  while i < this.GetNumberOfSlots(gamedataEquipmentArea.ArmsCW) {
    moduleID = equipArea.equipSlots[i].itemID;
    if ItemID.IsValid(moduleID) {
      moduleRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(moduleID));
      if this.IsCyberwareTypIncompatible(moduleRecord.ItemType().Type()) {
        return true;
      };
    } else {
      moduleID = this.GetActiveGadget();
      if ItemID.IsValid(moduleID) {
        moduleRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(moduleID));
        if this.IsCyberwareTypIncompatible(moduleRecord.ItemType().Type()) {
          return true;
        };
      };
    };
    i += 1;
  };
  return false;
}

// -- Check for incompatible cyberware while weapons manipulations and switch to FPP variant if needed
@wrapMethod(EquipmentSystemPlayerData)
public final func OnEquipmentSystemWeaponManipulationRequest(request: ref<EquipmentSystemWeaponManipulationRequest>) -> Void {
  let targetItemId: ItemID = this.GetItemIDfromEquipmentManipulationAction(request.requestType);
  let targetItemArea: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(targetItemId);
  let targetItemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(targetItemId));
  let targetItemType: gamedataItemType = targetItemRecord.ItemType().Type();

  if NotEquals(targetItemArea, gamedataEquipmentArea.Weapon) && this.HasIncompatibleCyberware() {
    this.SwapTargetSlotsToFPP();
  } else {
    this.SwapTargetSlotsToTPP();
  };

  wrappedMethod(request);
}

// -- Set TPP appearance after vehicle mounting/unmounting events
@wrapMethod(VehicleComponent)
protected final func ManageAdditionalAnimFeatures(object: ref<GameObject>, value: Bool) -> Void {
  wrappedMethod(object, value);
  EquipmentSystem.GetData(GetPlayer(object.GetGame())).SwapTargetSlotsToTPP();
}

private static func SLog(str: String) -> Void {
  LogChannel(n"DEBUG", "Sleeves: " + str);
}
