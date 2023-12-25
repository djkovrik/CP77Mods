import MetroPocketGuide.Graph.MetroDirectionChecker

@addField(NcartMetroMapController)
private let pulseHighlight: ref<PulseAnimation>;

@addField(NcartMetroMapController)
private let latestMarkerPath: CName = n"";

@wrapMethod(NcartMetroMapController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.pulseHighlight = new PulseAnimation();
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
    marker = this.CreateHighlightMarker(highlightData.line);
    marker.Reparent(parent);
    this.pulseHighlight.Stop();
    this.pulseHighlight.Configure(marker, 1.0, 0.1, 0.6);
    this.pulseHighlight.Start();
  };
}
