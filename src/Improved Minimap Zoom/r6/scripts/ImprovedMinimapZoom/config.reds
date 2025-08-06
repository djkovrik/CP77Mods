module ImprovedMinimapMain

public class ZoomConfig {

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusVehicleMin")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "800")
  public let visionRadiusVehicleMin: Float = 200.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusVehicleMax")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "800")
  public let visionRadiusVehicleMax: Float = 650.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusCombatMin")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusCombatMin: Float = 40.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusCombatMax")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusCombatMax: Float = 60.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusQuestAreaMin")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusQuestAreaMin: Float = 40.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusQuestAreaMax")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusQuestAreaMax: Float = 60.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusSecurityAreaMin")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusSecurityAreaMin: Float = 40.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusSecurityAreaMax")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusSecurityAreaMax: Float = 60.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusInteriorMin")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusInteriorMin: Float = 40.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusInteriorMax")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusInteriorMax: Float = 60.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusExteriorMin")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusExteriorMin: Float = 100.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "visionRadiusExteriorMax")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let visionRadiusExteriorMax: Float = 110.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "speedBoundsSprintMin")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0")
  public let speedBoundsSprintMin: Float = 4.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "speedBoundsSprintMax")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0")
  public let speedBoundsSprintMax: Float = 4.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "speedBoundsVehicleMin")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "100.0")
  public let speedBoundsVehicleMin: Float = 15.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "speedBoundsVehicleMax")
  @runtimeProperty("ModSettings.step", "5.0")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "100.0")
  public let speedBoundsVehicleMax: Float = 50.0;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "smoothingStrengthOnZoomIn")
  @runtimeProperty("ModSettings.step", "0.025")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let smoothingStrengthOnZoomIn: Float = 0.025;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "smoothingStrengthOnZoomOut")
  @runtimeProperty("ModSettings.step", "0.025")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let smoothingStrengthOnZoomOut: Float = 0.15;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "playerMarkerTransitionSpeedOnVehicleMount")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0")
  public let playerMarkerTransitionSpeedOnVehicleMount: Float = 2.5;

  @runtimeProperty("ModSettings.mod", "IZoom")
  @runtimeProperty("ModSettings.category", "Minimap config")
  @runtimeProperty("ModSettings.displayName", "playerMarkerTransitionSpeedOnVehicleUnmount")
  @runtimeProperty("ModSettings.step", "0.5")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0")
  public let playerMarkerTransitionSpeedOnVehicleUnmount: Float = 5.0;
}
