module MetroPocketGuide.Tracker

public class MetroStationTracker extends ScriptableSystem {

  private let questsSystem: wref<QuestsSystem>;
  private let uiSystem: wref<UISystem>;
  private let ftSystem: wref<FastTravelSystem>;

  private let factMetroStationActive: CName = n"ue_metro_active_station";
  private let factMetroStationNext: CName = n"ue_metro_next_station";
  private let factMetroStationArriving: CName = n"ue_metro_arriving_at_station";
  private let factMetroLineActive: CName = n"ue_metro_track_selected";

  private let metroStationActiveListenerId: Uint32;
  private let metroStationNextListenerId: Uint32;
  private let metroStationArrivingListenerId: Uint32;
  private let metroLineActiveListenerId: Uint32;

  public static func GetInstance(gi: GameInstance) -> ref<MetroStationTracker> {
    let system: ref<MetroStationTracker> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"MetroPocketGuide.Tracker.MetroStationTracker") as MetroStationTracker;
    return system;
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return ;
    };

    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.InitCoreData(player);
      this.RegisterFactListeners();
    };
  }

  private final func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
    this.UnregisterFactListeners();
  }

  private final func InitCoreData(player: ref<PlayerPuppet>) -> Void {
    this.questsSystem = GameInstance.GetQuestsSystem(player.GetGame());
    this.uiSystem = GameInstance.GetUISystem(player.GetGame());
    this.ftSystem = player.GetFastTravelSystem();
  }

  private final func RegisterFactListeners() -> Void {
    this.metroStationActiveListenerId = this.questsSystem.RegisterListener(this.factMetroStationActive, this, n"OnMetroStationActiveChange");
    this.metroStationNextListenerId = this.questsSystem.RegisterListener(this.factMetroStationNext, this, n"OnMetroStationNextChange");
    this.metroStationArrivingListenerId = this.questsSystem.RegisterListener(this.factMetroStationArriving, this, n"OnMetroStationArrivingChange");
    this.metroLineActiveListenerId = this.questsSystem.RegisterListener(this.factMetroLineActive, this, n"OnMetroLineActiveChange");
  }

  private final func UnregisterFactListeners() -> Void {
    this.questsSystem.UnregisterListener(this.factMetroStationActive, this.metroStationActiveListenerId);
    this.questsSystem.UnregisterListener(this.factMetroStationNext, this.metroStationNextListenerId);
    this.questsSystem.UnregisterListener(this.factMetroStationArriving, this.metroStationArrivingListenerId);
    this.questsSystem.UnregisterListener(this.factMetroLineActive, this.metroLineActiveListenerId);
  }

  protected cb func OnMetroStationActiveChange(factValue: Int32) -> Bool {
    MetroLog(s"OnMetroStationActiveChange \(MetroDataHelper.GetLocalizedStationTitleById(factValue))");
  }

  protected cb func OnMetroStationNextChange(factValue: Int32) -> Bool {
    MetroLog(s"OnMetroStationNextChange \(MetroDataHelper.GetLocalizedStationTitleById(factValue))");
  }

  protected cb func OnMetroStationArrivingChange(factValue: Int32) -> Bool {
    if Equals(factValue, 1) {
      MetroLog("Arriving");
    } else {
      MetroLog("Departured");
    };
  }

  protected cb func OnMetroLineActiveChange(factValue: Int32) -> Bool {
    MetroLog(s"OnMetroLineActiveChange \(MetroDataHelper.LineStr(MetroDataHelper.LineName(factValue)))");
  }
}
