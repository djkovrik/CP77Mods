@wrapMethod(BrowserController)
private final func TryGetWebsiteData(address: String) -> wref<JournalInternetPage> {
  if Equals("Atelier", address) {
    // "NETdir://ncity.pub" sets current webpage to the default one from "Internet" tab, which holds
    // all of the websites logos  
    return wrappedMethod("NETdir://ncity.pub");
  } else {
    return wrappedMethod(address);
  }
}

@wrapMethod(BrowserController)
protected cb func OnPageSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
  wrappedMethod(widget, userData);
  
  let currentController = this.m_currentPage.GetController() as WebPage;
  
  if Equals(this.m_defaultDevicePage, "Atelier") {
    inkTextRef.SetText(this.m_addressText, "NETdir://atelier.pub");
    currentController.PopulateAtelierView(this.m_gameController.GetPlayerControlledObject());
  }
}