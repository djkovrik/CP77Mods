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

@addField(inkSliderController)
native let slidingAreaRef: inkWidgetRef;

@addField(inkSliderController)
native let handleRef: inkWidgetRef;

@addField(inkSliderController)
native let direction: inkESliderDirection;

@addField(inkSliderController)
native let autoSizeHandle: Bool;

@addField(inkSliderController)
native let minimumValue: Float;

@addField(inkSliderController)
native let maximumValue: Float;

@addField(inkSliderController)
native let step: Float;
