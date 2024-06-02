module HudPainter

enum HudPainterConfigColor {
  Red = 0,
  ActiveRed = 1,
  MildRed = 2,
  DarkRed = 3,
  FaintRed = 4,
  Blue = 5,
  ActiveBlue = 6,
  MildBlue = 7,
  DarkBlue = 8,
  FaintBlue = 9,
  MediumBlue = 10,
  Yellow = 11,
  ActiveYellow = 12,
  MildYellow = 13,
  FaintYellow = 14,
  Green = 15,
  MildGreen = 16,
  ActiveGreen = 17,
  DarkGreen = 18,
  Grey = 19,
  White = 20,
}

class HudPainterWorldMapSettings {
  @runtimeProperty("ModSettings.mod", "Mod-HudPainter-Name")
  @runtimeProperty("ModSettings.category", "Mod-HudPainter-Settings-WorldMap")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-HudPainter-Settings-Enable-Colors")
  @runtimeProperty("ModSettings.description", "Mod-HudPainter-Settings-Enable-Colors-Desc")
  let enableCustomWorldmap: Bool = false;

  @runtimeProperty("ModSettings.mod", "Mod-HudPainter-Name")
  @runtimeProperty("ModSettings.category", "Mod-HudPainter-Settings-WorldMap")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-HudPainter-Settings-Contrast")
  @runtimeProperty("ModSettings.description", "Mod-HudPainter-Settings-Contrast-Desc")
  @runtimeProperty("ModSettings.step", "0.05")
  @runtimeProperty("ModSettings.min", "0.1")
  @runtimeProperty("ModSettings.max", "1.5")
  @runtimeProperty("ModSettings.dependency", "enableCustomWorldmap")
  let worldMapContrast: Float = 1.1;

  @runtimeProperty("ModSettings.mod", "Mod-HudPainter-Name")
  @runtimeProperty("ModSettings.category", "Mod-HudPainter-Settings-WorldMap")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-HudPainter-Settings-Saturation")
  @runtimeProperty("ModSettings.description", "Mod-HudPainter-Settings-Saturation-Desc")
  @runtimeProperty("ModSettings.step", "0.05")
  @runtimeProperty("ModSettings.min", "0.1")
  @runtimeProperty("ModSettings.max", "1.5")
  @runtimeProperty("ModSettings.dependency", "enableCustomWorldmap")
  let worldMapSaturation: Float = 1.1;

  @runtimeProperty("ModSettings.mod", "Mod-HudPainter-Name")
  @runtimeProperty("ModSettings.category", "Mod-HudPainter-Settings-WorldMap")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-HudPainter-Settings-Buildings")
  @runtimeProperty("ModSettings.description", "Mod-HudPainter-Settings-Buildings-Desc")
  @runtimeProperty("ModSettings.dependency", "enableCustomWorldmap")
  let worldMapBuildings: HudPainterConfigColor = HudPainterConfigColor.Red;

  @runtimeProperty("ModSettings.mod", "Mod-HudPainter-Name")
  @runtimeProperty("ModSettings.category", "Mod-HudPainter-Settings-WorldMap")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-HudPainter-Settings-Buildings-Edge")
  @runtimeProperty("ModSettings.description", "Mod-HudPainter-Settings-Buildings-Edge-Desc")
  @runtimeProperty("ModSettings.dependency", "enableCustomWorldmap")
  let worldMapBuildingsEdge: HudPainterConfigColor = HudPainterConfigColor.MildRed;

  @runtimeProperty("ModSettings.mod", "Mod-HudPainter-Name")
  @runtimeProperty("ModSettings.category", "Mod-HudPainter-Settings-WorldMap")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-HudPainter-Settings-Roads")
  @runtimeProperty("ModSettings.description", "Mod-HudPainter-Settings-Roads-Desc")
  @runtimeProperty("ModSettings.dependency", "enableCustomWorldmap")
  let worldMapRoads: HudPainterConfigColor = HudPainterConfigColor.MildBlue;

  @runtimeProperty("ModSettings.mod", "Mod-HudPainter-Name")
  @runtimeProperty("ModSettings.category", "Mod-HudPainter-Settings-WorldMap")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-HudPainter-Settings-Road-Borders")
  @runtimeProperty("ModSettings.description", "Mod-HudPainter-Settings-Road-Borders-Desc")
  @runtimeProperty("ModSettings.dependency", "enableCustomWorldmap")
  let worldMapRoadBorders: HudPainterConfigColor = HudPainterConfigColor.ActiveBlue;

  // @runtimeProperty("ModSettings.mod", "Mod-HudPainter-Name")
  // @runtimeProperty("ModSettings.category", "Mod-HudPainter-Settings-WorldMap")
  // @runtimeProperty("ModSettings.category.order", "1")
  // @runtimeProperty("ModSettings.displayName", "Metro line")
  // @runtimeProperty("ModSettings.description", "Metro line color for the world map menu.")
  // @runtimeProperty("ModSettings.dependency", "enableCustomWorldmap")
  // let worldMapMetroLine: HudPainterConfigColor = HudPainterConfigColor.Blue;
}

class HudPainterWorldMapPatch extends ScriptableService {
  // patch for 3dmap.envparam
  private cb func On3dMapEnvparamResource(event: ref<ResourceEvent>) {
    let config: ref<HudPainterWorldMapSettings> = new HudPainterWorldMapSettings();
    if !config.enableCustomWorldmap { return ; };

    let resource: ref<worldEnvironmentAreaParameters> = event.GetResource() as worldEnvironmentAreaParameters;
    this.Log(s"? Patch \(resource.GetClassName()) with contrast \(config.worldMapContrast) and saturation \(config.worldMapSaturation)");
    
    for parameter in resource.renderAreaSettings.areaParameters {
      let colorGradingAreaSettings: ref<ColorGradingAreaSettings> = parameter as ColorGradingAreaSettings;
      if IsDefined(colorGradingAreaSettings) {
        colorGradingAreaSettings.contrast = config.worldMapContrast;
        colorGradingAreaSettings.saturation = config.worldMapSaturation;
        this.Log(s"! Patched contrast: \(colorGradingAreaSettings.contrast), patched saturation: \(colorGradingAreaSettings.saturation)");
        break;
      };
    };
  }

  // patch for 3d_map_cubes.mt
  private cb func On3dMapCubesMtResource(event: ref<ResourceEvent>) {
    let config: ref<HudPainterWorldMapSettings> = new HudPainterWorldMapSettings();
    if !config.enableCustomWorldmap { return ; };

    let resource: ref<CMaterialTemplate> = event.GetResource() as CMaterialTemplate;
    let targetParameters: array<ref<CMaterialParameter>> = resource.parameters[2];
    this.Log(s"Patch 3d_map_cubes \(resource.GetClassName()), parameters size \(ArraySize(targetParameters))");

    for parameter in targetParameters {
      let colorParameter: ref<CMaterialParameterColor> = parameter as CMaterialParameterColor;
      if IsDefined(colorParameter) {
        switch colorParameter.parameterName {
          case n"BaseColorScale":
            colorParameter.color = this.GetColorValue(config.worldMapBuildings);
            break;
          case n"EdgeColor":
            colorParameter.color = this.GetColorValue(config.worldMapBuildingsEdge);
            break;
          default:
            // do nothing
            break;
        };
      };
    }
  }

  // patch for hud_painter_3d_map_roads.mt
  private cb func OnHudPainter3dMapRoadsResource(event: ref<ResourceEvent>) {
    let config: ref<HudPainterWorldMapSettings> = new HudPainterWorldMapSettings();
    if !config.enableCustomWorldmap { return ; };

    let resource: ref<CMaterialTemplate> = event.GetResource() as CMaterialTemplate;
    let targetParameters: array<ref<CMaterialParameter>> = resource.parameters[2];
    this.Log(s"Patch hud_painter_3d_map_roads \(resource.GetClassName()), parameters size \(ArraySize(targetParameters))");

    for parameter in targetParameters {
      let colorParameter: ref<CMaterialParameterColor> = parameter as CMaterialParameterColor;
      if IsDefined(colorParameter) {
        if Equals(colorParameter.parameterName, n"Color") {
          colorParameter.color = this.GetColorValue(config.worldMapRoads);
          break;
        };
      };
    };
  }

  // patch for hud_painter_3d_map_road_borders.mt
  private cb func OnHudPainter3dMapRoadBordersResource(event: ref<ResourceEvent>) {
    let config: ref<HudPainterWorldMapSettings> = new HudPainterWorldMapSettings();
    if !config.enableCustomWorldmap { return ; };

    let resource: ref<CMaterialTemplate> = event.GetResource() as CMaterialTemplate;
    let targetParameters: array<ref<CMaterialParameter>> = resource.parameters[2];
    this.Log(s"Patch hud_painter_3d_map_road_borders \(resource.GetClassName()), parameters size \(ArraySize(targetParameters))");

    for parameter in targetParameters {
      let colorParameter: ref<CMaterialParameterColor> = parameter as CMaterialParameterColor;
      if IsDefined(colorParameter) {
        if Equals(colorParameter.parameterName, n"Color") {
          colorParameter.color = this.GetColorValue(config.worldMapRoadBorders);
          break;
        };
      };
    };
  }

  private cb func OnLoad() {
    let callbackSystem: ref<CallbackSystem> = GameInstance.GetCallbackSystem();

    callbackSystem
      .RegisterCallback(n"Resource/Ready", this, n"On3dMapEnvparamResource")
      .AddTarget(ResourceTarget.Path(r"base\\weather\\24h_basic\\3dmap.envparam"));

    callbackSystem
      .RegisterCallback(n"Resource/Ready", this, n"On3dMapCubesMtResource")
      .AddTarget(ResourceTarget.Path(r"base\\materials\\3d_map_cubes.mt"));

    callbackSystem
      .RegisterCallback(n"Resource/Ready", this, n"OnHudPainter3dMapRoadsResource")
      .AddTarget(ResourceTarget.Path(r"base\\materials\\hud_painter_3d_map_roads.mt"));

    callbackSystem
      .RegisterCallback(n"Resource/Ready", this, n"OnHudPainter3dMapRoadBordersResource")
      .AddTarget(ResourceTarget.Path(r"base\\materials\\hud_painter_3d_map_road_borders.mt"));
  }

  private final func GetColorValue(from: HudPainterConfigColor) -> Color {
    let colorItem: ref<HudPainterColorItem>;
    let color: Color;
    let keyStr: String = this.ToStr(from);
    let key: Uint64 = this.Key(keyStr);

    let currentThemeColors: ref<inkHashMap> = this.GetCurrentPresetColorsHashMap();
    if currentThemeColors.KeyExist(key) {
      colorItem = currentThemeColors.Get(key) as HudPainterColorItem;
      color = this.ToColor(colorItem.presetColor);
      this.Log(s"- \(keyStr) found");
    } else {
      this.Log(s"- \(keyStr) not found");
      color = new Color(Cast<Uint8>(255), Cast<Uint8>(255), Cast<Uint8>(255), Cast<Uint8>(255));
    };

    return color;
  }

  private final func GetCurrentPresetColorsHashMap() -> ref<inkHashMap> {
    let result: ref<inkHashMap> = new inkHashMap();
    
    let presetData: array<ref<HudPainterColorItem>> = HudPainterStorage.Get().GetActivePresetData();
    let counter: Int32 = 0;
    for colorItem in presetData {
      if Equals(colorItem.type, HudPainterColorType.Default) {
        result.Insert(this.Key(colorItem.name), colorItem);
        counter += 1;
      };
    };

    this.Log(s"Colors map ready with \(counter) colors");
    return result;
  }

  private final func ToColor(hdrColor: HDRColor) -> Color {
    let red: Int32 = Cast<Int32>(hdrColor.Red * 255.0);
    let green: Int32 = Cast<Int32>(hdrColor.Green * 255.0);
    let blue: Int32 = Cast<Int32>(hdrColor.Blue * 255.0);
    let redColor: Uint8 = Cast<Uint8>(Min(red, 255));
    let greenColor: Uint8 = Cast<Uint8>(Min(green, 255));
    let blueColor: Uint8 = Cast<Uint8>(Min(blue, 255));
    return new Color(redColor, greenColor, blueColor, Cast<Uint8>(255));
  }

  private final func Key(name: String) -> Uint64 {
    return TDBID.ToNumber(TDBID.Create(name));
  }

  private final func ToStr(from: HudPainterConfigColor) -> String {
    return s"MainColors.\(from)";
  }

  private final func Log(str: String) -> Void {
    ModLog(n"WorldMapPatcher", str);
  }
}
