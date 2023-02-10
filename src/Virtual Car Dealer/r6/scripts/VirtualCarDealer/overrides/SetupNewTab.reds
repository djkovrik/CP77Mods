import CarDealer.System.PurchasableVehicleSystem


// Inspired (aka copy-pasted) by Virtual Atelier :)

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

@wrapMethod(ComputerControllerPS)
public final func GetMenuButtonWidgets() -> array<SComputerMenuButtonWidgetPackage> {
  let packages: array<SComputerMenuButtonWidgetPackage> = wrappedMethod();
  let package: SComputerMenuButtonWidgetPackage;

  let player: ref<PlayerPuppet> = this.GetLocalPlayerControlledGameObject() as PlayerPuppet;
  let isInDangerZone: Bool = PurchasableVehicleSystem.GetInstance(player.GetGame()).IsInDangerZone(player);

  if !isInDangerZone {
    if this.IsMenuEnabled(EComputerMenuType.INTERNET) && ArraySize(packages) > 0 {
      package.widgetName = "CarDealer";
      package.displayName = "Car Dealer";
      package.ownerID = this.GetID();
      package.iconID = n"iconInternet";
      package.widgetTweakDBID = this.GetMenuButtonWidgetTweakDBID();
      package.isValid = true;
      ArrayPush(packages, package);
    };
  } else {
    LogChannel(n"DEBUG", "PC is in danger or restricted zone, Car Dealer tab not available.");
  };

  return packages;
}
