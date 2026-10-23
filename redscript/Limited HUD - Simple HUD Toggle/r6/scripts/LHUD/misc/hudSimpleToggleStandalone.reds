module LimitedHudSimpleToggle

public class LHUDToggleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "UI-Settings-KeyBindings")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "UI-Settings-Interface-HUD-HudElementsDescription")
  @runtimeProperty("ModSettings.description", "UI-Settings-Bind")
  public let lhudSimpleToggle: EInputKey = EInputKey.IK_F1;
}

public class ToggleHudEvent extends Event {}

// kudos to psiberx for redscript snippets
public class SimpleToggleGlobalInputListener {
    private let m_uiSystem: ref<UISystem>;
    private let m_config: ref<LHUDToggleConfig>;

    public func SetUISystem(system: ref<UISystem>) -> Void {
      this.m_uiSystem = system;
      this.m_config = new LHUDToggleConfig();
    }

    protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
      if ListenerAction.IsAction(action, n"LHUD_Toggle") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
        this.m_uiSystem.QueueEvent(new ToggleHudEvent());
      };
    }
}

@addMethod(inkGameController)
protected cb func OnToggleHud(evt: ref<ToggleHudEvent>) -> Bool {
  let system: ref<inkSystem>;
  let root: ref<inkCompoundWidget>;
  let isVisible: Bool;
  if this.IsA(n"gameuiRootHudGameController") {
    system = GameInstance.GetInkSystem();
    root = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
    isVisible = root.IsVisible();
    root.SetVisible(!isVisible);
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
