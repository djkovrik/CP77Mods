module QHHotkeys

private class QHConfig {
  public static func ApplyOnSelect() -> Bool = false
}

@wrapMethod(QuickhacksListGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  // Hide change target hint
  this.GetRootCompoundWidget().GetWidget(n"input_container/input_hint/inputChangeTarget").SetVisible(false);
}

@wrapMethod(QuickhacksListGameController)
private final func SetVisibility(value: Bool) -> Void {
  wrappedMethod(value);

  if value {
    this.m_playerObject.RegisterInputListener(this, n"SelectHack1");
    this.m_playerObject.RegisterInputListener(this, n"SelectHack2");
    this.m_playerObject.RegisterInputListener(this, n"SelectHack3");
    this.m_playerObject.RegisterInputListener(this, n"SelectHack4");
    this.m_playerObject.RegisterInputListener(this, n"SelectHack5");
    this.m_playerObject.RegisterInputListener(this, n"SelectHack6");
    this.m_playerObject.RegisterInputListener(this, n"SelectHack7");
    this.m_playerObject.RegisterInputListener(this, n"SelectHack8");
    this.m_playerObject.RegisterInputListener(this, n"SelectHack9");
    this.m_playerObject.RegisterInputListener(this, n"SelectHack10");
  };
}

@wrapMethod(QuickhacksListGameController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let released: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) || Equals(ListenerAction.GetType(action), gameinputActionType.AXIS_CHANGE);
  let gameActive: Bool = this.GetPlayerControlledObject().GetHudManager().IsHackingMinigameActive();
  
  let name: CName;
  let index: Int32;
  if released && !gameActive && !this.m_isUILocked {
    name = ListenerAction.GetName(action);
    switch name {
      case n"SelectHack1":
        index = 0;
        break;
      case n"SelectHack2":
        index = 1;
        break;
      case n"SelectHack3":
        index = 2;
        break;
      case n"SelectHack4":
        index = 3;
        break;
      case n"SelectHack5":
        index = 4;
        break;
      case n"SelectHack6":
        index = 5;
        break;
      case n"SelectHack7":
        index = 6;
        break;
      case n"SelectHack8":
        index = 7;
        break;
        case n"SelectHack9":
        index = 8;
        break;
      case n"SelectHack10":
        index = 9;
        break;
      default:
        index = -1;
        break;
    };

    if NotEquals(index, -1) {
      this.OnQuckhackByHotkeyActivation(index);
    };
  };

  return wrappedMethod(action, consumer);
}

@addMethod(QuickhacksListGameController)
private func OnQuckhackByHotkeyActivation(requestedIndex: Int32) -> Void {
  let currentActiveIndex: Int32 = this.m_listController.GetSelectedIndex();
  let listSize: Int32 = this.m_listController.Size();
  if requestedIndex < 0 || requestedIndex > listSize - 1 {
    return ;
  };

  if QHConfig.ApplyOnSelect() {
    if NotEquals(requestedIndex, currentActiveIndex) {
      this.m_listController.SetSelectedIndex(requestedIndex, QHConfig.ApplyOnSelect());
    };
    this.ApplyQuickHack();
  } else {
    if Equals(requestedIndex, currentActiveIndex) {
      this.ApplyQuickHack();
    } else {
      this.m_listController.SetSelectedIndex(requestedIndex, false);
    };
  };
}

@wrapMethod(QuickhacksListGameController)
private final func PopulateData(data: array<ref<QuickhackData>>) -> Void {
  wrappedMethod(data);

  let controller: ref<QuickhacksListItemController>;
  let index: Int32 = 0;
  while index < ArraySize(data) {
    controller = this.m_listController.GetItemAt(index).GetController() as QuickhacksListItemController;
    if IsDefined(controller) {
      controller.SetQuickhackHotkeyAction(index);
    };
    index += 1;
  };
}

@addField(QuickhacksListItemController)
private let m_buttonHint: ref<inkWidget>;

@addField(QuickhacksListItemController)
private let m_buttonHintController: ref<ButtonHints>;

@wrapMethod(QuickhacksListItemController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let container: ref<inkCompoundWidget> = this.GetRootCompoundWidget().GetWidget(n"main_container") as inkCompoundWidget;
  let wrapper: ref<inkCanvas> = new inkCanvas();
  wrapper.SetName(n"qh_hint");
  wrapper.SetFitToContent(true);
  wrapper.SetHAlign(inkEHorizontalAlign.Fill);
  wrapper.SetVAlign(inkEVerticalAlign.Fill);
  wrapper.SetAnchor(inkEAnchor.Fill);
  wrapper.SetAnchorPoint(new Vector2(0.5, 0.5));
  wrapper.Reparent(container);

  this.m_buttonHint = this.SpawnFromExternal(wrapper, r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root");
  this.m_buttonHint.SetMargin(new inkMargin(0.0, 0.0, 8.0, 16.0));
  this.m_buttonHint.SetHAlign(inkEHorizontalAlign.Center);
  this.m_buttonHint.SetVAlign(inkEVerticalAlign.Bottom);
  this.m_buttonHint.SetAnchor(inkEAnchor.BottomCenter);
  this.m_buttonHint.SetAnchorPoint(new Vector2(1.0, 0.0));
  this.m_buttonHint.SetOpacity(0.8);
  this.m_buttonHintController = this.m_buttonHint.GetController() as ButtonHints;
}

@addMethod(QuickhacksListItemController)
public func SetQuickhackHotkeyAction(index: Int32) -> Void {
  let action: CName;
  switch index {
  case 0:
    action = n"SelectHack1";
    break;
  case 1:
    action = n"SelectHack2";
    break;
  case 2:
    action = n"SelectHack3";
    break;
  case 3:
    action = n"SelectHack4";
    break;
  case 4:
    action = n"SelectHack5";
    break;
  case 5:
    action = n"SelectHack6";
    break;
  case 6:
    action = n"SelectHack7";
    break;
  case 7:
    action = n"SelectHack8";
    break;
  case 8:
    action = n"SelectHack9";
    break;
  case 9:
    action = n"SelectHack10";
    break;
  default:
    action = n"";
    break;
  };

  if NotEquals(action, n"") {
    this.m_buttonHintController.AddButtonHint(action, "");
  };
}

// Disabe quickhacks target switch for IK_1 and IK_3 keys
@wrapMethod(HUDManager)
protected final func RegisterToInput() -> Void {
  wrappedMethod();
  let puppet: ref<GameObject> = this.GetPlayer();
  puppet.UnregisterInputListener(this, n"QH_MoveLeft");
  puppet.UnregisterInputListener(this, n"QH_MoveRight");
}
