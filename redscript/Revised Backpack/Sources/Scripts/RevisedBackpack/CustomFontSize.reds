module RevisedBackpack

public class RevisedBackpackCustomFontSize extends ScriptableService {
  private let backpackFontSize: Int32 = 36;
  
  private cb func OnLoad() {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/Loaded", this, n"OnStyleLoaded")
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\common\\main_colors.inkstyle"));
  }

  private cb func OnStyleLoaded(event: ref<ResourceEvent>) -> Void {
    let resource: ref<inkStyleResource> = event.GetResource() as inkStyleResource;
    let newStyle: inkStyle = resource.styles[0];
    let newProperties: array<inkStyleProperty> = newStyle.properties;
    let newProperty: inkStyleProperty;
    newProperty.propertyPath = n"MainColors.BackpackRevisedFontSize";
    newProperty.value = ToVariant(this.backpackFontSize);
    ArrayPush(newProperties, newProperty);
    newStyle.properties = newProperties;
    resource.styles[0] = newStyle;
  }
}
