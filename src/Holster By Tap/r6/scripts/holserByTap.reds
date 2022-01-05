@replaceMethod(UpperBodyEventsTransition)
protected final func UpdateSwitchItem(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let holsterDelay: Float = 0.25;
  let nextWeaponJustPressed: Bool = scriptInterface.IsActionJustPressed(n"NextWeapon");
  let previousWeaponJustPressed: Bool = scriptInterface.IsActionJustPressed(n"PreviousWeapon");
  let switchItemJustTapped: Bool = scriptInterface.IsActionJustTapped(n"SwitchItem");
  if !this.m_switchButtonPushed && !this.m_cyclePushed && !nextWeaponJustPressed && !previousWeaponJustPressed && !switchItemJustTapped {
    return false;
  };
  if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"FirearmsNoSwitch") || StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"ShootingRangeCompetition") || StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"Fists") || stateContext.IsStateMachineActive(n"Consumable") || stateContext.IsStateMachineActive(n"CombatGadget") || this.CheckEquipmentStateMachineState(stateContext, EEquipmentSide.Right, EEquipmentState.Equipping) {
    return false;
  };
  if this.m_cyclePushed {
    this.m_cycleBlock += timeDelta;
    if this.m_cycleBlock > 0.50 {
      this.m_cycleBlock = 0.00;
      this.m_cyclePushed = false;
      stateContext.SetPermanentBoolParameter(n"cyclePushed", this.m_cyclePushed, true);
    };
  };
  if nextWeaponJustPressed && !this.m_cyclePushed && !this.m_switchPending && DefaultTransition.HasRightWeaponEquipped(scriptInterface) && this.CheckEquipmentStateMachineState(stateContext, EEquipmentSide.Right, EEquipmentState.Equipped) {
    this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.CycleNextWeaponWheelItem);
    this.m_cyclePushed = true;
    stateContext.SetPermanentBoolParameter(n"cyclePushed", this.m_cyclePushed, true);
    return true;
  };
  if previousWeaponJustPressed && !this.m_cyclePushed && !this.m_switchPending && DefaultTransition.HasRightWeaponEquipped(scriptInterface) && this.CheckEquipmentStateMachineState(stateContext, EEquipmentSide.Right, EEquipmentState.Equipped) {
    this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.CyclePreviousWeaponWheelItem);
    this.m_cyclePushed = true;
    stateContext.SetPermanentBoolParameter(n"cyclePushed", this.m_cyclePushed, true);
    return true;
  };
  if switchItemJustTapped && !this.m_cyclePushed {
    this.m_switchButtonPushed = true;
    this.m_counter += 1;
  };
  if this.m_switchButtonPushed {
    if !StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"FirearmsNoUnequip") {
      this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.UnequipWeapon);
      this.ResetEquipVars(stateContext);
    };
    // this.m_delay += timeDelta;
    // if this.m_delay < holsterDelay && this.m_switchButtonPushed && !this.m_switchPending {
    //   if EquipmentSystem.GetData(scriptInterface.executionOwner).CycleWeapon(true, true) != ItemID.undefined() {
    //     this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.UnequipWeapon);
    //     this.m_switchPending = true;
    //   };
    //   return false;
    // };
    // if this.m_delay >= holsterDelay {
    //   if this.m_counter == 1 {
    //     this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.CycleNextWeaponWheelItem);
    //   } else {
    //     if this.m_counter > 1 && EquipmentSystem.GetData(scriptInterface.executionOwner).CycleWeapon(true, true) == ItemID.undefined() && !StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"FirearmsNoUnequip") {
    //       this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.UnequipWeapon);
    //     };
    //   };
    //   this.ResetEquipVars(stateContext);
    // };
    return true;
  };
  return false;
}
