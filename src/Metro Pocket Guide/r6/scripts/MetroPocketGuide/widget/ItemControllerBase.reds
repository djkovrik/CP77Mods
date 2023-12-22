module MetroPocketGuide.UI

public class TrackedRouteBaseItemController extends inkVirtualCompoundItemController {

  protected final func GetLineColor(line: ModNCartLine) -> CName {
    switch line {
      case ModNCartLine.A_RED: return n"MainColors.Red";
      case ModNCartLine.B_YELLOW: return n"MainColors.Yellow";
      case ModNCartLine.C_CYAN: return n"MainColors.Blue";
      case ModNCartLine.D_GREEN: return n"MainColors.Green";
      case ModNCartLine.E_ORANGE: return n"MainColors.Orange";
    };

    return n"MainColors.White";
  }

  protected final func GetLinePartName(line: ModNCartLine) -> CName {
    switch line {
      case ModNCartLine.A_RED: return n"line-a";
      case ModNCartLine.B_YELLOW: return n"line-b";
      case ModNCartLine.C_CYAN: return n"line-c";
      case ModNCartLine.D_GREEN: return n"line-d";
      case ModNCartLine.E_ORANGE: return n"line-e";
    };

    return n"line-a";
  }
}
