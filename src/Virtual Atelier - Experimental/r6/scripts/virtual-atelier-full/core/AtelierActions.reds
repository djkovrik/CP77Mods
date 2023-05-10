module VirtualAtelier.Core

public class AtelierActions {
  public let togglePreviewVendor: CName;
  public let togglePreviewBackpack: CName;
  public let addToVirtualCart: CName;
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
      instance.togglePreviewVendor = n"world_map_menu_cycle_filter_prev";
      instance.togglePreviewBackpack = n"world_map_menu_cycle_filter_prev";
      instance.addToVirtualCart = n"world_map_menu_cycle_filter_prev";
      instance.resetGarment = n"world_map_filter_navigation_down";
      instance.removeAllGarment = n"world_map_menu_open_quest_static";
      instance.removePreviewGarment = n"world_map_filter_navigation_up";
      instance.move = n"world_map_fake_move";
      instance.zoom = n"";
    } else {
      instance.togglePreviewVendor = n"UI_PrintDebug";
      instance.togglePreviewBackpack = n"UI_Unequip";
      instance.addToVirtualCart = n"UI_PrintDebug";
      instance.resetGarment = n"world_map_filter_navigation_down";
      instance.removeAllGarment = n"world_map_menu_open_quest_static";
      instance.removePreviewGarment = n"disassemble_item";
      instance.move = n"world_map_fake_move";
      instance.zoom = n"mouse_wheel";
    };

    return instance;
  }
}
