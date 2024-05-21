module HudPainter

public class HudPainterPreviewController extends inkGameController {
  private let m_selectorWidget: inkWidgetRef;
  private let m_previewsContainer: inkCompoundRef;
  private let m_affectedColors: inkTextRef;
  private let m_selectorCtrl: wref<ListController>;
  private let m_items: array<ref<HudPainterPreviewTab>>;

  protected cb func OnInitialize() {
    this.m_selectorCtrl = inkWidgetRef.GetController(this.m_selectorWidget) as ListController;
    this.m_selectorCtrl.RegisterToCallback(n"OnItemActivated", this, n"OnMenuChanged");
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnButtonRelease");

    this.PopulateItems();
    this.PopulateCategories();
    this.SpawnPreviews();
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_selectorCtrl.UnregisterFromCallback(n"OnItemActivated", this, n"OnMenuChanged");
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnButtonRelease");
  }

  protected cb func OnMenuChanged(index: Int32, target: ref<ListItemController>) -> Bool {
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
    this.ShowPreview(index);
  }

  protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
    let currentToggledIndex: Int32;
    let listSize: Int32 = this.m_selectorCtrl.Size();
    if evt.IsAction(n"prior_menu") {
      currentToggledIndex = this.m_selectorCtrl.GetToggledIndex();
      if currentToggledIndex < 1 {
        this.m_selectorCtrl.SetToggledIndex(listSize - 1);
      } else {
        this.m_selectorCtrl.SetToggledIndex(currentToggledIndex - 1);
      };
    } else {
      if evt.IsAction(n"next_menu") {
        currentToggledIndex = this.m_selectorCtrl.GetToggledIndex();
        if currentToggledIndex >= this.m_selectorCtrl.Size() - 1 {
          this.m_selectorCtrl.SetToggledIndex(0);
        } else {
          this.m_selectorCtrl.SetToggledIndex(currentToggledIndex + 1);
        };
      };
    };
  }

  protected cb func OnHudPainterColorSelected(evt: ref<HudPainterColorSelected>) -> Bool {
    this.QueueEvent(HudPainterPreviewModeEnabled.Create());
  }

  private final func PopulateItems() -> Void {
    // Healthbar
    let heathbar: ref<HudPainterPreviewTab> = new HudPainterPreviewTab();
    heathbar.tabName = GetLocalizedTextByKey(n"UI-Settings-Interface-HUD-Healthbar");
    heathbar.tabType = PreviewTabType.Healthbar;
    heathbar.previewResourcePath = r"base\\gameplay\\gui\\widgets\\healthbar\\playerhealthbar.inkwidget";
    heathbar.previewLibraryID = n"RootVert";
    heathbar.previewAnchorPoint = new Vector2(0.5, 0.0);
    heathbar.affectedColors = "Red, Blue, PanelBlue, ActiveBlue, DarkBlue, Overshield, Grey";
    ArrayPush(this.m_items, heathbar);
    // Quest tracker
    let questTracker: ref<HudPainterPreviewTab> = new HudPainterPreviewTab();
    questTracker.tabName = GetLocalizedTextByKey(n"UI-Settings-Interface-HUD-quest_tracker");
    questTracker.tabType = PreviewTabType.QuestTracker;
    questTracker.previewResourcePath = r"base\\gameplay\\gui\\widgets\\quests\\quest_tracker.inkwidget";
    questTracker.previewLibraryID = n"Root";
    questTracker.previewAnchorPoint = new Vector2(0.5, 0.5);
    questTracker.affectedColors = "ActiveYellow, ActiveGreen, CombatRed, StreetCred";
    ArrayPush(this.m_items, questTracker);
    // Ammo counter
    let ammoCounter: ref<HudPainterPreviewTab> = new HudPainterPreviewTab();
    ammoCounter.tabName = GetLocalizedTextByKey(n"UI-Settings-Interface-HUD-ammo_counter");
    ammoCounter.tabType = PreviewTabType.AmmoCounter;
    ammoCounter.previewResourcePath = r"base\\gameplay\\gui\\widgets\\ammo_counter\\ammo_counter.inkwidget";
    ammoCounter.previewLibraryID = n"Root";
    ammoCounter.previewAnchorPoint = new Vector2(0.5, 0.0);
    ammoCounter.affectedColors = "Red, ActiveRed, Blue";
    ArrayPush(this.m_items, ammoCounter);
    // Safe notification
    let notificationSafe: ref<HudPainterPreviewTab> = new HudPainterPreviewTab();
    notificationSafe.tabName = GetLocalizedTextByKey(n"UI-ResourceExports-NotificationTitle");
    notificationSafe.tabType = PreviewTabType.NotificationSafe;
    notificationSafe.previewResourcePath = r"base\\gameplay\\gui\\widgets\\notifications\\zonealert_notification.inkwidget";
    notificationSafe.previewLibraryID = n"Area_Safe";
    notificationSafe.previewAnchorPoint = new Vector2(0.5, 0.0);
    notificationSafe.affectedColors = "Green";
    ArrayPush(this.m_items, notificationSafe);
    // Message
    let phoneMessage: ref<HudPainterPreviewTab> = new HudPainterPreviewTab();
    phoneMessage.tabName = GetLocalizedTextByKey(n"UI-ResourceExports-Message");
    phoneMessage.tabType = PreviewTabType.UpdateMessage;
    phoneMessage.previewResourcePath = r"base\\gameplay\\gui\\widgets\\notifications\\quest_update.inkwidget";
    phoneMessage.previewLibraryID = n"notification_quest_updated";
    phoneMessage.previewAnchorPoint = new Vector2(1.0, 0.0);
    phoneMessage.affectedColors = "Yellow, White";
    ArrayPush(this.m_items, phoneMessage);
  }

  private final func PopulateCategories() -> Void {
    let count: Int32 = ArraySize(this.m_items);
    let i: Int32 = 0;
    let newData: ref<ListItemData>;
    let currentItem: ref<HudPainterPreviewTab>;
    this.m_selectorCtrl.Clear();

    while i < count {
      currentItem = this.m_items[i];
      newData = new ListItemData();
      newData.label = s"\(currentItem.tabName)";
      this.m_selectorCtrl.PushData(newData);
      i += 1;
    };
    this.m_selectorCtrl.Refresh();
    this.m_selectorCtrl.SetToggledIndex(0);
  }

  private final func SpawnPreviews() -> Void {
    let count: Int32 = ArraySize(this.m_items);
    let i: Int32 = 0;
    let currentItem: ref<HudPainterPreviewTab>;
    let spawnedWidget: ref<inkWidget>;

    while i < count {
      currentItem = this.m_items[i];
      spawnedWidget = this.SpawnFromExternal(
        inkWidgetRef.Get(this.m_previewsContainer), 
        currentItem.previewResourcePath, 
        currentItem.previewLibraryID
      );

      spawnedWidget.SetVisible(false);
      spawnedWidget.SetAnchorPoint(currentItem.previewAnchorPoint);
      spawnedWidget.SetName(StringToName(s"\(currentItem.tabType)"));

      this.Log(s"Widget \(currentItem.tabType) spawned \(IsDefined(spawnedWidget))");
      i += 1;
    };
  }

  private final func ShowPreview(index: Int32) -> Void {
    this.Log(s"Show preview \(index)");
    let count: Int32 = inkCompoundRef.GetNumChildren(this.m_previewsContainer);
    let i: Int32 = 0;
    let currentChild: ref<inkWidget>;

    while i < count {
      currentChild = inkCompoundRef.GetWidgetByIndex(this.m_previewsContainer, i);
      currentChild.SetVisible(Equals(i, index));
      i += 1;
    };

    this.m_selectorCtrl.SetSelectedIndex(index);
    inkTextRef.SetText(this.m_affectedColors, this.m_items[index].affectedColors);
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"Preview", str);
    };
  }
}
