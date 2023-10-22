import ImprovedMinimapMain.ZoomConfig

@addField(MinimapContainerController)
private let config: ref<ZoomConfig>;

@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  this.config = new ZoomConfig();
  this.ApplyZoomSettings();
  wrappedMethod();
}

@addMethod(MinimapContainerController)
private const func ApplyZoomSettings() -> Void {
  let range1: gameRange;
  range1.minValue = this.config.visionRadiusVehicleMin;
  range1.maxValue = this.config.visionRadiusVehicleMax;
  this.settings.visionRadiusVehicle = range1;

  let range2: gameRange;
  range2.minValue = this.config.visionRadiusCombatMin;
  range2.maxValue = this.config.visionRadiusCombatMax;
  this.settings.visionRadiusCombat = range2;

  let range3: gameRange;
  range3.minValue = this.config.visionRadiusQuestAreaMin;
  range3.maxValue = this.config.visionRadiusQuestAreaMax;
  this.settings.visionRadiusQuestArea = range3;

  let range4: gameRange;
  range4.minValue = this.config.visionRadiusSecurityAreaMin;
  range4.maxValue = this.config.visionRadiusSecurityAreaMax;
  this.settings.visionRadiusSecurityArea = range4;

  let range5: gameRange;
  range5.minValue = this.config.visionRadiusSecurityAreaMin;
  range5.maxValue = this.config.visionRadiusSecurityAreaMax;
  this.settings.visionRadiusSecurityArea = range5;

  let range6: gameRange;
  range6.minValue = this.config.visionRadiusInteriorMin;
  range6.maxValue = this.config.visionRadiusInteriorMax;
  this.settings.visionRadiusInterior = range6;

  let range7: gameRange;
  range7.minValue = this.config.visionRadiusExteriorMin;
  range7.maxValue = this.config.visionRadiusExteriorMax;
  this.settings.visionRadiusExterior = range7;

  let range8: gameRange;
  range8.minValue = this.config.speedBoundsSprintMin;
  range8.maxValue = this.config.speedBoundsSprintMax;
  this.settings.speedBoundsSprint = range8;

  let range9: gameRange;
  range9.minValue = this.config.speedBoundsVehicleMin;
  range9.maxValue = this.config.speedBoundsVehicleMax;
  this.settings.speedBoundsVehicle = range9;

  this.settings.smoothingStrengthOnZoomIn = this.config.smoothingStrengthOnZoomIn;
  this.settings.smoothingStrengthOnZoomOut = this.config.smoothingStrengthOnZoomOut;
  this.settings.playerMarkerTransitionSpeedOnVehicleMount = this.config.playerMarkerTransitionSpeedOnVehicleMount;
  this.settings.playerMarkerTransitionSpeedOnVehicleUnmount = this.config.playerMarkerTransitionSpeedOnVehicleUnmount;
}
