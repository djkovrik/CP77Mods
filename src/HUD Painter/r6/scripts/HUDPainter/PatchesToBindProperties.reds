module HudPainter

public class PatchMinimapStyle extends ScriptableService {

  private cb func OnLoad() {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/Loaded", this, n"OnMainColorsLoaded")
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\common\\main_colors.inkstyle"));
  }


  private cb func OnMainColorsLoaded(event: ref<ResourceEvent>) -> Void {
    this.Log("Patching minimap theme colors...");
    let resource: ref<inkStyleResource> = event.GetResource() as inkStyleResource;
    let minimapStyle: inkStyle;
    let minimapStyleIndex: Int32;
    let index: Int32 = 0;
    let count: Int32 = ArraySize(resource.styles);

    while index < count {
      if Equals(resource.styles[index].styleID, n"MiniMapStyle") {
        minimapStyle = resource.styles[index];
        minimapStyleIndex = index;
      };
      index += 1;
    };

    let newProperties: array<inkStyleProperty>;
    for prop in minimapStyle.properties {
      let newProperty: inkStyleProperty;
      newProperty.propertyPath = prop.propertyPath;
      newProperty.value = prop.value;
      if Equals(prop.propertyPath, n"MiniMapStyle.RoadColor") {
        let newReference: inkStylePropertyReference;
        newReference.referencedPath = n"MainColors.DarkBlue";
        newProperty.value = ToVariant(newReference);
      };
      if Equals(prop.propertyPath, n"MiniMapStyle.FloorColor") {
        let newReference: inkStylePropertyReference;
        newReference.referencedPath = n"MainColors.White";
        newProperty.value = ToVariant(newReference);
      };
      if Equals(prop.propertyPath, n"MiniMapStyle.ExteriorWallColor") {
        let newReference: inkStylePropertyReference;
        newReference.referencedPath = n"MainColors.Neutral";
        newProperty.value = ToVariant(newReference);
      };
      if Equals(prop.propertyPath, n"MiniMapStyle.InteriorWallColor") {
        let newReference: inkStylePropertyReference;
        newReference.referencedPath = n"MainColors.Neutral";
        newProperty.value = ToVariant(newReference);
      };
      
      ArrayPush(newProperties, newProperty);
    };

    minimapStyle.properties = newProperties;
    resource.styles[minimapStyleIndex] = minimapStyle;
    this.Log(s"Minimap style patched at index \(minimapStyleIndex), total props: \(ArraySize(newProperties))");
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"Patcher", str);
    };
  }
}
