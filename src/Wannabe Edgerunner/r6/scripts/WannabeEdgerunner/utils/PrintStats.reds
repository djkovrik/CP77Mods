import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

public abstract class EdgerunnerStats {
  public static func Print(system: ref<EdgerunningSystem>, config: ref<EdgerunningConfig>) -> Void {
    let berserk: Int32 = config.berserkUsageCost;
    let sandevistan: Int32 = config.sandevistanUsageCost;
    let upper = system.currentHumanityPool - system.upperThreshold;
    let lower = system.currentHumanityPool - system.lowerThreshold;
    let bl1 = upper / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierLegendary);
    let be1 = upper / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierEpic);
    let br1 = upper / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierRare);
    let bu1 = upper / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierUncommon);
    let bc1 = upper / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierCommon);
    let sl1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierLegendary);
    let se1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierEpic);
    let sr1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierRare);
    let su1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierUncommon);
    let sc1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierCommon);
    let enm1 = upper / config.killCostOther;
    let cop1 = upper / config.killCostNCPD;
    let civ1 = upper / config.killCostCivilian;
    E("------------------------------------------------------------");
    let bl2 = lower / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierLegendary);
    let be2 = lower / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierEpic);
    let br2 = lower / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierRare);
    let bu2 = lower / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierUncommon);
    let bc2 = lower / Cast<Int32>(Cast<Float>(berserk) * config.qualityMultiplierCommon);
    let sl2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierLegendary);
    let se2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierEpic);
    let sr2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierRare);
    let su2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierUncommon);
    let sc2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * config.qualityMultiplierCommon);
    let enm2 = upper / config.killCostOther;
    let cop2 = upper / config.killCostNCPD;
    let civ2 = upper / config.killCostCivilian;
    E(s"Glitches threshold: \(system.upperThreshold), cyberpsychosis threshold: \(system.lowerThreshold)");
    E(s"Berserk usages before glitches: Legendary \(bl1), Epic \(be1), Rare \(br1), Uncommon \(bu1), Common \(bc1)");
    E(s"Berserk usages before psycho: Legendary \(bl2), Epic \(be2), Rare \(br2), Uncommon \(bu2), Common \(bc2)");
    E(s"Sandevistan usages before glitches: Legendary \(sl1), Epic \(se1), Rare \(sr1), Uncommon \(su1), Common \(sc1)");
    E(s"Sandevistan usages before psycho: Legendary \(sl2), Epic \(se2), Rare \(sr2), Uncommon \(su2), Common \(sc2)");
    E(s"Available kills before glitches: \(enm1) enemies, \(cop1) cops, \(civ1) civs");
    E(s"Available kills before psycho: \(enm2) enemies, \(cop2) cops, \(civ2) civs");
    E("------------------------------------------------------------");
  }
}
