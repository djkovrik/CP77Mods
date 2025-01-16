module HUDrag
import Codeware.UI.VirtualResolutionWatcher

public class HUDitorWatcher extends ScriptableSystem {

  private let watcher: ref<VirtualResolutionWatcher>;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    if !IsDefined(this.watcher) {
      this.watcher = new VirtualResolutionWatcher();
      this.watcher.Initialize(request.owner.GetGame());
    };
  }

  public final static func Get(gi: GameInstance) -> ref<HUDitorWatcher> {
    let system: ref<HUDitorWatcher> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"HUDrag.HUDitorWatcher") as HUDitorWatcher;
    return system;
  }

  public final func AddTarget(target: ref<inkWidget>) -> Void {
    this.watcher.ScaleWidget(target);
  }
}
