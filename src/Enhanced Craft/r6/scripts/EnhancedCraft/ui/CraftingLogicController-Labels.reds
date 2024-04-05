module EnhancedCraft.UI
import EnhancedCraft.Config.*

// -- New text label for available skins counter
@addField(CraftingLogicController)
private let availableSkinsText: wref<inkText>;

// -- New text label for current selected variant
@addField(CraftingLogicController)
private let currentVariantCounter: wref<inkText>;

// -- New text label for Randomizer status
@addField(CraftingLogicController)
private let randomizerText: wref<inkText>;

// -- Inject new text labels into CraftingLogicController root compound widget
@wrapMethod(CraftingLogicController)
public func Init(craftingGameController: wref<CraftingMainGameController>) -> Void {
  wrappedMethod(craftingGameController);

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let counterContainer: ref<inkCompoundWidget> = root.GetWidget(n"inkCanvasWidget2/inkCanvasWidget7/itemDetailsContainer/weaponPreviewContainer") as inkCompoundWidget;
  let textContainer: ref<inkCompoundWidget> = root.GetWidget(n"inkCanvasWidget2/inkCanvasWidget7/itemDetailsContainer/weaponPreviewContainer") as inkCompoundWidget;

  if !IsDefined(this.availableSkinsText) || NotEquals(this.availableSkinsText.GetName(), n"AvailableSkinsLabel") {
    let skins: ref<inkText> = new inkText();
    skins.SetName(n"AvailableSkinsLabel");
    skins.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    skins.SetFontStyle(inkTextRef.GetFontStyle(this.m_perkNotificationText));
    skins.SetFontSize(inkTextRef.GetFontSize(this.m_perkNotificationText));
    skins.SetHAlign(inkEHorizontalAlign.Left);
    skins.SetVAlign(inkEVerticalAlign.Bottom);
    skins.SetAnchor(inkEAnchor.BottomLeft);
    skins.SetAnchorPoint(0.0, 1.0);
    skins.SetMargin(new inkMargin(0.0, 0.0, 0.0, 45.0));
    skins.SetLetterCase(textLetterCase.UpperCase);
    skins.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    skins.BindProperty(n"tintColor", n"MainColors.Red");
    skins.Reparent(textContainer);
    this.availableSkinsText = skins;
  };

  if !IsDefined(this.currentVariantCounter) || NotEquals(this.currentVariantCounter.GetName(), n"AvailableSkinsLabel") {
    let counter: ref<inkText> = new inkText();
    counter.SetName(n"AvailableSkinsLabel");
    counter.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    counter.SetFontStyle(inkTextRef.GetFontStyle(this.m_perkNotificationText));
    counter.SetFontSize(inkTextRef.GetFontSize(this.m_perkNotificationText));
    counter.SetHAlign(inkEHorizontalAlign.Right);
    counter.SetVAlign(inkEVerticalAlign.Top);
    counter.SetAnchor(inkEAnchor.TopRight);
    counter.SetAnchorPoint(1.0, 1.0);
    counter.SetMargin(new inkMargin(0.0, -60.0, 45.0, 0.0));
    counter.SetLetterCase(textLetterCase.UpperCase);
    counter.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    counter.BindProperty(n"tintColor", n"MainColors.Red");
    counter.Reparent(counterContainer);
    this.currentVariantCounter = counter;
  };

  if !IsDefined(this.randomizerText) || NotEquals(this.randomizerText.GetName(), n"RandomizerLabel") {
    let randomizer: ref<inkText> = new inkText();
    randomizer.SetName(n"RandomizerLabel");
    randomizer.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    randomizer.SetFontStyle(inkTextRef.GetFontStyle(this.m_perkNotificationText));
    randomizer.SetFontSize(inkTextRef.GetFontSize(this.m_perkNotificationText));
    randomizer.SetHAlign(inkEHorizontalAlign.Left);
    randomizer.SetVAlign(inkEVerticalAlign.Bottom);
    randomizer.SetAnchor(inkEAnchor.BottomLeft);
    randomizer.SetAnchorPoint(0.0, 1.0);
    randomizer.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    randomizer.SetLetterCase(textLetterCase.UpperCase);
    randomizer.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    randomizer.BindProperty(n"tintColor", n"MainColors.Red");
    randomizer.Reparent(textContainer);
    this.randomizerText = randomizer;
  };
}

// -- Refresh available skins counter state
@addMethod(CraftingLogicController)
public func RefreshSkinsCounter() -> Void {
  let size: Int32 = ArraySize(this.selectedRecipeVariants);
  if size > 1 {
    this.availableSkinsText.SetVisible(true);
    this.availableSkinsText.SetText(s"\(GetLocalizedTextByKey(n"Mod-Craft-UI-Variants")) \(size)");
  } else {
    this.availableSkinsText.SetVisible(false);
  };
}

// -- Refresh current skin index state
@addMethod(CraftingLogicController)
public func RefreshCurrentVariantCounter(current: Int32, total: Int32) -> Void {
  let size: Int32 = ArraySize(this.selectedRecipeVariants);
  if size > 1 && !this.ecraftConfig.randomizerEnabled {
    this.currentVariantCounter.SetVisible(true);
    this.currentVariantCounter.SetText(s"\(current) / \(total)");
  } else {
    this.currentVariantCounter.SetVisible(false);
  };
}

// -- Refresh Randomizer label state
@addMethod(CraftingLogicController)
public func RefreshRandomizerLabel() -> Void {
  if ArraySize(this.selectedRecipeVariantsNoIconics) > 1 {
    this.randomizerText.SetVisible(true);
    if this.ecraftConfig.randomizerEnabled {
      this.randomizerText.SetText(GetLocalizedTextByKey(n"Mod-Craft-UI-Randomizer-Enabled"));
    } else {
      this.randomizerText.SetText(GetLocalizedTextByKey(n"Mod-Craft-UI-Randomizer-Disabled"));
    };
  } else {
    this.randomizerText.SetVisible(false);
  };
}
