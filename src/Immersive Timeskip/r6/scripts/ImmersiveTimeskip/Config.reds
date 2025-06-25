module ImmersiveTimeskip.Config

public class ITSConfig {
  // Replace false with true if you want to replace vanilla timeskip menu as well
  public static func ReplaceIngameTimeskip() -> Bool = false
}

public class ITSHotkeyConfig {
  @runtimeProperty("ModSettings.mod", "Immersive Timeskip")
  @runtimeProperty("ModSettings.category", "UI-Settings-KeyBindings")
  @runtimeProperty("ModSettings.displayName", "UI-ResourceExports-TimeSkip")
  @runtimeProperty("ModSettings.description", "UI-Settings-Bind")
  public let itsHotkey: EInputKey = EInputKey.IK_O;
}
