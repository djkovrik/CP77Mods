@wrapMethod(PhotoModePlayerEntityComponent)
private final func SetupInventory(isCurrentPlayerObjectCustomizable: Bool) -> Void {
  wrappedMethod(isCurrentPlayerObjectCustomizable);
  let wardrobeSystemExtra: ref<WardrobeSystemExtra> = WardrobeSystemExtra.GetInstance(this.mainPuppet.GetGame());
  wardrobeSystemExtra.SetPhotoModeExtraSelectorActive(false);
}

@replaceMethod(PhotoModePlayerEntityComponent)
public final func SwitchWardrobeSet(wardrobeSet: Int32) -> Void {
  let wardrobeSystemExtra: ref<WardrobeSystemExtra> = WardrobeSystemExtra.GetInstance(this.mainPuppet.GetGame());
  let playerData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(this.mainPuppet);
  let wardrobeSetExtra: gameWardrobeClothingSetIndexExtra = wardrobeSystemExtra.GetPhotoModeSelectedSetIndex();
  if Equals(wardrobeSetExtra, gameWardrobeClothingSetIndexExtra.INVALID) {
    playerData.UnequipWardrobeSetExtra();
  } else {
    playerData.EquipWardrobeSetExtra(wardrobeSetExtra);
  };
}
