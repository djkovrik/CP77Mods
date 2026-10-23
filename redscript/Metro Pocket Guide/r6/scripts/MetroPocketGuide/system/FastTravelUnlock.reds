module MetroPocketGuide.Unlocker
import MetroPocketGuide.Config.MetroPocketGuideConfig

public class MetroStationsUnlocker extends ScriptableSystem {

  private let questsSystem: wref<QuestsSystem>;
  private let uiSystem: wref<UISystem>;
  private let ftSystem: wref<FastTravelSystem>;

  private let prologueLockListenerId: Uint32;
  private let factPrologueLock: CName = n"watson_prolog_lock";
  private let fatPocketGuideUnlocked: CName = n"metro_pocket_guide_unlocked";

  private let ftPoints: array<TweakDBID>;
  private let markerNodes: array<String>;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return ;
    };

    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.InitCoreData(player);
      this.RegisterFactListeners();
      this.PopulateArrays();
      this.CheckAndUnlock();
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

  private final func PopulateArrays() -> Void {
    this.ftPoints = [
      t"FastTravelPoints.wat_nid_metro_ftp_01",
      t"FastTravelPoints.wat_lch_metro_ftp_02",
      t"FastTravelPoints.wat_lch_metro_ftp_01",
      t"FastTravelPoints.wat_lch_metro_ftp_04",
      t"FastTravelPoints.wbr_jpn_metro_ftp_01",
      t"FastTravelPoints.wbr_jpn_metro_ftp_02",
      t"FastTravelPoints.cct_dtn_metro_ftp_02",
      t"FastTravelPoints.std_arr_metro_ftp_01",
      t"FastTravelPoints.cct_cpz_metro_ftp_01",
      t"FastTravelPoints.cct_cpz_metro_ftp_03",
      t"FastTravelPoints.hey_spr_metro_ftp_01",
      t"FastTravelPoints.hey_gle_metro_ftp_01",
      t"FastTravelPoints.hey_gle_metro_ftp_02",
      t"FastTravelPoints.hey_rey_metro_ftp_01",
      t"FastTravelPoints.std_rcr_metro_ftp_01",
      t"FastTravelPoints.wat_lch_metro_ftp_03",
      t"FastTravelPoints.wbr_hil_metro_ftp_01",
      t"FastTravelPoints.hey_gle_metro_ftp_03",
      t"FastTravelPoints.pac_cvi_metro_ftp_01"
    ];

    this.markerNodes = [
      "#wat_nid_metro_ftp_01",
      "#wat_lch_metro_ftp_02",
      "#wat_lch_metro_ftp_01",
      "#wat_lch_metro_ftp_09",
      "#wbr_jpn_metro_ftp_01",
      "#wbr_jpn_metro_ftp_02",
      "#cct_dtn_metro_ftp_02",
      "#std_arr_metro_ftp_01",
      "#cct_cpz_metro_ftp_01",
      "#cct_cpz_metro_ftp_15",
      "#hey_spr_metro_ftp_01",
      "#hey_gle_metro_ftp_01",
      "#hey_gle_metro_ftp_02",
      "#hey_rey_metro_ftp_01",
      "#std_rcr_metro_ftp_05",
      "#wat_lch_metro_ftp_08",
      "#wbr_hil_metro_ftp_01",
      "#hey_gle_metro_ftp_08",
      "#pac_cvi_metro_ftp_01"
    ];
  }

  private final func RegisterFactListeners() -> Void {
    this.prologueLockListenerId = this.questsSystem.RegisterListener(this.factPrologueLock, this, n"OnFactPrologueLockChange");
  }

  private final func UnregisterFactListeners() -> Void {
    this.questsSystem.UnregisterListener(this.factPrologueLock, this.prologueLockListenerId);
  }

  protected cb func OnFactPrologueLockChange(factValue: Int32) -> Bool {
    if factValue <= 0 && !this.IsStationsUnlocked() && this.IsUnlockEnabled() {
      this.MarkAsUnlocked();
      this.UnlockMetroStationFTPoints();
    };
  }

  private final func CheckAndUnlock() -> Void {
    if this.IsPrologueUnlocked() && !this.IsStationsUnlocked() && this.IsUnlockEnabled() {
      this.MarkAsUnlocked();
      this.UnlockMetroStationFTPoints();
    };
  }

  private final func UnlockMetroStationFTPoints() -> Void {
    MetroLog("Fast travel points unlocked");
    let points: array<ref<FastTravelPointData>>;
    let requesterId: EntityID = GetPlayer(GetGameInstance()).GetEntityID();
    let count: Int32 = ArraySize(this.ftPoints);
    let i: Int32 = 0;

    while i < count {
      let data: ref<FastTravelPointData> = new FastTravelPointData();
      data.pointRecord = this.ftPoints[i];
      data.markerRef = CreateNodeRef(this.markerNodes[i]);
      data.requesterID = requesterId;
      data.isEP1 = false;
      ArrayPush(points, data);
      i += 1;
    };

    let request: ref<RegisterFastTravelPointsRequest> = new RegisterFastTravelPointsRequest();
    request.fastTravelNodes = points;
    request.register = true;
    this.ftSystem.QueueRequest(request);

    MetroLog("Station Points unlocked");
  }

  private final func IsUnlockEnabled() -> Bool {
    let config: ref<MetroPocketGuideConfig> = new MetroPocketGuideConfig();
    return config.unlockMetroMappins;
  }

  private final func IsPrologueUnlocked() -> Bool {
    let prologueFact: Int32 = this.questsSystem.GetFact(this.factPrologueLock);
    return Equals(prologueFact, 0);
  }

  private final func IsStationsUnlocked() -> Bool {
    let unlockedFact: Int32 = this.questsSystem.GetFact(this.fatPocketGuideUnlocked);
    return Equals(unlockedFact, 1);
  }

  private final func MarkAsUnlocked() -> Void {
    this.questsSystem.SetFact(this.fatPocketGuideUnlocked, 1);
  }
}
