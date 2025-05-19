module AtelierDelivery

public abstract class AtelierDeliveryUtils {

  public final static func BuildShortLabel(baseLabel: String, maxLength: Int32) -> String {
    let currentLength: Int32 = StrLen(baseLabel);

    if currentLength <= maxLength {
      return baseLabel;
    }

    let shortened: String = UTF8StrLeft(baseLabel, maxLength);
    let suffix: String = "(...)";
    return s"\(shortened) \(suffix)";
  }

  public final static func PrettifyTimestampValue(timestamp: Float) -> String {
    let asMinutes: Float = timestamp / 60.0;
    let asHours: Float = asMinutes / 60.0;
    let asDays: Float = asHours / 24.0;

    let result: String;
    if asDays > 1.0 {
      result = s"\(Cast<Int32>(asDays))\(GetLocalizedTextByKey(n"Mod-VAD-Time-Suffix-Days"))";
    } else if asDays <= 1.0 && asHours > 1.0 {
      result = s"\(Cast<Int32>(asHours))\(GetLocalizedTextByKey(n"Mod-VAD-Time-Suffix-Hours"))";
    } else if NotEquals(timestamp, 0.0) {
      result = GetLocalizedTextByKey(n"Mod-VAD-Time-Less-Than-Hour");
    } else {
      result = GetLocalizedTextByKey(n"Mod-VAD-Shipment-Suffix-None");
    };

    return result;
  }

  public final static func GetDeliveryPointLocKey(deliveryPoint: AtelierDeliveryDropPoint) -> String {
    switch deliveryPoint {
      case AtelierDeliveryDropPoint.MegabuildingH10: return "LocKey#44450";
      case AtelierDeliveryDropPoint.KabukiMarket: return "LocKey#44430";
      case AtelierDeliveryDropPoint.MartinSt: return "LocKey#44415";
      case AtelierDeliveryDropPoint.EisenhowerSt: return "LocKey#95277";
      case AtelierDeliveryDropPoint.CharterHill: return "LocKey#21266";
      case AtelierDeliveryDropPoint.CherryBlossomMarket: return "LocKey#21233";
      case AtelierDeliveryDropPoint.NorthOakSign: return "LocKey#44579";
      case AtelierDeliveryDropPoint.SarastiAndRepublic: return "LocKey#95266";
      case AtelierDeliveryDropPoint.CorporationSt: return "LocKey#44500";
      case AtelierDeliveryDropPoint.MegabuildingH3: return "LocKey#44519";
      case AtelierDeliveryDropPoint.CongressMlk: return "LocKey#95271";
      case AtelierDeliveryDropPoint.CanneryPlaza: return "LocKey#44501";
      case AtelierDeliveryDropPoint.WollesenSt: return "LocKey#95265";
      case AtelierDeliveryDropPoint.MegabuildingH7: return "LocKey#95272";
      case AtelierDeliveryDropPoint.PacificaStadium: return "LocKey#95276";
      case AtelierDeliveryDropPoint.WestWindEstate: return "LocKey#10958";
      case AtelierDeliveryDropPoint.SunsetMotel: return "LocKey#37971";
      case AtelierDeliveryDropPoint.LongshoreStacks: return "LocKey#93789";
      default: return "";
    };
  }


  public final static func GetDeliveryBadgeLocKey(status: AtelierDeliveryStatus) -> CName {
    switch status {
      case AtelierDeliveryStatus.Created: return n"Mod-VAD-Status-Created";
      case AtelierDeliveryStatus.Shipped: return n"Mod-VAD-Status-Shipped";
      case AtelierDeliveryStatus.Arrived: return n"Mod-VAD-Status-Arrived";
      case AtelierDeliveryStatus.Delivered: return n"Mod-VAD-Status-Delivered";
      default: return n"";
    };
  }

  public final static func GetDeliveryBadgeColor(status: AtelierDeliveryStatus) -> CName {
    switch status {
      case AtelierDeliveryStatus.Created: return n"MainColors.Neutral";
      case AtelierDeliveryStatus.Shipped: return n"MainColors.DarkGold";
      case AtelierDeliveryStatus.Arrived: return n"MainColors.DarkBlue";
      case AtelierDeliveryStatus.Delivered: return n"MainColors.DarkGreen";
      default: return n"MainColors.White";
    };
  }

  public final static func GetDeliveryBadgeTextColor(status: AtelierDeliveryStatus) -> CName {
    switch status {
      case AtelierDeliveryStatus.Created: return n"MainColors.Black";
      case AtelierDeliveryStatus.Shipped: return n"MainColors.Black";
      case AtelierDeliveryStatus.Arrived: return n"MainColors.Black";
      case AtelierDeliveryStatus.Delivered: return n"MainColors.Black";
      default: return n"MainColors.Black";
    };
  }

  public final static func GetDropPointByTag(tag: CName) -> AtelierDeliveryDropPoint {
    switch tag {
      case n"MegabuildingH10": return AtelierDeliveryDropPoint.MegabuildingH10;
      case n"KabukiMarket": return AtelierDeliveryDropPoint.KabukiMarket;
      case n"MartinSt": return AtelierDeliveryDropPoint.MartinSt;
      case n"EisenhowerSt": return AtelierDeliveryDropPoint.EisenhowerSt;
      case n"CharterHill": return AtelierDeliveryDropPoint.CharterHill;
      case n"CherryBlossomMarket": return AtelierDeliveryDropPoint.CherryBlossomMarket;
      case n"NorthOakSign": return AtelierDeliveryDropPoint.NorthOakSign;
      case n"SarastiAndRepublic": return AtelierDeliveryDropPoint.SarastiAndRepublic;
      case n"CorporationSt": return AtelierDeliveryDropPoint.CorporationSt;
      case n"MegabuildingH3": return AtelierDeliveryDropPoint.MegabuildingH3;
      case n"CongressMlk": return AtelierDeliveryDropPoint.CongressMlk;
      case n"CanneryPlaza": return AtelierDeliveryDropPoint.CanneryPlaza;
      case n"WollesenSt": return AtelierDeliveryDropPoint.WollesenSt;
      case n"MegabuildingH7": return AtelierDeliveryDropPoint.MegabuildingH7;
      case n"PacificaStadium": return AtelierDeliveryDropPoint.PacificaStadium;
      case n"WestWindEstate": return AtelierDeliveryDropPoint.WestWindEstate;
      case n"SunsetMotel": return AtelierDeliveryDropPoint.SunsetMotel;
      case n"LongshoreStacks": return AtelierDeliveryDropPoint.LongshoreStacks;
    };

    return AtelierDeliveryDropPoint.None;
  }
}
