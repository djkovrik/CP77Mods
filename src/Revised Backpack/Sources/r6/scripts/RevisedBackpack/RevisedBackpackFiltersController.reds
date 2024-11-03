module RevisedBackpack
import Codeware.UI.HubTextInput
import Codeware.UI.inkCustomController

public class RevisedBackpackFiltersController extends inkLogicController {

  private let m_player: wref<PlayerPuppet>;
  private let m_delaySystem: wref<DelaySystem>;
  private let m_debounceCalbackId: DelayID;

  private let nameFilterInput: wref<HubTextInput>;
  private let typeFilterInput: wref<HubTextInput>;

  private let checkboxTier1Frame: wref<inkWidget>;
  private let checkboxTier2Frame: wref<inkWidget>;
  private let checkboxTier3Frame: wref<inkWidget>;
  private let checkboxTier4Frame: wref<inkWidget>;
  private let checkboxTier5Frame: wref<inkWidget>;
  private let checkboxMassActionFrame: wref<inkWidget>;

  private let checkboxTier1Thumb: wref<inkWidget>;
  private let checkboxTier2Thumb: wref<inkWidget>;
  private let checkboxTier3Thumb: wref<inkWidget>;
  private let checkboxTier4Thumb: wref<inkWidget>;
  private let checkboxTier5Thumb: wref<inkWidget>;
  private let checkboxMassActionThumb: wref<inkWidget>;

  private let buttonJunk: wref<RevisedFiltersButton>;
  private let buttonDisassemble: wref<RevisedFiltersButton>;
  private let buttonReset: wref<RevisedFiltersButton>;

  private let tier1Enabled: Bool = true;
  private let tier2Enabled: Bool = true;
  private let tier3Enabled: Bool = true;
  private let tier4Enabled: Bool = true;
  private let tier5Enabled: Bool = true;
  private let resetAvailable: Bool = false;
  private let massActionsEnabled: Bool = false;

  protected cb func OnInitialize() -> Bool {
    this.BuildWidgetsLayout();
    this.RegisterListeners();
    this.m_player = GetPlayer(GetGameInstance());
    this.m_delaySystem = GameInstance.GetDelaySystem(this.m_player.GetGame());
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterListeners();
    this.m_delaySystem.CancelCallback(this.m_debounceCalbackId);
  }

  private final func RegisterListeners() -> Void {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
  }

  private final func UnregisterListeners() -> Void {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let targetName: CName = target.GetName();
    this.HandleWidgetHoverOver(targetName);
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let targetName: CName = target.GetName();
    this.HandleWidgetHoverOut(targetName);
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget>;
    let targetName: CName;
    if evt.IsAction(n"click") {
      target = evt.GetTarget();
      targetName = target.GetName();
      this.HandleWidgetClick(targetName);
    };
  }

  protected cb func OnNameFilterInput(widget: wref<inkWidget>) {
    let currentText: String = this.nameFilterInput.GetText();
    if StrLen(currentText) > 0 {
      this.ApplyFiltersDelayed();
    } else {
      this.ApplyFilters();
    };
  }

  protected cb func OnTypeFilterInput(widget: wref<inkWidget>) {
    let currentText: String = this.typeFilterInput.GetText();
    if StrLen(currentText) > 0 {
      this.ApplyFiltersDelayed();
    } else {
      this.ApplyFilters();
    };
  }

  public final func ApplyFiltersDelayed() -> Void {
    let callback: ref<RevisedBackpackFilterDebounceCallback> = new RevisedBackpackFilterDebounceCallback();
    callback.m_controller = this;
    this.m_delaySystem.CancelCallback(this.m_debounceCalbackId);
    this.m_debounceCalbackId = this.m_delaySystem.DelayCallback(callback, 1.0, false);
  }

  public final func ApplyFilters() -> Void {
    this.Log("ApplyFilters");
    this.InvalidateResetButtonState();
    this.BroadcastFiltersState();
  }

  private final func ResetFilters() -> Void {
    this.Log("ResetFilters");
    this.PlaySound(n"ui_menu_onpress");
    this.nameFilterInput.SetText("");
    this.typeFilterInput.SetText("");
    this.tier1Enabled = true;
    this.tier2Enabled = true;
    this.tier3Enabled = true;
    this.tier4Enabled = true;
    this.tier5Enabled = true;
    this.InvalidateCheckboxes();
    this.InvalidateResetButtonState();
    this.BroadcastFiltersState();
  }

  private final func RunJunkAction() -> Void {
    this.Log(s"RunJunkAction: mass \(this.massActionsEnabled)");
    this.PlaySound(n"ui_menu_onpress");
  }

  private final func RunDisassembleAction() -> Void {
    this.Log(s"RunDisassembleAction: mass \(this.massActionsEnabled)");
    this.PlaySound(n"ui_menu_onpress");
  }

  private final func HandleWidgetClick(name: CName) -> Void {
    switch name {
      case n"tier1":
        this.PlaySound(n"ui_menu_onpress");
        this.tier1Enabled = !this.tier1Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"tier2":
        this.PlaySound(n"ui_menu_onpress");
        this.tier2Enabled = !this.tier2Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"tier3":
        this.PlaySound(n"ui_menu_onpress");
        this.tier3Enabled = !this.tier3Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"tier4":
        this.PlaySound(n"ui_menu_onpress");
        this.tier4Enabled = !this.tier4Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"tier5":
        this.PlaySound(n"ui_menu_onpress");
        this.tier5Enabled = !this.tier5Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"actions":
        this.PlaySound(n"ui_menu_onpress");
        this.massActionsEnabled = !this.massActionsEnabled;
        this.InvalidateCheckboxes();
        this.InvalidateMassActions();
        break;
      case n"buttonReset":
        if this.resetAvailable {
          this.ResetFilters();
        };
        break;
      case n"buttonJunk":
        if this.massActionsEnabled {
          this.RunJunkAction();
        };
        break;
      case n"buttonDisassemble":
        if this.massActionsEnabled {
          this.RunDisassembleAction();
        };
        break;
    };
  };

  private final func HandleWidgetHoverOver(name: CName) -> Void {
    switch name {
      case n"tier1":
        this.checkboxTier1Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
      case n"tier2":
        this.checkboxTier2Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
      case n"tier3":
        this.checkboxTier3Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
      case n"tier4":
        this.checkboxTier4Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
      case n"tier5":
        this.checkboxTier5Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
      case n"actions":
        this.checkboxMassActionFrame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
    };
  }

  private final func HandleWidgetHoverOut(name: CName) -> Void {
    switch name {
      case n"tier1":
        this.checkboxTier1Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
      case n"tier2":
        this.checkboxTier2Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
      case n"tier3":
        this.checkboxTier3Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
      case n"tier4":
        this.checkboxTier4Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
      case n"tier5":
        this.checkboxTier5Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
      case n"actions":
        this.checkboxMassActionFrame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
    };
  }

  private final func InvalidateResetButtonState() -> Void {
    let hasUncheckedCheckboxes: Bool = false;
    for widget in [this.checkboxTier1Thumb, this.checkboxTier2Thumb, this.checkboxTier3Thumb, this.checkboxTier4Thumb, this.checkboxTier5Thumb] {
      if !widget.IsVisible() {
        hasUncheckedCheckboxes = true;
      };
    };

    let inputHasText: Bool = StrLen(this.nameFilterInput.GetText()) > 0 || StrLen(this.typeFilterInput.GetText()) > 0;
    this.resetAvailable = hasUncheckedCheckboxes || inputHasText;
    this.buttonReset.SetDisabled(!this.resetAvailable);
  }

  private final func InvalidateMassActions() -> Void {
    this.buttonJunk.SetDisabled(!this.massActionsEnabled);
    this.buttonDisassemble.SetDisabled(!this.massActionsEnabled);
  }

  private final func InvalidateCheckboxes() -> Void {
    if NotEquals(this.checkboxTier1Thumb.IsVisible(), this.tier1Enabled) {
      this.checkboxTier1Thumb.SetVisible(this.tier1Enabled);
    };
    if NotEquals(this.checkboxTier2Thumb.IsVisible(), this.tier2Enabled) {
      this.checkboxTier2Thumb.SetVisible(this.tier2Enabled);
    };
    if NotEquals(this.checkboxTier3Thumb.IsVisible(), this.tier3Enabled) {
      this.checkboxTier3Thumb.SetVisible(this.tier3Enabled);
    };
    if NotEquals(this.checkboxTier4Thumb.IsVisible(), this.tier4Enabled) {
      this.checkboxTier4Thumb.SetVisible(this.tier4Enabled);
    };
    if NotEquals(this.checkboxTier5Thumb.IsVisible(), this.tier5Enabled) {
      this.checkboxTier5Thumb.SetVisible(this.tier5Enabled);
    };
    if NotEquals(this.checkboxMassActionThumb.IsVisible(), this.massActionsEnabled) {
      this.checkboxMassActionThumb.SetVisible(this.massActionsEnabled);
    };
  }

  private final func BroadcastFiltersState() -> Void {
    let nameQuery: String = this.nameFilterInput.GetText();
    let typeQuery: String = this.typeFilterInput.GetText();
    let noFiltersApplied: Bool = this.buttonReset.IsDisabled();
    this.Log(s"Broadcast filters state \(this.tier1Enabled) \(this.tier2Enabled) \(this.tier3Enabled) \(this.tier4Enabled) \(this.tier5Enabled) + [\(nameQuery)] and [\(typeQuery)], no filters: \(noFiltersApplied)");
  }

  private final func BuildWidgetsLayout() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();

    let outerContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    outerContainer.SetName(n"outerContainer");
    outerContainer.Reparent(root);

    let leftColumn: ref<inkVerticalPanel> = new inkVerticalPanel();
    leftColumn.SetName(n"leftColumn");
    leftColumn.SetMargin(new inkMargin(0.0, 0.0, 64.0, 0.0));
    leftColumn.Reparent(outerContainer);

    let inputRow: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    inputRow.SetName(n"inputRow");
    inputRow.SetMargin(new inkMargin(0.0, 0.0, 0.0, 32.0));
    inputRow.SetChildMargin(new inkMargin(0.0, 0.0, 16.0, 0.0));
    inputRow.Reparent(leftColumn);

    let nameFilterInput: ref<HubTextInput> = HubTextInput.Create();
    nameFilterInput.SetName(n"nameFilterInput");
    nameFilterInput.SetLetterCase(textLetterCase.UpperCase);
    nameFilterInput.SetDefaultText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Input-Name"));
    nameFilterInput.SetWidth(756.0);
    nameFilterInput.RegisterToCallback(n"OnInput", this, n"OnNameFilterInput");
    nameFilterInput.Reparent(inputRow);
    this.nameFilterInput = nameFilterInput;

    let typeFilterInput: ref<HubTextInput> = HubTextInput.Create();
    typeFilterInput.SetName(n"typeFilterInput");
    typeFilterInput.SetLetterCase(textLetterCase.UpperCase);
    typeFilterInput.SetDefaultText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Input-Type"));
    typeFilterInput.SetWidth(402.0);
    typeFilterInput.RegisterToCallback(n"OnInput", this, n"OnTypeFilterInput");
    typeFilterInput.Reparent(inputRow);
    this.typeFilterInput = typeFilterInput;

    let checkboxesRow: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    checkboxesRow.SetName(n"checkboxesRow");
    checkboxesRow.SetMargin(new inkMargin(0.0, 0.0, 0.0, 32.0));
    checkboxesRow.SetChildMargin(new inkMargin(0.0, 0.0, 32.0, 0.0));
    checkboxesRow.Reparent(leftColumn);

    let tier1: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier1", n"Gameplay-RPG-Stats-Tiers-Tier1", this.tier1Enabled);
    let tier2: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier2", n"Gameplay-RPG-Stats-Tiers-Tier2", this.tier2Enabled);
    let tier3: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier3", n"Gameplay-RPG-Stats-Tiers-Tier3", this.tier3Enabled);
    let tier4: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier4", n"Gameplay-RPG-Stats-Tiers-Tier4", this.tier4Enabled);
    let tier5: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier5", n"Gameplay-RPG-Stats-Tiers-Tier5", this.tier5Enabled);
    this.checkboxTier1Frame = tier1.GetWidgetByPathName(n"tier1/frame");
    this.checkboxTier2Frame = tier2.GetWidgetByPathName(n"tier2/frame");
    this.checkboxTier3Frame = tier3.GetWidgetByPathName(n"tier3/frame");
    this.checkboxTier4Frame = tier4.GetWidgetByPathName(n"tier4/frame");
    this.checkboxTier5Frame = tier5.GetWidgetByPathName(n"tier5/frame");
    this.checkboxTier1Thumb = tier1.GetWidgetByPathName(n"tier1/thumb");
    this.checkboxTier2Thumb = tier2.GetWidgetByPathName(n"tier2/thumb");
    this.checkboxTier3Thumb = tier3.GetWidgetByPathName(n"tier3/thumb");
    this.checkboxTier4Thumb = tier4.GetWidgetByPathName(n"tier4/thumb");
    this.checkboxTier5Thumb = tier5.GetWidgetByPathName(n"tier5/thumb");

    tier1.Reparent(checkboxesRow);
    tier2.Reparent(checkboxesRow);
    tier3.Reparent(checkboxesRow);
    tier4.Reparent(checkboxesRow);
    tier5.Reparent(checkboxesRow);

    let buttonReset: ref<RevisedFiltersButton> = RevisedFiltersButton.Create();
    buttonReset.SetName(n"buttonReset");
    buttonReset.SetText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Reset"));
    buttonReset.SetDisabled(true);
    buttonReset.Reparent(leftColumn);
    this.buttonReset = buttonReset;


    let rightColumn: ref<inkVerticalPanel> = new inkVerticalPanel();
    rightColumn.SetName(n"rightColumn");
    rightColumn.SetChildMargin(new inkMargin(0.0, 0.0, 0.0, 32.0));
    rightColumn.Reparent(outerContainer);

    let buttonJunk: ref<RevisedFiltersButton> = RevisedFiltersButton.Create();
    buttonJunk.SetName(n"buttonJunk");
    buttonJunk.SetText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Junk"));
    buttonJunk.SetDisabled(true);
    buttonJunk.Reparent(rightColumn);
    this.buttonJunk = buttonJunk;

    let buttonDisassemble: ref<RevisedFiltersButton> = RevisedFiltersButton.Create();
    buttonDisassemble.SetName(n"buttonDisassemble");
    buttonDisassemble.SetText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Disassemble"));
    buttonDisassemble.SetDisabled(true);
    buttonDisassemble.Reparent(rightColumn);
    this.buttonDisassemble = buttonDisassemble;

    let massActions: ref<inkCompoundWidget> = this.BuildCheckbox(n"actions", n"Mod-Revised-Filter-Mass-Action", this.massActionsEnabled);
    this.checkboxMassActionFrame = massActions.GetWidgetByPathName(n"actions/frame");
    this.checkboxMassActionThumb = massActions.GetWidgetByPathName(n"actions/thumb");
    massActions.Reparent(rightColumn);
  }

  private final func BuildCheckbox(name: CName, displayNameKey: CName, initial: Bool) -> ref<inkCompoundWidget> {
    // Common container
    let checkboxContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    checkboxContainer.SetName(name);
    
    // Checkbox container
    let internalContainer: ref<inkCanvas> = new inkCanvas();
    internalContainer.SetName(name);
    internalContainer.SetSize(64.0, 64.0);
    internalContainer.SetFitToContent(false);
    internalContainer.SetInteractive(true);
    internalContainer.SetChildOrder(inkEChildOrder.Backward);
    internalContainer.SetAnchor(inkEAnchor.CenterLeft);
    internalContainer.SetHAlign(inkEHorizontalAlign.Left);
    internalContainer.SetVAlign(inkEVerticalAlign.Center);
    internalContainer.Reparent(checkboxContainer);

    // Checkbox selector
    let checkbox: ref<inkImage> = new inkImage();
    checkbox.SetName(n"thumb");
    checkbox.SetAnchor(inkEAnchor.Centered);
    checkbox.SetAnchorPoint(0.5, 0.5);
    checkbox.SetMargin(1.0, 1.0, 0.0, 0.0);
    checkbox.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    checkbox.BindProperty(n"tintColor", n"MainColors.Red");
    checkbox.SetSize(38.0, 38.0);
    checkbox.SetOpacity(0.5);
    checkbox.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    checkbox.SetTexturePart(n"color_bg");
    checkbox.SetVisible(initial);
    checkbox.SetNineSliceScale(true);
    checkbox.Reparent(internalContainer);

    // Checkbox frame
    let frame: ref<inkImage> = new inkImage();
    frame.SetName(n"frame");
    frame.SetAnchor(inkEAnchor.Fill);
    frame.SetAnchorPoint(0.5, 0.5);
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.BindProperty(n"tintColor", n"MainColors.MildRed");
    frame.SetSize(64.0, 64.0);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"color_fg");
    frame.SetNineSliceScale(true);
    frame.Reparent(internalContainer);

    // Checkbox bg
    let bg: ref<inkImage> = new inkImage();
    bg.SetName(n"background");
    bg.SetAnchor(inkEAnchor.Fill);
    bg.SetAnchorPoint(0.5, 0.5);
    bg.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    bg.BindProperty(n"tintColor", n"MainColors.FaintRed");
    bg.SetSize(64.0, 64.0);
    bg.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    bg.SetTexturePart(n"color_bg");
    bg.SetNineSliceScale(true);
    bg.Reparent(internalContainer);

    // Checkbox label
    let label: ref<inkText> = new inkText();
    label.SetName(n"label");
    label.SetText(GetLocalizedTextByKey(displayNameKey));
    label.SetMargin(new inkMargin(16.0, 0.0, 0.0, 0.0));
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetFontSize(42);
    label.SetFitToContent(true);
    label.SetVAlign(inkEVerticalAlign.Center);
    label.SetLetterCase(textLetterCase.OriginalCase);
    label.SetAnchor(inkEAnchor.TopLeft);
    label.SetHAlign(inkEHorizontalAlign.Left);
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", n"MainColors.Red");
    label.Reparent(checkboxContainer);

    return checkboxContainer;
  }

  private final func PlaySound(evt: CName) -> Void {
    GameObject.PlaySoundEvent(this.m_player, evt);
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedFilters", str);
    };
  }
}
