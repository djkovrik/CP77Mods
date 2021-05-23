// Removes HP and max HP text labels from player healthbar

@replaceMethod(healthbarWidgetGameController)
private final func SetHealthProgress(value: Float) -> Void {
  value = ClampF(value, 0.01, 1.00);
  let percentHP: Float = 100.00 * Cast(this.m_currentHealth) / Cast(this.m_maximumHealth);
  percentHP = ClampF(percentHP, 1.00, 100.00);
  this.m_healthController.SetNameplateBarProgress(value, this.m_previousHealth == this.m_currentHealth);
  inkTextRef.SetText(this.m_healthTextPath, IntToString(this.m_currentHealth));
  inkTextRef.SetText(this.m_maxHealthTextPath, IntToString(this.m_maximumHealth));
  if this.m_previousHealth > this.m_currentHealth {
    this.StartDamageFallDelay();
  };

  inkWidgetRef.SetVisible(this.m_healthTextPath, false);
  inkWidgetRef.SetVisible(this.m_maxHealthTextPath, false);
}