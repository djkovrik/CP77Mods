class SleevesStateSystem extends ScriptableSystem {
  private let equipmentSystem: wref<EquipmentSystem>;
  private let transactionSystem: wref<TransactionSystem>;
  private let bundle: ref<SleevesInfoBundle>;
  private let cache: ref<inkHashMap>;
  private let isBraindanceActive: Bool;
  private let isArmCyberwareActive: Bool;
  private let isDriverCombatActive: Bool;
  private let eexChangedEquipment: array<ItemID>;

  private persistent let toggledItems: array<TweakDBID>;

  public static func Get(gi: GameInstance) -> ref<SleevesStateSystem> {
    let system: ref<SleevesStateSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"SleevesStateSystem") as SleevesStateSystem;
    return system;
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.isDriverCombatActive = false;
    this.equipmentSystem = GameInstance.GetScriptableSystemsContainer(request.owner.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    this.transactionSystem = GameInstance.GetTransactionSystem(request.owner.GetGame());

    if !IsDefined(this.cache) {
      this.cache = new inkHashMap();
    };

    if !GameInstance.GetSystemRequestsHandler().IsPreGame() {
      this.GetPlayer().TriggerSleevesRefreshCallback();
    };
  }

  public final func HasToggleableSleeves() -> Bool {
    this.EnsureBundle();

    for item in this.bundle.items {
      if item.Excluded() {
        return false;
      };
      if item.HasFppSuffix() || item.HasTppSuffix()  {
        return true;
      };
    };

    return false;
  }

  public final func HasSleevesActivated() -> Bool {
    this.EnsureBundle();

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
    this.EnsureBundle();
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

  public final func OnBraindanceEnter(entered: Bool) -> Void {
    SleevesLog(s"Braindance entered: \(entered)");
    this.isBraindanceActive = entered;
    this.GetPlayer().TriggerSleevesRefreshCallback();
  }

  public final func OnArmCyberwareStateChange(active: Bool) -> Void {
    if NotEquals(this.isArmCyberwareActive, active) {
      SleevesLog(s"Arm cyberware active: \(active)");
      this.isArmCyberwareActive = active;
      this.RefreshSleevesState();
      RefreshSleevesButtonEvent.Send(this.GetPlayer());
    };
  }

  public final func IsArmCyberwareActive() -> Bool {
    return this.isArmCyberwareActive;
  }

  public final static func IsTargetArmCyberware(player: ref<PlayerPuppet>) -> Bool {
    let weapon: ref<WeaponObject> = GameObject.GetActiveWeapon(player);
    let config: ref<SleevesConfig>;
    let weaponType: gamedataItemType;

    if !IsDefined(weapon) || !weapon.WeaponHasTag(n"Cyberware") {
      return false;
    };

    config = new SleevesConfig();
    weaponType = WeaponObject.GetWeaponType(weapon.GetItemID());

    switch weaponType {
      case gamedataItemType.Cyb_MantisBlades:
        return config.rollUpMantisBlades;
      case gamedataItemType.Cyb_Launcher:
        return config.rollUpLauncher;
      case gamedataItemType.Cyb_StrongArms:
        return config.rollUpStrongArms;
      case gamedataItemType.Cyb_NanoWires:
        return config.rollUpNanoWires;
    };

    return false;
  }

  public final func ClearCache() -> Void {
    this.cache.Clear();
  }

  private final func IsDriverCombatInFpp(psmBlackboard: ref<IBlackboard>) -> Bool {
    return psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle) == EnumInt(gamePSMVehicle.DriverCombat)
      && !psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsVehicleInTPP);
  }

  public final func OnDriverCombatStateChange() -> Void {
    let player: wref<PlayerPuppet> = this.GetPlayer();
    if !IsDefined(player) || !IsDefined(this.equipmentSystem) || !IsDefined(this.transactionSystem) || !IsDefined(this.cache) {
      return;
    };
    let psmBlackboard: ref<IBlackboard> = player.GetPlayerStateMachineBlackboard();
    if IsDefined(psmBlackboard) && NotEquals(this.isDriverCombatActive, this.IsDriverCombatInFpp(psmBlackboard)) {
      this.RefreshSleevesState();
    };
  }

  public final func RefreshSleevesState() -> Void {
    SleevesLog(s"RefreshSleevesState called, bd active \(this.isBraindanceActive), arm cw active \(this.isArmCyberwareActive)");

    let player: wref<PlayerPuppet> = this.GetPlayer();
    if !IsDefined(player) || !IsDefined(this.equipmentSystem) || !IsDefined(this.transactionSystem) || !IsDefined(this.cache) {
      return;
    };
    let psmBlackboard: ref<IBlackboard> = player.GetPlayerStateMachineBlackboard();
    if !IsDefined(psmBlackboard) {
      return;
    };
    let inVehicle: Bool = psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle);
    let wasDriverCombatActive: Bool = this.isDriverCombatActive;
    this.isDriverCombatActive = this.IsDriverCombatInFpp(psmBlackboard);
    this.bundle = GetSleevesInfo(player);
    this.LogCurrentInfo();
    this.RestoreSleevesEquipment(player);

    for item in this.bundle.items {
      if item.HasFppSuffix() || (inVehicle || wasDriverCombatActive || this.isDriverCombatActive) && item.HasTppSuffix() {
        if !this.isBraindanceActive && !this.isArmCyberwareActive {
          if item.IsToggled() {
            let appearance: CName = this.isDriverCombatActive ? item.GetItemFppAppearance() : item.GetItemTppAppearance();
            SleevesLog(s"Set \(appearance) appearance for \(ItemID.GetCombinedHash(item.itemID)) [\(item.itemName)]");
            this.ApplySleevesAppearance(player, item, appearance);
          } else {
            SleevesLog(s"Reset \(item.GetItemAppearance()) appearance for \(ItemID.GetCombinedHash(item.itemID)) [\(item.itemName)]");
            this.ApplySleevesAppearance(player, item, item.GetItemAppearance());
          };
        } else {
          SleevesLog(s"Reset BD/CW \(item.GetItemAppearance()) appearance for \(ItemID.GetCombinedHash(item.itemID)) [\(item.itemName)]");
          this.ApplySleevesAppearance(player, item, item.GetItemAppearance());
        };
      };
    };
  }

  private final func TrackSleevesEquipment(player: ref<GameObject>, record: TweakDBID) -> Void {
    let equipmentData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(player);
    if !IsDefined(equipmentData) {
      return;
    };
    if ArraySize(this.eexChangedEquipment) == 0 {
      ArrayResize(this.eexChangedEquipment, 2);
    };
    let areas: array<gamedataEquipmentArea> = [gamedataEquipmentArea.InnerChest, gamedataEquipmentArea.OuterChest];
    let i: Int32 = 0;
    while i < 2 {
      let equipped: ItemID = equipmentData.GetItemInEquipSlot(areas[i], 0);
      if ItemID.IsValid(equipped) && !ItemID.HasFlag(equipped, gameEItemIDFlag.Preview) && Equals(ItemID.GetTDBID(equipped), record) && equipmentData.IsSlotHidden(areas[i]) {
        this.eexChangedEquipment[i] = equipped;
      };
      i += 1;
    };
  }

  private final func RestoreSleevesEquipment(player: ref<GameObject>) -> Void {
    if NotEquals(this.bundle.mode, SleevesMode.EquipmentEx) {
      ArrayClear(this.eexChangedEquipment);
      return;
    };
    if ArraySize(this.eexChangedEquipment) == 0 {
      return;
    };
    let equipmentData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(player);
    if !IsDefined(equipmentData) {
      return;
    };
    let records: array<TweakDBID>;
    if !GetSleevesEquipmentExRecords(player, records) {
      return;
    };
    // Two base slots only. Membership checks traverse the active outfit at most twice;
    // neither inventory size nor the number of saved outfits affects this work.
    let areas: array<gamedataEquipmentArea> = [gamedataEquipmentArea.InnerChest, gamedataEquipmentArea.OuterChest];
    let i: Int32 = 0;
    while i < 2 {
      let tracked: ItemID = this.eexChangedEquipment[i];
      if ItemID.IsValid(tracked) {
        let equipped: ItemID = equipmentData.GetItemInEquipSlot(areas[i], 0);
        if NotEquals(equipped, tracked) || !equipmentData.IsSlotHidden(areas[i]) {
          this.eexChangedEquipment[i] = ItemID.None();
        } else if !ArrayContains(records, ItemID.GetTDBID(tracked)) {
          if NotEquals(this.transactionSystem.GetItemAppearance(player, tracked), n"empty_appearance_default") {
            // Restore only the appearance already required by EEX's hidden flag.
            // ClearVisuals would also update transmog, other clothing layers and audio.
            this.transactionSystem.ChangeItemAppearanceByName(player, tracked, n"empty_appearance_default");
          };
          // Keep tracking until the equipment/outfit changes: native requests are asynchronous.
        };
      };
      i += 1;
    };
  }

  private final func ApplySleevesAppearance(player: ref<GameObject>, item: ref<SleevedSlotInfo>, appearance: CName) -> Void {
    if Equals(item.mode, SleevesMode.EquipmentEx) {
      let liveItem: ref<ItemObject> = this.transactionSystem.GetItemInSlot(player, item.slotID);
      if !IsSlotOccupiedCustom(player.GetGame(), item.slotID) || !IsDefined(liveItem) || !IsDefined(item.itemObject) {
        return;
      };

      let liveItemID: ItemID = liveItem.GetItemID();
      if !ItemID.HasFlag(liveItemID, gameEItemIDFlag.Preview) || NotEquals(liveItemID, item.itemID) || NotEquals(liveItem.GetEntityID(), item.itemObject.GetEntityID()) {
        return;
      };

      if NotEquals(this.transactionSystem.GetItemAppearance(player, liveItemID), appearance) {
        this.TrackSleevesEquipment(player, item.itemTDBID);
        this.transactionSystem.ChangeItemAppearanceByName(player, liveItemID, appearance);
      };
      return;
    };

    this.transactionSystem.ChangeItemAppearanceByName(player, item.itemID, appearance);
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
    let isSlotEquipped: Bool;

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
      if IsDefined(itemObject) {
        itemID = itemObject.GetItemID();
        itemTDBID = ItemID.GetTDBID(itemID);
        isSlotEquipped = this.equipmentSystem.IsEquipped(player, itemID, this.SlotToArea(slotID));
        if ItemID.IsValid(itemID) && isSlotEquipped {
          if !this.HasCached(slotID, itemTDBID, mode) {
            slotName = this.GetLocalizedSlotName(slotID, mode);
            itemName = GetLocalizedTextByKey(RPGManager.GetItemRecord(itemID).DisplayName());
            itemAppearance = this.transactionSystem.GetItemAppearance(player, itemID);
            visualItemID = this.equipmentSystem.GetActiveVisualItem(player, this.SlotToArea(slotID));
            visualItemName = GetLocalizedTextByKey(RPGManager.GetItemRecord(visualItemID).DisplayName());
            info = SleevedSlotInfo.Create(slotID, slotName, itemID, itemName, itemAppearance, visualItemID, visualItemName, mode);
            this.Cache(info);
            SleevesLog(s"! Created: \(info.itemName) with base \(info.GetItemAppearance()) and tpp \(info.GetItemTppAppearance())");
            SleevesLog(s"-> \(info.itemName) \(mode) added to cache");
          } else {
            info = this.GetCached(slotID, itemTDBID, mode);
            SleevesLog(s"! Restored: \(info.itemName) with base \(info.GetItemAppearance()) and tpp \(info.GetItemTppAppearance())");
            SleevesLog(s"<- \(info.itemName) \(mode)` restored from cache");
          };
          ArrayPush(infoItems, info);
        };
      };
    };

    // Set toggles
    for item in infoItems {
      let toggled: Bool = NotEquals(item.mode, SleevesMode.Wardrobe) && this.IsToggled(item.itemTDBID) || Equals(item.mode, SleevesMode.Wardrobe) && this.IsToggled(item.visualItemTDBID);
      item.SetToggled(toggled);
    };

    SleevesLog(s"Items bundle size: \(ArraySize(infoItems))");
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
    let isSlotEquipped: Bool;

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
      if IsDefined(itemObject) {
        itemID = itemObject.GetItemID();
        itemTDBID = ItemID.GetTDBID(itemID);
        isSlotEquipped = IsSlotOccupiedCustom(player.GetGame(), slotID);
        if ItemID.IsValid(itemID) && isSlotEquipped {
          if !this.HasCached(slotID, itemTDBID, mode) {
            slotName = this.GetLocalizedSlotName(slotID, mode);
            itemName = GetLocalizedTextByKey(RPGManager.GetItemRecord(itemID).DisplayName());
            itemAppearance = this.transactionSystem.GetItemAppearance(player, itemID);
            visualItemID = itemID;
            visualItemName = itemName;
            info = SleevedSlotInfo.Create(slotID, slotName, itemID, itemName, itemAppearance, visualItemID, visualItemName, mode);
            this.Cache(info);
            SleevesLog(s"! Created: \(info.itemName) with base \(info.GetItemAppearance()) and tpp \(info.GetItemTppAppearance())");
            SleevesLog(s"-> \(info.itemName) added to cache");
          } else {
            info = this.GetCached(slotID, itemTDBID, mode);
            SleevesLog(s"! Restored: \(info.itemName) with base \(info.GetItemAppearance()) and tpp \(info.GetItemTppAppearance())");
            SleevesLog(s"<- \(info.itemName) restored from cache");
          };
          // Refresh the preview identity, but preserve the cached base appearance:
          // the live appearance may already contain the Sleeves TPP override.
          info.itemID = itemID;
          info.visualItemID = itemID;
          info.itemObject = itemObject;
          ArrayPush(infoItems, info);
        };
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
      case t"AttachmentSlots.Outfit":
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
    SleevesLog(s"Cache \(info.itemName) to key \(key)");
    this.cache.Insert(key, info);
  }

  private final func HasCached(slotID: TweakDBID, itemTDBID: TweakDBID, mode: SleevesMode) -> Bool {
    let key: Uint64 = this.Key(slotID, itemTDBID, mode);
    SleevesLog(s"HasCached key ? \(key): \(this.cache.KeyExist(key))");
    return this.cache.KeyExist(key);
  }

  private final func GetCached(slotID: TweakDBID, itemTDBID: TweakDBID, mode: SleevesMode) -> ref<SleevedSlotInfo> {
    let key: Uint64 = this.Key(slotID, itemTDBID, mode);
    return this.cache.Get(key) as SleevedSlotInfo;
  }

  private final func GetPlayer() -> ref<PlayerPuppet> {
    return GetPlayer(GetGameInstance());
  }

  private final func EnsureBundle() -> Void {
    let items: array<ref<SleevedSlotInfo>>;

    if !IsDefined(this.bundle) {
      this.bundle = SleevesInfoBundle.Create(SleevesMode.Vanilla, items);
    };
  }

  private final func LogCurrentInfo() -> Void {
    SleevesLog(s"LogCurrentInfo - mode \(this.bundle.mode), items:");
    for item in this.bundle.items {
      SleevesLog(s"--- Name \(item.GetItemName()), visual \(item.GetVisualItemName())");
      SleevesLog(s"--- Toggled: \(item.IsToggled())");
      SleevesLog(s"--- ID \(ItemID.GetCombinedHash(item.itemID)), visual \(ItemID.GetCombinedHash(item.visualItemID))");
      SleevesLog(s"--- TDBID \(TDBID.ToStringDEBUG(item.itemTDBID)), visual \(TDBID.ToStringDEBUG(item.visualItemTDBID))");
      SleevesLog(s"--- Appearances: base \(item.GetItemAppearance()), TPP \(item.GetItemTppAppearance())");
      SleevesLog(s"---");
    };
  }
}
