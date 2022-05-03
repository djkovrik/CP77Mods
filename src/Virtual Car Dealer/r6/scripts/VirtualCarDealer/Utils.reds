module CarDealer.Utils

public static func P(str: String) -> Void {
  LogChannel(n"DEBUG", s"Vehicles: \(str)");
}

public class DealerTexts {
  public static func NoDeals1() -> String = "Virtial Car Dealer has no offers at this moment!"
  public static func NoDeals2() -> String = "Please install any supported cars and come back again."
  public static func SponsoredBy() -> String = "Sponsored by"
  public static func Lot() -> String = "Lot"
  public static func Of() -> String = "of"
  public static func Available() -> String = "available!"
  public static func Purchased() -> String = "purchased"
  public static func NoMoni() -> String = "not enough eddies"
  public static func Previous() -> String = "Previous"
  public static func Next() -> String = "Next"
  public static func Buy() -> String = "Buy"
}
