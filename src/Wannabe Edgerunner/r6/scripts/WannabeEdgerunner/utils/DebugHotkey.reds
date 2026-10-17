module Edgerunning.Common
import Edgerunning.System.*

@if(ModuleExists("WannabeEdgerunnerDebug"))
public class WannabeEdgerunnerDebugListener {

  // Runs debug action with F1 hotkey
  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if ListenerAction.IsAction(action, n"restore_default_settings") && ListenerAction.IsButtonJustReleased(action) {
      let system: ref<EdgerunningSystem> = EdgerunningSystem.GetInstance(GetGameInstance());
      E(s"System defined: \(IsDefined(system))");
    system.AddHumanityDamage(10.0);
    system.InvalidateCurrentState(false);
    // system.RunPrePsychosisFlow();
    // system.RunPsychosisFlow();
    // system.RunPostPsychosisFlow();
    };
  }
}

@if(ModuleExists("WannabeEdgerunnerDebug"))
@addField(PlayerPuppet)
private let weDebugListener: ref<WannabeEdgerunnerDebugListener>;

@if(ModuleExists("WannabeEdgerunnerDebug"))
@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();
    this.weDebugListener = new WannabeEdgerunnerDebugListener();
    this.RegisterInputListener(this.weDebugListener);
}

@if(ModuleExists("WannabeEdgerunnerDebug"))
@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();
    this.UnregisterInputListener(this.weDebugListener);
    this.weDebugListener = null;
}
