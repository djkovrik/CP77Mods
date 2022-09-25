module ImprovedMinimapUtil

import ImprovedMinimapMain.ZoomConfig

public class ZoomCalc {

  public static func GetForSpeed(speed: Float, config: ref<ZoomConfig>) -> Float {
    if !config.isDynamicZoomEnabled {
      return config.minZoom;
    };
    if speed <= config.minSpeed { 
      return config.minZoom; 
    };
    if speed >= config.maxSpeed { 
      return config.maxZoom; 
    };

    // Calculate zoom increase step based on min/max values
    let speedRange: Float = config.maxSpeed -config.minSpeed;
    let zoomRange: Float = config.maxZoom - config.minZoom;
    let step: Float = zoomRange / speedRange;
    // Shift speed range for cases when MinSpeed is above zero
    let baseSpeed: Float = speed - config.minSpeed ;
    let zoomToAdd: Float = baseSpeed * step;
    let calculated: Float = config.minZoom + zoomToAdd;
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

public static func IMZAction() -> CName = n"imzPeek"

// -- ArchiveXL checker
@addField(SingleplayerMenuGameController)
public let archiveXlChecked: Bool;

@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let warning: ref<inkText>;
  let str: String = GetLocalizedTextByKey(n"Mod-IMZ-Combat");
  if Equals(str, "Mod-IMZ-Combat") || Equals(str, "") {
    if !this.archiveXlChecked {
      this.archiveXlChecked = true;
      warning = new inkText();
      warning.SetName(n"CustomWarning");
      warning.SetText("Archive XL not detected! Make sure that it was installed correctly.");
      warning.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
      warning.SetFontSize(64);
      warning.SetHAlign(inkEHorizontalAlign.Fill);
      warning.SetVAlign(inkEVerticalAlign.Bottom);
      warning.SetAnchor(inkEAnchor.BottomFillHorizontaly);
      warning.SetAnchorPoint(0.5, 1.0);
      warning.SetLetterCase(textLetterCase.OriginalCase);
      warning.SetMargin(new inkMargin(20.0, 0.0, 0.0, 10.0));
      warning.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
      warning.BindProperty(n"tintColor", n"MainColors.Red");
      warning.Reparent(this.GetRootCompoundWidget());
    };
  };
}
