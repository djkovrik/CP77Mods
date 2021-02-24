static func GetVisibilityTypeFor(quality: gamedataQuality) -> Int32 {
//  Here you can define visibility behavior for each item quality type.
//  Visibility types:
//    1 - visible through walls
//    2 - visible for line of sight (like default in-game behavior)
//    3 - visible only when scanner is active
//    4 - hidden

// --- Сonfiguration block starts here ---

  let markersVisibilityIconic = 1;      // Gold + Unique
  let markersVisibilityLegendary = 1;   // Gold
  let markersVisibilityEpic = 2;        // Purple
  let markersVisibilityRare = 3;        // Blue
  let markersVisibilityUncommon = 3;    // Green
  let markersVisibilityCommon = 4;      // White
  
// --- Сonfiguration block ends here ---

  switch quality {
    case gamedataQuality.Iconic: return markersVisibilityIconic;
    case gamedataQuality.Legendary: return markersVisibilityLegendary;
    case gamedataQuality.Epic: return markersVisibilityEpic;
    case gamedataQuality.Rare: return markersVisibilityRare;
    case gamedataQuality.Uncommon: return markersVisibilityUncommon;
    case gamedataQuality.Common: return markersVisibilityCommon;

    default: return markersVisibilityCommon;
  };
}

// -- Utils
static func ToString(quality: gamedataQuality) -> String {
  return UIItemsHelper.QualityEnumToString(quality);
}

static func IsLootQuality(quality: gamedataQuality) -> Bool {
  return Equals(quality, gamedataQuality.Common)
    || Equals(quality, gamedataQuality.Uncommon)
    || Equals(quality, gamedataQuality.Rare)
    || Equals(quality, gamedataQuality.Epic)
    || Equals(quality, gamedataQuality.Legendary)
    || Equals(quality, gamedataQuality.Iconic);
}

static func IsLootMarker(data: SDeviceMappinData) -> Bool {
  return IsLootQuality(data.visualStateData.m_quality) 
    && (Equals(data.gameplayRole, EGameplayRole.Loot) || Equals(data.gameplayRole, EGameplayRole.NPC));
}

static func ShouldShowThroughWalls(quality: gamedataQuality) -> Bool {
  return Equals(GetVisibilityTypeFor(quality), 1);
}

static func ShouldShowLineOfSight(quality: gamedataQuality) -> Bool {
  return Equals(GetVisibilityTypeFor(quality), 2);
}

static func ShouldShowIfScannerActive(quality: gamedataQuality) -> Bool {
  return Equals(GetVisibilityTypeFor(quality), 3);
}

static func ShouldHide(quality: gamedataQuality) -> Bool {
  return Equals(GetVisibilityTypeFor(quality), 4);
}

// -- Adds
@addMethod(HUDManager)
public func IsScannerActive() -> Bool {
  return Equals(this.m_activeMode, ActiveMode.FOCUS);
}

@addField(GameplayRoleComponent)
let m_hudManager: ref<HUDManager>;

@addMethod(GameplayRoleComponent)
public func IsScannerActive() -> Bool {
  return this.m_hudManager.IsScannerActive();
}

@addMethod(GameplayRoleComponent)
func EvaluateVisibilities() -> Void {
  let i: Int32;
  let variant: gamedataMappinVariant;
  let quality: gamedataQuality;
  let isLootMarker: Bool;
  let isScannerActive: Bool;
  let shouldShowLineOfSight: Bool;
  let shouldShowIfScannerActive: Bool;
  let shouldHide: Bool;

  isScannerActive = this.IsScannerActive();

  i = 0;
  while i < ArraySize(this.m_mappins) {
    if NotEquals(this.m_mappins[i].gameplayRole, EGameplayRole.UnAssigned) {
      isLootMarker = IsLootMarker(this.m_mappins[i]);

      if isLootMarker {
        quality = this.m_mappins[i].visualStateData.m_quality;
        shouldShowLineOfSight = ShouldShowLineOfSight(quality);
        shouldShowIfScannerActive = ShouldShowIfScannerActive(quality);
        shouldHide = ShouldHide(quality);

        if shouldHide {
          this.ToggleMappin(i, false);
        } else {
          if shouldShowIfScannerActive {
            this.ToggleMappin(i, isScannerActive);
          } else {
            if shouldShowLineOfSight {
              this.ToggleMappin(i, true);
            };
          };
        };
      };
    };
    i += 1;
  };
}

// -- Overrides
@replaceMethod(GameplayRoleComponent)
protected final func OnGameAttach() -> Void {
  this.m_currentGameplayRole = this.m_gameplayRole;
  this.DeterminGamplayRole();
  this.InitializeQuickHackIndicator();
  this.InitializePhoneCallIndicator();
  this.m_hudManager = (GameInstance.GetScriptableSystemsContainer(this.GetOwner().GetGame()).Get(n"HUDManager") as HUDManager);
}

@replaceMethod(GameplayRoleComponent)
protected cb func OnHUDInstruction(evt: ref<HUDInstruction>) -> Bool {
  if Equals(evt.braindanceInstructions.GetState(), InstanceState.ON) {
    if this.GetOwner().IsBraindanceBlocked() || this.GetOwner().IsPhotoModeBlocked() {
      this.m_isHighlightedInFocusMode = false;
      this.HideRoleMappins();
      return false;
    };
  };
  this.m_isForcedVisibleThroughWalls = evt.iconsInstruction.isForcedVisibleThroughWalls;
  if Equals(evt.iconsInstruction.GetState(), InstanceState.ON) {
    this.m_isHighlightedInFocusMode = true;
    this.ShowRoleMappins();
  } else {
    if evt.highlightInstructions.WasProcessed() {
      this.m_isHighlightedInFocusMode = false;
      this.HideRoleMappins();
    };
  };

  this.EvaluateVisibilities();
}

@replaceMethod(GameplayRoleComponent)
private final func CreateRoleMappinData(data: SDeviceMappinData) -> ref<GameplayRoleMappinData> {
  let roleMappinData: ref<GameplayRoleMappinData>;
  let quality: gamedataQuality;
  quality = this.GetOwner().GetLootQuality();
  roleMappinData = new GameplayRoleMappinData();
  roleMappinData.m_mappinVisualState = this.GetOwner().DeterminGameplayRoleMappinVisuaState(data);
  roleMappinData.m_isTagged = this.GetOwner().IsTaggedinFocusMode();
  roleMappinData.m_isQuest = this.GetOwner().IsQuest() || this.GetOwner().IsAnyClueEnabled() && !this.GetOwner().IsClueInspected();
  roleMappinData.m_visibleThroughWalls = this.m_isForcedVisibleThroughWalls || this.GetOwner().IsObjectRevealed() || this.IsCurrentTarget() || ShouldShowThroughWalls(quality);
  roleMappinData.m_range = this.GetOwner().DeterminGameplayRoleMappinRange(data);
  roleMappinData.m_isCurrentTarget = this.IsCurrentTarget();
  roleMappinData.m_gameplayRole = this.m_currentGameplayRole;
  roleMappinData.m_braindanceLayer = this.GetOwner().GetBraindanceLayer();
  roleMappinData.m_quality = quality;
  roleMappinData.m_isIconic = this.GetOwner().GetIsIconic();
  roleMappinData.m_hasOffscreenArrow = this.HasOffscreenArrow();
  roleMappinData.m_isScanningCluesBlocked = this.GetOwner().IsAnyClueEnabled() && this.GetOwner().IsScaningCluesBlocked();
  roleMappinData.m_textureID = this.GetIconIdForMappinVariant(data.mappinVariant);
  return roleMappinData;
}
