module ImprovedMinimapMain

// -- Here you can configure minimap zooom values and enable or disable the mod features

public class ZoomConfig {

  // -- BASE MINIMAP CONFIG --

  // -- Default in-game zoom values for reference:
  //    Combat = 40
  //    QuestArea = 25
  //    SecurityArea = 40
  //    Interior = 25
  //    Exterior = 35
  //    Vehicle = 100

  // Zoom value for active combat mode
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Static")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Combat")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Combat-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let combat: Int32 = 60;
  
  // Zoom value for quest areas
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Static")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Quest")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Quest-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let questArea: Int32 = 40;
  
  // Zoom value for restricted and dangerous areas
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Static")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Security")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Security-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let securityArea: Int32 = 60;
  
  // Zoom value for interiors
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Static")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Interior")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Interior-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let interior: Int32 = 40;

  // Zoom value for remained cases:
  // not in interior, not in vehicle, not in security area, no active combat
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Static")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Exterior")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Exterior-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let exterior: Int32 = 60;

  // -- MINIMAP PEEK HOTKEY CONFIG

  // Non-vehicle zoom increment value for peek mode
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Peek-Hotkey")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Peek-Increment")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Peek-Increment-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let peek: Int32 = 40;

  // By default hotkey zooms minimap while you hold it and 
  // resets zoom when you release it, replace false with true here
  // if you want to replace hold to zoom behavior with toggle by keypress
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Peek-Hotkey")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Peek-Toggleable")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Peek-Toggleable-Desc")
  let replaceHoldWithToggle: Bool = false;

  // -- VEHICLE MINIMAP CONFIG --

  // This option enables vehicle minimap dynamic zoom based on speed
  // If set to false then minimap will always use value from MinZoom option
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Max-Dynamic")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Max-Dynamic-Enable")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Max-Dynamic-Enable-Desc")
  let isDynamicZoomEnabled: Bool = true;

  // MinSpeed and MaxSpeed values determine at which speeds dynamic zoom
  // starts and stops, and MinZoom and MaxZoom values define zoom range itself

  // Minimal zoom value
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Max-Dynamic")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Min-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Min-Zoom-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let minZoom: Int32 = 80;

  // Speed threshold when zoom will start increasing from MinZoom
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Max-Dynamic")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Min-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Min-Zoom-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let minSpeed: Int32 = 20;

  // Maximal zoom value
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Max-Dynamic")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Max-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Max-Zoom-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let maxZoom: Int32 = 140;

  // Speed threshold when zoom will reach the value from MaxZoom
  @runtimeProperty("ModSettings.mod", "Improved Minimap Zoom")
  @runtimeProperty("ModSettings.category", "Mod-IMZ-Max-Dynamic")
  @runtimeProperty("ModSettings.displayName", "Mod-IMZ-Max-Speed")
  @runtimeProperty("ModSettings.description", "Mod-IMZ-Max-Speed-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "20")
  @runtimeProperty("ModSettings.max", "200")
  let maxSpeed: Int32 = 120;
}
