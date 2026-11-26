module CombatAwareness

@addField(scannerDetailsGameController)
private let caReadout: ref<inkText>;

@addField(scannerDetailsGameController)
private let caHint: ref<inkWidget>;

@addField(scannerDetailsGameController)
private let caHintKey: CName;

@addField(scannerDetailsGameController)
private let caHintParent: wref<inkCompoundWidget>;

@addField(scannerDetailsGameController)
private let caObserver: ref<ScannerObservation>;

@addField(scannerDetailsGameController)
private let caTimer: DelayID;

@addField(scannerDetailsGameController)
private let caSubject: EntityID;

@addField(scannerDetailsGameController)
private let caYaw: Float;

@addField(scannerDetailsGameController)
private let caLastText: String;

@addField(scannerDetailsGameController)
private let caReportSubject: EntityID;

@addField(scannerDetailsGameController)
private let caReportRevision: Int32;

@addField(scannerDetailsGameController)
private let caReported: Bool;

@wrapMethod(QuickhacksListGameController)
protected cb func OnInitialize() -> Bool {
  let result: Bool = wrappedMethod();
  AwarenessSystem.Get(this.m_gameInstance).scannerHintRow = 
    this.GetRootCompoundWidget().GetWidgetByPathName(n"input_container/input_hint") as inkCompoundWidget;

  return result;
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
  let result: Bool = wrappedMethod(player);
  if !IsDefined(this.caReadout) {
    let root = this.GetRootCompoundWidget();
    this.caReadout = AwarenessUI.Label(root, 0.0, 108.0, 30);
    // TODO: replace with MainColors binding
    this.caReadout.SetTintColor(HDRColor(0.65, 0.95, 1.0, 1.0));
    this.caReadout.SetVisible(false);
    this.caHint = this.SpawnFromExternal(root, r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"ButtonHintListItem");

    if IsDefined(this.caHint) {
      this.caHint.SetFitToContent(true);
      this.caHint.SetVisible(false);
    };
  }

  player.RegisterInputListener(this, n"CA_Study");
  this.CAObserve();
  return result;
}

@addMethod(scannerDetailsGameController)
protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
  player.UnregisterInputListener(this, n"CA_Study");
  GameInstance.GetDelaySystem(player.GetGame()).CancelCallback(this.caTimer);
  
  if IsDefined(this.caHint) {
    this.caHint.SetVisible(false);
    this.caHint.Reparent(this.GetRootCompoundWidget());
  };

  this.caHintParent = null;
  this.caHintKey = n"";
  this.caSubject = EntityID();
  this.caReportSubject = EntityID();
  this.caLastText = "";

  if IsDefined(this.caReadout) { 
    this.caReadout.SetVisible(false); 
  };
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnUnitialize() -> Bool {
  if IsDefined(this.caHintParent) { this.caHintParent.RemoveChild(this.caHint); };
  if IsDefined(this.m_player) {
    this.m_player.UnregisterInputListener(this, n"CA_Study");
    GameInstance.GetDelaySystem(this.m_player.GetGame()).CancelCallback(this.caTimer);
  };

  return wrappedMethod();
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnQuickHackPanelOpened(value: Bool) -> Bool {
  let result: Bool = wrappedMethod(value);
  this.CAObserve();
  return result;
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnScannedObjectTypeChanged(value: Int32) -> Bool {
  let result: Bool = wrappedMethod(value);
  this.CAObserve();
  return result;
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnScannedObjectChanged(value: EntityID) -> Bool {
  let result: Bool = wrappedMethod(value);
  this.CAObserve();
  return result;
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnScanningStateChanged(value: Variant) -> Bool {
  let result: Bool = wrappedMethod(value);
  this.CAObserve();
  return result;
}

@addMethod(scannerDetailsGameController)
private final func CACardTarget() -> ref<GameObject> {
  if !IsDefined(this.m_player) 
    || !IsDefined(this.m_scannedObject)
    || NotEquals(HUDManager.GetActiveMode(this.m_player.GetGame()), ActiveMode.FOCUS) { 
      return null; 
  };

  let bb = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
  if bb.GetEntityID(GetAllBlackboardDefs().UI_Scanner.ScannedObject) == this.m_scannedObject.GetEntityID() {
    return this.m_scannedObject;
  };

  return null;
}

@addMethod(scannerDetailsGameController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  if Equals(ListenerAction.GetName(action), n"CA_Study") && ListenerAction.IsButtonJustPressed(action) {
    let target = this.CACardTarget() as NPCPuppet;
    if Training.CanStudy(target, this.m_player) {
      let system = AwarenessSystem.Get(this.m_player.GetGame());
      system.ToggleStudy(target);
      if system.Ready(6) {
        QuickhackModule.RequestRefreshQuickhackMenu(this.m_player.GetGame(), target.GetEntityID());
      };
      this.CAObserve();
      return true;
    };
  }

  return false;
}

@addMethod(scannerDetailsGameController)
public final func CAObserve() -> Void {
  if !IsDefined(this.caReadout) || !IsDefined(this.m_player) { 
    return; 
  };
  
  let delays = GameInstance.GetDelaySystem(this.m_player.GetGame());
  delays.CancelCallback(this.caTimer);

  let text: String;
  let hint: CName;
  let previous = this.caSubject;
  let target = this.CACardTarget();

  if IsDefined(target) {
    this.caSubject = target.GetEntityID();
    let npc = target as NPCPuppet;
    let camera = target as SurveillanceCamera;
    let system = AwarenessSystem.Get(this.m_player.GetGame());
    let recon = system.Ready(0);

    if Training.CanStudy(npc, this.m_player) {
      let selected: Bool = system.studied == this.caSubject;
      hint = selected ? n"Mod-CombatAwareness-ClearStudy" : n"Mod-CombatAwareness-Study";
      if selected { 
        text = AwarenessUI.Text("Studied"); 
      };

      if recon {
        let link = npc.GetDeviceLink();
        let key = "Offline";
        if IsDefined(link) && link.IsConnected() && !link.AreOutgoingEventsSuppressed() {
          let net = link.GetSecuritySystem();
          if IsDefined(net) && !net.IsRestarting() && !net.IsUnpowered() && !net.IsDisabled() {
            key = StatusEffectSystem.ObjectHasStatusEffectWithTag(npc, n"CommsNoiseJam") ? "Jammed" : "Connected";
          };
        };

        if IsStringValid(text) { text += "  ·  "; };
        text += AwarenessUI.Text(key);
      };
    };

    if IsDefined(camera) && recon {
      let rotation = camera.GetRotationFromSlotRotation();
      let yaw = rotation.Yaw;
      if previous == this.caSubject {
        let delta = AngleNormalize180(yaw - this.caYaw);
        text = AwarenessUI.Text(AbsF(delta) < 0.15 ? "Stationary" : (delta > 0.0 ? "TurnLeft" : "TurnRight"));
      };
      this.caYaw = yaw;
    };

    if (IsDefined(npc) || IsDefined(camera)) && recon {
      if this.caReportSubject != this.caSubject || this.caReportRevision != system.reportRevision {
        this.caReportSubject = this.caSubject;
        this.caReportRevision = system.reportRevision;
        this.caReported = system.HasReport(this.caSubject);
      };
      if this.caReported {
        if IsStringValid(text) { text += "  ·  "; };
        text += AwarenessUI.Text("Sent");
      };
    };
    if IsDefined(npc) || IsDefined(camera) {
      if !IsDefined(this.caObserver) { this.caObserver = new ScannerObservation(); this.caObserver.hud = this; };
      this.caTimer = delays.DelayCallback(this.caObserver, 0.4);
    };
  } else {
    this.caSubject = EntityID();
  };

  if NotEquals(text, this.caLastText) {
    this.caLastText = text;
    this.caReadout.SetText(text);
  };

  this.caReadout.SetVisible(IsStringValid(text));
  this.CAUpdateHint(hint);
}


@addMethod(scannerDetailsGameController)
private final func CAUpdateHint(key: CName) -> Void {
  if !IsDefined(this.caHint) { 
    return; 
  };
  if NotEquals(this.caHintKey, key) {
    this.caHintKey = key;
    this.caHint.SetVisible(IsNameValid(key));
    if IsNameValid(key) {
      (this.caHint.GetController() as ButtonHintListItem).SetData(n"CA_Study", GetLocalizedTextByKey(key));
    };
  };
  if !IsNameValid(key) { 
    return; 
  };

  let root: wref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let panel: wref<inkCompoundWidget> = this.m_isQuickHackPanelOpened ? AwarenessSystem.Get(this.m_player.GetGame()).scannerHintRow : null;
  let parent: wref<inkCompoundWidget> = IsDefined(panel) ? panel : root;
  if (this.caHintParent == parent){ 
    return; 
  };

  this.caHintParent = parent;

  if this.caHint.GetParentWidget() != parent { 
    this.caHint.Reparent(parent); 
  };

  if IsDefined(panel) {
    this.caHint.SetAnchor(inkEAnchor.TopLeft);
    this.caHint.SetAnchorPoint(Vector2(0.0, 0.0));
    this.caHint.SetTranslation(Vector2(0.0, 0.0));
  } else {
    this.caHint.SetAnchor(inkEAnchor.Centered);
    this.caHint.SetAnchorPoint(Vector2(0.5, 0.5));
    this.caHint.SetTranslation(Vector2(0.0, 162.0));
  };
}
