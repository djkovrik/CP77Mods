import VendorPreview.utils.*

@addField(ComputerMainLayoutWidgetController)
public let m_isInDangerZone: Bool;

@replaceMethod(ComputerInkGameController)
protected cb func OnMainLayoutSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
  let danger: Bool = CurrentPlayerZoneManager.GetInstance().IsInDangerZone();
  let controller: ref<ComputerMainLayoutWidgetController>;
  this.m_mainLayout = widget;
  if IsDefined(this.m_mainLayout) {
    this.m_mainLayout.SetAnchor(inkEAnchor.Fill);
    controller = this.GetMainLayoutController();
    controller.m_isInDangerZone = danger;
    if IsDefined(controller) {
      controller.Initialize(this);
    };
    this.SetDevicesMenu(this, this.GetMainLayoutController().GetDevicesMenuContainer());
    this.RegisterCloseWindowButtonCallback();
  };
}


@wrapMethod(ComputerMainLayoutWidgetController)
public func InitializeMenuButtons(gameController: ref<ComputerInkGameController>, widgetsData: array<SComputerMenuButtonWidgetPackage>) -> Void {
  wrappedMethod(gameController, widgetsData);

  // Do nothing if zone is danger
  if this.m_isInDangerZone {
    return ;
  };

  let i = 0;
  // Add another tab for "Atelier"
  while i < ArraySize(widgetsData) {
    let widgetData = widgetsData[i];
    let widgetName = widgetData.widgetName;

    if Equals("internet", widgetName) {
      i = ArraySize(widgetsData);

      widgetData.displayName = VirtualAtelierText.Name();
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