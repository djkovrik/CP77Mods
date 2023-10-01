module EnhancedCraft.UI
import EnhancedCraft.Config.*

// -- New text label for available skins counter
@addField(CraftingLogicController)
private let m_availableSkinsText: wref<inkText>;

// -- New text label for Randomizer status
@addField(CraftingLogicController)
private let m_randomizerText: wref<inkText>;

// -- Inject new text labels into CraftingLogicController root compound widget
@wrapMethod(CraftingLogicController)
public func Init(craftingGameController: wref<CraftingMainGameController>) -> Void {
  wrappedMethod(craftingGameController);

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let textContainer: ref<inkCompoundWidget> = root.GetWidget(n"inkCanvasWidget2/inkCanvasWidget7/itemDetailsContainer/weaponPreviewContainer") as inkCompoundWidget;

  if !IsDefined(this.m_availableSkinsText) || NotEquals(this.m_availableSkinsText.GetName(), n"AvailableSkinsLabel") {
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
    this.m_availableSkinsText = skins;
  };

  if !IsDefined(this.m_randomizerText) || NotEquals(this.m_randomizerText.GetName(), n"RandomizerLabel") {
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
    this.m_randomizerText = randomizer;
  };
}

// -- Refresh available skins counter state
@addMethod(CraftingLogicController)
public func RefreshSkinsCounter() -> Void {
  let size: Int32 = ArraySize(this.m_selectedRecipeVariants);
  if size > 1 {
    this.m_availableSkinsText.SetVisible(true);
    this.m_availableSkinsText.SetText(s"\(GetLocalizedTextByKey(n"Mod-Craft-UI-Variants")) \(size)");
  } else {
    this.m_availableSkinsText.SetVisible(false);
  };
}

// -- Refresh Randomizer label state
@addMethod(CraftingLogicController)
public func RefreshRandomizerLabel() -> Void {
  if ArraySize(this.m_selectedRecipeVariantsNoIconics) > 1 {
    this.m_randomizerText.SetVisible(true);
    if this.ecraftConfig.randomizerEnabled {
      this.m_randomizerText.SetText(GetLocalizedTextByKey(n"Mod-Craft-UI-Randomizer-Enabled"));
    } else {
      this.m_randomizerText.SetText(GetLocalizedTextByKey(n"Mod-Craft-UI-Randomizer-Disabled"));
    };
  } else {
    this.m_randomizerText.SetVisible(false);
  };
}
