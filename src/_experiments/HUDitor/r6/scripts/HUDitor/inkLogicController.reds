import HUDrag.HUDWidgetsManager.*

@addField(inkLogicController)
let isMouseDown: Bool;

public class GameSessionInitializedEvent extends Event {}

// Called when gameplay actually starts & widgets are loaded
@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.QueueEvent(new GameSessionInitializedEvent());
}

// Call for a method that's observed in Lua, which then loads widgets' persisted state
@addMethod(inkLogicController)
protected cb func OnGameSessionInitialized(evt: ref<GameSessionInitializedEvent>) -> Bool {
  if this.IsHUDWidget() {
    this.LoadPersistedState();
  }
}

// Used in Lua
@addMethod(inkLogicController)
private func LoadPersistedState() {}

// Used in Lua
@addMethod(inkLogicController)
private func UpdatePersistedState(translation: Vector2, scale: Vector2) {}

// Called from Lua
@addMethod(inkLogicController)
private func SetPersistedState(locationX: Float, locationY: Float, scaleX: Float, scaleY: Float) {
  let persistedTranslation = new Vector2(locationX, locationY);
  let persistedScale = new Vector2(scaleX, scaleY);

  this.GetRootWidget().SetTranslation(persistedTranslation);
  this.GetRootWidget().SetScale(persistedScale);
}

// TopRight - minimap, quest, vehicle summon
// BottomRight - ammo counter and crouch indicator
// BottomLeft - dpad hint
// TopLeft - player health bar
// TopLeftPhone - phone call
// TopRightWanted - wanted bar
// InputHint - input hints
// LeftCenter - item and journal notifications

@addMethod(inkLogicController)
private func IsHUDWidget() -> Bool {
  let widgetName = this.GetRootWidget().GetName();

  if !Equals(widgetName, n"") {
    let hudWidgets = [n"TopRight", n"BottomRight", n"BottomLeft", n"TopLeft", n"TopLeftPhone", n"TopRightWanted", n"InputHint", n"LeftCenter"];

    return ArrayContains(hudWidgets, widgetName);
  } else {
    return false;
  }
}

@addMethod(inkLogicController)
protected cb func OnEnableHUDEditorWidget(event: ref<SetActiveHUDEditorWidget>) -> Bool {
  let widgetName = this.GetRootWidget().GetName();
  let hudEditorWidgetName = event.activeWidget;

  if (this.IsHUDWidget()) {
    if Equals(widgetName, hudEditorWidgetName) {
      this.GetRootWidget().SetOpacity(1);
      this.GetRootWidget().SetVisible(true);
      HUDWidgetsManager.GetInstance().AssignHUDWidgetListeners(this);
    } else {
      this.GetRootWidget().SetOpacity(0.15);
      HUDWidgetsManager.GetInstance().RemoveHUDWidgetListeners(this);
    }
  };
}

@addMethod(inkGameController)
protected cb func OnDisplayPreviewEvent(event: ref<DisplayPreviewEvent>) -> Bool {
  this.ShowIncomingPhoneCall(n"unknown", true);
  this.ShowWantedBar(true);
  this.ShowItemsNotification();
}

@addMethod(inkGameController)
protected cb func OnHidePreviewEvent(event: ref<HidePreviewEvent>) -> Bool {
  this.ShowIncomingPhoneCall(n"unknown", false);
  this.ShowWantedBar(false);
}

@addMethod(inkLogicController)
protected cb func OnDisableHUDEditorWidgets(event: ref<DisableHUDEditor>) -> Bool {
  if this.IsHUDWidget() {
    this.GetRootWidget().SetOpacity(1);
    HUDWidgetsManager.GetInstance().RemoveHUDWidgetListeners(this);
  }
}

@addMethod(inkLogicController)
protected cb func OnResetHUDWidgets(event: ref<ResetAllHUDWidgets>) {
  if this.IsHUDWidget() {
    let widget = this.GetRootWidget();

    if Equals(widget.GetName(), n"LeftCenter") {
      widget.SetTranslation(new Vector2(0.0, 0.0));
      widget.SetScale(new Vector2(0.666667, 0.666667));
    } else {
      widget.SetTranslation(new Vector2(0.0, 0.0));
      widget.SetScale(new Vector2(1.0, 1.0));
    };

    this.UpdatePersistedState(new Vector2(0, 0), new Vector2(1, 1));
  }
}

@addMethod(inkLogicController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let currentInput: Float;

  if Equals(ListenerAction.GetName(action), n"click") {
    if (ListenerAction.IsButtonJustPressed(action)) {
      this.isMouseDown = true;
    }

    if (ListenerAction.IsButtonJustReleased(action)) {
      this.isMouseDown = false;
    }
  }

  if (this.isMouseDown) {
    if Equals(ListenerAction.GetName(action), n"CameraMouseX") {
      currentInput = ListenerAction.GetValue(action);
      
      let currentTranslation = this.GetRootWidget().GetTranslation();
      currentTranslation.X += currentInput * 0.6;
      
      this.GetRootWidget().ChangeTranslation(new Vector2(currentInput * 0.6, 0));
      this.UpdatePersistedState(currentTranslation, this.GetRootWidget().GetScale());
    };

    if Equals(ListenerAction.GetName(action), n"CameraMouseY") {
      currentInput = -ListenerAction.GetValue(action);
      
      let currentTranslation = this.GetRootWidget().GetTranslation();
      currentTranslation.Y += currentInput * 0.6;

      this.GetRootWidget().ChangeTranslation(new Vector2(0, currentInput * 0.6));
      this.UpdatePersistedState(currentTranslation, this.GetRootWidget().GetScale());
    };
  }

  if Equals(ListenerAction.GetName(action), n"mouse_wheel") {
    let widgetName = this.GetRootWidget().GetName();

    if Equals(widgetName, n"TopLeftPhone") {
      return true;
    }

    let amount = ListenerAction.GetValue(action);
    let currentScale = this.GetRootWidget().GetScale();
    let zoomRatio: Float = 0.1;

    let finalXScale = currentScale.X + (amount * zoomRatio);
    let finalYScale = currentScale.Y + (amount * zoomRatio);

    if (finalXScale < 0.1) {
      finalXScale = 0.1;
    }

    if (finalYScale > 5.0) {
      finalYScale = 5.0;
    }

    if (finalYScale < 0.1) {
      finalYScale = 0.1;
    }

    if (finalXScale > 5.0) {
      finalXScale = 5.0;
    }
        
    this.GetRootWidget().SetScale(new Vector2(finalXScale, finalYScale));
    this.UpdatePersistedState(this.GetRootWidget().GetTranslation(), new Vector2(finalXScale, finalYScale));
  };
}

// Widgets previewing stuff

@addMethod(inkGameController)
private func ShowIncomingPhoneCall(name: CName, show: Bool) -> Void {
  if this.IsA(n"HudPhoneGameController") {
    let phoneSystem: ref<PhoneSystem> = GameInstance.GetScriptableSystemsContainer(this.GetPlayerControlledObject().GetGame()).Get(n"PhoneSystem") as PhoneSystem;
    if show {
      phoneSystem.TriggerCall(questPhoneCallMode.Video, false, name, false, questPhoneCallPhase.IncomingCall, true);
    } else {
      phoneSystem.TriggerCall(questPhoneCallMode.Video, false, name, false, questPhoneCallPhase.EndCall, true);    
    };
  };
}

@addMethod(inkGameController)
private func ShowWantedBar(show: Bool) -> Void {
  if this.IsA(n"WantedBarGameController") {
    let controller = this as WantedBarGameController;
    let stars: Int32;
    if show {
      stars = 5;
    } else {
      stars = 0;
    }
    controller.OnWantedDataChange(stars);
  };
}


@addMethod(inkGameController)
private func ShowItemsNotification() -> Void {
  if this.IsA(n"ItemsNotificationQueue") {
    let controller = this as ItemsNotificationQueue;
    controller.m_showDuration = 10.0;
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.Pants_03_rich_01"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.Pants_03_rich_02"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_01"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_02"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_03"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_04"), n"epic");
  };
}
