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
    if ArraySize(this.controller.selectedRecipeVariants) > 1 && this.controller.isWeaponSelected {
      if Equals(actionName, n"ECraft_Prev") && isReleased && !this.config.randomizerEnabled {
        this.controller.LoadPrevItemVariant();
      };
      if Equals(actionName, n"ECraft_Next") && isReleased && !this.config.randomizerEnabled {
        this.controller.LoadNextItemVariant();
      };
    };
  }
}

@addField(CraftingLogicController)
public let inputListener: ref<EnhancedCraftHotkeyListener>;

@wrapMethod(CraftingLogicController)
public func Init(craftingGameController: wref<CraftingMainGameController>) -> Void {
  wrappedMethod(craftingGameController);
  if !IsDefined(this.ecraftConfig) {
    this.ecraftConfig = new ECraftConfig();
  };
  this.inputListener = new EnhancedCraftHotkeyListener();
  this.inputListener.SetController(this);
  this.inputListener.SetConfig(this.ecraftConfig);
  this.m_craftingGameController.GetPlayer().RegisterInputListener(this.inputListener);
}

@wrapMethod(CraftingLogicController)
protected cb func OnUninitialize() -> Bool {
  this.m_craftingGameController.GetPlayer().UnregisterInputListener(this.inputListener);
  this.inputListener = null;
  wrappedMethod();
}
