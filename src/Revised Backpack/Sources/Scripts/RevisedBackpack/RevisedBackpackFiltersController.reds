module RevisedBackpack
import Codeware.UI.HubTextInput
import Codeware.UI.inkCustomController

public class RevisedBackpackFiltersController extends inkLogicController {

  private let m_player: wref<PlayerPuppet>;
  private let m_delaySystem: wref<DelaySystem>;
  private let m_transactionSystem: wref<TransactionSystem>;
  private let m_debounceCalbackId: DelayID;

  private let nameFilterInput: wref<HubTextInput>;
  private let typeFilterInput: wref<HubTextInput>;

  private let checkboxTier1Frame: wref<inkWidget>;
  private let checkboxTier2Frame: wref<inkWidget>;
  private let checkboxTier3Frame: wref<inkWidget>;
  private let checkboxTier4Frame: wref<inkWidget>;
  private let checkboxTier5Frame: wref<inkWidget>;

  private let checkboxTier1Thumb: wref<inkWidget>;
  private let checkboxTier2Thumb: wref<inkWidget>;
  private let checkboxTier3Thumb: wref<inkWidget>;
  private let checkboxTier4Thumb: wref<inkWidget>;
  private let checkboxTier5Thumb: wref<inkWidget>;

  private let buttonsContainer: wref<inkWidget>;
  private let buttonSelect: wref<RevisedFiltersButton>;
  private let buttonJunk: wref<RevisedFiltersButton>;
  private let buttonDisassemble: wref<RevisedFiltersButton>;
  private let buttonReset: wref<RevisedFiltersButton>;
  
  private let ammoContainer: wref<inkWidget>;
  private let ammoButtonHandgun: wref<RevisedBackpackFilterAmmoButton>;
  private let ammoButtonShotgun: wref<RevisedBackpackFilterAmmoButton>;
  private let ammoButtonRifle: wref<RevisedBackpackFilterAmmoButton>;
  private let ammoButtonSniperRifle: wref<RevisedBackpackFilterAmmoButton>;

  private let m_animProxy: ref<inkAnimProxy>;

  private let nameInput: String = "";
  private let typeInput: String = "";
  private let ammo: TweakDBID = t"";
  private let tier1Enabled: Bool = true;
  private let tier2Enabled: Bool = true;
  private let tier3Enabled: Bool = true;
  private let tier4Enabled: Bool = true;
  private let tier5Enabled: Bool = true;
  private let resetAvailable: Bool = false;
  private let selectionAvailable: Bool = false;
  private let massActionsAvailable: Bool = false;
  private let ammoFiltersAvailable: Bool = false;

  protected cb func OnInitialize() -> Bool {
    this.m_player = GetPlayer(GetGameInstance());
    this.m_delaySystem = GameInstance.GetDelaySystem(this.m_player.GetGame());
    this.m_transactionSystem = GameInstance.GetTransactionSystem(this.m_player.GetGame());
    this.BuildWidgetsLayout();
    this.RegisterListeners();
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterListeners();
    this.m_delaySystem.CancelCallback(this.m_debounceCalbackId);

    if IsDefined(this.m_animProxy) {
      if this.m_animProxy.IsPlaying() {
        this.m_animProxy.Stop();
        this.m_animProxy = null;
      };
    }
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
    this.nameInput = this.nameFilterInput.GetText();
    if StrLen(this.nameInput) > 0 {
      this.ApplyFiltersDelayed();
    } else {
      this.ApplyFilters();
    };
  }

  protected cb func OnTypeFilterInput(widget: wref<inkWidget>) {
    this.typeInput = this.typeFilterInput.GetText();
    if StrLen(this.typeInput) > 0 {
      this.ApplyFiltersDelayed();
    } else {
      this.ApplyFilters();
    };
  }

  protected cb func OnRevisedCategorySelectedEvent(evt: ref<RevisedCategorySelectedEvent>) -> Bool {
    this.selectionAvailable = NotEquals(evt.category.id, 10);
    this.ammoFiltersAvailable = Equals(evt.category.id, 20);
    this.InvalidateMassActionsButtons();
    this.UpdateAmmoFiltersVisibility();
  }

  protected cb func OnRevisedBackpackSelectedItemsCountChangedEvent(evt: ref<RevisedBackpackSelectedItemsCountChangedEvent>) -> Bool {
    this.massActionsAvailable = this.selectionAvailable && evt.count > 0;
    this.InvalidateMassActionsButtons();
  }

  public final func ApplyFiltersDelayed() -> Void {
    let callback: ref<RevisedBackpackFilterDebounceCallback> = new RevisedBackpackFilterDebounceCallback();
    callback.m_controller = this;
    this.m_delaySystem.CancelCallback(this.m_debounceCalbackId);
    this.m_debounceCalbackId = this.m_delaySystem.DelayCallback(callback, 0.2, false);
  }

  protected cb func OnRevisedAmmoFilterSelectedEvent(evt: ref<RevisedAmmoFilterSelectedEvent>) -> Bool {
    this.ammo = evt.ammoId;
    this.ApplyFilters();
  }

  public final func ApplyFilters() -> Void {
    this.Log("ApplyFilters");
    this.InvalidateResetButtonState();
    this.BroadcastFiltersState();
  }

  private final func ResetFilters() -> Void {
    this.Log("ResetFilters");
    this.PlaySound(n"ui_menu_onpress");
    this.nameInput = "";
    this.typeInput = "";
    this.ammo = t"";
    this.tier1Enabled = true;
    this.tier2Enabled = true;
    this.tier3Enabled = true;
    this.tier4Enabled = true;
    this.tier5Enabled = true;
    this.nameFilterInput.SetText(this.nameInput);
    this.typeFilterInput.SetText(this.typeInput);
    this.QueueEvent(RevisedAmmoFilterResetEvent.Create());
    this.InvalidateCheckboxes();
    this.InvalidateResetButtonState();
    this.BroadcastFiltersState();
  }

  private final func RunSelectAction() -> Void {
    this.PlaySound(n"ui_menu_onpress");
    this.QueueEvent(RevisedFiltersActionEvent.Create(revisedFiltersAction.Select));
  }

  private final func RunJunkAction() -> Void {
    this.PlaySound(n"ui_menu_onpress");
    this.QueueEvent(RevisedFiltersActionEvent.Create(revisedFiltersAction.Junk));
  }

  private final func RunDisassembleAction() -> Void {
    this.PlaySound(n"ui_menu_onpress");
    this.QueueEvent(RevisedFiltersActionEvent.Create(revisedFiltersAction.Disassemble));
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
      case n"buttonReset":
        if this.resetAvailable {
          this.ResetFilters();
        };
        break;
      case n"buttonSelect":
        if this.selectionAvailable {
          this.RunSelectAction();
        };
        break;
      case n"buttonJunk":
        if this.massActionsAvailable {
          this.RunJunkAction();
        };
        break;
      case n"buttonDisassemble":
        if this.massActionsAvailable {
          this.RunDisassembleAction();
        };
        break;
    };
  };

  private final func HandleWidgetHoverOver(name: CName) -> Void {
    switch name {
      case n"tier1":
        this.checkboxTier1Frame.BindProperty(n"tintColor", n"MainColors.Blue");
        break;
      case n"tier2":
        this.checkboxTier2Frame.BindProperty(n"tintColor", n"MainColors.Blue");
        break;
      case n"tier3":
        this.checkboxTier3Frame.BindProperty(n"tintColor", n"MainColors.Blue");
        break;
      case n"tier4":
        this.checkboxTier4Frame.BindProperty(n"tintColor", n"MainColors.Blue");
        break;
      case n"tier5":
        this.checkboxTier5Frame.BindProperty(n"tintColor", n"MainColors.Blue");
        break;
    };
  }

  private final func HandleWidgetHoverOut(name: CName) -> Void {
    switch name {
      case n"tier1":
        this.checkboxTier1Frame.BindProperty(n"tintColor", n"MainColors.MildBlue");
        break;
      case n"tier2":
        this.checkboxTier2Frame.BindProperty(n"tintColor", n"MainColors.MildBlue");
        break;
      case n"tier3":
        this.checkboxTier3Frame.BindProperty(n"tintColor", n"MainColors.MildBlue");
        break;
      case n"tier4":
        this.checkboxTier4Frame.BindProperty(n"tintColor", n"MainColors.MildBlue");
        break;
      case n"tier5":
        this.checkboxTier5Frame.BindProperty(n"tintColor", n"MainColors.MildBlue");
        break;
    };
  }

  private final func InvalidateResetButtonState() -> Void {
    let hasUncheckedCheckboxes: Bool = !this.tier1Enabled || !this.tier2Enabled || !this.tier3Enabled || !this.tier4Enabled || !this.tier5Enabled;
    let inputHasText: Bool = StrLen(this.nameInput) > 0 || StrLen(this.typeInput) > 0;
    let hasAmmoToggled: Bool = NotEquals(this.ammo, t"");
    this.resetAvailable = hasUncheckedCheckboxes || inputHasText || hasAmmoToggled;
    this.buttonReset.SetDisabled(!this.resetAvailable);
  }

  private final func InvalidateMassActionsButtons() -> Void {
    this.UpdateButtonsContainerVisibility();
    this.buttonJunk.SetDisabled(!this.massActionsAvailable);
    this.buttonDisassemble.SetDisabled(!this.massActionsAvailable);
  }

  private final func UpdateButtonsContainerVisibility() -> Void {
    if Equals(this.selectionAvailable, this.buttonsContainer.IsVisible()) {
      return;
    };

    let start: Float;
    let end: Float;
    if this.selectionAvailable {
      start = 0.0;
      end = 1.0;
    } else {
      start = 1.0;
      end = 0.0;
    };

    this.buttonsContainer.SetOpacity(start);
    let container: ref<inkAnimDef> = this.AnimateOpacity(0.2, start, end);
    this.m_animProxy = this.buttonsContainer.PlayAnimation(container);
  }

  private final func UpdateAmmoFiltersVisibility() -> Void {
    if Equals(this.ammoFiltersAvailable, this.ammoContainer.IsVisible()) {
      return;
    };

    let start: Float;
    let end: Float;
    if this.ammoFiltersAvailable {
      start = 0.0;
      end = 1.0;
    } else {
      start = 1.0;
      end = 0.0;
    };

    this.ammoContainer.SetOpacity(start);
    let container: ref<inkAnimDef> = this.AnimateOpacity(0.2, start, end);
    this.m_animProxy = this.ammoContainer.PlayAnimation(container);
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
  }

  private final func BroadcastFiltersState() -> Void {
    let filtersReset: Bool = this.buttonReset.IsDisabled();
    let tiers: array<gamedataQuality>;
    if this.tier5Enabled {
      ArrayPush(tiers, gamedataQuality.LegendaryPlusPlus);
      ArrayPush(tiers, gamedataQuality.LegendaryPlus);
      ArrayPush(tiers, gamedataQuality.Legendary);
    };
    if this.tier4Enabled {
      ArrayPush(tiers, gamedataQuality.EpicPlus);
      ArrayPush(tiers, gamedataQuality.Epic);
    };
    if this.tier3Enabled {
      ArrayPush(tiers, gamedataQuality.RarePlus);
      ArrayPush(tiers, gamedataQuality.Rare);
    };
    if this.tier2Enabled {
      ArrayPush(tiers, gamedataQuality.UncommonPlus);
      ArrayPush(tiers, gamedataQuality.Uncommon);
    };
    if this.tier1Enabled {
      ArrayPush(tiers, gamedataQuality.CommonPlus);
      ArrayPush(tiers, gamedataQuality.Common);
    };
    
    let event: ref<RevisedFilteringEvent> = RevisedFilteringEvent.Create(this.nameInput, this.typeInput, tiers, this.ammo, filtersReset);
    this.Log(s"BroadcastFiltersState with [\(this.nameInput)] and [\(this.typeInput)], and tiers \(ArraySize(tiers)), and ammo \(TDBID.ToStringDEBUG(this.ammo))");
    this.QueueEvent(event);
  }

  private final func BuildWidgetsLayout() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();

    let outerContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    outerContainer.SetName(n"outerContainer");
    outerContainer.Reparent(root);

    let leftColumn: ref<inkVerticalPanel> = new inkVerticalPanel();
    leftColumn.SetName(n"leftColumn");
    leftColumn.SetMargin(new inkMargin(0.0, 0.0, 96.0, 0.0));
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
    checkboxesRow.SetChildMargin(new inkMargin(0.0, 0.0, 24.0, 0.0));
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
    rightColumn.SetOpacity(0.0);
    rightColumn.SetAffectsLayoutWhenHidden(true);
    rightColumn.SetChildMargin(new inkMargin(0.0, 0.0, 0.0, 24.0));
    rightColumn.Reparent(outerContainer);
    this.buttonsContainer = rightColumn;

    let buttonSelect: ref<RevisedFiltersButton> = RevisedFiltersButton.Create();
    buttonSelect.SetName(n"buttonSelect");
    buttonSelect.SetText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Select"));
    buttonSelect.Reparent(rightColumn);
    this.buttonSelect = buttonSelect;

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
    buttonDisassemble.SetAsDangerous();
    buttonDisassemble.Reparent(rightColumn);
    this.buttonDisassemble = buttonDisassemble;

    let ammoColumn: ref<inkVerticalPanel> = new inkVerticalPanel();
    ammoColumn.SetName(n"ammoColumn");
    ammoColumn.SetOpacity(0.0);
    ammoColumn.SetAffectsLayoutWhenHidden(true);
    ammoColumn.SetMargin(new inkMargin(64.0, 0.0, 0.0, 0.0));
    ammoColumn.Reparent(outerContainer);
    this.ammoContainer = ammoColumn;

    let ammoRow1: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    ammoRow1.SetName(n"ammoRow1");
    ammoRow1.SetChildMargin(new inkMargin(48.0, 0.0, 0.0, 48.0));
    ammoRow1.Reparent(ammoColumn);

    let handgunAmmoQuery: ItemID = ItemID.CreateQuery(t"Ammo.HandgunAmmo");
    let handgunCount: Int32 = this.m_transactionSystem.GetItemQuantity(this.m_player, handgunAmmoQuery);
    let ammoHandgun: ref<RevisedBackpackFilterAmmoButton> = new RevisedBackpackFilterAmmoButton();
    ammoHandgun.SetName(n"ammoHandgun");
    ammoHandgun.SetAmmoId(t"Ammo.HandgunAmmo");
    ammoHandgun.SetCount(handgunCount);
    ammoHandgun.Reparent(ammoRow1);
    this.ammoButtonHandgun = ammoHandgun;

    let shotgunAmmoQuery: ItemID = ItemID.CreateQuery(t"Ammo.ShotgunAmmo");
    let shotgunCount: Int32 = this.m_transactionSystem.GetItemQuantity(this.m_player, shotgunAmmoQuery);
    let ammoShotgun: ref<RevisedBackpackFilterAmmoButton> = new RevisedBackpackFilterAmmoButton();
    ammoShotgun.SetName(n"ammoShotgun");
    ammoShotgun.SetAmmoId(t"Ammo.ShotgunAmmo");
    ammoShotgun.SetCount(shotgunCount);
    ammoShotgun.Reparent(ammoRow1);
    this.ammoButtonShotgun = ammoShotgun;

    let ammoRow2: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    ammoRow2.SetName(n"ammoRow2");
    ammoRow2.SetChildMargin(new inkMargin(48.0, 0.0, 0.0, 48.0));
    ammoRow2.Reparent(ammoColumn);

    let rifleAmmoQuery: ItemID = ItemID.CreateQuery(t"Ammo.RifleAmmo");
    let rifleCount: Int32 = this.m_transactionSystem.GetItemQuantity(this.m_player, rifleAmmoQuery);
    let ammoRifle: ref<RevisedBackpackFilterAmmoButton> = new RevisedBackpackFilterAmmoButton();
    ammoRifle.SetName(n"ammoRifle");
    ammoRifle.SetAmmoId(t"Ammo.RifleAmmo");
    ammoRifle.SetCount(rifleCount);
    ammoRifle.Reparent(ammoRow2);
    this.ammoButtonRifle = ammoRifle;

    let sniperRifleAmmoQuery: ItemID = ItemID.CreateQuery(t"Ammo.SniperRifleAmmo");
    let sniperRifleCount: Int32 = this.m_transactionSystem.GetItemQuantity(this.m_player, sniperRifleAmmoQuery);
    let ammoSniperRifle: ref<RevisedBackpackFilterAmmoButton> = new RevisedBackpackFilterAmmoButton();
    ammoSniperRifle.SetName(n"ammoSniperRifle");
    ammoSniperRifle.SetAmmoId(t"Ammo.SniperRifleAmmo");
    ammoSniperRifle.SetCount(sniperRifleCount);
    ammoSniperRifle.Reparent(ammoRow2);
    this.ammoButtonSniperRifle = ammoSniperRifle;
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
    checkbox.BindProperty(n"tintColor", n"MainColors.Blue");
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
    frame.BindProperty(n"tintColor", n"MainColors.MildBlue");
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
    bg.BindProperty(n"tintColor", n"MainColors.FaintBlue");
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

  private final func AnimateOpacity(duration: Float, start: Float, end: Float) -> ref<inkAnimDef> {
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();

    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(0.0);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(start);
    transparencyInterpolator.SetEndTransparency(end);

    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    
    return moveElementsAnimDef;
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
