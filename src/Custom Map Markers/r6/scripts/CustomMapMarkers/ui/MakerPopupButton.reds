module CustomMarkers.UI

import CustomMapMarkers.Codeware.UI.*

public class MarkerPopupButton extends SimpleButton {

  public func SetScale(scale: Float) -> Void {
    this.m_root.SetScale(new Vector2(scale, scale));
  }

  public static func Create() -> ref<MarkerPopupButton> {
    let self: ref<MarkerPopupButton> = new MarkerPopupButton();
    self.CreateInstance();

    return self;
  }
}
