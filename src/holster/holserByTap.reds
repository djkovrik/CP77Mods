@replaceMethod(UpperBodyEventsTransition)
protected final func UpdateSwitchItem(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let notificationEvent: ref<UIInGameNotificationEvent>;
  let holsterDelay: Float;
  holsterDelay = 0.25;
  notificationEvent = new UIInGameNotificationEvent();
  notificationEvent.m_notificationType = UIInGameNotificationType.ActionRestriction;
  if PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"FirearmsNoSwitch") || PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"ShootingRangeCompetition") || PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"Fists") || stateContext.IsStateMachineActive(n"Consumable") || stateContext.IsStateMachineActive(n"CombatGadget") || this.CheckEquipmentStateMachineState(stateContext, EEquipmentSide.Right, EEquipmentState.Equipping) {
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
  if scriptInterface.IsActionJustPressed(n"NextWeapon") && !this.m_cyclePushed && !this.m_switchPending && DefaultTransition.HasRightWeaponEquipped(scriptInterface) && this.CheckEquipmentStateMachineState(stateContext, EEquipmentSide.Right, EEquipmentState.Equipped) {
    this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.CycleNextWeaponWheelItem);
    this.m_cyclePushed = true;
    stateContext.SetPermanentBoolParameter(n"cyclePushed", this.m_cyclePushed, true);
    return true;
  };
  if scriptInterface.IsActionJustPressed(n"PreviousWeapon") && !this.m_cyclePushed && !this.m_switchPending && DefaultTransition.HasRightWeaponEquipped(scriptInterface) && this.CheckEquipmentStateMachineState(stateContext, EEquipmentSide.Right, EEquipmentState.Equipped) {
    this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.CyclePreviousWeaponWheelItem);
    this.m_cyclePushed = true;
    stateContext.SetPermanentBoolParameter(n"cyclePushed", this.m_cyclePushed, true);
    return true;
  };
  if scriptInterface.IsActionJustTapped(n"SwitchItem") && !this.m_cyclePushed {
    this.m_switchButtonPushed = true;
    this.m_counter += 1;
  };
  if this.m_switchButtonPushed {
    if !PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"FirearmsNoUnequip") {
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
    //     if this.m_counter > 1 && EquipmentSystem.GetData(scriptInterface.executionOwner).CycleWeapon(true, true) == ItemID.undefined() && !PlayerGameplayRestrictions.HasRestriction(scriptInterface.executionOwner, n"FirearmsNoUnequip") {
    //       this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.UnequipWeapon);
    //     };
    //   };
    //   this.ResetEquipVars(stateContext);
    // };
    return true;
  };
  return false;
}
