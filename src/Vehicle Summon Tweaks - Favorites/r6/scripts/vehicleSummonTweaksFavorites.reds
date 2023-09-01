module VehicleSummonTweaks

private abstract class VehicleSummonFavoritesConfig {
  public static func ActionName() -> CName = n"popup_goto_messenger"
  public static func Pin() -> String = "Pin"
  public static func Unpin() -> String = "Unpin"
}

public class FavoritesVehicleSystem extends ScriptableSystem {

  private persistent let pinned: array<TweakDBID>;

  public static func GetInstance(player: ref<GameObject>) -> ref<FavoritesVehicleSystem> {
    let gi: GameInstance = player.GetGame();
    let system: ref<FavoritesVehicleSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"VehicleSummonTweaks.FavoritesVehicleSystem") as FavoritesVehicleSystem;
    return system;
  }

  public final func IsPinned(id: TweakDBID) -> Bool {
    return ArrayContains(this.pinned, id);
  }

  public final func Toggle(id: TweakDBID) -> Bool {
    if this.IsPinned(id) {
      return this.Unpin(id);
    };

    return this.Pin(id);
  }

  private final func Pin(id: TweakDBID) -> Bool {
    if !this.IsPinned(id) {
      ArrayPush(this.pinned, id);
      return true;
    };

    return false;
  }

  private final func Unpin(id: TweakDBID) -> Bool {
    if this.IsPinned(id) {
      ArrayRemove(this.pinned, id);
      return true;
    };

    return false;
  }

}

@addField(VehiclesManagerPopupGameController)
private let buttonText: wref<inkText>;

@addField(VehiclesManagerPopupGameController)
private let system: wref<FavoritesVehicleSystem>;

@addField(VehiclesManagerPopupGameController)
private let currentItem: ref<VehicleListItemData>;

@addMethod(VehiclesManagerPopupGameController)
private func CreateButtonHintWidget() -> Void {
  let container: ref<inkCompoundWidget> = this.GetRootCompoundWidget().GetWidget(n"containerRoot") as inkCompoundWidget;

  let buttonHint: ref<inkWidget> = this.SpawnFromExternal(container, r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root");
  buttonHint.SetMargin(new inkMargin(416.0, 80.0, 0.0, 0.0));
  buttonHint.SetHAlign(inkEHorizontalAlign.Right);
  buttonHint.SetVAlign(inkEVerticalAlign.Bottom);
  buttonHint.SetAnchor(inkEAnchor.BottomCenter);
  buttonHint.SetAnchorPoint(new Vector2(0.0, 0.0));

  let buttonHintController: ref<ButtonHints> = buttonHint.GetController() as ButtonHints;
  buttonHintController.AddButtonHint(VehicleSummonFavoritesConfig.ActionName(), "");

  let buttonText: ref<inkText> = new inkText();
  buttonText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  buttonText.BindProperty(n"tintColor", n"MainColors.ActiveRed");
  buttonText.SetLetterCase(textLetterCase.UpperCase);
  buttonText.SetFontSize(36);
  buttonText.SetText(VehicleSummonFavoritesConfig.Pin());
  buttonText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  buttonText.SetMargin(new inkMargin(412.0, 20.0, 0.0, 0.0));
  buttonText.SetHAlign(inkEHorizontalAlign.Right);
  buttonText.SetVAlign(inkEVerticalAlign.Bottom);
  buttonText.SetAnchor(inkEAnchor.BottomCenter);
  buttonText.SetAnchorPoint(new Vector2(0.0, 0.0));
  buttonText.Reparent(container);
  this.buttonText = buttonText;
}

@wrapMethod(VehiclesManagerPopupGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  this.system = FavoritesVehicleSystem.GetInstance(playerPuppet);
  playerPuppet.RegisterInputListener(this, VehicleSummonFavoritesConfig.ActionName());
}

@wrapMethod(VehiclesManagerPopupGameController)
protected func SetupVirtualList() -> Void {
  wrappedMethod();
  this.CreateButtonHintWidget();
}

@wrapMethod(VehiclesManagerPopupGameController)
protected func Select(previous: ref<inkVirtualCompoundItemController>, next: ref<inkVirtualCompoundItemController>) -> Void {
  wrappedMethod(previous, next);

  let currentItemController: wref<VehiclesManagerListItemController> = next as VehiclesManagerListItemController;
  this.currentItem = currentItemController.GetVehicleData();

  if this.currentItem.pinned {
    this.buttonText.SetText(VehicleSummonFavoritesConfig.Unpin());
  } else {
    this.buttonText.SetText(VehicleSummonFavoritesConfig.Pin());
  };
}

@addMethod(VehiclesManagerPopupGameController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  super.OnAction(action, consumer);
  
  let actionName: CName = ListenerAction.GetName(action);
  let pressed: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED);
  if pressed && Equals(actionName, VehicleSummonFavoritesConfig.ActionName()) {
    this.TogglePin();
  };
}

@addMethod(VehiclesManagerPopupGameController)
private func TogglePin() -> Void {
  let currentVehicleId: TweakDBID = this.currentItem.m_data.recordID;
  if this.system.Toggle(currentVehicleId) {
    this.SetupData();
  };
}

@addField(VehicleListItemData)
public let pinned: Bool;

@wrapMethod(VehiclesManagerDataHelper)
public final static func GetVehicles(player: ref<GameObject>) -> array<ref<IScriptable>> {
  let system: ref<FavoritesVehicleSystem> = FavoritesVehicleSystem.GetInstance(player);
  let data: array<ref<IScriptable>> = wrappedMethod(player);
  for item in data {
    let current: ref<VehicleListItemData> = item as VehicleListItemData;
    current.pinned = system.IsPinned(current.m_data.recordID);
  };

  return data;
}

@wrapMethod(VehiclesManagerDataView)
public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
  let wrapped: Bool = wrappedMethod(left, right);
  let leftItem: ref<VehicleListItemData> = left as VehicleListItemData;
  let righItem: ref<VehicleListItemData> = right as VehicleListItemData;

  if NotEquals(leftItem.pinned, righItem.pinned) {
    return leftItem.pinned;
  };

  return wrapped;
}

@wrapMethod(VehiclesManagerListItemController)
protected cb func OnDataChanged(value: Variant) -> Bool {
  wrappedMethod(value);

  if this.m_vehicleData.pinned {
    inkTextRef.SetText(this.m_label, s"* \(GetLocalizedTextByKey(this.m_vehicleData.m_displayName)) *");
  };
}
