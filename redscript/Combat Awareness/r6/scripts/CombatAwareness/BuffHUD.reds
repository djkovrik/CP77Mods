module CombatAwareness

@addField(SingleCooldownManager)
public let caReadinessRow: Bool;

@addField(inkCooldownGameController)
private let caRows: array<wref<SingleCooldownManager>>;

@addField(inkCooldownGameController)
private let caSeen: Int32;

@addField(inkCooldownGameController)
private let caVisible: Int32;

@wrapMethod(buffListItemLogicController)
private final func SetTimeText(f: Float) -> Void {
  if f > 0.0 && IsDefined(this.m_statusEffectRecord) && this.m_statusEffectRecord.GetID() == Training.ReactionWindow() {
    wrappedMethod(Cast<Float>(CeilF(f)));
  } else {
    wrappedMethod(f);
  };
}

@wrapMethod(inkCooldownGameController)
public final func RequestCooldownVisualization(buffData: UIBuffInfo) -> Void {
  let slot = Training.Slot(buffData.buffID);
  if slot < 0 || this.m_maxCooldowns <= 0 || NotEquals(this.m_mode, ECooldownGameControllerMode.BUFFS_AND_DEBUFFS) {
    wrappedMethod(buffData);
    return;
  };

  let bit = Training.Bit(slot);
  this.caSeen = this.caSeen | bit;

  if (this.caVisible & bit) != 0 {
    if slot == 1 {
      let current = this.caRows[slot];
      if !current.IsIDMatch(buffData.buffID) {
        current.RemoveCooldown();
        current.ActivateCooldown(buffData);
      } else {
        if buffData.buffID == Training.ReactionWindow() { 
          current.CAUpdateReactionTime(buffData.timeRemaining);
        };
      };
    };
    return;
  };

  if ArraySize(this.caRows) == 0 { 
    ArrayResize(this.caRows, 7); 
  };

  let row = this.caRows[slot];
  if !IsDefined(row) {
    let widget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_poolHolder), n"SingleCooldownBar");
    if !IsDefined(widget) { 
      return; 
    }
    row = widget.GetController() as SingleCooldownManager;
    if !IsDefined(row) { 
      return; 
    }
    widget.SetVAlign(inkEVerticalAlign.Top);
    widget.SetHAlign(inkEHorizontalAlign.Left);
    row.Init(this.m_poolHolder, this.m_cooldownContainer);
    row.caReadinessRow = true;
    this.caRows[slot] = row;
  };

  row.ActivateCooldown(buffData);
  this.caVisible = this.caVisible | bit;
}

@wrapMethod(inkCooldownGameController)
protected cb func OnEffectUpdate(v: Variant) -> Bool {
  this.caSeen = 0;
  let result = wrappedMethod(v);

  if this.caVisible != this.caSeen {
    let i = 0;
    while i < ArraySize(this.caRows) {
      let bit = Training.Bit(i);
      if (this.caVisible & bit) != 0 && (this.caSeen & bit) == 0 {
        this.caRows[i].RemoveCooldown();
        this.caVisible = this.caVisible ^ bit;
      };
      i += 1;
    };
  };

  return result;
}

@wrapMethod(SingleCooldownManager)
private final func FillOutroAnimationStart() -> Void {
  if this.caReadinessRow {
    this.FillIntroAnimationStart();
    return;
  };

  wrappedMethod();
}

@wrapMethod(SingleCooldownManager)
private final func SetTimeRemaining(time: Float) -> Void {
  if this.caReadinessRow {
    if this.IsIDMatch(Training.ReactionWindow()) { this.CAUpdateReactionTime(time); }
    else { inkTextRef.SetText(this.m_timeRemaining, ""); };
    return;
  };
  
  wrappedMethod(time);
}

@addMethod(SingleCooldownManager)
public final func CAUpdateReactionTime(time: Float) -> Void {
  inkTextRef.SetText(this.m_timeRemaining, IntToString(CeilF(MaxF(time, 0.0))));
}
