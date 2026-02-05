public class SetActiveHUDEditorWidgetEvent extends Event {
  public let activeWidget: CName;
}

public class GameSessionInitializedEvent extends Event {}

public class DisableHUDEditor extends Event {}

public class ResetAllHUDWidgets extends Event {}

public class DisplayPreviewEvent extends Event {}

public class HidePreviewEvent extends Event {}

public class HijackSlotsEvent extends Event {}

public class HuditorInitializedEvent extends Event {}

public class ScannerDetailsAppearedEvent extends Event {
  public let isVisible: Bool;
  public let isHackable: Bool;
}

public class ReparentFpsCounterEvent extends Event {}
