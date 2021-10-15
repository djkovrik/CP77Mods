@addMethod(EquipmentSystemPlayerData)
private func SwapOuterChest(itemID: ItemID) -> Void {
  let appearanceString: String;
  let newAppearanceString: String;
  let ts: ref<TransactionSystem>;
  if Equals(EquipmentSystem.GetEquipAreaType(itemID), gamedataEquipmentArea.OuterChest) {
    ts = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
    appearanceString = ToString(ts.GetItemAppearance(this.m_owner, itemID));
    if StrFindLast(appearanceString, "&FPP") != -1 {
      newAppearanceString = StrReplace(appearanceString, "&FPP", "&TPP");
      ts.ChangeItemAppearance(this.m_owner, itemID, StringToName(newAppearanceString));
    };
  };
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnEquipProcessVisualTags(itemID: ItemID) -> Void {
  wrappedMethod(itemID);
  this.SwapOuterChest(itemID);
}

@addField(EquipmentSystemPlayerData)
public let m_photoModeBB: ref<IBlackboard>;

@addField(EquipmentSystemPlayerData)
public let m_photoModCallback: ref<CallbackHandle>;

@addMethod(EquipmentSystemPlayerData)
public func OnPhotoModeStateChanged(enabled: Bool) -> Void {
  this.SwapOuterChest(this.GetActiveItem(gamedataEquipmentArea.OuterChest));
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnAttach() -> Void {
  wrappedMethod();
  this.m_photoModeBB = GameInstance.GetBlackboardSystem(this.m_owner.GetGame()).Get(GetAllBlackboardDefs().PhotoMode);
  this.m_photoModCallback = this.m_photoModeBB.RegisterListenerBool(GetAllBlackboardDefs().PhotoMode.IsActive, this, n"OnPhotoModeStateChanged");
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnDetach() -> Void {
  wrappedMethod();
  this.m_photoModeBB.UnregisterListenerBool(GetAllBlackboardDefs().PhotoMode.IsActive, this.m_photoModCallback);
}
