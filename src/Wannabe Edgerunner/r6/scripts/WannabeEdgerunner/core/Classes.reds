public class UpdateHumanityCounterEvent extends Event {
  public let current: Int32;
  public let total: Int32;
  public let color: CName;
}

public class SFXBundle {
  public let name: CName;
  public let nextDelay: Float;

  public static func Create(name: CName, nextDelay: Float) -> ref<SFXBundle> {
    let bundle: ref<SFXBundle> = new SFXBundle();
    bundle.name = name;
    bundle.nextDelay = nextDelay;
    return bundle;
  }
}

public class CyberwareMenuBarAppeared extends Event {}
