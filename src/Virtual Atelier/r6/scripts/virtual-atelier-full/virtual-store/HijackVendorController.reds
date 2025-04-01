import VirtualAtelier.Systems.VirtualAtelierPreviewManager
import VirtualAtelier.UI.VirtualStoreController
import VirtualAtelier.Logs.AtelierLog

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInitialize() -> Bool {
  let root: ref<inkCompoundWidget>;
  if this.GetIsVirtual() {
    root = this.GetRootCompoundWidget();
    root.RemoveAllChildren();
    this.SpawnFromExternal(
      root, 
      r"base\\gameplay\\gui\\virtual_atelier.inkwidget", 
      n"VirtualStore:VirtualAtelier.UI.VirtualStoreController"
    );
  } else {
    wrappedMethod();
  };
}

@addMethod(PlayerPuppet)
public final func ShouldSkipDeviceExit() -> Bool {
  return this.skipDeviceExitHandle;
}

@addMethod(PlayerPuppet)
public final func SetSkipDeviceExit(skip: Bool) -> Void {
  this.skipDeviceExitHandle = skip;
}


@addMethod(FullscreenVendorGameController)
protected cb func OnAtelierCloseVirtualStore(evt: ref<AtelierCloseVirtualStore>) -> Bool {
  ModLog(n"DEBUG", "> OnAtelierCloseVirtualStore");
  if !StatusEffectSystem.ObjectHasStatusEffectWithTag(this.GetPlayerControlledObject(), n"LockInHubMenu") {
    this.m_menuEventDispatcher.SpawnEvent(n"OnBack");
  };
}

@wrapMethod(InteractiveDevice)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let player: ref<PlayerPuppet>;
  if Equals(ListenerAction.GetName(action), n"UI_Exit") {
    player = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
    if player.ShouldSkipDeviceExit() {
      player.SetSkipDeviceExit(false);
      return true;
    };
  };
  
  return wrappedMethod(action, consumer);
}