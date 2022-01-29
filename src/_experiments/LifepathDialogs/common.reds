public class SwitchToNewOptionEvent extends Event {
  public let hubId: Int32;
  public let selectedIndex: Int32;
  public let movesDown: Bool;
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
    let nextAvailableOption: ref<DialogOption>;

    this.dialogTree.Rebuild(this.hubs);

    if this.dialogTree.IsSelectedItemNotAvailable() {
      nextAvailableOption = this.dialogTree.GetNextAvailableOption();
      // Move to next option on HUD
      if nextAvailableOption.IsNotEmpty() {
        switchEvent.hubId = nextAvailableOption.hub;
        switchEvent.selectedIndex = nextAvailableOption.index;
        switchEvent.movesDown = nextAvailableOption.movesDown;
        this.uiSystem.QueueEvent(switchEvent);
      };
    };

    let opacityEvent: ref<SwitchOpacityEvent> = new SwitchOpacityEvent();
    if this.dialogTree.IsStateInvalid() {
      opacityEvent.opacity = 0.0;
    } else {
      opacityEvent.opacity = 1.0;
    };
    this.uiSystem.QueueEvent(opacityEvent);
	}
}

public class MoveUpCallback extends DelayCallback {
  public func Call() -> Void {
    MoveNativeSelectionUp();
  }
}

public class MoveDownCallback extends DelayCallback {
  public func Call() -> Void {
    MoveNativeSelectionDown();
  }
}

public static native func MoveNativeSelectionUp() -> Void

public static native func MoveNativeSelectionDown() -> Void
