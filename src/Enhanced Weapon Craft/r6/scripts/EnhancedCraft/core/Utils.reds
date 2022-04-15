module EnhancedCraft.Common

public static func IsPresetIconic(id: TweakDBID) -> Bool {
  let variant: Variant = TweakDBInterface.GetFlat(id + t".iconicVariant");
  let isIconic: Bool = FromVariant<Bool>(variant);
  return isIconic;
}

public static func L(str: String) -> Void {
  LogChannel(n"DEBUG", s"Craft: \(str)");
}
