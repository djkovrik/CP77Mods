@addField(MinimapContainerController)
public let m_districtName: ref<inkText>;

@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget() as inkCompoundWidget;

  let container: ref<inkCanvas> = new inkCanvas();
  container.SetHAlign(inkEHorizontalAlign.Fill);
  container.SetVAlign(inkEVerticalAlign.Bottom);
  container.SetAnchor(inkEAnchor.BottomFillHorizontaly);
  container.SetAnchorPoint(0.0, 1.0);
  container.SetSize(450.0, 34.0);
  container.SetFitToContent(true);
  container.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  container.Reparent(root);

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

  wrappedMethod();
}

@wrapMethod(MinimapContainerController)
protected cb func OnLocationUpdated(value: String) -> Bool {
  wrappedMethod(value);
  this.m_districtName.SetText(value);
}
