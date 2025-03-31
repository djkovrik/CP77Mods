module AtelierDelivery

public class AtelierDeliveryDebugHotkey {
  private let player: wref<PlayerPuppet>;
  private let timeSystem: wref<TimeSystem>;
  private let messengerSystem: wref<DeliveryMessengerSystem>;

  public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
    this.timeSystem = GameInstance.GetTimeSystem(this.player.GetGame());
    this.messengerSystem = DeliveryMessengerSystem.Get(this.player.GetGame());
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if ListenerAction.IsAction(action, n"restore_default_settings") && ListenerAction.IsButtonJustReleased(action) {
      this.ShowRandomSmsMessage();
    }
  }

  private final func DumpCurrentPlayerPosition() -> Void {
    let position: Vector4 = this.player.GetWorldPosition();
    let orientation: Quaternion = this.player.GetWorldOrientation();
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(this.player.GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    let district: ref<District> = ps.GetCurrentDistrict();
    let districtRecord: ref<District_Record> = district.GetDistrictRecord();
    let parentDistrictRecord: ref<District_Record> = districtRecord.ParentDistrict();

    ModLog(n"Delivery", s"Position: \(position)");
    ModLog(n"Delivery", s"Orientation: \(orientation)");
    ModLog(n"Delivery", s"\(TDBID.ToStringDEBUG(parentDistrictRecord.GetID())), \(TDBID.ToStringDEBUG(districtRecord.GetID()))");
  }

  private final func ShowRandomSmsMessage() -> Void {
    let item: ref<DeliveryHistoryItem> = this.CreateRandomMessage();
    this.messengerSystem.PushNewNotificationItem(item);
  }

  private func CreateRandomMessage() -> ref<DeliveryHistoryItem> {
    let testStore: CName = n"Testing store";
    let randType: Int32 = RandRange(0, 3);
    let randomId: Int32 = RandRange(1000, 9999);
    let randomTimestamp: Float = RandRangeF(36000.0, 96000.0);
    let randomDropPointInt: Int32 = RandRange(1, 18);
    let randomDropPoint: AtelierDeliveryDropPoint = IntEnum<AtelierDeliveryDropPoint>(randomDropPointInt);
    let districts: array<ref<TweakDBRecord>> = TweakDBInterface.GetRecords(n"District");
    let districtsSize: Int32 = ArraySize(districts);
    let randomDistrictInt: Int32 = RandRange(0, districtsSize - 1);
    let randomDistrict: TweakDBID = districts[randomDistrictInt].GetID();

    if Equals(randType, 0) {
      return DeliveryHistoryItem.Shipped(randomId, testStore, randomDropPoint, randomTimestamp);
    } else if Equals(randType, 1) {
      return DeliveryHistoryItem.Arrived(randomId, testStore, randomDropPoint);
    };

    return DeliveryHistoryItem.NewDropPoint(randomDropPoint, randomDistrict);
  }
}

@addField(PlayerPuppet)
private let atelierDeliveryDebugHotkey: ref<AtelierDeliveryDebugHotkey>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();
  if VirtualAtelierDeliveryConfig.Debug() {
    this.atelierDeliveryDebugHotkey = new AtelierDeliveryDebugHotkey();
    this.atelierDeliveryDebugHotkey.SetPlayer(this);
    this.RegisterInputListener(this.atelierDeliveryDebugHotkey);
  };
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  wrappedMethod();
  if VirtualAtelierDeliveryConfig.Debug() {
    this.UnregisterInputListener(this.atelierDeliveryDebugHotkey);
    this.atelierDeliveryDebugHotkey = null;
  };
}
