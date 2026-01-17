class HudPainterModSettings {
  @runtimeProperty("ModSettings.mod", "Mod-HudPainter-Name")
  @runtimeProperty("ModSettings.category", "UI-Shards-Others")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-HudPainter-HideMenuItem")
  @runtimeProperty("ModSettings.description", "Mod-HudPainter-HideMenuItem-Desc")
  public let hideMenuIntegration: Bool = false;
}

// Based on mod settings scenario, kudos to Jack Humbert ^=^
public class MenuScenario_HudPainter extends MenuScenario_PreGameSubMenu {

  public cb func OnEnterScenario(prevScenario: CName, userData: ref<IScriptable>) -> Bool {
    super.OnEnterScenario(prevScenario, userData);
    this.GetMenusState().OpenMenu(n"hud_painter", userData);
  }

  public cb func OnLeaveScenario(nextScenario: CName) -> Bool {
    super.OnLeaveScenario(nextScenario);
    this.GetMenusState().CloseMenu(n"hud_painter");
  }

  public func OnSubmenuOpen() -> Void {
    this.GetMenusState().CloseMenu(n"hud_painter");
  }

  protected cb func OnSettingsBack() -> Bool {
    this.CloseHudPainter(false);
  }

  protected cb func OnCloseHudPainterScreen() -> Bool {
    this.CloseHudPainter(true);
  }

  private final func CloseHudPainter(forceClose: Bool) -> Void {
    let menuState: wref<inkMenusState> = this.GetMenusState();
    if forceClose {
      menuState.CloseMenu(n"hud_painter");
      if NotEquals(this.m_currSubMenuName, n"") {
        if !menuState.DispatchEvent(this.m_currSubMenuName, n"OnBack") {
          this.CloseSubMenu();
        };
      } else {
        this.SwitchToScenario(this.m_prevScenario);
      };
    } else {
      menuState.DispatchEvent(n"hud_painter", n"OnBack");
    };
  }

  protected cb func OnMainMenuBack() -> Bool {
    this.SwitchToScenario(this.m_prevScenario);
  }
}

@addMethod(MenuScenario_SingleplayerMenu)
protected cb func OnOpenHudPainter() -> Bool {
  this.CloseSubMenu();
  this.SwitchToScenario(n"MenuScenario_HudPainter");
}

@addMethod(MenuScenario_PauseMenu)
protected cb func OnOpenHudPainter() -> Bool {
  this.CloseSubMenu();
  this.SwitchToScenario(n"MenuScenario_HudPainter");
}


class InsertHudPainterMenuItem extends ScriptableService {

  private cb func OnLoad() {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/Ready", this, n"OnMenuResourceReady")
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\fullscreen\\menu.inkmenu"))
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\fullscreen\\main_menu\\pregame_menu.inkmenu"));
  }

  private cb func OnMenuResourceReady(event: ref<ResourceEvent>) {
    let resource: ref<inkMenuResource> = event.GetResource() as inkMenuResource;

    let newMenuEntry: inkMenuEntry;
    newMenuEntry.depth = 100u;
    newMenuEntry.spawnMode = inkSpawnMode.SingleAndMultiplayer;
    newMenuEntry.isAffectedByFadeout = true;
    newMenuEntry.menuWidget *= r"base\\gameplay\\gui\\hud_painter.inkwidget";
    newMenuEntry.name = n"hud_painter";

    ArrayPush(resource.menusEntries, newMenuEntry);
    ArrayPush(resource.scenariosNames, n"MenuScenario_HudPainter");
  }
}

@addField(SingleplayerMenuGameController)
private let missingArchivePopup: ref<inkGameNotificationToken>;

@wrapMethod(SingleplayerMenuGameController)
private func PopulateMenuItemList() {
  wrappedMethod();

  let depot: ref<ResourceDepot> = GameInstance.GetResourceDepot();
  if depot.ArchiveExists("HUDPainter.archive") {
    let config: ref<HudPainterModSettings> = new HudPainterModSettings();
    if !config.hideMenuIntegration {
      this.AddMenuItem(GetLocalizedTextByKey(n"Mod-HudPainter-Name"), n"OnOpenHudPainter");
    }
  } else {
    if !IsDefined(this.missingArchivePopup) {
      this.missingArchivePopup = HudPainterMissingArchivePopup.Show(this);
      this.missingArchivePopup.RegisterListener(this, n"OnMissingArchivePopupClosed");
    };
  };
}

@addMethod(SingleplayerMenuGameController)
protected cb func OnMissingArchivePopupClosed(data: ref<inkGameNotificationData>) {
    this.missingArchivePopup = null;
}

@wrapMethod(PauseMenuGameController)
private func PopulateMenuItemList() {
  wrappedMethod();

  let config: ref<HudPainterModSettings> = new HudPainterModSettings();
  if !config.hideMenuIntegration {
    this.AddMenuItem(GetLocalizedTextByKey(n"Mod-HudPainter-Name"), n"OnOpenHudPainter");
  }
}
