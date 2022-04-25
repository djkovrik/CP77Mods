module EnhancedCraft.Hotkey
import EnhancedCraft.Config.*
import EnhancedCraft.Common.*

// -- Custom hotkey listener for Prev and Next hotkeys

public class EnhancedCraftHotkeyListener {

  private let controller: wref<CraftingLogicController>;

  public func SetController(controller: ref<CraftingLogicController>) -> Void {
    this.controller = controller;
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let actionName: CName = ListenerAction.GetName(action);
    let isReleased: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED);
    // Hotkeys active only if Randomizer disabled
    if Equals(actionName, HotkeyActions.EnhancedCraftPrevAction()) && isReleased && !Config.RandomizerEnabled() {
      this.controller.LoadPrevVariant();
    };
    if Equals(actionName, HotkeyActions.EnhancedCraftNextAction()) && isReleased && !Config.RandomizerEnabled() {
      this.controller.LoadNextVariant();
    };
  }
}

@addField(CraftingLogicController)
public let m_inputListener: ref<EnhancedCraftHotkeyListener>;

@wrapMethod(CraftingLogicController)
public func Init(craftingGameController: wref<CraftingMainGameController>) -> Void {
  wrappedMethod(craftingGameController);
  this.m_inputListener = new EnhancedCraftHotkeyListener();
  this.m_inputListener.SetController(this);
  this.m_craftingGameController.GetPlayer().RegisterInputListener(this.m_inputListener);
}

@wrapMethod(CraftingLogicController)
protected cb func OnUninitialize() -> Bool {
  this.m_craftingGameController.GetPlayer().UnregisterInputListener(this.m_inputListener);
  this.m_inputListener = null;
  wrappedMethod();
}
