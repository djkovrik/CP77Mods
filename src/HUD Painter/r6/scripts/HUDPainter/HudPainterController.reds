module HudPainter
import Codeware.UI.*

class HudPainterController extends gameuiSettingsMenuGameController {
  private let m_activePresetName: inkWidgetRef;
  private let m_buttonHintsSlot: inkWidgetRef;
  private let m_colorPickerSlot: inkWidgetRef;
  private let m_presetManagerButtons: inkWidgetRef;
  private let m_colorsListContainer: inkWidgetRef;
  private let m_presetsListContainer: inkWidgetRef;

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
    
    this.m_buttonHintsController = this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_buttonHintsSlot), 
      r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", 
      n"Root"
    ).GetController() as ButtonHints;

    this.AddInitialButtonHints();
    this.SpawnColorPicker();
    this.CreatePresetManagerButtons();
    this.RegisterCallbacks();
    this.RefreshScreenData();

    if this.m_storage.IsDefaultPresetMissing() {
      this.m_popupToken = HudPainterWarningPopup.Show(this, GetLocalizedTextByKey(n"Mod-HudPainter-Default-Missed"));
      this.m_popupToken.RegisterListener(this, n"OnDefaultPresetNotFoundPopupClosed");
    };
  }

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

  protected cb func OnHudPainterSoundEmitted(evt: ref<HudPainterSoundEmitted>) -> Bool {
    GameObject.PlaySoundEvent(this.m_player, evt.name);
  }

	protected cb func OnPresetActivateClick(widget: wref<inkWidget>) -> Bool {
    this.Log(s"Activate preset clicked");
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
    this.m_storage.SaveActivePresetName(this.m_currentSelectedPreset.name);
    this.RefreshScreenData();
    this.m_buttonActivate.SetDisabled(true);
    inkWidgetRef.SetVisible(this.m_colorPickerSlot, false);
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

  protected cb func OnHudPainterPresetSelected(evt: ref<HudPainterPresetSelected>) -> Bool {
    this.Log(s"Preset selected: \(evt.data.name)");
    this.m_currentSelectedPreset = evt.data;
    this.RefreshButtonsState();
  }

  protected cb func OnHudPainterPresetSaved(evt: ref<HudPainterPresetSaved>) -> Bool {
    this.RefreshScreenData();
    inkWidgetRef.SetVisible(this.m_colorPickerSlot, false);
  }

  private final func AddInitialButtonHints() -> Void {
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

  private final func SpawnColorPicker() -> Void {
    this.SpawnFromLocal(inkWidgetRef.Get(this.m_colorPickerSlot), n"ColorPicker");
    inkWidgetRef.SetVisible(this.m_colorPickerSlot, false);
  }

  private final func CreatePresetManagerButtons() -> Void {
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_presetManagerButtons) as inkCompoundWidget;

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

  private final func RegisterCallbacks() -> Void {
    this.m_buttonActivate.RegisterToCallback(n"OnBtnClick", this, n"OnPresetActivateClick");
    this.m_buttonSave.RegisterToCallback(n"OnBtnClick", this, n"OnPresetSaveClick");
  }

  private final func UnregisterCallbacks() -> Void {
    this.m_buttonActivate.UnregisterFromCallback(n"OnBtnClick", this, n"OnPresetActivateClick");
    this.m_buttonSave.UnregisterFromCallback(n"OnBtnClick", this, n"OnPresetSaveClick");
  }

  private final func RefereshActivePresetTitle() {
    let activePresetName: ref<inkText> = inkWidgetRef.Get(this.m_activePresetName) as inkText;
    let presetPrefix: String = GetLocalizedTextByKey(n"Mod-HudPainter-Presets-Active");
    let presetName: String = this.m_storage.GetActivePresetName();
    activePresetName.SetText(s"\(presetPrefix): \(presetName)");
  }

  private final func RefreshButtonsState() -> Void {
    this.m_buttonActivate.SetDisabled(this.m_currentSelectedPreset.active);
  }

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

  private final func RefreshScreenData() -> Void {
    this.RefereshActivePresetTitle();
    this.RefreshPresetsList();
    this.RefreshColorsList();
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"Screen", str);
    };
  }
}
