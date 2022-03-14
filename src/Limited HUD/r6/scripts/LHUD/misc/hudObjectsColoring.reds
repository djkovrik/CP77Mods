import LimitedHudConfig.LHUDAddonsColoringConfig

// Change or remove fill and outline coloring for characters and objects
// You can change return numbers for object categories below (but do not delete semicolon)
// This file contains default in-game values so configure it as you like

//////////////////////////////////////////////////////////////////////////////////////////


// Reference values for glow fill color:

// No color (disable): 0    Light yellow: 1   Light blue: 2   White: 3
// Light green: 4           Blue: 5           Orange: 6       Red: 7
@replaceMethod(FocusForcedHighlightData)
private final func GetFillColorIndex() -> Int32 {
  switch this.highlightType {
    case EFocusForcedHighlightType.INTERACTION:             return LHUDAddonsColoringConfig.FillInteraction(); // 2
    case EFocusForcedHighlightType.IMPORTANT_INTERACTION:   return LHUDAddonsColoringConfig.FillImportantInteraction(); // 5
    case EFocusForcedHighlightType.WEAKSPOT:                return LHUDAddonsColoringConfig.FillWeakspot(); // 6
    case EFocusForcedHighlightType.QUEST:                   return LHUDAddonsColoringConfig.FillQuest(); // 1
    case EFocusForcedHighlightType.DISTRACTION:             return LHUDAddonsColoringConfig.FillDistraction(); // 3
    case EFocusForcedHighlightType.CLUE:                    return LHUDAddonsColoringConfig.FillClue(); // 4
    case EFocusForcedHighlightType.NPC:                     return LHUDAddonsColoringConfig.FillNPC(); // 0
    case EFocusForcedHighlightType.AOE:                     return LHUDAddonsColoringConfig.FillAOE(); // 7
    case EFocusForcedHighlightType.ITEM:                    return LHUDAddonsColoringConfig.FillItem(); // 5
    case EFocusForcedHighlightType.HOSTILE:                 return LHUDAddonsColoringConfig.FillHostile(); // 7
    case EFocusForcedHighlightType.FRIENDLY:                return LHUDAddonsColoringConfig.FillFriendly(); // 4
    case EFocusForcedHighlightType.NEUTRAL:                 return LHUDAddonsColoringConfig.FillNeutral(); // 2
    case EFocusForcedHighlightType.HACKABLE:                return LHUDAddonsColoringConfig.FillHackable(); // 4
    case EFocusForcedHighlightType.ENEMY_NETRUNNER:         return LHUDAddonsColoringConfig.FillEnemyNetrunner(); // 6
    case EFocusForcedHighlightType.BACKDOOR:                return LHUDAddonsColoringConfig.FillBackdoor(); // 5
    default: return 0; // do not change this
  };
}


//////////////////////////////////////////////////////////////////////////////////////////

// Reference values for glow outline color:

// No color (disable): 0    Light green: 1    Red: 2      Light blue: 3
// Light red: 4             Light yellow: 5   Blue: 6     White: 7
@replaceMethod(FocusForcedHighlightData)
private final func GetOutlineColorIndex() -> Int32 {
  switch this.outlineType {
    case EFocusOutlineType.INTERACTION:               return LHUDAddonsColoringConfig.OutlineInteraction(); // 3
    case EFocusOutlineType.IMPORTANT_INTERACTION:     return LHUDAddonsColoringConfig.OutlineImportantInteraction(); // 6
    case EFocusOutlineType.WEAKSPOT:                  return LHUDAddonsColoringConfig.OutlineWeakspot(); // 4
    case EFocusOutlineType.QUEST:                     return LHUDAddonsColoringConfig.OutlineQuest(); // 5
    case EFocusOutlineType.DISTRACTION:               return LHUDAddonsColoringConfig.OutlineDistraction(); // 7
    case EFocusOutlineType.CLUE:                      return LHUDAddonsColoringConfig.OutlineClue(); // 1
    // No NPC category here
    case EFocusOutlineType.AOE:                       return LHUDAddonsColoringConfig.OutlineAOE(); // 2
    case EFocusOutlineType.ITEM:                      return LHUDAddonsColoringConfig.OutlineItem(); // 6
    case EFocusOutlineType.HOSTILE:                   return LHUDAddonsColoringConfig.OutlineHostile(); // 2
    case EFocusOutlineType.FRIENDLY:                  return LHUDAddonsColoringConfig.OutlineFriendly(); // 1
    case EFocusOutlineType.NEUTRAL:                   return LHUDAddonsColoringConfig.OutlineNeutral(); // 3
    case EFocusOutlineType.HACKABLE:                  return LHUDAddonsColoringConfig.OutlineHackable(); // 1
    case EFocusOutlineType.ENEMY_NETRUNNER:           return LHUDAddonsColoringConfig.OutlineEnemyNetrunner(); // 4
    case EFocusOutlineType.BACKDOOR:                  return LHUDAddonsColoringConfig.OutlineBackdoor(); // 6
    default: return 0; // do not change this
  };
}
