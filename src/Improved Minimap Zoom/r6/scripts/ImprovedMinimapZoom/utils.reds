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


// -- AXL checker

@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  if NotEquals(GetLocalizedTextByKey(n"Mod-IMZ-Combat"), "") { return true; };
  this.ShowIMZWarningAXL();
}

@addField(SingleplayerMenuGameController)
public let imzCheckedAXL: Bool;

@addMethod(SingleplayerMenuGameController)
private func ShowIMZWarningAXL() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"warningsAXL") as inkCompoundWidget;
  if !IsDefined(container) {
    container = new inkVerticalPanel();
    container.SetName(n"warningsAXL");
    container.SetHAlign(inkEHorizontalAlign.Fill);
    container.SetVAlign(inkEVerticalAlign.Bottom);
    container.SetAnchor(inkEAnchor.BottomFillHorizontaly);
    container.SetAnchorPoint(0.5, 1.0);
    container.SetMargin(new inkMargin(20.0, 0.0, 0.0, 10.0));
    container.Reparent(root);
  };

  let imzWarning1: ref<inkText>;
  let imzWarning2: ref<inkText>;
  if !this.imzCheckedAXL {
    this.imzCheckedAXL = true;
    imzWarning1 = new inkText();
    imzWarning1.SetName(n"IMZWarning1");
    imzWarning1.SetText("Improved Minimap Zoom: resource files not detected!");
    imzWarning1.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    imzWarning1.SetFontSize(42);
    imzWarning1.SetLetterCase(textLetterCase.OriginalCase);
    imzWarning1.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    imzWarning1.BindProperty(n"tintColor", n"MainColors.Red");
    imzWarning1.Reparent(container);

    imzWarning2 = new inkText();
    imzWarning2.SetName(n"IMZWarning2");
    imzWarning2.SetText("-> Please make sure that you have ImprovedMinimapZoom.archive and .xl files inside your archive\\pc\\mod folder.");
    imzWarning2.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    imzWarning2.SetFontSize(38);
    imzWarning2.SetLetterCase(textLetterCase.OriginalCase);
    imzWarning2.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    imzWarning2.BindProperty(n"tintColor", n"MainColors.Blue");
    imzWarning2.Reparent(container);
  };
}
