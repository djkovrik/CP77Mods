import VendorPreview.Config.VirtualAtelierConfig
import VendorPreview.Utils.AtelierLog


// Temp flag to show atelier tab content
// TODO Need a better way to inject, research why LoadWebPage does not work with custom internet
@addField(BrowserController)
private let showAtelier: Bool;

@addMethod(BrowserController)
protected cb func OnShowAtelierEvent(evt: ref<ShowAtelierEvent>) -> Bool {
  this.showAtelier = evt.show;
}

public class ShowAtelierEvent extends Event {
  let show: Bool;

  public static func Create(show: Bool) -> ref<ShowAtelierEvent> {
    let self: ref<ShowAtelierEvent> = new ShowAtelierEvent();
    self.show = show;
    return self;
  }
}

@wrapMethod(ComputerInkGameController)
private final func ShowMenuByName(elementName: String) -> Void {
  if Equals(elementName, "atelier") {
    this.QueueEvent(ShowAtelierEvent.Create(true));
    let internetData: SInternetData = this.GetOwner().GetDevicePS().GetInternetData();
    this.GetMainLayoutController().ShowInternet(internetData.startingPage);
    this.RequestMainMenuButtonWidgetsUpdate();
    if NotEquals(elementName, "mainMenu") {
      this.GetMainLayoutController().MarkManuButtonAsSelected(elementName);
    };

    return ;
  };

  this.QueueEvent(ShowAtelierEvent.Create(false));
  wrappedMethod(elementName);
}

@wrapMethod(ComputerInkGameController)
private final func HideMenuByName(elementName: String) -> Void {
  if Equals(elementName, "atelier") {
    this.GetMainLayoutController().HideInternet();
    return; 
  };

  wrappedMethod(elementName);
}

@wrapMethod(ComputerControllerPS)
public final func GetMenuButtonWidgets() -> array<SComputerMenuButtonWidgetPackage> {
  if !this.m_computerSetup.m_mailsMenu {
    return wrappedMethod();
  };

  let packages: array<SComputerMenuButtonWidgetPackage> = wrappedMethod();
  let package: SComputerMenuButtonWidgetPackage;
  let isInSafeZone: Bool = CurrentPlayerZoneManager.IsInSafeZone(this.GetLocalPlayerControlledGameObject() as PlayerPuppet) || VirtualAtelierConfig.DisableDangerZoneChecker();

  if isInSafeZone {
    if this.IsMenuEnabled(EComputerMenuType.INTERNET) && ArraySize(packages) > 0 {
      package.widgetName = "atelier";
      package.displayName = VirtualAtelierText.Name();
      package.ownerID = this.GetID();
      package.iconID = n"iconInternet";
      package.widgetTweakDBID = this.GetMenuButtonWidgetTweakDBID();
      package.isValid = true;
      SWidgetPackageBase.ResolveWidgetTweakDBData(package.widgetTweakDBID, package.libraryID, package.libraryPath);
      ArrayPush(packages, package);
    };
  } else {
    AtelierLog("PC is in dangerous or restricted zone, Atelier tab was hidden");
  };

  return packages;
}

@wrapMethod(ComputerMenuButtonController)
public func Initialize(gameController: ref<ComputerInkGameController>, widgetData: SComputerMenuButtonWidgetPackage) -> Void {
  wrappedMethod(gameController, widgetData);

  if Equals(widgetData.widgetName, "atelier") {
    inkImageRef.SetTexturePart(this.m_iconWidget, n"logo_wdb_large");
    inkImageRef.SetAtlasResource(this.m_iconWidget, r"base\\gameplay\\gui\\fullscreen\\wardrobe\\atlas_wardrobe.inkatlas");
  };
}
