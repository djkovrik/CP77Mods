module VendorPreview.StoresManager
import VendorPreview.Utils.AtelierLog

public class VirtualAtelierStoresSystem extends ScriptableSystem {

  private let stores: array<ref<VirtualShop>>;

  public static func GetInstance(player: ref<GameObject>) -> ref<VirtualAtelierStoresSystem> {
    let system: ref<VirtualAtelierStoresSystem> = GameInstance.GetScriptableSystemsContainer(player.GetGame()).Get(n"VendorPreview.StoresManager.VirtualAtelierStoresSystem") as VirtualAtelierStoresSystem;
    return system;
  }

  public func GetStores() -> array<ref<VirtualShop>> {
    return this.stores;
  }

  public func SetStores(stores: array<ref<VirtualShop>>) -> Void {
    this.stores = stores;
  }

  public func BuildStoresList() -> Void {
    ArrayClear(this.stores);

    let event: ref<VirtualShopRegistration> = new VirtualShopRegistration();
    event.SetSystemInstance(this);
    GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(event);
    AtelierLog("Initialized");
  }
}

@wrapMethod(gameuiInGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  VirtualAtelierStoresSystem.GetInstance(this.GetPlayerControlledObject()).BuildStoresList();
}
