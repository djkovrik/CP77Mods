module HUDrag.HUDWidgetsManager

@addField(PlayerPuppet)
public let hudWidgetsManager: ref<HUDWidgetsManager>;

@addField(AllBlackboardDefinitions)
public let hudWidgetsManager: wref<HUDWidgetsManager>;

public class HUDWidgetsManager {
  public let gameInstance: GameInstance;
  public let puppetId: EntityID;

  public let isActive: Bool;
  public let activeWidget: CName;

  public let topRight: ref<inkLogicController>;
  public let bottomLeft: ref<inkLogicController>;

  private func Initialize(gameInstance: GameInstance, puppetId: EntityID, hudGameController: ref<inkGameController>) {
    this.gameInstance = gameInstance;
    this.puppetId = puppetId;

    this.SetHUDEditorListener(hudGameController);
  }

  public static func CreateInstance(puppet: ref<gamePuppet>, hudGameController: ref<inkGameController>) {
    let instance: ref<HUDWidgetsManager> = new HUDWidgetsManager();

    let gameInstance = puppet.GetGame();
    let puppetEntityId = puppet.GetEntityID();

    instance.Initialize(gameInstance, puppetEntityId, hudGameController);

    let player = GetPlayer(gameInstance);
    player.hudWidgetsManager = instance;
    GetAllBlackboardDefs().hudWidgetsManager = instance;
  }

  public static func GetInstance() -> wref<HUDWidgetsManager> {
    return GetAllBlackboardDefs().hudWidgetsManager;
  }

  public func GetPlayerPuppet() -> wref<PlayerPuppet> {
    return GameInstance.FindEntityByID(this.gameInstance, this.puppetId) as PlayerPuppet;
  }

  public static func GetNextWidget(widgetName: CName) -> CName {
    switch widgetName {
      case n"TopRight":
        return n"BottomRight";

      case n"BottomRight":
        return n"BottomLeft";

      case n"BottomLeft":
        return n"TopLeft";

      case n"TopLeft":
        return n"TopLeftPhone";

      default:
        return n"TopRight"; 
    }
  }

  public static func GetPreviousWidget(widgetName: CName) -> CName {
    switch widgetName {
      case n"BottomRight":
        return n"TopRight";

      case n"BottomLeft":
        return n"BottomRight";

      case n"TopLeft":
        return n"BottomLeft";

      case n"TopLeftPhone":
        return n"TopLeft";

      default:
        return n"TopLeftPhone";
    }
  }

  public func SetHUDEditorListener(hudGameController: ref<inkGameController>) -> Void {
    let player: wref<PlayerPuppet> = this.GetPlayerPuppet();

    player.RegisterInputListener(hudGameController, n"ToggleSprint");
    player.RegisterInputListener(hudGameController, n"context_help");
    player.RegisterInputListener(hudGameController, n"world_map_filter_navigation_down");
    player.RegisterInputListener(hudGameController, n"back");
    player.RegisterInputListener(hudGameController, n"cancel");
    player.RegisterInputListener(hudGameController, n"right_button");
    player.RegisterInputListener(hudGameController, n"left_button");
    player.RegisterInputListener(hudGameController, n"CameraMouseX");
    player.RegisterInputListener(hudGameController, n"CameraMouseY");
    player.RegisterInputListener(hudGameController, n"click");
  }

  public func AssignHUDWidgetListeners(hudWidgetController: ref<inkLogicController>) {
    let player: wref<PlayerPuppet> = this.GetPlayerPuppet();

    player.RegisterInputListener(hudWidgetController, n"mouse_wheel");
    player.RegisterInputListener(hudWidgetController, n"CameraMouseX");
    player.RegisterInputListener(hudWidgetController, n"CameraMouseY");
    player.RegisterInputListener(hudWidgetController, n"click");
  }

   public func RemoveHUDWidgetListeners(hudWidgetController: ref<inkLogicController>) {
    let player: wref<PlayerPuppet> = this.GetPlayerPuppet();

    player.UnregisterInputListener(hudWidgetController, n"CameraMouseX");
    player.UnregisterInputListener(hudWidgetController, n"CameraMouseY");
    player.UnregisterInputListener(hudWidgetController, n"mouse_wheel");
    player.UnregisterInputListener(hudWidgetController, n"click");
  }
} 