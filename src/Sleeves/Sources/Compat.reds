@if(ModuleExists("EquipmentEx"))
import EquipmentEx.OutfitSystem

@if(!ModuleExists("EquipmentEx"))
public static func GetSleevesInfo(player: ref<GameObject>) -> ref<SleevesInfoBundle> {
  let system: ref<SleevesStateSystem> = SleevesStateSystem.Get(player.GetGame());
  return system.GetBasicSlotsItems(player, false);
}

@if(ModuleExists("EquipmentEx"))
public static func GetSleevesInfo(player: ref<GameObject>) -> ref<SleevesInfoBundle> {
  let sleevesSystem: ref<SleevesStateSystem> = SleevesStateSystem.Get(player.GetGame());
  let outfitSystem: ref<OutfitSystem> = OutfitSystem.GetInstance(player.GetGame());
  if outfitSystem.IsActive() {
    return sleevesSystem.GetEquipmentExSlotsItems(player);
  };
  return sleevesSystem.GetBasicSlotsItems(player, true);
}

@if(!ModuleExists("EquipmentEx"))
public static func IsSlotOccupiedCustom(gi: GameInstance, slot: TweakDBID) -> Bool {
  return false;
}

@if(ModuleExists("EquipmentEx"))
public static func IsSlotOccupiedCustom(gi: GameInstance, slot: TweakDBID) -> Bool {
  return OutfitSystem.GetInstance(gi).IsOccupied(slot);
}
