// -- Replacer for vanilla ClothingSet to work with gameWardrobeClothingSetIndexExtra
public class ClothingSetExtra extends IScriptable {

  public persistent let setID: gameWardrobeClothingSetIndexExtra;

  public persistent let clothingList: array<SSlotVisualInfo>;

  public persistent let iconID: TweakDBID;

  public static func IsEmpty(set: ref<ClothingSetExtra>) -> Bool {
    return Equals(ArraySize(set.clothingList), 0);
  }
}
