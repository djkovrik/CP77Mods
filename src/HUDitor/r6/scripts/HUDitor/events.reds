public class SetActiveHUDEditorWidgetEvent extends Event {
  public let activeWidget: CName;
}

public class ScannerDetailsAppearedEvent extends Event {
  public let isVisible: Bool;
  public let isHackable: Bool;
}

public class GameSessionInitializedEvent extends Event {}
public class DisableHUDEditorEvent extends Event {}
public class ResetAllHUDWidgetsEvent extends Event {}
public class DisplayPreviewEvent extends Event {}
public class HidePreviewEvent extends Event {}
public class HijackSlotsEvent extends Event {}
public class HuditorInitializedEvent extends Event {}
public class ReparentFpsCounterEvent extends Event {}
