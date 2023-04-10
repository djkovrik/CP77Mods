import MutedMarkersConfig.MiniMapConfig

@addField(UI_ScannerDef)
let MutedMarkerEnabled: BlackboardID_Bool;

@addField(scannerGameController)
let hideCallbackId: DelayID;

@addField(GameplayRoleComponent)
let isScannerActive: Bool;

@addField(GameplayRoleComponent)
let scannerStateBlackboard: ref<IBlackboard>;

@addField(GameplayRoleComponent)
let scannerStateCallback: ref<CallbackHandle>;

@addField(GameplayRoleComponent)
let checker: ref<MutedMarkersVisibilityChecker>;

@addField(GameplayRoleMappinData)
let isMMShard: Bool;
