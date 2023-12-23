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
    this.player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.route = PocketMetroNavigator.GetInstance(this.player.GetGame()).GetRoute();

    this.InitializeWidgets();
    this.RefreshDataSource();

    MetroLog(s"TrackedRouteListController created: \(ArraySize(this.route))");
  }

  protected cb func OnUninitialize() -> Bool {}

  protected cb func OnRefreshPocketGuideWidgetEvent(evt: ref<RefreshPocketGuideWidgetEvent>) -> Bool {
    this.route = PocketMetroNavigator.GetInstance(this.player.GetGame()).GetRoute();
    this.RefreshDataSource();
    MetroLog(s"Widget refreshed: \(ArraySize(this.route))");
  }

  protected cb func OnClearPocketGuideWidgetEvent(evt: ref<ClearPocketGuideWidgetEvent>) -> Bool {
    ArrayClear(this.route);
    this.RefreshDataSource();
    this.SetVisible(false);
    MetroLog("Widget cleared");
  }

  protected cb func OnShowPocketGuideWidgetEvent(evt: ref<ShowPocketGuideWidgetEvent>) -> Bool {
    this.SetVisible(true);
    MetroLog("Widget displayed");
  }

  protected cb func OnHidePocketGuideWidgetEvent(evt: ref<HidePocketGuideWidgetEvent>) -> Bool {
    this.SetVisible(false);
    MetroLog("Widget hidden");
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
  }

  private final func RefreshDataSource() -> Void {
    let items: array<ref<IScriptable>>;
    this.route = PocketMetroNavigator.GetInstance(this.player.GetGame()).GetRoute();

    for point in this.route {
      ArrayPush(items, point);
    };

    this.stationsListDataSource.Reset(items);
    this.stationsListDataView.UpdateView();
  }

  private final func SetVisible(visible: Bool) -> Void {
    this.GetRootCompoundWidget().SetVisible(visible);
    MetroLog(s"SetVisible \(visible)");
  }
}
