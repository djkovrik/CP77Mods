module Edgerunning.Controller

public class NewHumanityBarController extends inkGameController {

  private let barsContainer: ref<inkCompoundWidget>;

  protected cb func OnInitialize() {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.barsContainer = root.GetWidgetByPathName(n"barsContainer") as inkCompoundWidget;
    this.Log(s"OnInitialize: \(IsDefined(this.barsContainer))");

    this.SpawnFromExternal(
      this.barsContainer, 
      r"base\\gameplay\\gui\\fullscreen\\wannabe_edgerunner_bars.inkwidget", 
      n"Bar:Edgerunning.Controller.NewHumanityBarItemController"
    );
  }

  private final func Log(str: String) -> Void {
    LogChannel(n"DEBUG", s"NewHumanityBarController: \(str)");
  }
}
