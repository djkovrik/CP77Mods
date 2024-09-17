module HUDrag

public class HUDitorConfig {

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Tracker")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let questTrackerEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "UI-Settings-Interface-HUD-Minimap")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let minimapEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Wanted")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let wantedBarEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Quest-Notifs")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let questNotificationsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Item-Notifs")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let itemNotificationsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Vehicle-Summon")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let vehicleSummonEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Roster")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let weaponRosterEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Crouch")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let crouchIndicatorEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Dpad")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let dpadEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Phone-Controller")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let phoneHotkeyEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Player-Healthbar")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let playerHealthbarEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Stamina")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let playerStaminabarEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Call-Avatar")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let incomingCallAvatarEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Call-Button")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let incomingCallButtonEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Hints")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let inputHintsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Speedometer")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let speedometerEnabled: Bool = false;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Boss-Healthbar")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let bossHealthbarEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Dialog-Choices")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let dialogChoicesEnabled: Bool = false;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Progress")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let progressWidgetEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Toggles")
  @runtimeProperty("ModSettings.displayName", "Mod-HUDitor-Widget-Dialog-Subs")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Toggles-Desc")
  public let dialogSubtitlesEnabled: Bool = false;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Compatibility")
  @runtimeProperty("ModSettings.displayName", "E3 Compass")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Compatibility-Desc")
  public let compatE3CompassEnabled: Bool = false;

  @runtimeProperty("ModSettings.mod", "HUDitor")
  @runtimeProperty("ModSettings.category", "Mod-HUDitor-Compatibility")
  @runtimeProperty("ModSettings.displayName", "FPS Counter")
  @runtimeProperty("ModSettings.description", "Mod-HUDitor-Compatibility-Desc")
  public let fpsCounterEnabled: Bool = false;
}
