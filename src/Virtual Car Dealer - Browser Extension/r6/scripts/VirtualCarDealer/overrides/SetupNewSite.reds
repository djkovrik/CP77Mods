module CarDealer.Site
import BrowserExtension.DataStructures.*
import BrowserExtension.Classes.*
import BrowserExtension.System.*

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

@addField(BrowserGameController)
private let CarDealerSiteListener: ref<CarDealerSiteListener>;

@wrapMethod(BrowserGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.CarDealerSiteListener = new CarDealerSiteListener();
	this.CarDealerSiteListener.Init(this);
}

@wrapMethod(BrowserGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();

	this.CarDealerSiteListener.Uninit();
  this.CarDealerSiteListener = null;
}
