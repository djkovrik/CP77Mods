public abstract class MetroDataHelper {

  public final static func GetStationNameById(id: Int32) -> ENcartStations {
    switch id {
      case 1: return ENcartStations.ARASAKA_WATERFRONT;
      case 2: return ENcartStations.LITTLE_CHINA_HOSPITAL;
      case 3: return ENcartStations.LITTLE_CHINA_NORTH;
      case 4: return ENcartStations.LITTLE_CHINA_SOUTH;
      case 5: return ENcartStations.JAPAN_TOWN_NORTH;
      case 6: return ENcartStations.JAPAN_TOWN_SOUTH;
      case 7: return ENcartStations.DOWNTOWN_NORTH;
      case 8: return ENcartStations.ARROYO;
      case 9: return ENcartStations.CITY_CENTER;
      case 10: return ENcartStations.ARASAKA_TOWER;
      case 11: return ENcartStations.WELLSPRINGS;
      case 12: return ENcartStations.GLEN_NORTH;
      case 13: return ENcartStations.GLEN_SOUTH;
      case 14: return ENcartStations.VISTA_DEL_REY;
      case 15: return ENcartStations.RANCHO_CORONADO;
      case 16: return ENcartStations.LITTLE_CHINA_MEGABUILDING;
      case 17: return ENcartStations.CHARTER_HILL;
      case 18: return ENcartStations.GLEN_EBUNIKE;
      case 19: return ENcartStations.PACIFICA_STADIUM;
    };
    return ENcartStations.NONE;
  }

  public final static func GetStationNameByLocKey(locKey: String) -> ENcartStations {
    switch locKey {
      case "LocKey#44731": return ENcartStations.ARASAKA_WATERFRONT;
      case "LocKey#44728": return ENcartStations.LITTLE_CHINA_HOSPITAL;
      case "LocKey#44727": return ENcartStations.LITTLE_CHINA_NORTH;
      case "LocKey#52587": return ENcartStations.LITTLE_CHINA_SOUTH;
      case "LocKey#44715": return ENcartStations.JAPAN_TOWN_NORTH;
      case "LocKey#44716": return ENcartStations.JAPAN_TOWN_SOUTH;
      case "LocKey#44700": return ENcartStations.DOWNTOWN_NORTH;
      case "LocKey#52554": return ENcartStations.ARROYO;
      case "LocKey#44695": return ENcartStations.CITY_CENTER;
      case "LocKey#52544": return ENcartStations.ARASAKA_TOWER;
      case "LocKey#44679": return ENcartStations.WELLSPRINGS;
      case "LocKey#44675": return ENcartStations.GLEN_NORTH;
      case "LocKey#44676": return ENcartStations.GLEN_SOUTH;
      case "LocKey#44683": return ENcartStations.VISTA_DEL_REY;
      case "LocKey#44707": return ENcartStations.RANCHO_CORONADO;
      case "LocKey#52585": return ENcartStations.LITTLE_CHINA_MEGABUILDING;
      case "LocKey#52574": return ENcartStations.CHARTER_HILL;
      case "LocKey#52532": return ENcartStations.GLEN_EBUNIKE;
      case "LocKey#44687": return ENcartStations.PACIFICA_STADIUM;
    };
    return ENcartStations.NONE;
  }

  public final static func GetStationLinesById(id: Int32) -> array<ModNCartLine> {
    let stationId: ENcartStations = IntEnum<ENcartStations>(id);
    switch stationId {
      case ENcartStations.ARASAKA_WATERFRONT: return [ ModNCartLine.A_RED, ModNCartLine.E_ORANGE ];
      case ENcartStations.LITTLE_CHINA_HOSPITAL: return [ ModNCartLine.A_RED, ModNCartLine.E_ORANGE ];
      case ENcartStations.LITTLE_CHINA_NORTH: return [ ModNCartLine.A_RED ];
      case ENcartStations.LITTLE_CHINA_SOUTH: return [ ModNCartLine.D_GREEN, ModNCartLine.E_ORANGE ];
      case ENcartStations.JAPAN_TOWN_NORTH: return [ ModNCartLine.B_YELLOW, ModNCartLine.D_GREEN, ModNCartLine.E_ORANGE ];
      case ENcartStations.JAPAN_TOWN_SOUTH: return [ ModNCartLine.D_GREEN, ModNCartLine.E_ORANGE ];
      case ENcartStations.DOWNTOWN_NORTH: return [ ModNCartLine.A_RED, ModNCartLine.B_YELLOW, ModNCartLine.E_ORANGE ];
      case ENcartStations.ARROYO: return [ ModNCartLine.A_RED, ModNCartLine.C_CYAN ];
      case ENcartStations.CITY_CENTER: return [ ModNCartLine.A_RED, ModNCartLine.D_GREEN ];
      case ENcartStations.ARASAKA_TOWER: return [ ModNCartLine.A_RED, ModNCartLine.C_CYAN, ModNCartLine.D_GREEN ];
      case ENcartStations.WELLSPRINGS: return [ ModNCartLine.D_GREEN, ModNCartLine.E_ORANGE ];
      case ENcartStations.GLEN_NORTH: return [ ModNCartLine.B_YELLOW, ModNCartLine.D_GREEN ];
      case ENcartStations.GLEN_SOUTH: return [ ModNCartLine.D_GREEN, ModNCartLine.E_ORANGE ];
      case ENcartStations.VISTA_DEL_REY: return [ ModNCartLine.A_RED, ModNCartLine.C_CYAN, ModNCartLine.D_GREEN, ModNCartLine.E_ORANGE ];
      case ENcartStations.RANCHO_CORONADO: return [ ModNCartLine.A_RED, ModNCartLine.B_YELLOW ];
      case ENcartStations.LITTLE_CHINA_MEGABUILDING: return [ ModNCartLine.B_YELLOW, ModNCartLine.E_ORANGE ];
      case ENcartStations.CHARTER_HILL: return [ ModNCartLine.B_YELLOW, ModNCartLine.E_ORANGE ];
      case ENcartStations.GLEN_EBUNIKE: return [ ModNCartLine.B_YELLOW, ModNCartLine.D_GREEN ];
      case ENcartStations.PACIFICA_STADIUM: return [ ModNCartLine.B_YELLOW, ModNCartLine.C_CYAN ];
    };
    return [];
  }

  public final static func GetStationIdByName(stationName: ENcartStations) -> Int32 {
    switch stationName {
      case ENcartStations.ARASAKA_WATERFRONT: return 1;
      case ENcartStations.LITTLE_CHINA_HOSPITAL: return 2;
      case ENcartStations.LITTLE_CHINA_NORTH: return 3;
      case ENcartStations.LITTLE_CHINA_SOUTH: return 4;
      case ENcartStations.JAPAN_TOWN_NORTH: return 5;
      case ENcartStations.JAPAN_TOWN_SOUTH: return 6;
      case ENcartStations.DOWNTOWN_NORTH: return 7;
      case ENcartStations.ARROYO: return 8;
      case ENcartStations.CITY_CENTER: return 9;
      case ENcartStations.ARASAKA_TOWER: return 10;
      case ENcartStations.WELLSPRINGS: return 11;
      case ENcartStations.GLEN_NORTH: return 12;
      case ENcartStations.GLEN_SOUTH: return 13;
      case ENcartStations.VISTA_DEL_REY: return 14;
      case ENcartStations.RANCHO_CORONADO: return 15;
      case ENcartStations.LITTLE_CHINA_MEGABUILDING: return 16;
      case ENcartStations.CHARTER_HILL: return 17;
      case ENcartStations.GLEN_EBUNIKE: return 18;
      case ENcartStations.PACIFICA_STADIUM: return 19;
    };
    return 0;
  }


  public final static func GetStationTitle(stationName: ENcartStations) -> String {
    switch stationName {
      case ENcartStations.ARASAKA_WATERFRONT: return "LocKey#95277";
      case ENcartStations.LITTLE_CHINA_HOSPITAL: return "LocKey#95260";
      case ENcartStations.LITTLE_CHINA_NORTH: return "LocKey#95261";
      case ENcartStations.LITTLE_CHINA_SOUTH: return "LocKey#95262";
      case ENcartStations.JAPAN_TOWN_NORTH: return "LocKey#95259";
      case ENcartStations.JAPAN_TOWN_SOUTH: return "LocKey#95263";
      case ENcartStations.DOWNTOWN_NORTH: return "LocKey#95264";
      case ENcartStations.ARROYO: return "LocKey#95265";
      case ENcartStations.CITY_CENTER: return "LocKey#95266";
      case ENcartStations.ARASAKA_TOWER: return "LocKey#95267";
      case ENcartStations.WELLSPRINGS: return "LocKey#95268";
      case ENcartStations.GLEN_NORTH: return "LocKey#95269";
      case ENcartStations.GLEN_SOUTH: return "LocKey#95270";
      case ENcartStations.VISTA_DEL_REY: return "LocKey#95271";
      case ENcartStations.RANCHO_CORONADO: return "LocKey#95272";
      case ENcartStations.LITTLE_CHINA_MEGABUILDING: return "LocKey#95273";
      case ENcartStations.CHARTER_HILL: return "LocKey#95274";
      case ENcartStations.GLEN_EBUNIKE: return "LocKey#95275";
      case ENcartStations.PACIFICA_STADIUM: return "LocKey#95276";
    };
    return "";
  }

  public final static func GetLocalizedStationTitleById(id: Int32) -> String {
    let stationName: ENcartStations = MetroDataHelper.GetStationNameById(id);
    let stationTitle: String = MetroDataHelper.GetStationTitle(stationName);
    let stationTitleLocalized: String = GetLocalizedText(stationTitle);
    return stationTitleLocalized;
  }

  public final static func GetStationDistrict(stationName: ENcartStations) -> ENcartDistricts {
    switch stationName {
      case ENcartStations.ARASAKA_WATERFRONT: return ENcartDistricts.WATSON;
      case ENcartStations.LITTLE_CHINA_HOSPITAL: return ENcartDistricts.WATSON;
      case ENcartStations.LITTLE_CHINA_NORTH: return ENcartDistricts.WATSON;
      case ENcartStations.LITTLE_CHINA_SOUTH: return ENcartDistricts.WATSON;
      case ENcartStations.JAPAN_TOWN_NORTH: return ENcartDistricts.JAPAN_TOWN;
      case ENcartStations.JAPAN_TOWN_SOUTH: return ENcartDistricts.JAPAN_TOWN;
      case ENcartStations.DOWNTOWN_NORTH: return ENcartDistricts.CITY_CENTER;
      case ENcartStations.ARROYO: return ENcartDistricts.SANTO_DOMINGO;
      case ENcartStations.CITY_CENTER: return ENcartDistricts.CITY_CENTER;
      case ENcartStations.ARASAKA_TOWER: return ENcartDistricts.CITY_CENTER;
      case ENcartStations.WELLSPRINGS: return ENcartDistricts.HEYWOOD;
      case ENcartStations.GLEN_NORTH: return ENcartDistricts.HEYWOOD;
      case ENcartStations.GLEN_SOUTH: return ENcartDistricts.HEYWOOD;
      case ENcartStations.VISTA_DEL_REY: return ENcartDistricts.HEYWOOD;
      case ENcartStations.RANCHO_CORONADO: return ENcartDistricts.SANTO_DOMINGO;
      case ENcartStations.LITTLE_CHINA_MEGABUILDING: return ENcartDistricts.WATSON;
      case ENcartStations.CHARTER_HILL: return ENcartDistricts.HEYWOOD;
      case ENcartStations.GLEN_EBUNIKE: return ENcartDistricts.HEYWOOD;
      case ENcartStations.PACIFICA_STADIUM: return ENcartDistricts.PACIFICA;
    };
    return ENcartDistricts.WATSON;
  }

  public final static func GetDistrictTitle(district: ENcartDistricts) -> String {
    switch district {
      case ENcartDistricts.WATSON: return "LocKey#10947";
      case ENcartDistricts.CITY_CENTER: return "LocKey#10950";
      case ENcartDistricts.JAPAN_TOWN: return "LocKey#10948";
      case ENcartDistricts.HEYWOOD: return "LocKey#10945";
      case ENcartDistricts.PACIFICA: return "LocKey#10946";
      case ENcartDistricts.SANTO_DOMINGO: return "LocKey#10949";
    };
    return "";
  }

  public final static func LineStr(line: ModNCartLine) -> String {
    switch line {
      case ModNCartLine.A_RED: return "A";
      case ModNCartLine.B_YELLOW: return "B";
      case ModNCartLine.C_CYAN: return "C";
      case ModNCartLine.D_GREEN: return "D";
      case ModNCartLine.E_ORANGE: return "E";
    };

    return "";
  }

  public final static func LineName(code: Int32) -> ModNCartLine {
    switch code {
      case 1: return ModNCartLine.A_RED;
      case 2: return ModNCartLine.B_YELLOW;
      case 3: return ModNCartLine.C_CYAN;
      case 4: return ModNCartLine.D_GREEN;
      case 5: return ModNCartLine.E_ORANGE;
    };

    return ModNCartLine.NONE;
  }
}
