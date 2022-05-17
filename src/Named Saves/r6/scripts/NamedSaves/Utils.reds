module NamedSaves.Utils

public static func GetSaveIndexFromInternalName(internalName: String) -> Int32 {
  let prefix: String = GetLocalizedTextByKey(n"UI-Menus-Saving-ManualSave");
  let indexStr: String = StrAfterLast(internalName, prefix);
  return StringToInt(indexStr, -1);
}
