public class DeclutterWorldMapConfig {

  // Defines mappin variants which must be hidden
  public static func IsVariantHidden(mappinVariant: gamedataMappinVariant) -> Bool {
    return 
      /* --- Gigs --- */
      Equals(mappinVariant, gamedataMappinVariant.BountyHuntVariant) ||                 // Bounty Hunt
      Equals(mappinVariant, gamedataMappinVariant.ClientInDistressVariant) ||           // Client in distress
      Equals(mappinVariant, gamedataMappinVariant.SabotageVariant) ||                   // Sabotage
      Equals(mappinVariant, gamedataMappinVariant.RetrievingVariant) ||                 // Search and recover
      Equals(mappinVariant, gamedataMappinVariant.ThieveryVariant) ||                   // Thievery

      /* --- Services --- */
      Equals(mappinVariant, gamedataMappinVariant.ApartmentVariant) ||                  // Appartment
      Equals(mappinVariant, gamedataMappinVariant.ServicePointBarVariant) ||            // Bar
      Equals(mappinVariant, gamedataMappinVariant.ServicePointClothesVariant) ||        // Clothes
      Equals(mappinVariant, gamedataMappinVariant.ServicePointDropPointVariant) ||      // Drop point
      Equals(mappinVariant, gamedataMappinVariant.ServicePointFoodVariant) ||           // Food
      Equals(mappinVariant, gamedataMappinVariant.ServicePointProstituteVariant) ||     // JoyToy
      Equals(mappinVariant, gamedataMappinVariant.ServicePointJunkVariant) ||           // Junk shop
      Equals(mappinVariant, gamedataMappinVariant.ServicePointMedsVariant) ||           // Medpoint
      Equals(mappinVariant, gamedataMappinVariant.ServicePointMeleeTrainerVariant) ||   // Melee weapon vendor
      Equals(mappinVariant, gamedataMappinVariant.ServicePointNetTrainerVariant) ||     // Netrunner
      Equals(mappinVariant, gamedataMappinVariant.ServicePointRipperdocVariant) ||      // Ripperdoc
      Equals(mappinVariant, gamedataMappinVariant.ServicePointGunsVariant) ||           // Weapon shop

      /* --- Criminal activities --- */
      Equals(mappinVariant, gamedataMappinVariant.GangWatchVariant) ||                  // Assault in progress
      Equals(mappinVariant, gamedataMappinVariant.HiddenStashVariant) ||                // Reported crime
      Equals(mappinVariant, gamedataMappinVariant.OutpostVariant) ||                    // Suspected organized crime activity

      /* --- Misc --- */
      Equals(mappinVariant, gamedataMappinVariant.FastTravelVariant) ||                 // Fast travel
      Equals(mappinVariant, gamedataMappinVariant.TarotVariant) ||                      // Tarot card
      Equals(mappinVariant, gamedataMappinVariant.FixerVariant);                        // Fixer
  }

  // If true then markers will be hidden not just for world map but in-game too
  public static func HideIngameAsWell() -> Bool = false
}

// Hide on world map
@replaceMethod(BaseWorldMapMappinController)
protected func UpdateVisibility() -> Void {
  let questMappin: ref<QuestMappin>;
  let wasVisible: Bool;
  let isHidden: Bool;
  questMappin = (this.m_mappin as QuestMappin);
  this.m_isCompletedPhase = Equals(this.m_mappin.GetPhase(), gamedataMappinPhase.CompletedPhase);
  isHidden = DeclutterWorldMapConfig.IsVariantHidden(this.m_mappin.GetVariant());

  if (isHidden) {
    this.GetRootWidget().SetVisible(false);  // Hide normal variant
  }

  if NotEquals(questMappin, null) {
    wasVisible = this.GetRootWidget().IsVisible();
    this.GetRootWidget().SetVisible(questMappin.IsActive() && !isHidden); // Hide quest variant
    if !wasVisible && questMappin.IsActive() {
      this.GetRootWidget().SetOpacity(0.01);
    };
  };
}

// // Hide ingame
@replaceMethod(QuestMappinController)
private func UpdateVisibility() -> Void {
  let isTracked: Bool;
  let isInQuestArea: Bool;
  let showWhenClamped: Bool;
  let shouldBeVisible: Bool;
  isTracked = this.IsPlayerTracked();
  isInQuestArea = this.m_questMappin != null && this.m_questMappin.IsInsideTrigger();
  showWhenClamped = this.isCurrentlyClamped ? !this.m_shouldHideWhenClamped : true;

  if DeclutterWorldMapConfig.HideIngameAsWell() {
    shouldBeVisible = this.m_mappin.IsVisible() && showWhenClamped && !isInQuestArea && !DeclutterWorldMapConfig.IsVariantHidden(this.m_mappin.GetVariant());
  } else {
    shouldBeVisible = this.m_mappin.IsVisible() && showWhenClamped && !isInQuestArea;
  };

  this.SetRootVisible(shouldBeVisible);
}

// Remove onHover popup
@replaceMethod(WorldMapMenuGameController)
protected cb func OnHoverOverMappin(e: ref<inkPointerEvent>) -> Bool {
  let hoveredController: ref<BaseWorldMapMappinController>;
  let isHidden: Bool;
  hoveredController = (e.GetTarget().GetController() as BaseWorldMapMappinController);
  if NotEquals(hoveredController, null) && hoveredController.CanSelectMappin() {
    isHidden = DeclutterWorldMapConfig.IsVariantHidden(hoveredController.m_mappin.GetVariant());
    if !isHidden {
      this.SetSelectedMappin(hoveredController);
    };
  };
}

/*

// -- Getting mappin data
public final static func VariantToString(mappinVariant: gamedataMappinVariant) -> String {
  switch mappinVariant {
    case gamedataMappinVariant.DefaultVariant:
      return "quest";
    case gamedataMappinVariant.DefaultQuestVariant:
      return "minor_quest";
    case gamedataMappinVariant.DefaultInteractionVariant:
      return "quest";
    case gamedataMappinVariant.ConversationVariant:
      return "talk";
    case gamedataMappinVariant.QuestGiverVariant:
      return "quest_giver";
    case gamedataMappinVariant.MinorActivityVariant:
      return "minor_activity";
    case gamedataMappinVariant.ExclamationMarkVariant:
      return "quest";
    case gamedataMappinVariant.RetrievingVariant:
      return "retrieving";
    case gamedataMappinVariant.ThieveryVariant:
      return "thievery";
    case gamedataMappinVariant.SabotageVariant:
      return "sabotage";
    case gamedataMappinVariant.ClientInDistressVariant:
      return "client_in_distress";
    case gamedataMappinVariant.BountyHuntVariant:
      return "bounty_hunt";
    case gamedataMappinVariant.CourierVariant:
      return "courier";
    case gamedataMappinVariant.GangWatchVariant:
      return "gang_watch";
    case gamedataMappinVariant.OutpostVariant:
      return "outpost";
    case gamedataMappinVariant.ResourceVariant:
      return "resource";
    case gamedataMappinVariant.HiddenStashVariant:
      return "hidden_stash";
    case gamedataMappinVariant.HuntForPsychoVariant:
      return "hunt_for_psycho";
    case gamedataMappinVariant.SmugglersDenVariant:
      return "smugglers";
    case gamedataMappinVariant.WanderingMerchantVariant:
      return "wandering_merchant";
    case gamedataMappinVariant.ConvoyVariant:
      return "convoy";
    case gamedataMappinVariant.FixerVariant:
      return "fixer";
    case gamedataMappinVariant.DropboxVariant:
      return "dropbox";
    case gamedataMappinVariant.ApartmentVariant:
      return "apartment";
    case gamedataMappinVariant.ServicePointClothesVariant:
      return "clothes";
    case gamedataMappinVariant.ServicePointFoodVariant:
      return "food_vendor";
    case gamedataMappinVariant.ServicePointBarVariant:
      return "bar";
    case gamedataMappinVariant.ServicePointGunsVariant:
      return "gun";
    case gamedataMappinVariant.ServicePointMedsVariant:
      return "medicine";
    case gamedataMappinVariant.ServicePointMeleeTrainerVariant:
      return "melee";
    case gamedataMappinVariant.ServicePointNetTrainerVariant:
      return "netservice";
    case gamedataMappinVariant.ServicePointProstituteVariant:
      return "prostitute";
    case gamedataMappinVariant.ServicePointRipperdocVariant:
      return "ripperdoc";
    case gamedataMappinVariant.ServicePointTechVariant:
      return "tech";
    case gamedataMappinVariant.ServicePointJunkVariant:
      return "junk_shop";
    case gamedataMappinVariant.FastTravelVariant:
      return "fast_travel";
    case gamedataMappinVariant.EffectDropPointVariant:
      return "dropbox";
    case gamedataMappinVariant.ServicePointDropPointVariant:
      return "dropbox";
    case gamedataMappinVariant.VehicleVariant:
      return "car";
    case gamedataMappinVariant.GrenadeVariant:
      return "grenade";
    case gamedataMappinVariant.CustomPositionVariant:
      return "dynamic_event";
    case gamedataMappinVariant.InvalidVariant:
      return "invalid";
    case gamedataMappinVariant.SitVariant:
      return "Sit";
    case gamedataMappinVariant.GetInVariant:
      return "GetIn";
    case gamedataMappinVariant.GetUpVariant:
      return "GetUp";
    case gamedataMappinVariant.AllowVariant:
      return "Allow";
    case gamedataMappinVariant.BackOutVariant:
      return "BackOut";
    case gamedataMappinVariant.JackInVariant:
      return "JackIn";
    case gamedataMappinVariant.HitVariant:
      return "Hit";
    case gamedataMappinVariant.TakeDownVariant:
      return "TakeDown";
    case gamedataMappinVariant.NonLethalTakedownVariant:
      return "NonLethalTakedown";
    case gamedataMappinVariant.TakeControlVariant:
      return "TakeControl";
    case gamedataMappinVariant.OpenVendorVariant:
      return "OpenVendor";
    case gamedataMappinVariant.DistractVariant:
      return "Distract";
    case gamedataMappinVariant.ChangeToFriendlyVariant:
      return "ChangeToFriendly";
    case gamedataMappinVariant.GunSuicideVariant:
      return "GunSuicide";
    case gamedataMappinVariant.LifepathCorpoVariant:
      return "LifepathCorpo";
    case gamedataMappinVariant.LifepathNomadVariant:
      return "LifepathNomad";
    case gamedataMappinVariant.LifepathStreetKidVariant:
      return "LifepathStreetKid";
    case gamedataMappinVariant.AimVariant:
      return "Aim";
    case gamedataMappinVariant.JamWeaponVariant:
      return "JamWeapon";
    case gamedataMappinVariant.OffVariant:
      return "Off";
    case gamedataMappinVariant.UseVariant:
      return "Use";
    case gamedataMappinVariant.PhoneCallVariant:
      return "PhoneCall";
    case gamedataMappinVariant.SpeechVariant:
      return "talk";
    case gamedataMappinVariant.GPSPortalVariant:
      return "quest";
    case gamedataMappinVariant.FailedCrossingVariant:
      return "failed_crossing";
    case gamedataMappinVariant.TarotVariant:
      return "tarot_card";
    default:
      return "invalid";
  };
}

*/
