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
    this.RegisterHotkeyListeners();

    MetroLog(s"TrackedRouteListController created");
  }

  protected cb func OnUninitialize() -> Bool {
    MetroLog(s"TrackedRouteListController uninit");
    this.UnregisterHotkeyListeners();
    this.HideAllNavigatorInputHints();
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let isMpgHotkey: Bool = Equals(ListenerAction.GetName(action), n"mpg_toggle_widget");
    let isReleased: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED);
    if isMpgHotkey && isReleased && this.HasActiveRoute() {
      this.ToggleVisibility();
    };
  }

  protected cb func OnShowPocketGuideWidgetEvent(evt: ref<ShowPocketGuideWidgetEvent>) -> Bool {
    if this.HasActiveRoute() {
      this.SetVisible(true);
      MetroLog("Widget displayed");
    };
  }

  protected cb func OnHidePocketGuideWidgetEvent(evt: ref<HidePocketGuideWidgetEvent>) -> Bool {
    this.SetVisible(false);
    MetroLog("Widget hidden");
  }

  protected cb func OnShowPocketGuideInputHintsEvent(evt: ref<ShowPocketGuideInputHintsEvent>) -> Bool {
    if this.HasActiveRoute() {
      this.ShowNavigatorHintVisible();
      MetroLog("Input hint visible for navigator show");
    };
  }

  protected cb func OnHidePocketGuideInputHintsEvent(evt: ref<HidePocketGuideInputHintsEvent>) -> Bool {
    if this.HasActiveRoute() {
      this.HideNavigatorHintVisible();
      MetroLog("Input hint visible for navigator hide");
    };
  }

  private final func RegisterHotkeyListeners() -> Void {
    this.player.RegisterInputListener(this, n"mpg_toggle_widget");
  }

  private final func UnregisterHotkeyListeners() -> Void {
    this.player.UnregisterInputListener(this, n"mpg_toggle_widget");
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
    this.GetRootCompoundWidget().SetOpacity(0.0);
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

  private final func HasActiveRoute() -> Bool {
    return ArraySize(this.route) > 0;
  }

  private final func SetVisible(visible: Bool) -> Void {
    let targetWidget: ref<inkWidget> = this.GetRootCompoundWidget();
    let duration: Float = 0.3;
    let targetOpacity: Float;
    if visible {
      targetOpacity = 1.0;
    } else {
      targetOpacity = 0.0;
    };
    this.AnimateOpacity(targetWidget, targetOpacity, duration);
  }

  private final func IsVisible() -> Bool {
    let targetWidget: ref<inkWidget> = this.GetRootCompoundWidget();
    return Equals(targetWidget.GetOpacity(), 1.0);
  }

  private final func ToggleVisibility() -> Void {
    let isVisible: Bool = this.IsVisible();
    this.SetVisible(!isVisible);
    if isVisible {
      this.ShowNavigatorHintVisible();
    } else {
      this.HideNavigatorHintVisible();
    };
  }

  private final func ShowNavigatorHintVisible() -> Void {
    MetroLog("ShowNavigatorHintVisible");
    let data: InputHintData;
    data.action = n"mpg_toggle_widget";
    data.source = n"MetroPocketGuide";
    data.localizedLabel = GetLocalizedTextByKey(n"PMG-Hint-Show");
    data.sortingPriority = 10;
    SendInputHintData(GetGameInstance(), true, data);
  }

  private final func HideNavigatorHintVisible() -> Void {
    MetroLog("HideNavigatorHintVisible");
    let data: InputHintData;
    data.action = n"mpg_toggle_widget";
    data.source = n"MetroPocketGuide";
    data.localizedLabel = GetLocalizedTextByKey(n"PMG-Hint-Hide");
    data.sortingPriority = 10;
    SendInputHintData(GetGameInstance(), true, data);
  }

  private final func HideAllNavigatorInputHints() -> Void {
    MetroLog("HideAllNavigatorInputHints");
    let data: InputHintData;
    data.action = n"mpg_toggle_widget";
    data.source = n"MetroPocketGuide";
    data.localizedLabel = GetLocalizedTextByKey(n"PMG-Hint-Show");
    data.sortingPriority = 10;
    SendInputHintData(GetGameInstance(), false, data);

    data.action = n"mpg_toggle_widget";
    data.source = n"MetroPocketGuide";
    data.localizedLabel = GetLocalizedTextByKey(n"PMG-Hint-Hide");
    data.sortingPriority = 10;
    SendInputHintData(GetGameInstance(), false, data);
  }

  private final func AnimateOpacity(targetWidget: ref<inkWidget>, endOpacity: Float, duration: Float) -> ref<inkAnimProxy> {
    let proxy: ref<inkAnimProxy>;
    let animDef: ref<inkAnimDef> = new inkAnimDef();
    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetEndTransparency(endOpacity);
    transparencyInterpolator.SetDuration(duration);
    animDef.AddInterpolator(transparencyInterpolator);
    proxy = targetWidget.PlayAnimation(animDef);
    return proxy;
  }
}
