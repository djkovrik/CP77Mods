import LimitedHudConfig.LHUDAddonsColoringConfig
import LimitedHudCommon.*

// Change or remove fill and outline coloring for characters and objects
// You can change return numbers for object categories below (but do not delete semicolon)
// This file contains default in-game values so configure it as you like

//////////////////////////////////////////////////////////////////////////////////////////


// Reference values for glow fill color:

// No color (disable): 0    Light yellow: 1   Light blue: 2   White: 3
// Light green: 4           Blue: 5           Orange: 6       Red: 7
@replaceMethod(FocusForcedHighlightData)
private final func GetFillColorIndex() -> Int32 {
  let config: ref<LHUDAddonsColoringConfig> = new LHUDAddonsColoringConfig();
  switch this.highlightType {
    case EFocusForcedHighlightType.INTERACTION:             return EnumInt(config.FillInteraction); // 2
    case EFocusForcedHighlightType.IMPORTANT_INTERACTION:   return EnumInt(config.FillImportantInteraction); // 5
    case EFocusForcedHighlightType.WEAKSPOT:                return EnumInt(config.FillWeakspot); // 6
    case EFocusForcedHighlightType.QUEST:                   return EnumInt(config.FillQuest); // 1
    case EFocusForcedHighlightType.DISTRACTION:             return EnumInt(config.FillDistraction); // 3
    case EFocusForcedHighlightType.CLUE:                    return EnumInt(config.FillClue); // 4
    case EFocusForcedHighlightType.NPC:                     return EnumInt(config.FillNPC); // 0
    case EFocusForcedHighlightType.AOE:                     return EnumInt(config.FillAOE); // 7
    case EFocusForcedHighlightType.ITEM:                    return EnumInt(config.FillItem); // 5
    case EFocusForcedHighlightType.HOSTILE:                 return EnumInt(config.FillHostile); // 7
    case EFocusForcedHighlightType.FRIENDLY:                return EnumInt(config.FillFriendly); // 4
    case EFocusForcedHighlightType.NEUTRAL:                 return EnumInt(config.FillNeutral); // 2
    case EFocusForcedHighlightType.HACKABLE:                return EnumInt(config.FillHackable); // 4
    case EFocusForcedHighlightType.ENEMY_NETRUNNER:         return EnumInt(config.FillEnemyNetrunner); // 6
    case EFocusForcedHighlightType.BACKDOOR:                return EnumInt(config.FillBackdoor); // 5
    default: return 0; // do not change this
  };
}


//////////////////////////////////////////////////////////////////////////////////////////

// Reference values for glow outline color:

// No color (disable): 0    Light green: 1    Red: 2      Light blue: 3
// Light red: 4             Light yellow: 5   Blue: 6     White: 7
@replaceMethod(FocusForcedHighlightData)
private final func GetOutlineColorIndex() -> Int32 {
  let config: ref<LHUDAddonsColoringConfig> = new LHUDAddonsColoringConfig();
  switch this.outlineType {
    case EFocusOutlineType.INTERACTION:               return EnumInt(config.OutlineInteraction); // 3
    case EFocusOutlineType.IMPORTANT_INTERACTION:     return EnumInt(config.OutlineImportantInteraction); // 6
    case EFocusOutlineType.WEAKSPOT:                  return EnumInt(config.OutlineWeakspot); // 4
    case EFocusOutlineType.QUEST:                     return EnumInt(config.OutlineQuest); // 5
    case EFocusOutlineType.DISTRACTION:               return EnumInt(config.OutlineDistraction); // 7
    case EFocusOutlineType.CLUE:                      return EnumInt(config.OutlineClue); // 1
    // No NPC category here
    case EFocusOutlineType.AOE:                       return EnumInt(config.OutlineAOE); // 2
    case EFocusOutlineType.ITEM:                      return EnumInt(config.OutlineItem); // 6
    case EFocusOutlineType.HOSTILE:                   return EnumInt(config.OutlineHostile); // 2
    case EFocusOutlineType.FRIENDLY:                  return EnumInt(config.OutlineFriendly); // 1
    case EFocusOutlineType.NEUTRAL:                   return EnumInt(config.OutlineNeutral); // 3
    case EFocusOutlineType.HACKABLE:                  return EnumInt(config.OutlineHackable); // 1
    case EFocusOutlineType.ENEMY_NETRUNNER:           return EnumInt(config.OutlineEnemyNetrunner); // 4
    case EFocusOutlineType.BACKDOOR:                  return EnumInt(config.OutlineBackdoor); // 6
    default: return 0; // do not change this
  };
}

//////////////////////////////////////////////////////////////////////////////////////////

// Switch explosives back to AOE

@replaceMethod(ExplosiveDevice)
public const func GetCurrentOutline() -> EFocusOutlineType {
  let outlineType: EFocusOutlineType;
  if this.IsQuest() {
    outlineType = EFocusOutlineType.QUEST;
  } else {
    if !this.GetDevicePS().IsExploded() {
      outlineType = EFocusOutlineType.AOE;
    } else {
      outlineType = EFocusOutlineType.INVALID;
    };
  };
  return outlineType;
}

@replaceMethod(ExplosiveDevice)
public const func GetDefaultHighlight() -> ref<FocusForcedHighlightData> {
  let highlight: ref<FocusForcedHighlightData>;
  let outline: EFocusOutlineType;
  if this.GetDevicePS().IsDisabled() {
    return null;
  };
  if Equals(this.GetCurrentGameplayRole(), EGameplayRole.None) || Equals(this.GetCurrentGameplayRole(), EGameplayRole.Clue) {
    return null;
  };
  if this.m_scanningComponent.IsBraindanceBlocked() || this.m_scanningComponent.IsPhotoModeBlocked() {
    return null;
  };
  outline = this.GetCurrentOutline();
  highlight = new FocusForcedHighlightData();
  highlight.sourceID = this.GetEntityID();
  highlight.sourceName = this.GetClassName();
  highlight.priority = EPriority.Low;
  highlight.outlineType = outline;
  if Equals(outline, EFocusOutlineType.QUEST) {
    highlight.highlightType = EFocusForcedHighlightType.QUEST;
  } else {
    if Equals(outline, EFocusOutlineType.AOE) {
      highlight.highlightType = EFocusForcedHighlightType.AOE;
    } else {
      highlight = null;
    };
  };
  if highlight != null {
    if this.IsNetrunner() && NotEquals(highlight.outlineType, EFocusOutlineType.NEUTRAL) {
      highlight.patternType = VisionModePatternType.Netrunner;
    } else {
      highlight.patternType = VisionModePatternType.Default;
    };
  };
  return highlight;
}
