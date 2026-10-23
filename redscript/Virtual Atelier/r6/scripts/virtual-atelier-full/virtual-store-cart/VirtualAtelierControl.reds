module VirtualAtelier.UI

public abstract class VirtualAtelierControl extends inkComponent {
  protected let enabled: Bool;

  protected cb func OnInitialize() {
    this.enabled = true;
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
  }

  protected cb func OnUninitialize() {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    if this.enabled {
      this.OnControlHoverOver();
    };
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    if this.enabled {
      this.OnControlHoverOut();
    };
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") && this.enabled {
      this.PlaySound(n"Button", n"OnPress");
      this.OnControlClick();
    };
  }

  protected func OnControlHoverOver() -> Void
  protected func OnControlHoverOut() -> Void

  protected func OnControlClick() -> Void {
    this.QueueEvent(VirtualAtelierControlClickEvent.Create(this.GetName()));
  }

  public func SetEnabled(enabled: Bool) -> Void {
    this.enabled = enabled;
  }

  public func Dim(dim: Bool) -> Void {
    if dim {
      this.GetRootWidget().SetOpacity(0.2);
    } else {
      this.GetRootWidget().SetOpacity(1.0);
    };
  }

  public func SetName(name: CName) -> Void {
    this.GetRootWidget().SetName(name);
  }

  public func GetName() -> CName {
    return this.GetRootWidget().GetName();
  }
}
