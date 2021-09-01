// -- Bottom Left

@addMethod(inkGameController)
public func AdjustWidgetsPositions() -> Void {
  // Minimap
  this.minimapRef.Reparent(this.BottomLeftSlot);
  // Wanted Bar
  this.wantedBarRef.SetTranslation(new Vector2(-260.0, 180.0));
  this.wantedBarRef.Reparent(this.BottomLeftTopSlot);
  // Quest List
  this.questListRef.Reparent(this.TopRightSlot);
  // Vehicle summon
  this.vehicleSummonNotificationRef.SetTranslation(new Vector2(60.0, 320.0));
  // D-pad
  this.dpadHintRef.SetTranslation(new Vector2(0.0, -10.0));
  this.dpadHintRef.Reparent(this.BottomCenterSlot);
  // Input Hunt
  this.inputHintRef.SetTranslation(new Vector2(-25.0, -180.0));
  this.inputHintRef.Reparent(this.TopRightSlot);
  // Car HUD
  this.carHudRef.SetTranslation(new Vector2(-20.0, -100.0));
  this.carHudRef.SetHAlign(inkEHorizontalAlign.Right);
  this.carHudRef.Reparent(this.TopRightSlot);
  // Items notifications
  this.itemsNotificationsRef.SetTranslation(new Vector2(-80.0, -100.0));
}
