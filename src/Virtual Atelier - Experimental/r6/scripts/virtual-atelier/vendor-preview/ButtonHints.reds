@addField(ButtonHints)
public let m_rotateButtons: ref<inkWidget>;

@replaceMethod(ButtonHints)
public final func AddCharacterRoatateButtonHint() -> Void {
  this.m_rotateButtons = this.SpawnFromLocal(inkWidgetRef.Get(this.m_horizontalHolder), n"ButtonHintRotation");
}

@addMethod(ButtonHints)
public final func HideCharacterRotateButtonHint() -> Void {
  this.m_rotateButtons.SetVisible(false);
}
