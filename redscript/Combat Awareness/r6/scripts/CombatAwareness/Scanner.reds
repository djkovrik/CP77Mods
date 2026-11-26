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
private let caSubject: EntityID;

@addField(scannerDetailsGameController)
private let caLastText: String;

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
  
  if IsDefined(this.caHint) {
    this.caHint.SetVisible(false);
    this.caHint.Reparent(this.GetRootCompoundWidget());
  };

  this.caHintParent = null;
  this.caHintKey = n"";
  this.caSubject = EntityID();
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

  let text: String;
  let hint: CName;
  let target = this.CACardTarget();
  if IsDefined(target) {
    this.caSubject = target.GetEntityID();
    let npc = target as NPCPuppet;
    let system = AwarenessSystem.Get(this.m_player.GetGame());
    
    if Training.CanStudy(npc, this.m_player) {
      let selected: Bool = system.studied == this.caSubject;
      hint = selected ? n"Mod-CombatAwareness-ClearStudy" : n"Mod-CombatAwareness-Study";
      if selected { 
        text = AwarenessUI.Text("Studied"); 
      };
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
