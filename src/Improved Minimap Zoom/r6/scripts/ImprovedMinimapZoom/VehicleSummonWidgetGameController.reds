@replaceMethod(VehicleSummonWidgetGameController)
protected cb func OnInitialize() -> Bool {
  this.m_rootWidget = this.GetRootWidget();
  this.m_rootWidget.SetVisible(false);
  inkWidgetRef.SetVisible(this.m_subText, false);
  inkWidgetRef.SetVisible(this.m_radioStationName, false);
  this.m_vehicleSummonDataDef = GetAllBlackboardDefs().VehicleSummonData;
  this.m_vehicleSummonDataBB = this.GetBlackboardSystem().Get(this.m_vehicleSummonDataDef);
  this.m_vehicleSummonStateCallback = this.m_vehicleSummonDataBB.RegisterListenerUint(this.m_vehicleSummonDataDef.SummonState, this, n"OnVehicleSummonStateChanged");
  this.m_vehiclePurchaseDataDef = GetAllBlackboardDefs().VehiclePurchaseData;
  this.m_vehiclePurchaseDataBB = this.GetBlackboardSystem().Get(this.m_vehiclePurchaseDataDef);
  this.m_vehiclePurchaseStateCallback = this.m_vehiclePurchaseDataBB.RegisterListenerVariant(this.m_vehiclePurchaseDataDef.PurchasedVehicleRecordID, this, n"OnVehiclePurchased");
  // this.m_activeVehicleBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  // this.m_mountCallback = this.m_activeVehicleBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnVehicleMount");
  this.m_activeVehicleBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
  this.m_mountCallback = this.m_activeVehicleBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this, n"OnVehicleMount");
  
}

@replaceMethod(VehicleSummonWidgetGameController)
protected cb func OnUninitialize() -> Bool {
  this.m_rootWidget.SetVisible(false);
  inkWidgetRef.SetVisible(this.m_subText, false);
  inkWidgetRef.SetVisible(this.m_radioStationName, false);
  this.m_vehicleSummonDataBB.UnregisterListenerUint(this.m_vehicleSummonDataDef.SummonState, this.m_vehicleSummonStateCallback);
  this.m_vehiclePurchaseDataBB.UnregisterListenerVariant(this.m_vehiclePurchaseDataDef.PurchasedVehicleRecordID, this.m_vehiclePurchaseStateCallback);
  // this.m_activeVehicleBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_mountCallback);
  this.m_activeVehicleBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this.m_mountCallback);
}
