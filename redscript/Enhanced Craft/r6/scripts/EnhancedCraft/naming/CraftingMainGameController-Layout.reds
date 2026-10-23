module EnhancedCraft.Naming
import EnhancedCraft.Common.L
import EnhancedCraft.System.EnhancedCraftSystem
import EnhancedCraft.Config.*
import Codeware.UI.*

// -- Custom text input
@addField(CraftingMainGameController)
private let nameInput: wref<HubTextInput>;

// -- Custom text input container
@addField(CraftingMainGameController)
private let nameInputContainer: wref<inkCompoundWidget>;

// -- Recipe item name
@addField(CraftingMainGameController)
private let craftedItemName: wref<inkText>;

@addField(CraftingMainGameController)
private let nameInputGlobalCallbackRegistered: Bool;

@addMethod(CraftingMainGameController)
private func HasEnhancedCraftNameInput() -> Bool {
  return IsDefined(this.nameInput) && IsDefined(this.nameInputContainer) && IsDefined(this.craftedItemName);
}

// -- Inject text input into CraftingLogicController
@wrapMethod(CraftingMainGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  // If custon naming disabled then do nothing
  let config: ref<ECraftConfig> = new ECraftConfig();
  let customNamesEnabled: Bool = config.customNamesEnabled;
  if !customNamesEnabled {
    return true;
  };

  // Insert input
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let outerContainer: ref<inkCompoundWidget> = root.GetWidget(n"craftingPanel/inkCanvasWidget2/inkCanvasWidget7/itemDetailsContainer") as inkCompoundWidget;
  this.craftedItemName = root.GetWidget(n"craftingPanel/inkCanvasWidget2/inkCanvasWidget7/itemDetailsContainer/itemTitle/header/itemName") as inkText;
  if !IsDefined(outerContainer) || !IsDefined(this.craftedItemName) {
    return true;
  };

  let container: ref<inkVerticalPanel> = new inkVerticalPanel();
  container.SetSize(600.0, 100.0);
  container.SetFitToContent(true);
  container.SetHAlign(inkEHorizontalAlign.Left);
  container.SetAnchor(inkEAnchor.TopLeft);
  container.SetMargin(inkMargin(0.0, 196.0, 0.0, 0.0));
  container.Reparent(outerContainer);
  container.SetVisible(false);
  this.nameInputContainer = container;

  let input: ref<HubTextInput> = HubTextInput.Create();
  input.RegisterToCallback(n"OnInput", this, n"OnTextInput");
  input.Reparent(this.nameInputContainer);
  this.nameInput = input;

  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalInput");
  this.nameInputGlobalCallbackRegistered = true;
}

// -- Catch text input events
@addMethod(CraftingMainGameController)
protected cb func OnTextInput(widget: wref<inkWidget>) -> Bool {
  if !this.HasEnhancedCraftNameInput() {
    return false;
  };

  let text: String = this.nameInput.GetText();
  if NotEquals(text, "") {
    this.craftedItemName.SetText(text);
  };
}

// -- Catch mouse clicks to reset input focus
@addMethod(CraftingMainGameController)
protected cb func OnGlobalInput(evt: ref<inkPointerEvent>) -> Void {
	if evt.IsAction(n"mouse_left") {
		if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
			this.RequestSetFocus(null);
		};
	};
}

@wrapMethod(CraftingMainGameController)
protected cb func OnUninitialize() -> Bool {
  if this.nameInputGlobalCallbackRegistered {
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalInput");
    this.nameInputGlobalCallbackRegistered = false;
  };
  wrappedMethod();
}
