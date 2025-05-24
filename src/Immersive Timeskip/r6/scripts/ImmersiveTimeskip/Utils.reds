module ImmersiveTimeskip.Utils

public class ITSUtils {
  
  // Checks if custom timeskip popup available
  public static func IsTimeskipAvailable(player: ref<PlayerPuppet>) -> Bool {
    let gameInstance: GameInstance = player.GetGame();
    let canTimeskip: Bool = GameTimeUtils.CanPlayerTimeSkip(player);
    let notInElevator: Bool = !LiftDevice.IsPlayerInsideElevator(gameInstance);
    let timeDilationNotActive: Bool = !GameInstance.GetTimeSystem(gameInstance).IsTimeDilationActive();
    return canTimeskip && notInElevator && timeDilationNotActive;
  }

  // Animates opacity change
  public static func AnimateAlpha(targetWidget: wref<inkWidget>, endAlpha: Float, duration: Float) -> ref<inkAnimProxy> {
    let proxy: ref<inkAnimProxy>;
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetEndTransparency(endAlpha);
    transparencyInterpolator.SetDuration(duration);
    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
    return proxy;
  }
}

// Logging shortcut
public func ITS(str: String) -> Void {
  // LogChannel(n"DEBUG", s"TimeSkip: \(str)");
}
