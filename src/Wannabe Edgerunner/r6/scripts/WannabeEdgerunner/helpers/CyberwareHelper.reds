import Edgerunning.Common.E

/**
  public func Init(player: ref<PlayerPuppet>, config: ref<EdgerunningConfig>) -> Void
  public func GetCurrentCyberwareCost(showLog: Bool) -> Int32
  public func GetCyberwareCost(item: ref<Item_Record>) -> Int32
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

  public func GetCurrentCyberwareCost(showLog: Bool) -> Int32 {
    let cyberware: array<ref<Item_Record>> = EquipmentSystem.GetData(this.player).GetCyberwareFromSlots();
    let installedCyberwarePool: Int32 = 0;

    let name: CName;
    let area: gamedataEquipmentArea;
    let quality: gamedataQuality;
    let cost: Int32;

    for record in cyberware {
      name = record.DisplayName();
      area = record.EquipArea().Type();
      quality = record.Quality().Type();
      cost = this.GetCyberwareCost(record);
      if showLog {
        E(s"\(GetLocalizedTextByKey(name)) - \(area) - \(quality): costs -\(cost) humanity");
      };
      installedCyberwarePool += cost;
    };
  
    return installedCyberwarePool;
  }

  public func GetCyberwareCost(item: ref<Item_Record>) -> Int32 {
    let area: gamedataEquipmentArea = item.EquipArea().Type();
    let quality: gamedataQuality = item.Quality().Type();

    let baseCost: Float = 0.0;
    switch(area) {
      case gamedataEquipmentArea.FrontalCortexCW:
        baseCost = Cast<Float>(this.config.frontalCortexCost);
        break;
      case gamedataEquipmentArea.SystemReplacementCW:
        baseCost = Cast<Float>(this.config.systemReplacementCost);
        break;
      case gamedataEquipmentArea.EyesCW:
        baseCost = Cast<Float>(this.config.eyesCost);
        break;
      case gamedataEquipmentArea.MusculoskeletalSystemCW:
        baseCost = Cast<Float>(this.config.musculoskeletalSystemCost);
        break;
      case gamedataEquipmentArea.NervousSystemCW :
        baseCost = Cast<Float>(this.config.nervousSystemCost);
        break;
      case gamedataEquipmentArea.CardiovascularSystemCW:
        baseCost = Cast<Float>(this.config.cardiovascularSystemCost);
        break;
      case gamedataEquipmentArea.ImmuneSystemCW:
        baseCost = Cast<Float>(this.config.immuneSystemCost);
        break;
      case gamedataEquipmentArea.IntegumentarySystemCW:
        baseCost = Cast<Float>(this.config.integumentarySystemCost);
        break;
      case gamedataEquipmentArea.HandsCW:
        baseCost = Cast<Float>(this.config.handsCost);
        break;
      case gamedataEquipmentArea.ArmsCW:
        baseCost = Cast<Float>(this.config.armsCost);
        break;
      case gamedataEquipmentArea.LegsCW:
        baseCost = Cast<Float>(this.config.legsCost);
        break;
    };

    let qualityMult: Float = 1.0;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
    };

    let result: Float = baseCost * qualityMult;
    E(s"GetCyberwareCost: \(area) costs \(baseCost), \(quality) mult \(qualityMult) = \(result)");

    return RoundF(result);
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
