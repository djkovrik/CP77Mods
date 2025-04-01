module AtelierDelivery

public class DropPointsSpawnerCallbackInitial extends DelayCallback {
  private let system: wref<AtelierDropPointsSpawner>;

  public static func Create(system: ref<AtelierDropPointsSpawner>) -> ref<DropPointsSpawnerCallbackInitial> {
    let instance: ref<DropPointsSpawnerCallbackInitial> = new DropPointsSpawnerCallbackInitial();
    instance.system = system;
    return instance;
  }

	public func Call() -> Void {
    this.system.HandleInitialNotification();
	}
}
