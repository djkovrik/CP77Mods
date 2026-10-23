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
		this.m_siteData.iconAtlasPath = r"base\\gameplay\\gui\\virtual_atelier.inkatlas";
		this.m_siteData.iconTexturePart = n"site";
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
