module MetroPocketGuide.Config

public class MetroPocketGuideConfig {

  @runtimeProperty("ModSettings.mod", "Metro Guide")
  @runtimeProperty("ModSettings.category", "PMG-Widget-Appearance")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "PMG-Option-Opacity")
  @runtimeProperty("ModSettings.description", "PMG-Option-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.1")
  @runtimeProperty("ModSettings.max", "1.0")
  let opacity: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Metro Guide")
  @runtimeProperty("ModSettings.category", "PMG-Widget-Appearance")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "PMG-Option-Size")
  @runtimeProperty("ModSettings.description", "PMG-Option-Size-Desc")
  @runtimeProperty("ModSettings.step", "0.05")
  @runtimeProperty("ModSettings.min", "0.5")
  @runtimeProperty("ModSettings.max", "1.5")
  let scale: Float = 0.65;

  @runtimeProperty("ModSettings.mod", "Metro Guide")
  @runtimeProperty("ModSettings.category", "PMG-Widget-Position")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "PMG-Offset-Left")
  @runtimeProperty("ModSettings.description", "PMG-Offset-Left-Desc")
  @runtimeProperty("ModSettings.step", "25")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "2200")
  let offsetFromLeft: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Metro Guide")
  @runtimeProperty("ModSettings.category", "PMG-Widget-Position")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "PMG-Offset-Top")
  @runtimeProperty("ModSettings.description", "PMG-Offset-Top-Desc")
  @runtimeProperty("ModSettings.step", "20")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "1200")
  let offsetFromTop: Int32 = 80;

  @runtimeProperty("ModSettings.mod", "Metro Guide")
  @runtimeProperty("ModSettings.category", "PMG-Widget-Behavior")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "PMG-Visibility")
  @runtimeProperty("ModSettings.description", "PMG-Visibility-Desc")
  let visibleByDefault: Bool = true;

  @runtimeProperty("ModSettings.mod", "Metro Guide")
  @runtimeProperty("ModSettings.category", "PMG-Worldmap-Menu")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "PMG-Unlock")
  @runtimeProperty("ModSettings.description", "PMG-Unlock-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let unlockMetroMappins: Bool = false;
}
