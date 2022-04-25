import VendorPreview.utils.*

@addField(PlayerPuppet)
public let playerZoneManager: ref<CurrentPlayerZoneManager>;

@addField(AllBlackboardDefinitions)
public let playerZoneManager: wref<CurrentPlayerZoneManager>;

public class CurrentPlayerZoneManager {
  public let gameInstance: GameInstance;
  public let playerPuppet: wref<PlayerPuppet>;

  private func Initialize(gameInstance: GameInstance, puppet: ref<PlayerPuppet>) {
    this.gameInstance = gameInstance;
    this.playerPuppet = puppet;
  }

  public static func CreateInstance(gameInstance: GameInstance, puppet: ref<PlayerPuppet>) -> Void {
    let instance: ref<CurrentPlayerZoneManager> = new CurrentPlayerZoneManager();
    instance.Initialize(gameInstance, puppet);

    let player: ref<PlayerPuppet> = GetPlayer(gameInstance);
    player.playerZoneManager = instance;
    GetAllBlackboardDefs().playerZoneManager = instance;
    // AtelierLog("CurrentPlayerZoneManager initialized");
  }

  public static func GetInstance() -> wref<CurrentPlayerZoneManager> {
    return GetAllBlackboardDefs().playerZoneManager;
  }

  public func IsInDangerZone() -> Bool {
    let bb: ref<IBlackboard> = this.playerPuppet.GetPlayerStateMachineBlackboard();
    let zone: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let inDanger: Bool = zone > 2;
    // AtelierLog(s"Detected zone: \(zone)");
    return inDanger;
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();
  CurrentPlayerZoneManager.CreateInstance(this.GetGame(), this);
}