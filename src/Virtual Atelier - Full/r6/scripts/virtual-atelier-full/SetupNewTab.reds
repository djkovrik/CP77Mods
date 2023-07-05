import VendorPreview.Config.VirtualAtelierConfig
import VirtualAtelier.Helpers.CurrentPlayerZoneHelper
import VirtualAtelier.Core.AtelierTexts
import VirtualAtelier.Logs.AtelierLog

@wrapMethod(BrowserController)
private final func TryGetWebsiteData(address: String) -> wref<JournalInternetPage> {
  if Equals("Atelier", address) {
    return wrappedMethod("NETdir://ncity.pub");
  } else {
    return wrappedMethod(address);
  };
}

@wrapMethod(BrowserController)
protected cb func OnPageSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
  wrappedMethod(widget, userData);

  let currentController: ref<WebPage> = this.m_currentPage.GetController() as WebPage;
  if Equals(this.m_defaultDevicePage, "Atelier") {
    inkTextRef.SetText(this.m_addressText, "NETdir://atelier.pub");
    currentController.PopulateAtelierView();
  };
}


@wrapMethod(ComputerInkGameController)
private final func ShowMenuByName(elementName: String) -> Void {
  if Equals(elementName, "Atelier") {
    this.GetMainLayoutController().ShowInternet("Atelier");
    this.RequestMainMenuButtonWidgetsUpdate();
  } else {
    wrappedMethod(elementName);
  };
}

@wrapMethod(ComputerControllerPS)
public final func GetMenuButtonWidgets() -> array<SComputerMenuButtonWidgetPackage> {
  let packages: array<SComputerMenuButtonWidgetPackage> = wrappedMethod();
  let config: ref<VirtualAtelierConfig> = VirtualAtelierConfig.Get();
  let package: SComputerMenuButtonWidgetPackage;
  let player: ref<PlayerPuppet> = this.GetLocalPlayerControlledGameObject() as PlayerPuppet;
  let isInSafeZone: Bool = CurrentPlayerZoneHelper.IsInSafeZone(player, config);

  if isInSafeZone {
    if this.IsMenuEnabled(EComputerMenuType.INTERNET) && ArraySize(packages) > 0 {
      package.widgetName = "Atelier";
      package.displayName = AtelierTexts.TabName();
      package.ownerID = this.GetID();
      package.iconID = n"iconAtelier";
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


// kudos to NexusGuy999 for tab widget hack ^^
@wrapMethod(ComputerMenuButtonController)
public func Initialize(gameController: ref<ComputerInkGameController>, widgetData: SComputerMenuButtonWidgetPackage) -> Void {
  wrappedMethod(gameController, widgetData);

  if Equals(widgetData.widgetName, "Atelier") {
    inkImageRef.SetTexturePart(this.m_iconWidget, n"logo_wdb_large");
    inkImageRef.SetAtlasResource(this.m_iconWidget, r"base\\gameplay\\gui\\fullscreen\\wardrobe\\atlas_wardrobe.inkatlas");
  };
}

@addMethod(WebPage)
private func PopulateAtelierView() {
  let root: ref<inkCompoundWidget> = this.GetWidget(n"page/linkPanel/panel") as inkCompoundWidget;
  if (!IsDefined(root)) {
    root = this.GetWidget(n"Page/linkPanel/panel") as inkCompoundWidget;
  };
  root.RemoveAllChildren();
  this.SpawnFromExternal(root, r"base\\gameplay\\gui\\virtual_atelier_stores.inkwidget", n"AtelierStores:VirtualAtelier.UI.AtelierStoresListController");
}
