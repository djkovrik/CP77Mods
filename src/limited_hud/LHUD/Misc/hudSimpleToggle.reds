// kudos to psiberx for the events based approach sample

/*
  Available keybind names and related hotkeys:
    "brightness_settings" for 'Z' hotkey
    "UI_Unequip" for 'U' hotkey
*/

public static func KeybindName_ToggleHUD() -> String = "brightness_settings"

public class ToggleHudEvent extends Event {}

@addMethod(inkGameController)
protected cb func OnToggleHud(evt: ref<ToggleHudEvent>) -> Bool {
  let isVisible: Bool;
  if this.IsA(n"gameuiRootHudGameController") {
    isVisible = this.GetRootWidget().IsVisible();
    this.GetRootWidget().SetVisible(!isVisible);
  };
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  wrappedMethod(action, consumer);

  if ListenerAction.IsAction(action, Cast(KeybindName_ToggleHUD())) && ListenerAction.IsButtonJustReleased(action) {
    GameInstance.GetUISystem(this.GetGame()).QueueEvent(new ToggleHudEvent());
  };
}
