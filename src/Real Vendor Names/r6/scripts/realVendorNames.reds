@wrapMethod(WorldMapTooltipController)
public func SetData(data: WorldMapTooltipData, menu: ref<WorldMapMenuGameController>) -> Void {
  wrappedMethod(data, menu);

  let vendorName: String = this.GetRealVendorName(data);
  if NotEquals(vendorName, "") {
    inkTextRef.SetText(this.m_titleText, vendorName);
  };
}

@addMethod(WorldMapTooltipController)
private func GetRealVendorName(data: WorldMapTooltipData) -> String {
  // Get journal data entry
  let entry: String = data.journalEntry.GetId();
  // Build vendor name id
  let targetId: TweakDBID = TDBID.Create(s"Vendors.\(entry).localizedName");
  // Get localized name
  let vendorName: String = TweakDBInterface.GetString(targetId, "");
  // Fix wrong gamemappinsPointOfInterestMappinData for Fingers M.D.
  if Equals(entry, "wbr_jpn_netrunner_02") && Equals(data.mappin.GetVariant(), gamedataMappinVariant.ServicePointRipperdocVariant) {
    vendorName = "LocKey#45149";
  };

  // LogChannel(n"DEBUG", s"entry = \(entry), variant = \(data.mappin.GetVariant()), name = \(vendorName)");
  return vendorName;
}
