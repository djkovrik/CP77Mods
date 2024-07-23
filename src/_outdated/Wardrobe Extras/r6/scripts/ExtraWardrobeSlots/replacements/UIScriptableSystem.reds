@addField(UIScriptableSystem)
private persistent let m_newWardrobeSetsExtra: array<gameWardrobeClothingSetIndexExtra>;

@addMethod(UIScriptableSystem)
public final const func IsWardrobeSetNewExtra(wardrobeSet: gameWardrobeClothingSetIndexExtra) -> Bool {
  return ArrayContains(this.m_newWardrobeSetsExtra, wardrobeSet);
}

@replaceMethod(UIScriptableSystem)
private final func OnWardrobeSetAdded(request: ref<UIScriptableSystemWardrobeSetAdded>) -> Void {
  if !ArrayContains(this.m_newWardrobeSetsExtra, request.wardrobeSetExtra) {
    ArrayPush(this.m_newWardrobeSetsExtra, request.wardrobeSetExtra);
  };
}

@replaceMethod(UIScriptableSystem)
private final func OnWardrobeSetInspected(request: ref<UIScriptableSystemWardrobeSetInspected>) -> Void {
  if ArrayContains(this.m_newWardrobeSetsExtra, request.wardrobeSetExtra) {
    ArrayRemove(this.m_newWardrobeSetsExtra, request.wardrobeSetExtra);
  };
}
