module MetroPocketGuide.Tracker
import MetroPocketGuide.Navigator.PocketMetroNavigator

public class MetroStationTracker extends ScriptableSystem {
  private let player: wref<PlayerPuppet>;
  private let questsSystem: wref<QuestsSystem>;

  private let factMetroStationActive: CName = n"ue_metro_active_station";
  private let factMetroStationNext: CName = n"ue_metro_next_station";
  private let factMetroLineActive: CName = n"ue_metro_track_selected";

  private let metroStationActiveListenerId: Uint32;
  private let metroStationNextListenerId: Uint32;
  private let metroLineActiveListenerId: Uint32;

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
    this.player = player;
    this.questsSystem = GameInstance.GetQuestsSystem(player.GetGame());
  }

  private final func RegisterFactListeners() -> Void {
    this.metroStationActiveListenerId = this.questsSystem.RegisterListener(this.factMetroStationActive, this, n"OnMetroStationActiveChange");
    this.metroStationNextListenerId = this.questsSystem.RegisterListener(this.factMetroStationNext, this, n"OnMetroStationNextChange");
    this.metroLineActiveListenerId = this.questsSystem.RegisterListener(this.factMetroLineActive, this, n"OnMetroLineActiveChange");
  }

  private final func UnregisterFactListeners() -> Void {
    this.questsSystem.UnregisterListener(this.factMetroStationActive, this.metroStationActiveListenerId);
    this.questsSystem.UnregisterListener(this.factMetroStationNext, this.metroStationNextListenerId);
    this.questsSystem.UnregisterListener(this.factMetroLineActive, this.metroLineActiveListenerId);
  }

  protected cb func OnMetroLineActiveChange(factValue: Int32) -> Bool {
    PocketMetroNavigator.GetInstance(this.player.GetGame()).OnMetroLineChanged(factValue);
  }

  protected cb func OnMetroStationNextChange(factValue: Int32) -> Bool {
    PocketMetroNavigator.GetInstance(this.player.GetGame()).OnMetroStationChangedNext(factValue);
  }

  protected cb func OnMetroStationActiveChange(factValue: Int32) -> Bool {
    PocketMetroNavigator.GetInstance(this.player.GetGame()).OnMetroStationChangedActive(factValue);
  }

  private final func FactToStationStr(factValue: Int32) -> String {
    return s"\(MetroDataHelper.GetStationNameById(factValue)) - \(MetroDataHelper.GetLocalizedStationTitleById(factValue))";
  }

  private final func FactToLineStr(factValue: Int32) -> String {
    let lineName: ModNCartLine = MetroDataHelper.LineName(factValue);
    return s"\(lineName) - \(MetroDataHelper.LineStr(lineName))";
  }
}
