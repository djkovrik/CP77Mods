@replaceMethod(SettingsSelectorController)
public func Refresh() -> Void {
  let i: Int32;
  let languageProvider: ref<inkLanguageOverrideProvider>;
  let modifiedSymbol: String;
  let text: String;
  let updatePolicy: ConfigVarUpdatePolicy;
  let wasModified: Bool;
  let size: Int32 = this.m_SettingsEntry.GetDisplayNameKeysSize();
  if size > 0 {
    text = NameToString(this.m_SettingsEntry.GetDisplayName());
    i = 0;
    while i < size {
      text = StrReplace(text, "%", GetLocalizedTextByKey(this.m_SettingsEntry.GetDisplayNameKey(i)));
      i += 1;
    };
  } else {
    text = GetLocalizedTextByKey(this.m_SettingsEntry.GetDisplayName());
  };
  updatePolicy = this.m_SettingsEntry.GetUpdatePolicy();
  if Equals(text, "") {
    // text = "<NOT LOCALIZED>" + NameToString(this.m_SettingsEntry.GetDisplayName());
    text = NameToString(this.m_SettingsEntry.GetDisplayName());
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
