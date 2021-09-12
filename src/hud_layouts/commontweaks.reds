// Remove crime reported label from wanted bar widget
@wrapMethod(WantedBarGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  root.GetWidget(n"wanted_levels/attention").SetVisible(false);
}

// Remove text label for stamina bar widget
@wrapMethod(StaminabarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.GetRootCompoundWidget().GetWidget(n"staminaMain/stamina_logo").SetVisible(false);
}

// Scale widget size plus remove  widget holder and hp texts
@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let buffs: ref<inkWidget> = root.GetWidget(n"buffsHolder/inkVerticalPanelWidget2/buffs");
  root.GetWidget(n"buffsHolder/holder/holder_code").SetVisible(false);
  root.GetWidget(n"buffsHolder/holder/holder_core").SetVisible(false);
  root.GetWidget(n"buffsHolder/hpTextVert/hp_number_holder").SetVisible(false);
  root.GetWidget(n"buffsHolder/hpbar_fluff").SetVisible(false);
  buffs.SetScale(new Vector2(0.75, 0.75));
  buffs.SetTranslation(new Vector2(-50.0, 0.0));
}

// Remove quest tracker widget holder
@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  root.GetWidget(n"inkVerticalPanelWidget2/QuestTracker/Fluff/AnchorPoint").SetVisible(false);
}

// Shrink most widgets from input call answer button
@wrapMethod(IncomingCallGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let inputAnswer: ref<inkWidget> = root.GetWidget(n"inputAnswer");

  this.SetWidgetParams(
    inputAnswer, 
    new inkMargin(30.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Left, 
    inkEVerticalAlign.Top, 
    inkEAnchor.TopLeft, 
    new Vector2(0.0, 0.0),
    new Vector2(0.0, 0.0)
  );

  root.RemoveAllChildren();
  root.AddChildWidget(inputAnswer);  
}