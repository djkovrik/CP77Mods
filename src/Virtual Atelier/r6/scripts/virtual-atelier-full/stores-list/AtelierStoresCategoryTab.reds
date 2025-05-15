module VirtualAtelier.UI
import VirtualAtelier.Core.AtelierTexts
import VirtualAtelier.Logs.*

public class AtelierStoresCategoryTab extends inkComponent {
  let label: wref<inkText>;
  let category: VirtualStoreCategory;
  let hovered: Bool;
  let selected: Bool;

  public final static func Create(category: VirtualStoreCategory) -> ref<AtelierStoresCategoryTab> {
    let instance: ref<AtelierStoresCategoryTab> = new AtelierStoresCategoryTab();
    instance.category = category;
    return instance;
  }

  protected cb func OnCreate() -> ref<inkWidget> {
    let label: ref<inkText> = new inkText();
    label.SetName(n"label");
    label.SetText("TEST");
    label.SetFitToContent(true);
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetFontSize(44);
    label.SetInteractive(true);
    label.SetLetterCase(textLetterCase.UpperCase);
    label.SetMargin(new inkMargin(32.0, 0.0, 32.0, 0.0));
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", n"MainColors.White");
    return label;
  }

  protected cb func OnInitialize() -> Void {
    this.label = this.GetRootWidget() as inkText;
    this.label.SetText(this.GetCategoryName(this.category));
    this.RegisterInputListeners();
  }

  protected cb func OnUninitialize() -> Void {
    this.UnregisterInputListeners();
  }

  private final func RegisterInputListeners() -> Void {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnClick");
  }

  private final func UnregisterInputListeners() -> Void {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnClick");
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.QueueEvent(AtelierStoreSoundEvent.Create(n"ui_menu_hover"));
    this.hovered = true;
    this.RefreshState();
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
   this.hovered = false;
   this.RefreshState();
  }

  protected cb func OnClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.QueueEvent(AtelierStoreSoundEvent.Create(n"ui_menu_onpress"));
      this.QueueEvent(VirtualStoreCategorySelectedEvent.Create(this.category));
    };
  }

  protected cb func OnVirtualStoreCategorySelectedEvent(evt: ref<VirtualStoreCategorySelectedEvent>) -> Bool {
    this.selected = Equals(this.category, evt.category);
    this.RefreshState();
  }

  private final func RefreshState() -> Void {
    let resultingColor: CName;
    if !this.hovered && !this.selected {
      resultingColor = n"MainColors.White";
    } else if this.hovered && !this.selected {
      resultingColor = n"MainColors.Red";
    } else if !this.hovered && this.selected {
      resultingColor = n"MainColors.Gold";
    } else if this.hovered && this.selected  {
      resultingColor = n"MainColors.ActiveRed";
    };

    this.label.BindProperty(n"tintColor", resultingColor);

    if this.selected {
      this.AnimateScale(this.label, 1.1);
    } else {
      this.AnimateScale(this.label, 1.0);
    };
  }

  private final func GetCategoryName(type: VirtualStoreCategory) -> String {
    switch type {
      case VirtualStoreCategory.AllItems: 
        return AtelierTexts.CategoryAllItems();
      case VirtualStoreCategory.Clothes: 
        return AtelierTexts.CategoryClothes();
      case VirtualStoreCategory.Weapons: 
        return AtelierTexts.CategoryWeapons();
      case VirtualStoreCategory.Cyberware: 
        return AtelierTexts.CategoryCyberware(); 
      case VirtualStoreCategory.Consumables: 
        return AtelierTexts.CategoryConsumables();
      case VirtualStoreCategory.Other: 
        return AtelierTexts.CategoryOthers(); 
    };

    return "";
  }

  private final func AnimateScale(target: ref<inkWidget>, endScale: Float) -> Void {
    let scaleAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let scaleInterpolator: ref<inkAnimScale> = new inkAnimScale();
    scaleInterpolator.SetType(inkanimInterpolationType.Linear);
    scaleInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    scaleInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    scaleInterpolator.SetStartScale(target.GetScale());
    scaleInterpolator.SetEndScale(new Vector2(endScale, endScale));
    scaleInterpolator.SetDuration(0.1);
    scaleAnimDef.AddInterpolator(scaleInterpolator);
    target.PlayAnimation(scaleAnimDef);
  }
}
