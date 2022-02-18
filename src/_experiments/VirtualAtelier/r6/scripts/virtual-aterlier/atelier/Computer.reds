@wrapMethod(ComputerMainLayoutWidgetController)
public func InitializeMenuButtons(gameController: ref<ComputerInkGameController>, widgetsData: array<SComputerMenuButtonWidgetPackage>) -> Void {
  wrappedMethod(gameController, widgetsData);

  let i = 0;

  // Add another tab for "Atelier"
  while i < ArraySize(widgetsData) {
    let widgetData = widgetsData[i];
    let widgetName = widgetData.widgetName;

    if Equals("internet", widgetName) {
      i = ArraySize(widgetsData);

      widgetData.displayName = "Atelier";
      widgetData.widgetName = "Atelier";

      // TODO: Find a way to show a badge for newly installed stores (+ add a border around new stores?)
      let widget = this.CreateMenuButtonWidget(gameController, inkWidgetRef.Get(this.m_menuButtonList), widgetData);
      this.AddMenuButtonWidget(widget, widgetData, gameController);
      this.InitializeMenuButtonWidget(gameController, widget, widgetData);
    } else {
      i += 1;
    }
  };
}

@wrapMethod(ComputerInkGameController)
private final func ShowMenuByName(elementName: String) -> Void {
  if Equals(elementName, "Atelier") {
    this.ShowCustomInternet();
  } else {
    wrappedMethod(elementName);
  }
}

// TODO: Change the tab icon from Internet to something new
@addMethod(ComputerInkGameController)
protected final func ShowCustomInternet() -> Void {
  let internetData: SInternetData = (this.GetOwner().GetDevicePS() as ComputerControllerPS).GetInternetData();
  this.GetMainLayoutController().ShowInternet("Atelier");
  this.RequestMainMenuButtonWidgetsUpdate();
}