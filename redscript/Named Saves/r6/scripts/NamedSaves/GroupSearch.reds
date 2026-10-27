module NamedSaves.UI
import Codeware.UI.*

public class NamedSavesRefreshEvent extends Event {}

@addField(LoadGameMenuGameController)
private let namedSavesSearchAllCategories: Bool;

@addField(LoadGameMenuGameController)
private let namedSavesHideCategoryHeaders: Bool;

@addField(LoadGameMenuGameController)
private let namedSavesSearchingAll: Bool;

@addField(LoadGameMenuGameController)
private let namedSavesReady: Bool;

@addField(LoadGameMenuGameController)
private let namedSavesRefreshPending: Bool;

@addField(LoadGameMenuGameController)
private let namedSavesLastInput: String;

@addField(LoadGameMenuGameController)
private let namedSavesGroups: array<ref<NamedSavesGroupState>>;

@addField(LoadGameMenuGameController)
private let namedSavesGroupSnapshots: ref<inkHashMap>;

public class NamedSavesGroupState extends IScriptable {
  public let playthroughID: String;
  public let expandedBeforeSearch: Bool;
  public let expandedInSearch: Bool;
  private let next: ref<NamedSavesGroupState>;

  public static func Find(snapshots: ref<inkHashMap>, playthroughID: String) -> ref<NamedSavesGroupState> {
    let state: ref<NamedSavesGroupState> = snapshots.Get(FNV1a64(playthroughID)) as NamedSavesGroupState;
    while IsDefined(state) {
      if Equals(state.playthroughID, playthroughID) {
        return state;
      };
      state = state.next;
    };
    return null;
  }

  public final func Store(snapshots: ref<inkHashMap>) -> Void {
    let key: Uint64 = FNV1a64(this.playthroughID);
    this.next = snapshots.Get(key) as NamedSavesGroupState;
    if snapshots.KeyExist(key) {
      snapshots.Set(key, this);
    } else {
      snapshots.Insert(key, this);
    };
  }

  public final func ClearSnapshot() -> Void {
    this.next = null;
  }
}

@wrapMethod(LoadGameMenuGameController)
private final func CreateNewSaveGroup(info: ref<SaveMetadataInfo>) -> Int32 {
  let index: Int32 = wrappedMethod(info);
  if this.namedSavesSearchAllCategories {
    let groupController: wref<LoadListGroup> = this.m_saveGroupHeaderWidgets[index].GetController() as LoadListGroup;
    let state: ref<NamedSavesGroupState>;
    if this.namedSavesSearchingAll {
      state = NamedSavesGroupState.Find(this.namedSavesGroupSnapshots, info.playthroughID);
    };
    if !IsDefined(state) {
      state = new NamedSavesGroupState();
      state.playthroughID = info.playthroughID;
      state.expandedBeforeSearch = groupController.GetExpandedState();
      state.expandedInSearch = true;
      if this.namedSavesSearchingAll {
        state.Store(this.namedSavesGroupSnapshots);
      };
    };
    ArrayPush(this.namedSavesGroups, state);
    if this.namedSavesSearchingAll {
      groupController.SetExpandedState(this.namedSavesHideCategoryHeaders || state.expandedInSearch);
      this.m_saveGroupHeaderWidgets[index].SetVisible(false);
    };
  };
  return index;
}

@wrapMethod(LoadGameMenuGameController)
private final func ResetSaveMetaData() -> Void {
  wrappedMethod();
  ArrayClear(this.namedSavesGroups);

  if !this.namedSavesSearchingAll {
    this.namedSavesGroupSnapshots = null;
  };
}

@addMethod(LoadGameMenuGameController)
public final func RequestNamedSavesRefresh() -> Void {
  if this.namedSavesReady && this.namedSavesSearchingAll && !this.namedSavesRefreshPending {
    this.namedSavesRefreshPending = true;
    this.QueueEvent(new NamedSavesRefreshEvent());
  };
}

@addMethod(LoadGameMenuGameController)
protected cb func OnNamedSavesRefreshEvent(evt: ref<NamedSavesRefreshEvent>) -> Bool {
  this.namedSavesRefreshPending = false;
  this.RefreshNamedSavesSearch(false);
}

@wrapMethod(LoadGameMenuGameController)
protected cb func OnSaveDeleted(result: Bool, idx: Int32) -> Bool {
  wrappedMethod(result, idx);
  if result {
    this.RequestNamedSavesRefresh();
  };
}

@wrapMethod(LoadGameMenuGameController)
protected cb func OnUninitialize() -> Bool {
  this.namedSavesReady = false;
  this.namedSavesRefreshPending = false;
  this.namedSavesSearchingAll = false;
  this.namedSavesSearchAllCategories = false;
  this.namedSavesGroupSnapshots = null;
  ArrayClear(this.namedSavesGroups);
  wrappedMethod();
}

@addMethod(LoadGameMenuGameController)
private final func RefreshNamedSavesSearch(expandResults: Bool) -> Void {
  if !this.namedSavesReady || !this.namedSavesSearchAllCategories {
    return;
  };
  let evt: ref<NamedSavesSearchEvent> = this.CreateNamedSavesSearchEvent();
  let inputText: String = this.searchInput.GetText();
  let inputChanged: Bool = expandResults && NotEquals(inputText, this.namedSavesLastInput);
  let searchingAll: Bool = NotEquals(evt.query, "");
  let enteringSearch: Bool = searchingAll && !this.namedSavesSearchingAll;
  let leavingSearch: Bool = !searchingAll && this.namedSavesSearchingAll;
  let index: Int32 = 0;
  let state: ref<NamedSavesGroupState>;
  let header: wref<inkWidget>;
  let groupController: wref<LoadListGroup>;
  let controller: wref<LoadListItem>;
  let buttons: array<wref<inkWidget>>;
  let expanded: Bool;
  let hasMatches: Bool;
  let headerVisible: Bool;
  this.namedSavesLastInput = inputText;
  this.namedSavesSearchingAll = searchingAll;
  if enteringSearch {
    this.namedSavesGroupSnapshots = new inkHashMap();
  };
  while index < ArraySize(this.namedSavesGroups) {
    state = this.namedSavesGroups[index];
    header = this.m_saveGroupHeaderWidgets[index];
    groupController = null;
    if IsDefined(header) {
      groupController = header.GetController() as LoadListGroup;
    };
    if IsDefined(groupController) {
      if enteringSearch {
        state.expandedBeforeSearch = groupController.GetExpandedState();
        state.Store(this.namedSavesGroupSnapshots);
      };
      expanded = groupController.GetExpandedState();
      if searchingAll {
        if enteringSearch || inputChanged {
          state.expandedInSearch = true;
        };
        expanded = this.namedSavesHideCategoryHeaders || state.expandedInSearch;
      } else {
        if leavingSearch {
          expanded = state.expandedBeforeSearch;
        };
      };
      groupController.SetExpandedState(expanded);
      hasMatches = false;
      buttons = this.m_saveWidgetsMap[index];
      for button in buttons {
        controller = button.GetController() as LoadListItem;
        if IsDefined(controller) {
          if controller.RefreshNamedSavesGroupVisibility(expanded, evt) {
            hasMatches = true;
          };
        };
      };
      headerVisible = !searchingAll || (!this.namedSavesHideCategoryHeaders && hasMatches);
      if NotEquals(header.IsVisible(), headerVisible) {
        header.SetVisible(headerVisible);
      };
    };
    if leavingSearch {
      state.ClearSnapshot();
    };
    index += 1;
  };
  if leavingSearch {
    this.namedSavesGroupSnapshots = null;
  };
}
