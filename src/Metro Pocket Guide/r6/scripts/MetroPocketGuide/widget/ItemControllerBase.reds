module MetroPocketGuide.UI

public class TrackedRouteBaseItemController extends inkVirtualCompoundItemController {

  protected final func GetLineHDRColor(line: ModNCartLine) -> HDRColor {
    switch line {
      case ModNCartLine.A_RED: return new HDRColor(1.0, 0.266250998, 0.266250014, 1.0);
      case ModNCartLine.B_YELLOW: return new HDRColor(1.0, 0.981656015, 0.266250014, 1.0);
      case ModNCartLine.C_CYAN: return new HDRColor(0.0, 0.999997973, 1.0, 1.0);
      case ModNCartLine.D_GREEN: return new HDRColor(0.0974999964, 1.0, 0.187749997, 1.0);
      case ModNCartLine.E_ORANGE: return new HDRColor(0.917500019, 0.410138994, 0.0539029986, 1.0);
    };

    return new HDRColor(1.0, 1.0, 1.0, 1.0);
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
