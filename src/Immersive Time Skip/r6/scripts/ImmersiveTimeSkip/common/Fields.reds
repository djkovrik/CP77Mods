import ImmersiveTimeSkip.Hotkey.CustomTimeSkipListener

@addField(inkGameController)
public let itsDefaultOpacity: Float;

@addField(GameObject) 
public let itsTimeSkipActive: Bool;

@addField(PlayerPuppet)
private let itsTimeSkipListener: ref<CustomTimeSkipListener>;

@addField(PlayerPuppet)
private let itsTimeSystem: ref<TimeSystem>;

@addField(PlayerPuppet) 
public let itsTimeSkipPopupToken: ref<inkGameNotificationToken>;

@addField(TimeskipGameController)
private let itsInitialDiff: Float;

@addField(TimeskipGameController)
private let itsInitialTimestamp: Float;

@addField(TimeskipGameController)
private let itsSecondsPerDegree: Float;
