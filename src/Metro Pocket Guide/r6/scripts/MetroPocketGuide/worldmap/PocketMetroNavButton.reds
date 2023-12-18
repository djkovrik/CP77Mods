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
    this.m_icon.SetMargin(0.0, 30.0, 0.0, 6.0);
    this.m_icon.SetSize(new Vector2(82.0, 44.0));
    this.m_icon.SetTexturePart(n"ncart_logo_simple");
    this.m_icon.SetAtlasResource(r"base\\open_world\\metro\\ue_metro\\ui\\assets\\ue_metro_main_atlas.inkatlas");
  }
}
