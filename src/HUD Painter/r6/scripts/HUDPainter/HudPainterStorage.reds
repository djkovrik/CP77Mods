module HudPainter
import RedFileSystem.*
import RedData.Json.*

public class HudPainterStorage extends ScriptableService {
  private let defaultPreset: String = "DEFAULT";
  
  private let storage: ref<FileSystemStorage>;

  private persistent let activePreset: CName;

  private cb func OnLoad() {
    this.storage = FileSystem.GetStorage("HUDPainter");
    if Equals(this.activePreset, n"") {
      this.Log("First load, active preset set to default");
      this.SaveActivePresetName(this.defaultPreset);
    };

    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/Loaded", this, n"OnStyleLoaded")
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\common\\main_colors.inkstyle"))
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\common\\themes\\main_colors_johnny.inkstyle"));
  }

  public static func Get() -> ref<HudPainterStorage> {
    let storage: ref<HudPainterStorage> = GameInstance.GetScriptableServiceContainer().GetService(n"HudPainter.HudPainterStorage") as HudPainterStorage;
    return storage;
  }

  public final func GetActivePresetData() -> array<ref<HudPainterColorItem>> {
    return this.GetPresetData(this.GetActivePresetName());
  }

  public final func SaveNewPresetData(name: String, data: array<ref<HudPainterColorItem>>) -> Void {
    let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(GetGameInstance());
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(GetGameInstance());
    let presetName: String = s"\(name).json";
    let propertiesDefault: array<ref<HudPainterStylePropertyDTO>>;
    let propertiesJohnny: array<ref<HudPainterStylePropertyDTO>>;
    let property: ref<HudPainterStylePropertyDTO>;

    for item in data {
      property = new HudPainterStylePropertyDTO();
      property.name = item.name;
      property.red = item.customColor.Red;
      property.green = item.customColor.Green;
      property.blue = item.customColor.Blue;
      property.alpha = 1;

      if Equals(item.type, HudPainterColorType.Johnny) {
        ArrayPush(propertiesJohnny, property);
      } else {
        ArrayPush(propertiesDefault, property);
      };
    };

    this.Log(s"Preset \(presetName) encoded, Default: \(ArraySize(propertiesDefault)), Johnny: \(ArraySize(propertiesJohnny))");

    let jsonDto: ref<HudPainterStyleDTO> = new HudPainterStyleDTO();
    jsonDto.propertiesDefault = propertiesDefault;
    jsonDto.propertiesJohnny = propertiesJohnny;
    let json: ref<JsonObject> = ToJson(jsonDto);
    let destination: ref<File> = this.storage.GetFile(presetName);
    let status: Bool = destination.WriteJson(json);
    if status {
      this.Log(s"Preset \(presetName) saved");
      this.SaveActivePresetName(name);
      delaySystem.DelayCallback(DelayedScreenRefreshCallback.Create(uiSystem), 1.0, false);
    } else {
      this.Log(s"Preset \(presetName) not saved!");
    };
  }

  public final func IsDefaultPresetMissing() -> Bool {
    let defaultPresetStatus: FileSystemStatus = this.storage.Exists(s"\(this.defaultPreset).json");
    return NotEquals(defaultPresetStatus, FileSystemStatus.True);
  }

  public final func GetDefaultPresetName() -> String {
    return this.defaultPreset;
  }

  public final func GetAvailablePresetsList() -> array<ref<HudPainterPresetItem>> {
    let result: array<ref<HudPainterPresetItem>>;
    let defaultPresetStatus: FileSystemStatus = this.storage.Exists(s"\(this.defaultPreset).json");
    if NotEquals(defaultPresetStatus, FileSystemStatus.True) {
      this.Log("Failed to find default preset! Abort, notify user");
      return result;
    };

    let files: array<ref<File>> = this.storage.GetFiles();
    let item: ref<HudPainterPresetItem>;
    let shortName: String;

    // Default preset always first
    item = new HudPainterPresetItem();
    item.name = this.defaultPreset;
    item.fileName = s"\(this.defaultPreset).json";
    item.active = Equals(this.defaultPreset, this.GetActivePresetName());
    ArrayPush(result, item);

    // Other
    for file in files {
      shortName = StrBeforeLast(file.GetFilename(), ".json");
      if NotEquals(shortName, this.defaultPreset) {
        item = new HudPainterPresetItem();
        item.name = shortName;
        item.fileName = s"\(shortName).json";
        item.active = Equals(shortName, this.GetActivePresetName());
        ArrayPush(result, item);
      };
    };

    let presetsStr: String = "";
    for item in result {
      presetsStr += s"\(item.name), ";
    };

    this.Log(s"Available presets: \(presetsStr)");

    return result;
  }

  private final func GetPresetData(preset: String) -> array<ref<HudPainterColorItem>> {
    let result: array<ref<HudPainterColorItem>>;
    let defaultPreset: ref<HudPainterStyleDTO> = this.GetPresetByName(this.defaultPreset);
    let targetPreset: ref<HudPainterStyleDTO> = this.GetPresetByName(preset);

    // Integrity check
    let defaultPresetDefined: Bool = IsDefined(defaultPreset);
    let targetPresetDefined: Bool = IsDefined(targetPreset);

    if !defaultPresetDefined || !targetPresetDefined {
      this.Log(s"One of the presets not found! Default: \(defaultPresetDefined), target: \(targetPresetDefined)");
      return result;
    };

    let defaultPropertiesMatch: Bool = Equals(ArraySize(defaultPreset.propertiesDefault), ArraySize(targetPreset.propertiesDefault));
    let johnnyPropertiesMatch: Bool = Equals(ArraySize(defaultPreset.propertiesJohnny), ArraySize(targetPreset.propertiesJohnny));

    if !defaultPropertiesMatch || !johnnyPropertiesMatch {
      this.Log(s"Preset data broken! Default: \(defaultPropertiesMatch), Johnny \(johnnyPropertiesMatch)");
      return result;
    };

    // Build items list
    let propertyFrom: ref<HudPainterStylePropertyDTO>;
    let propertyTo: ref<HudPainterStylePropertyDTO>;
    let item: ref<HudPainterColorItem>;

    let index: Int32 = 0;
    let count: Int32 = ArraySize(defaultPreset.propertiesDefault);
    while index < count {
      propertyFrom = defaultPreset.propertiesDefault[index];
      propertyTo = targetPreset.propertiesDefault[index];
      item = new HudPainterColorItem();
      item.name = propertyFrom.name;
      item.type = HudPainterColorType.Default;
      item.defaultColor = new HDRColor(propertyFrom.red, propertyFrom.green, propertyFrom.blue, 1.0);
      item.customColor = new HDRColor(propertyTo.red, propertyTo.green, propertyTo.blue, 1.0);
      item.presetColor = new HDRColor(propertyTo.red, propertyTo.green, propertyTo.blue, 1.0);
      ArrayPush(result, item);
      index += 1;
    };

    index = 0;
    count = ArraySize(defaultPreset.propertiesJohnny);
    while index < count {
      propertyFrom = defaultPreset.propertiesJohnny[index];
      propertyTo = targetPreset.propertiesJohnny[index];
      item = new HudPainterColorItem();
      item.name = propertyFrom.name;
      item.type = HudPainterColorType.Johnny;
      item.defaultColor = new HDRColor(propertyFrom.red, propertyFrom.green, propertyFrom.blue, 1.0);
      item.customColor = new HDRColor(propertyTo.red, propertyTo.green, propertyTo.blue, 1.0);
      item.presetColor = new HDRColor(propertyTo.red, propertyTo.green, propertyTo.blue, 1.0);
      ArrayPush(result, item);
      index += 1;
    };

    this.Log(s"Preset \(preset) is ready! Default: \(ArraySize(targetPreset.propertiesDefault)), Johnny: \(ArraySize(targetPreset.propertiesJohnny)), total \(ArraySize(result))");
    return result;
  }

  private final func GetPresetByName(preset: String) -> ref<HudPainterStyleDTO> {
    let presetFileName: String = s"\(preset).json";
    let status: FileSystemStatus = this.storage.IsFile(presetFileName);
    if NotEquals(status, FileSystemStatus.True) {
      this.Log("Target preset not found!");
      return null;
    };

    return this.ParsePreset(presetFileName);
  }

  private final func ParsePreset(fileName: String) -> ref<HudPainterStyleDTO> {
    let file: ref<File> = this.storage.GetFile(fileName);
    let json: ref<JsonObject> = file.ReadAsJson() as JsonObject;
    let parsed: ref<HudPainterStyleDTO> = FromJson(json, n"HudPainterStyleDTO") as HudPainterStyleDTO;
    this.Log(s"File \(fileName) parsed: \(IsDefined(parsed)) | Default entries: \(ArraySize(parsed.propertiesDefault)), Johnny entries: \(ArraySize(parsed.propertiesJohnny))");
    return parsed;
  }

  private final func GetActivePresetName() -> String {
    this.Log(s"GetActivePresetName returns \(this.activePreset)");
    return NameToString(this.activePreset);
  }

  private final func SaveActivePresetName(name: String) -> Void {
    this.Log(s"SaveActivePresetName \(name)");
    this.activePreset = StringToName(name);
    this.Log(s"SaveActivePresetName should be \(this.activePreset)");
  }

  private cb func OnStyleLoaded(event: ref<ResourceEvent>) -> Void {
    if Equals(this.GetActivePresetName(), this.defaultPreset) {
      this.Log("Default preset is active, skip inkstyle patching");
      return ;
    };

    let activePreset: ref<HudPainterStyleDTO> = this.GetPresetByName(this.GetActivePresetName());
    let resource: ref<inkStyleResource> = event.GetResource() as inkStyleResource;
    let path: ResRef = event.GetPath();
    let isDefault: Bool = Equals(path, r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    let isJohnny: Bool = Equals(path, r"base\\gameplay\\gui\\common\\themes\\main_colors_johnny.inkstyle");
    if isDefault { this.PatchTheme(resource, activePreset.propertiesDefault); };
    if isJohnny { this.PatchTheme(resource, activePreset.propertiesJohnny); };
  }

  private final func PatchTheme(resource: ref<inkStyleResource>, props: array<ref<HudPainterStylePropertyDTO>>) -> Void {
    if Equals(ArraySize(resource.styles), 0) {
      this.Log("Failed to patch theme because styles array is empty");
      return ;
    };

    this.Log("Patching inkstyle file...");

    let colors: ref<inkHashMap> = new inkHashMap();
    for property in props {
      colors.Insert(this.Key(property.name), property);
    };

    let counter: Int32 = 0;
    let newStyle: inkStyle = resource.styles[0];
    let newProperties: array<inkStyleProperty>;
    for property in resource.styles[0].properties {
      let keyStr: String = NameToString(property.propertyPath);
      if colors.KeyExist(this.Key(keyStr)) {
        let newProperty: inkStyleProperty;
        let cachedColor: ref<HudPainterStylePropertyDTO> = colors.Get(this.Key(keyStr)) as HudPainterStylePropertyDTO;
        let newColor: HDRColor = cachedColor.AsHDRColor();
        newProperty.propertyPath = property.propertyPath;
        newProperty.value = ToVariant(newColor);
        counter += 1;
        ArrayPush(newProperties, newProperty);
      } else {
        ArrayPush(newProperties, property);
      };
    };

    this.Log(s"Properties patched: \(counter)");
    newStyle.properties = newProperties;
    resource.styles[0] = newStyle;
  }

  public final func Key(str: String) -> Uint64 {
    return TDBID.ToNumber(TDBID.Create(str));
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"Storage", str);
    };
  }
}

private class DelayedScreenRefreshCallback extends DelayCallback {
  private let system: wref<UISystem>;

  public func Call() {
    this.system.QueueEvent(new HudPainterPresetSaved());
  }

  public static func Create(system: ref<UISystem>) -> ref<DelayedScreenRefreshCallback> {
    let instance = new DelayedScreenRefreshCallback();
    instance.system = system;
    return instance;
  }
}
