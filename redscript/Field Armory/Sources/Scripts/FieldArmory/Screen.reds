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
  private let tiles: array<wref<inkCanvas>>;
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
  private let stored: Bool;
  private let heading: ref<inkVerticalPanel>;
  private let body: ref<inkVerticalPanel>;
  private let footer: ref<inkHorizontalPanel>;
  private let tools: ref<inkHorizontalPanel>;
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
    listHost.SetChildOrder(inkEChildOrder.Forward);
    this.panel = new inkVerticalPanel();
    this.panel.SetAnchor(inkEAnchor.CenterLeft);
    this.panel.SetAnchorPoint(Vector2(0.0, 0.5));
    this.panel.SetFitToContent(true);
    this.panel.Reparent(listHost);
    this.shell = InMenuPopupContent.Create();
    this.shell.Reparent(this.panel);

    let chrome = this.shell.GetRootCompoundWidget();
    chrome.GetWidgetByPathName(n"wrapper/right/fg").SetOpacity(0.45);
    this.Color(chrome.GetWidgetByPathName(n"wrapper/right/bg"), n"MainColors.Black");
    this.heading = new inkVerticalPanel();
    this.heading.Reparent(this.shell.GetContainerWidget());
    this.MakeScrollArea();
    this.footer = new inkHorizontalPanel();
    this.footer.SetHAlign(inkEHorizontalAlign.Right);
    this.footer.SetFitToContent(true);
    this.footer.Reparent(this.panel);
    this.tools = new inkHorizontalPanel();
    this.tools.SetHAlign(inkEHorizontalAlign.Right);
    this.tools.SetFitToContent(true);
    this.tools.Reparent(this.panel);
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
    this.Draw();
    this.RevealAfterLayout();

    ArmoryOperation.Recover(this.access);
  }

  protected cb func OnDetach() -> Void {
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

  private func Row(label: String, action: CName, opt value: Int32, opt detail: String) {
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

    let button = this.target == this.footer || this.target == this.tools || this.target == this.previewControls;
    let width = button ? 390.0 : 1130.0;
    if Equals(action, n"new") { width = 640.0; }
    if Equals(action, n"manage") || Equals(action, n"equip") { width = 275.0; }
    if Equals(action, n"position") { width = 430.0; }
    let hasDetail = StrLen(detail) > 0;
    let source = Equals(action, n"source");
    let height = this.target == this.body ? 104.0 : (button ? 78.0 : 68.0);
    let groupStart = Equals(action, n"pick") && (value == 0 || value == 3 || value == 6);
    let top = groupStart ? 17.0 : 6.0;
    let tile = new inkCanvas();
    tile.SetName(StringToName(ToString(ArraySize(this.tiles))));
    tile.SetSize(width, height);
    tile.SetMargin(inkMargin(0.0, top, button ? 14.0 : 0.0, 6.0));
    tile.SetInteractive(true);
    tile.SetChildOrder(inkEChildOrder.Forward);
    tile.Reparent(this.target);

    let frame = new inkImage();
    frame.SetAnchor(inkEAnchor.Fill);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    if button {
      let backing = new inkImage();
      backing.SetAnchor(inkEAnchor.Fill);
      backing.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
      backing.SetTexturePart(n"cell_bg");
      backing.SetNineSliceScale(true);
      this.Color(backing, n"MainColors.Black");
      backing.Reparent(tile);
    };
    frame.SetTexturePart(n"cell_fg");
    frame.SetNineSliceScale(true);
    this.Color(frame, (button || source) ? n"MainColors.Blue" : n"MainColors.Red");
    frame.Reparent(tile);
    row.SetAnchor(inkEAnchor.Fill);
    row.SetMargin(inkMargin(24.0, 0.0, source ? width * 0.5 : 20.0, hasDetail && !source ? 35.0 : 0.0));
    row.SetFontSize(button ? 38 : 33);
    row.SetVerticalAlignment(textVerticalAlignment.Center);
    if button { row.SetLetterCase(textLetterCase.UpperCase); }
    row.SetWrapping(false, width-44.0);
    row.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    this.Color(row, button ? n"MainColors.Red" : n"MainColors.White");
    row.Reparent(tile);
    if hasDetail {
      let parts = new inkText();
      parts.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Regular");
      parts.SetFontSize(source ? 33 : 29);
      parts.SetText(detail);
      parts.SetAnchor(inkEAnchor.Fill);
      parts.SetMargin(inkMargin(source ? width * 0.5 : 24.0, source ? 0.0 : 42.0, 20.0, 0.0));
      if source {
        parts.SetHorizontalAlignment(textHorizontalAlignment.Right);
        parts.SetInteractive(true);
        parts.RegisterToCallback(n"OnRelease", this, n"OnRow");
      }
      parts.SetVerticalAlignment(textVerticalAlignment.Center);
      parts.SetWrapping(false, width-44.0);
      parts.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
      this.Color(parts, source ? n"MainColors.Blue" : n"MainColors.Grey");
      parts.Reparent(tile);
    }
    tile.RegisterToCallback(n"OnRelease", this, n"OnRow");
    tile.RegisterToCallback(n"OnEnter", this, n"OnHover");
    tile.RegisterToCallback(n"OnLeave", this, n"OnLeaveRow");
    ArrayPush(this.tiles, tile);
    ArrayPush(this.accents, frame);
    ArrayPush(this.actions, action);
    ArrayPush(this.values, value);
    ArrayPush(this.texts, row);

    if this.target == this.body { 
      this.contentHeight += height + top + 6.0; 
    }
  }

  private func Paint(i: Int32) {
    if i < 0 || i >= ArraySize(this.tiles) { return; }
    let lit = (this.keyboardFocus && i == this.focus) || i == this.hovered;
    let loadout = Equals(this.actions[i], n"select");
    let selected = loadout && this.values[i] == this.selected;
    let externalButton = this.tiles[i].GetParentWidget() == this.footer || this.tiles[i].GetParentWidget() == this.tools || this.tiles[i].GetParentWidget() == this.previewControls;
    let persistentFrame = externalButton || Equals(this.actions[i], n"source");
    this.accents[i].SetVisible(loadout ? selected : (persistentFrame || lit));
    this.accents[i].SetOpacity(i == this.hovered ? 0.9 : (lit || selected ? 0.68 : (persistentFrame ? 0.55 : 0.25)));
    if externalButton {
      this.texts[i].UnbindProperty(n"tintColor");
      this.texts[i].BindProperty(n"tintColor", lit ? n"MainColors.White" : n"MainColors.Red");
    }
    this.texts[i].SetOpacity(lit ? 1.0 : (loadout ? 0.72 : 0.88));
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
    let old = this.focus;
    if this.hovered != i { this.GetGameController().PlaySound(n"Button", n"OnHover"); }
    this.keyboardFocus = false;
    this.focus = i;
    this.hovered = i;
    this.Paint(old);
    this.Paint(i);
  }

  protected cb func OnLeaveRow(e: ref<inkPointerEvent>) -> Bool {
    let i = this.hovered;
    if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i] == e.GetCurrentTarget() {
      this.hovered = -1;
      this.Paint(i);
    }
  }
  
  private func Status(set: ref<Loadout>) -> String {
    let reason = this.view.Problem(set, false);
    if StrLen(reason) > 0 { return reason; }
    let choice = this.wardrobe.Find(set);
    if IsNameValid(set.wardrobe) && (!IsDefined(choice) || !choice.valid || this.wardrobe.locked) { return Label("MissingOutfit"); }
    return this.view.Matches(set) && (!IsDefined(choice)||choice.wearing) ? Label("Equipped") : "";
  }

  private func FieldLabel(field: Int32) -> String {
    if field < 6 { return SlotLabel(field); }
    if field == 6 { return Label("CombatGadget"); }
    return field == 7 ? Label("Healing") : Label("Outfit");
  }

  private func ItemRow(item: ref<ArmoryItem>, slot: String, action: CName, value: Int32) {
    let detail = slot+" · "+(item.carried ? Label("Carried") : Label("InStash"));
    this.Row(item.Title(), action, value, detail);
  }

  private func EditItem(field: Int32, id: ItemID, fallback: String) {
    let slot = this.FieldLabel(field);
    let item = this.view.Find(id);
    if IsDefined(item) { this.ItemRow(item, slot, n"pick", field); }
    else { this.PlaceholderRow(field, n"pick", field, fallback); }
  }

  private func PlaceholderRow(field: Int32, action: CName, value: Int32, status: String) {
    if field < 6 {
      this.Row(Label("WeaponPosition")+" "+ToString(1+field%3), action, value, (field < 3 ? Label("RightHand") : Label("LeftHand"))+" · "+status);
    }
    else { this.Row(this.FieldLabel(field), action, value, status); }
  }

  private func Draw() {
    this.heading.RemoveAllChildren();
    this.body.RemoveAllChildren();
    this.footer.RemoveAllChildren();
    this.tools.RemoveAllChildren();
    this.previewControls.RemoveAllChildren();
    this.contentHeight = 0.0;
    this.hovered = -1;
    this.target = this.heading;
    ArrayClear(this.tiles); ArrayClear(this.accents);
    ArrayClear(this.actions); ArrayClear(this.values); ArrayClear(this.texts);
    let set = this.Selected();
    this.shell.SetTitle(Equals(this.mode, n"picker") ? this.FieldLabel(this.field) : (IsDefined(this.draft) ? Label("Edit") : Label("Loadouts")));
    if StrLen(this.reason) > 0 { this.Row(this.reason, n""); }
    this.target = this.body;
    if Equals(this.mode, n"picker") { this.DrawPicker(); }
    else {
      if IsDefined(this.draft) {
        this.Row(NameToString(set.title), n"name", 0, Label("NameLabel"));
        let i = 0;
        while i < 6 {
          this.EditItem(i, set.weapons[i], ItemID.IsValid(set.weapons[i]) ? Label("MissingWeapon") : Label("EmptySlot"));
          i += 1;
        };
 
        this.EditItem(6, this.view.Assignment(set.gadget, set.gadgetFamily, EHotkey.RB), ItemID.IsValid(set.gadget) ? Label("MissingAssignment") : Label("KeepCurrent"));
        this.EditItem(7, this.view.Assignment(set.healing, set.healingFamily, EHotkey.DPAD_UP), ItemID.IsValid(set.healing) ? Label("MissingAssignment") : Label("KeepCurrent"));
        let outfit = this.wardrobe.Find(set);
        if IsDefined(outfit) { this.Row(outfit.Title(), n"pick", 8, Label("Outfit")); }
        else { this.Row(Label("Outfit"), n"pick", 8, IsNameValid(set.wardrobe) ? Label("MissingOutfit") : Label("KeepCurrent")); }
        this.target = this.footer;
        this.Row(Label("Save"), n"save");
        this.Row(Label("DiscardChanges"), n"back");
      } else {
        if ArraySize(this.system.sets) == 0 { this.target = this.heading; this.Row(Label("EmptyList"), n""); this.target = this.body; }
        let i = 0;
        while i < ArraySize(this.system.sets) {
          let preset = this.system.sets[i];
          this.Row(NameToString(preset.title), n"select", i,this.Status(preset));
          i += 1;
        };

        this.target = this.footer;

        if IsDefined(set) {
          this.Row(Label("Equip"), n"equip");
          this.Row(Label("Manage"), n"manage");
          if Equals(this.mode, n"manage") {
            this.target = this.tools;
            this.Row(Label("Edit"), n"edit"); this.Row(Label("Duplicate"), n"copy"); this.Row(Label("Delete"), n"delete");
          }
        }
        this.target = this.footer;
        this.Row(Label("CreateFromCurrent"), n"new");
      };
    };

    if IsDefined(set) {
      this.target = this.previewControls;
      if Equals(this.mode, n"picker") { this.Row(Label("Back"), n"back"); }
      this.Row(this.PositionLabel(), n"position");
      if IsDefined(this.preview) { this.preview.Select(this.view, set, this.wardrobe.Find(set), this.position); }
    } else { 
      if IsDefined(this.preview) { 
        this.preview.Select(this.view, null, null, 0); 
      } ;
    };

    let editing = Equals(this.mode, n"edit");
    this.panel.SetTranslation(Vector2(-350.0, editing ? 200.0 : 0.0));
    let visibleHeight = editing ? this.contentHeight : MinF(this.contentHeight, 720.0);
    this.viewport.SetSize(1160.0, visibleHeight);
    this.viewport.SetVisible(visibleHeight > 0.0);
    let width = IsDefined(set) ? 1280.0 : 690.0;
    this.shell.GetRootCompoundWidget().GetWidgetByPathName(n"minSize").SetSize(width, 190.0);
    this.shell.GetRootCompoundWidget().GetWidgetByPathName(n"wrapper/right").SetSize(width-40.0, 180.0);
    this.footer.SetVisible(this.footer.GetNumChildren() > 0);
    this.tools.SetVisible(this.tools.GetNumChildren() > 0);
    this.previewControls.SetVisible(IsDefined(set));
    this.footer.SetMargin(inkMargin(0.0, 14.0, 0.0, 0.0));
    this.previewControls.SetMargin(inkMargin(0.0, Equals(this.mode, n"picker") ? 14.0 : 0.0, 0.0, 0.0));
    this.focus = Clamp(this.focus, 0, Max(0, ArraySize(this.actions)-1));
    let i = 0;
    while i < ArraySize(this.actions) { this.Paint(i); i += 1; }
  }

  private func PositionLabel() -> String {
    return Label("WeaponPosition")+"   "+ToString(this.position+1)+" / 3   >";
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
    this.PlaceholderRow(this.field, n"choose", -1, this.field < 6 ? Label("EmptySlot") : Label("KeepCurrent"));
    if this.field == 8 {
      let i = 0;
      while i < ArraySize(this.wardrobe.choices) { this.Row(this.wardrobe.choices[i].Title(), n"choose", i, slot); i += 1; }
    } else {
      let rows = this.Choices();
      let end = this.field < 6 && !this.stored ? this.view.carriedWeapons : ArraySize(rows);
      while first < end {
        let item = rows[first];
        this.ItemRow(item, slot, n"choose", first);
        first += 1;
      }
    }
  }

  protected cb func OnRow(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") && !e.IsHandled() {
      let target = e.GetCurrentTarget();
      if IsDefined(target as inkText) { target = target.GetParentWidget(); }
      let i = StringToInt(NameToString(target.GetName()));
      if i >= 0 && i < ArraySize(this.tiles) && this.tiles[i] == target {
        e.Handle();
        this.Act(i);
        return true;
      }
    }
  }

  protected cb func OnGlobalReleaseInput(e: ref<inkPointerEvent>) -> Bool {
    if IsDefined(this.dialog) || !this.IsTopPopup() || e.IsHandled() { return false; }
    if e.IsAction(n"cancel") && (IsDefined(this.draft)||IsNameValid(this.mode)) { e.Handle(); this.Back(); return true; }
    let up = e.IsAction(n"popup_navigate_up");
    if up || e.IsAction(n"popup_navigate_down") {
      let old = this.focus;
      this.keyboardFocus = true;
      this.hovered = -1;
      this.focus = (this.focus+ArraySize(this.actions)+(up ? -1 : 1)) % Max(1, ArraySize(this.actions));
      this.Paint(old); this.Paint(this.focus); this.Reveal(this.focus);
      e.Handle(); return true;
    }
    if e.IsAction(n"activate") || e.IsAction(n"proceed") { e.Handle(); this.Act(this.focus); return true; }
    return super.OnGlobalReleaseInput(e);
  }

  private func Back() {
    if Equals(this.mode, n"picker") { this.mode = n"edit"; }
    else { this.draft = null; this.mode = n""; }
    this.reason = ""; this.focus = IsDefined(this.draft) ? this.field+1 : this.selected; this.Refresh(); this.Draw(); this.RevealAfterLayout();
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
        this.field = value; this.stored = false; this.mode = n"picker";
        break;
      case n"choose": this.Choose(value); break;
      case n"source": this.stored = !this.stored; break;
      case n"position":
        this.position = (this.position+1)%3;
        this.texts[i].SetText(this.PositionLabel());
        let set = this.Selected();
        if IsDefined(this.preview) { this.preview.Select(this.view, set, this.wardrobe.Find(set), this.position); }
        return;
      case n"save":
        this.selected = this.system.Save(this.draft); this.Back(); return;
      case n"back": this.Back(); return;
      case n"equip":
        this.reason = ArmoryOperation.Start(this.access, this.Selected()); break;
    }
    this.focus = Equals(action, n"select") ? this.selected : (Equals(action, n"choose") ? this.field+1 : 0);
    this.Draw();
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

  private func RevealAfterLayout() {
    if this.focus < 0 || this.focus >= ArraySize(this.tiles) || this.tiles[this.focus].GetParentWidget() != this.body { return; }
    let callback = new ArmoryScrollToFocus();
    callback.screen = this;
    callback.tile = this.tiles[this.focus];
    GameInstance.GetDelaySystem(this.access.player.GetGame()).DelayCallbackNextFrame(callback);
  }

  public func RevealCurrent(tile: wref<inkWidget>) {
    if !this.closing && IsDefined(tile) && this.focus >= 0 && this.focus < ArraySize(this.tiles) && this.tiles[this.focus] == tile {
      this.Reveal(this.focus);
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
    this.mode = n"edit";
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
