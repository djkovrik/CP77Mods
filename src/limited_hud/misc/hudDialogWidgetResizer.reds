@addMethod(dialogWidgetGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  // Change this to scale dialog box, lower values means smaler size
  // You may wana to try something like 0.9 or 0.8
  let scaleValue: Float = 1.0;
  this.GetRootWidget().SetScale(new Vector2(scaleValue, scaleValue));
}