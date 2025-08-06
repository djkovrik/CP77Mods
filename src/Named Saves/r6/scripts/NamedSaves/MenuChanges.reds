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
  container.SetTranslation(new Vector2(730.0, 140.0));
  container.SetHAlign(inkEHorizontalAlign.Left);
  container.SetVAlign(inkEVerticalAlign.Center);
  container.SetAnchor(inkEAnchor.CenterLeft );
  container.SetAnchorPoint(new Vector2(1.0, 0.0));
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
  if NotEquals(inputText, "") {
    if NamedSavesConfig.ShouldRememberLastUsed() {
      NamedSavesEnv.SetName(inputText);
    };

    AddCustomNoteToNewestSave(inputText);
    this.m_nameInput.SetText("");
  };

  wrappedMethod(success, locks);
}


// --- LOAD SAVE MENU

@addField(LoadListItem)
public let m_customNote: wref<inkText>;

@addField(LoadListItem)
public let m_customNoteText: String;

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
  newText.SetMargin(new inkMargin(20.0, 0.0, 50.0, 0.0));
  newText.SetAnchorPoint(new Vector2(1.0, 1.0));
  newText.SetOpacity(0.6);
  newText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  newText.BindProperty(n"tintColor", n"MainColors.Green");
  newText.Reparent(container);
  this.m_customNote = newText;
  container.SetChildOrder(inkEChildOrder.Backward);
}

// Read custom notes by save index
@wrapMethod(LoadListItem)
public final func SetMetadata(metadata: ref<SaveMetadataInfo>, opt isEp1Enabled: Bool) -> Void {
  wrappedMethod(metadata, isEp1Enabled);

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

  public final static func Create(query: String, lifepath: LifePathFilter, type: SaveTypeFilter) -> ref<NamedSavesSearchEvent> {
    let instance: ref<NamedSavesSearchEvent> = new NamedSavesSearchEvent();
    instance.query = query;
    instance.lifepath = lifepath;
    instance.type = type;
    return instance;
  }
}

@addField(LoadGameMenuGameController)
private let m_searchInput: wref<HubTextInput>;

@wrapMethod(LoadGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let outerContainer: ref<inkCompoundWidget> = root.GetWidget(n"holder") as inkCompoundWidget;

  let container = new inkVerticalPanel();
  container.SetName(n"InputContainer");
  container.SetFitToContent(true);
  container.SetTranslation(new Vector2(730.0, 140.0));
  container.SetHAlign(inkEHorizontalAlign.Left);
  container.SetVAlign(inkEVerticalAlign.Center);
  container.SetAnchor(inkEAnchor.CenterLeft );
  container.SetAnchorPoint(new Vector2(1.0, 0.0));
  container.Reparent(outerContainer, 1);

  let input: ref<HubTextInput> = HubTextInput.Create(); 
  input = HubTextInput.Create();
  input.SetName(n"InputText");
  input.SetDefaultText(GetLocalizedText("LocKey#48662"));
  input.SetMaxLength(64);
  input.RegisterToCallback(n"OnInput", this, n"OnSearchInput");
  input.Reparent(container);
  this.m_searchInput = input;
}

@if(!ModuleExists("FilterSaves"))
@addMethod(LoadGameMenuGameController)
protected cb func OnSearchInput(widget: wref<inkWidget>) {
  let inputQuery: String = UTF8StrLower(this.m_searchInput.GetText());
  let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());
  uiSystem.QueueEvent(NamedSavesSearchEvent.Create(inputQuery));
}

@if(ModuleExists("FilterSaves"))
@addMethod(LoadGameMenuGameController)
protected cb func OnSearchInput(widget: wref<inkWidget>) {
  let inputQuery: String = UTF8StrLower(this.m_searchInput.GetText());
  let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());
  uiSystem.QueueEvent(NamedSavesSearchEvent.Create(inputQuery, this.m_lifePathFilter, this.m_saveTypeFilter));
}

@if(!ModuleExists("FilterSaves"))
@addMethod(LoadListItem)
protected cb func OnNamedSavesSearchEvent(evt: ref<NamedSavesSearchEvent>) -> Bool {
  let root: ref<inkWidget> = this.GetRootCompoundWidget();
  let isVisible: Bool = root.IsVisible();
  let shouldShow: Bool = Equals(evt.query, "") || StrContains(this.m_customNoteText, evt.query);

  if NotEquals(isVisible, shouldShow) {
    root.SetVisible(shouldShow);
  };
}

@if(ModuleExists("FilterSaves"))
@addMethod(LoadListItem)
protected cb func OnNamedSavesSearchEvent(evt: ref<NamedSavesSearchEvent>) -> Bool {
  let root: ref<inkWidget> = this.GetRootCompoundWidget();
  let isVisible: Bool = root.IsVisible();
  let filteredBySearch: Bool = Equals(evt.query, "") || StrContains(this.m_customNoteText, evt.query);
  let filteredByLifepath: Bool = Equals(this.m_lifepathCompat, evt.lifepath) || Equals(evt.lifepath, LifePathFilter.All);
  let filteredBySaveType: Bool = Equals(this.m_saveTypeCompat, evt.type) || Equals(evt.type, SaveTypeFilter.All);
  let shouldShow: Bool = filteredBySearch && filteredByLifepath && filteredBySaveType;

  if NotEquals(isVisible, shouldShow) {
    root.SetVisible(shouldShow);
  };
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
    this.m_searchInput.SetText("");
  };
}
