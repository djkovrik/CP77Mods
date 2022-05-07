module CarDealer.Utils

public static func P(str: String) -> Void {
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
  public static func NoMoni() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Eddies")
  public static func Previous() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Previous")
  public static func Next() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Next")
  public static func Buy() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-Buy")
  public static func ChangeColor() -> String = GetLocalizedTextByKey(n"Mod-Car-Dealer-ChangeColor")
}
