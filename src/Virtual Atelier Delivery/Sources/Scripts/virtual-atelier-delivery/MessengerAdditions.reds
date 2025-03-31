module AtelierDelivery

// Fix message preview displaying
@wrapMethod(MessengerUtils)
private final static func SetTitle(out contactData: ref<ContactData>, conversationEntry: wref<JournalPhoneConversation>) -> Void {
  wrappedMethod(contactData, conversationEntry);
  if Equals(contactData.id, "virtual_atelier_delivery") {
    contactData.hasValidTitle = false;
  };
}

// Forcefully add last entry hash if unreadMessages does not have it,
// for cases when all custom journal entries are visited already
@wrapMethod(MessengerUtils)
public final static func GetContactMessageData(out contactData: ref<ContactData>, journal: ref<JournalManager>, const messagesReceived: script_ref<[wref<JournalEntry>]>, const playerReplies: script_ref<[wref<JournalEntry>]>) -> Void {
  wrappedMethod(contactData, journal, messagesReceived, playerReplies);
  let deliveryMessenger: ref<DeliveryMessengerSystem>;
  let entryHash: Int32;
  if Equals(contactData.contactId, "virtual_atelier_delivery") {
    deliveryMessenger = DeliveryMessengerSystem.Get(GetGameInstance());
    entryHash = deliveryMessenger.GetLastEntryHash();
    if deliveryMessenger.HasUnreadMessage() && !ArrayContains(contactData.unreadMessages, entryHash) {
      ArrayPush(contactData.unreadMessages, entryHash);
    };
  };
}

// Reset persisted unread state on chat opening
@wrapMethod(PhoneContactItemVirtualController)
public final func OpenInChat() -> Void {
  wrappedMethod();
  if Equals(this.m_contactData.contactId, "virtual_atelier_delivery") {
    DeliveryMessengerSystem.Get(GetGameInstance()).ResetUnreadMessage();
  };
}
