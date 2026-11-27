module HUDrag
import HUDrag.HUDWidgetsManager.*
import Codeware.UI.VirtualResolutionWatcher

public class HUDitorResolutionWatcher extends VirtualResolutionWatcher {
  private let manager: wref<HUDWidgetsManager>;

  public func Initialize(game: GameInstance) -> Void {
    if this.m_initialized { return; };
    super.Initialize(game);
    this.Register(n"/gameplay/hud");
    this.Register(n"/accessibility/interface");
    this.Register(n"/interface/hudSafezones");
  }

  public func SetManager(manager: ref<HUDWidgetsManager>) -> Void {
    this.manager = manager;
    if IsDefined(manager) && IsDefined(manager.overlay) { manager.overlay.RequestBaseRefresh(); };
  }

  public func ClearManager(manager: ref<HUDWidgetsManager>) -> Void {
    if this.manager == manager { this.manager = null; };
  }

  protected cb func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    super.OnVarModified(groupPath, varName, varType, reason);
    if !IsDefined(this.manager) || this.manager.disposed { return; };
    if Equals(groupPath, n"/video/display") {
      if IsDefined(this.manager.overlay) { this.manager.overlay.RequestBaseRefresh(); };
      return;
    };
    if Equals(reason, ConfigChangeReason.Accepted) && (Equals(varName, n"HudScaling") || Equals(varName, n"HudScaling_Alt") || Equals(varName, n"HudSafezoneHor")) {
      this.manager.RequestPhoneGeometryRefresh();
    };
  }
}

public class HUDitorWatcher extends ScriptableSystem {
  private let watcher: ref<HUDitorResolutionWatcher>;

  public static func Get(gi: GameInstance) -> ref<HUDitorWatcher> {
    return GameInstance.GetScriptableSystemsContainer(gi).Get(n"HUDrag.HUDitorWatcher") as HUDitorWatcher;
  }

  public func Start(manager: ref<HUDWidgetsManager>) -> Void {
    if !IsDefined(this.watcher) {
      this.watcher = new HUDitorResolutionWatcher();
      this.watcher.Initialize(manager.gameInstance);
    };
    this.watcher.SetManager(manager);
  }

  public func Stop(manager: ref<HUDWidgetsManager>) -> Void {
    if IsDefined(this.watcher) { this.watcher.ClearManager(manager); };
  }
}
