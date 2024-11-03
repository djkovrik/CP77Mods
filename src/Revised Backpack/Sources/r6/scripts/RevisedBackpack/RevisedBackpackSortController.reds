module RevisedBackpack

public class RevisedBackpackSortController extends inkLogicController {

  private let m_player: wref<PlayerPuppet>;

  private let m_borderName: inkWidgetRef;
  private let m_borderType: inkWidgetRef;
  private let m_borderTier: inkWidgetRef;
  private let m_borderPrice: inkWidgetRef;
  private let m_borderWeight: inkWidgetRef;
  private let m_borderDps: inkWidgetRef;
  private let m_borderRange: inkWidgetRef;
  private let m_borderQuest: inkWidgetRef;

  private let m_arrowName: inkWidgetRef;
  private let m_arrowType: inkWidgetRef;
  private let m_arrowTier: inkWidgetRef;
  private let m_arrowPrice: inkWidgetRef;
  private let m_arrowWeight: inkWidgetRef;
  private let m_arrowDps: inkWidgetRef;
  private let m_arrowRange: inkWidgetRef;
  private let m_arrowQuest: inkWidgetRef;

  private let previousSelectedWidget: ref<inkWidget>;
  private let currentSelectedWidget: ref<inkWidget>;

  private let currentSorting: revisedSorting;
  private let currentSortingMode: revisedSortingMode;

  private let rotationAnimationProxy: ref<inkAnimProxy>;
  private let rotationAnimation: ref<inkAnimDef>;

  protected cb func OnInitialize() -> Bool {
    this.currentSorting = revisedSorting.None;
    this.currentSortingMode = revisedSortingMode.None;

    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");

    this.m_player = GetPlayer(GetGameInstance());
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");

    this.rotationAnimationProxy.Stop();
    this.rotationAnimationProxy = null;
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    this.SetHoveredOnState(target);

    let userData: ref<LabeledCursorData> = target.GetUserData(n"LabeledCursorData") as LabeledCursorData;
    if IsDefined(userData) {
      this.QueueEvent(RevisedBackpackColumnHoverOverEvent.Create(target, this.SortingFromUserData(userData.m_text)));
    };
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    this.SetHoveredOutState(target);
    this.QueueEvent(RevisedBackpackColumnHoverOutEvent.Create());
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.PlaySound(n"ui_menu_onpress");
      let target: ref<inkWidget> = evt.GetTarget();
      let userData: ref<LabeledCursorData> = target.GetUserData(n"LabeledCursorData") as LabeledCursorData;
      if IsDefined(userData) {
        this.previousSelectedWidget = this.currentSelectedWidget;
        this.currentSelectedWidget = target;
        this.OnSortingHeaderClick(this.SortingFromUserData(userData.m_text));
      };
    };
  }

  private final func SetHoveredOnState(target: ref<inkWidget>) -> Void {
    if IsDefined(target) {
      if NotEquals(this.currentSelectedWidget, target) {
        target.BindProperty(n"tintColor", n"MainColors.Blue");
        target.SetOpacity(0.5);
      };
    };
  }

  private final func SetSelectedState(target: ref<inkWidget>) -> Void {
    if IsDefined(target) {
      target.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
      target.SetOpacity(0.5);
    };
  }

  private final func SetHoveredOutState(target: ref<inkWidget>) -> Void {
    if IsDefined(target) {
      if NotEquals(this.currentSelectedWidget, target) {
        target.BindProperty(n"tintColor", n"MainColors.Red");
        target.SetOpacity(0.1);
      } else {
        target.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
        target.SetOpacity(0.5);
      };
    };
  }

  private final func OnSortingHeaderClick(type: revisedSorting) -> Void {
    if NotEquals(this.currentSorting, type) {
      this.currentSorting = type;
      this.currentSortingMode = revisedSortingMode.Asc;
    } else {
      if Equals(this.currentSortingMode, revisedSortingMode.Asc) {
        this.currentSortingMode = revisedSortingMode.Desc;
      } else {
        this.currentSortingMode = revisedSortingMode.Asc;
      };
    };

    this.UpdateSortingControls();
    this.QueueEvent(RevisedBackpackSortingChanged.Create(this.currentSorting, this.currentSortingMode));
  }

  private final func UpdateSortingControls() -> Void {
    this.Log(s"UpdateSortingControls \(this.currentSorting) + \(this.currentSortingMode)");
    
    if NotEquals(this.previousSelectedWidget, this.currentSelectedWidget) {
      this.SetHoveredOutState(this.previousSelectedWidget);
      this.SetSelectedState(this.currentSelectedWidget);
    };

    switch this.currentSorting {
      case revisedSorting.Name:
        this.UpdateArrow(this.m_arrowName, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Type:
        this.UpdateArrow(this.m_arrowType, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Tier:
        this.UpdateArrow(this.m_arrowTier, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Price:
        this.UpdateArrow(this.m_arrowPrice, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Weight:
        this.UpdateArrow(this.m_arrowWeight, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Dps:
        this.UpdateArrow(this.m_arrowDps, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Range:
        this.UpdateArrow(this.m_arrowRange, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Quest:
        this.UpdateArrow(this.m_arrowQuest, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
    };
  }

  private final func HideArrows() -> Void {
    inkWidgetRef.SetVisible(this.m_arrowName, false);
    inkWidgetRef.SetVisible(this.m_arrowType, false);
    inkWidgetRef.SetVisible(this.m_arrowTier, false);
    inkWidgetRef.SetVisible(this.m_arrowPrice, false);
    inkWidgetRef.SetVisible(this.m_arrowWeight, false);
    inkWidgetRef.SetVisible(this.m_arrowDps, false);
    inkWidgetRef.SetVisible(this.m_arrowRange, false);
    inkWidgetRef.SetVisible(this.m_arrowQuest, false);
  }

  private final func UpdateArrow(target: inkWidgetRef, asc: Bool) -> Void {
    if NotEquals(this.previousSelectedWidget, this.currentSelectedWidget) {
      this.HideArrows();
    };

    inkWidgetRef.SetVisible(target, true);
    let currentRotation: Float = inkWidgetRef.GetRotation(target);
    let targetRotation: Float;
    if asc {
      targetRotation = 0.0;
    } else {
      targetRotation = 180.0;
    };

    this.rotationAnimation = new inkAnimDef();
    let rotationInterpolator: ref<inkAnimRotation> = new inkAnimRotation();
    rotationInterpolator.SetDuration(0.15);
    rotationInterpolator.SetDirection(inkanimInterpolationDirection.To);
    rotationInterpolator.SetType(inkanimInterpolationType.Linear);
    rotationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    rotationInterpolator.SetStartRotation(currentRotation);
    rotationInterpolator.SetEndRotation(targetRotation);
    this.rotationAnimation.AddInterpolator(rotationInterpolator);
    this.rotationAnimationProxy.Stop();
    this.rotationAnimationProxy = null;
    this.rotationAnimationProxy = inkWidgetRef.PlayAnimation(target, this.rotationAnimation);
  }

  private final func SortingFromUserData(from: String) -> revisedSorting {
    switch from {
      case "Name": return revisedSorting.Name;
      case "Type": return revisedSorting.Type;
      case "Tier": return revisedSorting.Tier;
      case "Price": return revisedSorting.Price;
      case "Weight": return revisedSorting.Weight;
      case "Dps": return revisedSorting.Dps;
      case "Range": return revisedSorting.Range;
      case "Quest": return revisedSorting.Quest;
    };

    return revisedSorting.Name;
  }

  private final func PlaySound(evt: CName) -> Void {
    GameObject.PlaySoundEvent(this.m_player, evt);
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedSorter", str);
    };
  }
}
