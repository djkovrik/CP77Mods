module ImprovedMinimapUtil

import ImprovedMinimapMain.ZoomConfig

public class CastedValues {
  public static func Combat() -> Float = Cast(ZoomConfig.Combat())
  public static func QuestArea() -> Float = Cast(ZoomConfig.QuestArea())
  public static func SecurityArea() -> Float = Cast(ZoomConfig.SecurityArea())
  public static func Interior() -> Float = Cast(ZoomConfig.Interior())
  public static func Exterior() -> Float = Cast(ZoomConfig.Exterior())

  public static func MinZoom() -> Float = Cast(ZoomConfig.MinZoom())
  public static func MaxZoom() -> Float = Cast(ZoomConfig.MaxZoom())
  public static func MinSpeed() -> Float = Cast(ZoomConfig.MinSpeed())
  public static func MaxSpeed() -> Float = Cast(ZoomConfig.MaxSpeed())

  public static func Peek() -> Float = Cast(ZoomConfig.Peek())
}

public class ZoomCalc {

  public static func GetForSpeed(speed: Float) -> Float {
    if !ZoomConfig.IsDynamicZoomEnabled() {
      return CastedValues.MinZoom();
    };
    if speed <= CastedValues.MinSpeed() { 
      return CastedValues.MinZoom(); 
    };
    if speed >= CastedValues.MaxSpeed() { 
      return CastedValues.MaxZoom(); 
    };

    // Calculate zoom increase step based on min/max values
    let speedRange: Float = CastedValues.MaxSpeed() - CastedValues.MinSpeed();
    let zoomRange: Float = CastedValues.MaxZoom() - CastedValues.MinZoom();
    let step: Float = zoomRange / speedRange;
    // Shift speed range for cases when MinSpeed is above zero
    let baseSpeed: Float = speed - CastedValues.MinSpeed();
    let zoomToAdd: Float = baseSpeed * step;
    let calculated: Float = CastedValues.MinZoom() + zoomToAdd;
    return calculated;
  }

  public static func RoundTo05(value: Float) -> Float {
    let doubled: Float = value * 2.0;
    let rounded: Int32 = RoundF(doubled);
    let casted: Float = Cast(rounded);
    return casted / 2.0;
  }
}

public static func IMZLog(message: String) -> Void {
  // LogChannel(n"DEBUG", "IMZ: " + message);
}
