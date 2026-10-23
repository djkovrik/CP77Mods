// -- Utils
public static func HasTheSameId(point: ref<FastTravelPointData>, tdbID: TweakDBID) -> Bool {
  return Equals(point.pointRecord, tdbID);
}

public static func IsFastTravelPointEnabled(point: ref<FastTravelPointData>) -> Bool {
  return false;
}

// -- Overrides
@replaceMethod(FastTravelPointData)
public final const func ShouldShowMappinOnWorldMap() -> Bool {
  return TweakDBInterface.GetFastTravelPointRecord(this.pointRecord).ShowOnWorldMap() && IsFastTravelPointEnabled(this);
}

@replaceMethod(FastTravelPointData)
public final const func ShouldShowMappinInWorld() -> Bool {
  return TweakDBInterface.GetFastTravelPointRecord(this.pointRecord).ShowInWorld() && IsFastTravelPointEnabled(this);
}

@replaceMethod(DataTerm)
private final func RegisterMappin() -> Void {
  let mappinData: MappinData;
  if this.GetDevicePS().IsDisabled() {
    return ;
  };
  if !this.m_linkedFastTravelPoint.ShouldShowMappinInWorld() {
    this.DeactivateDevice(); // <- deactivates terminal if ft point is hidden
    EntityGameInterface.Destroy(this.GetEntity()); // <- destroy terminal entity
    return ;
  };
  if !this.IsMappinRegistered() {
    mappinData.mappinType = t"Mappins.FastTravelDynamicMappin";
    mappinData.variant = gamedataMappinVariant.FastTravelVariant;
    mappinData.visibleThroughWalls = false;
    this.m_mappinID = this.GetMappinSystem().RegisterMappinWithObject(mappinData, this, n"poi_mappin");
  };
}
