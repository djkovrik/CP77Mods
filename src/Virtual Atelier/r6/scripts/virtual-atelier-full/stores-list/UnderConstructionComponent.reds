module VirtualAtelier.UI

public class UnderConstructionComponent extends inkComponent {

  protected cb func OnCreate() -> ref<inkWidget> {
    let underConstruction: ref<inkText> = new inkText();
    underConstruction.SetName(n"underConstruction");
    underConstruction.SetText(GetLocalizedTextByKey(n"VA-Under-Construction"));
    underConstruction.SetFitToContent(true);
    underConstruction.SetAnchor(inkEAnchor.Centered);
    underConstruction.SetAnchorPoint(new Vector2(0.5, 0.5));
    underConstruction.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    underConstruction.SetFontStyle(n"Regular");
    underConstruction.SetFontSize(64);
    underConstruction.SetInteractive(true);
    underConstruction.SetLetterCase(textLetterCase.OriginalCase);
    underConstruction.SetMargin(new inkMargin(48.0, 0.48, 48.0, 48.0));
    underConstruction.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    underConstruction.BindProperty(n"tintColor", n"MainColors.Gold");

    return underConstruction;
  }
}