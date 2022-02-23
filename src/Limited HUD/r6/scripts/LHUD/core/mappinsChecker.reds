module LimitedHudMappinChecker

public class MappinChecker {
  public static func IsQuestIcon(mappin: wref<IMappin>) -> Bool {
    let variant: gamedataMappinVariant = mappin.GetVariant();

    return 
         Equals(variant, gamedataMappinVariant.ActionDealDamageVariant) 
      || Equals(variant, gamedataMappinVariant.ConversationVariant)
      || Equals(variant, gamedataMappinVariant.DefaultVariant)
      || Equals(variant, gamedataMappinVariant.DefaultQuestVariant)
      || Equals(variant, gamedataMappinVariant.DefaultInteractionVariant)
      || Equals(variant, gamedataMappinVariant.QuestGiverVariant)
      || Equals(variant, gamedataMappinVariant.MinorActivityVariant)
      || Equals(variant, gamedataMappinVariant.Zzz06_NCPDGigVariant)
      || Equals(variant, gamedataMappinVariant.ExclamationMarkVariant)
      || Equals(variant, gamedataMappinVariant.RetrievingVariant)
      || Equals(variant, gamedataMappinVariant.ThieveryVariant)
      || Equals(variant, gamedataMappinVariant.SabotageVariant)
      || Equals(variant, gamedataMappinVariant.ClientInDistressVariant)
      || Equals(variant, gamedataMappinVariant.BountyHuntVariant)
      || Equals(variant, gamedataMappinVariant.CourierVariant)
      || Equals(variant, gamedataMappinVariant.GangWatchVariant)
      || Equals(variant, gamedataMappinVariant.OutpostVariant)
      || Equals(variant, gamedataMappinVariant.HiddenStashVariant)
      || Equals(variant, gamedataMappinVariant.HuntForPsychoVariant)
      || Equals(variant, gamedataMappinVariant.SmugglersDenVariant)
      || Equals(variant, gamedataMappinVariant.WanderingMerchantVariant)
      || Equals(variant, gamedataMappinVariant.ConvoyVariant)
      || Equals(variant, gamedataMappinVariant.FixerVariant)
      || Equals(variant, gamedataMappinVariant.ApartmentVariant)
      || Equals(variant, gamedataMappinVariant.Zzz01_CarForPurchaseVariant)
      || Equals(variant, gamedataMappinVariant.Zzz02_MotorcycleForPurchaseVariant)
      || Equals(variant, gamedataMappinVariant.Zzz04_PreventionVehicleVariant)
      || Equals(variant, gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant)
      || Equals(variant, gamedataMappinVariant.GPSPortalVariant)
      || Equals(variant, gamedataMappinVariant.PhoneCallVariant)
      || Equals(variant, gamedataMappinVariant.TarotVariant)
      || Equals(variant, gamedataMappinVariant.FocusClueVariant)
      || false;
  }

  public static func IsVehicleIcon(mappin: wref<IMappin>) -> Bool {
    let variant: gamedataMappinVariant = mappin.GetVariant();

    return 
      Equals(variant, gamedataMappinVariant.VehicleVariant) 
      || Equals(variant, gamedataMappinVariant.Zzz03_MotorcycleVariant)
      || false;
  }

  public static func IsPlaceOfInterestIcon(mappin: wref<IMappin>) -> Bool {
    let variant: gamedataMappinVariant = mappin.GetVariant();

    return 
         Equals(variant, gamedataMappinVariant.FastTravelVariant) 
      || Equals(variant, gamedataMappinVariant.DropboxVariant)
      || Equals(variant, gamedataMappinVariant.ApartmentVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointClothesVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointFoodVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointBarVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointGunsVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointMedsVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointMeleeTrainerVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointNetTrainerVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointProstituteVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointRipperdocVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointTechVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointJunkVariant)
      || Equals(variant, gamedataMappinVariant.EffectDropPointVariant)
      || Equals(variant, gamedataMappinVariant.ServicePointDropPointVariant)
      || Equals(variant, gamedataMappinVariant.CustomPositionVariant)
      || false;
  }

  public static func IsLootMarker(mappin: wref<IMappin>) -> Bool {
    let variant: gamedataMappinVariant = mappin.GetVariant();
    let data: ref<GameplayRoleMappinData> = mappin.GetScriptData() as GameplayRoleMappinData;

    if Equals(data.m_textureID, t"MappinIcons.ShardMappin") {
      return true;
    };

    return 
       Equals(variant, gamedataMappinVariant.LootVariant) 
    || Equals(variant, gamedataMappinVariant.NPCVariant)
    || Equals(data.m_gameplayRole, EGameplayRole.Loot)
    || false;
  }

  public static func IsCombatMarker(mappin: wref<IMappin>) -> Bool {
    let variant: gamedataMappinVariant = mappin.GetVariant();

    return 
       Equals(variant, gamedataMappinVariant.GrenadeVariant) 
    || false;
  }

  public static func IsDeviceInteraction(mappin: wref<IMappin>) -> Bool {
    let variant: gamedataMappinVariant = mappin.GetVariant();
    let data: ref<GameplayRoleMappinData> = mappin.GetScriptData() as GameplayRoleMappinData;
    let role: EGameplayRole = data.m_gameplayRole;


    return 
       Equals(role, EGameplayRole.Alarm)
    || Equals(role, EGameplayRole.ControlNetwork)
    || Equals(role, EGameplayRole.ControlOtherDevice)
    || Equals(role, EGameplayRole.ControlSelf)
    || Equals(role, EGameplayRole.CutPower)
    || Equals(role, EGameplayRole.Distract)
    || Equals(role, EGameplayRole.ExplodeLethal)
    || Equals(role, EGameplayRole.ExplodeNoneLethal)
    || Equals(role, EGameplayRole.Fall)
    || Equals(role, EGameplayRole.GrantInformation)
    || Equals(role, EGameplayRole.HideBody)
    || Equals(role, EGameplayRole.OpenPath)
    || Equals(role, EGameplayRole.ClearPath)
    || Equals(role, EGameplayRole.DistractVendingMachine)
    || false;
  }

  public static func IsTracked(mappin: wref<IMappin>) -> Bool {
    return mappin.IsPlayerTracked();
  }
}
