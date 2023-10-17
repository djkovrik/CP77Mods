import BrowserExtension.DataStructures.*
import BrowserExtension.Classes.*
import BrowserExtension.System.*

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
      r"base\\gameplay\\gui\\virtual_atelier_stores.inkwidget", n"AtelierStores:VirtualAtelier.UI.AtelierStoresListController"
    ) as inkCompoundWidget;
  }
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
