module CombatAwareness

public abstract class Training {

  public static func KnockdownRecoveryRate() -> Float = 2.0;

  public static func EmergencyReloadRate() -> Float = 2.0;

  public static func ReactionWindow() -> TweakDBID = t"CombatAwareness.InitiativeReactionWindow";
  
  public static func ReactionSeconds() -> Float = TweakDBInterface.GetFloat(t"CombatAwareness.ReactionDuration.value", 3.0);

  public static func CanStudy(npc: ref<NPCPuppet>, player: ref<GameObject>) -> Bool {
    if !IsDefined(npc) || !npc.IsActive() || !IsDefined(player) { 
      return false; 
    }

    let attitude: EAIAttitude = npc.GetAttitudeTowards(player);
    return Equals(attitude, EAIAttitude.AIA_Hostile) || (npc.IsAggressive() && NotEquals(attitude, EAIAttitude.AIA_Friendly));
  }

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

  public static func Slot(id: TweakDBID) -> Int32 {
    switch id {
      case t"CombatAwareness.ThreatDetection": return 0;
      case t"CombatAwareness.InitiativeReaction": return 1;
      case t"CombatAwareness.InitiativeReactionWindow": return 1;
      case t"CombatAwareness.PrecisionAttack": return 2;
      case t"CombatAwareness.SpotWeakness": return 3;
      case t"CombatAwareness.DamageDeflection": return 4;
      case t"CombatAwareness.FumbleRecovery": return 5;
      case t"CombatAwareness.PreparedScript": return 6;
    };

    return -1;
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
