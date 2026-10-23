import MetroPocketGuide.Utils.MPGUtils

@addMethod(NcartMetroMapController)
private final func CreateHighlightMarker() -> ref<inkImage> {
    let icon: ref<inkImage> = new inkImage();
    icon.SetName(n"highlight");
    icon.SetAtlasResource(r"base\\gameplay\\gui\\metro_pocket_guide_icons.inkatlas");
    icon.SetTexturePart(n"arrow1");
    icon.SetFitToContent(false);
    icon.SetAnchor(inkEAnchor.CenterLeft);
    icon.SetAnchorPoint(Vector2(0.5, 0.5));
    icon.SetMargin(inkMargin(-24.0, 0.0, 0.0, 0.0));
    icon.SetHAlign(inkEHorizontalAlign.Left);
    icon.SetVAlign(inkEVerticalAlign.Center);
    icon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    icon.BindProperty(n"tintColor", n"MainColors.Blue");
    icon.SetSize(Vector2(30.0, 40.0));
    return icon;
}
