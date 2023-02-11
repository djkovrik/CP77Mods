@wrapMethod(ComputerMainLayoutWidgetController)
public func InitializeMenuButtons(gameController: ref<ComputerInkGameController>, widgetsData: array<SComputerMenuButtonWidgetPackage>) -> Void {
  wrappedMethod(gameController, widgetsData);
  inkWidgetRef.SetScale(this.m_menuButtonList, new Vector2(0.85, 0.85));
}
