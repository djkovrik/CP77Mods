module ImmersiveTimeskip.Hotkey
import ImmersiveTimeskip.Events.*

public class CustomTimeSkipListener {

  private let player: wref<PlayerPuppet>;

  public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if ListenerAction.IsAction(action, n"immersive_time_skip") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE) {
      this.player.isHoldingTimeSkipButton = true;
    };

    if ListenerAction.IsAction(action, n"immersive_time_skip") && ListenerAction.IsButtonJustReleased(action) {
      if this.player.isHoldingTimeSkipButton {
        this.player.isHoldingTimeSkipButton = false;
      } else {
        if this.player.itsTimeskipActive {
          GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(new InterruptCustomTimeSkipEvent());
        } else {
          GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(new OpenTimeSkipMenuEvent());
        }
      };
    };
  }
}
