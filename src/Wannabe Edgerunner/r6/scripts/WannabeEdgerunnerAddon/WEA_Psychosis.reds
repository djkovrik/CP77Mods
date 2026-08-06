// Wannabe Edgerunner Add-on - hostility pulse callback (╯°□°)╯︵ ┻━┻

module Edgerunning.System

// 1s repeating callback - broadcasts combat stims during psychosis
public class WEA_HostilityPulseCallback extends DelayCallback {
    let m_systemRef: wref<EdgerunningSystem>;
    let m_radius: Float;

    public func Call() -> Void {
        if !IsDefined(this.m_systemRef) { return; };

        let player = GetPlayer(GetGameInstance());
        if !IsDefined(player) { return; };

        let broadcaster = player.GetStimBroadcasterComponent();
        if !IsDefined(broadcaster) { return; };

        broadcaster.TriggerSingleBroadcast(player, gamedataStimType.Combat, this.m_radius);
        broadcaster.TriggerSingleBroadcast(player, gamedataStimType.Gunshot, this.m_radius);
        broadcaster.TriggerSingleBroadcast(player, gamedataStimType.Explosion, this.m_radius);
        broadcaster.TriggerSingleBroadcast(player, gamedataStimType.CombatCall, this.m_radius);
    }
}
