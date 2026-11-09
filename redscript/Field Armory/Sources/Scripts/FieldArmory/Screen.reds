module FieldArmory

import Codeware.UI.*

public class ArmoryScreen extends InGamePopup {
  public let access: ref<StashAccess>;
  private let system: wref<ArmorySystem>;
  private let view: ref<InventorySnapshot>;
  private let wardrobe: ref<WardrobeView>;
  public let previewHost: wref<inkCompoundWidget>;
  private let closing: Bool;
  public let preview: wref<ArmoryPreview>;
  private let shell: ref<InMenuPopupContent>;
  private let tiles: array<wref<inkWidget>>;
  private let accents: array<wref<inkImage>>;
  private let panel: ref<inkVerticalPanel>;
  private let draft: ref<Loadout>;
  private let dialog: ref<inkGameNotificationToken>;
  private let selected: Int32;
  private let position: Int32;
  private let focus: Int32;
  private let callerListener: ref<InventoryScriptListener>;
  private let stashListener: ref<InventoryScriptListener>;
  private let observer: ref<ArmoryInventoryListener>;
  private let refreshing: Bool;
  private let facts: array<CName>;
  private let factListeners: array<Uint32>;
  private let field: Int32;
  private let editorReturnRow: Int32;
  private let stored: Bool;
  private let heading: ref<inkVerticalPanel>;
  private let body: ref<inkVerticalPanel>;
  private let footer: ref<inkHorizontalPanel>;
  private let previewControls: ref<inkHorizontalPanel>;
  private let viewport: ref<inkCanvas>;
  private let scroll: ref<inkScrollController>;
  private let target: wref<inkCompoundWidget>;
  private let hovered: Int32;
  private let keyboardFocus: Bool;
  private let contentHeight: Float;
  private let mode: CName;
  private let reason: String;
  private let actions: array<CName>;
  private let values: array<Int32>;
  private let texts: array<wref<inkText>>;

  public func Close() {
    if this.closing { return; }
    this.closing = true;
    super.Close();
  }

  public func UseCursor() -> Bool { 
    return true; 
  }

  // stop simulation
  protected func SetTimeDilation() {}
  protected func ResetTimeDilation() {}

  protected cb func OnCreate() -> Void {
    super.OnCreate();

    this.system = ArmorySystem.Get(this.access.player.GetGame());
    let menu = this.GetGameController().SpawnFromExternal(this.m_container, r"djkovrik\\fieldarmory\\ui\\loadout_menu.inkwidget", n"Root") as inkCompoundWidget;
    if !IsDefined(menu) { this.Close(); return; }
    this.previewHost = menu.GetWidgetByPathName(n"previewHost") as inkCompoundWidget;

    let listHost = menu.GetWidgetByPathName(n"listHost") as inkCompoundWidget;
    this.GetGameController().SpawnFromExternal(this.previewHost, r"djkovrik\\fieldarmory\\ui\\loadout_preview.inkwidget", n"Root:FieldArmory.ArmoryPreview");
    menu.SetChildOrder(inkEChildOrder.Forward);
    listHost.SetAnchor(inkEAnchor.LeftFillVerticaly);
    listHost.SetMargin(inkMargin(20.0, 0.0, 0.0, 0.0));
    listHost.SetInteractive(false);
    listHost.SetChildOrder(inkEChildOrder.Forward);
    this.panel = new inkVerticalPanel();
    this.panel.SetAnchor(inkEAnchor.CenterLeft);
    this.panel.SetAnchorPoint(Vector2(0.0, 0.0));
    this.panel.SetTranslation(Vector2(-350.0, -520.0));
    this.panel.SetFitToContent(true);
    this.panel.Reparent(listHost);
    this.shell = InMenuPopupContent.Create();
    this.shell.Reparent(this.panel);

    let chrome = this.shell.GetRootCompoundWidget();
    chrome.GetWidgetByPathName(n"wrapper/right/fg").SetOpacity(0.45);
    this.heading = new inkVerticalPanel();
    this.heading.Reparent(this.shell.GetContainerWidget());
    this.MakeScrollArea();
    this.footer = new inkHorizontalPanel();
    this.footer.SetHAlign(inkEHorizontalAlign.Right);
    this.footer.SetFitToContent(true);
    this.footer.Reparent(this.panel);
    this.previewControls = new inkHorizontalPanel();
    this.previewControls.SetHAlign(inkEHorizontalAlign.Right);
    this.previewControls.SetFitToContent(true);
    this.previewControls.Reparent(this.panel);
    this.observer = new ArmoryInventoryListener();
    this.observer.screen = this;

    let ts = GameInstance.GetTransactionSystem(this.access.player.GetGame());
    this.callerListener = ts.RegisterInventoryListener(this.access.player, this.observer);
    this.stashListener = ts.RegisterInventoryListener(this.access.storage, this.observer);
    this.Refresh();

    let i = 0;
    for set in this.system.sets {
      if set.serial == this.system.lastApplied { this.selected = i; break; }
      i += 1;
    };

    this.focus = this.selected;
    this.FirstPosition();
    this.Draw(true);
    this.RevealAfterLayout();

    ArmoryOperation.Recover(this.access);
  }

  protected cb func OnAttach() -> Void {
    super.OnAttach();
    this.RegisterToGlobalInputCallback(n"OnPreOnPress", this, n"OnConfirmPress");
    this.RegisterToGlobalInputCallback(n"OnPreOnRelease", this, n"OnConfirmRelease");
  }

  protected cb func OnDetach() -> Void {
    this.UnregisterFromGlobalInputCallback(n"OnPreOnPress", this, n"OnConfirmPress");
    this.UnregisterFromGlobalInputCallback(n"OnPreOnRelease", this, n"OnConfirmRelease");
    let ts = GameInstance.GetTransactionSystem(this.access.player.GetGame());
    ts.UnregisterInventoryListener(this.access.player, this.callerListener);
    if IsDefined(this.access.storage) { ts.UnregisterInventoryListener(this.access.storage, this.stashListener); }
    this.ClearFacts();
    if this.system.screen == this { this.system.screen = null; }
    if IsDefined(this.system.pending) { this.system.pending.reverting = true; }
    super.OnDetach();
  }

  public func Invalidate() -> Void {
    if this.refreshing || !IsDefined(this.system) || this.system.screen != this || IsDefined(this.system.pending) { return; }
    this.refreshing = true;
    let callback = new ScreenRefresh();
    callback.screen = this;
    GameInstance.GetDelaySystem(this.access.player.GetGame()).DelayCallbackNextFrame(callback);
  }

  public func OnRefreshRequested() -> Void {
    this.refreshing = false;
    if this.system.screen == this && !IsDefined(this.system.pending) {
      this.Refresh(); this.Draw();
    };
  }

  private func ClearFacts() {
    let quests = GameInstance.GetQuestsSystem(this.access.player.GetGame());
    let i = 0;
    for fact in this.facts { 
      quests.UnregisterListener(fact, this.factListeners[i]);
       i += 1; 
    };

    ArrayClear(this.facts); 
    ArrayClear(this.factListeners);
  }

  protected cb func OnPairFactChanged(value: Int32) -> Bool { 
    this.Invalidate(); 
  }

  public func Refresh() {
    if !IsDefined(this.access.storage) { this.reason = Label("StashUnavailable"); return; }
    this.view = InventorySnapshot.Read(this.access);
    this.wardrobe = WardrobeView.Read(this.access.player);

    this.ClearFacts();

    let quets = GameInstance.GetQuestsSystem(this.access.player.GetGame());
    for row in this.view.weapons {
      if row.data.HasTag(n"QuestPreventDualWield") {
        let fact = RPGManager.GetItemRecord(row.data.GetID()).QuestFactPreventDualWield();
        if IsNameValid(fact) && !ArrayContains(this.facts, fact) {
          ArrayPush(this.facts, fact);
          ArrayPush(this.factListeners, quets.RegisterListener(fact, this, n"OnPairFactChanged"));
        };
      };
    };
  }

  public func Report(message: String) { 
    this.reason = message; 
    this.Refresh(); 
    this.Draw(); 
  }

  private func Selected() -> ref<Loadout> {
    if IsDefined(this.draft) { return this.draft; }
    if this.selected < ArraySize(this.system.sets) { return this.system.sets[this.selected]; }
    return null;
  }

  private func FirstPosition() {
    this.position = 0;
    let set = this.Selected();
    if !IsDefined(set) { return; }
    while this.position < 2 
    && !ItemID.IsValid(set.weapons[this.position]) 
    && !ItemID.IsValid(set.weapons[this.position+3]) { 
      this.position += 1; 
    };

    if !ItemID.IsValid(set.weapons[this.position]) && !ItemID.IsValid(set.weapons[this.position+3]) { 
      this.position = 0; 
    };
  }
  
  private func Color(widget: ref<inkWidget>, token: CName) {
    widget.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    widget.BindProperty(n"tintColor", token);
  }

  private func MakeScrollArea() {
    this.viewport = new inkCanvas();
    this.viewport.SetInteractive(true);
    this.viewport.Reparent(this.shell.GetContainerWidget());
    let area = new inkScrollArea();
    area.SetAnchor(inkEAnchor.Fill);
    area.SetMargin(inkMargin(0.0, 0.0, 18.0, 0.0));
    area.fitToContentDirection = inkFitToContentDirection.Horizontal;
    area.useInternalMask = true;
    area.Reparent(this.viewport);
    this.body = new inkVerticalPanel();
    this.body.Reparent(area);
    let track = new inkCanvas();
    track.SetAnchor(inkEAnchor.RightFillVerticaly);
    track.SetSize(10.0, 0.0);
    track.SetInteractive(true);
    track.Reparent(this.viewport);
    let rail = new inkRectangle();
    rail.SetAnchor(inkEAnchor.Fill);
    this.Color(rail, n"MainColors.Grey");
    rail.SetOpacity(0.2);
    rail.Reparent(track);
    let thumb = new inkRectangle();
    thumb.SetAnchor(inkEAnchor.TopFillHorizontaly);
    thumb.SetSize(10.0, 40.0);
    thumb.SetInteractive(true);
    this.Color(thumb, n"MainColors.Grey");
    thumb.SetOpacity(0.65);
    thumb.Reparent(track);
    let slider = new inkSliderController();
    slider.slidingAreaRef = inkWidgetRef.Create(track);
    slider.handleRef = inkWidgetRef.Create(thumb);
    slider.direction = inkESliderDirection.Vertical;
    slider.autoSizeHandle = true;
    slider.minHandleSize = 40.0;
    slider.Setup(0, 1, 0, 0);
    track.AttachController(slider);
    this.scroll = new inkScrollController();
    this.scroll.ScrollArea = inkScrollAreaRef.Create(area);
    this.scroll.VerticalScrollBarRef = inkWidgetRef.Create(track);
    this.scroll.autoHideVertical = true;
    this.viewport.AttachController(this.scroll);
  }

  private func RegisterAction(tile: ref<inkWidget>, action: CName, opt value: Int32, opt frame: ref<inkImage>, opt text: ref<inkText>) {
    tile.SetName(StringToName(ToString(ArraySize(this.tiles))));
    tile.RegisterToCallback(n"OnEnter", this, n"OnHover");
    tile.RegisterToCallback(n"OnLeave", this, n"OnLeaveRow");
    ArrayPush(this.tiles, tile);
    ArrayPush(this.accents, frame);
    ArrayPush(this.actions, action);
    ArrayPush(this.values, value);
    ArrayPush(this.texts, text);
  }

  private func CommandButton(label: String, action: CName) {
    let button: ref<PopupButton> = PopupButton.Create();
    button.SetText(label);
    button.RegisterToCallback(n"OnBtnClick", this, n"OnCommandClick");
    button.Reparent(this.target, this.GetGameController());
    let root = button.GetRootWidget();
    let chrome = button.GetRootCompoundWidget();
    chrome.GetWidgetByPathName(n"minSize").SetSize(0.0, 80.0);
    chrome.GetWidgetByPathName(n"background").SetSize(0.0, 80.0);
    chrome.GetWidgetByPathName(n"frame").SetSize(0.0, 80.0);
    root.SetFitToContent(true);
    root.SetMargin(inkMargin(this.target.GetNumChildren() > 1 ? 14.0 : 0.0, 4.0, 0.0, 6.0));
    this.RegisterAction(root, action);
  }

  private func AddSilhouette(tile: ref<inkCanvas>, field: Int32, item: ref<ArmoryItem>) {
    let icon = new inkImage();
    let size = Vector2(54.0, 54.0);
    if IsDefined(item) {
      let record = RPGManager.GetItemRecord(item.data.GetID());
      let type = record.ItemType().Type();
      let weapon = record as WeaponItem_Record;
      let hudIcon: wref<UIIcon_Record>;
      if IsDefined(weapon) { hudIcon = weapon.HudIcon(); }
      let part: CName;
      switch type {
        case gamedataItemType.Wea_Knife: part = n"knife"; size = Vector2(70.0, 15.0); break;
        case gamedataItemType.Wea_Revolver: part = n"revolver_power"; size = Vector2(72.0, 41.0); break;
        case gamedataItemType.Wea_Handgun: part = n"pistol"; size = Vector2(63.0, 43.0); break;
        case gamedataItemType.Wea_SniperRifle: part = n"sniper"; size = Vector2(98.0, 31.0); break;
        case gamedataItemType.Wea_Shotgun: part = n"shotgun_power"; size = Vector2(90.0, 19.0); break;
        case gamedataItemType.Wea_Katana: part = n"katana"; size = Vector2(81.0, 16.0); break;
        case gamedataItemType.Wea_LightMachineGun: part = n"light_machine"; size = Vector2(87.0, 30.0); break;
        case gamedataItemType.Wea_AssaultRifle: size = Vector2(62.0, 42.0); break;
      };

      if item.data.HasTag(n"Defender") || (IsDefined(hudIcon) && hudIcon.GetID() == t"HUDWeaponIcons.Defender") {
        InkImageUtils.RequestSetImage(this.GetGameController(), icon, t"HUDWeaponIcons.Defender");
        size = Vector2(94.0, 30.0);
      } else if IsNameValid(part) {
        icon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\weapon_types.inkatlas");
        icon.SetTexturePart(part);
      } else {
        let classIcon = UIItemsHelper.GetWeaponTypeIcon(type);
        if Equals(classIcon, n"UIIcon.WeaponTypeIcon_Default") && IsDefined(hudIcon) {
          InkImageUtils.RequestSetImage(this.GetGameController(), icon, hudIcon.GetID());
          size = Vector2(94.0, 30.0);
        } else {
          InkImageUtils.RequestSetImage(this.GetGameController(), icon, classIcon);
        };
      };
    } else {
      icon.SetAtlasResource(r"base\\gameplay\\gui\\fullscreen\\inventory\\shadow_icons.inkatlas");
      icon.SetTexturePart(field == 6 ? n"granade" : (field == 7 ? n"inhaler" : n"wardrobe"));
      size = Vector2(field == 6 ? 28.0 : (field == 7 ? 35.0 : 22.0), 54.0);
    };

    icon.SetAnchor(inkEAnchor.CenterLeft);
    icon.SetAnchorPoint(Vector2(0.5, 0.5));
    icon.SetMargin(inkMargin(64.0, 0.0, 0.0, 0.0));
    icon.SetSize(size);
    icon.SetInteractive(false);
    this.Color(icon, n"MainColors.Blue");
    if IsDefined(item) { icon.SetOpacity(0.58); }
    icon.Reparent(tile);
  }

  private func Row(label: String, action: CName, opt value: Int32, opt detail: String, opt item: ref<ArmoryItem>, opt statusAtRight: Bool, opt secondary: String) {
    let row = new inkText();
    row.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Medium");
    row.SetText(label);
    if !IsNameValid(action) {
      row.SetFontSize(35);
      row.SetFitToContent(true);
      row.SetWrapping(true, 908.0);
      row.SetMargin(inkMargin(4.0, 2.0, 4.0, 8.0));
      this.Color(row, n"MainColors.White");
      row.Reparent(this.target);
      return;
    };

    // fixed for now
    let width: Float = 1130.0;
    let hasDetail: Bool = StrLen(detail) > 0;
    let source: Bool = Equals(action, n"source");
    let weaponParts: Bool = Equals(action, n"choose") && this.field < 6 && hasDetail;
    let editor = Equals(action, n"name") || Equals(action, n"pick");
    let silhouette = IsDefined(item) || (Equals(action, n"pick") && value >= 6);
    let hand = Equals(action, n"pick") && value < 6;
    let left = silhouette ? 120.0 : (hand ? 285.0 : 24.0);
    let stacked = hasDetail && !source && !weaponParts && !statusAtRight;
    let height = this.target == this.body ? (editor || stacked ? 94.0 : 80.0) : 68.0;
    let column = weaponParts ? width * 0.46 : width * 0.5;
    let top = 4.0;
    if Equals(action, n"pick") {
      if value < 3 { top = 18.0; }
      else if value == 6 { top = 32.0; }
    }
    let tile = new inkCanvas();
    if source { tile.SetHAlign(inkEHorizontalAlign.Left); }
    tile.SetSize(width, height);
    tile.SetMargin(inkMargin(0.0, top, 0.0, 6.0));
    tile.SetInteractive(true);
    tile.SetChildOrder(inkEChildOrder.Forward);
    tile.Reparent(this.target);

    let frame = new inkImage();
    frame.SetAnchor(inkEAnchor.Fill);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"cell_fg");
    frame.SetNineSliceScale(true);
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.Reparent(tile);
    if silhouette { this.AddSilhouette(tile, value, item); }
    let focusText = row;
    if hand {
      let caption = new inkText();
      caption.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Medium");
      caption.SetFontSize(35);
      caption.SetAnchor(inkEAnchor.Fill);
      caption.SetMargin(inkMargin(24.0, 0.0, width-left+12.0, stacked ? height-52.0 : 0.0));
      caption.SetVerticalAlignment(textVerticalAlignment.Center);
      caption.SetText(this.FieldLabel(value));
      this.Color(caption, n"MainColors.White");
      caption.Reparent(tile);
      if StrLen(label) == 0 { focusText = caption; }
    }
    row.SetAnchor(inkEAnchor.Fill);
    row.SetMargin(inkMargin(left, 0.0, source || weaponParts || statusAtRight ? width-column + 12.0 : 20.0, stacked ? height - 52.0 : 0.0));
    row.SetFontSize(37);
    row.SetVerticalAlignment(textVerticalAlignment.Center);
    row.SetWrapping(false, width-44.0);
    row.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    row.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    if StrLen(secondary) > 0 {
      let line = new inkHorizontalPanel();
      line.SetAnchor(inkEAnchor.Fill);
      line.SetMargin(row.GetMargin());
      line.SetInteractive(false);
      line.Reparent(tile);
      row.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
      row.SetFitToContent(true);
      row.SetVAlign(inkEVerticalAlign.Center);
      row.SetWrapping(true, width-left-280.0);
      row.SetVisible(StrLen(label) > 0);
      row.Reparent(line);
      let status = new inkText();
      status.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Regular");
      status.SetFontSize(35);
      status.SetVerticalAlignment(textVerticalAlignment.Center);
      status.SetVAlign(inkEVerticalAlign.Center);
      status.SetFitToContent(true);
      status.SetInteractive(false);
      status.SetText(StrLen(label) > 0 ? " · " + secondary : secondary);
      this.Color(status, n"MainColors.Grey");
      status.Reparent(line);
    } else {
      row.Reparent(tile);
    }
    if hasDetail {
      let parts = new inkText();
      parts.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Regular");
      parts.SetFontSize(weaponParts ? 29 : (source ? 35 : 32));
      parts.SetText(detail);
      parts.SetAnchor(inkEAnchor.Fill);
      parts.SetMargin(inkMargin(stacked ? 24.0 : column, stacked ? 42.0 : 0.0, 20.0, 0.0));
      if !stacked {
        parts.SetHorizontalAlignment(textHorizontalAlignment.Right);
        parts.SetInteractive(false);
      }
      parts.SetVerticalAlignment(textVerticalAlignment.Center);
      parts.SetWrapping(weaponParts, weaponParts ? width-column-20.0 : width-44.0);
      parts.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
      this.Color(parts, source ? n"MainColors.Blue" : n"MainColors.Grey");
      parts.Reparent(tile);
      if Equals(action, n"name") {
        this.Color(row, n"MainColors.Grey");
        focusText = parts;
      }
    }
    tile.RegisterToCallback(n"OnRelease", this, n"OnRow");
    this.RegisterAction(tile, action, value, frame, focusText);

    if this.target == this.body { 
      this.contentHeight += height + top + 6.0; 
    }
  }

  private func Paint(i: Int32) {
    if i < 0 || i >= ArraySize(this.tiles) { return; }
    let lit = (this.keyboardFocus && i == this.focus) || i == this.hovered;
    let action = this.actions[i];
    if !IsDefined(this.accents[i]) {
      let button = this.tiles[i].GetControllerByType(n"Codeware.UI.PopupButton") as PopupButton;
      let input = Equals(action, n"back") || Equals(action, n"close") ? n"cancel" : (i == this.focus ? n"proceed" : n"");
      if NotEquals(button.GetInputAction(), input) { button.SetInputAction(input); }
      this.tiles[i].SetState(lit ? n"Hover" : n"Default");
      return;
    }

    let selected = Equals(action, n"select") && this.values[i] == this.selected;
    let source = Equals(action, n"source");
    this.accents[i].BindProperty(n"tintColor", selected ? n"MainColors.Red" : (lit || source ? n"MainColors.Blue" : n"MainColors.Grey"));
    this.accents[i].SetOpacity(lit || selected ? 1.0 : (source ? 0.52 : 0.16));
    this.texts[i].BindProperty(n"tintColor", lit || (Equals(action, n"choose") && this.values[i] == -1) ? n"MainColors.Blue" : n"MainColors.White");
    this.texts[i].SetOpacity(lit || selected ? 1.0 : 0.88);
  }

  private func Reveal(i: Int32) {
    if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i].GetParentWidget() == this.body {
      this.scroll.EnsureVisible(this.tiles[i]);
      this.scroll.UpdateScrollPositionFromScrollArea();
    }
  }

  protected cb func OnHover(e: ref<inkPointerEvent>) -> Bool {
    let i = StringToInt(NameToString(e.GetCurrentTarget().GetName()));
    if i < 0 || i >= ArraySize(this.tiles) || this.tiles[i] != e.GetCurrentTarget() { return false; }
    let old = this.hovered;
    if old != i { this.GetGameController().PlaySound(n"Button", n"OnHover"); }
    this.hovered = i;
    if this.keyboardFocus {
      this.keyboardFocus = false;
      this.Paint(this.focus);
    }
    if old != i { this.Paint(old); }
    this.Paint(i);
  }

  protected cb func OnLeaveRow(e: ref<inkPointerEvent>) -> Bool {
    let i = this.hovered;
    if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i] == e.GetCurrentTarget() {
      this.hovered = -1;
      this.Paint(i);
    }
  }
  
  private func Status(set: ref<Loadout>, out available: Bool) -> String {
    available = false;
    if !IsDefined(this.access.storage) || !IsDefined(this.view) { return Label("StashUnavailable"); }
    let reason = this.view.Problem(set, false);
    if StrLen(reason) > 0 { return reason; }
    let choice = this.wardrobe.Find(set);
    if IsNameValid(set.wardrobe) && (!IsDefined(choice) || !choice.valid || this.wardrobe.locked) { return Label("MissingOutfit"); }
    available = true;
    return this.view.Matches(set) && (!IsDefined(choice)||choice.wearing) ? Label("Equipped") : "";
  }

  private func FieldLabel(field: Int32) -> String {
    if field < 6 { return ToString(1 + field % 3) + " · " + (field < 3 ? Label("RightHand") : Label("LeftHand")); }
    if field == 6 { return Label("CombatGadget"); }
    return field == 7 ? Label("Healing") : Label("Outfit");
  }

  private func EditItem(field: Int32, id: ItemID, fallback: String) {
    let item = this.view.Find(id);
    if IsDefined(item) {
      let owner = item.carried ? Label("Carried") : Label("InStash");
      let parts: String;
      if field < 6 { parts = item.PartsLabel(); }
      this.Row(item.Name(), n"pick", field, parts, null, false, owner);
    } else {
      this.Row(field < 6 ? "" : this.FieldLabel(field), n"pick", field, "", null, false, fallback);
    }
  }

  private func EditorFocus() -> Int32 {
    if this.field < 6 { return 1 + 2 * (this.field % 3) + (this.field < 3 ? 0 : 1); }
    return 1 + this.field;
  }

  private func Draw(opt focusPrimary: Bool) {
    this.heading.RemoveAllChildren();
    this.body.RemoveAllChildren();
    this.footer.RemoveAllChildren();
    this.previewControls.RemoveAllChildren();
    this.contentHeight = 0.0;
    this.hovered = -1;
    this.target = this.heading;
    ArrayClear(this.tiles); ArrayClear(this.accents);
    ArrayClear(this.actions); ArrayClear(this.values); ArrayClear(this.texts);
    let selected = this.Selected();
    this.shell.SetTitle(Equals(this.mode, n"picker") ? this.FieldLabel(this.field) : (IsDefined(this.draft) ? Label("Edit") : Label("Loadouts")));
    if StrLen(this.reason) > 0 { this.Row(this.reason, n""); }
    this.target = this.body;
    if Equals(this.mode, n"picker") { this.DrawPicker(); }
    else {
      if IsDefined(this.draft) {
        this.Row(Label("NameLabel"), n"name", 0, NameToString(selected.title));
        let i = 0;
        while i < 3 {
          this.EditItem(i, selected.weapons[i], ItemID.IsValid(selected.weapons[i]) ? Label("MissingWeapon") : Label("EmptySlot"));
          this.EditItem(i + 3, selected.weapons[i + 3], ItemID.IsValid(selected.weapons[i+3]) ? Label("MissingWeapon") : Label("EmptySlot"));
          i += 1;
        };
 
        this.EditItem(6, this.view.Assignment(selected.gadget, selected.gadgetFamily, EHotkey.RB), ItemID.IsValid(selected.gadget) ? Label("MissingAssignment") : Label("KeepCurrent"));
        this.EditItem(7, this.view.Assignment(selected.healing, selected.healingFamily, EHotkey.DPAD_UP), ItemID.IsValid(selected.healing) ? Label("MissingAssignment") : Label("KeepCurrent"));
        let outfit = this.wardrobe.Find(selected);
        let outfitLabel = IsNameValid(selected.wardrobe) ? Label("MissingOutfit") : Label("KeepCurrent");
        this.Row(IsDefined(outfit) ? outfit.Title() : Label("Outfit"), n"pick", 8, "", null, false, IsDefined(outfit) ? "" : outfitLabel);
        this.target = this.footer;
        if focusPrimary { this.focus = ArraySize(this.actions); }
        this.CommandButton(Label("Save"), n"save");
        this.CommandButton(Label("DiscardChanges"), n"back");
      } else {
        if ArraySize(this.system.sets) == 0 { this.target = this.heading; this.Row(Label("EmptySlot"), n""); this.target = this.body; }
        let selectedAvailable: Bool;
        let i = 0;
        while i < ArraySize(this.system.sets) {
          let preset = this.system.sets[i];
          let available: Bool;
          let status = this.Status(preset, available);
          this.Row(NameToString(preset.title), n"select", i, status, null, available && StrLen(status) > 0);
          if i == this.selected { selectedAvailable = available; }
          i += 1;
        };

        this.target = this.footer;

        if Equals(this.mode, n"manage") {
          if focusPrimary { this.focus = ArraySize(this.actions); }
          this.CommandButton(Label("EditAction"), n"edit");
          this.CommandButton(Label("Duplicate"), n"copy");
          this.CommandButton(Label("Delete"), n"delete");
        } else {
          if IsDefined(selected) {
            if focusPrimary {
              this.focus = selectedAvailable ? ArraySize(this.actions) : this.selected;
            }
            this.CommandButton(Label("Equip"), n"equip");
            this.CommandButton(Label("Manage"), n"manage");
          }
          this.CommandButton(Label("CreateFromCurrent"), n"new");
        }
      };
    };

    this.target = !IsDefined(selected) || Equals(this.mode, n"edit") ? this.footer : this.previewControls;
    if Equals(this.mode, n"picker") || Equals(this.mode, n"manage") {
      this.CommandButton(Label("Back"), n"back");
    } else {
      if !IsDefined(this.draft) { this.CommandButton(GetLocalizedText("UI-ScriptExports-Close"), n"close"); }
    }
    if IsDefined(selected) {
      this.CommandButton(this.PositionLabel(), n"position");
      if IsDefined(this.preview) { this.preview.Select(this.view, selected, this.wardrobe.Find(selected), this.position); }
    } else { 
      if IsDefined(this.preview) { 
        this.preview.Select(this.view, null, null, 0); 
      } ;
    };

    let editing = Equals(this.mode, n"edit");
    let visibleHeight = MinF(this.contentHeight, editing ? 1120.0 : 720.0);
    this.viewport.SetSize(1160.0, visibleHeight);
    this.viewport.SetVisible(visibleHeight > 0.0);
    let empty = !IsDefined(selected);
    // dynamic maybe? kept for the first release
    let width = empty ? 780.0 : 1280.0;
    this.heading.SetMargin(inkMargin(0.0, 0.0, 0.0, empty ? 22.0 : 0.0));
    this.panel.GetParentWidget().SetSize(width,0.0);
    this.shell.GetRootCompoundWidget().GetWidgetByPathName(n"minSize").SetSize(width, empty ? 220.0 : 190.0);
    this.shell.GetRootCompoundWidget().GetWidgetByPathName(n"wrapper/right").SetSize(width - 40.0, 180.0);
    this.footer.SetVisible(this.footer.GetNumChildren() > 0);
    this.previewControls.SetVisible(this.previewControls.GetNumChildren() > 0);
    this.footer.SetMargin(inkMargin(0.0, 14.0, 0.0, 0.0));
    this.previewControls.SetMargin(inkMargin(0.0, Equals(this.mode, n"picker") ? 14.0 : 0.0, 0.0, 0.0));
    this.focus = Clamp(this.focus, 0, Max(0, ArraySize(this.actions)-1));
    let i = 0;
    while i < ArraySize(this.actions) { this.Paint(i); i += 1; }
  }

  private func PositionLabel() -> String {
    return Label("PreviewPosition") + " " + ToString(this.position+1) + " / 3  >";
  }

  private func Choices() -> array<ref<ArmoryItem>> {
    if this.field < 6 { return this.view.weapons; }
    if this.field == 6 { return this.view.gadgets; }
    return this.view.heals;
  }

  private func DrawPicker() {
    let first = 0;
    if this.field < 6 {
      this.target = this.heading;
      let carried = this.view.carriedWeapons;
      let storedCount = ArraySize(this.view.weapons)-carried;
      let container = this.stored ? Label("Stash") : Label("Inventory");
      let count = this.stored ? storedCount : carried;
      this.Row(container+" ("+ToString(count)+")", n"source", 0, this.stored ? Label("ShowInventory") : Label("ShowStash"));
      this.target = this.body;
      if this.stored { first = carried; }
    }
    let slot = this.FieldLabel(this.field);
    this.Row(this.field < 6 ? Label("ClearSlot") : Label("KeepCurrent"), n"choose", -1);
    if this.field == 8 {
      let i = 0;
      while i < ArraySize(this.wardrobe.choices) { this.Row(this.wardrobe.choices[i].Title(), n"choose", i, slot); i += 1; }
    } else {
      let rows = this.Choices();
      let end = this.field < 6 && !this.stored ? this.view.carriedWeapons : ArraySize(rows);
      while first < end {
        let item = rows[first];
        if this.field < 6 {
          this.Row(item.Name(), n"choose", first, item.PartsLabel(), item);
        } else {
          this.Row(item.Name(), n"choose", first);
        }
        first += 1;
      }
    }
  }

  protected cb func OnRow(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") && !e.IsHandled() {
      let target = e.GetCurrentTarget();
      let i = StringToInt(NameToString(target.GetName()));
      if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i] == target {
        e.Handle();
        this.Act(i);
        return true;
      }
    }
  }

  protected cb func OnCommandClick(widget: wref<inkWidget>) {
    let i = StringToInt(NameToString(widget.GetName()));
    if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i] == widget { this.Act(i); }
  }

  private func TakeConfirm(e: ref<inkPointerEvent>) -> Bool {
    if this.closing || IsDefined(this.dialog) || !this.IsTopPopup() || e.IsHandled() || e.IsConsumed() { return false; }
    if !e.IsAction(n"proceed") && (!e.IsAction(n"activate") || e.IsAction(n"click") || e.IsAction(n"mouse_left")) { return false; }
    e.Handle();
    e.Consume();
    return true;
  }

  protected cb func OnConfirmPress(e: ref<inkPointerEvent>) -> Bool {
    return this.TakeConfirm(e);
  }

  protected cb func OnConfirmRelease(e: ref<inkPointerEvent>) -> Bool {
    if !this.TakeConfirm(e) { return false; }
    this.Act(this.focus);
    return true;
  }

  protected cb func OnGlobalReleaseInput(e: ref<inkPointerEvent>) -> Bool {
    if IsDefined(this.dialog) || !this.IsTopPopup() || e.IsHandled() { return false; }
    if e.IsAction(n"cancel") && (IsDefined(this.draft)||IsNameValid(this.mode)) { e.Handle(); this.Back(); return true; }
    let up = e.IsAction(n"popup_navigate_up");
    if up || e.IsAction(n"popup_navigate_down") {
      let old = this.focus;
      let oldHover = this.hovered;
      this.keyboardFocus = true;
      this.hovered = -1;
      let from = this.editorReturnRow > 0 ? this.editorReturnRow : this.focus;
      this.editorReturnRow = 0;
      this.focus = (from+ArraySize(this.actions)+(up ? -1 : 1)) % Max(1, ArraySize(this.actions));
      if oldHover != old { this.Paint(oldHover); }
      this.Paint(old); this.Paint(this.focus); this.Reveal(this.focus);
      e.Handle(); return true;
    }
    return super.OnGlobalReleaseInput(e);
  }

  private func Back() {
    this.reason = "";
    this.Refresh();
    if Equals(this.mode, n"picker") { this.ReturnToEditor(); return; }
    this.draft = null;
    this.mode = n"";
    this.editorReturnRow = 0;
    this.focus = this.selected;
    this.Draw(true);
    this.RevealAfterLayout();
  }

  private func ReturnToEditor() {
    this.mode = n"edit";
    this.editorReturnRow = this.EditorFocus();
    this.Draw(true);
    this.RevealAfterLayout();
  }

  private func Act(i: Int32) {
    if this.closing || i < 0 || i >= ArraySize(this.actions) || IsDefined(this.system.pending) || IsDefined(this.dialog) { return; }
    this.GetGameController().PlaySound(n"Button", n"OnPress");
    let action = this.actions[i];
    let value = this.values[i];
    if !Equals(action, n"position") { this.reason = ""; }

    switch action {
      case n"select": this.selected = value; this.FirstPosition(); break;
      case n"manage": this.mode = n"manage"; break;
      case n"new":
        this.Refresh();
        this.draft = Loadout.Capture(this.access.player);
        if !IsDefined(this.draft) { this.Report(Label("EquipmentRestricted")); return; }
        this.draft.title = StringToName(Label("Name")+" "+ToString(ArraySize(this.system.sets)+1));
        if IsDefined(this.wardrobe.unique) { this.wardrobe.unique.Bind(this.draft); }
        this.mode = n"edit"; this.FirstPosition(); break;
      case n"edit": case n"copy":
        this.Refresh(); this.draft = this.Selected().Copy(); this.mode = n"edit";
        if Equals(action, n"copy") { this.draft.serial = 0ul; }
        break;
      case n"name":
        this.dialog = GenericMessageNotification.ShowInput(this.GetGameController(), Label("NameLabel"), NameToString(this.draft.title), GenericMessageNotificationType.ConfirmCancel);
        this.dialog.RegisterListener(this, n"OnName"); return;
      case n"delete":
        this.dialog = GenericMessageNotification.Show(this.GetGameController(), Label("Delete"), Label("ConfirmDelete")+" "+NameToString(this.Selected().title), GenericMessageNotificationType.YesNo);
        this.dialog.RegisterListener(this, n"OnDelete"); return;
      case n"pick":
        this.editorReturnRow = 0;
        this.field = value; this.stored = false; this.mode = n"picker";
        break;
      case n"choose":
        this.Choose(value);
        this.ReturnToEditor();
        return;
      case n"source": this.stored = !this.stored; break;
      case n"position":
        this.position = (this.position+1)%3;
        let button = this.tiles[i].GetControllerByType(n"Codeware.UI.PopupButton") as PopupButton;
        button.SetText(this.PositionLabel());
        let set = this.Selected();
        if IsDefined(this.preview) { this.preview.Select(this.view, set, this.wardrobe.Find(set), this.position); }
        return;
      case n"save":
        this.selected = this.system.Save(this.draft); this.Back(); return;
      case n"back": this.Back(); return;
      case n"close": this.Close(); return;
      case n"equip":
        this.reason = ArmoryOperation.Start(this.access, this.Selected()); break;
    }
    this.focus = Equals(action, n"select") ? this.selected : 0;
    let enteringEditor = Equals(action, n"new") || Equals(action, n"edit") || Equals(action, n"copy");
    this.Draw(enteringEditor || Equals(action, n"manage") || Equals(action, n"select"));
    if Equals(action, n"source") && this.stored {
      let match = this.StoredMatch();
      let j = 0;
      while j < ArraySize(this.actions) {
        if Equals(this.actions[j], n"choose") && this.values[j] == match { this.PaintFocusAt(j); break; }
        j += 1;
      }
    } else {
      if Equals(action, n"pick") || Equals(action, n"source") { this.scroll.SetScrollPosition(0.0); }
      this.RevealAfterLayout();
    }
  }

  private func PaintFocusAt(i: Int32) {
    let old = this.focus;
    this.focus = i;
    this.Paint(old); this.Paint(i); this.RevealAfterLayout();
  }

  private func RowToReveal() -> Int32 {
    if this.editorReturnRow > 0 { return this.editorReturnRow; }
    if this.focus >= 0 && this.focus < ArraySize(this.actions) && (Equals(this.actions[this.focus], n"equip") || Equals(this.actions[this.focus], n"edit")) {
      return this.selected;
    }
    return this.focus;
  }

  private func RevealAfterLayout() {
    let row = this.RowToReveal();
    if row < 0 || row >= ArraySize(this.tiles) || this.tiles[row].GetParentWidget() != this.body { return; }
    let callback = new ArmoryScrollToFocus();
    callback.screen = this;
    callback.tile = this.tiles[row];
    GameInstance.GetDelaySystem(this.access.player.GetGame()).DelayCallbackNextFrame(callback);
  }

  public func RevealCurrent(tile: wref<inkWidget>) {
    let row = this.RowToReveal();
    if !this.closing && IsDefined(tile) && row >= 0 && row < ArraySize(this.tiles) && this.tiles[row] == tile {
      this.Reveal(row);
    }
  }

  private func StoredMatch() -> Int32 {
    let first = this.view.carriedWeapons;
    let id = this.draft.weapons[this.field];
    if !ItemID.IsValid(id) { id = this.draft.weapons[this.position]; }
    if ItemID.IsValid(id) {
      let name = GetLocalizedTextByKey(RPGManager.GetItemRecord(id).DisplayName());
      let i = first;
      while i < ArraySize(this.view.weapons) {
        let candidate = this.view.weapons[i].data.GetID();
        if ItemID.GetTDBID(candidate) == ItemID.GetTDBID(id) || (StrLen(name) > 0 && Equals(name, GetLocalizedTextByKey(RPGManager.GetItemRecord(candidate).DisplayName()))) { return i; }
        i += 1;
      }
    }
    return first;
  }

  private func Choose(index: Int32) {
    if this.field == 8 {
      if index >= 0 { this.wardrobe.choices[index].Bind(this.draft); }
      else { this.draft.wardrobe = n""; this.draft.outfitName = n""; }
    } else {
      let id = ItemID.None();
      if index >= 0 { let rows = this.Choices(); id = rows[index].data.GetID(); }
      if this.field < 6 {
        let existing = ArrayFindFirst(this.draft.weapons, id);
        if ItemID.IsValid(id) && existing >= 0 && existing != this.field { this.draft.weapons[existing] = ItemID.None(); }
        this.draft.weapons[this.field] = id;
        this.position = this.field%3;
        this.reason = this.view.Problem(this.draft, false);
      } else { this.draft.SetAssignment(this.field == 6 ? EHotkey.RB : EHotkey.DPAD_UP, id); }
    }
  }

  protected cb func OnName(data: ref<inkGameNotificationData>) {
    this.dialog = null;
    let result = data as GenericMessageNotificationCloseData;
    if IsDefined(result) 
      && Equals(result.result, GenericMessageNotificationResult.Confirm) 
      && StrLen(result.input) > 0 { 
        this.draft.title = StringToName(result.input); 
    };

    this.Draw();
  }

  protected cb func OnDelete(data: ref<inkGameNotificationData>) {
    this.dialog = null;
    let result = data as GenericMessageNotificationCloseData;
    if IsDefined(result) && Equals(result.result, GenericMessageNotificationResult.Yes) {
      this.system.Delete(this.selected); this.selected = Max(0, Min(this.selected, ArraySize(this.system.sets) - 1));
      if ArraySize(this.system.sets) == 0 { this.mode = n""; }
      this.focus = this.selected; this.FirstPosition();
    };

    this.Draw();
  }
}

public class ArmoryScrollToFocus extends DelayCallback {
  public let screen: wref<ArmoryScreen>;
  public let tile: wref<inkWidget>;

  public func Call() {
    if IsDefined(this.screen) { this.screen.RevealCurrent(this.tile); }
  }
}
