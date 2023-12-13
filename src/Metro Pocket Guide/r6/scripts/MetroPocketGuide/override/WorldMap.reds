import Codeware.UI.*

public class PocketMetroNavButton extends HubLinkButton {

  public static func Create() -> ref<PocketMetroNavButton> {
    let self = new PocketMetroNavButton();
    self.CreateInstance();
    return self;
  }

  protected cb func OnCreate() {
      super.OnCreate();
      this.TweakAppearance();
  }

  public func SetVisible(visible: Bool) -> Void {
    this.m_root.SetVisible(visible);
  }

  private final func TweakAppearance() -> Void {
    this.m_icon.SetTexturePart(n"metro");
    this.m_icon.SetAtlasResource(r"base\\open_world\\metro\\ue_metro\\ui\\assets\\ncart_icon64.inkatlas");
  }
}

enum PocketMetroWordlMapMode {
  NONE = 0,
  SELECTION_NONE_SELECTED = 1,
  SELECTION_ONE_SELECTED = 2,
  SELECTION_BOTH_SELECTED = 3,
  HAS_SELECTED_ROUTE = 4,
}

@addField(WorldMapMenuGameController)
public let metroButtonNavigate: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
public let metroButtonCancel: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
public let metroButtonStop: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
public let pocketMetroMode: PocketMetroWordlMapMode = PocketMetroWordlMapMode.NONE;

@wrapMethod(WorldMapMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.AddMetroPocketGuideControls();
}

@addMethod(WorldMapMenuGameController)
private final func AddMetroPocketGuideControls() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let parent: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"Content") as inkCompoundWidget;
  let buttonsContainer: ref<inkCompoundWidget> = new inkCanvas();
  buttonsContainer.SetName(n"buttonsContainer");
  buttonsContainer.SetAnchor(inkEAnchor.TopRight);
  buttonsContainer.SetFitToContent(true);
  buttonsContainer.SetInteractive(false);
  buttonsContainer.SetAnchorPoint(1.0, 0.0);
  buttonsContainer.SetMargin(0.0, 360.0, 400.0, 0.0);
  buttonsContainer.Reparent(parent);

  this.metroButtonNavigate = PocketMetroNavButton.Create();
  this.metroButtonNavigate.SetName(n"buttonNavigate");
  this.metroButtonNavigate.SetText("Navigate");
  this.metroButtonNavigate.RegisterToCallback(n"OnClick", this, n"OnNavigateButtonClick");
  this.metroButtonNavigate.Reparent(buttonsContainer);

  this.metroButtonCancel = PocketMetroNavButton.Create();
  this.metroButtonCancel.SetName(n"buttonCancel");
  this.metroButtonCancel.SetText("Cancel");
  this.metroButtonCancel.SetVisible(false);
  this.metroButtonCancel.RegisterToCallback(n"OnClick", this, n"OnCancelButtonClick");
  this.metroButtonCancel.Reparent(buttonsContainer);

  this.metroButtonStop = PocketMetroNavButton.Create();
  this.metroButtonStop.SetText("Stop");
  this.metroButtonStop.SetName(n"buttonStop");
  this.metroButtonStop.SetVisible(false);
  this.metroButtonStop.RegisterToCallback(n"OnClick", this, n"OnStopButtonClick");
  this.metroButtonStop.Reparent(buttonsContainer);
}


@addMethod(WorldMapMenuGameController)
protected cb func OnNavigateButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    MetroLog("Navigate");
    this.PlaySound(n"Button", n"OnPress");
  }
}

@addMethod(WorldMapMenuGameController)
protected cb func OnCancelButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    MetroLog("Cancel");
    this.PlaySound(n"Button", n"OnPress");
  }
}

@addMethod(WorldMapMenuGameController)
protected cb func OnStopButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    MetroLog("Stop");
    this.PlaySound(n"Button", n"OnPress");
  }
}

@wrapMethod(WorldMapMenuGameController)
private final func HandlePressInput(e: ref<inkPointerEvent>) -> Void {
  if this.ShouldSkipEventHandle(e) {
    e.Handle();
  } else {
    wrappedMethod(e);
  };
}

@wrapMethod(WorldMapMenuGameController)
private final func HandleReleaseInput(e: ref<inkPointerEvent>) -> Void {
  if this.ShouldSkipEventHandle(e) {
    e.Handle();
  } else {
    wrappedMethod(e);
  };
}

@addMethod(WorldMapMenuGameController)
private final func ShouldSkipEventHandle(e: ref<inkPointerEvent>) -> Bool {
  let targetName: CName = e.GetTarget().GetName();
  let customButtons: array<CName> = [ n"buttonNavigate", n"buttonCancel", n"buttonStop" ];
  return ArrayContains(customButtons, targetName);
}
