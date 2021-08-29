import MutedMarkersConfig.WorldConfig

// Hide vehicle icons
@replaceMethod(QuestMappinController)
private func UpdateVisibility() -> Void {
  let isInQuestArea: Bool = this.m_questMappin != null && this.m_questMappin.IsInsideTrigger();
  let showWhenClamped: Bool = this.isCurrentlyClamped ? !this.m_shouldHideWhenClamped : true;
  let shouldHideVehicle: Bool = WorldConfig.HideVehicles() && Equals(this.m_mappin.GetVariant(), gamedataMappinVariant.VehicleVariant);
  let shouldBeVisible: Bool = this.m_mappin.IsVisible() && showWhenClamped && !isInQuestArea && !shouldHideVehicle;
  this.SetRootVisible(shouldBeVisible);
}
