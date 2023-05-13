import VirtualAtelier.Systems.VirtualAtelierCartManager
import VirtualAtelier.Systems.VirtualAtelierPreviewManager

public class AtelierEquipStateChangedEvent extends Event {
  public let manager: wref<VirtualAtelierPreviewManager>;

  public static func Create(manager: ref<VirtualAtelierPreviewManager>) -> ref<AtelierEquipStateChangedEvent> {
    let evt: ref<AtelierEquipStateChangedEvent> = new AtelierEquipStateChangedEvent();
    evt.manager = manager;
    return evt;
  }
}

public class AtelierCartStateChangedEvent extends Event {
  public let manager: wref<VirtualAtelierCartManager>;

  public static func Create(manager: ref<VirtualAtelierCartManager>) -> ref<AtelierCartStateChangedEvent> {
    let evt: ref<AtelierCartStateChangedEvent> = new AtelierCartStateChangedEvent();
    evt.manager = manager;
    return evt;
  }
}

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
