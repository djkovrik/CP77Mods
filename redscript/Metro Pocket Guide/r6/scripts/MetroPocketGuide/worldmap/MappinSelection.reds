@addMethod(BaseWorldMapMappinController)
public final func SelectForRoute() -> Void {
  this.selectionGlow.SetVisible(true);
}

@addMethod(BaseWorldMapMappinController)
public final func DeselectFromRoute() -> Void {
  this.selectionGlow.SetVisible(false);
}

@addMethod(BaseWorldMapMappinController)
public final func IsNotSelectedForRoute() -> Bool {
  return !this.selectionGlow.IsVisible();
}
