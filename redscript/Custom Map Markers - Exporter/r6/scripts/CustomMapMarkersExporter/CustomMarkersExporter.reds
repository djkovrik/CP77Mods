module CustomMarkers.Export

@if(ModuleExists("RedFileSystem"))
import RedFileSystem.*
@if(ModuleExists("RedData.Json"))
import RedData.Json.*
@if(ModuleExists("CustomMarkers.System"))
import CustomMarkers.System.*
@if(ModuleExists("CustomMarkers.Common"))
import CustomMarkers.Common.*

@if(ModuleExists("RedData.Json") && ModuleExists("RedFileSystem"))
public class CustomMarkersExporter extends ScriptableService {
  private let fileName: String = "data.json";
  private let storage: ref<FileSystemStorage>;

  public static func Get() -> ref<CustomMarkersExporter> {
    let storage: ref<CustomMarkersExporter> = GameInstance.GetScriptableServiceContainer().GetService(n"CustomMarkers.Export.CustomMarkersExporter") as CustomMarkersExporter;
    return storage;
  }

  private cb func OnLoad() {
    this.storage = FileSystem.GetStorage("CustomMapMarkers");
    this.Log(s"Storage initialized");
  }

  public final func RebuildMappinsWithStorageData(currentMappins: array<ref<CustomMappinData>>) -> array<ref<CustomMappinData>> {
    this.Log("RebuildMappinsWithStorageData call");
    if !this.EnsureStorage() {
      this.Log("Storage is not available, keeping save data");
      return currentMappins;
    };

    let persistedReadResult: ref<CustomMappinsReadResult> = this.GetPersistedMappinsReadResult();

    if Equals(persistedReadResult.status, CustomMappinsReadStatus.Missing) {
      if NotEquals(ArraySize(currentMappins), 0) {
        this.Log(s"No persisted mappins detected - creating new \(this.fileName)");
        this.PersistNewRevision(currentMappins);
      } else {
        this.Log("No persisted mappins detected and no active mappins to persist");
      };

      return currentMappins;
    };

    if Equals(persistedReadResult.status, CustomMappinsReadStatus.Invalid) {
      this.Log(s"Storage \(this.fileName) is invalid, keeping save data and avoiding overwrite");
      return currentMappins;
    };

    let rebuiltMappins: array<ref<CustomMappinData>> = this.BuildMappinsFromDTO(persistedReadResult.dto);
    this.Log(s"Storage \(this.fileName) loaded as source of truth, mappins: \(ArraySize(rebuiltMappins))");
    return rebuiltMappins;
  }

  public final func GetOtherModsMappinData() -> array<ref<CustomMappinData>> {
    this.Log("GetOtherModsMappinData call");
    let modsMappins: array<ref<CustomMappinData>>;
    if !this.EnsureStorage() {
      this.Log("Storage is not available, no mod mappins loaded");
      return modsMappins;
    };

    let modsDTOs: array<ref<CustomMappinsDTO>> = this.GetOtherModsMappinsDTOs();
    let newData: ref<CustomMappinData>;

    for modDto in modsDTOs {
      if IsDefined(modDto) {
        for mappinDto in modDto.mappins {
          if IsDefined(mappinDto) {
            newData = CustomMappinDataDTO.FromDTO(mappinDto);
            if this.IsValidMappinData(newData) && !this.HasMappin(modsMappins, newData) {
              this.Log(s"New mod mappin detected: \(newData.description)");
              ArrayPush(modsMappins, newData);
            };
          };
        };
      };
    };

    return modsMappins;
  }

  public final func PersistNewRevision(mappins: array<ref<CustomMappinData>>) -> Bool {
    this.Log("PersistNewRevision call");
    if !this.EnsureStorage() {
      this.Log("Storage is not available, persist skipped");
      return false;
    };

    let resultingMappins: array<ref<CustomMappinDataDTO>>;
    for mappin in mappins {
      if IsDefined(mappin) {
        let mappinDto: ref<CustomMappinDataDTO> = CustomMappinDataDTO.ToDTO(mappin);
        if IsDefined(mappinDto) {
          ArrayPush(resultingMappins, mappinDto);
        };
      };
    };
    let jsonDto: ref<CustomMappinsDTO> = new CustomMappinsDTO();
    jsonDto.mappins = resultingMappins;
    let json: ref<JsonObject> = ToJson(jsonDto);
    if !IsDefined(json) {
      this.Log("Persist json conversion failed");
      return false;
    };

    let destination: ref<File> = this.storage.GetFile(this.fileName);
    if !IsDefined(destination) {
      this.Log(s"Destination \(this.fileName) is not available");
      return false;
    };

    let status: Bool = destination.WriteJson(json);
    this.Log(s"Persisted markers: \(ArraySize(resultingMappins)) - \(status)");
    return status;
  }

  private final func GetPersistedMappinsReadResult() -> ref<CustomMappinsReadResult> {
    this.Log("GetPersistedMappinsReadResult call");
    let result: ref<CustomMappinsReadResult> = new CustomMappinsReadResult();
    let markersDataStatus: FileSystemStatus = this.storage.Exists(this.fileName);
    let markersDataExists: Bool = Equals(markersDataStatus, FileSystemStatus.True);
    this.Log(s"Markers data status: \(markersDataStatus), file exists: \(markersDataExists)");

    if !markersDataExists {
      this.Log("Data file does not exist!");
      result.status = CustomMappinsReadStatus.Missing;
      return result;
    };

    let file: ref<File> = this.storage.GetFile(this.fileName);
    if !IsDefined(file) {
      this.Log(s"File \(this.fileName) is not available");
      result.status = CustomMappinsReadStatus.Invalid;
      return result;
    };

    let json: ref<JsonObject> = file.ReadAsJson() as JsonObject;
    if !IsDefined(json) {
      this.Log(s"File \(this.fileName) read failed");
      result.status = CustomMappinsReadStatus.Invalid;
      return result;
    };

    let parsed: ref<CustomMappinsDTO> = FromJson(json, n"CustomMarkers.Export.CustomMappinsDTO") as CustomMappinsDTO;
    if !IsDefined(parsed) {
      this.Log(s"File \(this.fileName) parse failed");
      result.status = CustomMappinsReadStatus.Invalid;
      return result;
    };

    this.Log(s"File \(this.fileName) parsed: \(IsDefined(parsed)), mappins: \(ArraySize(parsed.mappins))");
    for parsedMappin in parsed.mappins {
      if IsDefined(parsedMappin) {
        this.Log(s"- \(parsedMappin.description) \(parsedMappin.type) - [\(parsedMappin.X), \(parsedMappin.Y), \(parsedMappin.Z), \(parsedMappin.W)]");
      };
    };
    result.status = CustomMappinsReadStatus.Loaded;
    result.dto = parsed;
    return result;
  }

  private final func GetOtherModsMappinsDTOs() -> array<ref<CustomMappinsDTO>> {
    this.Log("GetOtherModsMappinsDTOs call");

    let result: array<ref<CustomMappinsDTO>>;
    let files: array<ref<File>> = this.storage.GetFiles();
    let fileExtension: String;
    let isJsonFile: Bool;
    let modFileName: String;
    let parsed: ref<CustomMappinsDTO>;
    for file in files {
      if IsDefined(file) {
        modFileName = file.GetFilename();
        fileExtension = StrLower(file.GetExtension());
        isJsonFile = Equals(fileExtension, "json") || Equals(fileExtension, ".json");

        if Equals(StrLower(modFileName), this.fileName) {
          this.Log(s"Skip \(modFileName) read");
        } else if !isJsonFile {
          this.Log(s"Skip non-json file \(modFileName)");
        } else {
          let json: ref<JsonObject> = file.ReadAsJson() as JsonObject;
          if !IsDefined(json) {
            this.Log(s"File \(modFileName) read failed");
          } else {
            this.Log(s"Parsing \(modFileName)...");
            parsed = FromJson(json, n"CustomMarkers.Export.CustomMappinsDTO") as CustomMappinsDTO;
            if !IsDefined(parsed) {
              this.Log(s"File \(modFileName) parse failed");
            } else {
              this.Log(s"Mod storage \(modFileName) parsed: \(IsDefined(parsed)), mappins: \(ArraySize(parsed.mappins))");
              for parsedMappin in parsed.mappins {
                if IsDefined(parsedMappin) {
                  this.Log(s"- \(parsedMappin.description) \(parsedMappin.type) - [\(parsedMappin.X), \(parsedMappin.Y), \(parsedMappin.Z), \(parsedMappin.W)]");
                };
              };
              ArrayPush(result, parsed);
            };
          };
        };
      };
    };

    return result;
  }

  private final func HasMappin(source: array<ref<CustomMappinData>>, mappin: ref<CustomMappinData>) -> Bool {
    if !IsDefined(mappin) {
      return false;
    };

    for sourcePin in source {
      if IsDefined(sourcePin)
        && Equals(Cast<Int32>(sourcePin.position.X), Cast<Int32>(mappin.position.X)) 
        && Equals(Cast<Int32>(sourcePin.position.Y), Cast<Int32>(mappin.position.Y))
        && Equals(Cast<Int32>(sourcePin.position.Z), Cast<Int32>(mappin.position.Z)) {
        return true;
      };
    };

    return false;
  }

  private final func BuildMappinsFromDTO(dto: ref<CustomMappinsDTO>) -> array<ref<CustomMappinData>> {
    let result: array<ref<CustomMappinData>>;
    let newData: ref<CustomMappinData>;

    if !IsDefined(dto) {
      return result;
    };

    for mappinDto in dto.mappins {
      if IsDefined(mappinDto) {
        newData = CustomMappinDataDTO.FromDTO(mappinDto);
        if this.IsValidMappinData(newData) && !this.HasMappin(result, newData) {
          ArrayPush(result, newData);
        };
      };
    };

    return result;
  }

  private final func IsValidMappinData(data: ref<CustomMappinData>) -> Bool {
    if !IsDefined(data) {
      this.Log("Skip mappin: data is null");
      return false;
    };

    if Equals(NameToString(data.description), "") {
      this.Log("Skip mappin: description is empty");
      return false;
    };

    if !this.IsValidIcon(data.type) {
      this.Log(s"Skip mappin \(data.description): icon \(data.type) is not supported");
      return false;
    };

    if !this.IsValidPosition(data.position) {
      this.Log(s"Skip mappin \(data.description): position is invalid");
      return false;
    };

    return true;
  }

  private final func IsValidIcon(type: CName) -> Bool {
    let supportedIcons: array<CName> = Icons.Row1();
    for icon in Icons.Row2() {
      ArrayPush(supportedIcons, icon);
    };

    return ArrayContains(supportedIcons, type);
  }

  private final func IsValidPosition(position: Vector4) -> Bool {
    if position.X == 0.0 && position.Y == 0.0 && position.Z == 0.0 {
      return false;
    };

    return position.X > -1000000.0 && position.X < 1000000.0
      && position.Y > -1000000.0 && position.Y < 1000000.0
      && position.Z > -1000000.0 && position.Z < 1000000.0;
  }

  private final func EnsureStorage() -> Bool {
    if !IsDefined(this.storage) {
      this.storage = FileSystem.GetStorage("CustomMapMarkers");
    };

    return IsDefined(this.storage);
  }

  private final func Log(str: String) -> Void {
    // ModLog(n"Exporter", str);
  }
}

public class CustomMappinDataDTO {
  public let X: Float;
  public let Y: Float;
  public let Z: Float;
  public let W: Float;
  public let description: String;
  public let type: String;

  public static func ToDTO(data: ref<CustomMappinData>) -> ref<CustomMappinDataDTO> {
    if !IsDefined(data) {
      return null;
    };

    let result: ref<CustomMappinDataDTO> = new CustomMappinDataDTO();
    result.X = data.position.X;
    result.Y = data.position.Y;
    result.Z = data.position.Z;
    result.W = data.position.W;
    result.description = NameToString(data.description);
    result.type = NameToString(data.type);
    return result;
  }

  public static func FromDTO(data: ref<CustomMappinDataDTO>) -> ref<CustomMappinData> {
    if !IsDefined(data) {
      return null;
    };

    let result: ref<CustomMappinData> = new CustomMappinData();
    let position: Vector4 = Vector4(data.X, data.Y, data.Z, data.W);
    result.position = position;
    result.description = StringToName(data.description);
    result.type = StringToName(data.type);
    return result;
  }
}

public class CustomMappinsDTO {
  public let mappins: array<ref<CustomMappinDataDTO>>;
}

public enum CustomMappinsReadStatus {
  Missing = 0,
  Invalid = 1,
  Loaded = 2,
}

public class CustomMappinsReadResult {
  public let status: CustomMappinsReadStatus;
  public let dto: ref<CustomMappinsDTO>;
}
