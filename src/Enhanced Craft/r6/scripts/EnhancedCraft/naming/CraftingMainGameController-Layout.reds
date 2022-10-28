module EnhancedCraft.Naming
import EnhancedCraft.Codeware.UI.*
import EnhancedCraft.Common.L
import EnhancedCraft.System.EnhancedCraftSystem
import EnhancedCraft.Config.*

// -- Custom text input
@addField(CraftingMainGameController)
private let m_nameInput: ref<HubTextInput>;

@addField(CraftingMainGameController)
private let m_originalName: String;

// -- Custom text input container
@addField(CraftingMainGameController)
private let m_nameInputContainer: ref<inkCompoundWidget>;

// -- Recipe item name
@addField(CraftingMainGameController)
private let m_craftedItemName: ref<inkText>;

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
  let outerContainer: ref<inkCompoundWidget> = root.GetWidget(n"craftingPanel/inkCanvasWidget2/itemDetailsContainer") as inkCompoundWidget;
  this.m_nameInputContainer = new inkVerticalPanel();
  this.m_nameInputContainer.SetSize(600.0, 100.0);
  this.m_nameInputContainer.SetFitToContent(true);
  this.m_nameInputContainer.SetHAlign(inkEHorizontalAlign.Left);
  this.m_nameInputContainer.SetAnchor(inkEAnchor.TopLeft);
  this.m_nameInputContainer.SetMargin(new inkMargin(0.0, 165.0, 0.0, 0.0));
  this.m_nameInputContainer.Reparent(outerContainer);
  this.m_nameInput = HubTextInput.Create();
  this.m_nameInput.RegisterToCallback(n"OnInput", this, n"OnTextInput");
  this.m_nameInput.Reparent(this.m_nameInputContainer );
  this.m_nameInputContainer .SetVisible(false);

  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalInput");

  // Find item name inkText
  this.m_craftedItemName = root.GetWidget(n"craftingPanel/inkCanvasWidget2/itemDetailsContainer/itemTitle/header/itemName") as inkText;
}

// -- Catch text input events
@addMethod(CraftingMainGameController)
protected cb func OnTextInput(widget: wref<inkWidget>) -> Bool {
  let text: String = this.m_nameInput.GetText();
  if NotEquals(text, "") {
    this.m_craftedItemName.SetText(text);
  } else {
    this.m_craftedItemName.SetText(this.m_originalName);
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
  this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalInput");
  wrappedMethod();
}
