import MetroPocketGuide.Graph.MetroDirectionChecker

@addField(NcartMetroMapController)
let highlightAnimDef: ref<inkAnimDef>;

@addField(NcartMetroMapController)
private let highlightAnimProxy: ref<inkAnimProxy>;

@addField(NcartMetroMapController)
private let latestMarkerPath: CName = n"";

@addField(NcartMetroMapController)
private let highlightAnimDuration: Float = 0.6;

@wrapMethod(NcartMetroMapController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.InitializeHighlightAnimation();
}

@addMethod(NcartMetroMapController)
protected cb func InitializeHighlightAnimation() -> Bool {
  this.highlightAnimDef = new inkAnimDef();

  let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
  translationInterpolator.SetStartTranslation(Vector2(0.0, 0.0));
  translationInterpolator.SetEndTranslation(Vector2(-16.0, 0.0));
  translationInterpolator.SetType(inkanimInterpolationType.Linear);
  translationInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
  translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
  translationInterpolator.SetDuration(this.highlightAnimDuration);
  this.highlightAnimDef.AddInterpolator(translationInterpolator);

  let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
  transparencyInterpolator.SetStartTransparency(1.0);
  transparencyInterpolator.SetEndTransparency(0.5);
  transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
  transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
  transparencyInterpolator.SetDuration(this.highlightAnimDuration);
  this.highlightAnimDef.AddInterpolator(transparencyInterpolator);
}

@wrapMethod(NcartMetroMapController)
private final func UpdateAvialableLines() -> Void {
  wrappedMethod();
  this.HighlightRecommendedSelection();
}

@wrapMethod(NcartMetroMapController)
protected cb func OnStartupAnimationDone(proxy: ref<inkAnimProxy>) -> Bool {
  GameInstance.GetUISystem(GetGameInstance()).QueueEvent(new ShowPocketGuideWidgetEvent());
  wrappedMethod(proxy);
}

@wrapMethod(NcartMetroMapController)
private final func HideDirectionPanes() -> Void {
  GameInstance.GetUISystem(GetGameInstance()).QueueEvent(new HidePocketGuideWidgetEvent());
  wrappedMethod();
}

@addMethod(NcartMetroMapController)
private final func HighlightRecommendedSelection() -> Void {
  let allLines: array<CName> = [
    n"ue_metro_show_line_a1",
    n"ue_metro_show_line_a2",
    n"ue_metro_show_line_b1",
    n"ue_metro_show_line_b2",
    n"ue_metro_show_line_c1",
    n"ue_metro_show_line_c2",
    n"ue_metro_show_line_d1",
    n"ue_metro_show_line_d2",
    n"ue_metro_show_line_e1",
    n"ue_metro_show_line_e2"
  ];

  let visibleLines: array<CName>;

  for line in allLines {
    if Cast<Bool>(this.m_questsSystem.GetFact(line)) {
      ArrayPush(visibleLines, line);
    };
  };

  let highlightData: ref<LineDirectionData> = MetroDirectionChecker.GetRecommendedHighlight(visibleLines);
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let parent: ref<inkCompoundWidget>;
  let marker: ref<inkImage>;

  // Remove previously added marker
  if NotEquals(this.latestMarkerPath, n"") {
    parent = root.GetWidgetByPathName(this.latestMarkerPath) as inkCompoundWidget;
    parent.RemoveChildByName(n"highlight");
  };

  if IsDefined(highlightData) {
    // Add new marker from actual path
    this.latestMarkerPath = highlightData.path;
    parent = root.GetWidgetByPathName(this.latestMarkerPath) as inkCompoundWidget;
    marker = this.CreateHighlightMarker();
    marker.Reparent(parent);

    // Animate 
    let options: inkAnimOptions;
    options.loopInfinite = true;
    options.loopType = inkanimLoopType.PingPong;
    this.highlightAnimProxy.Stop();
    this.highlightAnimProxy = marker.PlayAnimationWithOptions(this.highlightAnimDef, options);
  };
}
