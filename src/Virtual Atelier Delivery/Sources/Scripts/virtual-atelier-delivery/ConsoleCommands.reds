import AtelierDelivery.AtelierDropPointsSpawner

public abstract class Delivery {
  public static func Despawn(gi: GameInstance) {
    let spawner: ref<AtelierDropPointsSpawner> = AtelierDropPointsSpawner.Get(gi);
    spawner.DespawnAll();
  }
}
