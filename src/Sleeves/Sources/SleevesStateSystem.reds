class SleevesStateSystem extends ScriptableSystem {
  private let player: wref<PlayerPuppet>;
  private let equipmentSystem: wref<EquipmentSystem>;
  private let transactionSystem: wref<TransactionSystem>;
  private let bundle: ref<SleevesInfoBundle>;
  private let cache: ref<inkHashMap>;

  private persistent let toggledItems: array<TweakDBID>;

  public static func Get(gi: GameInstance) -> ref<SleevesStateSystem> {
    let system: ref<SleevesStateSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"SleevesStateSystem") as SleevesStateSystem;
    return system;
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.player = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    this.equipmentSystem = GameInstance.GetScriptableSystemsContainer(request.owner.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    this.transactionSystem = GameInstance.GetTransactionSystem(request.owner.GetGame());
    this.cache = new inkHashMap();

    if !GameInstance.GetSystemRequestsHandler().IsPreGame() {
      this.RefreshSleevesState();
    };
  }

  private final func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
    this.player = null;
    this.equipmentSystem = null;
    this.transactionSystem = null;
    this.cache = null;
  }

  public final func HasToggleableSleeves() -> Bool {
    for item in this.bundle.items {
      if item.HasFppSuffix() && !item.Excluded() {
        return true;
      };
    };

    return false;
  }

  public final func HasSleevesActivated() -> Bool {
    for item in this.bundle.items {
      if NotEquals(item.mode, SleevesMode.Wardrobe) && this.IsToggled(item.itemTDBID)  {
        return true;
      };

      if Equals(item.mode, SleevesMode.Wardrobe) && this.IsToggled(item.visualItemTDBID)  {
        return true;
      };
    };

    return false;
  }

  public final func GetInfoBundle() -> ref<SleevesInfoBundle> {
    return this.bundle;
  }

  public final func IsToggled(id: TweakDBID) -> Bool {
    return ArrayContains(this.toggledItems, id);
  }

  public final func AddToggle(id: TweakDBID) -> Bool {
    if !this.IsToggled(id) {
      ArrayPush(this.toggledItems, id);
      this.RefreshSleevesState();
      return true;
    };

    return false;
  }

  public final func RemoveToggle(id: TweakDBID) -> Bool {
    if this.IsToggled(id) {
      ArrayRemove(this.toggledItems, id);
      this.RefreshSleevesState();
      return true;
    };

    return false;
  }

  public final func OnBraindanceEnter() -> Void {
    SleevesLog("Braindance enter");
    for item in this.bundle.items {
      SleevesLog(s"Reset braindance \(item.GetItemAppearance()) appearance for \(ItemID.GetCombinedHash(item.itemID))");
      this.transactionSystem.ChangeItemAppearanceByName(this.player, item.itemID, item.GetItemAppearance());
    };
  }

  public final func OnBraindanceExit() -> Void {
    SleevesLog("Braindance exit");
    this.RefreshSleevesState();
  }

  public final func RefreshSleevesState() -> Void {
    this.bundle = GetSleevesInfo(this.player);
    this.LogCurrentInfo();

    for item in this.bundle.items {
      if item.IsToggled() {
        SleevesLog(s"Set \(item.GetItemTppAppearance()) appearance for \(ItemID.GetCombinedHash(item.itemID))");
        this.transactionSystem.ChangeItemAppearanceByName(this.player, item.itemID, item.GetItemTppAppearance());
      } else {
        SleevesLog(s"Reset \(item.GetItemAppearance()) appearance for \(ItemID.GetCombinedHash(item.itemID))");
        this.transactionSystem.ChangeItemAppearanceByName(this.player, item.itemID, item.GetItemAppearance());
      };
    };
  }

  public final func GetBasicSlotsItems(player: ref<GameObject>, isEquipmentExInstalled: Bool) -> ref<SleevesInfoBundle> {
    let currentWardrobeSet: gameWardrobeClothingSetIndex = EquipmentSystem.GetActiveWardrobeSetID(player);
    let isWardrobeActive: Bool = NotEquals(currentWardrobeSet, gameWardrobeClothingSetIndex.INVALID);
    let info: ref<SleevedSlotInfo>;
    let infoItems: array<ref<SleevedSlotInfo>>;
    let itemObject: ref<ItemObject>;
    let slotName: String;
    let itemID: ItemID;
    let itemTDBID: TweakDBID;
    let itemName: String;
    let itemAppearance: CName;
    let visualItemID: ItemID;
    let visualItemName: String;

    let targetSlots: array<TweakDBID> = [
      t"AttachmentSlots.Outfit",
      t"AttachmentSlots.Torso",
      t"AttachmentSlots.Chest"
    ];

    let mode: SleevesMode;
    if isEquipmentExInstalled {
      mode = SleevesMode.Vanilla;
    } else if isWardrobeActive {
      mode = SleevesMode.Wardrobe;
    } else {
      mode = SleevesMode.Vanilla;
    };

    // Populate list
    for slotID in targetSlots {
      itemObject = this.transactionSystem.GetItemInSlot(player, slotID);
      itemID = itemObject.GetItemID();
      itemTDBID = ItemID.GetTDBID(itemID);
      if ItemID.IsValid(itemID) {
        if !this.HasCached(slotID, itemTDBID, mode) {
          slotName = this.GetLocalizedSlotName(slotID, mode);
          itemName = GetLocalizedTextByKey(RPGManager.GetItemRecord(itemID).DisplayName());
          itemAppearance = this.transactionSystem.GetItemAppearance(player, itemID);
          visualItemID = this.equipmentSystem.GetActiveVisualItem(player, this.SlotToArea(slotID));
          visualItemName = GetLocalizedTextByKey(RPGManager.GetItemRecord(visualItemID).DisplayName());
          info = SleevedSlotInfo.Create(slotID, slotName, itemID, itemName, itemAppearance, visualItemID, visualItemName, mode);
          this.Cache(info);
          SleevesLog(s"-> \(info.itemName) added to cache");
        } else {
          info = this.GetCached(slotID, itemTDBID, mode);
          SleevesLog(s"<- \(info.itemName) restored from cache");
        };
        ArrayPush(infoItems, info);
      };
    };

    // Set toggles
    for item in infoItems {
      let toggled: Bool = NotEquals(item.mode, SleevesMode.Wardrobe) && this.IsToggled(item.itemTDBID) || Equals(item.mode, SleevesMode.Wardrobe) && this.IsToggled(item.visualItemTDBID);
      item.SetToggled(toggled);
    };

    return SleevesInfoBundle.Create(mode, infoItems);
  }

  public final func GetEquipmentExSlotsItems(player: ref<GameObject>) -> ref<SleevesInfoBundle> {
    let info: ref<SleevedSlotInfo>;
    let infoItems: array<ref<SleevedSlotInfo>>;
    let itemObject: ref<ItemObject>;
    let slotName: String;
    let itemID: ItemID;
    let itemTDBID: TweakDBID;
    let itemName: String;
    let itemAppearance: CName;
    let visualItemID: ItemID;
    let visualItemName: String;
    let isOccupied: Bool;

    let targetSlots: array<TweakDBID> = [
      t"OutfitSlots.TorsoOuter",
      t"OutfitSlots.TorsoMiddle",
      t"OutfitSlots.TorsoInner",
      t"OutfitSlots.TorsoUnder",
      t"OutfitSlots.BodyOuter",
      t"OutfitSlots.BodyMiddle",
      t"OutfitSlots.BodyInner",
      t"OutfitSlots.BodyUnder"
    ];

    let mode: SleevesMode = SleevesMode.EquipmentEx;

    // Populate list
    for slotID in targetSlots {
      itemObject = this.transactionSystem.GetItemInSlot(player, slotID);
      itemID = itemObject.GetItemID();
      itemTDBID = ItemID.GetTDBID(itemID);
      isOccupied = IsSlotOccupiedCustom(player.GetGame(), slotID);
      if ItemID.IsValid(itemID) && isOccupied {
        if !this.HasCached(slotID, itemTDBID, mode) {
          slotName = this.GetLocalizedSlotName(slotID, mode);
          itemName = GetLocalizedTextByKey(RPGManager.GetItemRecord(itemID).DisplayName());
          itemAppearance = this.transactionSystem.GetItemAppearance(player, itemID);
          visualItemID = this.equipmentSystem.GetActiveVisualItem(player, this.SlotToArea(slotID));
          visualItemName = GetLocalizedTextByKey(RPGManager.GetItemRecord(visualItemID).DisplayName());
          info = SleevedSlotInfo.Create(slotID, slotName, itemID, itemName, itemAppearance, visualItemID, visualItemName, mode);
          this.Cache(info);
          SleevesLog(s"-> \(info.itemName) added to cache");
        } else {
          info = this.GetCached(slotID, itemTDBID, mode);
          SleevesLog(s"<- \(info.itemName) restored from cache");
        };
        ArrayPush(infoItems, info);
      };
    };

    // Set toggles
    for item in infoItems {
      let toggled: Bool = NotEquals(item.mode, SleevesMode.Wardrobe) && this.IsToggled(item.itemTDBID);
      item.SetToggled(toggled);
    };

    return SleevesInfoBundle.Create(mode, infoItems);
  }

  private final func SlotToArea(slot: TweakDBID) -> gamedataEquipmentArea {
    switch slot {
      case t"AttachmentSlots.Torso":
        return gamedataEquipmentArea.OuterChest;
      case t"AttachmentSlots.Chest":
        return gamedataEquipmentArea.InnerChest;
      case t"AttachmentSlots.Outit":
        return gamedataEquipmentArea.Outfit;
    };
    return gamedataEquipmentArea.Invalid;
  }

  private final func GetLocalizedSlotName(slotID: TweakDBID, mode: SleevesMode) -> String {
    if Equals(mode, SleevesMode.EquipmentEx) {
      let key: String = TweakDBInterface.GetAttachmentSlotRecord(slotID).LocalizedName();
      let name: String = GetLocalizedTextByKey(StringToName(key));
      return NotEquals(name, "") ? name : key;
    };

    switch slotID {
      case t"AttachmentSlots.Outfit": return GetLocalizedTextByKey(n"Gameplay-Items-Item Type-Clo_Outfit");
      case t"AttachmentSlots.Torso": return GetLocalizedTextByKey(n"Gameplay-Items-Item Type-Clo_OuterChest");
      case t"AttachmentSlots.Chest": return GetLocalizedTextByKey(n"Gameplay-Items-Item Type-Clo_InnerChest");
    };

    return "";
  }

  private final func Key(slotID: TweakDBID, itemTDBID: TweakDBID, mode: SleevesMode) -> Uint64 {
    let slotHash: Uint64 = TDBID.ToNumber(slotID);
    let itemHash: Uint64 = TDBID.ToNumber(itemTDBID);
    let modeHash: Uint64 = Cast<Uint64>(EnumInt(mode));
    return slotHash + itemHash + modeHash;
  }

  private final func Cache(info: ref<SleevedSlotInfo>) -> Void {
    let key: Uint64 = this.Key(info.slotID, info.itemTDBID, info.mode);
    this.cache.Insert(key, info);
  }

  private final func HasCached(slotID: TweakDBID, itemTDBID: TweakDBID, mode: SleevesMode) -> Bool {
    let key: Uint64 = this.Key(slotID, itemTDBID, mode);
    return this.cache.KeyExist(key);
  }

  private final func GetCached(slotID: TweakDBID, itemTDBID: TweakDBID, mode: SleevesMode) -> ref<SleevedSlotInfo> {
    let key: Uint64 = this.Key(slotID, itemTDBID, mode);
    return this.cache.Get(key) as SleevedSlotInfo;
  }

  private final func LogCurrentInfo() -> Void {
    SleevesLog(s"Sleeves state: mode \(this.bundle.mode)");
    for item in this.bundle.items {
      SleevesLog(s"- Item data: toggled \(item.IsToggled())");
      SleevesLog(s"--- Name: \(item.GetItemName()), visual \(item.GetVisualItemName())");
      SleevesLog(s"--- ID \(ItemID.GetCombinedHash(item.itemID)), visual \(ItemID.GetCombinedHash(item.visualItemID))");
      SleevesLog(s"--- TDBID \(TDBID.ToStringDEBUG(item.itemTDBID)), visual \(TDBID.ToStringDEBUG(item.visualItemTDBID))");
      SleevesLog(s"--- Appearance: \(item.GetItemAppearance()), TPP \(item.GetItemTppAppearance())");
      SleevesLog("---");
    };
  }
}
