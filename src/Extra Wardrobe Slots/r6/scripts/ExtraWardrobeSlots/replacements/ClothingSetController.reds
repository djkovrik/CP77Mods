@addField(ClothingSetController)
private let m_clothingSetExtra: ref<ClothingSetExtra>;

@addField(ClothingSetController)
private let m_arrowMarker: ref<inkImage>;

@wrapMethod(ClothingSetController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.m_clothingSetExtra = new ClothingSetExtra();
  this.m_styleWidget = this.GetRootWidget();
  this.m_arrowMarker = this.GetRootCompoundWidget().GetWidget(n"arrowMarker") as inkImage;
}

@addMethod(ClothingSetController)
public final func SetClothingSetExtra(clothingSet: ref<ClothingSetExtra>, showName: Bool) -> Void {
  this.m_clothingSetExtra = clothingSet;
  this.SetDefined(true);
  inkWidgetRef.SetVisible(this.m_setName, showName);
}

@addMethod(ClothingSetController)
public final func UpdateNumberingExtra(slotNumber: Int32) -> Void {
  let textParams: ref<inkTextParams> = new inkTextParams();
  textParams.AddNumber("0", slotNumber + 1);
  inkTextRef.SetText(this.m_setName, "{0}", textParams);
  this.m_clothingSetExtra.setID = WardrobeSystemExtra.NumberToWardrobeClothingSetIndex(slotNumber);

  // Rotate and move arrow for right column
  if slotNumber > 6 {
    this.m_arrowMarker.SetRotation(180.0);
    this.m_arrowMarker.SetTranslation(this.GetRootCompoundWidget().GetWidth() + this.m_arrowMarker.GetWidth() * 1.75, 0.0);
  }
}

@addMethod(ClothingSetController)
public final func GetClothingSetExtra() -> ref<ClothingSetExtra> {
  return this.m_clothingSetExtra;
}
