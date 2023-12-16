import Codeware.UI.*

// New buttons widget
public class PocketMetroNavButton extends HubLinkButton {

  public static func Create() -> ref<PocketMetroNavButton> {
    let self = new PocketMetroNavButton();
    self.CreateInstance();
    return self;
  }

  protected cb func OnCreate() {
      super.OnCreate();
      this.TweakAppearance();
  }

  public func SetVisible(visible: Bool) -> Void {
    this.m_root.SetVisible(visible);
  }

  private final func TweakAppearance() -> Void {
    this.m_icon.SetMargin(0.0, 30.0, 0.0, 6.0);
    this.m_icon.SetSize(new Vector2(82.0, 44.0));
    this.m_icon.SetTexturePart(n"ncart_logo_simple");
    this.m_icon.SetAtlasResource(r"base\\open_world\\metro\\ue_metro\\ui\\assets\\ue_metro_main_atlas.inkatlas");
  }
}

@addField(WorldMapMenuGameController)
public let metroButtonNavigate: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
public let metroButtonCancel: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
public let metroButtonStop: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
private let routeSelectionEnabled: Bool = false;

@addField(WorldMapMenuGameController)
private let previousCustomFilters: array<Int32>;

@wrapMethod(WorldMapMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.AddMetroPocketGuideControls();
}

// Create controls
@addMethod(WorldMapMenuGameController)
private final func AddMetroPocketGuideControls() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let parent: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"Content") as inkCompoundWidget;
  let buttonsContainer: ref<inkCompoundWidget> = new inkCanvas();
  buttonsContainer.SetName(n"buttonsContainer");
  buttonsContainer.SetAnchor(inkEAnchor.BottomCenter);
  buttonsContainer.SetFitToContent(true);
  buttonsContainer.SetInteractive(false);
  buttonsContainer.SetAnchorPoint(0.0, 0.5);
  buttonsContainer.SetMargin(0.0, 0.0, 0.0, 120.0);
  buttonsContainer.Reparent(parent);

  this.metroButtonNavigate = PocketMetroNavButton.Create();
  this.metroButtonNavigate.SetName(n"buttonNavigate");
  this.metroButtonNavigate.SetText("Navigate");
  this.metroButtonNavigate.RegisterToCallback(n"OnClick", this, n"OnNavigateButtonClick");
  this.metroButtonNavigate.Reparent(buttonsContainer);

  this.metroButtonCancel = PocketMetroNavButton.Create();
  this.metroButtonCancel.SetName(n"buttonCancel");
  this.metroButtonCancel.SetText("Cancel");
  this.metroButtonCancel.SetVisible(false);
  this.metroButtonCancel.RegisterToCallback(n"OnClick", this, n"OnCancelButtonClick");
  this.metroButtonCancel.Reparent(buttonsContainer);

  this.metroButtonStop = PocketMetroNavButton.Create();
  this.metroButtonStop.SetText("Stop");
  this.metroButtonStop.SetName(n"buttonStop");
  this.metroButtonStop.SetVisible(false);
  this.metroButtonStop.RegisterToCallback(n"OnClick", this, n"OnStopButtonClick");
  this.metroButtonStop.Reparent(buttonsContainer);
}


// Handle button clicks
@addMethod(WorldMapMenuGameController)
protected cb func OnNavigateButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    this.PlaySound(n"Button", n"OnPress");
    this.metroButtonNavigate.SetVisible(false);
    this.metroButtonCancel.SetVisible(true);
    this.routeSelectionEnabled = true;
    this.RefreshFiltersVisibility();
    this.SwitchToCustomFiltersForStations();
    GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(PocketMetroRouteSelectionEnabledEvent.Create());
    GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(PocketMetroPlayerMarkerVisibilityEvent.Create(false));
  }
}

@addMethod(WorldMapMenuGameController)
protected cb func OnCancelButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    this.PlaySound(n"Button", n"OnPress");
    this.metroButtonCancel.SetVisible(false);
    this.metroButtonNavigate.SetVisible(true);
    this.routeSelectionEnabled = false;
    this.RefreshFiltersVisibility();
    this.RestorePreviousFiltersState();
    GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(PocketMetroRouteSelectionDisabledEvent.Create());
    GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(PocketMetroPlayerMarkerVisibilityEvent.Create(true));
  }
}

@addMethod(WorldMapMenuGameController)
protected cb func OnStopButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    MetroLog("Stop");
    this.PlaySound(n"Button", n"OnPress");
  }
}

// Skip vanilla input events for custom buttons

@wrapMethod(WorldMapMenuGameController)
private final func HandlePressInput(e: ref<inkPointerEvent>) -> Void {
  if this.ShouldSkipEventHandle(e) {
    e.Handle();
  } else {
    wrappedMethod(e);
  };
}

@wrapMethod(WorldMapMenuGameController)
private final func HandleReleaseInput(e: ref<inkPointerEvent>) -> Void {
  if this.ShouldSkipEventHandle(e) {
    e.Handle();
  } else {
    wrappedMethod(e);
  };
}

// Block filters toggle when route selection is active
@wrapMethod(WorldMapMenuGameController)
private final func CycleQuickFilterPrev() -> Void {
  if !this.routeSelectionEnabled {
    wrappedMethod();
  }
}

@wrapMethod(WorldMapMenuGameController)
private final func CycleQuickFilterNext() -> Void {
  if !this.routeSelectionEnabled {
    wrappedMethod();
  }
}

@wrapMethod(WorldMapMenuGameController)
private final func CycleWorldMapFilter(cycleNext: Bool) -> Void {
  if !this.routeSelectionEnabled {
    wrappedMethod(cycleNext);
  }
}

// Show/hide filters panel
@addMethod(WorldMapMenuGameController)
private final func RefreshFiltersVisibility() -> Void {
  if this.routeSelectionEnabled {
    inkWidgetRef.SetVisible(this.m_filterSelector, false);
    inkWidgetRef.SetVisible(this.m_customFilters, false);
  } else {
    inkWidgetRef.SetVisible(this.m_filterSelector, true);
    inkWidgetRef.SetVisible(this.m_customFilters, Equals(this.GetQuickFilter(), gamedataWorldMapFilter.CustomFilter));
  };
}

// Prevent custom filter anim on route selection mode
@wrapMethod(WorldMapMenuGameController)
private final func PlayCustomFiltersAnimations() -> Void {
  if !this.routeSelectionEnabled {
    wrappedMethod();
  };
}

@wrapMethod(WorldMapMenuGameController)
protected cb func OnQuickFilterChanged(filterGroup: wref<MappinUIFilterGroup_Record>) -> Bool {
  wrappedMethod(filterGroup);
  if this.routeSelectionEnabled {
    inkWidgetRef.SetVisible(this.m_filterSelector, false);
    inkWidgetRef.SetVisible(this.m_customFilters, false);
  };
}

// Force custom filters tab with fast travel and quest selections
@addMethod(WorldMapMenuGameController)
private final func SwitchToCustomFiltersForStations() -> Void {
  let filterGroup: wref<MappinUIFilterGroup_Record> = TweakDBInterface.GetMappinUIFilterGroupRecord(t"WorldMap.CustomFilterGroup");
  this.m_currentQuickFilterIndex = 3;
  this.m_currentCustomFilterIndex = 4;
  this.SetQuickFilterIndicator(this.m_currentQuickFilterIndex);
  this.SetQuickFilterFromRecord(filterGroup);
  ArrayClear(this.previousCustomFilters);

  let count: Int32 = ArraySize(this.m_customFiltersList);
  let enable: Bool;
  let i: Int32 = 0;
  while i < count {
    if this.m_customFiltersList[i].IsFilterEnabled() {
      ArrayPush(this.previousCustomFilters, i);
    };

    enable = Equals(this.m_customFiltersList[i].GetFilterType(), gamedataWorldMapFilter.FastTravel);
    this.m_customFiltersList[i].EnableFilter(enable);
    if enable {
      this.SetCustomFilter(this.m_customFiltersList[i].GetFilterType());
    } else {
      this.ClearCustomFilter(this.m_customFiltersList[i].GetFilterType());
    };
    i += 1;
  };
}

// Force custom filters tab with fast travel and quest selections
@addMethod(WorldMapMenuGameController)
private final func RestorePreviousFiltersState() -> Void {
  let count: Int32 = ArraySize(this.m_customFiltersList);
  let enable: Bool;
  let i: Int32 = 0;
  while i < count {
    enable = ArrayContains(this.previousCustomFilters, i);
    this.m_customFiltersList[i].EnableFilter(enable);
    if enable {
      this.SetCustomFilter(this.m_customFiltersList[i].GetFilterType());
    } else {
      this.ClearCustomFilter(this.m_customFiltersList[i].GetFilterType());
    };
    i += 1;
  };
}

// Check if event reated to any custom button
@addMethod(WorldMapMenuGameController)
private final func ShouldSkipEventHandle(e: ref<inkPointerEvent>) -> Bool {
  let targetName: CName = e.GetTarget().GetName();
  let customButtons: array<CName> = [ n"buttonNavigate", n"buttonCancel", n"buttonStop" ];
  return ArrayContains(customButtons, targetName);
}
