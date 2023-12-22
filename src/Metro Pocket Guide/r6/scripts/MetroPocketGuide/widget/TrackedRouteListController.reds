module MetroPocketGuide.UI
import MetroPocketGuide.Navigator.PocketMetroNavigator

public class TrackedRouteListController extends inkGameController {
  private let player: wref<PlayerPuppet>;
  private let route: array<ref<RoutePoint>>;

  private let stationsList: wref<inkVirtualListController>;
  private let stationsListScrollController: wref<inkScrollController>;
  private let stationsListDataSource: ref<ScriptableDataSource>;
  private let stationsListDataView: ref<TrackedRouteDataView>;
  private let stationsListTemplateClassifier: ref<TrackedRouteItemClassifier>;
  
  protected cb func OnInitialize() {
    MetroLog("TrackedRouteListController::OnInitialize");
    
    this.player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.route = PocketMetroNavigator.Get().GetRoute();

    if ArraySize(this.route) > 0 {
      this.InitializeWidgets();
      this.RefreshDataSource();
    };
  }

  protected cb func OnUninitialize() -> Bool {
    MetroLog("TrackedRouteListController::OnUninitialize");
  }

  private final func InitializeWidgets() -> Void {
    this.stationsList = this.GetChildWidgetByPath(n"container/wrapper/scrollArea/virtualList").GetController() as inkVirtualListController;
    this.stationsListScrollController = this.GetChildWidgetByPath(n"container/wrapper").GetControllerByType(n"inkScrollController") as inkScrollController;
    this.stationsListDataSource = new ScriptableDataSource();
    this.stationsListDataView = new TrackedRouteDataView();
    this.stationsListDataView.SetSource(this.stationsListDataSource);
    this.stationsListTemplateClassifier = new TrackedRouteItemClassifier();
    this.stationsList.SetClassifier(this.stationsListTemplateClassifier);
    this.stationsList.SetSource(this.stationsListDataView);

    MetroLog(s"TrackedRouteListController::InitializeWidgets - \(IsDefined(this.stationsList)) \(IsDefined(this.stationsListScrollController))");
  }

  private final func RefreshDataSource() -> Void {
    let items: array<ref<IScriptable>>;
    for point in this.route {
      ArrayPush(items, point);
    };

    this.stationsListDataSource.Reset(items);
    this.stationsListDataView.UpdateView();
  }
}
