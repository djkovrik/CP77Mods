import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

/**
  public func Init(player: ref<PlayerPuppet>) -> Void
  public func RunLowHumanityEffects() -> Void
  public func StopLowHumanityEffects() -> Void
  public func RunPrePsychosisEffects() -> Void
  public func StopPrePsychosisEffects() -> Void
  public func RunPsychosisEffects() -> Void
  public func StopPsychosisEffects() -> Void
  public func ScheduleCycledSfx(delay: Float) -> Void
  public func CancelCycledFx() -> Void
  public func PlayFastTravelFx() -> Void
  public func CancelOtherFxes() -> Void
*/
public class PsychosisEffectsHelper {
  private let player: wref<PlayerPuppet>;
  private let delaySystem: wref<DelaySystem>;

  private let cycledSFXDelayId: DelayID;

  private let cyberpsychosisSFX: array<ref<SFXBundle>>;

  public func Init(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
    this.delaySystem = GameInstance.GetDelaySystem(player.GetGame());
    this.PopulateSfxArray();
  }

  public func RunLowHumanityEffects() -> Void {
    E("!!! Fx Stage 1 - Glitches start");
    this.StopVFX(n"hacking_glitch_low");
    this.PlayVFXDelayed(n"fx_damage_high", 0.5);
    this.PlaySFXDelayed(n"ono_v_pain_short", 0.5);
    this.PlayVFXDelayed(n"personal_link_glitch", 0.75);
    this.PlaySFXDelayed(n"ono_v_fear_panic_scream ", 1.7);
    this.PlayVFXDelayed(n"disabling_connectivity_glitch", 1.8);
    this.PlayVFXDelayed(n"hacking_glitch_low", 3.0);
    this.ApplyStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 0.1);
  }

  public func StopLowHumanityEffects() -> Void {
    E("!!! Fx Stage 1 - Glitches stop");
    this.RemoveStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 0.1);
    this.StopVFX(n"hacking_glitch_low");
  };

  public func RunPrePsychosisEffects() -> Void {
    E("!!! Fx Stage 2 - Pre-Psychosis start");
    this.StopVFX(n"hacking_glitch_low");
    this.StopVFX(n"reboot_glitch");
    this.PlaySFXDelayed(n"ono_v_pain_short", 0.5);
    this.PlayVFXDelayed(n"reboot_glitch", 0.5);
    this.PlayVFXDelayed(n"hacking_glitch_low", 2.0);
    this.ApplyStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 3.0);
    this.ApplyStatusEffect(t"BaseStatusEffect.ActivePrePsychosisGlitch", 4.0);
  }

  public func StopPrePsychosisEffects() -> Void {
    E("!!! Fx Stage 2 - Pre-Psychosis stop");
    this.RemoveStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 0.1);
    this.RemoveStatusEffect(t"BaseStatusEffect.ActivePrePsychosisGlitch", 0.2);
    this.StopVFX(n"hacking_glitch_low");
  };

  public func RunPsychosisEffects() -> Void {
    E("!!! Fx Stage 3 - Psychosis start");
    this.StopVFX(n"hacking_glitch_low");
    this.ApplyStatusEffect(t"BaseStatusEffect.ActivePsychosisBuff", 0.1);
    this.PlayVFXDelayed(n"hacking_glitch_low", 7.0);
  }

  public func StopPsychosisEffects() -> Void {
    E("!!! Fx Stage 3 - Psychosis stop");
    this.RemoveStatusEffect(t"BaseStatusEffect.ActivePsychosisBuff", 0.1);
    this.StopVFX(n"hacking_glitch_low");
  };

  public func ScheduleCycledSfx(delay: Float) -> Void {
    E("Sfx - Schedule cycled fx");
    this.cycledSFXDelayId = this.delaySystem.DelayCallback(LaunchCycledSFXCallback.Create(this), delay, false);
  }

  public func CancelCycledFx() -> Void {
    E("Sfx - Cancel cycled fx");
    this.delaySystem.CancelDelay(this.cycledSFXDelayId);
  }

  public func PlayFastTravelFx() -> Void {
    this.PlayVFXDelayed(n"fast_travel_glitch", 0.3);
  }

  public func CancelOtherFxes() -> Void {
    E("Sfx - Cancel other fxes");
    this.StopVFX(n"fx_damage_high");
    this.StopVFX(n"personal_link_glitch");
    this.StopVFX(n"disabling_connectivity_glitch");
    this.StopVFX(n"hacking_glitch_low");
    this.StopVFX(n"reboot_glitch");
    this.StopSFX(n"ono_v_pain_short");
    this.StopSFX(n"ono_v_fear_panic_scream");
  }

  private func OnLaunchCycledSFXCallback() -> Void {
    E("Sfx - OnLaunchCycledSFXCallback");
    let random: Int32 = RandRange(0, ArraySize(this.cyberpsychosisSFX));
    let bundle: ref<SFXBundle> = this.cyberpsychosisSFX[random];
    this.PlaySFX(bundle.name);
    this.cycledSFXDelayId = this.delaySystem.DelayCallback(LaunchCycledSFXCallback.Create(this), bundle.nextDelay, false);
  }

  private func PlaySFX(name: CName) -> Void {
    GameObject.PlaySoundEvent(this.player, name);
    E(s"+ Play \(name) sfx");
  }

  private func PlayVFX(name: CName) -> Void {
    GameObjectEffectHelper.StartEffectEvent(this.player, name, true);
    E(s"+ Play \(name) vfx");
  }

  private func PlaySFXDelayed(name: CName, delay: Float) -> Void {
    this.delaySystem.DelayCallback(PlaySFXCallback.Create(this.player, name), delay);
  }

  private func PlayVFXDelayed(name: CName, delay: Float) -> Void {
    this.delaySystem.DelayCallback(PlayVFXCallback.Create(this.player, name), delay);
  }

  private func StopSFX(name: CName) -> Void {
    GameObject.StopSoundEvent(this.player, name);
    E(s"+ Stop \(name) sfx");
  }

  private func StopVFX(name: CName) -> Void {
    GameObjectEffectHelper.StopEffectEvent(this.player, name);
    E(s"+ Stop \(name) vfx");
  }

  private func ApplyStatusEffect(id: TweakDBID, delay: Float) {
    this.delaySystem.DelayCallback(ApplyStatusEffectCallback.Create(this.player, id), delay);
  }

  private func RemoveStatusEffect(id: TweakDBID, delay: Float) {
    this.delaySystem.DelayCallback(RemoveStatusEffectCallback.Create(this.player, id), delay);
  }

  private func PopulateSfxArray() -> Void {
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_breath_heavy", 6.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_pain_short", 14.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_exhale_02", 8.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_pain_long", 8.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ONO_V_LongPain", 14.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_fear_panic_scream", 12.0));
  }
}

public class LaunchCycledSFXCallback extends DelayCallback {
  let helper: wref<PsychosisEffectsHelper>;

  public static func Create(helper: ref<PsychosisEffectsHelper>) -> ref<LaunchCycledSFXCallback> {
    let self: ref<LaunchCycledSFXCallback> = new LaunchCycledSFXCallback();
    self.helper = helper;
    return self;
  }

  public func Call() -> Void {
    this.helper.OnLaunchCycledSFXCallback();
  }
}

public class PlaySFXCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
	public let sfxName: CName;

  public static func Create(player: ref<PlayerPuppet>, sfxName: CName) -> ref<PlaySFXCallback> {
    let self: ref<PlaySFXCallback> = new PlaySFXCallback();
    self.player = player;
    self.sfxName = sfxName;
    return self;
  }

	public func Call() -> Void {
    GameObject.PlaySoundEvent(this.player, this.sfxName);
    E(s"Run \(this.sfxName) sfx");
	}
}

public class PlayVFXCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
	public let vfxName: CName;

  public static func Create(player: ref<PlayerPuppet>, vfxName: CName) -> ref<PlayVFXCallback> {
    let self: ref<PlayVFXCallback> = new PlayVFXCallback();
    self.player = player;
    self.vfxName = vfxName;
    return self;
  }

	public func Call() -> Void {
    GameObjectEffectHelper.StartEffectEvent(this.player, this.vfxName, false);
    E(s"Run \(this.vfxName) vfx");
	}
}

public class ApplyStatusEffectCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
  public let id: TweakDBID;

  public static func Create(player: ref<PlayerPuppet>, id: TweakDBID) -> ref<ApplyStatusEffectCallback> {
    let self: ref<ApplyStatusEffectCallback> = new ApplyStatusEffectCallback();
    self.player = player;
    self.id = id;
    return self;
  }

	public func Call() -> Void {
    GameInstance.GetStatusEffectSystem(this.player.GetGame()).ApplyStatusEffect(this.player.GetEntityID(), this.id, this.player.GetRecordID(), this.player.GetEntityID());
    E(s"Apply \(TDBID.ToStringDEBUG(this.id)) effect to player");
	}
}

public class RemoveStatusEffectCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
  public let id: TweakDBID;

  public static func Create(player: ref<PlayerPuppet>, id: TweakDBID) -> ref<RemoveStatusEffectCallback> {
    let self: ref<RemoveStatusEffectCallback> = new RemoveStatusEffectCallback();
    self.player = player;
    self.id = id;
    return self;
  }

	public func Call() -> Void {
    GameInstance.GetStatusEffectSystem(this.player.GetGame()).RemoveStatusEffect(this.player.GetEntityID(), this.id);
    E(s"Remove \(TDBID.ToStringDEBUG(this.id)) effect from player");
  }
}