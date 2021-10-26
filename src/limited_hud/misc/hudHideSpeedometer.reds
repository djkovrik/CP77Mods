// Hides TPP speedometer widget
@wrapMethod(hudCarController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.GetRootWidget().SetOpacity(0.0);
}
