import Edgerunning.Common.E

public class UpdateHumanityCounterEvent extends Event {
  public let current: Int32;
  public let total: Int32;
  public let color: CName;
}

public class SFXBundle {
  public let name: CName;
  public let duration: Float;

  public static func Create(name: CName, duration: Float) -> ref<SFXBundle> {
    let bundle: ref<SFXBundle> = new SFXBundle();
    bundle.name = name;
    bundle.duration = duration;
    return bundle;
  }
}

public class PlaySFXCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
	public let sfxName: CName;

	public func Call() -> Void {
    GameObject.PlaySoundEvent(this.player, this.sfxName);
    E(s"Run \(this.sfxName) sfx");
	}
}

public class PlayVFXCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
	public let vfxName: CName;

	public func Call() -> Void {
    GameObjectEffectHelper.StartEffectEvent(this.player, this.vfxName, false);
    E(s"Run \(this.vfxName) vfx");
	}
}

public class ApplyStatusEffectCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
  public let id: TweakDBID;

	public func Call() -> Void {
    GameInstance.GetStatusEffectSystem(this.player.GetGame()).ApplyStatusEffect(this.player.GetEntityID(), this.id, this.player.GetRecordID(), this.player.GetEntityID());
    E(s"Apply \(TDBID.ToStringDEBUG(this.id)) effect to player");
	}
}

public class RemoveStatusEffectCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
  public let id: TweakDBID;

	public func Call() -> Void {
    GameInstance.GetStatusEffectSystem(this.player.GetGame()).RemoveStatusEffect(this.player.GetEntityID(), this.id);
    E(s"Remove \(TDBID.ToStringDEBUG(this.id)) effect from player");
  }
}

@addField(PlayerStateMachineDef)
public let HumanityDamage: BlackboardID_Int;
