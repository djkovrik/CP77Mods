module CombatAwareness

public abstract class AwarenessUI {

  // lockeys helper
  public static func Text(key: String) -> String {
    return GetLocalizedTextByKey(StringToName("Mod-CombatAwareness-" + key));
  }

  public static func Label(parent: ref<inkCompoundWidget>, x: Float, y: Float, size: Int32) -> ref<inkText> {
    let label: ref<inkText> = new inkText();
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Medium");
    label.SetFontSize(size);
    label.SetFitToContent(true);
    label.SetAnchor(inkEAnchor.Centered);
    label.SetAnchorPoint(Vector2(0.5, 0.5));
    label.SetTranslation(Vector2(x, y));
    label.Reparent(parent);
    return label;
  }
}
