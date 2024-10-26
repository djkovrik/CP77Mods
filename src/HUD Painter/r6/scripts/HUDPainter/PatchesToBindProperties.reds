module HudPainter

// Bind minimap colors
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

// Bind xp bars
@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let expWidgets: array<ref<inkWidget>>;

  let bar1: ref<inkWidget> = root.GetWidgetByPathName(n"buffsHolder/barsLayout/xpBar/exp_bar_cotianer/exp_bar_full");
  let bar2: ref<inkWidget> = root.GetWidgetByPathName(n"buffsHolder/barsLayout/xpBar/flugg_stripes_exp/bar");
  let exp1: ref<inkWidget> = root.GetWidgetByPathName(n"buffsHolder/barsLayout/xpBar/exp_bar_cotianer/textpos/xp_text/exp_value_plus");
  let exp2: ref<inkWidget> = root.GetWidgetByPathName(n"buffsHolder/barsLayout/xpBar/exp_bar_cotianer/textpos/xp_text/exp_value");
  let exp3: ref<inkWidget> = root.GetWidgetByPathName(n"buffsHolder/barsLayout/xpBar/exp_bar_cotianer/textpos/xp_text/exp_value_label");
  ArrayPush(expWidgets, bar1);
  ArrayPush(expWidgets, bar2);
  ArrayPush(expWidgets, exp1);
  ArrayPush(expWidgets, exp2);
  ArrayPush(expWidgets, exp3);

  for widget in expWidgets {
    widget.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    widget.BindProperty(n"tintColor", n"MainColors.NPC_Chatter");
  };
}

// Bind xp bar in character menu
@wrapMethod(MenuHubGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let expWidgets: array<ref<inkWidget>>;

  let bar1: ref<inkWidget> = root.GetWidgetByPathName(n"topPanels/holder/left_holder/level_holder/text_holder/expBarWrapper/bars");
  let bar2: ref<inkWidget> = root.GetWidgetByPathName(n"topPanels/holder/left_holder/level_holder/text_holder/expBarWrapper/barWrapper/bar");
  let bar3: ref<inkWidget> = root.GetWidgetByPathName(n"topPanels/holder/left_holder/level_holder/text_holder/expBarWrapper/barWrapper/thumb");
  ArrayPush(expWidgets, bar1);
  ArrayPush(expWidgets, bar2);
  ArrayPush(expWidgets, bar3);

  for widget in expWidgets {
    widget.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    widget.BindProperty(n"tintColor", n"MainColors.NPC_Chatter");
  };
}

// Bind attribute text value
@wrapMethod(NewPerksCategoriesGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let attrValues: array<ref<inkWidget>>;

  let body: ref<inkWidget> = root.GetWidgetByPathName(n"attributes_canvas/body/attribute_button/container/wrapper/itemWrapper/itemContentWrapper/detailsWrapper/levelWrapper/value");
  let reflexes: ref<inkWidget> = root.GetWidgetByPathName(n"attributes_canvas/reflexes/attribute_button/container/wrapper/itemWrapper/itemContentWrapper/detailsWrapper/levelWrapper/value");
  let tech: ref<inkWidget> = root.GetWidgetByPathName(n"attributes_canvas/technical_ability/attribute_button/container/wrapper/itemWrapper/itemContentWrapper/detailsWrapper/levelWrapper/value");
  let intelligence: ref<inkWidget> = root.GetWidgetByPathName(n"attributes_canvas/intelligence/attribute_button/container/wrapper/itemWrapper/itemContentWrapper/detailsWrapper/levelWrapper/value");
  let cool: ref<inkWidget> = root.GetWidgetByPathName(n"attributes_canvas/cool/attribute_button/container/wrapper/itemWrapper/itemContentWrapper/detailsWrapper/levelWrapper/value");
  ArrayPush(attrValues, body);
  ArrayPush(attrValues, reflexes);
  ArrayPush(attrValues, tech);
  ArrayPush(attrValues, intelligence);
  ArrayPush(attrValues, cool);

  for widget in attrValues {
    widget.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    widget.BindProperty(n"tintColor", n"MainColors.NPC_Chatter");
  };
}

// Vehicle weapon roster divider
// Colored with colors interpolator so bind props after animation end
@addField(WeaponRosterGameController)
private let vehicleWeaponDivider: wref<inkWidget>;

@wrapMethod(WeaponRosterGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.vehicleWeaponDivider = this.GetRootCompoundWidget().GetWidgetByPathName(n"/vehicle_container/weapon_container/divider_line");
  this.vehicleWeaponDivider.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
}

@wrapMethod(WeaponRosterGameController)
private final func Fold() -> Void {
  wrappedMethod();
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnFoldEndCustom");
  };
}

@addMethod(WeaponRosterGameController)
protected cb func OnFoldEndCustom(proxy: ref<inkAnimProxy>) -> Bool {
  this.vehicleWeaponDivider.UnbindProperty(n"tintColor");
  this.vehicleWeaponDivider.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnFoldEndCustom");
  };
}

@wrapMethod(WeaponRosterGameController)
private final func Unfold() -> Void {
  wrappedMethod();
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnUnfoldEndCustom");
  };
}

@addMethod(WeaponRosterGameController)
protected cb func OnUnfoldEndCustom(proxy: ref<inkAnimProxy>) -> Bool {
  this.vehicleWeaponDivider.UnbindProperty(n"tintColor");
  this.vehicleWeaponDivider.BindProperty(n"tintColor", n"MainColors.ActiveRed");
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnUnfoldEndCustom");
  };
}

// Vehicle control camera - TODO check why inkstyle does not work
@wrapMethod(RemoteControlDrivingHUDGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let overlay: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"Overlay") as inkCompoundWidget;
  let indexes: array<Int32> = [ 3, 9, 15, 22, 23, 24, 25, 26, 27 ];
  for index in indexes {
    overlay.GetWidgetByIndex(index).BindProperty(n"tintColor", n"MainColors.CombatRed");
  };

  let fncs: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"Overlay/fncs") as inkCompoundWidget;
  let i: Int32 = 0;
  let count: Int32 = fncs.GetNumChildren();
  while i < count {
    fncs.GetWidgetByIndex(i).BindProperty(n"tintColor", n"MainColors.CombatRed");
    i += 1;
  };
}
