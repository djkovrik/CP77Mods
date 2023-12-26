import MetroPocketGuide.Navigator.PocketMetroNavigator

@wrapMethod(PocketRadio)
public final func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>, gameplayTags: script_ref<array<CName>>) -> Void {
  wrappedMethod(evt, gameplayTags);

  let navigator: ref<PocketMetroNavigator>;
  if ArrayContains(Deref(gameplayTags), n"MetroRide") {
    navigator = PocketMetroNavigator.GetInstance(this.m_player.GetGame());
    navigator.OnMetroEnter();
  };
}

@wrapMethod(PocketRadio)
public final func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>, gameplayTags: script_ref<array<CName>>) -> Void {
  wrappedMethod(evt, gameplayTags);

  let navigator: ref<PocketMetroNavigator>;
  if ArrayContains(Deref(gameplayTags), n"MetroRide") {
    navigator = PocketMetroNavigator.GetInstance(this.m_player.GetGame());
    navigator.OnMetroExit();
  };
}

// TODO Find better solution maybe?
