// -- Bottom Left

@addField(inkGameController)
public let CustomBottomLeftVerticalMinimap: ref<inkVerticalPanel>;

@addField(inkGameController)
public let CustomBottomLeftVerticalWanted: ref<inkVerticalPanel>;

@addMethod(inkGameController)
public func CreateCustomSlots() -> Void {
  this.CustomBottomLeftVerticalMinimap = this.MakeVerticalSlot(
    n"CustomBottomLeftVerticalMinimap",
    new inkMargin(0.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Left,
    inkEVerticalAlign.Bottom,
    inkEAnchor.BottomLeft,
    new Vector2(0.0, 1.0),
    new Vector2(0.0, 1.0)
  );
  this.CustomBottomLeftVerticalMinimap.Reparent(this.RootSlot);

  this.CustomBottomLeftVerticalWanted = this.MakeVerticalSlot(
    n"CustomBottomLeftVertocalWanted",
    new inkMargin(0.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Center,
    inkEVerticalAlign.Top,
    inkEAnchor.CenterFillVerticaly,
    new Vector2(0.5, 0.5),
    new Vector2(0.5, 0.5)
  );
  this.CustomBottomLeftVerticalWanted.Reparent(this.RootSlot);
}

@addMethod(inkGameController)
public func AdjustWidgetsPositions() -> Void {
  this.playerHealthBarRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  this.playerHealthBarRef.SetAnchor(inkEAnchor.TopLeft);
  this.playerHealthBarRef.Reparent(this.RootSlot);
  this.phoneAvatarRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  this.phoneAvatarRef.SetAnchor(inkEAnchor.TopLeft);
  this.phoneAvatarRef.Reparent(this.RootSlot);
  // this.minimapRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  // this.minimapRef.SetAnchor(inkEAnchor.TopLeft);
  // this.minimapRef.Reparent(this.RootSlot);
  this.questListRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  this.questListRef.SetAnchor(inkEAnchor.TopLeft);
  this.questListRef.Reparent(this.RootSlot);
  // this.wantedBarRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  // this.wantedBarRef.SetAnchor(inkEAnchor.TopLeft);
  // this.wantedBarRef.Reparent(this.RootSlot);
  this.vehicleSummonNotificationRef.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  this.vehicleSummonNotificationRef.SetAnchor(inkEAnchor.TopLeft);
  this.vehicleSummonNotificationRef.Reparent(this.RootSlot);
  this.dpadHintRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  this.dpadHintRef.SetAnchor(inkEAnchor.TopLeft);
  this.dpadHintRef.Reparent(this.RootSlot);
  this.inputHintRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  this.inputHintRef.SetAnchor(inkEAnchor.TopLeft);
  this.inputHintRef.Reparent(this.RootSlot);
  this.ammoCounterRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  this.ammoCounterRef.SetAnchor(inkEAnchor.TopLeft);
  this.ammoCounterRef.Reparent(this.RootSlot);
  this.crouchIndicatorRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  this.crouchIndicatorRef.SetAnchor(inkEAnchor.TopLeft);
  this.crouchIndicatorRef.Reparent(this.RootSlot);
  this.itemsNotificationsRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  this.itemsNotificationsRef.SetAnchor(inkEAnchor.TopLeft);
  this.itemsNotificationsRef.Reparent(this.RootSlot);
  this.journalNotificationsRef.SetMargin(0.0, 0.0, 0.0, 0.0);
  this.journalNotificationsRef.SetAnchor(inkEAnchor.TopLeft);
  this.journalNotificationsRef.Reparent(this.RootSlot);

  this.SetWidgetParams(
    this.minimapRef, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Left, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomLeft, 
    new Vector2(0.0, 1.0), 
    new Vector2(0.0, 1.0)
  );
  this.minimapRef.Reparent(this.CustomBottomLeftVerticalMinimap);

  this.SetWidgetParams(
    this.wantedBarRef, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Center, 
    inkEVerticalAlign.Center, 
    inkEAnchor.Centered, 
    new Vector2(0.5, 0.5),
    new Vector2(0.5, 0.5)
  );
  this.wantedBarRef.SetRotation(180.0);
  this.wantedBarRef.Reparent(this.CustomBottomLeftVerticalWanted);

  this.RootSlot.RemoveChild(this.TopLeftMainSlot);
  this.RootSlot.RemoveChild(this.TopRightMainSlot);
  this.RootSlot.RemoveChild(this.BottomCenterSlot);
  this.RootSlot.RemoveChild(this.BottomLeftSlot);
  this.RootSlot.RemoveChild(this.BottomLeftTopSlot);
  this.RootSlot.RemoveChild(this.BottomRightMainSlot);
  this.RootSlot.RemoveChild(this.LeftCenterSlot);
}

// @wrapMethod(MinimapContainerController)
// protected cb func OnInitialize() -> Bool {
//   wrappedMethod();
//   let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
//   let compass: ref<inkWidget> = root.GetWidget(n"MiniMapContainer/compassContainer");
//   let timeText: ref<inkWidget> = root.GetWidget(n"location/unredMessagesGroup");
//   root.GetWidget(n"holder").SetVisible(false);
//   compass.SetMargin(new inkMargin(-40.0, -20.0, 0.0, 0.0));
//   compass.SetHAlign(inkEHorizontalAlign.Left);
//   compass.SetVAlign(inkEVerticalAlign.Bottom);
//   compass.SetAnchor(inkEAnchor.BottomLeft);
//   timeText.SetTranslation(new Vector2(340.0, 0.0));
// }

@wrapMethod(WantedBarGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  root.GetWidget(n"wanted_levels/attention").SetVisible(false);
}