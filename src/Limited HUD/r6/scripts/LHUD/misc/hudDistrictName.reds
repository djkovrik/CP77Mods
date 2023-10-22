import LimitedHudConfig.MinimapModuleConfig

@addField(MinimapContainerController)
public let m_districtContainer: ref<inkWidget>;

@addField(MinimapContainerController)
public let m_districtName: ref<inkText>;

@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  let config: ref<MinimapModuleConfig> = new MinimapModuleConfig();
  if config.ShowCurrentDistrict {
    this.InitDistrictLabel();
  };
  
  wrappedMethod();
}

@if(!ModuleExists("e3hud"))
@addMethod(MinimapContainerController)
private func InitDistrictLabel() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget() as inkCompoundWidget;
  let isJohnny: Bool = this.IsPlayingAsJohnny();
  if isJohnny { return ; }

  let container: ref<inkCanvas> = new inkCanvas();
  container.SetHAlign(inkEHorizontalAlign.Fill);
  container.SetVAlign(inkEVerticalAlign.Bottom);
  container.SetAnchor(inkEAnchor.BottomFillHorizontaly);
  container.SetAnchorPoint(0.0, 1.0);
  container.SetSize(450.0, 34.0);
  container.SetFitToContent(true);
  container.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  container.Reparent(root);

  this.m_districtContainer = container;

  let background: ref<inkRectangle> = new inkRectangle();
  background.SetAnchor(inkEAnchor.Fill);
  background.SetHAlign(inkEHorizontalAlign.Fill);
  background.SetVAlign(inkEVerticalAlign.Fill);
  background.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  background.BindProperty(n"tintColor", n"MainColors.Blue");
  background.Reparent(container);

  let text: ref<inkText> = new inkText();
  text.SetName(n"CustomDistrictLabel");
  text.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  text.SetFontStyle(n"Bold");
  text.SetFontSize(30);
  text.SetFitToContent(true);
  text.SetHAlign(inkEHorizontalAlign.Center);
  text.SetVAlign(inkEVerticalAlign.Center);
  text.SetAnchor(inkEAnchor.Centered);
  text.SetAnchorPoint(0.5, 0.5);
  text.SetLetterCase(textLetterCase.OriginalCase);
  text.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  text.BindProperty(n"tintColor", n"MainColors.DarkRed");
  text.Reparent(container);

  this.m_districtName = text;
}

@if(ModuleExists("e3hud"))
@addMethod(MinimapContainerController)
private func InitDistrictLabel() {
  
}

@wrapMethod(MinimapContainerController)
protected cb func OnLocationUpdated(value: String) -> Bool {
  wrappedMethod(value);

  if IsDefined(this.m_districtName) {
    this.m_districtName.SetText(value);
  };
}

@wrapMethod(MinimapContainerController)
private final func SecurityZoneUpdate() -> Void {
  wrappedMethod();

  let isJohnny: Bool = this.IsPlayingAsJohnny();
  let visible: Bool = !this.m_playerInCombat && this.m_inPublicOrRestrictedZone && !isJohnny;
  if IsDefined(this.m_districtContainer) {
    this.m_districtContainer.SetVisible(visible);
  };
}

@wrapMethod(MinimapContainerController)
protected cb func OnPSMCombatChanged(psmCombatArg: gamePSMCombat) -> Bool {
  wrappedMethod(psmCombatArg);

  let isJohnny: Bool = this.IsPlayingAsJohnny();
  let visible: Bool = !this.m_playerInCombat && this.m_inPublicOrRestrictedZone && !isJohnny;
  if IsDefined(this.m_districtContainer) {
    this.m_districtContainer.SetVisible(visible);
  };
}

@addMethod(MinimapContainerController)
private final func IsPlayingAsJohnny() -> Bool {
  let player: wref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
  if !IsDefined(player) { return false; };
  let localPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(player.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  let factName: String = GameInstance.GetPlayerSystem(player.GetGame()).GetPossessedByJohnnyFactName();
  return localPuppet.IsJohnnyReplacer() || GameInstance.GetQuestsSystem(player.GetGame()).GetFactStr(factName) == 1;
}
