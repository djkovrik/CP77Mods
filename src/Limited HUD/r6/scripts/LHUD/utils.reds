// -- ArchiveXL checker

@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  if NotEquals(GetLocalizedTextByKey(n"Mod-LHUD-Is-Enabled"), "") { return true; };
  this.ShowLHUDWarningAXL();
}

@addField(SingleplayerMenuGameController)
public let lhudCheckedAXL: Bool;

@addMethod(SingleplayerMenuGameController)
private func ShowLHUDWarningAXL() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"warningsAXL") as inkCompoundWidget;
  if !IsDefined(container) {
    container = new inkVerticalPanel();
    container.SetName(n"warningsAXL");
    container.SetHAlign(inkEHorizontalAlign.Fill);
    container.SetVAlign(inkEVerticalAlign.Bottom);
    container.SetAnchor(inkEAnchor.BottomFillHorizontaly);
    container.SetAnchorPoint(0.5, 1.0);
    container.SetMargin(new inkMargin(20.0, 0.0, 0.0, 10.0));
    container.Reparent(root);
  };

  let lhudWarning1: ref<inkText>;
  let lhudWarning2: ref<inkText>;
  if !this.lhudCheckedAXL {
    this.lhudCheckedAXL = true;
    lhudWarning1 = new inkText();
    lhudWarning1.SetName(n"LhudWarning1");
    lhudWarning1.SetText("Limited HUD: resource files not detected!");
    lhudWarning1.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    lhudWarning1.SetFontSize(42);
    lhudWarning1.SetLetterCase(textLetterCase.OriginalCase);
    lhudWarning1.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    lhudWarning1.BindProperty(n"tintColor", n"MainColors.Red");
    lhudWarning1.Reparent(container);

    lhudWarning2 = new inkText();
    lhudWarning2.SetName(n"LhudWarning2");
    lhudWarning2.SetText("-> Please make sure that you have LimitedHUD.archive and .xl files inside your archive\\pc\\mod folder.");
    lhudWarning2.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    lhudWarning2.SetFontSize(38);
    lhudWarning2.SetLetterCase(textLetterCase.OriginalCase);
    lhudWarning2.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    lhudWarning2.BindProperty(n"tintColor", n"MainColors.Blue");
    lhudWarning2.Reparent(container);
  };
}
