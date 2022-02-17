@replaceMethod(BaseMappinBaseController)
  protected func UpdateTrackedState() -> Void {
    let animPlayer: ref<animationPlayer>;
    let i: Int32;
    let isClamped: Bool;
    let isRootVisible: Bool;
    let isTracked: Bool;
    let visible: Bool = false;
    if ArraySize(this.m_taggedWidgets) == 0 {
      return;
    };
    if this.GetProfile().ShowTrackedIcon() {
      isRootVisible = this.GetRootWidget().IsVisible();
      isTracked = this.IsTracked(); // <- old line
      isTracked = false;            // <- new line
      isClamped = this.IsClamped();
      visible = isRootVisible && isTracked && !isClamped;
    };
    i = 0;
    while i < ArraySize(this.m_taggedWidgets) {
      inkWidgetRef.SetVisible(this.m_taggedWidgets[i], visible);
      i += 1;
    };
    animPlayer = this.GetAnimPlayer_Tracked();
    if animPlayer != null {
      animPlayer.PlayOrPause(visible);
    };
  }
