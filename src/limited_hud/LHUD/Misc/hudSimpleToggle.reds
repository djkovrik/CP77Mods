// kudos to psiberx for redscript snippets

/*
  Available keybind names and related hotkeys:
    n"restore_default_settings" for 'F1' hotkey
    n"brightness_settings" for 'Z' hotkey
    n"UI_Unequip" for 'U' hotkey
*/

public static func KeybindName_ToggleHUD() -> String = "brightness_settings"

public class ToggleHudEvent extends Event {}

public class SimpleToggleGlobalInputListener {

    private let m_uiSystem: ref<UISystem>;

    public func SetUISystem(system: ref<UISystem>) -> Void {
      this.m_uiSystem = system;
    }

    protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
        LogChannel(n"DEBUG", ToString(ListenerAction.GetType(action)) + " " + NameToString(ListenerAction.GetName(action)));

        if ListenerAction.IsAction(action, StringToName(KeybindName_ToggleHUD())) && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED)  {
          this.m_uiSystem.QueueEvent(new ToggleHudEvent());
        };
    }
}

@addMethod(inkGameController)
protected cb func OnToggleHud(evt: ref<ToggleHudEvent>) -> Bool {
  let isVisible: Bool;
  if this.IsA(n"gameuiRootHudGameController") {
    isVisible = this.GetRootWidget().IsVisible();
    this.GetRootWidget().SetVisible(!isVisible);
  };
}

@addField(PlayerPuppet)
private let m_simpleToggleInputListener: ref<SimpleToggleGlobalInputListener>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();
    this.m_simpleToggleInputListener = new SimpleToggleGlobalInputListener();
    this.m_simpleToggleInputListener.SetUISystem(GameInstance.GetUISystem(this.GetGame()));
    this.RegisterInputListener(this.m_simpleToggleInputListener);
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();
    this.UnregisterInputListener(this.m_simpleToggleInputListener);
    this.m_simpleToggleInputListener = null;
}