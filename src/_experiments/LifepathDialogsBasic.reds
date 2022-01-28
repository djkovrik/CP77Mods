private class BlockedOptionConfig {
  public static func IconOpacity() -> Float = 0.6
  public static func TextOpacity() -> Float = 0.6
}

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

@wrapMethod(CaptionImageIconsLogicController)
public final func SetLifePath(argData: ref<LifePathBluelinePart>) -> Void {
  wrappedMethod(argData);
  if argData.additionalData {
    this.GetRootWidget().SetOpacity(BlockedOptionConfig.IconOpacity());
  };
}

@addMethod(DialogChoiceLogicController)
public final func SetDimmed() -> Void {
  let opacity: Float = BlockedOptionConfig.TextOpacity();
  inkWidgetRef.SetOpacity(this.m_ActiveTextRef, opacity);
  inkWidgetRef.SetOpacity(this.m_InActiveTextRef, opacity);
  this.m_SelectedBg.SetOpacity(BlockedOptionConfig.TextOpacity());
}

@wrapMethod(DialogHubLogicController)
private final func UpdateDialogHubData() -> Void {
  wrappedMethod();
  let modCurrentItem: wref<DialogChoiceLogicController>;
  let modChoiceData: ListChoiceData;
  let j: Int32 = 0;
  while j < ArraySize(this.m_data.choices) {
    modCurrentItem = this.m_itemControllers[j];
    modChoiceData = this.m_data.choices[j];
    if HasBlockedLifepath(modChoiceData.captionParts.parts) {
      modCurrentItem.SetDimmed();
    };
    j += 1;
  };
}

private static func HasBlockedLifepath(argList: array<ref<InteractionChoiceCaptionPart>>) -> Bool {
  let currBluelineHolder: wref<InteractionChoiceCaptionBluelinePart>;
  let currBlueLinePart: wref<LifePathBluelinePart>;
  let currType: gamedataChoiceCaptionPartType;
  let i: Int32 = 0;
  while i < ArraySize(argList) {
    currType = argList[i].GetType();
    if Equals(currType, gamedataChoiceCaptionPartType.Blueline) {
      currBluelineHolder = argList[i] as InteractionChoiceCaptionBluelinePart;
      currBlueLinePart = currBluelineHolder.blueline.parts[0] as LifePathBluelinePart;
      if IsDefined(currBlueLinePart) {
        return currBlueLinePart.additionalData;
      };
    };
    i = i + 1;
  };

  return false;
}