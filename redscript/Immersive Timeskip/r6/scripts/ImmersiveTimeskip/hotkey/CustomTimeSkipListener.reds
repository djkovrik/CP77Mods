module ImmersiveTimeskip.Hotkey
import ImmersiveTimeskip.Events.*
import ImmersiveTimeskip.Config.*

public class CustomTimeSkipListener {

  private let player: wref<PlayerPuppet>;
  private let config: ref<ITSHotkeyConfig>;

  public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
    this.config = new ITSHotkeyConfig();
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let lastUsedPad: Bool = this.player.PlayerLastUsedPad();
    let isMountedToVehicle: Bool = VehicleComponent.IsMountedToVehicle(this.player.GetGame(), this.player);

    let launchFromPress: Bool = ListenerAction.IsAction(action, n"immersive_time_skip") 
      && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED)
      && !this.player.itsTimeskipActive
      && !lastUsedPad;

    let launchFromHold: Bool = ListenerAction.IsAction(action, n"immersive_time_skip") 
      && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE)
      && !this.player.itsTimeskipActive;
    
    let shouldInterruptByPress: Bool = ListenerAction.IsAction(action, n"immersive_time_skip") 
      && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED)
      && this.player.itsTimeskipActive
      && !isMountedToVehicle;

    let shouldInterruptByHold: Bool = ListenerAction.IsAction(action, n"immersive_time_skip") 
      && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE)
      && this.player.itsTimeskipActive
      && isMountedToVehicle;

    // KBM & not in vehicle
    if launchFromPress && !isMountedToVehicle {
      GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(new OpenTimeSkipMenuEvent());
    };

    // KBM && in vehicle or gamepad
    if launchFromHold && (isMountedToVehicle || lastUsedPad) {
      GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(new OpenTimeSkipMenuEvent());
    };

    if shouldInterruptByPress || shouldInterruptByHold {
      GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(new InterruptCustomTimeSkipEvent());
    };
  }
}
