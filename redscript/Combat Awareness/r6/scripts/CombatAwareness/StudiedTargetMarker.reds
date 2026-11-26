module CombatAwareness

@addField(NPCPuppet)
private let caStudyMarker: NewMappinID;

class StudiedMarkerData extends MappinScriptData {}

@addField(QuestMappinController)
private let caStudyDot: ref<inkCircle>;

@wrapMethod(QuestMappinController)
protected cb func OnIntro() -> Bool {
  let result = wrappedMethod();
  let studied = IsDefined(this.m_mappin.GetScriptData() as StudiedMarkerData);
  if !studied && !IsDefined(this.caStudyDot) { return result; };
  let art = this.GetWidget(n"Canvas");
  let arrow = this.GetWidget(n"Arrow");
  if !IsDefined(art) || !IsDefined(arrow) { return result; };
  art.SetOpacity(studied ? 0.0 : 1.0);
  arrow.SetOpacity(studied ? 0.0 : 1.0);
  if !IsDefined(this.caStudyDot) {
    this.caStudyDot = new inkCircle();
    this.caStudyDot.SetSize(14.0, 14.0);
    this.caStudyDot.SetAnchor(inkEAnchor.Centered);
    this.caStudyDot.SetAnchorPoint(Vector2(0.5, 0.5));
    this.caStudyDot.SetTranslation(Vector2(27.0, -14.0));
    // TODO: replace with MainColors binding
    this.caStudyDot.SetTintColor(HDRColor(0.30, 0.95, 1.0, 1.0));
    this.caStudyDot.Reparent(this.m_root);
  };
  this.caStudyDot.SetVisible(studied);
  return result;
}

@addMethod(NPCPuppet)
public final func CAHideStudyMarker() -> Void {
  if this.caStudyMarker.value != 0ul {
    GameInstance.GetMappinSystem(this.GetGame()).UnregisterMappin(this.caStudyMarker);
    this.caStudyMarker.value = 0ul;
  };
}

@addMethod(NPCPuppet)
public final func CAShowStudyMarker() -> Void {
  if this.caStudyMarker.value != 0ul || !this.IsActive() { return; };
  let data: MappinData;
  data.mappinType = t"CombatAwareness.StudiedTargetMappin";
  data.variant = gamedataMappinVariant.AimVariant;
  data.active = true;
  data.scriptData = new StudiedMarkerData();
  data.visibleThroughWalls = false;
  this.caStudyMarker = GameInstance.GetMappinSystem(this.GetGame())
    .RegisterMappinWithObject(
      data, 
      this, 
      this.GetQuickHackIndicatorSlotName(), 
      Vector3(0.0, 0.0, 0.35)
    );
}

@wrapMethod(NPCPuppet)
protected cb func OnGameAttached() -> Bool {
  let result = wrappedMethod();
  let system = AwarenessSystem.Get(this.GetGame());
  if IsDefined(system) && system.studied == this.GetEntityID() {
    this.CAShowStudyMarker();
  };
  return result;
}

@wrapMethod(NPCPuppet)
protected cb func OnDetach() -> Bool {
  this.CAHideStudyMarker();
  return wrappedMethod();
}

@wrapMethod(NPCPuppet)
protected func OnIncapacitated() -> Void {
  this.CAHideStudyMarker();
  wrappedMethod();
}

@wrapMethod(NPCPuppet)
protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
  this.CAHideStudyMarker();
  return wrappedMethod(evt);
}
