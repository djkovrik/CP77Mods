import CarDealer.System.PurchasableVehicleSystem


// Inspired (aka copy-pasted) by Virtual Atelier :) kudos to Pacings

// Add new button
@wrapMethod(ComputerMainLayoutWidgetController)
public func InitializeMenuButtons(gameController: ref<ComputerInkGameController>, widgetsData: array<SComputerMenuButtonWidgetPackage>) -> Void {
  wrappedMethod(gameController, widgetsData);

  // Find internet tab
  let i: Int32 = 0;
  let internetData: SComputerMenuButtonWidgetPackage;
  while i < ArraySize(widgetsData) {
    if Equals("internet", widgetsData[i].widgetName) {
      internetData = widgetsData[i];
    };
    i += 1;
  };

  let player: ref<PlayerPuppet> = gameController.GetPlayerControlledObject() as PlayerPuppet;
  let isInDangerZone: Bool = PurchasableVehicleSystem.GetInstance(player.GetGame()).IsInDangerZone(player);

  // Do not show tab for danger zone PCs
  if isInDangerZone {
    return ;
  };

  // Add Car Dealer tab
  let widget: ref<inkWidget>;
  if Equals(internetData.widgetName, "internet") {
    internetData.displayName = "Car Dealer";
    internetData.widgetName = "CarDealer";
    widget = this.CreateMenuButtonWidget(gameController, inkWidgetRef.Get(this.m_menuButtonList), internetData);
    this.AddMenuButtonWidget(widget, internetData, gameController);
    this.InitializeMenuButtonWidget(gameController, widget, internetData);
  };
}

@wrapMethod(BrowserController)
private final func TryGetWebsiteData(address: String) -> wref<JournalInternetPage> {
  if Equals("CarDealer", address) {
    return wrappedMethod("NETdir://cyber.car");
  } else {
    return wrappedMethod(address);
  }
}

// Show Car Dealer page
@wrapMethod(BrowserController)
protected cb func OnPageSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
  wrappedMethod(widget, userData);

  let currentController: ref<WebPage> = this.m_currentPage.GetController() as WebPage;
  if Equals(this.m_defaultDevicePage, "CarDealer") {
    inkTextRef.SetText(this.m_addressText, "NETdir://cyber.car");
    currentController.PopulateDealerView(this.m_gameController.GetPlayerControlledObject());
  };
}

@wrapMethod(ComputerInkGameController)
private final func ShowMenuByName(elementName: String) -> Void {
  if Equals(elementName, "CarDealer") {
    this.ShowCarDealer();
  } else {
    wrappedMethod(elementName);
  }
}

@addMethod(ComputerInkGameController)
protected final func ShowCarDealer() -> Void {
  this.GetMainLayoutController().ShowInternet("CarDealer");
  this.RequestMainMenuButtonWidgetsUpdate();
}
