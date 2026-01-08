module RevisedBackpack

class InsertBetterBackpackMenuItem extends ScriptableService {

  private cb func OnLoad() {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/Ready", this, n"OnMenuResourceReady")
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\fullscreen\\menu.inkmenu"));
  }

  private cb func OnMenuResourceReady(event: ref<ResourceEvent>) {
    let resource: ref<inkMenuResource> = event.GetResource() as inkMenuResource;

    let newMenuEntry: inkMenuEntry;
    newMenuEntry.depth = 0u;
    newMenuEntry.spawnMode = inkSpawnMode.SingleAndMultiplayer;
    newMenuEntry.isAffectedByFadeout = true;
    newMenuEntry.menuWidget *= r"base\\gameplay\\gui\\fullscreen\\inventory\\revised_backpack.inkwidget";
    newMenuEntry.name = n"revised_backpack";

    ArrayPush(resource.menusEntries, newMenuEntry);
  }
}

@wrapMethod(MenuHubLogicController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.AddRevisedBackpackMenuItem();
}

@addMethod(MenuHubLogicController)
private final func AddRevisedBackpackMenuItem() -> Void {
  let isInComaQuest: Bool = HubMenuUtility.IsPlayerHardwareDisabled(GetPlayer(GetGameInstance()));
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"mainMenu/buttonsContainer/panel_inventory") as inkCompoundWidget;
  let improvedBackpackItem: ref<inkWidget> = this.SpawnFromLocal(container, n"menu_button");
  improvedBackpackItem.SetMargin(inkMargin(0.0, 510.0, 0.0, 0.0));
  
  let data: MenuData;
  data.disabled = isInComaQuest;
  data.fullscreenName = n"revised_backpack";
  data.identifier = 42;
  data.parentIdentifier = 3;
  data.label = GetLocalizedTextByKey(n"Mod-Revised-Mod-Name");
  data.icon = n"ico_backpack";

  let controller: ref<MenuItemController> = improvedBackpackItem.GetController() as MenuItemController;
  controller.Init(data);
}
