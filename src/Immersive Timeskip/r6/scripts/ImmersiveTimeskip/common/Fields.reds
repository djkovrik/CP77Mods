import ImmersiveTimeskip.Hotkey.CustomTimeSkipListener

@addField(inkGameController)
public let itsDefaultOpacity: Float;

@addField(GameObject) 
public let itsTimeskipActive: Bool;

@addField(PlayerPuppet)
public let isHoldingTimeSkipButton: Bool;

@addField(PlayerPuppet)
private let itsTimeskipListener: ref<CustomTimeSkipListener>;

@addField(PlayerPuppet)
private let itsTimeSystem: ref<TimeSystem>;

@addField(PlayerPuppet) 
public let itsTimeskipPopupToken: ref<inkGameNotificationToken>;

@addField(TimeskipGameController)
private let itsInitialDiff: Float;

@addField(TimeskipGameController)
private let itsInitialTimestamp: Float;

@addField(TimeskipGameController)
private let itsSecondsPerDegree: Float;

@addField(HubTimeSkipController)
private let itsMenuEventDispatcher: wref<inkMenuEventDispatcher>;

@addField(HubTimeSkipController)
private let itsPlayerInstance: wref<PlayerPuppet>;
