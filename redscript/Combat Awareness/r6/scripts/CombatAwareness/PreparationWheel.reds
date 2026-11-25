module CombatAwareness

@addField(RadialWheelController)
public let caPanel: ref<PreparationPanel>;

@addField(PlayerPuppet)
public let caEditing: Bool;

@wrapMethod(RadialWheelController)
protected cb func OnInitialize() -> Bool {
  let result: Bool = wrappedMethod();
  this.GetPlayerControlledObject().RegisterInputListener(this, n"CA_Prepare");
  return result;
}

@wrapMethod(RadialWheelController)
protected cb func OnOpenWheelRequest(evt: ref<QuickSlotButtonHoldStartEvent>) -> Bool {
  let result: Bool = wrappedMethod(evt);

  if this.isActive {
    let hint: InputHintData;
    this.CacheInputHintData(hint, n"CA_Prepare", n"CombatAwareness", 9, 9, AwarenessUI.Text("Prepare"));
    this.AddInputHint(hint, true);
    let bb = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_PlayerBioMonitor);
    bb.SignalVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.BuffsList);
  };
  
  return result;
}

@wrapMethod(RadialWheelController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let name: CName = ListenerAction.GetName(action);
  let pressed: Bool = ListenerAction.IsButtonJustPressed(action);

  if this.isActive && Equals(name, n"CA_Prepare") && pressed {
    let system = AwarenessSystem.Get(this.playerPuppet.GetGame());
    if IsDefined(this.caPanel) {
      let draft = this.caPanel.draft;
      this.Shutdown();
      system.Confirm(draft);
    } else {
      this.playerPuppet.caEditing = true;
      this.caPanel = new PreparationPanel();
      this.caPanel.Init(this.GetRootCompoundWidget());
      this.caPanel.draft = system.layout;
      this.caPanel.Refresh(system);
    };

    return true;
  };

  if IsDefined(this.caPanel) {
    if Equals(name, n"SelectWheelItem") && pressed {
      let mask = this.caPanel.draft ^ Training.Bit(this.caPanel.selected);
      if Training.Total(mask) <= Training.Budget() {
        this.caPanel.draft = mask;
        this.caPanel.Refresh(AwarenessSystem.Get(this.playerPuppet.GetGame()));
      };
    };

    if (Equals(name, n"CloseWheel") && ListenerAction.IsButtonJustReleased(action)) || (Equals(name, n"OpenPauseMenu") && pressed) {
      this.Shutdown();
    };

    return true;
  }

  return wrappedMethod(action, consumer);
}

// handle rotation
@wrapMethod(RadialWheelController)
protected cb func OnRadialAngleChanged(v: Vector4) -> Bool {
  if IsDefined(this.caPanel) {
    let degrees = this.ConvertVectorToAngle(v);

    if degrees >= 0.0 {
      let slot = FloorF(degrees * 7.0 / 360.0 + 0.5) % 7;
      if slot != this.caPanel.selected {
        this.caPanel.selected = slot;
        this.caPanel.Refresh(AwarenessSystem.Get(this.playerPuppet.GetGame()));
      };
    };

    return true;
  };

  return wrappedMethod(v);
}

@wrapMethod(RadialWheelController)
private final func Shutdown() -> Void {
  if IsDefined(this.caPanel) {
    this.caPanel.Close(this.GetRootCompoundWidget());
    this.caPanel = null;
    this.playerPuppet.caEditing = false;
  };

  wrappedMethod();
}

@wrapMethod(QuickSlotsHoldDecisions)
public const func ToQuickSlotsBusy(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  if (scriptInterface.executionOwner as PlayerPuppet).caEditing { 
    return false; 
  };

  return wrappedMethod(stateContext, scriptInterface);
}
