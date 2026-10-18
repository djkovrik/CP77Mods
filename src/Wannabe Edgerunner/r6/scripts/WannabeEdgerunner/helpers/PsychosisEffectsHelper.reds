import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

/**
  public func Init(player: ref<PlayerPuppet>) -> Void
  public func RunNewPrePsychosisEffect() -> Void
  public func StopNewPrePsychosisEffect() -> Void
  public func RunNewPsychosisEffects() -> Void
  public func StopNewPsychosisEffect() -> Void
  public func RunNewPostPsychosisEffect() -> Void
  public func StopNewPostPsychosisEffect() -> Void
  public func ScheduleCycledSfx(delay: Float) -> Void
  public func CancelCycledFx() -> Void
  public func PlayFastTravelFx() -> Void
  public func CancelOtherFxes() -> Void
  public func RefreshConfig() -> Void
*/
public class PsychosisEffectsHelper {
  private let player: wref<PlayerPuppet>;
  private let delaySystem: wref<DelaySystem>;
  private let config: ref<EdgerunningConfig>;

  private let cycledSFXDelayId: DelayID;
  private let pendingFx: array<DelayID>;
  private let cycledEnabled: Bool;

  public func GetPlayer() -> wref<PlayerPuppet> { return this.player; }

  public func GetPsychosisOutlineDelay() -> Float {
    return this.config.lightVisuals ? 2.0 : 9.0;
  }

  public func CancelPendingFx() -> Void {
    for id in this.pendingFx { this.delaySystem.CancelCallback(id); };
    ArrayClear(this.pendingFx);
  }


  private let cyberpsychosisSFX: array<ref<SFXBundle>>;

  public func Init(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
    this.delaySystem = GameInstance.GetDelaySystem(player.GetGame());
    this.config = new EdgerunningConfig();
    this.PopulateSfxArray();
  }

  public func RunNewPrePsychosisEffect() -> Void {
    E("!!! Fx New - Pre Psychosis");
    this.PlayVFXDelayed(n"fx_damage_high", 0.5);
    if this.config.lightVisuals {
      this.ApplyStatusEffect(t"BaseStatusEffect.NewPrePsychosisEffectLightFx");
    } else {
      this.PlayVFXDelayed(n"personal_link_glitch", 1.0);
      this.ApplyStatusEffect(t"BaseStatusEffect.NewPrePsychosisEffectNormalFx");
    };
  }

  public func StopNewPrePsychosisEffect() -> Void {
    E("!!! Fx New - Stop Pre Psychosis");
    this.RemoveStatusEffect(t"BaseStatusEffect.NewPrePsychosisEffectLightFx");
    this.RemoveStatusEffect(t"BaseStatusEffect.NewPrePsychosisEffectNormalFx");
  }

  public func RunNewPsychosisEffect() -> Void {
    E("!!! Fx New - Psychosis start");
    if this.config.lightVisuals {
      this.PlaySFXDelayed(n"ONO_V_LongPain", 0.6);
      this.PlayVFXDelayed(n"fx_damage_high", 0.6);
      this.ApplyStatusEffect(t"BaseStatusEffect.NewPsychosisEffectLightFx");
    } else {
      this.ApplyStatusEffect(t"BaseStatusEffect.NewPsychosisEffectNormalFx");
      this.PlaySFXDelayed(n"ONO_V_LongPain", 7.5);
      this.PlayVFXDelayed(n"status_bleeding", 7.6);
    };
  }

  public func StopNewPsychosisEffect() -> Void {
    E("!!! Fx New - Psychosis stop");
    this.RemoveStatusEffect(t"BaseStatusEffect.NewPsychosisEffectLightFx");
    this.RemoveStatusEffect(t"BaseStatusEffect.NewPsychosisEffectNormalFx");
    this.StopVFX(n"status_bleeding");
  };

  public func RunNewPostPsychosisEffect() -> Void {
    this.StopNewPsychosisEffect();
    E("!!! Fx New - Post Psychosis start");
    if this.config.lightVisuals {
      this.ApplyStatusEffect(t"BaseStatusEffect.NewPostPsychosisEffectLightFx");
    } else {
      this.ApplyStatusEffect(t"BaseStatusEffect.NewPostPsychosisEffectNormalFx");
    };
  }

  public func StopNewPostPsychosisEffect() -> Void {
    E("!!! Fx New - Post Psychosis stop");
    this.RemoveStatusEffect(t"BaseStatusEffect.NewPostPsychosisEffectLightFx");
    this.RemoveStatusEffect(t"BaseStatusEffect.NewPostPsychosisEffectNormalFx");
  };

  public func ScheduleCycledSfx(delay: Float) -> Void {
    E("Sfx - Schedule cycled fx");
    this.delaySystem.CancelCallback(this.cycledSFXDelayId);
    this.cycledSFXDelayId = GetInvalidDelayID();
    this.cycledEnabled = true;
    this.cycledSFXDelayId = this.delaySystem.DelayCallback(LaunchCycledSFXCallback.Create(this), delay, true);
  }

  public func CancelCycledFx() -> Void {
    E("Sfx - Cancel cycled fx");
    this.cycledEnabled = false;
    this.delaySystem.CancelCallback(this.cycledSFXDelayId);
    this.cycledSFXDelayId = GetInvalidDelayID();
  }

  public func PlayFastTravelFx() -> Void {
    this.PlayVFXDelayed(n"fast_travel_glitch", 0.3);
  }

  public func CancelOtherFxes() -> Void {
    E("Sfx - Cancel other fxes");
    this.StopVFX(n"fx_damage_high");
    this.StopVFX(n"personal_link_glitch");
    this.StopVFX(n"hacking_glitch_low");
    this.StopVFX(n"fast_travel_glitch");
    this.StopSFX(n"ONO_V_LongPain");
    this.StopSFX(n"ui_gmpl_perk_edgerunner");
  }

  public func RefreshConfig() -> Void {
    this.config = new EdgerunningConfig();
  }

  public func OnLaunchCycledSFXCallback() -> Void {
    if !IsDefined(this.player) || !this.cycledEnabled {
      return;
    };

    E("Sfx - OnLaunchCycledSFXCallback");
    let random: Int32 = RandRange(0, ArraySize(this.cyberpsychosisSFX));
    let bundle: ref<SFXBundle> = this.cyberpsychosisSFX[random];
    this.PlaySFX(bundle.name);
    this.cycledSFXDelayId = this.delaySystem.DelayCallback(LaunchCycledSFXCallback.Create(this), bundle.nextDelay, true);
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
    ArrayPush(this.pendingFx, this.delaySystem.DelayCallback(PlaySFXCallback.Create(this.player, name), delay, true));
  }

  private func PlayVFXDelayed(name: CName, delay: Float) -> Void {
    ArrayPush(this.pendingFx, this.delaySystem.DelayCallback(PlayVFXCallback.Create(this.player, name), delay, true));
  }

  private func StopSFX(name: CName) -> Void {
    if !IsDefined(this.player) { return; };
    GameObject.StopSoundEvent(this.player, name);
    E(s"+ Stop \(name) sfx");
  }

  private func StopVFX(name: CName) -> Void {
    if !IsDefined(this.player) { return; };
    GameObjectEffectHelper.StopEffectEvent(this.player, name);
    E(s"+ Stop \(name) vfx");
  }

  private func ApplyStatusEffect(id: TweakDBID) {
    // Gameplay packages start with the logical phase in both FX profiles.
    if IsDefined(this.player) { StatusEffectHelper.ApplyStatusEffect(this.player, id); };
  }

  private func RemoveStatusEffect(id: TweakDBID) {
    if IsDefined(this.player) { StatusEffectHelper.RemoveStatusEffect(this.player, id); };
  }

  private func PopulateSfxArray() -> Void {
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ui_gmpl_perk_edgerunner", 16.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ui_gmpl_perk_edgerunner", 17.0));
  }
}

public class LaunchCycledSFXCallback extends EdgerunningEpisodeCallback {
  let helper: wref<PsychosisEffectsHelper>;

  public static func Create(helper: ref<PsychosisEffectsHelper>) -> ref<LaunchCycledSFXCallback> {
    let self: ref<LaunchCycledSFXCallback> = new LaunchCycledSFXCallback();
    self.helper = helper;
    self.BindEpisode(helper.GetPlayer());
    return self;
  }

  public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.helper) {
      this.helper.OnLaunchCycledSFXCallback();
    };
  }
}

public class PlaySFXCallback extends EdgerunningEpisodeCallback {
	public let player: wref<PlayerPuppet>;
	public let sfxName: CName;

  public static func Create(player: ref<PlayerPuppet>, sfxName: CName) -> ref<PlaySFXCallback> {
    let self: ref<PlaySFXCallback> = new PlaySFXCallback();
    self.player = player;
    self.BindEpisode(player);
    self.sfxName = sfxName;
    return self;
  }

	public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.player) {
      GameObject.PlaySoundEvent(this.player, this.sfxName);
      E(s"Run \(this.sfxName) sfx");
    };
	}
}

public class PlayVFXCallback extends EdgerunningEpisodeCallback {
	public let player: wref<PlayerPuppet>;
	public let vfxName: CName;

  public static func Create(player: ref<PlayerPuppet>, vfxName: CName) -> ref<PlayVFXCallback> {
    let self: ref<PlayVFXCallback> = new PlayVFXCallback();
    self.player = player;
    self.BindEpisode(player);
    self.vfxName = vfxName;
    return self;
  }

	public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.player) {
      GameObjectEffectHelper.StartEffectEvent(this.player, this.vfxName, false);
      E(s"Run \(this.vfxName) vfx");
    };
	}
}

public class ApplyStatusEffectCallback extends EdgerunningEpisodeCallback {
	public let player: wref<PlayerPuppet>;
  public let id: TweakDBID;

  public static func Create(player: ref<PlayerPuppet>, id: TweakDBID) -> ref<ApplyStatusEffectCallback> {
    let self: ref<ApplyStatusEffectCallback> = new ApplyStatusEffectCallback();
    self.player = player;
    self.BindEpisode(player);
    self.id = id;
    return self;
  }

	public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.player) {
      GameInstance.GetStatusEffectSystem(this.player.GetGame()).ApplyStatusEffect(this.player.GetEntityID(), this.id, this.player.GetRecordID(), this.player.GetEntityID());
      E(s"Apply \(TDBID.ToStringDEBUG(this.id)) effect to player");
    };
	}
}

public class RemoveStatusEffectCallback extends EdgerunningEpisodeCallback {
	public let player: wref<PlayerPuppet>;
  public let id: TweakDBID;

  public static func Create(player: ref<PlayerPuppet>, id: TweakDBID) -> ref<RemoveStatusEffectCallback> {
    let self: ref<RemoveStatusEffectCallback> = new RemoveStatusEffectCallback();
    self.player = player;
    self.BindEpisode(player);
    self.id = id;
    return self;
  }

	public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.player) {
      GameInstance.GetStatusEffectSystem(this.player.GetGame()).RemoveStatusEffect(this.player.GetEntityID(), this.id);
      E(s"Remove \(TDBID.ToStringDEBUG(this.id)) effect from player");
    };
  }
}
