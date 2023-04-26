public class AtelierStoresTemplateClassifier extends inkVirtualItemTemplateClassifier {}
public class AtelierVirtualList extends inkVirtualCompoundWidget {}

public class AtelierStoreSoundEvent extends Event {
  let name: CName;

  public static func Create(name: CName) -> ref<AtelierStoreSoundEvent> {
    let evt: ref<AtelierStoreSoundEvent> = new AtelierStoreSoundEvent();
    evt.name = name;
    return evt;
  }
}

public class AtelierStoreClickEvent extends Event {
  let storeID: CName;

  public static func Create(id: CName) -> ref<AtelierStoreClickEvent> {
    let evt: ref<AtelierStoreClickEvent> = new AtelierStoreClickEvent();
    evt.storeID = id;
    return evt;
  }
}

public class AtelierStoreHoverOverEvent extends Event {
  let store: ref<VirtualShop>;

  public static func Create(store: ref<VirtualShop>) -> ref<AtelierStoreHoverOverEvent> {
    let evt: ref<AtelierStoreHoverOverEvent> = new AtelierStoreHoverOverEvent();
    evt.store = store;
    return evt;
  }
}

public class AtelierStoreHoverOutEvent extends Event {
  public static func Create() -> ref<AtelierStoreHoverOutEvent> {
    let evt: ref<AtelierStoreHoverOutEvent> = new AtelierStoreHoverOutEvent();
    return evt;
  }
}

public class AtelierStoresRefreshEvent extends Event {
  let store: ref<VirtualShop>;

  public static func Create(store: ref<VirtualShop>) -> ref<AtelierStoresRefreshEvent> {
    let evt: ref<AtelierStoresRefreshEvent> = new AtelierStoresRefreshEvent();
    evt.store = store;
    return evt;
  }
}

@wrapMethod(gameuiInGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.SpawnAtelierButtonHints();
}

@addMethod(gameuiInGameMenuGameController)
private func SpawnAtelierButtonHints() -> Void {
  let inkSystem: ref<inkSystem> = GameInstance.GetInkSystem();
  let hudRoot: ref<inkCompoundWidget> = inkSystem.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  hudRoot.RemoveChildByName(n"AtelierButtonHints");

  let container: ref<inkCanvas> = new inkCanvas();
  container.SetName(n"AtelierButtonHints");
  container.SetAnchor(inkEAnchor.BottomCenter);
  container.SetAnchorPoint(0.0, 1.0);
  container.SetSize(400.0, 100.0);
  container.SetScale(new Vector2(0.666, 0.666));
  container.SetMargin(new inkMargin(160.0, 0.0, 0.0, 20.0));
  container.Reparent(hudRoot);
  this.SpawnFromExternal(container, r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
}
