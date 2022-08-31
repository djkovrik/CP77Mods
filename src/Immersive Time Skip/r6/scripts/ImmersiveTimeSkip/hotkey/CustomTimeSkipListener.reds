module ImmersiveTimeSkip.Hotkey
import ImmersiveTimeSkip.Events.*

public class CustomTimeSkipListener {

  private let player: ref<PlayerPuppet>;

  public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if ListenerAction.IsAction(action, n"immersive_time_skip") && ListenerAction.IsButtonJustReleased(action) {
      GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(new OpenTimeSkipMenuEvent());
    };
  }
}
