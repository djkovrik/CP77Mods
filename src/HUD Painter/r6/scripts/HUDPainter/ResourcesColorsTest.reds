class UpdateMainColorsTest extends ScriptableService {
  private cb func OnLoad() {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/Loaded", this, n"OnStyleLoaded")
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\common\\main_colors.inkstyle"));
  }

  private cb func OnStyleLoaded(event: ref<ResourceEvent>) {
    // let resource: ref<inkStyleResource> = event.GetResource() as inkStyleResource;

    // let newProperty: inkStyleProperty;
    // newProperty.propertyPath = n"MainColors.Red";
    // let newColor: HDRColor = new HDRColor(1.0, 1.0, 1.0, 1.0);
    // newProperty.value = ToVariant(newColor);
    // resource.styles[0].properties[0] = newProperty;
    // let newStyles: array<inkStyle> = resource.styles;
    // let firstStyle: inkStyle = resource.styles[0];
    // let newStyle: inkStyle;
    // let newStyleProperties: array<inkStyleProperty>;

    // newStyle.state = firstStyle.state;
    // newStyle.styleID = firstStyle.styleID;

    // for property in firstStyle.properties {
    //   let newProperty: inkStyleProperty;
    //   newProperty.propertyPath = property.propertyPath;
    //   FTLog(s"Handle \(property.propertyPath)");
    //   let newColor = new HDRColor(1.0, 1.0, 1.0, 1.0);
    //   newProperty.value = ToVariant(newColor);
    //   ArrayPush(newStyleProperties, newProperty);
    // };

    // newStyle.properties = newStyleProperties;
    // newStyles[0] = newStyle;
    // resource.styles = newStyles;
  }
}
