enum MarkerVisibility { ThroughWalls = 0, LineOfSight = 1, Scanner = 2, Hidden = 3, Default = 4 }

// Visibility types:
//   * MarkerVisibility.ThroughWalls - visible through walls
//   * MarkerVisibility.LineOfSight - visible when V sees it (very similar to default in-game behavior)
//   * MarkerVisibility.Scanner - visible only when scanner is active 
//   * MarkerVisibility.Hidden - not visible at all
//   * MarkerVisibility.Default - means do not change default game behavior, this variant was added 
//     just for scripting convenience so in most cases you probably want to use LineOfSight

// -- CONFIG SECTION STARTS HERE --
class LootConfig {
  // Visibility for Iconic items
  public static func Iconic() -> MarkerVisibility = MarkerVisibility.ThroughWalls
  // Visibility for Legendary items (gold)
  public static func Legendary() -> MarkerVisibility = MarkerVisibility.ThroughWalls
  // Visibility for Epic items (purple)
  public static func Epic() -> MarkerVisibility = MarkerVisibility.LineOfSight
  // Visibility for Rate items (blue)
  public static func Rare() -> MarkerVisibility = MarkerVisibility.Scanner
  // Visibility for Uncommon items (green)
  public static func Uncommon() -> MarkerVisibility = MarkerVisibility.Scanner
  // Visibility for Common items (white)
  public static func Common() -> MarkerVisibility = MarkerVisibility.Hidden
  // Visibility for Shards
  public static func Shards() -> MarkerVisibility = MarkerVisibility.LineOfSight
}

class WorldConfig {
  // Replace false with true if you want to hide icons for access points
  public static func HideAccessPoints() -> Bool = false
  // Replace false with true if you want to hide icons for containers where you can hide bodies
  public static func HideBodyContainers() -> Bool = false
  // Replace false with true if you want to hide icons for cameras
  public static func HideCameras() -> Bool = false
  // Replace false with true if you want to hide icons for doors
  public static func HideDoors() -> Bool = false
  // Replace false with true if you want to hide icons for distraction objects
  public static func HideDistractions() -> Bool = false
  // Replace false with true if you want to hide icons for explosive objects
  public static func HideExplosives() -> Bool = false
  // Replace false with true if you want to hide icons for misc network devices (computers, smart screens etc.)
  public static func HideNetworking() -> Bool = false
}
// -- CONFIG SECTION ENDS HERE --

public static func GetVisibilityTypeFor(data: SDeviceMappinData) -> MarkerVisibility {
  let isShard: Bool = Equals(data.visualStateData.m_textureID, t"MappinIcons.ShardMappin");
  let isIconic: Bool = data.visualStateData.m_isIconic;
  let role: EGameplayRole = data.gameplayRole;
  let quality: gamedataQuality = data.visualStateData.m_quality;

  // Shard check
  if isShard {
    return LootConfig.Shards();
  }

  // Iconic check
  if isIconic {
    return LootConfig.Iconic();
  }

  // Access point check
  if WorldConfig.HideAccessPoints() && Equals(role, EGameplayRole.ControlNetwork) {
    return MarkerVisibility.Hidden;
  }

  // Bodies check
  if WorldConfig.HideBodyContainers() && Equals(role, EGameplayRole.HideBody) {
    return MarkerVisibility.Hidden;
  }

  // Camera check
  if WorldConfig.HideCameras() && Equals(role, EGameplayRole.Alarm) {
    return MarkerVisibility.Hidden;
  }

  // Door check
  if WorldConfig.HideDoors() && Equals(role, EGameplayRole.OpenPath) {
    return MarkerVisibility.Hidden;
  }

  // Distraction check
  if WorldConfig.HideDistractions() && (Equals(role, EGameplayRole.Distract) || Equals(role, EGameplayRole.Fall)) {
    return MarkerVisibility.Hidden;
  }

  // Explosive check
  if WorldConfig.HideExplosives() && (Equals(role, EGameplayRole.ExplodeLethal) || Equals(role, EGameplayRole.ExplodeNoneLethal)) {
    return MarkerVisibility.Hidden;
  }

  // Networking check
  if WorldConfig.HideNetworking() && (Equals(role, EGameplayRole.ControlSelf) || Equals(role, EGameplayRole.GrantInformation)) {
    return MarkerVisibility.Hidden;
  }

  // Quality check
  if Equals(data.visualStateData.m_textureID, t"MappinIcons.LootMappin") {
    switch(quality) {
      case gamedataQuality.Iconic: return LootConfig.Iconic();
      case gamedataQuality.Legendary: return LootConfig.Legendary();
      case gamedataQuality.Epic: return LootConfig.Epic();
      case gamedataQuality.Rare: return LootConfig.Rare();
      case gamedataQuality.Uncommon: return LootConfig.Uncommon();
      case gamedataQuality.Common: return LootConfig.Common();

      default: return MarkerVisibility.Default;
    };
  };

  return MarkerVisibility.Default;
}

// -- Add
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
  let isScannerActive: Bool = this.IsScannerActive();
  let i: Int32 = 0;
  let visibility: MarkerVisibility;

  while i < ArraySize(this.m_mappins) {
    if NotEquals(this.m_mappins[i].gameplayRole, IntEnum(0)) || NotEquals(this.m_mappins[i].gameplayRole, IntEnum(1)) {
      visibility = GetVisibilityTypeFor(this.m_mappins[i]);

      switch(visibility) {
        case MarkerVisibility.ThroughWalls:
          MarkersLog("> ThroughWalls for: " + ToStr(this.m_mappins[i]));
          this.ToggleMappin(i, true);
          break;
        case MarkerVisibility.LineOfSight:
          MarkersLog("> LineOfSight for: " + ToStr(this.m_mappins[i]));
          this.ToggleMappin(i, true);
          break;
        case MarkerVisibility.Scanner:
          MarkersLog("> Scanner for: " + ToStr(this.m_mappins[i]));
          this.ToggleMappin(i, isScannerActive);
          break;
        case MarkerVisibility.Hidden:
          MarkersLog("> Hidden for: " + ToStr(this.m_mappins[i]));
          this.ToggleMappin(i, false);
          break;
        case MarkerVisibility.Default:
          MarkersLog("> Default for: " + ToStr(this.m_mappins[i]));
          // do nothing
          break;
      };
    };
    i += 1;
  };
}

// -- Override
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
  let roleMappinData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
  roleMappinData.m_mappinVisualState = this.GetOwner().DeterminGameplayRoleMappinVisuaState(data);
  roleMappinData.m_isTagged = this.GetOwner().IsTaggedinFocusMode();
  roleMappinData.m_isQuest = this.GetOwner().IsQuest() || this.GetOwner().IsAnyClueEnabled() && !this.GetOwner().IsClueInspected();
  // roleMappinData.m_visibleThroughWalls = this.m_isForcedVisibleThroughWalls || this.GetOwner().IsObjectRevealed() || this.IsCurrentTarget();
  roleMappinData.m_visibleThroughWalls = this.m_isForcedVisibleThroughWalls || this.GetOwner().IsObjectRevealed() || this.IsCurrentTarget() || Equals(GetVisibilityTypeFor(data), MarkerVisibility.ThroughWalls);
  roleMappinData.m_range = this.GetOwner().DeterminGameplayRoleMappinRange(data);
  roleMappinData.m_isCurrentTarget = this.IsCurrentTarget();
  roleMappinData.m_gameplayRole = this.m_currentGameplayRole;
  roleMappinData.m_braindanceLayer = this.GetOwner().GetBraindanceLayer();
  roleMappinData.m_quality = this.GetOwner().GetLootQuality();
  roleMappinData.m_isIconic = this.GetOwner().GetIsIconic();
  roleMappinData.m_hasOffscreenArrow = this.HasOffscreenArrow();
  roleMappinData.m_isScanningCluesBlocked = this.GetOwner().IsAnyClueEnabled() && this.GetOwner().IsScaningCluesBlocked();
  roleMappinData.m_textureID = this.GetIconIdForMappinVariant(data.mappinVariant);
  let showOnMiniMap: Bool;
  if roleMappinData.m_isQuest && roleMappinData.m_textureID != t"MappinIcons.ShardMappin" || roleMappinData.m_isTagged {
    showOnMiniMap = true;
  } else {
    if NotEquals(data.mappinVariant, gamedataMappinVariant.LootVariant) && (roleMappinData.m_isCurrentTarget || roleMappinData.m_visibleThroughWalls) {
      showOnMiniMap = true;
    } else {
      showOnMiniMap = false;
    };
  };
  roleMappinData.m_showOnMiniMap = showOnMiniMap;
  return roleMappinData;
}

// UTILS FOR DEBUGGING

static func RoleToStr(role: EGameplayRole) -> String {
  switch(role) {
    case EGameplayRole.UnAssigned: return "UnAssigned";
    case EGameplayRole.Alarm: return "Alarm";
    case EGameplayRole.ControlNetwork: return "ControlNetwork";
    case EGameplayRole.ControlOtherDevice: return "ControlOtherDevice";
    case EGameplayRole.ControlSelf: return "ControlSelf";
    case EGameplayRole.CutPower: return "CutPower";
    case EGameplayRole.Distract: return "Distract";
    case EGameplayRole.DropPoint: return "DropPoint";
    case EGameplayRole.ExplodeLethal: return "ExplodeLethal";
    case EGameplayRole.ExplodeNoneLethal: return "ExplodeNoneLethal";
    case EGameplayRole.Fall: return "Fall";
    case EGameplayRole.FastTravel: return "FastTravel";
    case EGameplayRole.GrantInformation: return "GrantInformation";
    case EGameplayRole.HazardWarning: return "HazardWarning";
    case EGameplayRole.HideBody: return "HideBody";
    case EGameplayRole.Loot: return "Loot";
    case EGameplayRole.OpenPath: return "OpenPath";
    case EGameplayRole.ClearPath: return "ClearPath";
    case EGameplayRole.Push: return "Push";
    case EGameplayRole.ServicePoint: return "ServicePoint";
    case EGameplayRole.Shoot: return "Shoot";
    case EGameplayRole.SpreadGas: return "SpreadGas";
    case EGameplayRole.StoreItems: return "StoreItems";
    case EGameplayRole.GenericRole: return "GenericRole";
    case EGameplayRole.ClearPathAd: return "ClearPathAd";
    case EGameplayRole.DistractVendingMachine: return "DistractVendingMachine";
    case EGameplayRole.NPC: return "NPC";
    case EGameplayRole.Clue: return "Clue";

    default: return "Undefined";
  }
}

static func ToStr(data: SDeviceMappinData) -> String {
  return "role: " + RoleToStr(data.visualStateData.m_gameplayRole) 
    + ", quality: " + UIItemsHelper.QualityEnumToString(data.visualStateData.m_quality)
    + ", textureId: " + TDBID.ToStringDEBUG(data.visualStateData.m_textureID);
}

static func MarkersLog(str: String) -> Void {
  // Log(str);
}