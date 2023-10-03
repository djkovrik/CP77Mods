module ImmersiveTimeskip.Hotkey
import ImmersiveTimeskip.Events.*

public class CustomTimeSkipListener {

  private let player: wref<PlayerPuppet>;

  public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let lastUsedPad: Bool = this.player.PlayerLastUsedPad();

    let launchFromPad: Bool = ListenerAction.IsAction(action, n"immersive_time_skip") 
      && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE)
      && !this.player.itsTimeskipActive
      && lastUsedPad;
    
    let launchFromKeyboard: Bool = ListenerAction.IsAction(action, n"immersive_time_skip") 
      && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED)
      && !this.player.itsTimeskipActive
      && !lastUsedPad;
    
    let shouldInterrupt: Bool = ListenerAction.IsAction(action, n"immersive_time_skip") 
      && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED)
      && this.player.itsTimeskipActive;

    if launchFromPad || launchFromKeyboard {
      GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(new OpenTimeSkipMenuEvent());
    };

    if shouldInterrupt {
      GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(new InterruptCustomTimeSkipEvent());
    };
  }
}
