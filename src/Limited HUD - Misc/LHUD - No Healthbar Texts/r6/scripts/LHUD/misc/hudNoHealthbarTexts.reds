// Removes HP and max HP text labels from player healthbar
@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.GetRootCompoundWidget().GetWidget(n"buffsHolder/healthNumberContainer").SetVisible(false);
}
