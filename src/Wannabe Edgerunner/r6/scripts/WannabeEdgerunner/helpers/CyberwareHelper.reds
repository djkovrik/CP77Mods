import Edgerunning.Common.E

/**
  public func Init(player: ref<PlayerPuppet>, config: ref<EdgerunningConfig>) -> Void
  public func GetCurrentKerenzikov() -> ref<Item_Record>
  public func GetCurrentOpticalCamo() -> ref<Item_Record>
  public func GetCurrentBloodPump() -> ref<Item_Record>
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

  public func GetCurrentBloodPump() -> ref<Item_Record> {
    let cyberware: array<ref<Item_Record>> = EquipmentSystem.GetData(this.player).GetCyberwareFromSlots();
    for record in cyberware {
      if this.IsBloodPump(record) {
        return record;
      };
    };

    return null;
  }

  public static func IsKerenzikov(id: TweakDBID) -> Bool {
    return Equals(id, t"Items.KerenzikovCommon") 
      || Equals(id, t"Items.KerenzikovUncommon")
      || Equals(id, t"Items.KerenzikovRare")
      || Equals(id, t"Items.KerenzikovEpic")
      || Equals(id, t"Items.KerenzikovLegendary")
      || Equals(id, t"Items.AdvancedKerenzikovCommon")
      || Equals(id, t"Items.AdvancedKerenzikovUncommon")
      || Equals(id, t"Items.AdvancedKerenzikovUncommonPlus")
      || Equals(id, t"Items.AdvancedKerenzikovRare")
      || Equals(id, t"Items.AdvancedKerenzikovRarePlus")
      || Equals(id, t"Items.AdvancedKerenzikovEpic")
      || Equals(id, t"Items.AdvancedKerenzikovEpicPlus")
      || Equals(id, t"Items.AdvancedKerenzikovLegendary")
      || Equals(id, t"Items.AdvancedKerenzikovLegendaryPlus")
      || Equals(id, t"Items.AdvancedKerenzikovLegendaryPlusPlus");
  }

  public static func IsOpticalCamo(id: TweakDBID) -> Bool {
    return Equals(id, t"Items.OpticalCamoRare") 
      || Equals(id, t"Items.OpticalCamoEpic")
      || Equals(id, t"Items.OpticalCamoLegendary")
      || Equals(id, t"Items.AdvancedOpticalCamoCommon")
      || Equals(id, t"Items.AdvancedOpticalCamoUncommon")
      || Equals(id, t"Items.AdvancedOpticalCamoUncommonPlus")
      || Equals(id, t"Items.AdvancedOpticalCamoRare")
      || Equals(id, t"Items.AdvancedOpticalCamoRarePlus")
      || Equals(id, t"Items.AdvancedOpticalCamoEpic")
      || Equals(id, t"Items.AdvancedOpticalCamoEpicPlus")
      || Equals(id, t"Items.AdvancedOpticalCamoLegendary")
      || Equals(id, t"Items.AdvancedOpticalCamoLegendaryPlus")
      || Equals(id, t"Items.AdvancedOpticalCamoLegendaryPlusPlus")
      || Equals(id, t"Items.OpticalCamoLurkerCommon")
      || Equals(id, t"Items.OpticalCamoLurkerUncommon")
      || Equals(id, t"Items.OpticalCamoLurkerUncommonPlus")
      || Equals(id, t"Items.OpticalCamoLurkerRare")
      || Equals(id, t"Items.OpticalCamoLurkerRarePlus")
      || Equals(id, t"Items.OpticalCamoLurkerEpic")
      || Equals(id, t"Items.OpticalCamoLurkerEpicPlus")
      || Equals(id, t"Items.OpticalCamoLurkerLegendary")
      || Equals(id, t"Items.OpticalCamoLurkerLegendaryPlus")
      || Equals(id, t"Items.OpticalCamoLurkerLegendaryPlusPlus")
      || Equals(id, t"Items.OpticalCamoStaminaCommon")
      || Equals(id, t"Items.OpticalCamoStaminaUncommon")
      || Equals(id, t"Items.OpticalCamoStaminaUncommonPlus")
      || Equals(id, t"Items.OpticalCamoStaminaRare")
      || Equals(id, t"Items.OpticalCamoStaminaRarePlus")
      || Equals(id, t"Items.OpticalCamoStaminaEpic")
      || Equals(id, t"Items.OpticalCamoStaminaEpicPlus")
      || Equals(id, t"Items.OpticalCamoStaminaLegendary")
      || Equals(id, t"Items.OpticalCamoStaminaLegendaryPlus")
      || Equals(id, t"Items.OpticalCamoStaminaLegendaryPlusPlus");
  }

  public static func IsBloodPump(id: TweakDBID) -> Bool {
    return Equals(id, t"Items.AdvancedBloodPumpCommon") 
      || Equals(id, t"Items.AdvancedBloodPumpUncommon")
      || Equals(id, t"Items.AdvancedBloodPumpUncommonPlus")
      || Equals(id, t"Items.AdvancedBloodPumpRare")
      || Equals(id, t"Items.AdvancedBloodPumpRarePlus")
      || Equals(id, t"Items.AdvancedBloodPumpEpic")
      || Equals(id, t"Items.AdvancedBloodPumpEpicPlus")
      || Equals(id, t"Items.AdvancedBloodPumpLegendary")
      || Equals(id, t"Items.AdvancedBloodPumpLegendaryPlus")
      || Equals(id, t"tems.AdvancedBloodPumpLegendaryPlusPlus");
  }

  private func IsKerenzikov(record: ref<Item_Record>) -> Bool {
    let id: TweakDBID = record.GetID();
    return CyberwareHelper.IsKerenzikov(id);
  }

  private func IsOpticalCamo(record: ref<Item_Record>) -> Bool {
    let id: TweakDBID = record.GetID();
    return CyberwareHelper.IsOpticalCamo(id);
  }

  private func IsBloodPump(record: ref<Item_Record>) -> Bool {
    let id: TweakDBID = record.GetID();
    return CyberwareHelper.IsBloodPump(id);
  }
}
