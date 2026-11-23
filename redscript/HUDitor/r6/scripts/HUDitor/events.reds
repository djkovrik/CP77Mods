import HUDrag.HUDWidgetsManager.HUDWidgetsManager

public class HUDitorEditorStateEvent extends Event {
  public let listener: wref<HUDitorInputListener>;
  public let requestId: Uint32;
  public let open: Bool;
}

public class HUDitorBindEvent extends Event {
  public let manager: wref<HUDWidgetsManager>;
  public let requestId: Uint32;
}

public class SetActiveHUDEditorWidgetEvent extends Event {
  public let activeWidget: CName;
}

public class ScannerDetailsAppearedEvent extends Event {
  public let isVisible: Bool;
  public let isHackable: Bool;
}

public class HuditorSlotEvent extends Event {
  public let isVisible: Bool;
}

public class GameSessionInitializedEvent extends Event {}
public class DisableHUDEditorEvent extends Event {}
public class ResetAllHUDWidgetsEvent extends Event {}
public class DisplayPreviewEvent extends Event {}
public class HidePreviewEvent extends Event {}
public class HijackSlotsEvent extends Event {}
public class HuditorInitializedEvent extends Event {}
@if(ModuleExists("FpsCounter"))
public class ReparentFpsCounterEvent extends Event {}
