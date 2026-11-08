module FieldArmory

public class ScreenRefresh extends DelayCallback {
  public let screen: wref<ArmoryScreen>;
  public func Call() {
    if IsDefined(this.screen) { this.screen.OnRefreshRequested(); }
  }
}

public class ArmoryInventoryListener extends InventoryScriptCallback {
  public let screen: wref<ArmoryScreen>;
  public func OnItemAdded(item: ItemID, itemData: wref<gameItemData>, flaggedAsSilent: Bool) { this.screen.Invalidate(); }
  public func OnItemRemoved(item: ItemID, difference: Int32, currentQuantity: Int32) { this.screen.Invalidate(); }
  public func OnPartAdded(item: ItemID, partID: ItemID) { this.screen.Invalidate(); }
  public func OnPartRemoved(partID: ItemID, formerItemID: ItemID) { this.screen.Invalidate(); }
  public func OnItemQuantityChanged(item: ItemID, diff: Int32, total: Uint32, flaggedAsSilent: Bool) { this.screen.Invalidate(); }
}

@wrapMethod(PlayerPuppet)
protected cb func OnNewPerkSold(evt: ref<NewPerkSoldEvent>) -> Bool {
  wrappedMethod(evt);
  if Equals(evt.perkType, gamedataNewPerkType.Cool_Central_Milestone_2) {
    let screen = ArmorySystem.Get(this.GetGame()).screen;
    if IsDefined(screen) { screen.Invalidate(); }
  }
}

@wrapMethod(PlayerDevelopmentData)
public final func BuyNewPerk(perkType: gamedataNewPerkType, opt forceBuy: Bool) -> Bool {
  let bought = wrappedMethod(perkType, forceBuy);
  if bought && Equals(perkType, gamedataNewPerkType.Cool_Central_Milestone_2) {
    let screen = ArmorySystem.Get(this.GetOwner().GetGame()).screen;
    if IsDefined(screen) { screen.Invalidate(); }
  }
  return bought;
}

public class RestoreArmorySession extends DelayCallback {
  public let system: wref<ArmorySystem>;
  public func Call() {
    if !IsDefined(this.system) || !IsDefined(this.system.journal) || IsDefined(this.system.pending) { return; }
    let game = this.system.GetGameInstance();
    let player = GetPlayer(game);
    let storage = GameInstance.FindEntityByID(game, this.system.journal.storageID) as GameObject;
    if IsDefined(player) && IsDefined(storage) && storage.IsAttached() && IsDefined(EquipmentSystem.GetData(player)) {
      let access = new StashAccess();
      access.player = player;
      access.storage = storage;
      ArmoryOperation.Recover(access);
    }
  }
}
