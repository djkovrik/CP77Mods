module AtelierDelivery

public class DropPointsSpawnerCallbackRecovery extends DelayCallback {
  private let system: wref<AtelierDropPointsSpawner>;
  private let generation: Uint32;

  public static func Create(system: ref<AtelierDropPointsSpawner>, generation: Uint32) -> ref<DropPointsSpawnerCallbackRecovery> {
    let callback: ref<DropPointsSpawnerCallbackRecovery> = new DropPointsSpawnerCallbackRecovery();
    callback.system = system;
    callback.generation = generation;
    return callback;
  }

  public func Call() -> Void {
    if IsDefined(this.system) {
      this.system.HandleRecovery(this.generation);
    };
  }
}
