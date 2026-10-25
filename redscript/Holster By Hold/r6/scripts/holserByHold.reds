@wrapMethod(UpperBodyEventsTransition)
protected final func UpdateSwitchItem(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  // A handled Reload hold consumes this input; all other input follows the wrapper chain.
  if scriptInterface.IsActionJustHeld(n"Reload") && !stateContext.GetBoolParameter(n"UnequipToGadgetOrConsumable", true) {
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
