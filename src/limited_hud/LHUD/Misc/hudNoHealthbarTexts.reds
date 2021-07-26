// Removes HP and max HP text labels from player healthbar

@wrapMethod(healthbarWidgetGameController)
private final func SetHealthProgress(value: Float) -> Void {
  wrappedMethod(value);
  inkWidgetRef.SetVisible(this.m_healthTextPath, false);
  inkWidgetRef.SetVisible(this.m_maxHealthTextPath, false);
}