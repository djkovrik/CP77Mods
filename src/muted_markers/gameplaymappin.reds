@addField(GameplayMappinController)
public let m_isScannerActive: Bool;

@addMethod(GameplayMappinController)
protected cb func OnScannerStateChangedEvent(evt: ref<ScannerStateChangedEvent>) -> Bool {
  if NotEquals(this.m_isScannerActive, evt.isEnabled) {
    this.m_isScannerActive = evt.isEnabled;
    this.UpdateVisibility();
  }
}

@replaceMethod(GameplayMappinController)
private func UpdateVisibility() -> Void {
  let data: ref<GameplayRoleMappinData> = this.GetVisualData();
  let visibility: MarkerVisibility = GetVisibilityTypeFor(data);
  if IsDefined(this.m_mappin) {
    switch(visibility) {
      case MarkerVisibility.ThroughWalls:
        this.SetRootVisible(true);
        break;
      case MarkerVisibility.Default:
        this.SetRootVisible(this.m_mappin.IsVisible());
        break;
      case MarkerVisibility.Scanner:
        this.SetRootVisible(this.m_isScannerActive);
        break;
      case MarkerVisibility.Hidden:
        this.SetRootVisible(false);
        break;
    };
  };
}
