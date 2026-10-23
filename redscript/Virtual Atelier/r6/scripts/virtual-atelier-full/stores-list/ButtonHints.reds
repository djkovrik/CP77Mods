// Kept to overwrite the old file on update
module VirtualAtelier.UI

public abstract class AtelierStoresListButtonHints {
  public final static func Spawn(parent: ref<inkGameController>, container: ref<inkCompoundWidget>) -> ref<ButtonHints> {
    let widget: ref<inkWidget> = parent.SpawnFromExternal(container, r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root");
    widget.SetScale(Vector2(1.1, 1.1));
    let buttonHints: ref<ButtonHints> = widget.GetController() as ButtonHints;
    return buttonHints;
  }
}
