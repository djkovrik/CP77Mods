module HudPainter
import Codeware.UI.*

class HudPainterController extends gameuiSettingsMenuGameController {
  private let m_activePresetName: inkTextRef;
  private let m_buttonHintsSlot: inkWidgetRef;
  private let m_colorPickerSlot: inkWidgetRef;
  private let m_colorsListContainer: inkWidgetRef;
  private let m_legendItemDefault: inkWidgetRef;
  private let m_legendItemJohnny: inkWidgetRef;
  private let m_presetManagerButtons: inkWidgetRef;
  private let m_presetsListContainer: inkWidgetRef;
  private let m_screenTitle: inkWidgetRef;
  private let m_screenTitleImage: inkWidgetRef;
  private let m_slotTitleColors: inkWidgetRef;
  private let m_slotTitleLegend: inkWidgetRef;
  private let m_slotTitlePresets: inkWidgetRef;
  private let m_widgetsPreviewSlot: inkWidgetRef;

  private let m_storage: wref<HudPainterStorage>;
  private let m_player: wref<GameObject>;
  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;
  private let m_buttonHintsController: wref<ButtonHints>;
  private let m_buttonActivate: wref<SimpleButton>;
  private let m_buttonSave: wref<SimpleButton>;
  private let m_popupToken: ref<inkGameNotificationToken>;
  private let m_currentSelectedPreset: ref<HudPainterPresetItem>;

  private let m_colorItems: array<ref<HudPainterColorItem>>;
  private let m_presetItems: array<ref<HudPainterPresetItem>>;

  protected cb func OnInitialize() {
    this.m_storage = HudPainterStorage.Get();
    this.m_player = this.GetPlayerControlledObject();

    this.SetupScreenContent();
    this.RegisterCallbacks();
    this.CheckForExistingArchive();
  }


  // -- CORE

  protected cb func OnSetMenuEventDispatcher(menuEventDispatcher: wref<inkMenuEventDispatcher>) -> Bool {
    super.OnSetMenuEventDispatcher(menuEventDispatcher);
    this.m_menuEventDispatcher = menuEventDispatcher;
    this.m_menuEventDispatcher.RegisterToEvent(n"OnBack", this, n"OnBack");
  }

  protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
    this.m_menuEventDispatcher.SpawnEvent(n"OnCloseHudPainterScreen");
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_menuEventDispatcher.UnregisterFromEvent(n"OnBack", this, n"OnBack");
    this.UnregisterCallbacks();
  }

  private final func RegisterCallbacks() -> Void {
    this.m_buttonActivate.RegisterToCallback(n"OnBtnClick", this, n"OnPresetActivateClick");
    this.m_buttonSave.RegisterToCallback(n"OnBtnClick", this, n"OnPresetSaveClick");
  }

  private final func UnregisterCallbacks() -> Void {
    this.m_buttonActivate.UnregisterFromCallback(n"OnBtnClick", this, n"OnPresetActivateClick");
    this.m_buttonSave.UnregisterFromCallback(n"OnBtnClick", this, n"OnPresetSaveClick");
  }


  // -- EVENTS

  protected cb func OnHudPainterSoundEmitted(evt: ref<HudPainterSoundEmitted>) -> Bool {
    GameObject.PlaySoundEvent(this.m_player, evt.name);
  }

	protected cb func OnPresetActivateClick(widget: wref<inkWidget>) -> Bool {
    this.Log(s"Activate preset clicked");
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
    this.m_storage.SaveActivePresetName(this.m_currentSelectedPreset.name);
    this.m_buttonActivate.SetDisabled(true);
    inkWidgetRef.SetVisible(this.m_colorPickerSlot, false);
    this.RefreshInkStyle();
	}

	protected cb func OnPresetSaveClick(widget: wref<inkWidget>) -> Bool {
    this.Log(s"Save preset clicked");
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
    this.m_popupToken = GenericMessageNotification.ShowInput(this, GetLocalizedTextByKey(n"Mod-HudPainter-Save-Preset-Title"), GetLocalizedTextByKey(n"Mod-HudPainter-Save-Preset-Hint"), GenericMessageNotificationType.ConfirmCancel);
    this.m_popupToken.RegisterListener(this, n"OnSavePresetPopupClosed");
	}

  protected cb func OnHudPainterColorSelected(evt: ref<HudPainterColorSelected>) -> Bool {
    if !inkWidgetRef.IsVisible(this.m_colorPickerSlot) {
      inkWidgetRef.SetVisible(this.m_colorPickerSlot, true);
    };
  }

  protected cb func OnHudPainterPresetSelected(evt: ref<HudPainterPresetSelected>) -> Bool {
    this.Log(s"Preset selected: \(evt.data.name)");
    this.m_currentSelectedPreset = evt.data;
    this.m_buttonActivate.SetDisabled(this.m_currentSelectedPreset.active);
  }

  protected cb func OnHudPainterPresetSaved(evt: ref<HudPainterPresetSaved>) -> Bool {
    this.RefreshInkStyle();
  }

  protected cb func OnHudPainterInkStyleRefreshed(evt: ref<HudPainterInkStyleRefreshed>) -> Bool {
    this.Log("inkStyle refreshed!");
    this.UnregisterCallbacks();
    this.SetupScreenContent();
    this.RegisterCallbacks();
  }


  // -- SCREEN CONTENT

  private final func RefreshButtonHints() -> Void {
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_buttonHintsSlot) as inkCompoundWidget;
    container.RemoveAllChildren();
    this.m_buttonHintsController = this.SpawnFromExternal(
      container, 
      r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", 
      n"Root"
    ).GetController() as ButtonHints;

    this.m_buttonHintsController.ClearButtonHints();
    this.m_buttonHintsController.AddButtonHint(n"back", "Common-Access-Close");
  }

  private final func RefreshColorsList() -> Void {
    this.m_colorItems = this.m_storage.GetActivePresetData();
    this.Log(s"Active preset loaded: \(ArraySize(this.m_colorItems)) colors");

    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_colorsListContainer) as inkCompoundWidget;
    container.RemoveAllChildren();

    let component: ref<ComponentColorItem>;
    for colorItem in this.m_colorItems {
      component = new ComponentColorItem();
      component.Reparent(container);
      component.SetData(colorItem);
    };
  }

  private final func RefreshColorPicker() -> Void {
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_colorPickerSlot) as inkCompoundWidget;
    container.RemoveAllChildren();
    this.SpawnFromLocal(container, n"ColorPicker");
    inkWidgetRef.SetVisible(this.m_colorPickerSlot, false);
  }

  private final func RefreshPresetManagerButtons() -> Void {
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_presetManagerButtons) as inkCompoundWidget;
    container.RemoveAllChildren();

    let buttonActivate: ref<SimpleButton> = SimpleButton.Create();
    buttonActivate.SetName(n"buttonActivate");
    buttonActivate.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Activate-Preset"));
    buttonActivate.ToggleAnimations(true);
    buttonActivate.ToggleSounds(true);
    buttonActivate.SetDisabled(true);
    buttonActivate.Reparent(container);
    this.m_buttonActivate = buttonActivate;

    let buttonSave: ref<SimpleButton> = SimpleButton.Create();
    buttonSave.SetName(n"buttonSave");
    buttonSave.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Save-Preset"));
    buttonSave.ToggleAnimations(true);
    buttonSave.ToggleSounds(true);
    buttonSave.Reparent(container);
    this.m_buttonSave = buttonSave;
  }

  private final func RefreshPresetsList() -> Void {
    this.m_presetItems = this.m_storage.GetAvailablePresetsList();
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_presetsListContainer) as inkCompoundWidget;
    container.RemoveAllChildren();

    let component: ref<ComponentPresetItem>;
    for presetItem in this.m_presetItems {
      component = new ComponentPresetItem();
      component.Reparent(container);
      component.SetData(presetItem);
    };
    this.Log(s"Presets list loaded: \(ArraySize(this.m_presetItems)) items, container available: \(IsDefined(container))");
  }

  private final func RefreshTitles() {
    let presetPrefix: String = GetLocalizedTextByKey(n"Mod-HudPainter-Presets-Active");
    let presetName: String = this.m_storage.GetActivePresetName();
    let presetNameWidget: ref<inkText> = inkWidgetRef.Get(this.m_activePresetName) as inkText;
    presetNameWidget.UnbindProperty(n"tintColor");
    presetNameWidget.BindProperty(n"tintColor", n"MainColors.Blue");
    presetNameWidget.SetText(s"\(presetPrefix): \(presetName)");

    let colorsTitle: ref<inkWidget> = inkWidgetRef.Get(this.m_slotTitleColors);
    colorsTitle.UnbindProperty(n"tintColor");
    colorsTitle.BindProperty(n"tintColor", n"MainColors.Blue");

    let legendTitle: ref<inkWidget> = inkWidgetRef.Get(this.m_slotTitleLegend);
    legendTitle.UnbindProperty(n"tintColor");
    legendTitle.BindProperty(n"tintColor", n"MainColors.Blue");

    let presetsTitle: ref<inkWidget> = inkWidgetRef.Get(this.m_slotTitlePresets);
    presetsTitle.UnbindProperty(n"tintColor");
    presetsTitle.BindProperty(n"tintColor", n"MainColors.Blue");

    let legendItemDefault: ref<inkWidget> = inkWidgetRef.Get(this.m_legendItemDefault);
    legendItemDefault.UnbindProperty(n"tintColor");
    legendItemDefault.BindProperty(n"tintColor", n"MainColors.Red");

    let legendItemJohnny: ref<inkWidget> = inkWidgetRef.Get(this.m_legendItemJohnny);
    legendItemJohnny.UnbindProperty(n"tintColor");
    legendItemJohnny.BindProperty(n"tintColor", n"MainColors.Green");

    let screenTitle: ref<inkWidget> = inkWidgetRef.Get(this.m_screenTitle);
    screenTitle.UnbindProperty(n"tintColor");
    screenTitle.BindProperty(n"tintColor", n"MainColors.PanelRed");

    let screenTitleImage: ref<inkWidget> = inkWidgetRef.Get(this.m_screenTitleImage);
    screenTitleImage.UnbindProperty(n"tintColor");
    screenTitleImage.BindProperty(n"tintColor", n"MainColors.PanelRed");
  }

  private final func RefreshInkStyle() -> Void {
    this.m_storage.PatchCurrentInkStyleResource();
  }


  // -- POPUP CALLBACKS

  protected cb func OnSavePresetPopupClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    let isInputValid: Bool = NotEquals(resultData.input, "") && NotEquals(resultData.input, this.m_storage.GetDefaultPresetName());

    if Equals(resultData.result, GenericMessageNotificationResult.Confirm) && isInputValid {
      this.PlaySound(n"Item", n"OnBuy");
      this.SaveCurrentColorsAsPreset(resultData.input);
    };

    this.m_popupToken = null;

    if Equals(resultData.input, this.m_storage.GetDefaultPresetName()) {
      this.m_popupToken = HudPainterWarningPopup.Show(this, GetLocalizedTextByKey(n"Mod-HudPainter-Default-Overwrite"));
      this.m_popupToken.RegisterListener(this, n"OnDefaultPresetNamePopupClosed");
    };
  }

  protected cb func OnDefaultPresetNotFoundPopupClosed(data: ref<inkGameNotificationData>) {
    this.m_popupToken = null;
    this.m_menuEventDispatcher.SpawnEvent(n"OnCloseHudPainterScreen");
  }

  protected cb func OnDefaultPresetNamePopupClosed(data: ref<inkGameNotificationData>) {
    this.m_popupToken = null;
  }


  // -- UTILITY

  private final func SaveCurrentColorsAsPreset(presetName: String) -> Void {
    let currentColors: array<ref<HudPainterColorItem>>;
    let colorItem: ref<HudPainterColorItem>;
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_colorsListContainer) as inkCompoundWidget;
    let child: ref<ComponentColorItem>;
    let childNumber: Int32 = container.GetNumChildren();
    let index: Int32 = 0;
    while index < childNumber {
      child = container.GetWidgetByIndex(index).GetController() as ComponentColorItem;
      if IsDefined(child) {
        colorItem = child.GetData();
        ArrayPush(currentColors, colorItem);
      };
      index += 1;
    };

    if ArraySize(currentColors) > 0 {
      this.Log(s"Saving \(ArraySize(currentColors)) items to preset \(presetName)");
      this.m_storage.SaveNewPresetData(presetName, currentColors);
    } else {
      this.Log(s"Preset not saved!");
    };
  }

  private final func SetupScreenContent() -> Void {
    this.RefreshButtonHints();
    this.RefreshColorsList();
    this.RefreshColorPicker();
    this.RefreshPresetManagerButtons();
    this.RefreshPresetsList();
    this.RefreshTitles();
  }

  private final func CheckForExistingArchive() -> Void {
    if this.m_storage.IsDefaultPresetMissing() {
      this.m_popupToken = HudPainterWarningPopup.Show(this, GetLocalizedTextByKey(n"Mod-HudPainter-Default-Missed"));
      this.m_popupToken.RegisterListener(this, n"OnDefaultPresetNotFoundPopupClosed");
    };
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"Screen", str);
    };
  }
}
