module EnhancedCraft.Hotkey
import EnhancedCraft.Config.*
import EnhancedCraft.Common.*
import EnhancedCraft.System.*

// -- Custom hotkey listener for Prev and Next hotkeys

public class EnhancedCraftHotkeyListener {

  private let controller: wref<CraftingLogicController>;

  private let config: ref<ECraftConfig>;

  public func SetController(controller: ref<CraftingLogicController>) -> Void {
    this.controller = controller;
  }

  public func SetConfig(config: ref<ECraftConfig>) -> Void {
    this.config = config;
  }

  // Hotkeys active only if Randomizer disabled
  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let actionName: CName = ListenerAction.GetName(action);
    let isReleased: Bool = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED);
    // Weapons
    if ArraySize(this.controller.m_selectedRecipeVariants) > 2 && this.controller.m_isWeaponSelected {
      if Equals(actionName, HotkeyActions.EnhancedCraftPrevAction(this.config)) && isReleased && !this.config.randomizerEnabled {
        this.controller.LoadPrevItemVariant();
      };
      if Equals(actionName, HotkeyActions.EnhancedCraftNextAction(this.config)) && isReleased && !this.config.randomizerEnabled {
        this.controller.LoadNextItemVariant();
      };
    };
    // Clothes
    if ArraySize(this.controller.m_selectedRecipeVariants) > 2 && this.controller.m_isClothesSelected {
      if Equals(actionName, HotkeyActions.EnhancedCraftPrevAction(this.config)) && isReleased {
        this.controller.LoadPrevItemVariant();
      };
      if Equals(actionName, HotkeyActions.EnhancedCraftNextAction(this.config)) && isReleased {
        this.controller.LoadNextItemVariant();
      };
    };
  }
}

@addField(CraftingLogicController)
public let m_inputListener: ref<EnhancedCraftHotkeyListener>;

@wrapMethod(CraftingLogicController)
public func Init(craftingGameController: wref<CraftingMainGameController>) -> Void {
  wrappedMethod(craftingGameController);
  if !IsDefined(this.ecraftConfig) {
    this.ecraftConfig = new ECraftConfig();
  };
  this.m_inputListener = new EnhancedCraftHotkeyListener();
  this.m_inputListener.SetController(this);
  this.m_inputListener.SetConfig(this.ecraftConfig);
  this.m_craftingGameController.GetPlayer().RegisterInputListener(this.m_inputListener);
}

@wrapMethod(CraftingLogicController)
protected cb func OnUninitialize() -> Bool {
  this.m_craftingGameController.GetPlayer().UnregisterInputListener(this.m_inputListener);
  this.m_inputListener = null;
  wrappedMethod();
}
