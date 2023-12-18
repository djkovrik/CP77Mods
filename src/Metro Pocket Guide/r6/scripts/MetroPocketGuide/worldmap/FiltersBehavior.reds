
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

// Hide fiters panel on forced tab open
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
