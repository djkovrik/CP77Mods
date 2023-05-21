module VirtualAtelier.Core

public class AtelierActions {
  public let togglePreviewVendor: CName;
  public let togglePreviewBackpack: CName;
  public let addToVirtualCart: CName;
  // public let addToVirtualCartExtra: CName;
  public let resetGarment: CName;
  public let removeAllGarment: CName;
  public let removePreviewGarment: CName;
  public let move: CName;
  public let zoom: CName;

  // TODO Migrate to Input Loader? Can't do it rn because of the bindings limit 
  public static func Get(playerPuppet: ref<GameObject>) -> ref<AtelierActions> {
    let instance: ref<AtelierActions> = new AtelierActions();
    let lastUsedPad: Bool = playerPuppet.PlayerLastUsedPad();

    if lastUsedPad {
      instance.togglePreviewVendor = n"world_map_menu_cycle_filter_prev";   // IK_Pad_DigitLeft
      instance.togglePreviewBackpack = n"world_map_menu_cycle_filter_prev"; // IK_Pad_DigitLeft
      instance.addToVirtualCart = n"world_map_menu_cycle_filter_prev";      // IK_Pad_DigitLeft
      // instance.addToVirtualCartExtra = n"va_add_to_cart";                   // IK_Pad_DigitLeft
      instance.resetGarment = n"world_map_filter_navigation_down";          // IK_Pad_DigitDown
      instance.removeAllGarment = n"world_map_menu_open_quest_static";      // IK_Pad_Y_TRIANGLE
      instance.removePreviewGarment = n"world_map_filter_navigation_up";    // IK_Pad_DigitUp
      instance.move = n"world_map_fake_move";                               // IK_Pad_LeftAxisX
      instance.zoom = n"";                                                  // None
    } else {
      instance.togglePreviewVendor = n"UI_PrintDebug";                      // IK_P
      instance.togglePreviewBackpack = n"UI_Unequip";                       // IK_U
      instance.addToVirtualCart = n"UI_PrintDebug";                         // IK_P
      // instance.addToVirtualCartExtra = n"va_add_to_cart";                   // IK_P
      instance.resetGarment = n"world_map_filter_navigation_down";          // IK_X
      instance.removeAllGarment = n"world_map_menu_open_quest_static";      // IK_J
      instance.removePreviewGarment = n"disassemble_item";                  // IK_Z
      instance.move = n"world_map_fake_move";                               // IK_LeftMouse
      instance.zoom = n"mouse_wheel";                                       // IK_MouseZ
    };

    return instance;
  }
}
