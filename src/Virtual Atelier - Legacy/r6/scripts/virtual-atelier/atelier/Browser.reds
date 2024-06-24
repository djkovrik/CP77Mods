@wrapMethod(BrowserController)
protected cb func OnPageSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
  wrappedMethod(widget, userData);
  
  let currentController: ref<WebPage> = this.m_currentPage.GetController() as WebPage;
  if this.showAtelier {
    inkTextRef.SetText(this.m_addressText, "NETdir://atelier.pub");
    currentController.PopulateAtelierView(this.m_gameController.GetPlayerControlledObject());
  };
}
