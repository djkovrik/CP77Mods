module CustomMarkers.Export

@if(ModuleExists("RedFileSystem"))
import RedFileSystem.*
@if(ModuleExists("RedData.Json"))
import RedData.Json.*
@if(ModuleExists("CustomMarkers.System"))
import CustomMarkers.System.*

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

    let modsDTOs: array<ref<CustomMappinsDTO>> = this.GetOtherModsMappinsDTOs();
    let modsMappins: array<ref<CustomMappinData>>;
    let newData: ref<CustomMappinData>;

    for modDto in modsDTOs {
      if IsDefined(modDto) {
        for mappinDto in modDto.mappins {
          if IsDefined(mappinDto) {
            newData = CustomMappinDataDTO.FromDTO(mappinDto);
            if !this.HasMappin(modsMappins, newData) {
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
    let resultingMappins: array<ref<CustomMappinDataDTO>>;
    for mappin in mappins {
      let mappinDto: ref<CustomMappinDataDTO> = CustomMappinDataDTO.ToDTO(mappin);
      ArrayPush(resultingMappins, mappinDto);
    };
    let jsonDto: ref<CustomMappinsDTO> = new CustomMappinsDTO();
    jsonDto.mappins = resultingMappins;
    let json: ref<JsonObject> = ToJson(jsonDto);
    let destination: ref<File> = this.storage.GetFile(this.fileName);
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
      this.Log(s"- \(parsedMappin.description) \(parsedMappin.type) - [\(parsedMappin.X), \(parsedMappin.Y), \(parsedMappin.Z), \(parsedMappin.W)]");
    }
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
              this.Log(s"- \(parsedMappin.description) \(parsedMappin.type) - [\(parsedMappin.X), \(parsedMappin.Y), \(parsedMappin.Z), \(parsedMappin.W)]");
            };
            ArrayPush(result, parsed);
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
        if !this.HasMappin(result, newData) {
          ArrayPush(result, newData);
        };
      };
    };

    return result;
  }

  private final func Log(str: String) -> Void {
    ModLog(n"Exporter", str);
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
