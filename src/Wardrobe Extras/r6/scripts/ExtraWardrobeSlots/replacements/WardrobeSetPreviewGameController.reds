@replaceMethod(WardrobeSetPreviewGameController)
public final func GetVisualItems() -> array<ItemID> {
  let i: Int32;
  let slots: array<gamedataEquipmentArea>;
  let visualItem: ItemID;
  let visualItems: array<ItemID>;
  let gi: GameInstance = this.GetGamePuppet().GetGame();
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(gi).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  let equipmentSystem: ref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"EquipmentSystem") as EquipmentSystem;
  let wardrobeSystem: ref<WardrobeSystemExtra> = WardrobeSystemExtra.GetInstance(gi);
  let clothingSet: ref<ClothingSetExtra> = wardrobeSystem.GetActiveClothingSet();
  if clothingSet != null {
    i = 0;
    while i < ArraySize(clothingSet.clothingList) {
      visualItem = clothingSet.clothingList[i].visualItem;
      if ItemID.IsValid(visualItem) {
        ArrayPush(visualItems, visualItem);
      };
      i += 1;
    };
  } else {
    slots = equipmentSystem.GetPaperDollSlots(player);
    i = 0;
    while i < ArraySize(slots) {
      visualItem = equipmentSystem.GetActiveVisualItem(player, slots[i]);
      if ItemID.IsValid(visualItem) {
        ArrayPush(visualItems, visualItem);
      };
      i += 1;
    };
  };
  return visualItems;
}

@replaceMethod(WardrobeSetPreviewGameController)
protected final func TryRestoreActiveWardrobeSet() -> Bool {
  let equipmentSystem: ref<EquipmentSystem>;
  let gi: GameInstance;
  let player: ref<PlayerPuppet>;
  let req: ref<EquipWardrobeSetRequest>;
  let puppet: ref<gamePuppet> = this.GetGamePuppet();
  let activeSetIndex: gameWardrobeClothingSetIndexExtra = WardrobeSystemExtra.GetInstance(puppet.GetGame()).GetActiveClothingSetIndex();
  if NotEquals(activeSetIndex, gameWardrobeClothingSetIndexExtra.INVALID) {
    gi = puppet.GetGame();
    player = GameInstance.GetPlayerSystem(gi).GetLocalPlayerControlledGameObject() as PlayerPuppet;
    equipmentSystem = GameInstance.GetScriptableSystemsContainer(gi).Get(n"EquipmentSystem") as EquipmentSystem;
    req = new EquipWardrobeSetRequest();
    req.setIDExtra = activeSetIndex;
    req.owner = player;
    equipmentSystem.QueueRequest(req);
    return true;
  };
  return false;
}