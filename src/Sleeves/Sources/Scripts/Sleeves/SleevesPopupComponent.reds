import Codeware.UI.*

public class SleevesPopupComponent extends inkComponent {
  private let data: ref<SleevesInfoBundle>;

  protected cb func OnCreate() -> ref<inkWidget> {
    // Root
    let root: ref<inkFlex> = new inkFlex();
    root.SetName(n"Root");
    root.SetInteractive(true);
    root.SetFitToContent(true);
    
    // Internal container
    let internalPanel: ref<inkVerticalPanel> = new inkVerticalPanel();
    internalPanel.SetName(n"internalPanel");
    internalPanel.SetFitToContent(true);
    internalPanel.SetHAlign(inkEHorizontalAlign.Center);
    internalPanel.SetVAlign(inkEVerticalAlign.Center);
    internalPanel.SetAnchor(inkEAnchor.Centered);
    internalPanel.SetMargin(inkMargin(16.0, 16.0, 16.0, 16.0));
    internalPanel.Reparent(root);

    // - Mode label
    let modeName: ref<inkText> = new inkText();
    modeName.SetName(n"modeName");
    modeName.SetText(s"Test");
    modeName.SetMargin(inkMargin(0.0, 0.0, 0.0, 8.0));
    modeName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    modeName.SetFontSize(42);
    modeName.SetFitToContent(true);
    modeName.SetLetterCase(textLetterCase.OriginalCase);
    modeName.SetAnchor(inkEAnchor.TopLeft);
    modeName.SetHAlign(inkEHorizontalAlign.Left);
    modeName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    modeName.BindProperty(n"tintColor", n"MainColors.Blue");
    modeName.SetOpacity(0.75);
    modeName.Reparent(internalPanel);

    // - Items panel
    let items: ref<inkVerticalPanel> = new inkVerticalPanel();
    items.SetName(n"items");
    items.SetFitToContent(true);
    items.Reparent(internalPanel);

    return root;
  }

  protected cb func OnInitialize() {
    this.UpdateContent();
  }

  protected cb func OnUninitialize() {
    // 
  }

  private final func UpdateContent() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let itemsContainer: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"internalPanel/items") as inkCompoundWidget;
    if IsDefined(this.data) && ArraySize(this.data.items) > 0 {
      for item in this.data.items {
        let component: ref<SleevesPopupItemComponent> = new SleevesPopupItemComponent();
        component.SetData(item);
        component.SetMode(this.data.mode);
        component.Reparent(itemsContainer);
      };
    };

    let modeName: ref<inkText> = root.GetWidgetByPathName(n"internalPanel/modeName") as inkText;
    modeName.SetText(this.data.GetLocalizedModeName());
  }

  public final func SetData(data: ref<SleevesInfoBundle>) -> Void {
    this.data = data;
  }
}
