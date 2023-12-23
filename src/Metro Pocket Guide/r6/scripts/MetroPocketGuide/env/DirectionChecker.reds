module MetroPocketGuide.Graph
import MetroPocketGuide.Navigator.* 

public class MetroDirectionChecker extends ScriptableEnv {
  let lineA: array<Int32>;
  let lineB: array<Int32>;
  let lineC: array<Int32>;
  let lineD: array<Int32>;
  let lineE: array<Int32>;

  private cb func OnLoad() {
    this.PopulateLines();
  }

  public static final func GetRecommendedHighlight(route: array<ref<RoutePoint>>, currentIndex: Int32) -> String {
    let env: ref<MetroDirectionChecker> = ScriptableEnv.Get(n"MetroPocketGuide.Graph.MetroDirectionChecker") as MetroDirectionChecker;
    return env.CalculateNextHint(route, currentIndex);
  }

  public final func PopulateLines() -> Void {
    this.lineA = [ 1, 2, 3, 7, 9, 10, 14, 8, 15 ];
    this.lineB = [ 19, 18, 12, 7, 16, 5, 17, 15 ];
    this.lineC = [ 10, 14, 8, 19 ];
    this.lineD = [ 6, 5, 4, 9, 10, 14, 13, 11, 12, 18 ];
    this.lineE = [ 1, 2, 16, 7, 11, 13, 14, 6, 5, 4, 17 ];
  }

  public final func CalculateNextHint(route: array<ref<RoutePoint>>, currentIndex: Int32) -> String {
    return "";
  }

  private final func IndexOf(src: array<Int32>, element: Int32) -> Int32 {
    let count:Int32 = ArraySize(src);
    let i: Int32 = 0;
    while i < count {
      if Equals(src[i], element) {
        return i;
      };
      i += 1;
    };
    return -1;
  }
}
