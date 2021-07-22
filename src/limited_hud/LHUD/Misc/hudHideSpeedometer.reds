// Hides TPP speedometer widget
@replaceMethod(hudCarController)
protected cb func OnInitialize() -> Bool {
  this.PlayLibraryAnimation(n"intro");
  this.GetRootWidget().SetOpacity(0.0);
}
