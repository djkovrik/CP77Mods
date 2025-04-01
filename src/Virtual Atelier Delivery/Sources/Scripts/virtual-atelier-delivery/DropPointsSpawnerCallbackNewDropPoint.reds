module AtelierDelivery

public class DropPointsSpawnerCallbackNewDropPoint extends DelayCallback {
  private let system: wref<AtelierDropPointsSpawner>;

  public static func Create(system: ref<AtelierDropPointsSpawner>) -> ref<DropPointsSpawnerCallbackNewDropPoint> {
    let instance: ref<DropPointsSpawnerCallbackNewDropPoint> = new DropPointsSpawnerCallbackNewDropPoint();
    instance.system = system;
    return instance;
  }

	public func Call() -> Void {
    this.system.HandleNewDropPointsNotification();
	}
}
