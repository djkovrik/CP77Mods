/* Removes bugged Santiago contact from dialer menu */
@replaceMethod(DialerContactDataView)
public func FilterItem(data: ref<IScriptable>) -> Bool {
  let contact: ref<ContactData>;
  contact = (data as ContactData);
  
  if NotEquals(contact, null) && Equals(contact.id, "santiago") {
    return false;
  }

  return true;
}

/* Removes bugged Santiago contact from messenger menu */
@addMethod(MessengerContactDataView)
protected func FilterItems(data: ref<VirutalNestedListData>) -> Bool {
  let contact: ref<ContactData>;
  contact = (data.m_data as ContactData);
  
  if NotEquals(contact, null) && Equals(contact.id, "santiago") {
    return false;
  }

  return true;
}