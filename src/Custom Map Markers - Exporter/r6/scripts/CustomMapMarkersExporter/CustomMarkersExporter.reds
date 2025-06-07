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

    let persistedDto: ref<CustomMappinsDTO> = this.GetPersistedMappinsDTO();

    if !IsDefined(persistedDto) && NotEquals(ArraySize(currentMappins), 0) {
      this.Log(s"No persisted mappins detected - creating new \(this.fileName)");
      this.PersistNewRevision(currentMappins);
      return currentMappins;
    };

    if Equals(ArraySize(persistedDto.mappins), ArraySize(currentMappins)) {
      this.Log("Storage mappins count is the same as active mappins count, no update needed");
      return currentMappins;
    };

    let updatedMappins: array<ref<CustomMappinData>> = currentMappins;
    let newData: ref<CustomMappinData>;
    this.Log(s"Storage mappins \(ArraySize(persistedDto.mappins)) mappins, active mappins: \(ArraySize(currentMappins))");
    for mappinDto in persistedDto.mappins {
      newData = CustomMappinDataDTO.FromDTO(mappinDto);
      if !this.HasMappin(updatedMappins, newData) {
        this.Log(s"New mappin detected: \(newData.description)");
        ArrayPush(updatedMappins, newData);
      };
    };

    if this.PersistNewRevision(updatedMappins) {
      this.Log("Storage mappins updated");
    };

    return updatedMappins;
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

  private final func GetPersistedMappinsDTO() -> ref<CustomMappinsDTO> {
    this.Log("GetPersistedMappinsDTO call");
    let markersDataStatus: FileSystemStatus = this.storage.Exists(this.fileName);
    let markersDataExists: Bool = Equals(markersDataStatus, FileSystemStatus.True);
    this.Log(s"Markers data status: \(markersDataStatus), file exists: \(markersDataExists)");

    if !markersDataExists {
      this.Log("Data file does not exist!");
      return null;
    };

    let file: ref<File> = this.storage.GetFile(this.fileName);
    let json: ref<JsonObject> = file.ReadAsJson() as JsonObject;

    let parsed: ref<CustomMappinsDTO> = FromJson(json, n"CustomMarkers.Export.CustomMappinsDTO") as CustomMappinsDTO;
    this.Log(s"File \(this.fileName) parsed: \(IsDefined(parsed)), mappins: \(ArraySize(parsed.mappins))");
    for parsedMappin in parsed.mappins {
      this.Log(s"- \(parsedMappin.description) \(parsedMappin.type) - [\(parsedMappin.X), \(parsedMappin.Y), \(parsedMappin.Z), \(parsedMappin.W)]");
    }
    return parsed;
  }

  private final func HasMappin(source: array<ref<CustomMappinData>>, mappin: ref<CustomMappinData>) -> Bool {
    for sourcePin in source {
      if Equals(Cast<Int32>(sourcePin.position.X), Cast<Int32>(mappin.position.X)) 
        && Equals(Cast<Int32>(sourcePin.position.Y), Cast<Int32>(mappin.position.Y))
        && Equals(Cast<Int32>(sourcePin.position.Z), Cast<Int32>(mappin.position.Z)) {
        return true;
      };
    };

    return false;
  }

  private final func Log(str: String) -> Void {
    // ModLog(n"Markers", str);
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
    let position: Vector4 = new Vector4(data.X, data.Y, data.Z, data.W);
    result.position = position;
    result.description = StringToName(data.description);
    result.type = StringToName(data.type);
    return result;
  }
}

public class CustomMappinsDTO {
  let mappins: array<ref<CustomMappinDataDTO>>;
}
