module Edgerunning.Common

public static func E(str: String) -> Void {
  if ShowDebugLogsEdgerunner() {
    LogChannel(n"DEBUG", s"Psycho: \(str)");
  };
}
