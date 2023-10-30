// -- Utils
public static func HasTheSameId(point: ref<FastTravelPointData>, tdbID: TweakDBID) -> Bool {
  return Equals(point.pointRecord, tdbID);
}

public static func IsFastTravelPointEnabled(point: ref<FastTravelPointData>) -> Bool {

  // -- CONFIG SECTION STARTS HERE

  /*
    Defines the list of available fast travel points.
    To hide any fast travel point just put double slash at the start of the line.
    For example, if you want to hide Nomad Camp point which defined by this line:

      HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_06") ||   // Northern Badlands, Nomad Camp
    
    then add // to make it look like this:

      // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_06") ||   // Northern Badlands, Nomad Camp

    To show any hidden fast travel point just remove // from the start of the line.

  */
  return
    // --- Hideouts
    HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_10") ||   // Little China, Megabuilding H10: Atrium (V's appartment)
    HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_06") ||   // Kabuki, Charter St (near Judy's appartment)
    HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_06") ||   // Northern Badlands, Nomad Camp

    // -- New apartments from patch 1.5
    HasTheSameId(point, t"FastTravelPoints.dlc6_apart_cct_dtn_dataterm") ||  // Corpo Plaza, Apartment
    HasTheSameId(point, t"FastTravelPoints.dlc6_apart_hey_gle_dataterm") ||  // The Glen, Apartment
    HasTheSameId(point, t"FastTravelPoints.dlc6_apart_wat_nid_dataterm") ||  // Northside, Apartment
    HasTheSameId(point, t"FastTravelPoints.dlc6_apart_wbr_jpn_dataterm") ||  // Japantown, Apartment
    
    // --- No logic here, just FT points for the rest of the districts ---
    HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_02") ||   // Arroyo, Megabuilding H6
    HasTheSameId(point, t"FastTravelPoints.wbr_hil_dataterm_02") ||   // Charter Hill, Lele Park
    HasTheSameId(point, t"FastTravelPoints.pac_cvi_dataterm_05") ||   // Coastview, Batty's Hotel
    HasTheSameId(point, t"FastTravelPoints.cct_dtn_dataterm_03") ||   // Downtown, Skyline & Republic
    HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_01") ||   // Watson, Martin St
    HasTheSameId(point, t"FastTravelPoints.hey_spr_dataterm_04") ||   // Wellsprings, Megabuilding H2, 


    // --- FT points with metro station ---
    HasTheSameId(point, t"FastTravelPoints.wbr_jpn_metro_ftp_01") ||  // Japantown, Metro: Monroe St
    HasTheSameId(point, t"FastTravelPoints.wbr_jpn_metro_ftp_02") ||  // Japantown, Metro: Japantown South
    HasTheSameId(point, t"FastTravelPoints.wbr_jpn_metro_ftp_03") ||
    HasTheSameId(point, t"FastTravelPoints.wbr_jpn_metro_ftp_04") ||
    HasTheSameId(point, t"FastTravelPoints.wbr_jpn_metro_ftp_05") ||
    HasTheSameId(point, t"FastTravelPoints.wbr_jpn_metro_ftp_06") ||

    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_01") ||  // Little China, Metro: Farrier St
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_02") ||  // Little China, Metro: Med Center
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_11") ||  // Little China, Metro: Med Center
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_12") ||  // Little China, Metro: Med Center
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_03") ||  // Little China, Metro: Zocalo
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_04") ||  // Little China, Metro: Ellison Street
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_05") ||
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_06") ||
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_07") ||
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_08") ||
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_09") ||
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_10") ||

    HasTheSameId(point, t"FastTravelPoints.wat_nid_metro_ftp_01") ||  // Northside, Metro: Eisenhower St
    HasTheSameId(point, t"FastTravelPoints.wat_nid_metro_ftp_02") ||

    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_01") ||  // The Glen, Metro: Glen North
    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_02") ||  // The Glen, Metro: Glen South

    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_03") ||  // The Glen, Metro: Ebunike
    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_04") ||
    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_05") ||
    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_06") ||
    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_07") ||
    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_08") ||
    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_09") ||

    HasTheSameId(point, t"FastTravelPoints.hey_rey_metro_ftp_01") ||  // Vista Del Rey, Metro: Congress & MLK
    HasTheSameId(point, t"FastTravelPoints.hey_rey_metro_ftp_02") ||
    HasTheSameId(point, t"FastTravelPoints.hey_rey_metro_ftp_03") ||
    HasTheSameId(point, t"FastTravelPoints.hey_rey_metro_ftp_04") ||

    HasTheSameId(point, t"FastTravelPoints.hey_spr_metro_ftp_01") ||  // Wellsprings, Metro: Market St
    HasTheSameId(point, t"FastTravelPoints.hey_spr_metro_ftp_02") ||
    HasTheSameId(point, t"FastTravelPoints.hey_spr_metro_ftp_03") ||
    HasTheSameId(point, t"FastTravelPoints.hey_spr_metro_ftp_04") ||

    HasTheSameId(point, t"FastTravelPoints.std_arr_metro_ftp_01") ||  // Arroyo, Metro: Wollesen St
    HasTheSameId(point, t"FastTravelPoints.std_arr_metro_ftp_02") ||
    HasTheSameId(point, t"FastTravelPoints.std_arr_metro_ftp_03") ||
    HasTheSameId(point, t"FastTravelPoints.std_arr_metro_ftp_04") ||
    HasTheSameId(point, t"FastTravelPoints.std_arr_metro_ftp_05") ||
    HasTheSameId(point, t"FastTravelPoints.std_arr_metro_ftp_06") ||

    HasTheSameId(point, t"FastTravelPoints.wbr_hil_metro_ftp_01") ||  // Charter Hill, Metro: Charter Hill
    HasTheSameId(point, t"FastTravelPoints.wbr_hil_metro_ftp_02") ||
    HasTheSameId(point, t"FastTravelPoints.wbr_hil_metro_ftp_03") ||
    HasTheSameId(point, t"FastTravelPoints.wbr_hil_metro_ftp_04") ||
    HasTheSameId(point, t"FastTravelPoints.wbr_hil_metro_ftp_05") ||
    HasTheSameId(point, t"FastTravelPoints.wbr_hil_metro_ftp_06") ||

    HasTheSameId(point, t"FastTravelPoints.pac_cvi_metro_ftp_01") ||  // Coastview, Metro: Stadium
    HasTheSameId(point, t"FastTravelPoints.pac_cvi_metro_ftp_02") ||

    HasTheSameId(point, t"FastTravelPoints.cct_cpz_metro_ftp_01") ||  // Corpo Plaza, Metro: Republic Way
    HasTheSameId(point, t"FastTravelPoints.cct_cpz_metro_ftp_02") ||
    HasTheSameId(point, t"FastTravelPoints.cct_cpz_metro_ftp_03") ||  // Corpo Plaza, Metro: Memorial Park

    HasTheSameId(point, t"FastTravelPoints.cct_dtn_metro_ftp_01") ||
    HasTheSameId(point, t"FastTravelPoints.cct_dtn_metro_ftp_02") ||  // Downtown, Metro: Downtown - Alexander St
    HasTheSameId(point, t"FastTravelPoints.cct_dtn_metro_ftp_03") ||

    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_01") ||  // Rancho Coronado, Metro: Megabuilding H7
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_02") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_03") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_04") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_05") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_06") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_07") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_08") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_09") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_10") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_11") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_12") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_13") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_14") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_15") ||
    HasTheSameId(point, t"FastTravelPoints.std_rcr_metro_ftp_16") ||

    // --- FT points with bus stop ---
    HasTheSameId(point, t"FastTravelPoints.wbr_nok_dataterm_03") ||   // North Oak, Columbarium
    HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_01") ||   // Northern Badlands, Sunset Motel
    HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_11") ||   // Northern Badlands, Sunshine Motel
    HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_09") ||   // Rancho Coronado, Mallagra & Manzanita
    HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_08") ||   // Rancho Coronado, Tama Viewpoint
    HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_10") ||   // Southern Badlands, Las Palapas Motel
    HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_06") ||   // Southern Badlands, Tango Tors Motel
  
  false;
    // -- CONFIG SECTION ENDS HERE
}

// -- Overrides
@replaceMethod(FastTravelPointData)
public final const func ShouldShowMappinOnWorldMap() -> Bool {
  return TweakDBInterface.GetFastTravelPointRecord(this.pointRecord).ShowOnWorldMap() && IsFastTravelPointEnabled(this);
}

@replaceMethod(FastTravelPointData)
public final const func ShouldShowMappinInWorld() -> Bool {
  return TweakDBInterface.GetFastTravelPointRecord(this.pointRecord).ShowInWorld() && IsFastTravelPointEnabled(this);
}

@replaceMethod(DataTerm)
private final func RegisterMappin() -> Void {
  let mappinData: MappinData;
  if this.GetDevicePS().IsDisabled() {
    return;
  };
  if !this.m_linkedFastTravelPoint.ShouldShowMappinInWorld() {
    this.DeactivateDevice(); // <- deactivates terminal if ft point is hidden
    EntityGameInterface.Destroy(this.GetEntity()); // <- destroy terminal entity
    return ;
  };
  if !this.IsMappinRegistered() {
    mappinData.mappinType = t"Mappins.FastTravelDynamicMappin";
    mappinData.variant = gamedataMappinVariant.FastTravelVariant;
    mappinData.visibleThroughWalls = false;
    this.m_mappinID = this.GetMappinSystem().RegisterMappinWithObject(mappinData, this, n"poi_mappin");
  };
}

// ShortRange spawnProfile for Fast Travel mappin replaced with LongRange
@wrapMethod(WorldMappinsContainerController)
public func CreateMappinUIProfile(mappin: wref<IMappin>, mappinVariant: gamedataMappinVariant, customData: ref<MappinControllerCustomData>) -> MappinUIProfile {
  let defaultRes: ResRef = r"base\\gameplay\\gui\\widgets\\mappins\\quest\\default_mappin.inkwidget";
  if Equals(mappinVariant, gamedataMappinVariant.FastTravelVariant) {
    return MappinUIProfile.Create(defaultRes, t"MappinUISpawnProfile.ShortRange", t"WorldMappinUIProfile.FastTravel");
  };

  return wrappedMethod(mappin, mappinVariant, customData);
}
