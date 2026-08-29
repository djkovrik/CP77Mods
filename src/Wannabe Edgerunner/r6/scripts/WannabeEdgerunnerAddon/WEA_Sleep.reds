// Wannabe Edgerunner Add-on - sleep verification callback (¬_¬)
// "did you actually sleep or just tap the bed?" - we find out 10 real seconds later

module Edgerunning.System
import Edgerunning.Common.*

// 10s delay - checks if 6+ game-hours passed (actual sleep vs bed cancel) (¬ᗜ¬)
public class WEA_SleepVerifyCallback extends DelayCallback {
    let m_systemRef: wref<EdgerunningSystem>;

    public func Call() -> Void {
        if !IsDefined(this.m_systemRef) { return; };
        if !this.m_systemRef.m_weaSleepPending { return; }; // pending flag got cleared elsewhere, we're stale

        this.m_systemRef.m_weaSleepPending = false;

        let gi = GetGameInstance();
        let currentTime = GameInstance.GetTimeSystem(gi).GetGameTimeStamp();
        let elapsed = currentTime - this.m_systemRef.m_weaSleepCheckTime;

        // 6 in-game hours = 21600 game-seconds. anything less = they bailed on the sleep ui
        if elapsed >= 21600.0 {
            // flip the bypass flag and re-fire OnRestoreAction - this time the gate lets it through
            this.m_systemRef.m_weaSleepBypass = true;
            this.m_systemRef.OnRestoreAction(HumanityRestoringAction.Sleep);
        };
    }
}
