enum MarkerVisibility { 
  ThroughWalls = 0,
  LineOfSight = 1,
  Scanner = 2,
  Hidden = 3, 
  Default = 4 
}

public class EvaluateVisibilitiesEvent extends Event {}

public class EvaluateMutedMarkersCallback extends DelayCallback {
  let blackboard: wref<IBlackboard>;

  public func Call() -> Void {
    this.blackboard.SetBool(GetAllBlackboardDefs().UI_Scanner.IsEnabled_mm, false, true);
  }
}
