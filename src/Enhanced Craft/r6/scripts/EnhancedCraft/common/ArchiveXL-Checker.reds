// -- AXL checker

@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  if !GameInstance.GetResourceDepot().ArchiveExists("EnhancedCraft.archive") {
    this.ShowECraftWarningAXL();
  };
}


@addMethod(SingleplayerMenuGameController)
private func ShowECraftWarningAXL() -> Void {
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

  let ecraftWarning1: ref<inkText> = new inkText();
  ecraftWarning1 = new inkText();
  ecraftWarning1.SetName(n"EcraftWarning1");
  ecraftWarning1.SetText("Enhanced Craft: resource files not detected!");
  ecraftWarning1.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  ecraftWarning1.SetFontSize(42);
  ecraftWarning1.SetLetterCase(textLetterCase.OriginalCase);
  ecraftWarning1.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  ecraftWarning1.BindProperty(n"tintColor", n"MainColors.Red");
  ecraftWarning1.Reparent(container);

  let ecraftWarning2: ref<inkText> = new inkText();
  ecraftWarning2 = new inkText();
  ecraftWarning2.SetName(n"EcraftWarning2");
  ecraftWarning2.SetText("-> Please make sure that you have EnhancedCraft.archive and .xl files inside your archive\\pc\\mod folder.");
  ecraftWarning2.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  ecraftWarning2.SetFontSize(38);
  ecraftWarning2.SetLetterCase(textLetterCase.OriginalCase);
  ecraftWarning2.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  ecraftWarning2.BindProperty(n"tintColor", n"MainColors.Blue");
  ecraftWarning2.Reparent(container);
}
