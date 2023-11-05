import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

public abstract class EdgerunnerStats {
  public static func Print(system: ref<EdgerunningSystem>, config: ref<EdgerunningConfig>) -> Void {
    let berserk: Int32 = config.berserkUsageCost;
    let sandevistan: Int32 = config.sandevistanUsageCost;
    let upper = system.currentHumanityPool - system.psychosisThreshold;
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
    E(s"Pool: \(system.currentHumanityPool), cyberpsychosis threshold: \(system.psychosisThreshold)");
    E(s"Berserk usages before psycho: Legendary \(bl1), Epic \(be1), Rare \(br1), Uncommon \(bu1), Common \(bc1)");
    E(s"Sandevistan usages before psycho: Legendary \(sl1), Epic \(se1), Rare \(sr1), Uncommon \(su1), Common \(sc1)");
    E(s"Available kills before psycho: \(enm1) enemies, \(cop1) cops, \(civ1) civs");
    E("------------------------------------------------------------");
  }
}
