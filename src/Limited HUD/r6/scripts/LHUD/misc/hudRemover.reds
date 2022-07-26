import LimitedHudConfig.LHUDAddonsConfig

// -- OVERHEAD SUBTITLES
@addMethod(ChattersGameController)
public func GetAffiliationLHUD(lineData: scnDialogLineData) -> gamedataAffiliation {
  let puppet: ref<gamePuppetBase> = lineData.speaker as gamePuppetBase;
  if IsDefined(puppet) {
    return TweakDBInterface.GetCharacterRecord(puppet.GetRecordID()).Affiliation().Type();
  } else {
    return gamedataAffiliation.Unknown;
  };
}

@addMethod(ChattersGameController)
public func ShouldShowSubtitlesLHUD(affiliationata: gamedataAffiliation) -> Bool {
  return
    Equals(affiliationata, gamedataAffiliation.AfterlifeMercs) ||
    Equals(affiliationata, gamedataAffiliation.Aldecaldos) ||
    Equals(affiliationata, gamedataAffiliation.Civilian) ||
    Equals(affiliationata, gamedataAffiliation.News54) ||
    Equals(affiliationata, gamedataAffiliation.RecordingAgency) ||
    Equals(affiliationata, gamedataAffiliation.TheMox) ||
  false;
}

@addField(ChattersGameController)
private let lhudAddonsConfig: ref<LHUDAddonsConfig>;

@wrapMethod(ChattersGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudAddonsConfig = new LHUDAddonsConfig();
}

@wrapMethod(ChattersGameController)
protected func ShouldDisplayLine(lineData: scnDialogLineData) -> Bool {
  let affiliation: gamedataAffiliation = this.GetAffiliationLHUD(lineData);
  let shouldDisplayOriginal: Bool = wrappedMethod(lineData);
  let shouldDisplayModded: Bool = this.ShouldShowSubtitlesLHUD(affiliation);
  if this.lhudAddonsConfig.RemoveOverheadSubtitles {
    return shouldDisplayOriginal && shouldDisplayModded;
  } else {
    return shouldDisplayOriginal;
  };
}

// -- NEW AREA NOTIFICATION
@wrapMethod(JournalNotificationQueue)
protected cb func OnNewLocationDiscovered(newLocation: Bool) -> Bool {
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  if !config.RemoveNewAreaNotification {
    wrappedMethod(newLocation);
  };
}
