// -- Utils
public static func HasTheSameId(point: ref<FastTravelPointData>, tdbID: TweakDBID) -> Bool {
  return Equals(point.pointRecord, tdbID);
}

// public static func HasTheSameId(point: ref<FastTravelPointData>, tdbIdStr: String) -> Bool {
//   return Equals(TDBID.ToStringDEBUG(point.pointRecord), tdbIdStr);
// }


// -- CONFIG SECTION STARTS HERE

// Replace false with true to ignore IsFastTravelPointEnabled function and completely disable all fast travel points
public static func ShouldDisableEverything() -> Bool {
  return false;
}

// Defines the list of available fast travel points
// You can comment and uncommend lines to change active fast travel points list
public static func IsFastTravelPointEnabled(point: ref<FastTravelPointData>) -> Bool {

  if ShouldDisableEverything() {
    return false;
  };

  return
    // --- FT points with metro station ---
    HasTheSameId(point, t"FastTravelPoints.wbr_jpn_metro_ftp_02") ||  // Japantown, Metro: Japantown South
    HasTheSameId(point, t"FastTravelPoints.wbr_jpn_metro_ftp_01") ||  // Japantown, Metro: Monroe St
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_01") ||  // Little China, Metro: Farrier St
    HasTheSameId(point, t"FastTravelPoints.wat_lch_metro_ftp_02") ||  // Little China, Metro: Med Center
    HasTheSameId(point, t"FastTravelPoints.wat_nid_metro_ftp_01") ||  // Northside, Metro: Eisenhower St
    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_01") ||  // The Glen, Metro: Glen North
    HasTheSameId(point, t"FastTravelPoints.hey_gle_metro_ftp_02") ||  // The Glen, Metro: Glen South
    HasTheSameId(point, t"FastTravelPoints.hey_rey_metro_ftp_01") ||  // Vista Del Rey, Metro: Congress & MLK

    // --- FT points with bus stop ---
    HasTheSameId(point, t"FastTravelPoints.wbr_nok_dataterm_03") ||   // North Oak, Columbarium
    HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_01") ||   // Northern Badlands, Sunset Motel
    HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_11") ||   // Northern Badlands, Sunshine Motel
    HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_09") ||   // Rancho Coronado, Mallagra & Manzanita
    HasTheSameId(point, t"FastTravelPoints.std_rcr_dataterm_08") ||   // Rancho Coronado, Tama Viewpoint
    HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_10") ||   // Southern Badlands, Las Palapas Motel
    HasTheSameId(point, t"FastTravelPoints.bls_sth_dataterm_06") ||   // Southern Badlands, Tango Tors Motel

    // --- Hideouts
    HasTheSameId(point, t"FastTravelPoints.wat_lch_dataterm_10") ||   // Little China, Megabuilding H10: Atrium (V's appartment)
    HasTheSameId(point, t"FastTravelPoints.wat_kab_dataterm_06") ||   // Kabuki, Charter St (near Judy's appartment)
    HasTheSameId(point, t"FastTravelPoints.bls_nth_dataterm_06") ||   // Northern Badlands, Nomad Camp
    
    // --- No logic here, just FT points for the rest of the districts ---
    HasTheSameId(point, t"FastTravelPoints.std_arr_dataterm_02") ||   // Arroyo, Megabuilding H6
    HasTheSameId(point, t"FastTravelPoints.wbr_hil_dataterm_02") ||   // Charter Hill, Lele Park
    HasTheSameId(point, t"FastTravelPoints.pac_cvi_dataterm_05") ||   // Coastview, Batty's Hotel
    HasTheSameId(point, t"FastTravelPoints.cct_dtn_dataterm_03") ||   // Downtown, Skyline & Republic
    HasTheSameId(point, t"FastTravelPoints.wat_nid_dataterm_01") ||   // Watson, Martin St
    HasTheSameId(point, t"FastTravelPoints.hey_spr_dataterm_04");     // Wellsprings, Megabuilding H2, 
}

// -- CONFIG SECTION ENDS HERE

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
    return ;
  };
  if !this.IsMappinRegistered() {
    mappinData.mappinType = t"Mappins.FastTravelDynamicMappin";
    mappinData.variant = gamedataMappinVariant.FastTravelVariant;
    mappinData.visibleThroughWalls = false;
    this.m_mappinID = this.GetMappinSystem().RegisterMappinWithObject(mappinData, this, n"poi_mappin");
  };
}

// -- Logging
// public static func FastTravelPointDataToString(data: ref<FastTravelPointData>) -> String {
//   return GetLocalizedText(data.GetDistrictDisplayName())
//     + ", " + GetLocalizedText(data.GetPointDisplayName())
//     + ", id = " + TDBID.ToStringDEBUG(data.pointRecord);
// }

// @replaceMethod(FastTravelSystem)
// private final func RegisterMappin(nodeData: ref<FastTravelPointData>) -> Void {
//   let mappinData: MappinData;
//   let transform: Transform;
//   if !nodeData.ShouldShowMappinOnWorldMap() {
//     return ;
//   };
//   mappinData.mappinType = t"Mappins.FastTravelStaticMappin";
//   mappinData.variant = gamedataMappinVariant.FastTravelVariant;
//   mappinData.active = true;
//   nodeData.mappinID = GameInstance.GetMappinSystem(this.GetGameInstance()).RegisterFastTravelMappin(mappinData, nodeData);
//   Log("RegisterMappin: " + FastTravelPointDataToString(nodeData));
// }

// @replaceMethod(DataTerm)
// protected cb func OnInteractionActivated(evt: ref<InteractionEvent>) -> Bool {
//   super.OnInteractionActivated(evt);
//   if Equals(evt.eventType, gameinteractionsEInteractionEventType.EIET_activate) {
//     if Equals(evt.layerData.tag, n"LogicArea") {
//       this.RegisterFastTravelPoints();
//     };
//   };
//   Log("INTERACTED: " + FastTravelPointDataToString(this.m_linkedFastTravelPoint));
// }
