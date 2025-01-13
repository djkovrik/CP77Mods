public class SleevesInfoBundle {
  let mode: SleevesMode;
  let items: array<ref<SleevedSlotInfo>>;

  public final static func Create(mode: SleevesMode, items: array<ref<SleevedSlotInfo>>) -> ref<SleevesInfoBundle> {
    let instance: ref<SleevesInfoBundle> = new SleevesInfoBundle();
    instance.mode = mode;
    instance.items = items;
    return instance;
  }

  public final func GetLocalizedModeName() -> String {
    switch this.mode {
      case SleevesMode.Vanilla: return GetLocalizedTextByKey(n"Gameplay-RPG-Items-Categories-Clothing");
      case SleevesMode.Wardrobe: return GetLocalizedTextByKey(n"Gameplay-Devices-DisplayNames-Wardrobe");
    };

    return "Equipment-EX";
  }

  private final static func GetLocalizedSlotName(slotID: TweakDBID, mode: SleevesMode) -> String {
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
}

public class SleevedSlotInfo {
  private let slotID: TweakDBID;
  private let slotName: String;
  private let itemID: ItemID;
  private let itemTDBID: TweakDBID;
  private let itemName: String;
  private let itemAppearance: CName;
  private let visualItemID: ItemID;
  private let visualItemTDBID: TweakDBID;
  private let visualItemName: String;
  private let toggled: Bool;
  private let mode: SleevesMode;

  public static func Create(
      slotID: TweakDBID, 
      slotName: String,
      itemID: ItemID, 
      itemName: String, 
      itemAppearance: CName, 
      visualItemID: ItemID, 
      visualItemName: String, 
      mode: SleevesMode
    ) -> ref<SleevedSlotInfo> {

    let instance: ref<SleevedSlotInfo> = new SleevedSlotInfo();
    instance.slotID = slotID;
    instance.slotName = slotName;
    instance.itemID = itemID;
    instance.itemTDBID = ItemID.GetTDBID(itemID);
    instance.itemName = itemName;
    instance.itemAppearance = itemAppearance;
    instance.visualItemID = visualItemID;
    instance.visualItemTDBID = ItemID.GetTDBID(visualItemID);
    instance.visualItemName = visualItemName;
    instance.mode = mode;
    return instance;
  }

  public final func GetItemName() -> String {
    return this.itemName;
  }

  public final func GetVisualItemName() -> String {
    return this.visualItemName;
  }

  public final func GetDisplayedItemName() -> String {
    if Equals(this.mode, SleevesMode.Wardrobe) {
      return this.GetVisualItemName();
    };

    return this.GetItemName();
  }

  public final func GetSlotName() -> String {
    return this.slotName;
  }

  public final func IsToggled() -> Bool {
    return this.toggled;
  }

  public final func SetToggled(toggled: Bool) -> Void {
    this.toggled = toggled;
  }

  public final func GetItemAppearance() -> CName {
    return this.itemAppearance;
  }

  public final func GetItemTppAppearance() -> CName {
    let appearanceString: String = NameToString(this.itemAppearance);
    let newAppearanceString: String;
    if !this.HasFppSuffix() {
      return this.itemAppearance;
    };

    newAppearanceString = StrReplace(appearanceString, "&FPP", "&TPP");
    if this.HasPartSuffix() {
      newAppearanceString = StrReplace(newAppearanceString, "&Part", "&Full");
    };

    return StringToName(newAppearanceString);
  }

  public func HasFppSuffix() -> Bool {
    return this.HasSuffix("&FPP");
  }

  public func HasTppSuffix() -> Bool {
    return this.HasSuffix("&TPP");
  }

  private func Excluded() -> Bool {
    let excluded: array<TweakDBID> = [
      t"Items.MQ049_martinez_jacket"
    ];

    return ArrayContains(excluded, this.itemTDBID) || ArrayContains(excluded, this.visualItemTDBID);
  }

  private func HasPartSuffix() -> Bool {
    return this.HasSuffix("&Part");
  }

  private func HasFullSuffix() -> Bool {
    return this.HasSuffix("&Full");
  }

  private func HasSuffix(suffix: String) -> Bool {
    let appearanceString: String = NameToString(this.itemAppearance);
    return StrContains(appearanceString, suffix);
  }
}

public class RefreshSleevesButtonEvent extends Event {
  let enabled: Bool;
  let active: Bool;

  public static func Send(player: ref<GameObject>) -> Void {
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(player.GetGame());
    let sleevesSystem: ref<SleevesStateSystem> = SleevesStateSystem.Get(player.GetGame());
    let enabled: Bool = sleevesSystem.HasToggleableSleeves();
    let active: Bool = sleevesSystem.HasSleevesActivated();

    let evt: ref<RefreshSleevesButtonEvent> = new RefreshSleevesButtonEvent();
    evt.enabled = enabled;
    evt.active = active;

    uiSystem.QueueEvent(evt);
  }
}

public class ShowSleevesButtonEvent extends Event {
  let show: Bool;

  public static func Send(player: ref<GameObject>, show: Bool) -> Void {
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(player.GetGame());
    let evt: ref<ShowSleevesButtonEvent> = new ShowSleevesButtonEvent();
    evt.show = show;
    uiSystem.QueueEvent(evt);
  }
}

public class ShowSleevesPopupEvent extends Event {}

enum SleevesMode {
  Vanilla = 0,
  Wardrobe = 1,
  EquipmentEx = 2,
}
