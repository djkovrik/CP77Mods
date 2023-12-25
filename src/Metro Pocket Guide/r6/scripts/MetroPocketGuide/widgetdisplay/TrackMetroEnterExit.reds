import MetroPocketGuide.Config.MetroPocketGuideConfig
import MetroPocketGuide.Navigator.PocketMetroNavigator

@wrapMethod(PocketRadio)
public final func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>, gameplayTags: script_ref<array<CName>>) -> Void {
  wrappedMethod(evt, gameplayTags);

  let uiSystem: ref<UISystem>;
  let config: ref<MetroPocketGuideConfig>;
  if ArrayContains(Deref(gameplayTags), n"MetroRide") {
    MetroLog("Metro ride started");
    config = new MetroPocketGuideConfig();
    uiSystem = GameInstance.GetUISystem(this.m_player.GetGame());
    if config.visibleByDefault {
      uiSystem.QueueEvent(new ShowPocketGuideWidgetEvent());
      uiSystem.QueueEvent(new HidePocketGuideInputHintsEvent());
    } else {
      uiSystem.QueueEvent(new HidePocketGuideWidgetEvent());
      uiSystem.QueueEvent(new ShowPocketGuideInputHintsEvent());
    };
  };
}

@wrapMethod(PocketRadio)
public final func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>, gameplayTags: script_ref<array<CName>>) -> Void {
  wrappedMethod(evt, gameplayTags);

  let uiSystem: ref<UISystem>;
  let navigator: ref<PocketMetroNavigator>;
  if ArrayContains(Deref(gameplayTags), n"MetroRide") {
    MetroLog("Metro ride stopped");
    uiSystem = GameInstance.GetUISystem(this.m_player.GetGame());
    navigator = PocketMetroNavigator.GetInstance(this.m_player.GetGame());
    uiSystem.QueueEvent(new HidePocketGuideWidgetEvent());
    uiSystem.QueueEvent(new ClearPocketGuideInputHintsEvent());
    navigator.CheckForRouteEnd();
  };
}
