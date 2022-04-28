@addField(AllBlackboardDefinitions)
public let VirtualShop: ref<VirtualShopDef>;

public class VirtualShopDef extends BlackboardDefinition {
  public let Stores: BlackboardID_Variant;

  public let AtelierItems: BlackboardID_Variant;

  public final const func AutoCreateInSystem() -> Bool {
    return true;
  }
}

public class VirtualShop extends IScriptable {
  let storeID: CName;
  let storeName: String;
  let items: array<String>;
  let qualities: array<String>;
  let quantities: array<Int32>;
  let prices: array<Int32>;
  let atlasResource: ResRef;
  let texturePart: CName;
}

public class VirtualShopRegistration extends Event {
  let owner: wref<GameObject>;

  private func AddStore(storeID: CName, storeName: String, items: array<String>, prices: array<Int32>, atlasResource: ResRef, texturePart: CName, opt qualities: array<String>, opt quantities: array<Int32>) -> Bool {
    let board: wref<IBlackboard> = GameInstance.GetBlackboardSystem(this.owner.GetGame()).Get(GetAllBlackboardDefs().VirtualShop);
    let stores: array<ref<VirtualShop>> = FromVariant(board.GetVariant(GetAllBlackboardDefs().VirtualShop.Stores));

    let store = new VirtualShop();
    store.storeID = storeID;
    store.storeName = storeName;
    store.items = items;
    store.prices = prices;
    store.atlasResource = atlasResource;
    store.texturePart = texturePart;
    store.qualities = qualities;
    store.quantities = quantities;

    ArrayPush(stores, store);

    board.SetVariant(GetAllBlackboardDefs().VirtualShop.Stores, ToVariant(stores));
  }
}

@wrapMethod(gameuiInGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  let event = new VirtualShopRegistration();
  event.owner = this.GetPlayerControlledObject();

  this.QueueEvent(event);

  wrappedMethod();
}
