public class SetActiveHUDEditorWidget extends Event {
  let activeWidget: CName;
}

public class GameSessionInitializedEvent extends Event {}

public class DisableHUDEditor extends Event {}

public class ResetAllHUDWidgets extends Event {}

public class DisplayPreviewEvent extends Event {}

public class HidePreviewEvent extends Event {}

public class HijackSlotsEvent extends Event {}

public class ScannerDetailsAppearedEvent extends Event {
  let isVisible: Bool;
  let isHackable: Bool;
}

enum HUDitorCompatMode {
  Default = 0,
  E3HUD = 1,
  E3CompassFaithful = 2,
  E3CompassFaithfulE3HUD = 3,
  E3CompassMinimap = 4,
  E3CompassMinimapE3HUD = 5,
  LTBF = 6,
}

public class SetHUDitorCompatMode extends Event {
  let mode: HUDitorCompatMode;
}