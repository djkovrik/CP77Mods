@addField(scannerGameController)
public let mutedMarkersCallback: DelayID;

@addField(UI_ScannerDef)
public let IsEnabled_mm: BlackboardID_Bool;

@addField(GameplayRoleMappinData)
public let isShard_mm: Bool;

@addField(GameplayRoleComponent)
public let isScannerActive_mm: Bool;

@addField(GameplayRoleComponent)
public let scannerBlackboard_mm: ref<IBlackboard>;

@addField(GameplayRoleComponent)
public let scannerCallback_mm: ref<CallbackHandle>;