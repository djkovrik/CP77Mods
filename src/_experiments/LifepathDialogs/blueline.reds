@addField(LifePathBluelinePart)
public let additionalData: Bool;

@addMethod(LifePath_ScriptConditionType)
public const quest func CheckAdditionalData(playerObject: ref<GameObject>) -> Bool {
  let playerControlledObject: ref<GameObject>;
  let playerDevSystem: ref<PlayerDevelopmentSystem> = this.GetPlayerDevelopmentSystem();
  let playerLifePath: gamedataLifePath = playerDevSystem.GetLifePath(playerObject);
  let lifePath: gamedataLifePath = TweakDBInterface.GetLifePathRecord(this.m_lifePathId).Type();
  if !IsDefined(playerObject) {
    return false;
  };
  playerControlledObject = GameInstance.GetPlayerSystem(playerObject.GetGame()).GetLocalPlayerControlledGameObject();
  playerLifePath = playerDevSystem.GetLifePath(playerControlledObject);
  return NotEquals(lifePath, playerLifePath);
}

@replaceMethod(LifePath_ScriptConditionType)
public const func GetBluelinePart(playerObject: ref<GameObject>) -> ref<BluelinePart> {
  let part: ref<LifePathBluelinePart> = new LifePathBluelinePart();
  part.additionalData = this.CheckAdditionalData(playerObject);
  part.passed = this.Evaluate(playerObject);
  part.m_record = TweakDBInterface.GetLifePathRecord(this.m_lifePathId);
  part.captionIconRecordId = part.m_record.CaptionIcon().GetID();
  return part;
}

@replaceMethod(LifePath_ScriptConditionType)
public const quest func Evaluate(playerObject: ref<GameObject>) -> Bool {
  let playerControlledObject: ref<GameObject>;
  let playerDevSystem: ref<PlayerDevelopmentSystem> = this.GetPlayerDevelopmentSystem();
  let playerLifePath: gamedataLifePath = playerDevSystem.GetLifePath(playerObject);
  let lifePath: gamedataLifePath = TweakDBInterface.GetLifePathRecord(this.m_lifePathId).Type();
  if !IsDefined(playerObject) {
    return false;
  };
  playerControlledObject = GameInstance.GetPlayerSystem(playerObject.GetGame()).GetLocalPlayerControlledGameObject();
  playerLifePath = playerDevSystem.GetLifePath(playerControlledObject);
  if !this.m_inverted {
    return true;
  };
  return NotEquals(lifePath, playerLifePath);
}
