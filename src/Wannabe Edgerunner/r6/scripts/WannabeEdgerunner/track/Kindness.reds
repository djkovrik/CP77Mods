import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

// Pet
@wrapMethod(dialogWidgetGameController)
protected cb func OnLastAttemptedChoiceCustom(value: Variant) -> Bool {
  if Equals(this.m_lastSelectedHub, "LocKey#39016") || Equals(this.m_lastSelectedHub, "LocKey#32183") || Equals(this.m_lastSelectedHub, "LocKey#32185") {
    this.m_lastSelectedHub = "";
    EdgerunningSystem.GetInstance(this.GetPlayerControlledObject().GetGame()).OnKindness();
    E("Pet - restore humanity");
  };
  return wrappedMethod(value);
}

// Donate to a veteran
@wrapMethod(dialogWidgetGameController)
protected cb func OnLastAttemptedChoiceCustom(value: Variant) -> Bool {
  if Equals(this.m_lastSelectedHub, "LocKey#45546") {
    this.m_lastSelectedHub = "";
    EdgerunningSystem.GetInstance(this.GetPlayerControlledObject().GetGame()).OnKindness();
    E("Donated some money - restore humanity");
  };
  return wrappedMethod(value);
}
