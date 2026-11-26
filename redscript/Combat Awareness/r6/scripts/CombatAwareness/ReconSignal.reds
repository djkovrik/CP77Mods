module CombatAwareness

public abstract class ReconSignal {
  
  public static func Show(system: ref<AwarenessSystem>, source: ref<GameObject>, key: String) -> Void {
    let player: ref<PlayerPuppet> = system.player;
    let delta = source.GetWorldPosition() - player.GetWorldPosition();
    let angle = AngleNormalize180(Vector4.Heading(delta) - Vector4.Heading(player.GetWorldForward()));
    let dir = AbsF(angle) < 45.0 ? "Ahead" : (AbsF(angle) > 135.0 ? "Behind" : (angle > 0.0 ? "Left" : "Right"));
    let msg: SimpleScreenMessage;
    let sourceName = GetLocalizedText(source.GetDisplayName());
   
    msg.message = AwarenessUI.Text(key) + " · " + AwarenessUI.Text(dir) + " " + IntToString(RoundF(Vector4.Length(delta))) + " " + AwarenessUI.Text("Metres");
    
    if AbsF(delta.Z) > 2.0 { 
      msg.message += " " + AwarenessUI.Text(delta.Z > 0.0 ? "Above" : "Below"); 
    };
    
    if IsStringValid(sourceName) { 
      msg.message += " · " + sourceName; 
    };

    msg.duration = 3.0;
    msg.isShown = true;
    
    let def: ref<UI_NotificationsDef> = GetAllBlackboardDefs().UI_Notifications;
    GameInstance.GetBlackboardSystem(player.GetGame()).Get(def).SetVariant(def.OnscreenMessage, ToVariant(msg), true);
  }
}
