module VirtualAtelier.Site

@if(ModuleExists("BrowserExtension.System"))
import BrowserExtension.DataStructures.*
@if(ModuleExists("BrowserExtension.System"))
import BrowserExtension.Classes.*
@if(ModuleExists("BrowserExtension.System"))
import BrowserExtension.System.*

@if(ModuleExists("BrowserExtension.System"))
public class VirtualAtelierSiteListener extends BrowserEventsListener {

  public func Init(logic: ref<BrowserGameController>) {
		super.Init(logic);

		this.m_siteData.address = s"NETdir://atelier.pub";
		this.m_siteData.shortName = s"Virtual Atelier";
		this.m_siteData.iconAtlasPath = r"base\\gameplay\\gui\\virtual_atelier_logo.inkatlas";
		this.m_siteData.iconTexturePart = n"logo";
  }

  public func GetWebPage(address: String) -> ref<inkCompoundWidget> {
    let root: ref<inkCompoundWidget> = this.m_deviceLogicController.GetRootCompoundWidget();
    return this.m_deviceLogicController.SpawnFromExternal(
      root, 
      r"base\\gameplay\\gui\\virtual_atelier_stores.inkwidget", 
      n"AtelierStores:VirtualAtelier.UI.AtelierStoresListController"
    ) as inkCompoundWidget;
  }
}

@if(!ModuleExists("BrowserExtension.System"))
public class VirtualAtelierSiteListener {
  public func Init(logic: ref<BrowserGameController>) {}
  public func Uninit() {}
  public func GetWebPage(address: String) -> ref<inkCompoundWidget> { return null; }
}

@addField(BrowserGameController)
private let virtualAtelierSiteListener: ref<VirtualAtelierSiteListener>;

@wrapMethod(BrowserGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.virtualAtelierSiteListener = new VirtualAtelierSiteListener();
	this.virtualAtelierSiteListener.Init(this);
}

@wrapMethod(BrowserGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();

	this.virtualAtelierSiteListener.Uninit();
  this.virtualAtelierSiteListener = null;
}

// Notify

@addField(SingleplayerMenuGameController)
protected let atelierExtensionPopup: ref<inkGameNotificationToken>;

@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  if this.BrowserExtensionNotInstalledAtelier() {
    this.atelierExtensionPopup = GenericMessageNotification.Show(
      this, 
      GetLocalizedText("LocKey#11447"), 
      "You installed Virtual Atelier - Browser Extension addon but not the main Browser Extension mod itself, " +
      "so please download it here:\nhttps://www.nexusmods.com/cyberpunk2077/mods/10038",
      GenericMessageNotificationType.OK
    );

    this.atelierExtensionPopup.RegisterListener(this, n"OnAtelierExtensionPopupClosed");
  };
}

@addMethod(SingleplayerMenuGameController)
protected cb func OnAtelierExtensionPopupClosed(data: ref<inkGameNotificationData>) {
  this.atelierExtensionPopup = null;
}

@if(ModuleExists("BrowserExtension.System"))
@addMethod(SingleplayerMenuGameController)
public final func BrowserExtensionNotInstalledAtelier() -> Bool {
  return false;
}

@if(!ModuleExists("BrowserExtension.System"))
@addMethod(SingleplayerMenuGameController)
public final func BrowserExtensionNotInstalledAtelier() -> Bool {
  return true;
}
