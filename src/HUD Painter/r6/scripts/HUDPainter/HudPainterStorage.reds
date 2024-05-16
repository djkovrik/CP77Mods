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
    return NameToString(this.activePreset);
  }

  private final func SaveActivePresetName(name: String) -> Void {
    this.activePreset = StringToName(name);
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
