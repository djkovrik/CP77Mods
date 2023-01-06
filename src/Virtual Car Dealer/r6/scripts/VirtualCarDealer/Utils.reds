module CarDealer.Utils

public static func CarDealerLog(str: String) -> Void {
  // LogChannel(n"DEBUG", s"Vehicles: \(str)");
}

public class DealerTexts {
  public static func NoDeals1() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-No-Deals1")
  public static func NoDeals2() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-No-Deals2")
  public static func SponsoredBy() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Sponsored")
  public static func Lot() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Lot")
  public static func Of() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Of")
  public static func Available() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Available")
  public static func Purchased() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Purchased")
  public static func NoCred() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Cred")
  public static func NoMoni() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Eddies")
  public static func Previous() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Previous")
  public static func Next() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Next")
  public static func Buy() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Buy")
  public static func ChangeColor() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-ChangeColor")
}

// -- AXL checker

@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  if NotEquals(GetLocalizedTextByKey(n"Mod-Car-Dealer-Lot"), "") { return true; };
  this.ShowCarDealerWarningAXL();
}

@addField(SingleplayerMenuGameController)
public let carDealerCheckedAXL: Bool;

@addMethod(SingleplayerMenuGameController)
private func ShowCarDealerWarningAXL() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"warningsAXL") as inkCompoundWidget;
  if !IsDefined(container) {
    container = new inkVerticalPanel();
    container.SetName(n"warningsAXL");
    container.SetHAlign(inkEHorizontalAlign.Fill);
    container.SetVAlign(inkEVerticalAlign.Bottom);
    container.SetAnchor(inkEAnchor.BottomFillHorizontaly);
    container.SetAnchorPoint(0.5, 1.0);
    container.SetMargin(new inkMargin(20.0, 0.0, 0.0, 10.0));
    container.Reparent(root);
  };

  let carDealerWarning1: ref<inkText>;
  let carDealerWarning2: ref<inkText>;
  if !this.carDealerCheckedAXL {
    this.carDealerCheckedAXL = true;
    carDealerWarning1 = new inkText();
    carDealerWarning1.SetName(n"CarDealerWarning1");
    carDealerWarning1.SetText("Virtual Car Dealer: resource files not detected!");
    carDealerWarning1.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    carDealerWarning1.SetFontSize(42);
    carDealerWarning1.SetLetterCase(textLetterCase.OriginalCase);
    carDealerWarning1.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    carDealerWarning1.BindProperty(n"tintColor", n"MainColors.Red");
    carDealerWarning1.Reparent(container);

    carDealerWarning2 = new inkText();
    carDealerWarning2.SetName(n"CarDealerWarning2");
    carDealerWarning2.SetText("-> Please make sure that you have VirtualCarDealer.archive and .xl files inside your archive\\pc\\mod folder.");
    carDealerWarning2.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    carDealerWarning2.SetFontSize(38);
    carDealerWarning2.SetLetterCase(textLetterCase.OriginalCase);
    carDealerWarning2.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    carDealerWarning2.BindProperty(n"tintColor", n"MainColors.Blue");
    carDealerWarning2.Reparent(container);
  };
}
