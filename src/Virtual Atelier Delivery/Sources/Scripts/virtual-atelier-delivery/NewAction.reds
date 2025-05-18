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
protected cb func OnInstantiated() -> Bool {
  super.OnInstantiated();
  this.dropPointsSpawner = AtelierDropPointsSpawner.Get(this.GetGameInstance());
  this.ordersSystem = OrderProcessingSystem.Get(this.GetGameInstance());
}

@addMethod(DropPointControllerPS)
protected final func OnOpenVaDeliveryUI(evt: ref<OpenVaDeliveryUI>) -> EntityNotificationType {
  let entityId: EntityID = this.GetMyEntityID();
  let dropPointTag: CName = this.dropPointsSpawner.GetUniqueTagByEntityId(entityId);
  this.ordersSystem.GetArrivedItems(dropPointTag);
  return EntityNotificationType.DoNotNotifyEntity;
}

@wrapMethod(DropPointControllerPS)
public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
  let dps: ref<DropPointSystem>;
  if !super.GetActions(outActions, context) {
    return false;
  };
  dps = this.GetDropPointSystem();
  if !dps.IsEnabled() {
    return false;
  };

  let entityId: EntityID = this.GetMyEntityID();
  if this.dropPointsSpawner.IsCustomDropPoint(entityId) {
    ArrayPush(outActions, this.ActionOpenVaDeliveryUI(context.processInitiatorObject));
    this.SetActionIllegality(outActions, this.m_illegalActions.regularActions);
    return true;
  }

  return wrappedMethod(outActions, context);
}
