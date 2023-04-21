@wrapMethod(ComputerMainLayoutWidgetController)
public func InitializeMenuButtons(gameController: ref<ComputerInkGameController>, widgetsData: array<SComputerMenuButtonWidgetPackage>) -> Void {
  wrappedMethod(gameController, widgetsData);
  inkWidgetRef.SetScale(this.m_menuButtonList, new Vector2(0.85, 0.85));
  inkWidgetRef.SetAnchor(this.m_menuButtonList, inkEAnchor.TopLeft);
  inkWidgetRef.SetAnchorPoint(this.m_menuButtonList, new Vector2(0.0, 0.0));
  inkWidgetRef.SetFitToContent(this.m_menuButtonList, true);
  inkWidgetRef.SetHAlign(this.m_menuButtonList, inkEHorizontalAlign.Fill);
  inkWidgetRef.SetMargin(this.m_menuButtonList, new inkMargin(-100.0, 20.0, 0.0, 0.0));
}
