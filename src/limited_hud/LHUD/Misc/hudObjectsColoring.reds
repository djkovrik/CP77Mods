
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
    case EFocusForcedHighlightType.INTERACTION:             return 2;
    case EFocusForcedHighlightType.IMPORTANT_INTERACTION:   return 5;
    case EFocusForcedHighlightType.WEAKSPOT:                return 6;
    case EFocusForcedHighlightType.QUEST:                   return 1;
    case EFocusForcedHighlightType.DISTRACTION:             return 3;
    case EFocusForcedHighlightType.CLUE:                    return 4;
    case EFocusForcedHighlightType.NPC:                     return 0;
    case EFocusForcedHighlightType.AOE:                     return 7;
    case EFocusForcedHighlightType.ITEM:                    return 5;
    case EFocusForcedHighlightType.HOSTILE:                 return 7;
    case EFocusForcedHighlightType.FRIENDLY:                return 4;
    case EFocusForcedHighlightType.NEUTRAL:                 return 2;
    case EFocusForcedHighlightType.HACKABLE:                return 4;
    case EFocusForcedHighlightType.ENEMY_NETRUNNER:         return 6;
    case EFocusForcedHighlightType.BACKDOOR:                return 5;
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
    case EFocusOutlineType.INTERACTION:               return 3;
    case EFocusOutlineType.IMPORTANT_INTERACTION:     return 6;
    case EFocusOutlineType.WEAKSPOT:                  return 4;
    case EFocusOutlineType.QUEST:                     return 5;
    case EFocusOutlineType.DISTRACTION:               return 7;
    case EFocusOutlineType.CLUE:                      return 1;
    // No NPC category here
    case EFocusOutlineType.AOE:                       return 2;
    case EFocusOutlineType.ITEM:                      return 6;
    case EFocusOutlineType.HOSTILE:                   return 2;
    case EFocusOutlineType.FRIENDLY:                  return 1;
    case EFocusOutlineType.NEUTRAL:                   return 3;
    case EFocusOutlineType.HACKABLE:                  return 1;
    case EFocusOutlineType.ENEMY_NETRUNNER:           return 4;
    case EFocusOutlineType.BACKDOOR:                  return 6;
    default: return 0; // do not change this
  };
}
