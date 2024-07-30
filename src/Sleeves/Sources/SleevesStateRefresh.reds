@if(ModuleExists("EquipmentEx"))
import EquipmentEx.*

// -- Vanilla
@wrapMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  wrappedMethod(itemID, slotIndex, blockActiveSlotsUpdate, forceEquipWeapon);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
private final func UnequipItem(equipAreaIndex: Int32, slotIndex: Int32, opt forceRemove: Bool) -> Void {
  wrappedMethod(equipAreaIndex, slotIndex, forceRemove);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

// -- Wardrobe
@wrapMethod(EquipmentSystemPlayerData)
public final func OnQuestDisableWardrobeSetRequest(request: ref<QuestDisableWardrobeSetRequest>) -> Void {
  wrappedMethod(request);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnQuestRestoreWardrobeSetRequest(request: ref<QuestRestoreWardrobeSetRequest>) -> Void {
  wrappedMethod(request);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnQuestEnableWardrobeSetRequest(request: ref<QuestEnableWardrobeSetRequest>) -> Void {
  wrappedMethod(request);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func EquipWardrobeSet(setID: gameWardrobeClothingSetIndex) -> Void {
  wrappedMethod(setID);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func UnequipWardrobeSet() -> Void {
  wrappedMethod();
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func DeleteWardrobeSet(setID: gameWardrobeClothingSetIndex) -> Void {
  wrappedMethod(setID);
  this.m_owner.TriggerSleevesButtonRefreshCallback();
}

// -- Equipment-EX
@if(ModuleExists("EquipmentEx"))
@addMethod(gameuiInventoryGameController)
protected cb func OnCustomOutfitUpdated(evt: ref<OutfitUpdated>) -> Bool {
  this.m_player.TriggerSleevesButtonRefreshCallback();
}

// -- Braindance
@wrapMethod(HUDManager)
protected cb func OnBraindanceToggle(value: Bool) -> Bool {
  wrappedMethod(value);
  if this.m_isBraindanceActive {
    SleevesStateSystem.Get(this.GetGameInstance()).OnBraindanceEnter();
  } else {
    SleevesStateSystem.Get(this.GetGameInstance()).OnBraindanceExit();
  };
}

// -- Handle unequip
@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  wrappedMethod(evt);

  if evt.actionName.IsAction(n"unequip_item") {
    this.m_player.TriggerSleevesButtonRefreshCallback();
  };
}

@wrapMethod(VehicleComponent)
protected final func OnVehicleCameraChange(state: Bool) -> Void {
  wrappedMethod(state);
  GetPlayer(GetGameInstance()).TriggerSleevesButtonRefreshCallback();
}

// -- Delayed refresh
@addField(GameObject)
private let sleevesDelayCallback: DelayID;

@addMethod(GameObject)
public final func TriggerSleevesButtonRefreshCallback() -> Void {
  let triggerDelaySeconds: Float = 3.0;
  let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
  delaySystem.CancelCallback(this.sleevesDelayCallback);
  this.sleevesDelayCallback = delaySystem.DelayCallback(SlotsButtonRefreshCallback.Create(this), triggerDelaySeconds, false);
}

public class SlotsButtonRefreshCallback extends DelayCallback {
  let owner: wref<GameObject>;

  public static final func Create(owner: ref<GameObject>) -> ref<SlotsButtonRefreshCallback> {
    let instance: ref<SlotsButtonRefreshCallback> = new SlotsButtonRefreshCallback();
    instance.owner = owner;
    return instance;
  }

  public func Call() -> Void {
    SleevesStateSystem.Get(this.owner.GetGame()).RefreshSleevesState();
    RefreshSleevesButtonEvent.Send(this.owner);
  }
}
