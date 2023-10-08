import Edgerunning.Common.E

/**
  public func Init(player: ref<PlayerPuppet>, config: ref<EdgerunningConfig>) -> Void
  public func GetCurrentKerenzikov() -> ref<Item_Record>
  public func GetCurrentOpticalCamo() -> ref<Item_Record>
*/

public class CyberwareHelper {
  private let player: wref<PlayerPuppet>;
  private let config: ref<EdgerunningConfig>;

  public func Init(player: ref<PlayerPuppet>, config: ref<EdgerunningConfig>) -> Void {
    this.player = player;
    this.config = config;
  }

  public func GetCurrentKerenzikov() -> ref<Item_Record> {
    let cyberware: array<ref<Item_Record>> = EquipmentSystem.GetData(this.player).GetCyberwareFromSlots();
    for record in cyberware {
      if this.IsKerenzikov(record) {
        return record;
      };
    };

    return null;
  }

  public func GetCurrentOpticalCamo() -> ref<Item_Record> {
    let cyberware: array<ref<Item_Record>> = EquipmentSystem.GetData(this.player).GetCyberwareFromSlots();
    for record in cyberware {
      if this.IsOpticalCamo(record) {
        return record;
      };
    };

    return null;
  }

  private func IsKerenzikov(record: ref<Item_Record>) -> Bool {
    let id: TweakDBID = record.GetID();
    return Equals(id, t"Items.KerenzikovCommon") 
      || Equals(id, t"Items.KerenzikovUncommon")
      || Equals(id, t"Items.KerenzikovRare")
      || Equals(id, t"Items.KerenzikovEpic")
      || Equals(id, t"Items.KerenzikovLegendary");
  }

  private func IsOpticalCamo(record: ref<Item_Record>) -> Bool {
    let id: TweakDBID = record.GetID();
    return Equals(id, t"Items.OpticalCamoRare") 
      || Equals(id, t"Items.OpticalCamoEpic")
      || Equals(id, t"Items.OpticalCamoLegendary");
  }
}
