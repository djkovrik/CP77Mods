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

public class SwitchToNewOptionEvent extends Event {
  public let hubId: Int32;
  public let selectedIndex: Int32;
}

public class SwitchOpacityEvent extends Event {
  public let opacity: Float;
}

public class ValidationCallback extends DelayCallback {
  public let hubs: array<ListChoiceHubData>;
  public let dialogTree: wref<DialogTree>;
  public let uiSystem: wref<UISystem>;

	public func Call() -> Void {
    let switchEvent: ref<SwitchToNewOptionEvent> = new SwitchToNewOptionEvent();
    let opacityEvent: ref<SwitchOpacityEvent> = new SwitchOpacityEvent();
    let nextAvailableOption: ref<DialogOption>;

    this.dialogTree.Rebuild(this.hubs);

    if this.dialogTree.IsSelectedItemNotAvailable() {
      nextAvailableOption = this.dialogTree.GetNextAvailableOption();
      if nextAvailableOption.IsNotEmpty() {
        switchEvent.hubId = nextAvailableOption.hub;
        switchEvent.selectedIndex = nextAvailableOption.index;
        this.uiSystem.QueueEvent(switchEvent);
      };
    };

    if this.dialogTree.IsStateInvalid() {
      opacityEvent.opacity = 0.0;
    } else {
      opacityEvent.opacity = 1.0;
    };
    this.uiSystem.QueueEvent(opacityEvent);
	}
}

@addMethod(dialogWidgetGameController)
protected cb func OnSwitchToNewOptionEvent(evt: ref<SwitchToNewOptionEvent>) -> Bool {
  this.m_InteractionsBlackboard.SetInt(this.m_InteractionsBBDefinition.ActiveChoiceHubID, evt.hubId, true);
  this.m_InteractionsBlackboard.SetInt(this.m_InteractionsBBDefinition.SelectedIndex, evt.selectedIndex, true);
}

@addMethod(dialogWidgetGameController)
protected cb func OnSwitchOpacityEvent(evt: ref<SwitchOpacityEvent>) -> Bool {
  this.GetRootCompoundWidget().SetOpacity(evt.opacity);
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
  let validateCallback: ref<ValidationCallback> = new ValidationCallback();
  if this.m_activeHubID != -1 {
    this.m_delaySystem.CancelCallback(this.m_delayID);
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
  this.m_SelectedBg.SetOpacity(0.0);
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