/**
  public static func GetEnemyCost(affiliation: gamedataAffiliation, config: ref<EdgerunningConfig>) -> Int32
*/
// TODO Add PL factions
public abstract class EnemyCostHelper {
  public static func GetEnemyCost(affiliation: gamedataAffiliation, config: ref<EdgerunningConfig>) -> Int32 {
    let cost: Int32 = 0;
    switch affiliation {
      case gamedataAffiliation.Arasaka:
        cost = config.killCostArasaka;
        break;
      case gamedataAffiliation.KangTao:
        cost = config.killCostKangTao;
        break;
      case gamedataAffiliation.Maelstrom:
        cost = config.killCostMaelstrom;
        break;
      case gamedataAffiliation.Militech:
        cost = config.killCostMilitech;
        break;
      case gamedataAffiliation.NCPD:
        cost = config.killCostNCPD;
        break;
      case gamedataAffiliation.NetWatch:
        cost = config.killCostNetWatch;
        break;
      case gamedataAffiliation.Animals:
        cost = config.killCostAnimals;
        break;
      case gamedataAffiliation.Scavengers:
        cost = config.killCostScavengers;
        break;
      case gamedataAffiliation.SixthStreet:
        cost = config.killCostSixthStreet;
        break;
      case gamedataAffiliation.TygerClaws:
        cost = config.killCostTygerClaws;
        break;
      case gamedataAffiliation.Valentinos:
        cost = config.killCostValentinos;
        break;
      case gamedataAffiliation.VoodooBoys:
        cost = config.killCostVoodooBoys;
        break;
      case gamedataAffiliation.Wraiths:
        cost = config.killCostWraiths;
        break;
      case gamedataAffiliation.Civilian:
        cost = config.killCostCivilian;
        break;
      default:
        cost = config.killCostOther;
        break;
    };

    return cost;
  }
}
