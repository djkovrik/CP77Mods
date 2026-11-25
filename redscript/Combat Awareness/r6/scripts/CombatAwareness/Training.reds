module CombatAwareness


public abstract class Training {

  public static func Record(slot: Int32) -> TweakDBID {
    switch slot {
      case 0: return t"CombatAwareness.ThreatDetection";
      case 1: return t"CombatAwareness.InitiativeReaction";
      case 2: return t"CombatAwareness.PrecisionAttack";
      case 3: return t"CombatAwareness.SpotWeakness";
      case 4: return t"CombatAwareness.DamageDeflection";
      case 5: return t"CombatAwareness.FumbleRecovery";
      case 6: return t"CombatAwareness.PreparedScript";
    }
    
    return TDBID.None();
  }

  public static func Cost(slot: Int32) -> Int32 {
    if slot < 2 { return 1; };
    if slot == 2 { return 3; };
    return 2;
  }

  // TODO: Temp? Replace with implants & progression mb
  public static func Budget() -> Int32 = 4;

  // seven sectors, each one is pow(2, n)
  public static func Bit(slot: Int32) -> Int32 {
    switch slot {
      case 0: return 1;
      case 1: return 2;
      case 2: return 4;
      case 3: return 8;
      case 4: return 16;
      case 5: return 32;
      case 6: return 64;
    };

    return 0;
  }


  public static func Total(mask: Int32) -> Int32 {
    let i = 0;
    let total = 0;
    while i < 7 {
      if (mask & (Training.Bit(i))) != 0 { 
        total += Training.Cost(i); 
      }

      i += 1;
    };

    return total;
  }
}
