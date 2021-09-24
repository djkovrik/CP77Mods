@wrapMethod(UpperBodyEventsTransition)
protected final func UpdateSwitchItem(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if scriptInterface.IsActionJustHeld(n"Reload") 
      && !StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"FirearmsNoUnequip") {
    this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.UnequipWeapon);
    this.ResetEquipVars(stateContext);
    return true;
  };
  wrappedMethod(timeDelta, stateContext, scriptInterface);
}
