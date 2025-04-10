module AtelierDelivery

public class DeliveryMessengerSystem extends ScriptableSystem {
  persistent let history: array<ref<DeliveryHistoryItem>>;
  persistent let uniqueIndex: Int32 = 0;
  persistent let hasUnreadMessage: Bool = false;

  private let conversation: wref<JournalPhoneConversation>;

  public static func Get(gi: GameInstance) -> ref<DeliveryMessengerSystem> {
    let system: ref<DeliveryMessengerSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"AtelierDelivery.DeliveryMessengerSystem") as DeliveryMessengerSystem;
    return system;
  }

  private func OnAttach() -> Void {
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };

    let token: ref<ResourceToken> = GameInstance.GetResourceDepot().LoadResource(r"base\\atelier\\delivery.journal");
    token.RegisterCallback(this, n"OnJournalLoaded");

    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Session/Ready", this, n"OnSessionReady")
      .SetLifetime(CallbackLifetime.Session);
  }

  private cb func OnJournalLoaded(token: ref<ResourceToken>) {
    this.Log("OnJournalLoaded");
    let journal: ref<gameJournalResource> = token.GetResource() as gameJournalResource;
    let journalRoot: ref<gameJournalRootFolderEntry> = journal.entry as gameJournalRootFolderEntry;
    let primaryFolder: ref<gameJournalPrimaryFolderEntry> = journalRoot.entries[0] as gameJournalPrimaryFolderEntry;
    let contact: ref<JournalContact> = primaryFolder.entries[0] as JournalContact;
    this.conversation = contact.entries[0] as JournalPhoneConversation;
  }

  private cb func OnSessionReady(event: ref<GameSessionEvent>) {
    this.ApplyPersistedTextsToConversation();
  }

  private final func UnlockNewContact() -> Void {
    this.Log("UnlockNewContact");
    let journalManager: ref<JournalManager> = GameInstance.GetJournalManager(this.GetGameInstance());
    journalManager.ChangeEntryState("contacts/virtual_atelier_delivery", "gameJournalContact", gameJournalEntryState.Active, JournalNotifyOption.Notify);
    journalManager.ChangeEntryState("contacts/virtual_atelier_delivery/notifications", "gameJournalPhoneConversation", gameJournalEntryState.Active, JournalNotifyOption.Notify);
  }

  public final func HasUnreadMessage() -> Bool {
    return this.hasUnreadMessage;
  }

  public final func ResetUnreadMessage() -> Void {
    this.hasUnreadMessage = false;
  }

  public final func GetLastEntryHash() -> Int32 {
    let journalManager: ref<JournalManager> = GameInstance.GetJournalManager(this.GetGameInstance());
    let currentHistory: array<ref<DeliveryHistoryItem>> = this.history;
    let currentConversationMessages: array<ref<JournalEntry>> = this.conversation.entries;
    let lastIndex: Int32 = ArraySize(currentHistory) - 1;
    return journalManager.GetEntryHash(currentConversationMessages[lastIndex]);
  }

  public final func PushWelcomeNotificationItem() -> Void {
    let item: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Welcome();
    this.PushNewNotificationItem(item);
  }

  public final func PushNewDropPointNotificationItem(dropPoint: AtelierDeliveryDropPoint, district: TweakDBID) -> Void {
    let item: ref<DeliveryHistoryItem> = DeliveryHistoryItem.NewDropPoint(dropPoint, district);
    this.PushNewNotificationItem(item);
  }

  public final func PushShippedNotificationItem(bundle: ref<PurchasedAtelierBundle>) -> Void {
    let item: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Shipped(bundle.GetOrderId(), bundle.GetStoreName(), bundle.GetDeliveryPoint(), bundle.GetNextStatusUpdateDiff());
    this.PushNewNotificationItem(item);
  }

  public final func PushArrivedNotificationItem(bundle: ref<PurchasedAtelierBundle>) -> Void {
    let item: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Arrived(bundle.GetOrderId(), bundle.GetStoreName(), bundle.GetDeliveryPoint());
    this.PushNewNotificationItem(item);
  }

  public final func PushNewNotificationItem(item: ref<DeliveryHistoryItem>) -> Void {
    this.Log(s"PushNewNotificationItem \(item.LocalizedString())");
    let relatedEntriesCount: Int32 = ArraySize(this.conversation.entries);
    let currentHistory: array<ref<DeliveryHistoryItem>> = this.history;
    this.uniqueIndex = this.uniqueIndex + 1;
    item = DeliveryHistoryItem.WrapWithIndex(item, this.uniqueIndex);
    ArrayPush(currentHistory, item);

    let updatedHistory: array<ref<DeliveryHistoryItem>> = this.TakeLast(currentHistory, relatedEntriesCount);
    this.history = updatedHistory;
    this.ApplyPersistedTextsToConversation();
    this.NotifyAboutLastHistoryItem();
  }

  private final func ApplyPersistedTextsToConversation() -> Void {
    let currentHistory: array<ref<DeliveryHistoryItem>> = this.history;
    this.Log(s"ApplyPersistedTextsToConversation, persistend history size: \(ArraySize(currentHistory))");
    let message: ref<JournalPhoneMessage>;
    let messageText: String;
    let historyItem: ref<DeliveryHistoryItem>;
    let lastIndex: Int32 = ArraySize(currentHistory) - 1;
    let index: Int32 = 0;
    let path: String;
    while index <= lastIndex {
      message = this.conversation.entries[index] as JournalPhoneMessage;
      path = s"contacts/virtual_atelier_delivery/notifications/\(message.GetId())";
      historyItem = currentHistory[index];
      messageText = historyItem.LocalizedString();
      message.text = CreateLocalizationString(messageText);
      index += 1;
      this.Log(s" - updated \(path) text");
    };
  }

  private final func NotifyAboutLastHistoryItem() -> Void {
    this.Log("NotifyAboutLastHistoryItem");
    let journalManager: ref<JournalManager> = GameInstance.GetJournalManager(this.GetGameInstance());
    let currentHistory: array<ref<DeliveryHistoryItem>> = this.history;
    let currentConversationMessages: array<ref<JournalEntry>> = this.conversation.entries;
    let lastIndex: Int32 = ArraySize(currentHistory) - 1;
    let lastMessage: ref<JournalPhoneMessage> = currentConversationMessages[lastIndex] as JournalPhoneMessage;
    let path: String = s"contacts/virtual_atelier_delivery/notifications/\(lastMessage.GetId())";
    this.Log(s" - notify about \(path)");
    this.hasUnreadMessage = true;
    journalManager.ChangeEntryState(path, s"gameJournalPhoneMessage", gameJournalEntryState.Inactive, JournalNotifyOption.DoNotNotify);
    journalManager.ChangeEntryState(path, s"gameJournalPhoneMessage", gameJournalEntryState.Active, JournalNotifyOption.Notify);
  }

  private final func TakeLast(items: array<ref<DeliveryHistoryItem>>, n: Int32) -> array<ref<DeliveryHistoryItem>> {
    this.Log(s"TakeLast \(ArraySize(items)) items, n = \(n)");
    let size: Int32 = ArraySize(items);
    if size <= n {
      this.Log(s"TakeLast input and output size \(ArraySize(items))");
      return items;
    };

    let result: array<ref<DeliveryHistoryItem>>;
    let lastIndex: Int32 = size - 1;
    let firstIndex: Int32 = lastIndex - n + 1;
    let i: Int32 = firstIndex;
    while i <= lastIndex {
      ArrayPush(result, items[i]);
      i += 1;
    };

    this.Log(s"TakeLast input size \(ArraySize(items)), output size \(ArraySize(result))");
    return result;
  }

  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryMessenger", str);
    };
  }
}

