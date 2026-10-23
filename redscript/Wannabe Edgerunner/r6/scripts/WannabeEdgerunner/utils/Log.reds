module Edgerunning.Common

public class EdgerunnerLogs {

  @if(ModuleExists("WannabeEdgerunnerDebug"))
  public static func IsEnabled() -> Bool = true

  @if(!ModuleExists("WannabeEdgerunnerDebug"))
  public static func IsEnabled() -> Bool = false
}

public func E(str: String) -> Void {
  if EdgerunnerLogs.IsEnabled() {
    ModLog(n"Edgerunner", str);
  };
}
