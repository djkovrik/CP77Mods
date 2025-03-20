import VendorPreview.Config.VirtualAtelierConfig
import VirtualAtelier.Helpers.CurrentPlayerZoneHelper
import VirtualAtelier.Core.AtelierTexts
import VirtualAtelier.Logs.AtelierLog

@if(!ModuleExists("VirtualAtelier.Site"))
@addField(BrowserController)
private let showAtelier: Bool;

@if(!ModuleExists("VirtualAtelier.Site"))
@addField(BrowserController)
private let atelierWidget: wref<inkWidget>;

@if(!ModuleExists("VirtualAtelier.Site"))
@addMethod(BrowserController)
protected cb func OnShowAtelierEvent(evt: ref<ShowAtelierEvent>) -> Bool {
  this.showAtelier = evt.show;
}

@if(!ModuleExists("VirtualAtelier.Site"))
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

@if(!ModuleExists("VirtualAtelier.Site"))
@wrapMethod(ComputerInkGameController)
private final func HideMenuByName(elementName: String) -> Void {
  if Equals(elementName, "atelier") {
    this.GetMainLayoutController().HideInternet();
    return; 
  };

  wrappedMethod(elementName);
}


// Add Atelier tab to PC layout
@if(!ModuleExists("VirtualAtelier.Site"))
@wrapMethod(ComputerControllerPS)
public final func GetMenuButtonWidgets() -> array<SComputerMenuButtonWidgetPackage> {
  if !this.m_computerSetup.m_mailsMenu {
    return wrappedMethod();
  };

  let packages: array<SComputerMenuButtonWidgetPackage> = wrappedMethod();
  let config: ref<VirtualAtelierConfig> = VirtualAtelierConfig.Get();
  let package: SComputerMenuButtonWidgetPackage;
  let player: ref<PlayerPuppet> = this.GetLocalPlayerControlledGameObject() as PlayerPuppet;
  let isInSafeZone: Bool = CurrentPlayerZoneHelper.IsInSafeZone(player, config);
  if isInSafeZone {
    if this.IsMenuEnabled(EComputerMenuType.INTERNET) && ArraySize(packages) > 0 {
      package.widgetName = "atelier";
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


// Switch Atelier tab icon
// ^^ kudos to NexusGuy999 for tab widget hack ^^
@if(!ModuleExists("VirtualAtelier.Site"))
@wrapMethod(ComputerMenuButtonController)
public func Initialize(gameController: ref<ComputerInkGameController>, widgetData: SComputerMenuButtonWidgetPackage) -> Void {
  wrappedMethod(gameController, widgetData);

  if Equals(widgetData.widgetName, "atelier") {
    inkImageRef.SetTexturePart(this.m_iconWidget, n"tab");
    inkImageRef.SetAtlasResource(this.m_iconWidget, r"base\\gameplay\\gui\\virtual_atelier.inkatlas");
  };
}


// Show Atelier if tab was activated
@if(!ModuleExists("VirtualAtelier.Site"))
@wrapMethod(BrowserController)
protected cb func OnPageSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
  wrappedMethod(widget, userData);

  let root: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_pageContentRoot) as inkCompoundWidget;
  root.SetInteractive(false);
  if this.showAtelier {
    inkTextRef.SetText(this.m_addressText, "NETdir://atelier.pub");
    root.RemoveAllChildren();
    this.PopulateAtelierView(root);
  } else {
    root.RemoveChild(this.atelierWidget);
  };
}


// Spawn Atelier stores widget
@if(!ModuleExists("VirtualAtelier.Site"))
@addMethod(BrowserController)
private func PopulateAtelierView(root: ref<inkCompoundWidget>) {
  this.atelierWidget = this.SpawnFromExternal(
    root, 
    r"base\\gameplay\\gui\\virtual_atelier_stores.inkwidget",
    n"AtelierStores:VirtualAtelier.UI.AtelierStoresListController"
  );
}

public class ShowAtelierEvent extends Event {
  let show: Bool;

  public static func Create(show: Bool) -> ref<ShowAtelierEvent> {
    let self: ref<ShowAtelierEvent> = new ShowAtelierEvent();
    self.show = show;
    return self;
  }
}
