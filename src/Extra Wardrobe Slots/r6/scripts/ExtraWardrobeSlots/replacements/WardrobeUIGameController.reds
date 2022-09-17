@addField(WardrobeUIGameController)
private let m_finalEquippedSetExtra: gameWardrobeClothingSetIndexExtra;

@addField(WardrobeUIGameController)
private let m_setsExtra: array<ref<ClothingSetExtra>>;

@replaceMethod(WardrobeUIGameController)
protected cb func OnInitialize() -> Bool {
  let currentEquipped: gameWardrobeClothingSetIndexExtra;
  let selectedSetIndex: Int32;
  this.m_equipmentBlackboard = GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_Equipment);
  if IsDefined(this.m_equipmentBlackboard) {
    this.m_equipmentInProgressCallback = this.m_equipmentBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_Equipment.EquipmentInProgress, this, n"OnEquipmentInProgress");
  };
  this.m_buttonHintsController = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsManagerRef), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
  this.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
  this.m_tooltipsManager = inkWidgetRef.GetControllerByType(this.m_tooltipsManagerRef, n"gameuiTooltipsManager") as gameuiTooltipsManager;
  this.m_tooltipsManager.Setup(ETooltipsStyle.Menus);
  this.m_setEditorController = inkWidgetRef.GetController(this.m_setEditorWidget) as WardrobeSetEditorUIController;
  this.m_setEditorController.Initialize(this.m_player, this.m_tooltipsManager, this.m_buttonHintsController, this);
  this.m_equipmentSystem = GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
  this.InitSetPanel();
  currentEquipped = EquipmentSystem.GetActiveWardrobeSetIDExtra(this.m_player);
  selectedSetIndex = Equals(currentEquipped, gameWardrobeClothingSetIndexExtra.INVALID) ? 0 : WardrobeSystemExtra.WardrobeClothingSetIndexToNumber(currentEquipped);
  this.SelectSlot(this.m_setControllers[selectedSetIndex]);
  this.PlayIntroAnimation();

  // Move text label
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let wardrobeLabel: ref<inkText> = root.GetWidget(n"setEditorScreenContainer/setContainer/setPickerPanel/setsLabel") as inkText;
  wardrobeLabel.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
}

@replaceMethod(WardrobeUIGameController)
private final func InitSetPanel() -> Void {
  let slotsPerColumn: Int32 = 7;
  let slotsTotal: Int32 = slotsPerColumn * 2;
  let controller: wref<ClothingSetController>;
  let controllerIndex: Int32;
  let currentEquipped: gameWardrobeClothingSetIndexExtra;
  let i: Int32;
  let widget: wref<inkWidget>;
  this.m_setsExtra = WardrobeSystemExtra.GetInstance(this.m_player.GetGame()).GetClothingSets();
  let setAmount: Int32 = ArraySize(this.m_setsExtra);
  ArrayClear(this.m_setControllers);
  inkCompoundRef.RemoveAllChildren(this.m_setGridWidget);
  currentEquipped = EquipmentSystem.GetActiveWardrobeSetIDExtra(this.m_player);
  this.m_finalEquippedSetExtra = currentEquipped;
  i = 0;
  // this.m_maxSetsAmount
  while i < slotsTotal {
    widget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_setGridWidget), n"wardrobeOutfitSlot");
    controller = widget.GetController() as ClothingSetController;
    controller.RegisterToCallback(n"OnRelease", this, n"OnSetClick");
    controller.RegisterToCallback(n"OnHoverOver", this, n"OnSetHoverOver");
    controller.RegisterToCallback(n"OnHoverOut", this, n"OnSetHoverOut");
    controller.UpdateNumberingExtra(i);
    controller.SetEquipped(Equals(controller.GetClothingSetExtra().setID, currentEquipped));
    ArrayPush(this.m_setControllers, controller);
    i += 1;
  };
  i = 0;
  while i < setAmount {
    controllerIndex = WardrobeSystemExtra.WardrobeClothingSetIndexToNumber(this.m_setsExtra[i].setID);
    this.m_setControllers[controllerIndex].SetClothingSetExtra(this.m_setsExtra[i], true);
    i += 1;
  };

  // Rearrange slots
  let slot: ref<inkWidget>;
  i = 0;
  while i < slotsPerColumn {
    slot = inkCompoundRef.GetWidget(this.m_setGridWidget, i + slotsPerColumn);
    slot.SetTranslation(slot.GetWidth() + 10.0, -slot.GetHeight() * Cast<Float>(slotsPerColumn) - Cast<Float>(Abs(Cast<Int32>(slot.GetHeight()))) / 4.0 - 7.5);
    i += 1;
  };
}

@addMethod(WardrobeUIGameController)
public final func EquipSetExtra(setID: gameWardrobeClothingSetIndexExtra) -> Void {
  let req: ref<EquipWardrobeSetRequest> = new EquipWardrobeSetRequest();
  req.setIDExtra = setID;
  req.owner = this.m_player;
  this.m_equipmentSystem.QueueRequest(req);
}

@addMethod(WardrobeUIGameController)
public final func UnequipSetExtra() -> Void {
  let req: ref<UnequipWardrobeSetRequest> = new UnequipWardrobeSetRequest();
  req.owner = this.m_player;
  this.m_equipmentSystem.QueueRequest(req);
}

@replaceMethod(WardrobeUIGameController)
private final func FinalizeTransmog() -> Void {
  let slots: array<ref<ClothingSetExtra>>;
  let slotsUsed: Int32 = 0;
  if this.m_currentSetController.GetClothingSetChanged() {
    this.m_setEditorController.SaveSet();
  };
  this.m_setEditorController.GetPreviewController().ClearPuppet();
  this.m_setEditorController.GetPreviewController().RestorePuppetWeapons();
  this.SendDeleteRequests();
  if Equals(this.m_finalEquippedSetExtra, gameWardrobeClothingSetIndexExtra.INVALID) {
    if Equals(EquipmentSystem.GetActiveWardrobeSetIDExtra(this.m_player), gameWardrobeClothingSetIndexExtra.INVALID) {
      this.m_setEditorController.GetPreviewController().RestorePuppetEquipment();
    } else {
      this.UnequipSetExtra();
    };
  } else {
    this.EquipSetExtra(this.m_finalEquippedSetExtra);
  };
  this.m_setEditorController.GetPreviewController().DelayedResetItemAppearanceInSlot(t"AttachmentSlots.Chest");
  slots = WardrobeSystemExtra.GetInstance(this.m_player.GetGame()).GetClothingSets();
  slotsUsed = ArraySize(slots);
  // GameInstance.GetTelemetrySystem(this.m_player.GetGame()).LogWardrobeUsed(slotsUsed);
}

@replaceMethod(WardrobeUIGameController)
private final func SendDeleteRequests() -> Void {
  let setSumber: Int32;
  let savedSets: array<ref<ClothingSetExtra>> = WardrobeSystemExtra.GetInstance(this.m_player.GetGame()).GetClothingSets();
  let i: Int32 = 0;
  while i < ArraySize(savedSets) {
    setSumber = WardrobeSystemExtra.WardrobeClothingSetIndexToNumber(savedSets[i].setID);
    if !this.m_setControllers[setSumber].GetDefined() {
      this.DeleteSetExtra(savedSets[i].setID);
    };
    i += 1;
  };
}

@addMethod(WardrobeUIGameController)
public final func ResetSetExtra(setID: gameWardrobeClothingSetIndexExtra) -> Void {
  let clothingSet: ref<ClothingSetExtra>;
  let i: Int32;
  let setAmount: Int32;
  let controllerIndex: Int32 = WardrobeSystemExtra.WardrobeClothingSetIndexToNumber(setID);
  let setController: wref<ClothingSetController> = this.m_setControllers[controllerIndex];
  if setController == null {
    return;
  };
  if setController.GetDefined() {
    this.m_setsExtra = WardrobeSystemExtra.GetInstance(this.m_player.GetGame()).GetClothingSets();
    setAmount = ArraySize(this.m_setsExtra);
    i = 0;
    while i < setAmount {
      if Equals(this.m_setsExtra[i].setID, setID) {
        setController.SetClothingSetExtra(this.m_setsExtra[i], true);
        break;
      };
      i += 1;
    };
  } else {
    clothingSet = setController.GetClothingSetExtra();
    i = 0;
    while i < ArraySize(clothingSet.clothingList) {
      clothingSet.clothingList[i].visualItem = ItemID.None();
      i += 1;
    };
  };
  setController.SetClothingSetChanged(false);
}

@addField(DeleteWardrobeSetRequest)
public let setIDExtra: gameWardrobeClothingSetIndexExtra;

@addMethod(WardrobeUIGameController)
public final func DeleteSetExtra(setID: gameWardrobeClothingSetIndexExtra) -> Void {
  let req: ref<DeleteWardrobeSetRequest> = new DeleteWardrobeSetRequest();
  req.setIDExtra = setID;
  req.owner = this.m_player;
  this.m_equipmentSystem.QueueRequest(req);
}

@addMethod(WardrobeUIGameController)
public final func SetEquippedStateExtra(currentSet: gameWardrobeClothingSetIndexExtra) -> Void {
  let set: ref<ClothingSetExtra>;
  this.m_finalEquippedSetExtra = currentSet;
  let i: Int32 = 0;
  while i < ArraySize(this.m_setControllers) {
    set = this.m_setControllers[i].GetClothingSetExtra();
    this.m_setControllers[i].SetEquipped(Equals(set.setID, currentSet));
    i += 1;
  };
}

@replaceMethod(WardrobeUIGameController)
protected cb func OnDeleteSetConfirmationResults(data: ref<inkGameNotificationData>) -> Bool {
  let clothingSet: ref<ClothingSetExtra>;
  let i: Int32;
  let resultData: ref<GenericMessageNotificationCloseData>;
  this.PlayWardrobeSound(n"Item", n"OnDisassemble");
  resultData = data as GenericMessageNotificationCloseData;
  if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
    this.m_deletedSetController.SetDefined(false);
    if this.m_deletedSetController.GetEquipped() {
      this.m_finalEquippedSetExtra = gameWardrobeClothingSetIndexExtra.INVALID;
      this.m_deletedSetController.SetEquipped(false);
    };
    clothingSet = this.m_deletedSetController.GetClothingSetExtra();
    i = 0;
    while i < ArraySize(clothingSet.clothingList) {
      clothingSet.clothingList[i].visualItem = ItemID.None();
      i += 1;
    };
    if this.m_currentSetController == this.m_deletedSetController {
      this.SelectSlot(this.m_deletedSetController);
    };
  };
  this.m_confirmationRequestToken = null;
  this.m_deletedSetController = null;
}

@replaceMethod(WardrobeUIGameController)
protected cb func OnSetClick(e: ref<inkPointerEvent>) -> Bool {
  let actionName: ref<inkActionName>;
  let setController: wref<ClothingSetController>;
  if this.m_outroAnimProxy.IsPlaying() {
    return true;
  };
  setController = e.GetCurrentTarget().GetController() as ClothingSetController;
  if setController.IsDisabled() {
    return true;
  };
  actionName = e.GetActionName();
  if actionName.IsAction(n"select") {
    this.PlayWardrobeSound(n"Button", n"OnPress");
    if this.m_currentSetController.GetClothingSetChanged() {
      this.m_setEditorController.SaveSet();
    };
    this.SelectSlot(setController);
  } else {
    if setController.GetDefined() && actionName.IsAction(n"delete_wardrobe_set") {
      this.m_deletedSetController = setController;
      this.m_confirmationRequestToken = GenericMessageNotification.Show(this, GetLocalizedText("UI-Wardrobe-LabelWarning"), GetLocalizedText("UI-Wardrobe-NotificationDeleteSet"), GenericMessageNotificationType.ConfirmCancel);
      this.m_confirmationRequestToken.RegisterListener(this, n"OnDeleteSetConfirmationResults");
    };
  };
}