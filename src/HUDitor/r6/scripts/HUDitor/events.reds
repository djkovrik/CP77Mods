public class SetActiveHUDEditorWidgetEvent extends Event {
  let activeWidget: CName;
}

public class GameSessionInitializedEvent extends Event {}

public class DisableHUDEditor extends Event {}

public class ResetAllHUDWidgets extends Event {}

public class DisplayPreviewEvent extends Event {}

public class HidePreviewEvent extends Event {}

public class HijackSlotsEvent extends Event {}

public class HijackNewPhnoneControlerEvent extends Event {}

public class ScannerDetailsAppearedEvent extends Event {
  let isVisible: Bool;
  let isHackable: Bool;
}
