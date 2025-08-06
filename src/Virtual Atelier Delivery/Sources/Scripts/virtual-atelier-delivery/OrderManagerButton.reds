module AtelierDelivery
import Codeware.UI.*

public class OrderManagerButton extends CustomButton {

    protected let m_bg: wref<inkImage>;
    protected let m_frame: wref<inkImage>;

    public final func SetVisible(visible: Bool) -> Void {
      this.m_root.SetVisible(visible);
    }

    protected func CreateWidgets() -> Void {
        let root: ref<inkFlex> = new inkFlex();
        root.SetName(n"button");
        root.SetInteractive(true);
        root.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
        root.SetAnchor(inkEAnchor.CenterRight);
        root.SetHAlign(inkEHorizontalAlign.Right);
        root.SetVAlign(inkEVerticalAlign.Center);
        root.SetSize(new Vector2(100.0, 100.0));

        let minSize: ref<inkRectangle> = new inkRectangle();
        minSize.SetName(n"minSize");
        minSize.SetVisible(false);
        minSize.SetAffectsLayoutWhenHidden(true);
        minSize.SetHAlign(inkEHorizontalAlign.Left);
        minSize.SetVAlign(inkEVerticalAlign.Top);
        minSize.SetSize(new Vector2(280.0, 80.0));
        minSize.Reparent(root);
        
        let frame: ref<inkImage> = new inkImage();
        frame.SetName(n"frame");
        frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        frame.SetTexturePart(n"cell_fg");
        frame.SetNineSliceScale(true);
        frame.SetVAlign(inkEVerticalAlign.Top);
        frame.SetAnchorPoint(new Vector2(0.5, 0.5));
        frame.SetSize(new Vector2(280.0, 80.0));
        frame.SetStyle(r"base\\gameplay\\gui\\common\\dialogs_popups.inkstyle");
        frame.BindProperty(n"tintColor", n"PopupButton.frameColor");
        frame.BindProperty(n"opacity", n"PopupButton.frameOpacity");
        frame.Reparent(root);

        let label: ref<inkText> = new inkText();
        label.SetName(n"label");
        label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        label.SetLetterCase(textLetterCase.UpperCase);
        label.SetHorizontalAlignment(textHorizontalAlignment.Center);
        label.SetVerticalAlignment(textVerticalAlignment.Center);
        label.SetContentHAlign(inkEHorizontalAlign.Center);
        label.SetContentVAlign(inkEVerticalAlign.Center);
        label.SetOverflowPolicy(textOverflowPolicy.AdjustToSize);
        label.SetFitToContent(true);
        label.SetVAlign(inkEVerticalAlign.Center);
        label.SetSize(new Vector2(100.0, 32.0));
        label.SetStyle(r"base\\gameplay\\gui\\common\\dialogs_popups.inkstyle");
        label.BindProperty(n"fontStyle", n"MainColors.BodyFontWeight");
        label.BindProperty(n"fontSize", n"MainColors.ReadableMedium");
        label.BindProperty(n"tintColor", n"PopupButton.textColor");
        label.BindProperty(n"opacity", n"PopupButton.textOpacity");
        label.Reparent(root);

        this.m_root = root;
        this.m_label = label;
        this.m_frame = frame;

        this.SetRootWidget(root);
    }

    protected func ApplyHoveredState() {
        this.m_root.SetState(this.m_isHovered ? n"Hover" : n"Default");
    }

    public func SetHoveredState(isHovered: Bool) -> Void {
      super.SetHoveredState(isHovered);
    }

    public static func Create() -> ref<OrderManagerButton> {
        let self: ref<OrderManagerButton> = new OrderManagerButton();
        self.CreateInstance();
        return self;
    }
}