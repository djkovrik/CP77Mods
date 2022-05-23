import LimitedHudConfig.LHUDAddonsConfig

// Hide overhead subtitles
@wrapMethod(ChattersGameController)
protected func ShouldDisplayLine(lineData: scnDialogLineData) -> Bool {
  let shouldDisplayOriginal: Bool = wrappedMethod(lineData);
  if LHUDAddonsConfig.RemoveOverheadSubtitles() {
    return shouldDisplayOriginal && !lineData.speaker.IsHostile();
  } else {
    return shouldDisplayOriginal;
  };
}
