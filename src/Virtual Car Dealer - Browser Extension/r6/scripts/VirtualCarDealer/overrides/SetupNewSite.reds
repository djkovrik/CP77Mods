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


// Notify

@addField(SingleplayerMenuGameController)
protected let dealerExtensionPopup: ref<inkGameNotificationToken>;

@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  if this.BrowserExtensionNotInstalledDealer() {
    this.dealerExtensionPopup = GenericMessageNotification.Show(
      this, 
      GetLocalizedText("LocKey#11447"), 
      "You installed Virtual Car Dealer - Browser Extension addon but not the main Browser Extension mod itself, " +
      "so please download it here:\nhttps://www.nexusmods.com/cyberpunk2077/mods/10038",
      GenericMessageNotificationType.OK
    );

    this.dealerExtensionPopup.RegisterListener(this, n"OnDealerExtensionPopupClosed");
  };
}

@addMethod(SingleplayerMenuGameController)
protected cb func OnDealerExtensionPopupClosed(data: ref<inkGameNotificationData>) {
  this.dealerExtensionPopup = null;
}

@if(ModuleExists("BrowserExtension.System"))
@addMethod(SingleplayerMenuGameController)
public final func BrowserExtensionNotInstalledDealer() -> Bool {
  return false;
}

@if(!ModuleExists("BrowserExtension.System"))
@addMethod(SingleplayerMenuGameController)
public final func BrowserExtensionNotInstalledDealer() -> Bool {
  return true;
}
