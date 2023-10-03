module QHHotkeys

@wrapMethod(QuickhacksListGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  // Hide change target hint
  this.GetRootCompoundWidget().GetWidget(n"input_container/input_hint/inputChangeTarget").SetVisible(false);
}

@replaceMethod(QuickhacksListGameController)
private final func SetVisibility(value: Bool) -> Void {
  let animOptions: inkAnimOptions;
  let delayIntroDescritpio: ref<DelayedDescriptionIntro>;
  let progressBarBB: wref<IBlackboard> = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_HUDProgressBar);
  let uiQuickSlotsDataBB: ref<IBlackboard> = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_QuickSlotsData);
  if value {
    if !HUDManager.HasCurrentTarget(this.m_gameInstance) {
      return;
    };
    this.m_playerObject = this.GetPlayerControlledObject();
    if !IsDefined(this.m_playerObject) {
      return;
    };
    if this.m_lastCompiledTarget != this.m_data[0].m_actionOwner {
      if EntityID.IsDefined(this.m_data[0].m_actionOwner) {
        this.m_lastCompiledTarget = this.m_data[0].m_actionOwner;
      };
    } else {
      if this.m_selectedData.m_noQuickhackData {
        if GameInstance.GetStatsSystem(this.m_gameInstance).GetStatValue(Cast<StatsObjectID>(this.m_playerObject.GetEntityID()), gamedataStatType.HasCyberdeck) <= 0.00 {
          return;
        };
      } else {
        return;
      };
    };
    this.SetupQuickhacksMemoryBar();
    this.GetRootWidget().SetVisible(true);
    if IsDefined(this.inkIntroAnimProxy) && this.inkIntroAnimProxy.IsPlaying() {
      this.inkIntroAnimProxy.Stop();
    };
    animOptions.customTimeDilation = 2.00;
    animOptions.applyCustomTimeDilation = true;
    this.inkIntroAnimProxy = this.PlayLibraryAnimation(n"intro", animOptions);
    this.PlaySound(n"QuickHackMenu", n"OnOpen");
    if this.m_timeBetweenIntroAndDescritpionCheck {
      GameInstance.GetDelaySystem(this.m_playerObject.GetGame()).CancelDelay(this.m_timeBetweenIntroAndDescritpionDelayID);
    };
    if this.m_timeBetweenIntroAndIntroDescription != 0.00 {
      this.m_introDescriptionAnimProxy = this.PlayLibraryAnimation(n"outro_tooltip");
    };
    delayIntroDescritpio = new DelayedDescriptionIntro();
    this.m_timeBetweenIntroAndDescritpionDelayID = GameInstance.GetDelaySystem(this.m_playerObject.GetGame()).DelayEvent(this.m_playerObject, delayIntroDescritpio, this.m_timeBetweenIntroAndIntroDescription, false);
    this.m_timeBetweenIntroAndDescritpionCheck = true;
    if !this.m_active {
      this.m_playerObject.RegisterInputListener(this, n"UI_MoveDown");
      this.m_playerObject.RegisterInputListener(this, n"UI_MoveUp");
      this.m_playerObject.RegisterInputListener(this, n"context_help");
      this.m_playerObject.RegisterInputListener(this, n"UI_ApplyAndClose");
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
    this.RequestTimeDilation(this.m_playerObject, n"quickHackScreen", true);
    this.m_memoryBoard.Signal(this.m_memoryBoardDef.MemoryPercent);
    if IsDefined(uiQuickSlotsDataBB) {
      uiQuickSlotsDataBB.SetBool(GetAllBlackboardDefs().UI_QuickSlotsData.quickhackPanelOpen, true);
    };
    GameInstance.GetUISystem(this.m_gameInstance).RequestNewVisualState(n"inkQuickHackingState");
  } else {
    this.PlaySound(n"QuickHackMenu", n"OnClose");
    this.GetRootWidget().SetVisible(false);
    if IsDefined(this.m_playerObject) {
      GameInstance.GetTargetingSystem(this.m_playerObject.GetGame()).BreakLookAt(this.m_playerObject);
      if this.m_active {
        this.m_playerObject.UnregisterInputListener(this);
      };
      this.RequestTimeDilation(this.m_playerObject, n"quickHackScreen", false);
    };
    if IsDefined(uiQuickSlotsDataBB) {
      uiQuickSlotsDataBB.SetBool(GetAllBlackboardDefs().UI_QuickSlotsData.quickhackPanelOpen, false);
    };
    this.m_playerObject = null;
    GameInstance.GetUISystem(this.m_gameInstance).RestorePreviousVisualState(n"inkQuickHackingState");
    progressBarBB.SetFloat(GetAllBlackboardDefs().UI_HUDProgressBar.ProgressBump, 0.00);
    this.ResetQuickhackSelection();
    if IsDefined(this.m_memorySpendAnimation) {
      this.m_memorySpendAnimation.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
    };
    this.HACK_wasPlayedOnTarget = false;
    this.m_lastCompiledTarget = new EntityID();
    if this.m_contextHelpOverlay {
      this.ShowTutorialOverlay(false);
    };
  };
  this.m_active = value;
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

  if NotEquals(requestedIndex, currentActiveIndex) {
    this.m_listController.SetSelectedIndex(requestedIndex, true);
  };
  this.ApplyQuickHack(true);
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

public class QHotkeysScannerToggledEvent extends Event {
  let usedKBM: Bool;

  public static func Create(enabled: Bool) -> ref<QHotkeysScannerToggledEvent> {
    let self: ref<QHotkeysScannerToggledEvent> = new QHotkeysScannerToggledEvent();
    self.usedKBM = enabled;
    return self;
  }
}

@addMethod(QuickhacksListItemController)
protected cb func OnQHotkeysScannerToggledEvent(evt: ref<QHotkeysScannerToggledEvent>) -> Bool {
  this.m_buttonHint.SetVisible(evt.usedKBM);
}

@wrapMethod(scannerGameController)
private final func ShowScanner(show: Bool) -> Void {
  wrappedMethod(show);

  let lastUsedKBM: Bool = this.m_playerPuppet.PlayerLastUsedKBM();
  GameInstance.GetUISystem(this.m_gameInstance).QueueEvent(QHotkeysScannerToggledEvent.Create(lastUsedKBM));
}
