// -- ArchiveXL checker
@addField(SingleplayerMenuGameController)
public let archiveXlChecked: Bool;

@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let warning: ref<inkText>;
  let str: String = GetLocalizedTextByKey(n"Mod-LHUD-Is-Enabled");
  if Equals(str, "Mod-LHUD-Is-Enabled") || Equals(str, "") {
    if !this.archiveXlChecked {
      this.archiveXlChecked = true;
      warning = new inkText();
      warning.SetName(n"CustomWarning");
      warning.SetText("Archive XL not detected! Make sure that it was installed correctly.");
      warning.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
      warning.SetFontSize(64);
      warning.SetHAlign(inkEHorizontalAlign.Fill);
      warning.SetVAlign(inkEVerticalAlign.Bottom);
      warning.SetAnchor(inkEAnchor.BottomFillHorizontaly);
      warning.SetAnchorPoint(0.5, 1.0);
      warning.SetLetterCase(textLetterCase.OriginalCase);
      warning.SetMargin(new inkMargin(20.0, 0.0, 0.0, 10.0));
      warning.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
      warning.BindProperty(n"tintColor", n"MainColors.Red");
      warning.Reparent(this.GetRootCompoundWidget());
    };
  };
}
