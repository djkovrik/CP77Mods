module LimitedHudCommon

import LimitedHudConfig.*

public class LHUDMarkerConfigs extends ScriptableSystem {
  public let quest: ref<WorldMarkersModuleConfigQuest>;
  public let loot: ref<WorldMarkersModuleConfigLoot>;
  public let vehicles: ref<WorldMarkersModuleConfigVehicles>;
  public let poi: ref<WorldMarkersModuleConfigPOI>;
  public let combat: ref<WorldMarkersModuleConfigCombat>;
  public let devices: ref<WorldMarkersModuleConfigDevices>;
  public let coloring: ref<LHUDAddonsColoringConfig>;

  public static func Get() -> ref<LHUDMarkerConfigs> {
    return GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"LimitedHudCommon.LHUDMarkerConfigs") as LHUDMarkerConfigs;
  }

  private func OnAttach() -> Void {
    this.Refresh();
  }

  public final func Refresh() -> Void {
    this.coloring = new LHUDAddonsColoringConfig();
    this.quest = new WorldMarkersModuleConfigQuest();
    this.loot = new WorldMarkersModuleConfigLoot();
    this.vehicles = new WorldMarkersModuleConfigVehicles();
    this.poi = new WorldMarkersModuleConfigPOI();
    this.combat = new WorldMarkersModuleConfigCombat();
    this.devices = new WorldMarkersModuleConfigDevices();
  }
}
