module MetroPocketGuide.Config

public class MetroPocketGuideConfig {

  @runtimeProperty("ModSettings.mod", "Netro Guide")
  @runtimeProperty("ModSettings.category", "Widget appearance")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "Opacity")
  @runtimeProperty("ModSettings.description", "Decrease this value to make the widget more transparent.")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.1")
  @runtimeProperty("ModSettings.max", "1.0")
  let opacity: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Netro Guide")
  @runtimeProperty("ModSettings.category", "Widget appearance")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "Scale")
  @runtimeProperty("ModSettings.description", "Bigger value means larger widget size and vice versa.")
  @runtimeProperty("ModSettings.step", "0.05")
  @runtimeProperty("ModSettings.min", "0.5")
  @runtimeProperty("ModSettings.max", "1.5")
  let scale: Float = 0.65;

  @runtimeProperty("ModSettings.mod", "Netro Guide")
  @runtimeProperty("ModSettings.category", "Widget position")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Offset from screen left")
  @runtimeProperty("ModSettings.description", "Increase this value to move the widget to the right side of the screen.")
  @runtimeProperty("ModSettings.step", "20")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "1600")
  let offsetFromLeft: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Netro Guide")
  @runtimeProperty("ModSettings.category", "Widget position")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Offset from screen top")
  @runtimeProperty("ModSettings.description", "Increase this value to move the widget to the bottom of the screen.")
  @runtimeProperty("ModSettings.step", "20")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "900")
  let offsetFromTop: Int32 = 120;

  @runtimeProperty("ModSettings.mod", "Netro Guide")
  @runtimeProperty("ModSettings.category", "World map menu")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Unlock metro mappins")
  @runtimeProperty("ModSettings.description", "If enabled then unlocks all metro fast travel markers on the world map.")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let unlockMetroMappins: Bool = false;
}
