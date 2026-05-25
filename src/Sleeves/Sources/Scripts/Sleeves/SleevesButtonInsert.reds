@addMethod(gameuiInventoryGameController)
private final func ShowSleevesButton(show: Bool) -> Void {
  ShowSleevesButtonEvent.Send(this.m_player, show);
}

@addMethod(gameuiInventoryGameController)
protected cb func OnShowSleevesPopupEvent(evt: ref<ShowSleevesPopupEvent>) -> Bool {
  let system: ref<SleevesStateSystem> = SleevesStateSystem.Get(this.m_player.GetGame());
  let bundle: ref<SleevesInfoBundle>;

  if !IsDefined(system) {
    return false;
  };

  system.RefreshSleevesState();
  bundle = system.GetInfoBundle();

  if IsDefined(bundle) && ArraySize(bundle.items) > 0 {
    SleevesPopup.Show(this, bundle);
  };
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"default_wrapper") as inkCompoundWidget;
  this.SpawnFromExternal(container, r"base\\gameplay\\gui\\sleeves.inkwidget", n"SleevesButton:SleevesButtonController");
  this.ShowSleevesButton(true);
  RefreshSleevesButtonEvent.Send(this.m_player);
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnItemChooserItemChanged(e: ref<ItemChooserItemChanged>) -> Bool {
  this.ShowSleevesButton(false);
  return wrappedMethod(e);
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
  this.ShowSleevesButton(true);
  return wrappedMethod(userData);
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnCloseMenu(userData: ref<IScriptable>) -> Bool {
  this.ShowSleevesButton(false);
  return wrappedMethod(userData);
}

@addMethod(gameuiInventoryGameController)
protected cb func OnDropQueueUpdatedEventCustom(evt: ref<DropQueueUpdatedEvent>) -> Bool {
  this.ShowSleevesButton(false);
}
