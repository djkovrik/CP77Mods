@replaceMethod(SettingsSelectorController)
public func Refresh() -> Void {
  let languageProvider: ref<inkLanguageOverrideProvider>;
  let modifiedSymbol: String;
  let wasModified: Bool;
  let text: String = GetLocalizedTextByKey(this.m_SettingsEntry.GetDisplayName());
  let updatePolicy: ConfigVarUpdatePolicy = this.m_SettingsEntry.GetUpdatePolicy();
  if Equals(text, "") {
    // text = "<NOT LOCALIZED>" + NameToString(this.m_SettingsEntry.GetDisplayName());
    text = "" + NameToString(this.m_SettingsEntry.GetDisplayName());  // <NOT LOCALIZED> removed
  };
  if Equals(updatePolicy, ConfigVarUpdatePolicy.ConfirmationRequired) {
    modifiedSymbol = "*";
    wasModified = this.m_SettingsEntry.HasRequestedValue();
  } else {
    if Equals(updatePolicy, ConfigVarUpdatePolicy.RestartRequired) || Equals(updatePolicy, ConfigVarUpdatePolicy.LoadLastCheckpointRequired) {
      modifiedSymbol = "!";
      wasModified = this.m_SettingsEntry.HasRequestedValue() || this.m_SettingsEntry.WasModifiedSinceLastSave();
    } else {
      modifiedSymbol = "";
      wasModified = false;
    };
  };
  languageProvider = inkWidgetRef.GetUserData(this.m_LabelText, n"inkLanguageOverrideProvider") as inkLanguageOverrideProvider;
  languageProvider.SetLanguage(scnDialogLineLanguage.Origin);
  inkTextRef.UpdateLanguageResources(this.m_LabelText, false);
  inkTextRef.SetText(this.m_LabelText, text);
  inkWidgetRef.SetVisible(this.m_ModifiedFlag, wasModified);
  inkTextRef.SetText(this.m_ModifiedFlag, modifiedSymbol);
}
