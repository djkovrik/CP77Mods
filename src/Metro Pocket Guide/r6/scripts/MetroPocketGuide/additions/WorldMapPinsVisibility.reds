// Control pins visibility
@addField(BaseWorldMapMappinController)
private let routeSelectionEnabled: Bool = false;

// React to route selection enabled
@addMethod(BaseWorldMapMappinController)
protected cb func OnPocketMetroRouteSelectionEnabledEvent(evt: ref<PocketMetroRouteSelectionEnabledEvent>) -> Bool {
  this.routeSelectionEnabled = true;
  this.UpdateVisibilityForRouteSelection();
}

@addMethod(BaseWorldMapMappinController)
protected cb func OnPocketMetroRouteSelectionEnabledEvent(evt: ref<PocketMetroRouteSelectionEnabledEvent>) -> Bool {
  this.routeSelectionEnabled = true;
  this.UpdateVisibilityForRouteSelection();
}

@addMethod(WorldMapPlayerMappinController)
protected cb func OnPocketMetroPlayerMarkerVisibilityEvent(evt: ref<PocketMetroPlayerMarkerVisibilityEvent>) -> Bool {
  this.GetRootWidget().SetVisible(evt.show);
}


// Switch visibility
@addMethod(BaseWorldMapMappinController)
private final func UpdateVisibilityForRouteSelection() -> Void {
  let variant: gamedataMappinVariant = this.m_mappin.GetVariant();
  let shouldShow: Bool;
  if Equals(variant, gamedataMappinVariant.Zzz17_NCARTVariant) || Equals(variant, gamedataMappinVariant.FastTravelVariant) {
    if this.routeSelectionEnabled {
      shouldShow = Equals(variant, gamedataMappinVariant.Zzz17_NCARTVariant);
      if shouldShow {
        this.GetRootWidget().SetVisible(true);
      } else {
        this.GetRootWidget().SetVisible(false);
      };
    } else {
      this.GetRootWidget().SetVisible(true);
    };
  };
}
