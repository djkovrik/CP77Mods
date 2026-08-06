// Wannabe Edgerunner Add-on - config (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧

@if(ModuleExists("ModSettingsModule"))
public class WEAConfig {

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Sleep Recovery")
    @runtimeProperty("ModSettings.displayName", "Require Actual Sleep")
    @runtimeProperty("ModSettings.description", "If enabled, clicking the bed and canceling won't restore humanity - you must actually sleep")
    public let sleepVerificationEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Sleep Recovery")
    @runtimeProperty("ModSettings.displayName", "Max Recovery %")
    @runtimeProperty("ModSettings.description", "Maximum humanity percentage recoverable from sleep (100 = full restore)")
    @runtimeProperty("ModSettings.step", "5")
    @runtimeProperty("ModSettings.min", "10")
    @runtimeProperty("ModSettings.max", "100")
    public let sleepRecoveryCap: Int32 = 100;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Sleep Recovery")
    @runtimeProperty("ModSettings.displayName", "Scale By Hours Slept")
    @runtimeProperty("ModSettings.description", "Short naps restore less than a full night's sleep - the longer you actually sleep, the more humanity comes back. Needs Sleep Verification.")
    public let sleepScalingEnabled: Bool = false;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Sleep Recovery")
    @runtimeProperty("ModSettings.displayName", "Full Restore Hours")
    @runtimeProperty("ModSettings.description", "Sleep this many hours to wake up fully rested. Less than that, and you only get a proportional slice of humanity back.")
    @runtimeProperty("ModSettings.step", "1")
    @runtimeProperty("ModSettings.min", "6")
    @runtimeProperty("ModSettings.max", "12")
    public let sleepScalingFullHours: Int32 = 8;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "HUD")
    @runtimeProperty("ModSettings.displayName", "Hide Humanity Restored Messages")
    @runtimeProperty("ModSettings.description", "Tired of '+X Humanity' popups cluttering your screen every time you pet a cat? Flip this on for a quieter HUD (･ω<)")
    public let hideHumanityMessages: Bool = false;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Weapon Twitch")
    @runtimeProperty("ModSettings.displayName", "Enable Weapon Twitch")
    @runtimeProperty("ModSettings.description", "Hands tremble when aiming at low humanity - small, quick twitches that worsen as you lose yourself")
    public let twitchEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Weapon Twitch")
    @runtimeProperty("ModSettings.displayName", "Mild Twitch Threshold %")
    @runtimeProperty("ModSettings.description", "Humanity % below which mild weapon twitch begins")
    @runtimeProperty("ModSettings.step", "5")
    @runtimeProperty("ModSettings.min", "10")
    @runtimeProperty("ModSettings.max", "80")
    public let twitchThresholdMild: Int32 = 40;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Weapon Twitch")
    @runtimeProperty("ModSettings.displayName", "Moderate Twitch Threshold %")
    @runtimeProperty("ModSettings.description", "Humanity % below which moderate weapon twitch kicks in")
    @runtimeProperty("ModSettings.step", "5")
    @runtimeProperty("ModSettings.min", "5")
    @runtimeProperty("ModSettings.max", "60")
    public let twitchThresholdModerate: Int32 = 25;

    // severe twitch reuses the base mod's psychosis threshold
    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Neuroblockers")
    @runtimeProperty("ModSettings.displayName", "Tier-Based Effectiveness")
    @runtimeProperty("ModSettings.description", "Neuroblockers reduce humanity damage instead of blocking it - effectiveness depends on quality tier")
    public let neuroEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Neuroblockers")
    @runtimeProperty("ModSettings.displayName", "Common Reduction %")
    @runtimeProperty("ModSettings.description", "Damage reduction from Common neuroblockers")
    @runtimeProperty("ModSettings.step", "5")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "100")
    public let neuroReductionCommon: Int32 = 40;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Neuroblockers")
    @runtimeProperty("ModSettings.displayName", "Uncommon Reduction %")
    @runtimeProperty("ModSettings.description", "Damage reduction from Uncommon neuroblockers")
    @runtimeProperty("ModSettings.step", "5")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "100")
    public let neuroReductionUncommon: Int32 = 60;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Neuroblockers")
    @runtimeProperty("ModSettings.displayName", "Rare Reduction %")
    @runtimeProperty("ModSettings.description", "Damage reduction from Rare neuroblockers - the best you'll find in Night City")
    @runtimeProperty("ModSettings.step", "5")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "100")
    public let neuroReductionRare: Int32 = 80;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Psychosis Hostility")
    @runtimeProperty("ModSettings.displayName", "NPCs Fear Cyberpsycho")
    @runtimeProperty("ModSettings.description", "During psychosis, nearby NPCs are hit with combat stimuli - everyone panics and fights back. Hardcore vibes.")
    public let psychosisHostilityEnabled: Bool = false;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Psychosis Hostility")
    @runtimeProperty("ModSettings.displayName", "Pulse Radius")
    @runtimeProperty("ModSettings.description", "How far the hostility broadcast reaches (meters)")
    @runtimeProperty("ModSettings.step", "5")
    @runtimeProperty("ModSettings.min", "10")
    @runtimeProperty("ModSettings.max", "100")
    public let psychosisHostilityRadius: Int32 = 60;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Cigarette Humanity")
    @runtimeProperty("ModSettings.displayName", "Enable Cigarette Recovery")
    @runtimeProperty("ModSettings.description", "Smoking a cigarette restores a small amount of humanity - take a drag, feel human again")
    public let smokeEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Cigarette Humanity")
    @runtimeProperty("ModSettings.displayName", "Humanity Per Cigarette")
    @runtimeProperty("ModSettings.step", "1")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "15")
    public let smokeRestoreAmount: Int32 = 5;

    @runtimeProperty("ModSettings.mod", "WE Add-on")
    @runtimeProperty("ModSettings.category", "Cigarette Humanity")
    @runtimeProperty("ModSettings.displayName", "Daily Smoke Limit")
    @runtimeProperty("ModSettings.description", "Max cigarettes per day that restore humanity (diminishing returns and all that)")
    @runtimeProperty("ModSettings.step", "1")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "10")
    public let smokeDailyLimit: Int32 = 4;

    public static func Get() -> ref<WEAConfig> {
        return new WEAConfig();
    }
}

@if(!ModuleExists("ModSettingsModule"))
public class WEAConfig {

    public let sleepVerificationEnabled: Bool = true;
    public let sleepRecoveryCap: Int32 = 100;
    public let sleepScalingEnabled: Bool = false;
    public let sleepScalingFullHours: Int32 = 8;
    public let hideHumanityMessages: Bool = false;

    public let twitchEnabled: Bool = true;
    public let twitchThresholdMild: Int32 = 40;
    public let twitchThresholdModerate: Int32 = 25;

    public let neuroEnabled: Bool = true;
    public let neuroReductionCommon: Int32 = 40;
    public let neuroReductionUncommon: Int32 = 60;
    public let neuroReductionRare: Int32 = 80;

    public let psychosisHostilityEnabled: Bool = false;
    public let psychosisHostilityRadius: Int32 = 60;

    public let smokeEnabled: Bool = true;
    public let smokeRestoreAmount: Int32 = 5;
    public let smokeDailyLimit: Int32 = 4;

    public static func Get() -> ref<WEAConfig> {
        return new WEAConfig();
    }
}
