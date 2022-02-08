module CustomMarkers.UI

import Codeware.UI.*
import Codeware.Localization.*
import CustomMarkers.Config.*
import CustomMarkers.Common.*
import CustomMarkers.UI.*

public class CustomMarkerPopup extends InGamePopup {

  private let m_uiSystem: ref<UISystem>;

  private let m_content: ref<InGamePopupContent>;

  private let m_input: ref<HubTextInput>;

  private let m_icons: array<ref<IconPreviewItem>>;

  private let m_selectedIcon: CName;

  private let m_buttonCancel: ref<MarkerPopupButton>;

  private let m_buttonOk: ref<MarkerPopupButton>;

  private let m_translator: wref<LocalizationSystem>;

  protected cb func OnCreate() -> Void {
    super.OnCreate();
    this.m_translator = LocalizationSystem.GetInstance(this.GetGame());
    this.CreateWidgets();
    this.SetupInitialLayout();
  }

  protected cb func OnShow() -> Void {
    super.OnShow();
    this.m_input.RegisterToCallback(n"OnInput", this, n"OnInput");
  }

  protected cb func OnHide() -> Void {
    super.OnHide();
    this.m_input.UnregisterFromCallback(n"OnInput", this, n"OnInput");
  }

  protected cb func OnClick(widget: wref<inkWidget>) -> Bool {
    let name: CName = widget.GetName();
    let nameString: String = NameToString(name);
    this.PlaySound(n"Button", n"OnPress");
    if StrContains(nameString, "button") {
      this.HandleButtonClick(name);
    } else {
      this.HandleIconClick(name);
    };
  }

  protected cb func OnInput(event: ref<inkCharacterEvent>) -> Void {
    let isDisabled: Bool = StrLen(this.m_input.GetText()) == 0;
    this.m_buttonOk.SetDisabled(isDisabled);
  }

  private func HandleButtonClick(name: CName) -> Void {
    let evt: ref<RequestMarkerCreationEvent>;
    let text: String;
    if Equals(name, n"buttonOk") {
      text = this.m_input.GetText();
      if NotEquals(text, "") {
        evt = new RequestMarkerCreationEvent();
        evt.m_description = text;
        evt.m_texturePart = this.m_selectedIcon;
        this.m_uiSystem.QueueEvent(evt);
      } else {
        CMM("You have not entered marker description");
      };
    };

    this.Close();
  }

  public func SetUISystemInstance(uiSystem: ref<UISystem>) -> Void {
    this.m_uiSystem = uiSystem;
  }

  public func UseCursor() -> Bool {
    return true;
  }

  public static func Show(requester: ref<inkGameController>, player: ref<GameObject>) -> Void {
    let popup: ref<CustomMarkerPopup> = new CustomMarkerPopup();
    popup.SetUISystemInstance(GameInstance.GetUISystem(player.GetGame()));
    popup.Open(requester);
  }

  private func HandleIconClick(name: CName) -> Void {
    this.m_selectedIcon = name;
    for icon in this.m_icons {
      if Equals(this.m_selectedIcon, icon.GetName()) {
        icon.Tint();
      } else {
        icon.Dim();
      };
    };
  }

  private func CreateWidgets() -> Void {
    this.m_content = InGamePopupContent.Create();
    this.m_content.Reparent(this);

    // ROOT
    let root: ref<inkFlex> = this.CreateRootFlex();

    // Root vertical panel which contains top, middle and bottom panels
    let commonPanel: ref<inkVerticalPanel> = new inkVerticalPanel();
    commonPanel.SetFitToContent(true);
    commonPanel.SetHAlign(inkEHorizontalAlign.Center);
    commonPanel.SetVAlign(inkEVerticalAlign.Center);
    commonPanel.SetAnchor(inkEAnchor.Centered);
    commonPanel.SetMargin(new inkMargin(50.0, 50.0, 50.0, 50.0));
    commonPanel.Reparent(root);

    // TOP PANEL: input with text label

    // Text label
    let textInputLabel: ref<inkText> = this.CreateTextLabel(this.m_translator.GetText("CustomMarkers-DescriptionLabel"));
    textInputLabel.SetMargin(new inkMargin(0.0, 0.0, 0.0, 10.0));
    // Input field
    this.m_input = HubTextInput.Create();
    // Top panel
    let topPanel: ref<inkVerticalPanel> = new inkVerticalPanel();
    topPanel.SetMargin(new inkMargin(0.0, 0.0, 0.0, 25.0));
    // Reparent
    textInputLabel.Reparent(topPanel);
    this.m_input.Reparent(topPanel);
    topPanel.Reparent(commonPanel);

    // MIDDLE PANEL: label and horizontal icons list

    // Icons panel 1
    let iconsPanel1: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    iconsPanel1.SetMargin(new inkMargin(0.0, 50.0, 0.0, 0.0));
    let iconNames1: array<CName> = Icons.Row1();
    let atlasResource: ResRef = r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas";
    let newIcon: ref<IconPreviewItem>;
    let margin: inkMargin = new inkMargin(20.0, 0.0, 0.0, 0.0);
    for name in iconNames1 {
      newIcon = IconPreviewItem.Create(atlasResource, name, margin, CustomMarkersConfig.IconColorActive(), CustomMarkersConfig.IconColorInactive());
      newIcon.RegisterToCallback(n"OnClick", this, n"OnClick");
      newIcon.Reparent(iconsPanel1);
      ArrayPush(this.m_icons, newIcon);
    };
    // Icons panel 2
    let iconsPanel2: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    let iconNames2: array<CName> = Icons.Row2();
    for name in iconNames2 {
      newIcon = IconPreviewItem.Create(atlasResource, name, margin, CustomMarkersConfig.IconColorActive(), CustomMarkersConfig.IconColorInactive());
      newIcon.RegisterToCallback(n"OnClick", this, n"OnClick");
      newIcon.Reparent(iconsPanel2);
      ArrayPush(this.m_icons, newIcon);
    };
    // Text label
    let selectIconLabel: ref<inkText> = this.CreateTextLabel(this.m_translator.GetText("CustomMarkers-PickIconLabel"));
    // Middle panel
    let middlePanel: ref<inkVerticalPanel> = new inkVerticalPanel();
    // Reparent
    selectIconLabel.Reparent(middlePanel);
    iconsPanel1.Reparent(middlePanel);
    iconsPanel2.Reparent(middlePanel);
    middlePanel.Reparent(commonPanel);

    // BOTTOM PANNEL

    // Buttons
    this.m_buttonCancel = this.CreateButton(n"buttonCancel", GetLocalizedText("Gameplay-Devices-Interactions-Cancel"));
    this.m_buttonOk = this.CreateButton(n"buttonOk", GetLocalizedText("Gameplay-Devices-Interactions-Ok"));

    // Bottom panel
    let bottomPanel: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    this.m_buttonCancel.Reparent(bottomPanel);
    this.m_buttonOk.Reparent(bottomPanel);
    bottomPanel.Reparent(commonPanel);
    
    root.Reparent(this.m_container);
  }

  private func SetupInitialLayout() -> Void {
    this.m_buttonOk.SetDisabled(true);

    if ArraySize(this.m_icons) > 0 {
      this.m_selectedIcon = this.m_icons[0].GetName();
      this.m_icons[0].Tint();
    };
  }

  private func CreateRootFlex() -> ref<inkFlex> {
    let root: ref<inkFlex> = new inkFlex();
    root.SetName(n"root");
    root.SetMargin(new inkMargin(50.0, 50.0, 50.0, 0.0));
    root.SetAnchor(inkEAnchor.Centered);
    root.SetAnchorPoint(0.5, 0.0);

    let pattern: ref<inkImage> = new inkImage();
    pattern.SetName(n"background");
    pattern.SetNineSliceScale(true);
    pattern.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    pattern.SetBrushTileType(inkBrushTileType.NoTile);
    pattern.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    pattern.SetTexturePart(n"cell_bg");
    pattern.SetContentHAlign(inkEHorizontalAlign.Fill);
    pattern.SetContentVAlign(inkEVerticalAlign.Fill);
    pattern.SetTileHAlign(inkEHorizontalAlign.Left);
    pattern.SetTileVAlign(inkEVerticalAlign.Top);
    pattern.SetTintColor(Colors.BaseBlack());
    pattern.SetOpacity(0.95);
    pattern.Reparent(root);

    let frame: ref<inkImage> = new inkImage();
    frame.SetName(n"frame");
    frame.SetNineSliceScale(true);
    frame.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    frame.SetBrushTileType(inkBrushTileType.NoTile);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"cell_fg");
    frame.SetContentHAlign(inkEHorizontalAlign.Fill);
    frame.SetContentVAlign(inkEVerticalAlign.Fill);
    frame.SetTileHAlign(inkEHorizontalAlign.Left);
    frame.SetTileVAlign(inkEVerticalAlign.Top);
    frame.SetTintColor(Colors.MainRed());
    frame.SetOpacity(0.95);
    frame.Reparent(root);

    return root;
  }

  private func CreateTextLabel(text: String) -> ref<inkText> {
    let label: ref<inkText> = new inkText();
    label.SetName(n"label");
    label.SetText(text);
    label.SetFitToContent(true);
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetFontStyle(n"Regular");
    label.SetFontSize(36);
    label.SetHorizontalAlignment(textHorizontalAlignment.Left);
    label.SetVerticalAlignment(textVerticalAlignment.Top);
    label.SetAnchor(inkEAnchor.TopLeft);
    label.SetLetterCase(textLetterCase.OriginalCase);
    label.SetTintColor(Colors.MainRed());
    return label;
  }

  private func CreateButton(name: CName, text: String) -> ref<MarkerPopupButton> {
    let button: ref<MarkerPopupButton> = MarkerPopupButton.Create();
    button.SetName(name);
    button.SetText(text);
    button.SetWidth(300.0);
    button.SetScale(0.75);
    button.RegisterToCallback(n"OnClick", this, n"OnClick");
    return button;
  }
}
