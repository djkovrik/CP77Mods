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

public class CustomBarHoverOverEvent extends Event {
  public let humanityCurrent: Int32;
  public let humanityTotal: Int32;
  public let humanityAdditionalDesc: String;
}

public class HumanityThresholdHoverOverEvent extends Event {
  public let humanityThreshold: Int32;
  public let humanityTotal: Int32;
  public let chance: Int32;
}

public class HumanityBarUserData extends inkUserData {
  public let danger: Bool;

  public static func Create(danger: Bool) -> ref<HumanityBarUserData> {
    let self: ref<HumanityBarUserData> = new HumanityBarUserData();
    self.danger = danger;
    return self;
  }
}

public class CustomBarHoverOutEvent extends Event {}

public enum WannabeHeatLevel {
  One = 0,
  Two = 1,
  Three = 2,
  Four = 3,
  Five = 4,
  MaxTac = 5,
}

public enum HumanityRestoringAction {
  Sleep = 0,
  Shower = 1,
  Pet = 2,
  Donation = 3,
  Apartment = 4,
  Lover = 5,
  Social = 6,
  Unknown = 10,
}
