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
    // --- No logic here, just the rest of the fast travel points (the list might be incomplete) ---
    // HasTheSameId(point, t"FastTravelPoints.wat_awf_dataterm_03") ||   // Arasaka Waterfront, California & Pershing
    // HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_06") ||   // Arroyo, Arasaka Industrial Park
    // HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_04") ||   // Arroyo, Hargreaves St
    // HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_05") ||   // Arroyo, Megabuilding H4
    // HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_02") ||   // Arroyo, Megabuilding H6
    // HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_08") ||   // Arroyo, MLK & Brandon
    // HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_03") ||   // Arroyo, Red Dirt Bar
    // HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_01") ||   // Arroyo, Republic East
    // HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_07") ||   // Arroyo, San Amaro St
    // HasTheSameId(point, t"FastTravelPoints.wbr_hil_dataterm_05") ||   // Charter Hill, Dynalar
    // HasTheSameId(point, t"FastTravelPoints.wbr_hil_dataterm_01") ||   // Charter Hill, Gold Niwaki Plaza
    // HasTheSameId(point, t"FastTravelPoints.wbr_hil_dataterm_02") ||   // Charter Hill, Lele Park
    // HasTheSameId(point, t"FastTravelPoints.wbr_hil_dataterm_04") ||   // Charter Hill, Longshore South
    // HasTheSameId(point, t"FastTravelPoints.wbr_hil_dataterm_03") ||   // Charter Hill, Luxury Apartments
    // HasTheSameId(point, t"FastTravelPoints.pac_cvi_dataterm_05") ||   // Coastview, Batty's Hotel
    // HasTheSameId(point, t"FastTravelPoints.pac_cvi_dataterm_03") ||   // Coastview, Chapel
    // HasTheSameId(point, t"FastTravelPoints.pac_cvi_dataterm_01") ||   // Coastview, Grand Imperial Mall
    // HasTheSameId(point, t"FastTravelPoints.pac_cvi_dataterm_02") ||   // Coastview, Pacifica Pier
    // HasTheSameId(point, t"FastTravelPoints.pac_cvi_dataterm_04") ||   // Coastview, Stadium Parking
    // HasTheSameId(point, t"FastTravelPoints.cct_cpz_dataterm_02") ||   // Corpo Plaza, Arasaka Tower
    // HasTheSameId(point, t"FastTravelPoints.cct_cpz_dataterm_03") ||   // Corpo Plaza, Reconciliation Park
    // HasTheSameId(point, t"FastTravelPoints.cct_cpz_dataterm_01") ||   // Corpo Plaza, Ring Road
    // HasTheSameId(point, t"FastTravelPoints.cct_dtn_dataterm_02") ||   // Downtown, Berkeley & Bruce Skiv
    // HasTheSameId(point, t"FastTravelPoints.cct_dtn_dataterm_07") ||   // Downtown, Downtown Central
    // HasTheSameId(point, t"FastTravelPoints.cct_dtn_dataterm_05") ||   // Downtown, Downtown North
    // HasTheSameId(point, t"FastTravelPoints.cct_dtn_dataterm_04") ||   // Downtown, Gold Beach Marina
    // HasTheSameId(point, t"FastTravelPoints.cct_dtn_dataterm_01") ||   // Downtown, Halsey & MLK
    // HasTheSameId(point, t"FastTravelPoints.cct_dtn_dataterm_03") ||   // Downtown, Skyline & Republic
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_01") ||   // Japantown, Capitola St
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_02") ||   // Japantown, Cherry Blossom Market
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_06") ||   // Japantown, Crescent & Broad
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_11") ||   // Japantown, Dark Matter
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_07") ||   // Japantown, Fourth Wall Studios
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_10") ||   // Japantown, Japantown West
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_05") ||   // Japantown, Megabuilding H8
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_09") ||   // Japantown, Redwood Market
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_04") ||   // Japantown, Sagan & Diamond
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_03") ||   // Japantown, Silk Road West
    // HasTheSameId(point, t"FastTravelPoints.wbr_jpn_dataterm_08") ||   // Japantown, Skyline & Salinas
    // HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_10") ||   // Kabuki, Allen St South
    // HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_08") ||   // Kabuki, Bellevue Overwalk
    // HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_03") ||   // Kabuki, Creek Loop
    // HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_01") ||   // Kabuki, Kabuki Market
    // HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_04") ||   // Kabuki, Kabuki: Central
    // HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_02") ||   // Kabuki, Kennedy North
    // HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_05") ||   // Kabuki, Pinewood St South
    // HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_07") ||   // Kabuki, Sutter St
    // HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_04") ||   // Little China, Afterlife
    // HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_05") ||   // Little China, Bradbury & Buran
    // HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_03") ||   // Little China, California & Cartwright
    // HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_07") ||   // Little China, Clarendon St
    // HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_02") ||   // Little China, Drake Ave
    // HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_01") ||   // Little China, Goldsmith St
    // HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_11") ||   // Little China, Riot
    // HasTheSameId(point, t"FastTravelPoints.wbr_nok_dataterm_01") ||   // North Oak, Arasaka Estate
    // HasTheSameId(point, t"FastTravelPoints.wbr_nok_dataterm_04") ||   // North Oak, Drive-In Theater
    // HasTheSameId(point, t"FastTravelPoints.wbr_nok_dataterm_02") ||   // North Oak, Kerry Eurodyne's Residence
    // HasTheSameId(point, t"FastTravelPoints.wbr_nok_dataterm_05") ||   // North Oak, North Oak Sign
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_07") ||   // Northern Badlands, 101 North
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_08") ||   // Northern Badlands, Dam
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_14") ||   // Northern Badlands, Desert Film Set
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_15") ||   // Northern Badlands, Edgewood Farm
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_16") ||   // Northern Badlands, Far Ridge
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_13") ||   // Northern Badlands, I-9 East
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_17") ||   // Northern Badlands, Lake Farm
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_02") ||   // Northern Badlands, Medeski Fuel Station
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_03") ||   // Northern Badlands, Mobile Camp
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_05") ||   // Northern Badlands, Oil Fields
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_04") ||   // Northern Badlands, Rocky Ridge
    // HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_10") ||   // Northern Badlands, Wraith Camp
    // HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_07") ||   // Northside, All Foods Plant
    // HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_02") ||   // Northside, Docks
    // HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_03") ||   // Northside, East
    // HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_08") ||   // Northside, Ebunike Docks
    // HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_04") ||   // Northside, Longshore North
    // HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_05") ||   // Northside, Offshore St
    // HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_06") ||   // Northside, Pershing St
    // HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_01") ||   // Rancho Coronado, Almunecar & Jerez
    // HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_06") ||   // Rancho Coronado, Kendal Park
    // HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_10") ||   // Rancho Coronado, PieZ
    // HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_05") ||   // Rancho Coronado, Rancho Coronado East
    // HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_02") ||   // Rancho Coronado, Rancho Coronado North
    // HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_03") ||   // Rancho Coronado, Rancho Coronado South
    // HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_07") ||   // Rancho Coronado, Trailer Park
    // HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_12") ||   // Southern Badlands, Abandoned Fuel Station
    // HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_08") ||   // Southern Badlands, Autowerks
    // HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_01") ||   // Southern Badlands, Border Checkpoint
    // HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_02") ||   // Southern Badlands, Fuel Station
    // HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_04") ||   // Southern Badlands, Protein Farm
    // HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_05") ||   // Southern Badlands, Regional Airport
    // HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_09") ||   // Southern Badlands, Solar Arrays
    // HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_03") ||   // Southern Badlands, Solar Power Station
    // HasTheSameId(point, t"FastTravelPoints.hey_gle_dataterm_04") ||   // The Glen, El Coyote Cojo
    // HasTheSameId(point, t"FastTravelPoints.hey_gle_dataterm_08") ||   // The Glen, Embers
    // HasTheSameId(point, t"FastTravelPoints.hey_gle_dataterm_06") ||   // The Glen, Hanford Overpass
    // HasTheSameId(point, t"FastTravelPoints.hey_gle_dataterm_05") ||   // The Glen, Megabuilding H3
    // HasTheSameId(point, t"FastTravelPoints.hey_gle_dataterm_03") ||   // The Glen, Palms View Way
    // HasTheSameId(point, t"FastTravelPoints.hey_gle_dataterm_01") ||   // The Glen, Senate & Market
    // HasTheSameId(point, t"FastTravelPoints.hey_gle_dataterm_07") ||   // The Glen, Valentino Alley
    // HasTheSameId(point, t"FastTravelPoints.hey_gle_dataterm_02") ||   // The Glen, Ventura & Skyline
    // HasTheSameId(point, t"FastTravelPoints.hey_rey_dataterm_03") ||   // Vista Del Rey, College St
    // HasTheSameId(point, t"FastTravelPoints.hey_rey_dataterm_05") ||   // Vista Del Rey, Congress & Madison
    // HasTheSameId(point, t"FastTravelPoints.hey_rey_dataterm_07") ||   // Vista Del Rey, Delamain HQ
    // HasTheSameId(point, t"FastTravelPoints.hey_rey_dataterm_02") ||   // Vista Del Rey, Petrel St
    // HasTheSameId(point, t"FastTravelPoints.hey_rey_dataterm_01") ||   // Vista Del Rey, Republic & Vine
    // HasTheSameId(point, t"FastTravelPoints.hey_rey_dataterm_06") ||   // Vista Del Rey, Shooting Range
    // HasTheSameId(point, t"FastTravelPoints.hey_rey_dataterm_04") ||   // Vista Del Rey, Skyline East
    // HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_01") ||   // Watson, Martin St
    // HasTheSameId(point, t"FastTravelPoints.hey_spr_dataterm_03") ||   // Wellsprings, Berkeley & Bay
    // HasTheSameId(point, t"FastTravelPoints.hey_spr_dataterm_02") ||   // Wellsprings, Cannery Plaza
    // HasTheSameId(point, t"FastTravelPoints.hey_spr_dataterm_01") ||   // Wellsprings, Corporation St
    // HasTheSameId(point, t"FastTravelPoints.hey_spr_dataterm_04") ||   // Wellsprings, Megabuilding H2
    // HasTheSameId(point, t"FastTravelPoints.hey_spr_dataterm_06") ||   // Wellsprings, Palms View Plaza
    // HasTheSameId(point, t"FastTravelPoints.hey_spr_dataterm_05") ||   // Wellsprings, Parque del Mar
    // HasTheSameId(point, t"FastTravelPoints.hey_spr_dataterm_07") ||   // Wellsprings, Pumping Station
    // HasTheSameId(point, t"FastTravelPoints.pac_wwd_dataterm_03") ||   // West Wind Estate, West Wind Apartments

    // --- Hideouts
    HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_10") ||   // Little China, Megabuilding H10: Atrium (V's appartment)
    HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_06") ||   // Kabuki, Charter St (near Judy's appartment)
    HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_06") ||   // Northern Badlands, Nomad Camp

    // -- New apartments from patch 1.5
    HasTheSameId(point, t"FastTravelPoints.dlc6_apart_cct_dtn_dataterm") ||  // Corpo Plaza, Apartment
    HasTheSameId(point, t"FastTravelPoints.dlc6_apart_hey_gle_dataterm") ||  // The Glen, Apartment
    HasTheSameId(point, t"FastTravelPoints.dlc6_apart_wat_nid_dataterm") ||  // Northside, Apartment
    HasTheSameId(point, t"FastTravelPoints.dlc6_apart_wbr_jpn_dataterm") ||  // Japantown, Apartment
    
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
    return ;
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
@replaceMethod(WorldMappinsContainerController)
public func CreateMappinUIProfile(mappin: wref<IMappin>, mappinVariant: gamedataMappinVariant, customData: ref<MappinControllerCustomData>) -> MappinUIProfile {
  let questAnimationRecord: ref<UIAnimation_Record>;
  let questMappin: wref<QuestMappin>;
  let stealthMappin: wref<StealthMappin>;
  let gameplayRoleData: ref<GameplayRoleMappinData> = mappin.GetScriptData() as GameplayRoleMappinData;
  let defaultRuntimeProfile: TweakDBID = t"WorldMappinUIProfile.Default";
  let defaultWidgetResource: ResRef = r"base\\gameplay\\gui\\widgets\\mappins\\quest\\default_mappin.inkwidget";
  if mappin.IsExactlyA(n"gamemappinsStealthMappin") {
    stealthMappin = mappin as StealthMappin;
    if stealthMappin.IsCrowdNPC() {
      return MappinUIProfile.None();
    };
    return MappinUIProfile.Create(r"base\\gameplay\\gui\\widgets\\mappins\\stealth\\stealth_default_mappin.inkwidget", t"MappinUISpawnProfile.Stealth", t"WorldMappinUIProfile.Stealth");
  };
  if mappin.IsExactlyA(n"gamemappinsRemotePlayerMappin") {
    return MappinUIProfile.Create(r"multi\\gameplay\\gui\\widgets\\world_mappins\\remote_player_mappin.inkwidget", t"MappinUISpawnProfile.Always", defaultRuntimeProfile);
  };
  if mappin.IsExactlyA(n"gamemappinsPingSystemMappin") {
    return MappinUIProfile.Create(r"multi\\gameplay\\gui\\widgets\\world_mappins\\pingsystem_mappin.inkwidget", t"MappinUISpawnProfile.Always", defaultRuntimeProfile);
  };
  if mappin.IsExactlyA(n"gamemappinsInteractionMappin") {
    return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.ShortRange", t"WorldMappinUIProfile.Interaction");
  };
  if mappin.IsExactlyA(n"gamemappinsPointOfInterestMappin") {
    if MappinUIUtils.IsMappinServicePoint(mappinVariant) {
      return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.ShortRange", t"WorldMappinUIProfile.ServicePoint");
    };
    if Equals(mappinVariant, gamedataMappinVariant.FixerVariant) {
      return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.ShortRange", t"WorldMappinUIProfile.Fixer");
    };
    return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.ShortRange", defaultRuntimeProfile);
  };
  if Equals(mappinVariant, gamedataMappinVariant.QuickHackVariant) {
    return MappinUIProfile.Create(r"base\\gameplay\\gui\\widgets\\mappins\\interaction\\quick_hack_mappin.inkwidget", t"MappinUISpawnProfile.ShortRange", t"WorldMappinUIProfile.QuickHack");
  };
  if Equals(mappinVariant, gamedataMappinVariant.PhoneCallVariant) {
    return MappinUIProfile.Create(r"base\\gameplay\\gui\\widgets\\mappins\\interaction\\quick_hack_mappin.inkwidget", t"MappinUISpawnProfile.Always", defaultRuntimeProfile);
  };
  if Equals(mappinVariant, gamedataMappinVariant.Zzz04_PreventionVehicleVariant) {
    return MappinUIProfile.None();
  };
  if Equals(mappinVariant, gamedataMappinVariant.VehicleVariant) || Equals(mappinVariant, gamedataMappinVariant.Zzz03_MotorcycleVariant) {
    return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.LongRange", t"WorldMappinUIProfile.Vehicle");
  };
  if gameplayRoleData != null {
    if Equals(mappinVariant, gamedataMappinVariant.FocusClueVariant) {
      return MappinUIProfile.Create(r"base\\gameplay\\gui\\widgets\\mappins\\gameplay\\gameplay_mappin.inkwidget", t"MappinUISpawnProfile.Always", t"WorldMappinUIProfile.FocusClue");
    };
    if Equals(mappinVariant, gamedataMappinVariant.LootVariant) {
      return MappinUIProfile.Create(r"base\\gameplay\\gui\\widgets\\mappins\\gameplay\\gameplay_mappin.inkwidget", t"MappinUISpawnProfile.Always", t"WorldMappinUIProfile.Loot");
    };
    return MappinUIProfile.Create(r"base\\gameplay\\gui\\widgets\\mappins\\gameplay\\gameplay_mappin.inkwidget", t"MappinUISpawnProfile.Always", t"WorldMappinUIProfile.GameplayRole");
  };
  if Equals(mappinVariant, gamedataMappinVariant.FastTravelVariant) {
    return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.LongRange", t"WorldMappinUIProfile.FastTravel");
  };
  if Equals(mappinVariant, gamedataMappinVariant.ServicePointDropPointVariant) {
    return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.ShortRange", t"WorldMappinUIProfile.DropPoint");
  };
  if mappin.IsQuestMappin() {
    questMappin = mappin as QuestMappin;
    if IsDefined(questMappin) {
      if questMappin.IsUIAnimation() {
        questAnimationRecord = TweakDBInterface.GetUIAnimationRecord(questMappin.GetUIAnimationRecordID());
        if ResRef.IsValid(questAnimationRecord.WidgetResource()) && NotEquals(questAnimationRecord.AnimationName(), n"") {
          return MappinUIProfile.Create(questAnimationRecord.WidgetResource(), t"MappinUISpawnProfile.Always", defaultRuntimeProfile);
        };
      } else {
        return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.Always", t"WorldMappinUIProfile.Quest");
      };
    };
  };
  if customData != null && (customData as TrackedMappinControllerCustomData) != null {
    return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.Always", defaultRuntimeProfile);
  };
  return MappinUIProfile.Create(defaultWidgetResource, t"MappinUISpawnProfile.MediumRange", defaultRuntimeProfile);
}
