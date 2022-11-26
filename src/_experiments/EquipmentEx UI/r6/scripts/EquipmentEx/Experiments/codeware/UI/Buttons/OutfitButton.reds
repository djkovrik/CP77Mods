module EquipmentEx.Codeware.UI

public class OutfitButton extends CustomButton {

  private let m_marker: ref<inkWidget>;

  private static func OpacitySelected() -> Float = 1.0
  private static func OpacityNotSelected() -> Float = 0.6

	protected func CreateWidgets() -> Void {
		let root: ref<inkCanvas> = new inkCanvas();
		root.SetName(n"OutfitButton");
		root.SetSize(600.0, 80.0);
		root.SetAnchorPoint(new Vector2(0.5, 0.5));
		root.SetInteractive(true);

    let marker: ref<inkRectangle> = new inkRectangle();
    marker.SetName(n"RectangleMarker");
    marker.SetAnchor(inkEAnchor.CenterLeft);
    marker.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    marker.BindProperty(n"tintColor", n"MainColors.Red");
    marker.SetOpacity(0.7);
    marker.SetSize(8.0, 50.0);
    marker.SetVisible(false);
    marker.SetMargin(new inkMargin(-30.0, 0.0, 0.0, 0.0));
    marker.Reparent(root);

		let label: ref<inkText> = new inkText();
		label.SetName(n"label");
		label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
		label.SetFontStyle(n"Regular");
		label.SetFontSize(46);
		label.SetLetterCase(textLetterCase.OriginalCase);
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", n"MainColors.Red");
		label.SetAnchor(inkEAnchor.CenterLeft);
		label.SetHorizontalAlignment(textHorizontalAlignment.Left);
		label.SetVerticalAlignment(textVerticalAlignment.Center);
		label.SetText("BUTTON");
		label.SetOpacity(OutfitButton.OpacityNotSelected());
		label.Reparent(root);

		this.m_root = root;
    this.m_marker = marker;
		this.m_label = label;

		this.SetRootWidget(root);
	}

	protected func CreateAnimations() -> Void {

	}

	protected func ApplyFlippedState() -> Void {
		
	}

	protected func ApplyDisabledState() -> Void {

	}

	protected func ApplyHoveredState() -> Void {

	}

	protected func ApplyPressedState() -> Void {

	}

	public static func Create() -> ref<OutfitButton> {
		let self: ref<OutfitButton> = new OutfitButton();
		self.CreateInstance();

		return self;
	}

  public func SetSelected(selected: Bool) -> Void {
    this.m_marker.SetVisible(selected);
    let opacity: Float;
    let color: CName;
    if selected {
      opacity = OutfitButton.OpacitySelected();
      color = n"MainColors.ActiveRed";
    } else {
      opacity = OutfitButton.OpacityNotSelected();
      color = n"MainColors.Red";
    };

    this.m_label.SetOpacity(opacity);
    this.m_label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    this.m_label.UnbindProperty(n"tintColor");
    this.m_label.BindProperty(n"tintColor", color);
  }

  public func SetEquipped(equipped: Bool) -> Void {
    let fontStyle: CName;
    if equipped {
      fontStyle = n"Bold";
      this.m_label.SetOpacity(OutfitButton.OpacitySelected());
    } else {
      fontStyle = n"Regular";
    };

    this.m_label.SetFontStyle(fontStyle);
  }
}
