import ExtraWardrobeSlots.Utils.W


@addField(EquipmentSystemPlayerData)
private let m_wardrobeSystemExtra: ref<WardrobeSystemExtra>;

@addField(EquipmentSystemPlayerData)
private persistent let m_lastActiveWardrobeSetExtra: gameWardrobeClothingSetIndexExtra;

@wrapMethod(EquipmentSystemPlayerData)
public final func OnAttach() -> Void {
  wrappedMethod();
  if IsDefined(this.m_owner as PlayerPuppet) {
    this.m_wardrobeSystemExtra = WardrobeSystemExtra.GetInstance(this.m_owner.GetGame());
  };
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnRestored() -> Void {
  wrappedMethod();
  this.m_wardrobeSystemExtra = WardrobeSystemExtra.GetInstance(this.m_owner.GetGame());
}

@addMethod(EquipmentSystemPlayerData)
public final const func GetActiveWardrobeSetExtra() -> ref<ClothingSetExtra> {
  let set: ref<ClothingSetExtra>;
  if this.IsVisualSetActive() {
    set = this.m_wardrobeSystemExtra.GetActiveClothingSet();
  } else {
    set = new ClothingSetExtra();
  };
  return set;
}

@replaceMethod(EquipmentSystemPlayerData)
public final func OnQuestDisableWardrobeSetRequest(request: ref<QuestDisableWardrobeSetRequest>) -> Void {
  this.m_wardrobeDisabled = request.blockReequipping;
  if this.IsVisualSetActive() {
    this.m_lastActiveWardrobeSetExtra = this.m_wardrobeSystemExtra.GetActiveClothingSetIndex();
    this.UnequipWardrobeSetExtra();
  };
}

@replaceMethod(EquipmentSystemPlayerData)
public final func OnQuestRestoreWardrobeSetRequest(request: ref<QuestRestoreWardrobeSetRequest>) -> Void {
  this.m_wardrobeDisabled = false;
  if NotEquals(this.m_lastActiveWardrobeSetExtra, gameWardrobeClothingSetIndexExtra.INVALID) {
    this.EquipWardrobeSetExtra(this.m_lastActiveWardrobeSetExtra);
    this.m_lastActiveWardrobeSetExtra = gameWardrobeClothingSetIndexExtra.INVALID;
  };
}

@addMethod(EquipmentSystemPlayerData)
public final func EquipWardrobeSetExtra(setID: gameWardrobeClothingSetIndexExtra) -> Void {
  let i: Int32;
  let outfitData: wref<gameItemData>;
  let visualItem: ItemID;
  let clothingSet: ref<ClothingSetExtra> = this.FindWardrobeClothingSetByIDExtra(setID);
  let outfit: ItemID = this.GetActiveItem(gamedataEquipmentArea.Outfit);
  if this.m_wardrobeDisabled || Equals(setID, gameWardrobeClothingSetIndexExtra.INVALID) || ArraySize(clothingSet.clothingList) == 0 {
    return;
  };
  if ItemID.IsValid(outfit) {
    outfitData = GameInstance.GetTransactionSystem(this.m_owner.GetGame()).GetItemData(this.m_owner, outfit);
  };
  if IsDefined(outfitData) && outfitData.HasTag(n"UnequipBlocked") {
    return;
  };
  if ItemID.IsValid(outfit) {
    this.UnequipItem(outfit);
  };
  this.m_wardrobeSystemExtra.SetActiveClothingSetIndex(setID);
  i = 0;
  while i <= ArraySize(clothingSet.clothingList) {
    visualItem = clothingSet.clothingList[i].visualItem;
    if ItemID.IsValid(visualItem) {
      this.EquipVisuals(visualItem);
    } else {
      this.ClearVisuals(clothingSet.clothingList[i].areaType);
    };
    i += 1;
  };
}

@addMethod(EquipmentSystemPlayerData)
public final const func FindWardrobeClothingSetByIDExtra(setID: gameWardrobeClothingSetIndexExtra) -> ref<ClothingSetExtra> {
  let clothingSets: array<ref<ClothingSetExtra>> = this.m_wardrobeSystemExtra.GetClothingSets();
  let i: Int32 = 0;
  while i <= ArraySize(clothingSets) {
    if Equals(clothingSets[i].setID, setID) {
      return clothingSets[i];
    };
    i += 1;
  };
  return new ClothingSetExtra();
}

@addMethod(EquipmentSystemPlayerData)
public final func UnequipWardrobeSetExtra() -> Void {
  let i: Int32;
  let currentSet: ref<ClothingSetExtra> = this.GetActiveWardrobeSetExtra();
  if NotEquals(this.m_wardrobeSystemExtra.GetActiveClothingSetIndex(), gameWardrobeClothingSetIndexExtra.INVALID) {
    this.m_visualUnequipTransition = true;
    i = 0;
    while i <= ArraySize(currentSet.clothingList) {
      this.UnequipVisuals(currentSet.clothingList[i].areaType);
      i += 1;
    };
    this.m_visualUnequipTransition = false;
    this.m_wardrobeSystemExtra.SetActiveClothingSetIndex(gameWardrobeClothingSetIndexExtra.INVALID);
  };
}

@replaceMethod(EquipmentSystem)
private final func OnEquipWardrobeSetRequest(request: ref<EquipWardrobeSetRequest>) -> Void {
  let playerData: ref<EquipmentSystemPlayerData> = this.GetPlayerData(request.owner);
  playerData.EquipWardrobeSetExtra(request.setIDExtra);
}

@replaceMethod(EquipmentSystem)
private final func OnUnequipWardrobeSetRequest(request: ref<UnequipWardrobeSetRequest>) -> Void {
  let playerData: ref<EquipmentSystemPlayerData> = this.GetPlayerData(request.owner);
  playerData.UnequipWardrobeSetExtra();
}

@addMethod(EquipmentSystemPlayerData)
public final func DeleteWardrobeSetExtra(setID: gameWardrobeClothingSetIndexExtra) -> Void {
  if Equals(this.m_wardrobeSystemExtra.GetActiveClothingSetIndex(), setID) {
    this.UnequipWardrobeSet();
  };
  this.m_wardrobeSystemExtra.DeleteClothingSet(setID);
}

@replaceMethod(EquipmentSystem)
private final func OnDeleteWardrobeSetRequest(request: ref<DeleteWardrobeSetRequest>) -> Void {
  let playerData: ref<EquipmentSystemPlayerData> = this.GetPlayerData(request.owner);
  playerData.DeleteWardrobeSetExtra(request.setIDExtra);
}

@replaceMethod(EquipmentSystemPlayerData)
public final const func IsVisualSetActive() -> Bool {
  let activeClothingSetIndex: gameWardrobeClothingSetIndexExtra = this.m_wardrobeSystemExtra.GetActiveClothingSetIndex();
  return NotEquals(activeClothingSetIndex, gameWardrobeClothingSetIndexExtra.INVALID);
}

@addMethod(EquipmentSystem)
private final func InitializeWardrobeDatabaseExtra() -> Void {
  let i: Int32;
  let itemList: array<wref<gameItemData>>;
  let transactionSystem: ref<TransactionSystem>;
  let wardrobeSystemExtra: ref<WardrobeSystemExtra>;
  let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
  if IsDefined(player) {
    transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
    transactionSystem.GetItemList(player, itemList);
    wardrobeSystemExtra = WardrobeSystemExtra.GetInstance(this.GetGameInstance());
    i = 0;
    while i < ArraySize(itemList) {
      if RPGManager.IsItemClothing(itemList[i].GetID()) {
        wardrobeSystemExtra.StoreUniqueItemIDAndMarkNew(this.GetGameInstance(), itemList[i].GetID());
      };
      i += 1;
    };
  };
}

@wrapMethod(EquipmentSystem)
private final func InitializeWardrobeDatabase() -> Void {
  wrappedMethod();
  this.InitializeWardrobeDatabaseExtra();
}

@addMethod(EquipmentSystem)
public final static func GetActiveWardrobeSetIDExtra(owner: ref<GameObject>) -> gameWardrobeClothingSetIndexExtra {
  return WardrobeSystemExtra.GetInstance(owner.GetGame()).GetActiveClothingSetIndex();
}

@addMethod(EquipmentSystem)
public final static func GetActiveWardrobeSetExtra(owner: ref<GameObject>) -> ref<ClothingSetExtra> {
  let playerData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(owner);
  return playerData.GetActiveWardrobeSetExtra();
}

@replaceMethod(EquipmentSystemPlayerData)
private final const func ShouldUnderwearBeVisibleInSet() -> Bool {
  let activeItem: ItemID;
  let tagCounter: Int32;
  let set: ref<ClothingSetExtra> = this.GetActiveWardrobeSetExtra();
  let i: Int32 = 0;
  while i < ArraySize(set.clothingList) {
    activeItem = set.clothingList[i].visualItem;
    if ItemID.IsValid(activeItem) && (Equals(set.clothingList[i].areaType, gamedataEquipmentArea.Legs) || this.HasUnderwearVisualTags(activeItem)) {
      tagCounter += 1;
    };
    i += 1;
  };
  return tagCounter == 0;
}

@replaceMethod(EquipmentSystemPlayerData)
private final const func ShouldUnderwearTopBeVisibleInSet() -> Bool {
  let activeItem: ItemID;
  let tagCounter: Int32;
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
  let set: ref<ClothingSetExtra> = this.GetActiveWardrobeSetExtra();
  let i: Int32 = 0;
  while i < ArraySize(set.clothingList) {
    activeItem = set.clothingList[i].visualItem;
    if ItemID.IsValid(activeItem) && (Equals(set.clothingList[i].areaType, gamedataEquipmentArea.InnerChest) || transactionSystem.MatchVisualTagByItemID(activeItem, this.m_owner, n"hide_T1")) {
      tagCounter += 1;
    };
    i += 1;
  };
  return tagCounter == 0;
}

@wrapMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  wrappedMethod(itemID, slotIndex, blockActiveSlotsUpdate, forceEquipWeapon);
  let equipmentArea: gamedataEquipmentArea;
  let itemData: wref<gameItemData> = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, itemID);
  if !this.IsEquippable(itemData) {
    return;
  };
  equipmentArea = EquipmentSystem.GetEquipAreaType(itemID);
  if Equals(equipmentArea, gamedataEquipmentArea.Outfit) && this.IsVisualSetActive() {
    this.UnequipWardrobeSetExtra();
  };
}

@addMethod(EquipmentSystemPlayerData)
public func InvalidateAppearance() -> Void {
  this.QuestRestoreSlot(gamedataEquipmentArea.Head);
  this.QuestRestoreSlot(gamedataEquipmentArea.Face);
  this.QuestRestoreSlot(gamedataEquipmentArea.Legs);
  this.QuestRestoreSlot(gamedataEquipmentArea.Feet);
  this.QuestRestoreSlot(gamedataEquipmentArea.OuterChest);
  this.QuestRestoreSlot(gamedataEquipmentArea.InnerChest);
  this.QuestRestoreSlot(gamedataEquipmentArea.Outfit);
}
