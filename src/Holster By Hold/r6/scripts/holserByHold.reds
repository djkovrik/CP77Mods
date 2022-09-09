@wrapMethod(UpperBodyEventsTransition)
protected final func UpdateSwitchItem(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if scriptInterface.IsActionJustHeld(n"Reload") {
    if !StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"FirearmsNoUnequip") && (
      DefaultTransition.IsHeavyWeaponEquipped(scriptInterface) || DefaultTransition.HasMeleeWeaponEquipped(scriptInterface) || DefaultTransition.IsRangedWeaponEquipped(scriptInterface)  || DefaultTransition.HasRightWeaponEquipped(scriptInterface)
    ) {
      this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.UnequipWeapon);
      this.ResetEquipVars(stateContext);
      return true;
    } else {
      this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.RequestLastUsedOrFirstAvailableWeapon);
      this.ResetEquipVars(stateContext);
      return true;
    };
  };

  return wrappedMethod(timeDelta, stateContext, scriptInterface);
}
