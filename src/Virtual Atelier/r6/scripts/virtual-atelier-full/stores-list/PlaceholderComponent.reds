module VirtualAtelier.UI

public class PlaceholderComponent extends inkComponent {

  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkVerticalPanel> = new inkVerticalPanel();
    root.SetName(n"Root");
    root.SetAnchor(inkEAnchor.Centered);
    root.SetAnchorPoint(new Vector2(0.5, 0.5));

    let icon: ref<inkImage> = new inkImage();
    icon.SetName(n"logo");
    icon.SetAtlasResource(r"base\\gameplay\\gui\\virtual_atelier.inkatlas");
    icon.SetTexturePart(n"h_logo");
    icon.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    icon.SetSize(506.0, 101.0);
    icon.SetHAlign(inkEHorizontalAlign.Center);
    icon.SetVAlign(inkEVerticalAlign.Fill);
    icon.Reparent(root);

    let underConstruction: ref<inkText> = new inkText();
    underConstruction.SetName(n"underConstruction");
    underConstruction.SetText(GetLocalizedTextByKey(n"VA-Under-Construction"));
    underConstruction.SetFitToContent(true);
    underConstruction.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    underConstruction.SetFontStyle(n"Regular");
    underConstruction.SetFontSize(64);
    underConstruction.SetInteractive(true);
    underConstruction.SetLetterCase(textLetterCase.OriginalCase);
    underConstruction.SetMargin(new inkMargin(48.0, 96.0, 48.0, 0.0));
    underConstruction.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    underConstruction.BindProperty(n"tintColor", n"MainColors.Gold");
    underConstruction.Reparent(root);

    return root;
  }
}