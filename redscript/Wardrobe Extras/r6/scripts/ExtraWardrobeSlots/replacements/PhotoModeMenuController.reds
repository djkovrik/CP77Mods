@addField(gameuiPhotoModeMenuController)
private let m_extraWardrobeAttribute: Uint32;

@addField(gameuiPhotoModeMenuController)
private let m_hasExtraWardrobeAttribute: Bool;

@wrapMethod(gameuiPhotoModeMenuController)
protected cb func OnAddMenuItem(labelText: String, attributeKey: Uint32, page: Uint32) -> Bool {
  wrappedMethod(labelText, attributeKey, page);
  if Equals(labelText, "UI-PhotoMode-MenuItemOutfitPreset") || Equals(labelText, GetLocalizedText("UI-PhotoMode-MenuItemOutfitPreset")) {
    this.m_extraWardrobeAttribute = attributeKey;
    this.m_hasExtraWardrobeAttribute = true;
  };
}

@wrapMethod(gameuiPhotoModeMenuController)
protected cb func OnSetupOptionSelector(attribute: Uint32, values: array<PhotoModeOptionSelectorData>, startData: Int32, doApply: Bool) -> Bool {
  let extraValues: array<PhotoModeOptionSelectorData>;
  let wardrobeSystemExtra: ref<WardrobeSystemExtra>;
  if this.IsExtraWardrobeSelector(attribute, values) {
    wardrobeSystemExtra = WardrobeSystemExtra.GetInstance(this.GetPlayerControlledObject().GetGame());
    wardrobeSystemExtra.SetPhotoModeExtraSelectorActive(true);
    extraValues = this.BuildExtraWardrobeSelectorValues(values);
    startData = WardrobeSystemExtra.WardrobeClothingSetIndexToPhotoModeData(wardrobeSystemExtra.GetActiveClothingSetIndex());
    wrappedMethod(attribute, extraValues, startData, doApply);
  } else {
    wrappedMethod(attribute, values, startData, doApply);
  };
}

@wrapMethod(gameuiPhotoModeMenuController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  WardrobeSystemExtra.GetInstance(this.GetPlayerControlledObject().GetGame()).SetPhotoModeExtraSelectorActive(false);
}

@addMethod(gameuiPhotoModeMenuController)
public final func IsExtraWardrobeAttribute(attribute: Uint32) -> Bool {
  return this.m_hasExtraWardrobeAttribute && attribute == this.m_extraWardrobeAttribute;
}

@addMethod(gameuiPhotoModeMenuController)
public final func ApplyExtraWardrobeSelection(photoModeData: Int32) -> Void {
  let playerData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(this.GetPlayerControlledObject());
  let wardrobeSystemExtra: ref<WardrobeSystemExtra> = WardrobeSystemExtra.GetInstance(this.GetPlayerControlledObject().GetGame());
  let wardrobeSetExtra: gameWardrobeClothingSetIndexExtra = WardrobeSystemExtra.PhotoModeDataToWardrobeClothingSetIndex(photoModeData);
  wardrobeSystemExtra.SetPhotoModeSelectedSetIndex(wardrobeSetExtra);
  if Equals(wardrobeSetExtra, gameWardrobeClothingSetIndexExtra.INVALID) {
    playerData.UnequipWardrobeSetExtra();
  } else {
    playerData.EquipWardrobeSetExtra(wardrobeSetExtra);
  };
}

@addMethod(gameuiPhotoModeMenuController)
private final func IsExtraWardrobeSelector(attribute: Uint32, values: array<PhotoModeOptionSelectorData>) -> Bool {
  let itemData: ref<PhotoModeMenuListItemData>;
  let listItem: ref<PhotoModeMenuListItem>;
  if this.m_hasExtraWardrobeAttribute && attribute == this.m_extraWardrobeAttribute {
    return true;
  };
  listItem = this.GetMenuItem(attribute);
  if !IsDefined(listItem) {
    return false;
  };
  itemData = listItem.GetData() as PhotoModeMenuListItemData;
  if !IsDefined(itemData) {
    return false;
  };
  if Equals(itemData.label, "UI-PhotoMode-MenuItemOutfitPreset") || Equals(itemData.label, GetLocalizedText("UI-PhotoMode-MenuItemOutfitPreset")) || StrContains(itemData.label, "OutfitPreset") {
    this.m_extraWardrobeAttribute = attribute;
    this.m_hasExtraWardrobeAttribute = true;
    return true;
  };
  if this.ValuesMatchOriginalWardrobe(values) {
    this.m_extraWardrobeAttribute = attribute;
    this.m_hasExtraWardrobeAttribute = true;
    return true;
  };
  return false;
}

@addMethod(gameuiPhotoModeMenuController)
private final func ValuesMatchOriginalWardrobe(values: array<PhotoModeOptionSelectorData>) -> Bool {
  let i: Int32;
  let j: Int32;
  let matchedSet: Bool;
  let offFound: Bool;
  let originalSets: array<ref<ClothingSet>> = GameInstance.GetWardrobeSystem(this.GetPlayerControlledObject().GetGame()).GetClothingSets();
  if ArraySize(originalSets) == 0 || ArraySize(values) != ArraySize(originalSets) + 1 {
    return false;
  };
  i = 0;
  while i < ArraySize(values) {
    if values[i].optionData == EnumInt(gameWardrobeClothingSetIndex.INVALID) {
      offFound = true;
    } else {
      matchedSet = false;
      j = 0;
      while j < ArraySize(originalSets) {
        if values[i].optionData == EnumInt(originalSets[j].setID) {
          matchedSet = true;
          break;
        };
        j += 1;
      };
      if !matchedSet {
        return false;
      };
    };
    i += 1;
  };
  return offFound;
}

@addMethod(gameuiPhotoModeMenuController)
private final func BuildExtraWardrobeSelectorValues(nativeValues: array<PhotoModeOptionSelectorData>) -> array<PhotoModeOptionSelectorData> {
  let extraSets: array<ref<ClothingSetExtra>> = WardrobeSystemExtra.GetInstance(this.GetPlayerControlledObject().GetGame()).GetClothingSets();
  let i: Int32;
  let noneText: String = GetLocalizedText("UI-PhotoMode-OptionOff");
  let option: PhotoModeOptionSelectorData;
  let result: array<PhotoModeOptionSelectorData>;
  let slotNumber: Int32;
  option.optionText = noneText;
  option.optionData = EnumInt(gameWardrobeClothingSetIndex.INVALID);
  ArrayPush(result, option);
  slotNumber = 0;
  while slotNumber < EnumInt(gameWardrobeClothingSetIndexExtra.COUNT) {
    i = 0;
    while i < ArraySize(extraSets) {
      if WardrobeSystemExtra.WardrobeClothingSetIndexToNumber(extraSets[i].setID) == slotNumber {
        option.optionText = this.GetExtraWardrobeOptionText(nativeValues, slotNumber);
        option.optionData = WardrobeSystemExtra.WardrobeClothingSetIndexToPhotoModeData(extraSets[i].setID);
        ArrayPush(result, option);
        break;
      };
      i += 1;
    };
    slotNumber += 1;
  };
  return result;
}

@addMethod(gameuiPhotoModeMenuController)
private final func GetExtraWardrobeOptionText(nativeValues: array<PhotoModeOptionSelectorData>, slotNumber: Int32) -> String {
  let i: Int32 = 0;
  if slotNumber < EnumInt(gameWardrobeClothingSetIndex.COUNT) {
    while i < ArraySize(nativeValues) {
      if nativeValues[i].optionData == slotNumber {
        return nativeValues[i].optionText;
      };
      i += 1;
    };
  };
  if slotNumber < 9 {
    return "0" + ToString(slotNumber + 1);
  };
  return ToString(slotNumber + 1);
}

@addMethod(PhotoModeMenuListItem)
private final func ApplySelectedExtraWardrobeOption() -> Void {
  let data: ref<PhotoModeMenuListItemData> = this.GetData() as PhotoModeMenuListItemData;
  let selectedIndex: Int32;
  if !IsDefined(data) || !IsDefined(this.m_photoModeController) || !this.m_photoModeController.IsExtraWardrobeAttribute(data.attributeKey) {
    return;
  };
  selectedIndex = this.GetSelectedOptionIndex();
  if selectedIndex >= 0 && selectedIndex < ArraySize(this.m_OptionSelectorValues) {
    this.m_photoModeController.ApplyExtraWardrobeSelection(this.m_OptionSelectorValues[selectedIndex].optionData);
  };
}

@wrapMethod(PhotoModeMenuListItem)
public final func HandleReleasedInput(e: ref<inkPointerEvent>, opt gameCtrl: wref<inkGameController>) -> Void {
  wrappedMethod(e, gameCtrl);
  this.ApplySelectedExtraWardrobeOption();
}

@wrapMethod(PhotoModeMenuListItem)
protected cb func OnOptionLeft(e: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(e);
  this.ApplySelectedExtraWardrobeOption();
}

@wrapMethod(PhotoModeMenuListItem)
protected cb func OnOptionRight(e: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(e);
  this.ApplySelectedExtraWardrobeOption();
}

@wrapMethod(PhotoModeMenuListItem)
public final func ForceValue(value: Float, doApply: Bool) -> Void {
  wrappedMethod(value, doApply);
  this.ApplySelectedExtraWardrobeOption();
}
