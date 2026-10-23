module CarDealer.Site

@if(ModuleExists("BrowserExtension.System"))
import BrowserExtension.DataStructures.*
@if(ModuleExists("BrowserExtension.System"))
import BrowserExtension.Classes.*
@if(ModuleExists("BrowserExtension.System"))
import BrowserExtension.System.*

@if(ModuleExists("BrowserExtension.System"))
public class CarDealerSiteListener extends BrowserEventsListener {

  public func Init(logic: ref<BrowserGameController>) {
		super.Init(logic);

		this.m_siteData.address = s"NETdir://cyber.car";
		this.m_siteData.shortName = s"Car Dealer";
		this.m_siteData.iconAtlasPath = r"base\\gameplay\\gui\\car-dealer-logo.inkatlas";
		this.m_siteData.iconTexturePart = n"dealer";
  }

  public func GetWebPage(address: String) -> ref<inkCompoundWidget> {
    let root: ref<inkCompoundWidget> = this.m_deviceLogicController.GetRootCompoundWidget();
    return this.m_deviceLogicController.SpawnFromExternal(
      root, 
      r"base\\gameplay\\gui\\dealer.inkwidget", 
      n"CarDealer:CarDealer.Content.CarDealerContentController"
    ) as inkCompoundWidget;
  }
}

@if(!ModuleExists("BrowserExtension.System"))
public class CarDealerSiteListener {
  public func Init(logic: ref<BrowserGameController>) {}
  public func Uninit() {}
  public func GetWebPage(address: String) -> ref<inkCompoundWidget> { return null; }
}

@addField(BrowserGameController)
private let carDealerSiteListener: ref<CarDealerSiteListener>;

@wrapMethod(BrowserGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.carDealerSiteListener = new CarDealerSiteListener();
	this.carDealerSiteListener.Init(this);
}

@wrapMethod(BrowserGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();

	this.carDealerSiteListener.Uninit();
  this.carDealerSiteListener = null;
}
