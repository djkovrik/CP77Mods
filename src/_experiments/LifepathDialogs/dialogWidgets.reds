@addField(dialogWidgetGameController)
private let m_dialogTree: ref<DialogTree>;

@addField(dialogWidgetGameController)
private let m_delaySystem: ref<DelaySystem>;

@addField(dialogWidgetGameController)
private let m_uiSystem: ref<UISystem>;

@addField(dialogWidgetGameController)
private let m_delayID: DelayID;

@wrapMethod(dialogWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.m_dialogTree = new DialogTree();
  this.m_dialogTree.Init();
  this.m_delaySystem = GameInstance.GetDelaySystem(this.GetPlayerControlledObject().GetGame());
  this.m_uiSystem = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());
}

@wrapMethod(dialogWidgetGameController)
protected func OnInteractionsChanged() -> Void {
  wrappedMethod();
  this.m_dialogTree.SetCurrentSelectedHub(this.m_activeHubID);
  this.m_dialogTree.SetCurrentSelectedIndex(this.m_selectedIndex);
  this.ScheduleValidation();
}

@addMethod(dialogWidgetGameController)
private func ScheduleValidation() -> Void {
  let validateCallback: ref<ValidationCallback>;
  if this.m_activeHubID != -1 {
    this.m_delaySystem.CancelCallback(this.m_delayID);
    validateCallback = new ValidationCallback();
    validateCallback.hubs = this.m_data.choiceHubs;
    validateCallback.dialogTree = this.m_dialogTree;
    validateCallback.uiSystem = this.m_uiSystem;
    this.m_delayID = this.m_delaySystem.DelayCallback(validateCallback, 0);
  };
}

@wrapMethod(CaptionImageIconsLogicController)
public final func SetLifePath(argData: ref<LifePathBluelinePart>) -> Void {
  wrappedMethod(argData);
  if argData.additionalData {
    this.GetRootWidget().SetOpacity(BlockedOptionConfig.IconOpacity());
  };
}

@addMethod(DialogChoiceLogicController)
public final func SetDimmed() -> Void {
  let opacity: Float = BlockedOptionConfig.TextOpacity();
  inkWidgetRef.SetOpacity(this.m_ActiveTextRef, opacity);
  inkWidgetRef.SetOpacity(this.m_InActiveTextRef, opacity);
  this.m_SelectedBg.SetOpacity(BlockedOptionConfig.TextOpacity());
}

@wrapMethod(DialogHubLogicController)
private final func UpdateDialogHubData() -> Void {
  wrappedMethod();
  let modCurrentItem: wref<DialogChoiceLogicController>;
  let modChoiceData: ListChoiceData;
  let j: Int32 = 0;
  while j < ArraySize(this.m_data.choices) {
    modCurrentItem = this.m_itemControllers[j];
    modChoiceData = this.m_data.choices[j];
    if DialogTree.HasBlockedLifepath(modChoiceData.captionParts.parts) {
      modCurrentItem.SetDimmed();
    };
    j += 1;
  };
}

@addMethod(dialogWidgetGameController)
protected cb func OnSwitchToNewOptionEvent(evt: ref<SwitchToNewOptionEvent>) -> Bool {
  this.m_InteractionsBlackboard.SetInt(this.m_InteractionsBBDefinition.ActiveChoiceHubID, evt.hubId, true);
  this.m_InteractionsBlackboard.SetInt(this.m_InteractionsBBDefinition.SelectedIndex, evt.selectedIndex, true);
  if evt.movesDown {
    this.m_delaySystem.DelayCallback(new MoveDownCallback(), 0.1);
  } else {
    this.m_delaySystem.DelayCallback(new MoveUpCallback(), 0.1);
  };
}

@addMethod(dialogWidgetGameController)
protected cb func OnSwitchOpacityEvent(evt: ref<SwitchOpacityEvent>) -> Bool {
  this.GetRootCompoundWidget().SetOpacity(evt.opacity);
}