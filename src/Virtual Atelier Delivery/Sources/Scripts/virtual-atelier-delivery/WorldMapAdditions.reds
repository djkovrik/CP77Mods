module AtelierDelivery

@addField(MapMenuUserData)
public let deliveryPoint: AtelierDeliveryDropPoint;

@addField(WorldMapMenuGameController)
public let spawner: wref<AtelierDropPointsSpawner>;

@addField(WorldMapTooltipBaseController)
public let isCustomMappin: Bool;

@addField(WorldMapTooltipBaseController)
public let previewImageInfo: ref<DropPointImageInfo>;

@addField(WorldMapTooltipController)
public let dropPointImageContainer: wref<inkCompoundWidget>;

@addMethod(WorldMapTooltipContainer)
public final func SetIsCustomMappin(custom: Bool, imageInfo: ref<DropPointImageInfo>) -> Void {
  this.m_defaultTooltipController.SetIsCustomMappin(custom, imageInfo);
}

@addMethod(WorldMapTooltipBaseController)
public final func SetIsCustomMappin(custom: Bool, imageInfo: ref<DropPointImageInfo>) -> Void {
  this.isCustomMappin = custom;
  this.previewImageInfo = imageInfo;
}

@wrapMethod(WorldMapMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.spawner = AtelierDropPointsSpawner.Get(this.m_player.GetGame());
}

// Save spawned mappins
@wrapMethod(DropPointSystem)
private final func RegisterDropPointMappin(data: ref<DropPointMappinRegistrationData>) -> Void {
  wrappedMethod(data);

  let spawner: ref<AtelierDropPointsSpawner> = AtelierDropPointsSpawner.Get(this.GetGameInstance());
  let entityId: EntityID = data.GetOwnerID();
  let mappinData: ref<DropPointMappinRegistrationData> = this.GetMappinData(entityId);
  let mappinId: NewMappinID;
  if IsDefined(mappinData) {
    mappinId = mappinData.GetMappinID();
    if NotEquals(mappinId.value, Cast<Uint64>(0)) && spawner.IsCustomDropPoint(entityId) {
      spawner.SaveSpawnedMappinId(entityId, mappinId);
    };
  };
}

// Show VA tooltip
@wrapMethod(WorldMapTooltipController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"tooltip/tooltipFlex/mainLayout/content/mainContent") as inkCompoundWidget;
  let dropPointPreview: ref<inkCompoundWidget> = LayoutsBuilder.BuildDropPointPreviewContainer();
  dropPointPreview.SetAffectsLayoutWhenHidden(false);
  dropPointPreview.SetVisible(false);
  dropPointPreview.Reparent(container);
  this.dropPointImageContainer = dropPointPreview;
}

@wrapMethod(WorldMapTooltipController)
protected final func Reset() -> Void {
  wrappedMethod();
  this.dropPointImageContainer.SetVisible(false);
}

@wrapMethod(WorldMapMenuGameController)
private final func UpdateTooltip(tooltipType: WorldMapTooltipType, controller: wref<BaseWorldMapMappinController>) -> Void {
  let mappin: ref<RuntimeMappin> = controller.GetMappin() as RuntimeMappin;
  let mappinId: NewMappinID = mappin.GetNewMappinID();
  let isCustomMappin: Bool = this.spawner.IsCustomDropPoint(mappinId);
  let dropPointInstance: ref<AtelierDropPointInstance>;
  let imageInfo: ref<DropPointImageInfo>;
  if isCustomMappin {
    dropPointInstance = this.spawner.FindInstanceByMappinId(mappinId);
    if IsDefined(dropPointInstance) {
      imageInfo = DropPointImageInfo.Create(dropPointInstance.inkAtlas, dropPointInstance.uniqueTag);
    };
  };
  this.m_tooltipController.SetIsCustomMappin(isCustomMappin, imageInfo);
  wrappedMethod(tooltipType, controller);
}

@wrapMethod(WorldMapTooltipController)
public func SetData(const data: script_ref<WorldMapTooltipData>, menu: ref<WorldMapMenuGameController>) -> Void {
  wrappedMethod(data, menu);
  let deliveryPoint: AtelierDeliveryDropPoint;
  let deliveryPointLocKey: String;
  this.dropPointImageContainer.SetVisible(this.isCustomMappin);
  let image: ref<inkImage> = this.dropPointImageContainer.GetWidgetByPathName(n"image") as inkImage;
  if this.isCustomMappin {
    deliveryPoint = AtelierDeliveryUtils.GetDropPointByTag(this.previewImageInfo.texturePart);
    deliveryPointLocKey = AtelierDeliveryUtils.GetDeliveryPointLocKey(deliveryPoint);
    inkTextRef.SetText(this.m_titleText, GetLocalizedTextByKey(n"Mod-VAD-Marker"));
    inkTextRef.SetText(this.m_descText, GetLocalizedText(deliveryPointLocKey));
    inkWidgetRef.Get(this.m_descText).BindProperty(n"tintColor", n"MainColors.Blue");
    inkTextRef.SetText(this.m_additionalDescText, GetLocalizedTextByKey(n"Mod-VAD-Marker-Description"));
    inkWidgetRef.SetVisible(this.m_additionalDescText, true);
    inkWidgetRef.SetOpacity(this.m_additionalDescText, 0.4);
    image.SetAtlasResource(this.previewImageInfo.atlas);
    image.SetTexturePart(this.previewImageInfo.texturePart);
  };
}

// Update icons
@addMethod(BaseMappinBaseController)
protected final func IsCustomMappinVA() -> Bool {
  let spawner: ref<AtelierDropPointsSpawner> = AtelierDropPointsSpawner.Get(GetGameInstance());
  let entityId: EntityID = this.GetMappin().GetEntityID();
  let mappinId: NewMappinID = this.GetMappin().GetNewMappinID();
  let isCustomMappin: Bool = spawner.IsCustomDropPoint(entityId) || spawner.IsCustomDropPoint(mappinId);
  return isCustomMappin;
}

@addMethod(BaseMappinBaseController)
protected final func UpdateIconVA(opt forMinimap: Bool) -> Void {
  let texturePart: CName = n"icon";
  if forMinimap {
    texturePart = n"mappin";
  };

  if this.IsCustomMappinVA() {
    inkImageRef.SetAtlasResource(this.iconWidget, r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_pins.inkatlas");
    inkImageRef.SetTexturePart(this.iconWidget, texturePart);
  };
}

@wrapMethod(BaseWorldMapMappinController)
protected func UpdateIcon() -> Void {
  wrappedMethod();
  if Equals(this.GetMappin().GetVariant(), gamedataMappinVariant.ServicePointDropPointVariant) {
    this.UpdateIconVA();
  };
}

@wrapMethod(QuestMappinController)
protected func UpdateIcon() -> Void {
  wrappedMethod();
  if Equals(this.GetMappin().GetVariant(), gamedataMappinVariant.ServicePointDropPointVariant) {
    this.UpdateIconVA();
  };
}

@wrapMethod(MinimapPOIMappinController)
protected final func UpdateIcon() -> Void {
  wrappedMethod();
  if Equals(this.GetMappin().GetVariant(), gamedataMappinVariant.ServicePointDropPointVariant) {
    this.UpdateIconVA(true);
  };
}

// Move to custom mappin
@wrapMethod(WorldMapMenuGameController)
protected cb func OnMapNavigationDelay(evt: ref<MapNavigationDelay>) -> Bool {
  if NotEquals(this.m_initMappinFocus.deliveryPoint, AtelierDeliveryDropPoint.None) {
    this.MoveToCustomDeliveryPoint(this.m_initMappinFocus.deliveryPoint);
    return true;
  };

  wrappedMethod(evt);
}

@addMethod(WorldMapMenuGameController)
private final func MoveToCustomDeliveryPoint(target: AtelierDeliveryDropPoint) -> Void {
  let target: ref<AtelierDropPointInstance> = this.FindDropPointInstance(target);
  let direction: Vector3;
  if IsDefined(target) {
    direction = Cast<Vector3>(target.position);
    this.GetEntityPreview().MoveTo(direction);
  };
}

@addMethod(WorldMapMenuGameController)
private final func FindDropPointInstance(target: AtelierDeliveryDropPoint) -> ref<AtelierDropPointInstance> {
  let dropPoints: array<ref<AtelierDropPointInstance>> = this.spawner.GetAvailableDropPoints();
  for dropPoint in dropPoints {
    if Equals(dropPoint.type, target) {
      return dropPoint;
    };
  };

  return null;
}
