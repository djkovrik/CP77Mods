public class DeclutterWorldMapConfig {

  // Defines mappin variant visibility
  // To comment or uncomment any line just add/remove double slash at the start of the line
  public static func ShouldHideThisOne(mappinVariant: gamedataMappinVariant) -> Bool {
    return 
      // -- CONFIG SECTION STARTS HERE --
      // -- COMMENTED = VISIBLE, UNCOMMENTED = HIDDEN

      /* --- Gigs --- */
      //Equals(mappinVariant, gamedataMappinVariant.BountyHuntVariant) ||  // Bounty Hunt
      //Equals(mappinVariant, gamedataMappinVariant.ClientInDistressVariant) ||  // Client in distress
      //Equals(mappinVariant, gamedataMappinVariant.SabotageVariant) ||  // Sabotage
      //Equals(mappinVariant, gamedataMappinVariant.RetrievingVariant) ||  // Search and recover
      //Equals(mappinVariant, gamedataMappinVariant.ThieveryVariant) ||  // Thievery

      /* --- Crime activities --- */
      Equals(mappinVariant, gamedataMappinVariant.GangWatchVariant) ||  // Assault in progress
      Equals(mappinVariant, gamedataMappinVariant.HiddenStashVariant) ||  // Reported crime (aka NCPD scanner hustle quest)
      //Equals(mappinVariant, gamedataMappinVariant.OutpostVariant) ||  // Suspected organized crime activity (aka boss skull)

      /* --- Misc --- */
      //Equals(mappinVariant, gamedataMappinVariant.ApartmentVariant) ||  // Appartment
      Equals(mappinVariant, gamedataMappinVariant.FastTravelVariant) ||  // Fast travel
      //Equals(mappinVariant, gamedataMappinVariant.TarotVariant) ||  // Tarot card
      //Equals(mappinVariant, gamedataMappinVariant.VehicleVariant) ||  // Your vehicle
      Equals(mappinVariant, gamedataMappinVariant.FixerVariant) ||  // Fixer

      /* --- Services --- */
      //Equals(mappinVariant, gamedataMappinVariant.ServicePointClothesVariant) ||  // Clothes
      //Equals(mappinVariant, gamedataMappinVariant.ServicePointProstituteVariant) ||  // JoyToy
      //Equals(mappinVariant, gamedataMappinVariant.ServicePointMeleeTrainerVariant) ||  // Melee weapon vendor
      //Equals(mappinVariant, gamedataMappinVariant.ServicePointNetTrainerVariant) ||  // Netrunner
      //Equals(mappinVariant, gamedataMappinVariant.ServicePointRipperdocVariant) ||  // Ripperdoc
      //Equals(mappinVariant, gamedataMappinVariant.ServicePointGunsVariant) ||  // Weapon shop
      Equals(mappinVariant, gamedataMappinVariant.ServicePointDropPointVariant) ||  // Drop point
      Equals(mappinVariant, gamedataMappinVariant.ServicePointJunkVariant) ||  // Junk shop
      Equals(mappinVariant, gamedataMappinVariant.ServicePointMedsVariant) ||  // Medpoint
      Equals(mappinVariant, gamedataMappinVariant.ServicePointBarVariant) ||  // Bar
      Equals(mappinVariant, gamedataMappinVariant.ServicePointFoodVariant) ||  // Food

      // -- CONFIG SECTION ENDS HERE --

      false;
  }

  // All mappins within ShowEverythingRange will be shown if ShouldShowLocally is true
  public static func ShouldShowLocally() -> Bool = true
  public static func ShowEverythingRange() -> Float = 250.0  // meters

  public static func ShouldHideVehicleQuests() -> Bool = true
}

// Check if quest related to vehicle
@addMethod(WorldMapMenuGameController)
public func IsRelatedToVehicleQuest(mappin: wref<IMappin>) -> Bool {
  let mappinQuest: ref<JournalQuest>;
  mappinQuest = questLogGameController.GetTopQuestEntry(this.m_journalManager, this.GetMappinJournalEntry(mappin));

  return NotEquals(mappinQuest, null) && Equals(mappinQuest.GetType(), gameJournalQuestType.VehicleQuest);
}

// Hide mappin
@replaceMethod(WorldMapMenuGameController)
public func CreateMappinUIProfile(mappin: wref<IMappin>, mappinVariant: gamedataMappinVariant, customData: ref<MappinControllerCustomData>) -> MappinUIProfile {
  let isHidden: Bool;
  let isVehicleQuest: Bool;
  let isTracked: Bool;
  let widgetResource: ResRef;
  let isInLocalRange: Bool;

  isInLocalRange = DeclutterWorldMapConfig.ShouldShowLocally() && Vector4.Distance(this.GetPlayerControlledObject().GetWorldPosition(), mappin.GetWorldPosition()) <= DeclutterWorldMapConfig.ShowEverythingRange();
  isHidden = !isInLocalRange  && !this.IsFastTravelEnabled() && DeclutterWorldMapConfig.ShouldHideThisOne(mappin.GetVariant());
  isVehicleQuest = this.IsRelatedToVehicleQuest(mappin);
  isTracked = mappin.IsPlayerTracked();

  if (isHidden && !isTracked) || (DeclutterWorldMapConfig.ShouldHideVehicleQuests() && isVehicleQuest && !isTracked) {
    return MappinUIProfile.None();
  };

  widgetResource = r"base\gameplay\gui\fullscreen\world_map\mappins\default_mappin.inkwidget";
  if NotEquals(customData, null) {
    if customData.IsA(n"gameuiWorldMapPlayerInitData") {
      widgetResource = r"base\gameplay\gui\fullscreen\world_map\mappins\player_mappin.inkwidget";
    };
  };
  return MappinUIProfile.Create(widgetResource, t"MappinUISpawnProfile.Always", t"MapMappinUIProfile.Default");
}
