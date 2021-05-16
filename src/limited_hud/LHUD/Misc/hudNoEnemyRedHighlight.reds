// Keeps red highlight effect active only for NPCs under Ping effect, disables it for all other cases
@replaceMethod(ScriptedPuppet)
public const func GetCurrentOutline() -> EFocusOutlineType {
  let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  let outlineType: EFocusOutlineType;
  let attitude: EAIAttitude;

  let hasPingEffect: Bool = StatusEffectHelper.HasStatusEffect(this, t"BaseStatusEffect.Ping");

  if this.IsQuest() {
    return EFocusOutlineType.QUEST;
  };
  if !this.IsActive() {
    return EFocusOutlineType.ITEM;
  };
  attitude = GameObject.GetAttitudeTowards(this, playerPuppet);
  if this.IsAggressive() || this.IsBoss() {
    if Equals(attitude, EAIAttitude.AIA_Friendly) {
      outlineType = EFocusOutlineType.FRIENDLY;
    } else {
      if this.IsPrevention() && Equals(attitude, EAIAttitude.AIA_Neutral) {
        outlineType = EFocusOutlineType.NEUTRAL;
      } else {
        if hasPingEffect {
          outlineType = EFocusOutlineType.HOSTILE;
        } else {
          outlineType = EFocusOutlineType.INVALID;
        };
      };
    };
  } else {
    if this.IsTaggedinFocusMode() {
      outlineType = EFocusOutlineType.NEUTRAL;
    } else {
      outlineType = EFocusOutlineType.INVALID;
    };
  };
  return outlineType;
}
