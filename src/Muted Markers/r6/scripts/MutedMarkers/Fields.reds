@addField(UI_ScannerDef)
public let MutedMarkerEnabled: BlackboardID_Bool;

@addField(scannerGameController)
public let hideCallbackId: DelayID;

@addField(GameplayRoleComponent)
public let isScannerActive: Bool;

@addField(GameplayRoleComponent)
public let scannerStateBlackboard: ref<IBlackboard>;

@addField(GameplayRoleComponent)
public let scannerStateCallback: ref<CallbackHandle>;

@addField(GameplayRoleMappinData)
public let isMMShard: Bool;