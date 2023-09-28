@addField(MinimapContainerController)
public let m_districtContainer: ref<inkWidget>;

@addField(MinimapContainerController)
public let m_districtName: ref<inkText>;

@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  this.InitDistrictLabel();
  wrappedMethod();
}

@if(!ModuleExists("e3hud"))
@addMethod(MinimapContainerController)
private func InitDistrictLabel() {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget() as inkCompoundWidget;
  let player: wref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
  let isJohnny: Bool = false;
  
  if IsDefined(player) {
    isJohnny = player.IsJohnnyReplacer();
  };

  if !isJohnny {
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
  };
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

  let player: wref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
  if !IsDefined(player) { return ; };
  let isJohnny: Bool = player.IsJohnnyReplacer();
  let visible: Bool = !this.m_playerInCombat && this.m_inPublicOrRestrictedZone && !isJohnny;
  if IsDefined(this.m_districtContainer) {
    this.m_districtContainer.SetVisible(visible);
  };
}

@wrapMethod(MinimapContainerController)
protected cb func OnPSMCombatChanged(psmCombatArg: gamePSMCombat) -> Bool {
  wrappedMethod(psmCombatArg);

  let player: wref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
  if !IsDefined(player) { return false; };
  let isJohnny: Bool = player.IsJohnnyReplacer();
  let visible: Bool = !this.m_playerInCombat && this.m_inPublicOrRestrictedZone && !isJohnny;
  if IsDefined(this.m_districtContainer) {
    this.m_districtContainer.SetVisible(visible);
  };
}
