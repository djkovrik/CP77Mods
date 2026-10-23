@wrapMethod(ItemQuantityPickerController)
private final func SetData() -> Void {
  wrappedMethod();
  if NotEquals(this.m_data.virtualItemPrice, 0) {
    this.m_itemPrice = this.m_data.virtualItemPrice;
    this.UpdatePriceText();
  };
}