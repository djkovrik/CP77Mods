module AtelierDelivery

public class OpenVaDeliveryUI extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"OpenVaDeliveryUI";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#8783", n"LocKey#8783");
  }
}

@addMethod(DropPointControllerPS)
protected final func ActionOpenVaDeliveryUI(executor: ref<GameObject>) -> ref<OpenVaDeliveryUI> {
  let action: ref<OpenVaDeliveryUI> = new OpenVaDeliveryUI();
  action.clearanceLevel = 2;
  action.SetUp(this);
  action.SetProperties();
  action.SetExecutor(executor);
  action.AddDeviceName(this.m_deviceName);
  action.CreateInteraction();
  action.CreateActionWidgetPackage();
  return action;
}

@addField(DropPointControllerPS)
private let dropPointsSpawner: wref<AtelierDropPointsSpawner>;

@addField(DropPointControllerPS)
private let ordersSystem: wref<OrderProcessingSystem>;

@addMethod(DropPointControllerPS)
private final func VADIsDebugEnabled() -> Bool {
  return IsDefined(this.dropPointsSpawner) && this.dropPointsSpawner.IsDebugEnabled();
}

@addMethod(DropPointControllerPS)
private final func VADLogPickup(str: String) -> Void {
  if this.VADIsDebugEnabled() {
    ModLog(n"DeliveryOrders", str);
  };
}

@addMethod(DropPointControllerPS)
protected cb func OnInstantiated() -> Bool {
  super.OnInstantiated();
  this.dropPointsSpawner = AtelierDropPointsSpawner.Get(this.GetGameInstance());
  this.ordersSystem = OrderProcessingSystem.Get(this.GetGameInstance());
  if this.VADIsDebugEnabled() {
    this.VADLogPickup(s"Pickup terminal instantiated: entity=\(this.GetMyEntityID()), spawner=\(IsDefined(this.dropPointsSpawner)), ordersSystem=\(IsDefined(this.ordersSystem))");
  };
}

@addMethod(DropPointControllerPS)
protected final func OnOpenVaDeliveryUI(evt: ref<OpenVaDeliveryUI>) -> EntityNotificationType {
  if this.VADIsDebugEnabled() {
    this.VADLogPickup(s"Pickup interaction received: entity=\(this.GetMyEntityID())");
  };
  if !IsDefined(this.dropPointsSpawner) {
    this.VADLogPickup("Pickup interaction: cached spawner is missing, trying to reacquire it");
    this.dropPointsSpawner = AtelierDropPointsSpawner.Get(this.GetGameInstance());
  };

  if !IsDefined(this.ordersSystem) {
    this.VADLogPickup("Pickup interaction: cached order system is missing, trying to reacquire it");
    this.ordersSystem = OrderProcessingSystem.Get(this.GetGameInstance());
  };

  if !IsDefined(this.dropPointsSpawner) || !IsDefined(this.ordersSystem) {
    if this.VADIsDebugEnabled() {
      this.VADLogPickup(s"Pickup interaction FAILED: spawner=\(IsDefined(this.dropPointsSpawner)), ordersSystem=\(IsDefined(this.ordersSystem))");
    };
    return EntityNotificationType.DoNotNotifyEntity;
  };

  let entityId: EntityID = this.GetMyEntityID();
  let dropPointTag: CName = this.dropPointsSpawner.GetUniqueTagByEntityId(entityId);
  if this.VADIsDebugEnabled() {
    this.VADLogPickup(s"Pickup interaction resolved terminal: entity=\(entityId), uniqueTag=\(dropPointTag)");
  };
  this.ordersSystem.GetArrivedItems(dropPointTag);
  return EntityNotificationType.DoNotNotifyEntity;
}

@wrapMethod(DropPointControllerPS)
public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
  let entityId: EntityID = this.GetMyEntityID();
  if !IsDefined(this.dropPointsSpawner) {
    this.dropPointsSpawner = AtelierDropPointsSpawner.Get(this.GetGameInstance());
  };

  if IsDefined(this.dropPointsSpawner) && this.dropPointsSpawner.IsCustomDropPoint(entityId) {
    // Atelier terminals intentionally replace the vendor/quest actions. Only this
    // branch bypasses wrappedMethod; ordinary drop points keep the full chain.
    if !super.GetActions(outActions, context) || !this.GetDropPointSystem().IsEnabled() {
      return false;
    };
    ArrayPush(outActions, this.ActionOpenVaDeliveryUI(context.processInitiatorObject));
    this.SetActionIllegality(outActions, this.m_illegalActions.regularActions);
    return true;
  }

  return wrappedMethod(outActions, context);
}
