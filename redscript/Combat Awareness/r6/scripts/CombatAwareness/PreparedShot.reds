module CombatAwareness

class PreparedShot {

  private let firstHit: wref<gameHitEvent>;
  private let source: EntityID;
  private let target: EntityID;
  private let weapon: EntityID;
  private let pelletTime: Float;

  public static func FromHit(hit: ref<gameHitEvent>) -> ref<PreparedShot> {
    let shot: ref<PreparedShot> = new PreparedShot();
    let data = hit.attackData;
    shot.firstHit = hit;
    shot.source = data.GetInstigator().GetEntityID();
    shot.target = hit.target.GetEntityID();
    let weapon = data.GetWeapon();
    
    if IsDefined(weapon) && AttackData.IsRangedOrDirect(data.GetAttackType()) && weapon.IsRanged() {
      shot.weapon = weapon.GetEntityID();
      if GameInstance.GetStatsSystem(hit.target.GetGame()).GetStatValue(Cast<StatsObjectID>(shot.weapon), gamedataStatType.ProjectilesPerShot) > 1.0 {
        shot.pelletTime = data.GetAttackTime();
      };
    };

    return shot;
  }

  public func Matches(hit: ref<gameHitEvent>) -> Bool {
    if hit.target.GetEntityID() != this.target { 
      return false; 
    }
    if this.firstHit == hit { 
      return true; 
    }

    let data = hit.attackData;
    return this.pelletTime > 0.0 && this.pelletTime == data.GetAttackTime()
      && AttackData.IsRangedOrDirect(data.GetAttackType()) 
      && IsDefined(data.GetWeapon())
      && this.weapon == data.GetWeapon().GetEntityID() 
      && this.source == data.GetInstigator().GetEntityID();
  }
}
