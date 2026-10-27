module NamedSaves.UI
import NamedSaves.Config.*
import Codeware.UI.*
import NamedSaves.Utils.*

@if(ModuleExists("FilterSaves"))
import FilterSaves.*

// --- SAVE GAME MENU

@addField(SaveGameMenuGameController)
private let m_nameInput: wref<HubTextInput>;

@wrapMethod(SaveGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  // Insert input
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let outerContainer: ref<inkCompoundWidget> = root.GetWidget(n"holder") as inkCompoundWidget;

  let container = new inkVerticalPanel();
  container.SetName(n"InputContainer");
  container.SetFitToContent(true);
  container.SetTranslation(Vector2(730.0, 140.0));
  container.SetHAlign(inkEHorizontalAlign.Left);
  container.SetVAlign(inkEVerticalAlign.Center);
  container.SetAnchor(inkEAnchor.CenterLeft );
  container.SetAnchorPoint(Vector2(1.0, 0.0));
  container.Reparent(outerContainer, 1);

  let input: ref<HubTextInput> = HubTextInput.Create(); 
  input = HubTextInput.Create();
  input.SetName(n"InputText");
  input.SetMaxLength(64);
  input.Reparent(container);
  this.m_nameInput = input;

  if NamedSavesConfig.ShouldRememberLastUsed() && NamedSavesEnv.IsNotEmpty() {
    let savedText: String = NamedSavesEnv.GetName();
    this.m_nameInput.SetText(savedText);
  }
}

// Reset input focus on elsewhere click - copy-pasted from psiberx samples ^^
@wrapMethod(SaveGameMenuGameController)
protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.IsAction(n"mouse_left") {
    if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
      this.RequestSetFocus(null);
    };
  };
}

// Save input text on save completion event
@wrapMethod(SaveGameMenuGameController)
protected cb func OnSavingComplete(success: Bool, locks: array<gameSaveLock>) -> Bool {
  let inputText: String = this.m_nameInput.GetText();
  if success && NotEquals(inputText, "") && TryAddCustomNoteToNewestSave(inputText) {
    if NamedSavesConfig.ShouldRememberLastUsed() {
      NamedSavesEnv.SetName(inputText);
    };

    this.m_nameInput.SetText("");
  };

  wrappedMethod(success, locks);
}


// --- LOAD SAVE MENU

@addField(LoadListItem)
public let m_customNote: wref<inkText>;

@addField(LoadListItem)
public let m_customNoteText: String;

@addField(LoadListItem)
private let m_namedSavesMenu: wref<LoadGameMenuGameController>;

@addField(LoadListItem)
private let m_namedSavesGroupExpanded: Bool;

@if(ModuleExists("FilterSaves"))
@addField(LoadListItem)
public let m_lifepathCompat: LifePathFilter;

@if(ModuleExists("FilterSaves"))
@addField(LoadListItem)
public let m_saveTypeCompat: SaveTypeFilter;

@wrapMethod(LoadListItem)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidget(n"Not_Empty_Slot/inkHorizontalPanelWidget3") as inkCompoundWidget;

  let newText = new inkText();
  newText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  newText.SetName(n"NamedSaveLabel");
  newText.SetFontStyle(n"Regular");
  newText.SetFontSize(38);
  newText.SetLetterCase(textLetterCase.OriginalCase);
  newText.SetFitToContent(true);
  newText.SetHAlign(inkEHorizontalAlign.Fill);
  newText.SetVAlign(inkEVerticalAlign.Fill);
  newText.SetAnchor(inkEAnchor.BottomRight);
  newText.SetMargin(inkMargin(20.0, 0.0, 50.0, 0.0));
  newText.SetAnchorPoint(Vector2(1.0, 1.0));
  newText.SetOpacity(0.6);
  newText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  newText.BindProperty(n"tintColor", n"MainColors.Green");
  newText.Reparent(container);
  this.m_customNote = newText;
  container.SetChildOrder(inkEChildOrder.Backward);
}

// Read custom notes by save index
@wrapMethod(LoadListItem)
public final func SetMetadata(metadata: ref<SaveMetadataInfo>, isVisible: Bool, opt isEp1Enabled: Bool) -> Void {
  wrappedMethod(metadata, isVisible, isEp1Enabled);
  this.m_namedSavesGroupExpanded = isVisible;

  let index: Int32 = GetSaveIndexFromInternalName(metadata.internalName);
  let note: String = GetNoteForSaveIndex(index);
  this.m_customNoteText = UTF8StrLower(note);
  this.RefreshCompatSaveInfo(metadata);

  if NotEquals(index, -1) && NotEquals(note, "") {
    this.m_customNote.SetVisible(true);
    this.m_customNote.SetText(note);
  } else {
    this.m_customNote.SetVisible(false);
  };

  if IsDefined(this.m_namedSavesMenu) {
    this.OnNamedSavesSearchEvent(this.m_namedSavesMenu.CreateNamedSavesSearchEvent());
    this.m_namedSavesMenu.RequestNamedSavesRefresh();
  };
}

@wrapMethod(LoadListItem)
public final func SetInvalid(const label: script_ref<String>, isVisible: Bool) -> Void {
  wrappedMethod(label, isVisible);
  this.m_namedSavesGroupExpanded = isVisible;
  this.m_customNoteText = "";
  this.m_customNote.SetVisible(false);
  if IsDefined(this.m_namedSavesMenu) {
    this.OnNamedSavesSearchEvent(this.m_namedSavesMenu.CreateNamedSavesSearchEvent());
    this.m_namedSavesMenu.RequestNamedSavesRefresh();
  };
}

@addMethod(LoadListItem)
public final func SetNamedSavesMenu(menu: wref<LoadGameMenuGameController>, evt: ref<NamedSavesSearchEvent>) -> Void {
  this.m_namedSavesMenu = menu;
  this.OnNamedSavesSearchEvent(evt);
}

@addMethod(LoadListItem)
public final func RefreshNamedSavesGroupVisibility(expanded: Bool, evt: ref<NamedSavesSearchEvent>) -> Bool {
  this.m_namedSavesGroupExpanded = expanded;
  return this.ApplyNamedSavesSearch(evt);
}

@if(!ModuleExists("FilterSaves"))
@addMethod(LoadListItem)
private final func RefreshCompatSaveInfo(metadata: ref<SaveMetadataInfo>) {
  // do nothing
}

@if(ModuleExists("FilterSaves"))
@addMethod(LoadListItem)
private final func RefreshCompatSaveInfo(metadata: ref<SaveMetadataInfo>) {
  switch metadata.lifePath {
    case inkLifePath.Corporate:
      this.m_lifepathCompat = LifePathFilter.Corpo;
      break;
    case inkLifePath.Nomad:
      this.m_lifepathCompat = LifePathFilter.Nomad;
      break;
    case inkLifePath.StreetKid:
      this.m_lifepathCompat = LifePathFilter.StreetKid;
      break;
    case inkLifePath.Invalid:
      this.m_lifepathCompat = LifePathFilter.Invalid;
      break;
    default:
      break;
  };

  switch metadata.saveType {
    case inkSaveType.ManualSave:
      this.m_saveTypeCompat = SaveTypeFilter.ManualSaves;
      break;
    case inkSaveType.QuickSave:
      this.m_saveTypeCompat = SaveTypeFilter.QuickSaves;
      break;
    case inkSaveType.AutoSave:
      this.m_saveTypeCompat = SaveTypeFilter.AutoSaves;
      break;
    case inkSaveType.PointOfNoReturn:
      this.m_saveTypeCompat = SaveTypeFilter.PointOfNoReturn;
      break;
    default:
      break;
  };
}

@if(!ModuleExists("FilterSaves"))
public class NamedSavesSearchEvent extends Event {
  public let query: String;

  public final static func Create(query: String) -> ref<NamedSavesSearchEvent> {
    let instance: ref<NamedSavesSearchEvent> = new NamedSavesSearchEvent();
    instance.query = query;
    return instance;
  }
}

@if(ModuleExists("FilterSaves"))
public class NamedSavesSearchEvent extends Event {
  public let query: String;
  public let lifepath: LifePathFilter;
  public let type: SaveTypeFilter;
  public let questFilter: String;

  public final static func Create(query: String, lifepath: LifePathFilter, type: SaveTypeFilter, text: String) -> ref<NamedSavesSearchEvent> {
    let instance: ref<NamedSavesSearchEvent> = new NamedSavesSearchEvent();
    instance.query = query;
    instance.lifepath = lifepath;
    instance.type = type;
    instance.questFilter = text;
    return instance;
  }
}

@addField(LoadGameMenuGameController)
private let searchInput: wref<HubTextInput>;

@wrapMethod(LoadGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  let config: ref<NamedSavesConfig> = new NamedSavesConfig();
  this.namedSavesSearchAllCategories = config.searchAllCategories;
  this.namedSavesHideCategoryHeaders = config.hideCategoryHeaders;
  wrappedMethod();

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let outerContainer: ref<inkCompoundWidget> = root.GetWidget(n"holder") as inkCompoundWidget;

  let container = new inkVerticalPanel();
  container.SetName(n"InputContainer");
  container.SetFitToContent(true);
  container.SetTranslation(Vector2(730.0, 140.0));
  container.SetHAlign(inkEHorizontalAlign.Left);
  container.SetVAlign(inkEVerticalAlign.Center);
  container.SetAnchor(inkEAnchor.CenterLeft );
  container.SetAnchorPoint(Vector2(1.0, 0.0));
  container.Reparent(outerContainer, 1);

  let input: ref<HubTextInput> = HubTextInput.Create(); 
  input = HubTextInput.Create();
  input.SetName(n"InputText");
  input.SetDefaultText(GetLocalizedText("LocKey#48662"));
  input.SetMaxLength(64);
  input.RegisterToCallback(n"OnInput", this, n"OnSearchInput");
  input.Reparent(container);
  this.searchInput = input;
  this.namedSavesReady = true;
}

@addMethod(LoadGameMenuGameController)
protected cb func OnSearchInput(widget: wref<inkWidget>) {
  if this.namedSavesSearchAllCategories {
    this.RefreshNamedSavesSearch(true);
  } else {
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());
    uiSystem.QueueEvent(this.CreateNamedSavesSearchEvent());
  };
}

@if(!ModuleExists("FilterSaves"))
@addMethod(LoadGameMenuGameController)
public final func CreateNamedSavesSearchEvent() -> ref<NamedSavesSearchEvent> {
  let inputQuery: String = "";
  if IsDefined(this.searchInput) {
    inputQuery = UTF8StrLower(this.searchInput.GetText());
  };
  return NamedSavesSearchEvent.Create(inputQuery);
}

@if(ModuleExists("FilterSaves"))
@addMethod(LoadGameMenuGameController)
public final func CreateNamedSavesSearchEvent() -> ref<NamedSavesSearchEvent> {
  let inputQuery: String = "";
  if IsDefined(this.searchInput) {
    inputQuery = UTF8StrLower(this.searchInput.GetText());
  };
  return NamedSavesSearchEvent.Create(inputQuery, this.m_lifePathFilter, this.m_saveTypeFilter, this.filterSavesSearchText);
}

@wrapMethod(LoadGameMenuGameController)
private final func SetupLoadItems(const saves: script_ref<array<String>>) -> Void {
  wrappedMethod(saves);

  let evt: ref<NamedSavesSearchEvent> = this.CreateNamedSavesSearchEvent();
  let count: Int32 = inkCompoundRef.GetNumChildren(this.m_list);
  let index: Int32 = 0;
  let controller: wref<LoadListItem>;
  while index < count {
    controller = inkCompoundRef.GetWidgetByIndex(this.m_list, index).GetController() as LoadListItem;
    if IsDefined(controller) {
      controller.SetNamedSavesMenu(this, evt);
    };
    index += 1;
  };
  this.RefreshNamedSavesSearch(false);
}

@wrapMethod(LoadGameMenuGameController)
private final func SetVisibilityOfSavesInGroup(playthroughIndex: Int32, newVisibility: Bool) -> Void {
  wrappedMethod(playthroughIndex, newVisibility);

  if this.namedSavesSearchingAll {
    if this.namedSavesHideCategoryHeaders {
      newVisibility = true;
      let header: wref<inkWidget> = this.m_saveGroupHeaderWidgets[playthroughIndex];
      if IsDefined(header) {
        let groupController: wref<LoadListGroup> = header.GetController() as LoadListGroup;
        if IsDefined(groupController) {
          groupController.SetExpandedState(true);
        };
      };
    } else {
      this.namedSavesGroups[playthroughIndex].expandedInSearch = newVisibility;
    };
  };

  let evt: ref<NamedSavesSearchEvent> = this.CreateNamedSavesSearchEvent();
  let buttons: array<wref<inkWidget>> = this.m_saveWidgetsMap[playthroughIndex];
  let controller: wref<LoadListItem>;
  for button in buttons {
    controller = button.GetController() as LoadListItem;
    if IsDefined(controller) {
      controller.RefreshNamedSavesGroupVisibility(newVisibility, evt);
    };
  };
}

@if(!ModuleExists("FilterSaves"))
@addMethod(LoadListItem)
private final func MatchesNamedSavesSearch(evt: ref<NamedSavesSearchEvent>) -> Bool {
  return Equals(evt.query, "") || StrContains(this.m_customNoteText, evt.query);
}

@if(ModuleExists("FilterSaves"))
@addMethod(LoadListItem)
private final func MatchesNamedSavesSearch(evt: ref<NamedSavesSearchEvent>) -> Bool {
  let filteredBySearch: Bool = Equals(evt.query, "") || StrContains(this.m_customNoteText, evt.query);
  let filteredByLifepath: Bool = Equals(this.m_lifepathCompat, evt.lifepath) || Equals(evt.lifepath, LifePathFilter.All);
  let filteredBySaveType: Bool = Equals(this.m_saveTypeCompat, evt.type) || Equals(evt.type, SaveTypeFilter.All);
  let filteredByQuest: Bool = this.DoesSavePassQuestFilter(evt.questFilter);
  return filteredBySearch && filteredByLifepath && filteredBySaveType && filteredByQuest;
}

@addMethod(LoadListItem)
private final func ApplyNamedSavesSearch(evt: ref<NamedSavesSearchEvent>) -> Bool {
  if !IsDefined(this.m_namedSavesMenu) {
    return false;
  };
  let root: ref<inkWidget> = this.GetRootCompoundWidget();
  let matches: Bool = this.IsMetadataSet() && this.MatchesNamedSavesSearch(evt);
  let shouldShow: Bool = this.m_namedSavesGroupExpanded && matches;

  if NotEquals(this.IsVisible(), shouldShow) {
    this.SetVisible(shouldShow);
  };
  if NotEquals(root.IsVisible(), shouldShow) {
    root.SetVisible(shouldShow);
  };
  return matches;
}

@addMethod(LoadListItem)
protected cb func OnNamedSavesSearchEvent(evt: ref<NamedSavesSearchEvent>) -> Bool {
  this.ApplyNamedSavesSearch(evt);
}

// Reset input focus on elsewhere click - copy-pasted from psiberx samples ^^
@wrapMethod(LoadGameMenuGameController)
protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.IsAction(n"mouse_left") {
    if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
      this.RequestSetFocus(null);
    };
  };
}

@if(ModuleExists("FilterSaves"))
@wrapMethod(LoadGameMenuGameController)
protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.IsAction(GetLifepathFilterButtonAction()) || evt.IsAction(GetSaveTypeFilterButtonAction()) {
    this.searchInput.SetText("");
  };
}
