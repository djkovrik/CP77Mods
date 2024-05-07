@if(ModuleExists("EquipmentEx"))
import EquipmentEx.*

import Codeware.UI.*

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

  private func HasFppSuffix() -> Bool {
    return this.HasSuffix("&FPP");
  }

  private func HasTppSuffix() -> Bool {
    return this.HasSuffix("&TPP");
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


@if(!ModuleExists("EquipmentEx"))
public static func GetSleevesInfo(player: ref<GameObject>) -> ref<SleevesInfoBundle> {
  let system: ref<SleevesStateSystem> = SleevesStateSystem.Get(player.GetGame());
  return system.GetBasicSlotsItems(player, false);
}

@if(ModuleExists("EquipmentEx"))
public static func GetSleevesInfo(player: ref<GameObject>) -> ref<SleevesInfoBundle> {
  let sleevesSystem: ref<SleevesStateSystem> = SleevesStateSystem.Get(player.GetGame());
  let outfitSystem: ref<OutfitSystem> = OutfitSystem.GetInstance(player.GetGame());
  if outfitSystem.IsActive() {
    return sleevesSystem.GetEquipmentExSlotsItems(player);
  };
  return sleevesSystem.GetBasicSlotsItems(player, true);
}

@if(!ModuleExists("EquipmentEx"))
public static func IsSlotOccupiedCustom(gi: GameInstance, slot: TweakDBID) -> Bool {
  return false;
}

@if(ModuleExists("EquipmentEx"))
public static func IsSlotOccupiedCustom(gi: GameInstance, slot: TweakDBID) -> Bool {
  return OutfitSystem.GetInstance(gi).IsOccupied(slot);
}


public class SleevesButtonController extends inkGameController {
  private let enabled: Bool;
  private let active: Bool;

  private let borderHovered: wref<inkWidget>;

  private let appearAnimDuration: Float = 0.2;
  private let appearAnimDelay: Float = 0.4;

  protected cb func OnInitialize() {
    this.InitializeWidgets();
    this.RegisterInputListeners();
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterInputListeners();
  }

  protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
    if this.enabled {
      this.SetHoveredState(true);
      this.PlaySound(n"Button", n"OnHover");
    };
  }

  protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
    if this.enabled {
      this.SetHoveredState(false);
    };
  }

  protected cb func OnClick(e: ref<inkPointerEvent>) -> Bool {
    if this.enabled && e.IsAction(n"click") {
      this.PlaySound(n"Button", n"OnPress");
      GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(new ShowSleevesPopupEvent());
    };
  }

  protected cb func OnRefreshSleevesButtonEvent(evt: ref<RefreshSleevesButtonEvent>) -> Bool {
    this.enabled = evt.enabled;
    this.active = evt.active;
    this.RefreshButtonState(evt.enabled, evt.active);
  }

  protected cb func OnShowSleevesButtonEvent(evt: ref<ShowSleevesButtonEvent>) -> Bool {
    let root: ref<inkWidget> = this.GetRootCompoundWidget();
    if evt.show {
      this.AnimateAppearance(root, this.appearAnimDuration, this.appearAnimDelay);
    } else {
      this.AnimateDisappearance(root, this.appearAnimDuration, 0.0);
    };
  }

  private final func InitializeWidgets() -> Void {
    this.borderHovered = this.GetRootCompoundWidget().GetWidgetByPathName(n"container/frameHovered");
  }

  private final func RegisterInputListeners() -> Void {
    this.RegisterToCallback(n"OnEnter", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnLeave", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnClick");
  }

  private final func UnregisterInputListeners() -> Void {
    this.UnregisterFromCallback(n"OnEnter", this, n"OnRelease");
    this.UnregisterFromCallback(n"OnLeave", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnClick");
  }

  private final func RefreshButtonState(enabled: Bool, active: Bool) -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let sleevesIconInactive: ref<inkWidget> = root.GetWidgetByPathName(n"container/iconInactive");
    let sleevesIconActive: ref<inkWidget> = root.GetWidgetByPathName(n"container/iconActive");
    let sleevesIconNotAvailable: ref<inkWidget> = root.GetWidgetByPathName(n"container/iconNotAvailable");

    if !enabled {
      // Not available
      sleevesIconNotAvailable.SetVisible(true);
      sleevesIconInactive.SetVisible(false);
      sleevesIconActive.SetVisible(false);
    } else if enabled && !active {
      // Available but not active
      sleevesIconInactive.SetVisible(true);
      sleevesIconActive.SetVisible(false);
      sleevesIconNotAvailable.SetVisible(false);
    } else if enabled && active {
      // Active
      sleevesIconActive.SetVisible(true);
      sleevesIconInactive.SetVisible(false);
      sleevesIconNotAvailable.SetVisible(false);
    };
  }

  private final func SetHoveredState(hovered: Bool) -> Void {
    this.borderHovered.SetVisible(hovered);
  }

  private final func AnimateAppearance(targetWidget: wref<inkWidget>, duration: Float, delay: Float) -> ref<inkAnimProxy> {
    let proxy: ref<inkAnimProxy>;
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();

    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(delay);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(0.0);
    transparencyInterpolator.SetEndTransparency(1.0);

    let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
    translationInterpolator.SetDuration(duration);
    translationInterpolator.SetStartDelay(delay);
    translationInterpolator.SetType(inkanimInterpolationType.Linear);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetStartTranslation(new Vector2(60.0, 0.0));
    translationInterpolator.SetEndTranslation(new Vector2(0.0, 0.0));

    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    moveElementsAnimDef.AddInterpolator(translationInterpolator);
    proxy = targetWidget.PlayAnimation(moveElementsAnimDef);

    return proxy;
  }

  private final func AnimateDisappearance(targetWidget: wref<inkWidget>, duration: Float, delay: Float) -> ref<inkAnimProxy> {
    let proxy: ref<inkAnimProxy>;
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();

    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(delay);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(1.0);
    transparencyInterpolator.SetEndTransparency(0.0);

    let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
    translationInterpolator.SetDuration(duration);
    translationInterpolator.SetStartDelay(delay);
    translationInterpolator.SetType(inkanimInterpolationType.Linear);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetStartTranslation(new Vector2(0.0, 0.0));
    translationInterpolator.SetEndTranslation(new Vector2(60.0, 0.0));

    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    moveElementsAnimDef.AddInterpolator(translationInterpolator);
    proxy = targetWidget.PlayAnimation(moveElementsAnimDef);

    return proxy;
  }
}


@addMethod(gameuiInventoryGameController)
private final func ShowSleevesButton(show: Bool) -> Void {
  ShowSleevesButtonEvent.Send(this.m_player, show);
}

@addMethod(gameuiInventoryGameController)
protected cb func OnShowSleevesPopupEvent(evt: ref<ShowSleevesPopupEvent>) -> Bool {
  let bundle: ref<SleevesInfoBundle> = SleevesStateSystem.Get(this.m_player.GetGame()).GetInfoBundle();
  SleevesPopup.Show(this, bundle);
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"default_wrapper") as inkCompoundWidget;
  this.SpawnFromExternal(container, r"base\\gameplay\\gui\\sleeves.inkwidget", n"SleevesButton:SleevesButtonController");
  this.ShowSleevesButton(true);
  RefreshSleevesButtonEvent.Send(this.m_player);
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnItemChooserItemChanged(e: ref<ItemChooserItemChanged>) -> Bool {
  this.ShowSleevesButton(false);
  return wrappedMethod(e);
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
  this.ShowSleevesButton(true);
  return wrappedMethod(userData);
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnCloseMenu(userData: ref<IScriptable>) -> Bool {
  this.ShowSleevesButton(false);
  return wrappedMethod(userData);
}

@addMethod(gameuiInventoryGameController)
protected cb func OnDropQueueUpdatedEventCustom(evt: ref<DropQueueUpdatedEvent>) -> Bool {
  this.ShowSleevesButton(false);
}


public static func SleevesLog(str: String) -> Void {
  // ModLog(n"Sleeves", str);
}


public class SleevesPopup extends InMenuPopup {
  let data: ref<SleevesInfoBundle>;

  protected cb func OnCreate() {
    super.OnCreate();

    let content: ref<InMenuPopupContent> = InMenuPopupContent.Create();
    content.SetTitle(GetLocalizedTextByKey(n"Mod-Sleeves-Title"));
    content.Reparent(this);

    let component: ref<SleevesPopupComponent> = new SleevesPopupComponent();
    component.SetData(this.data);
    component.Reparent(content.GetContainerWidget());

    let footer: ref<InMenuPopupFooter> = InMenuPopupFooter.Create();
    footer.Reparent(this);

    let button: ref<PopupButton> = PopupButton.Create();
    button.SetText(GetLocalizedTextByKey(n"UI-ScriptExports-Done0"));
    button.SetInputAction(n"one_click_confirm");
    button.Reparent(footer);
  }

  protected cb func OnConfirm() {
    this.PlaySound(n"Button", n"OnPress");
  }

  public static func Show(requester: ref<inkGameController>, data: ref<SleevesInfoBundle>) -> Void {
    let popup: ref<SleevesPopup> = new SleevesPopup();
    popup.data = data;
    popup.Open(requester);
  }
}


public class SleevesPopupComponent extends inkComponent {
  private let data: ref<SleevesInfoBundle>;

  protected cb func OnCreate() -> ref<inkWidget> {
    // Root
    let root: ref<inkFlex> = new inkFlex();
    root.SetName(n"Root");
    root.SetInteractive(true);
    root.SetFitToContent(true);
    
    // Internal container
    let internalPanel: ref<inkVerticalPanel> = new inkVerticalPanel();
    internalPanel.SetName(n"internalPanel");
    internalPanel.SetFitToContent(true);
    internalPanel.SetHAlign(inkEHorizontalAlign.Center);
    internalPanel.SetVAlign(inkEVerticalAlign.Center);
    internalPanel.SetAnchor(inkEAnchor.Centered);
    internalPanel.SetMargin(new inkMargin(16.0, 16.0, 16.0, 16.0));
    internalPanel.Reparent(root);

    // - Mode label
    let modeName: ref<inkText> = new inkText();
    modeName.SetName(n"modeName");
    modeName.SetText(s"Test");
    modeName.SetMargin(new inkMargin(0.0, 0.0, 0.0, 8.0));
    modeName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    modeName.SetFontSize(42);
    modeName.SetFitToContent(true);
    modeName.SetLetterCase(textLetterCase.OriginalCase);
    modeName.SetAnchor(inkEAnchor.TopLeft);
    modeName.SetHAlign(inkEHorizontalAlign.Left);
    modeName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    modeName.BindProperty(n"tintColor", n"MainColors.Blue");
    modeName.SetOpacity(0.75);
    modeName.Reparent(internalPanel);

    // - Items panel
    let items: ref<inkVerticalPanel> = new inkVerticalPanel();
    items.SetName(n"items");
    items.SetFitToContent(true);
    items.Reparent(internalPanel);

    return root;
  }

  protected cb func OnInitialize() {
    this.UpdateContent();
  }

  protected cb func OnUninitialize() {
    // 
  }

  private final func UpdateContent() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let itemsContainer: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"internalPanel/items") as inkCompoundWidget;
    if IsDefined(this.data) && ArraySize(this.data.items) > 0 {
      for item in this.data.items {
        let component: ref<SleevesPopupItemComponent> = new SleevesPopupItemComponent();
        component.SetData(item);
        component.SetMode(this.data.mode);
        component.Reparent(itemsContainer);
      };
    };

    let modeName: ref<inkText> = root.GetWidgetByPathName(n"internalPanel/modeName") as inkText;
    modeName.SetText(this.data.GetLocalizedModeName());
  }

  public final func SetData(data: ref<SleevesInfoBundle>) -> Void {
    this.data = data;
  }
}


public class SleevesPopupItemComponent extends inkComponent {
  private let system: wref<SleevesStateSystem>;
  private let mode: SleevesMode;
  private let data: ref<SleevedSlotInfo>;

  private let itemName: ref<inkText>;
  private let slotName: ref<inkText>;
  private let checkboxFrame: ref<inkImage>;
  private let checkboxFrameNotAvailable: ref<inkImage>;
  private let checkboxBgAvailable: ref<inkImage>;
  private let checkboxBgNotAvailable: ref<inkImage>;
  private let checkboxMarker: ref<inkImage>;

  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    root.SetName(n"Root");
    root.SetSize(820.0, 120.0);
    root.SetMargin(0.0, 8.0, 0.0, 8.0);
    root.SetInteractive(true);
    root.SetAnchor(inkEAnchor.Fill);

    // Checkbox
    let checkboxContainer: ref<inkCanvas> = new inkCanvas();
    checkboxContainer.SetName(n"checkboxContainer");
    checkboxContainer.SetSize(64.0, 64.0);
    checkboxContainer.SetFitToContent(false);
    checkboxContainer.SetInteractive(true);
    checkboxContainer.SetChildOrder(inkEChildOrder.Backward);
    checkboxContainer.SetAnchor(inkEAnchor.CenterLeft);
    checkboxContainer.SetHAlign(inkEHorizontalAlign.Left);
    checkboxContainer.SetVAlign(inkEVerticalAlign.Center);
    checkboxContainer.Reparent(root);

    let checkbox: ref<inkImage> = new inkImage();
    checkbox.SetName(n"checkbox");
    checkbox.SetAnchor(inkEAnchor.Centered);
    checkbox.SetAnchorPoint(0.5, 0.5);
    checkbox.SetMargin(1.0, 1.0, 0.0, 0.0);
    checkbox.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    checkbox.BindProperty(n"tintColor", n"MainColors.Red");
    checkbox.SetSize(38.0, 38.0);
    checkbox.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    checkbox.SetTexturePart(n"color_bg");
    checkbox.SetNineSliceScale(true);
    checkbox.Reparent(checkboxContainer);

    let frame: ref<inkImage> = new inkImage();
    frame.SetName(n"frame");
    frame.SetAnchor(inkEAnchor.Fill);
    frame.SetAnchorPoint(0.5, 0.5);
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.BindProperty(n"tintColor", n"MainColors.MildRed");
    frame.SetSize(64.0, 64.0);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"color_fg");
    frame.SetNineSliceScale(true);
    frame.Reparent(checkboxContainer);

    let frameNotAvailable: ref<inkImage> = new inkImage();
    frameNotAvailable.SetName(n"frameNotAvailable");
    frameNotAvailable.SetAnchor(inkEAnchor.Fill);
    frameNotAvailable.SetAnchorPoint(0.5, 0.5);
    frameNotAvailable.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frameNotAvailable.BindProperty(n"tintColor", n"MainColors.Grey");
    frameNotAvailable.SetSize(64.0, 64.0);
    frameNotAvailable.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frameNotAvailable.SetTexturePart(n"color_fg");
    frameNotAvailable.SetNineSliceScale(true);
    frameNotAvailable.SetVisible(false);
    frameNotAvailable.SetOpacity(0.5);
    frameNotAvailable.Reparent(checkboxContainer);

    let bg: ref<inkImage> = new inkImage();
    bg.SetName(n"bg");
    bg.SetAnchor(inkEAnchor.Fill);
    bg.SetAnchorPoint(0.5, 0.5);
    bg.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    bg.BindProperty(n"tintColor", n"MainColors.FaintRed");
    bg.SetSize(64.0, 64.0);
    bg.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    bg.SetTexturePart(n"color_bg");
    bg.SetNineSliceScale(true);
    bg.Reparent(checkboxContainer);

    let bgNotAvailable: ref<inkImage> = new inkImage();
    bgNotAvailable.SetName(n"bgNotAvailable");
    bgNotAvailable.SetAnchor(inkEAnchor.Fill);
    bgNotAvailable.SetAnchorPoint(0.5, 0.5);
    bgNotAvailable.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    bgNotAvailable.BindProperty(n"tintColor", n"MainColors.Grey");
    bgNotAvailable.SetSize(64.0, 64.0);
    bgNotAvailable.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    bgNotAvailable.SetTexturePart(n"color_bg");
    bgNotAvailable.SetNineSliceScale(true);
    bgNotAvailable.SetVisible(false);
    bgNotAvailable.SetOpacity(0.1);
    bgNotAvailable.Reparent(checkboxContainer);

    // Labels
    let labels: ref<inkVerticalPanel> = new inkVerticalPanel();
    labels.SetName(n"labelsContainer");
    labels.SetFitToContent(false);
    labels.SetInteractive(true);
    labels.SetSize(740.0, 108.0);
    labels.SetAnchor(inkEAnchor.CenterLeft);
    labels.SetHAlign(inkEHorizontalAlign.Left);
    labels.SetVAlign(inkEVerticalAlign.Center);
    labels.SetMargin(32.0, 0.0, 0.0, 0.0);
    labels.Reparent(root);

    let itemName: ref<inkText> = new inkText();
    itemName.SetName(n"itemName");
    itemName.SetText("Test");
    itemName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    itemName.SetFontSize(40);
    itemName.SetFitToContent(false);
    itemName.SetSize(740.0, 54.0);
    itemName.SetLetterCase(textLetterCase.OriginalCase);
    itemName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    itemName.BindProperty(n"tintColor", n"MainColors.Red");
    itemName.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    itemName.SetWrapping(false, 744, textWrappingPolicy.PerCharacter);
    itemName.Reparent(labels);

    let slotName: ref<inkText> = new inkText();
    slotName.SetName(n"slotName");
    slotName.SetText("Test");
    slotName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    slotName.SetFontSize(36);
    slotName.SetFitToContent(false);
    slotName.SetSize(740.0, 54.0);
    slotName.SetLetterCase(textLetterCase.OriginalCase);
    slotName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    slotName.BindProperty(n"tintColor", n"MainColors.Grey");
    slotName.Reparent(labels);

    return root;
  }

  protected cb func OnInitialize() {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.itemName = root.GetWidgetByPathName(n"labelsContainer/itemName") as inkText;
    this.slotName = root.GetWidgetByPathName(n"labelsContainer/slotName") as inkText;
    this.checkboxFrame = root.GetWidgetByPathName(n"checkboxContainer/frame") as inkImage;
    this.checkboxFrameNotAvailable = root.GetWidgetByPathName(n"checkboxContainer/frameNotAvailable") as inkImage;
    this.checkboxBgAvailable = root.GetWidgetByPathName(n"checkboxContainer/bg") as inkImage;
    this.checkboxBgNotAvailable = root.GetWidgetByPathName(n"checkboxContainer/bgNotAvailable") as inkImage;
    this.checkboxMarker = root.GetWidgetByPathName(n"checkboxContainer/checkbox") as inkImage;

    this.system = SleevesStateSystem.Get(GetGameInstance());

    this.UpdateLabels();
    this.UpdateCheckbox();
    this.RegisterInputListeners();
  }

  protected cb func OnUninitialize() {
    this.UnregisterInputListeners();
  }

  protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
    if this.IsAvailableForSelection() {
      this.PlaySound(n"Button", n"OnHover");

      this.itemName.UnbindProperty(n"tintColor");
      this.itemName.BindProperty(n"tintColor", n"MainColors.ActiveRed");
      this.checkboxFrame.UnbindProperty(n"tintColor");
      this.checkboxFrame.BindProperty(n"tintColor", n"MainColors.Red");
    }
  }

  protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
    if this.IsAvailableForSelection() {
      this.itemName.UnbindProperty(n"tintColor");
      this.itemName.BindProperty(n"tintColor", n"MainColors.Red");
      this.checkboxFrame.UnbindProperty(n"tintColor");
      this.checkboxFrame.BindProperty(n"tintColor", n"MainColors.MildRed");
    }
  }

  protected cb func OnClick(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") && this.IsAvailableForSelection() {
      let toggled: Bool = this.data.IsToggled();
      let tdbid: TweakDBID;
      if NotEquals(this.data.mode, SleevesMode.Wardrobe) {
        tdbid = this.data.itemTDBID;
      } else {
        tdbid = this.data.visualItemTDBID;
      };

      if toggled {
        if this.system.RemoveToggle(tdbid) {
          this.data.SetToggled(false);
          this.UpdateCheckbox();
          this.PlaySound(n"Button", n"OnPress");
        }
      } else {
        if this.system.AddToggle(tdbid) {
          this.data.SetToggled(true);
          this.UpdateCheckbox();
          this.PlaySound(n"Button", n"OnPress");
        };
      };

      RefreshSleevesButtonEvent.Send(GetPlayer(GetGameInstance()));
    };
  }

  public final func SetMode(mode: SleevesMode) -> Void {
    this.mode = mode;
  }

  public final func SetData(data: ref<SleevedSlotInfo>) -> Void {
    this.data = data;
  }

  private final func UpdateLabels() -> Void {
    this.itemName.SetText(this.data.GetDisplayedItemName());
    this.slotName.SetText(this.data.GetSlotName());
  }

  private final func UpdateCheckbox() -> Void {
    if this.IsAvailableForSelection() {
      this.checkboxMarker.SetVisible(this.data.IsToggled());
    } else {
      this.checkboxFrame.SetVisible(false);
      this.checkboxMarker.SetVisible(false);
      this.checkboxBgAvailable.SetVisible(false);
      this.checkboxBgNotAvailable.SetVisible(true);
      this.checkboxFrameNotAvailable.SetVisible(true);
    }
  }

  private final func RegisterInputListeners() -> Void {
    this.RegisterToCallback(n"OnEnter", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnLeave", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnClick");
  }

  private final func UnregisterInputListeners() -> Void {
    this.UnregisterFromCallback(n"OnEnter", this, n"OnRelease");
    this.UnregisterFromCallback(n"OnLeave", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnClick");
  }

  private final func IsAvailableForSelection() -> Bool {
    return this.data.HasFppSuffix();
  }
}


// -- Vanilla
@wrapMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  wrappedMethod(itemID, slotIndex, blockActiveSlotsUpdate, forceEquipWeapon);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
private final func UnequipItem(equipAreaIndex: Int32, slotIndex: Int32, opt forceRemove: Bool) -> Void {
  wrappedMethod(equipAreaIndex, slotIndex, forceRemove);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

// -- Wardrobe
@wrapMethod(EquipmentSystemPlayerData)
public final func OnQuestDisableWardrobeSetRequest(request: ref<QuestDisableWardrobeSetRequest>) -> Void {
  wrappedMethod(request);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnQuestRestoreWardrobeSetRequest(request: ref<QuestRestoreWardrobeSetRequest>) -> Void {
  wrappedMethod(request);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnQuestEnableWardrobeSetRequest(request: ref<QuestEnableWardrobeSetRequest>) -> Void {
  wrappedMethod(request);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func EquipWardrobeSet(setID: gameWardrobeClothingSetIndex) -> Void {
  wrappedMethod(setID);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func UnequipWardrobeSet() -> Void {
  wrappedMethod();
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func DeleteWardrobeSet(setID: gameWardrobeClothingSetIndex) -> Void {
  wrappedMethod(setID);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

// -- Equipment-EX
@if(ModuleExists("EquipmentEx"))
@addMethod(EquipmentSystemPlayerData)
protected cb func OnCustomOutfitUpdated(evt: ref<OutfitUpdated>) -> Bool {
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

// -- Handle unequip
@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  wrappedMethod(evt);

  if evt.actionName.IsAction(n"unequip_item") {
    this.m_player.TriggerSleevesButtonRefreshCallback();
  };
}

@wrapMethod(VehicleComponent)
protected final func OnVehicleCameraChange(state: Bool) -> Void {
  wrappedMethod(state);
  GetPlayer(GetGameInstance()).TriggerSleevesButtonRefreshCallback();
}

// -- Delayed refresh
@addField(GameObject)
private let sleevesDelayCallback: DelayID;

@addMethod(GameObject)
public final func TriggerSleevesButtonRefreshCallback() -> Void {
  let triggerDelaySeconds: Float = 3.0;
  let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
  delaySystem.CancelCallback(this.sleevesDelayCallback);
  this.sleevesDelayCallback = delaySystem.DelayCallback(SlotsButtonRefreshCallback.Create(this), triggerDelaySeconds, false);
}

public class SlotsButtonRefreshCallback extends DelayCallback {
  let owner: wref<GameObject>;

  public static final func Create(owner: ref<GameObject>) -> ref<SlotsButtonRefreshCallback> {
    let instance: ref<SlotsButtonRefreshCallback> = new SlotsButtonRefreshCallback();
    instance.owner = owner;
    return instance;
  }

  public func Call() -> Void {
    SleevesStateSystem.Get(this.owner.GetGame()).RefreshSleevesState();
    RefreshSleevesButtonEvent.Send(this.owner);
  }
}


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
      if item.HasFppSuffix() {
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


