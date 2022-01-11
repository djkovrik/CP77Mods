// Set custom data for worldmap mappin popup
@replaceMethod(WorldMapTooltipController)
public func SetData(data: WorldMapTooltipData, menu: ref<WorldMapMenuGameController>) -> Void {
  let contentID: TweakDBID;
  let contentRecord: wref<ContentAssignment_Record>;
  let curveModifier: wref<CurveStatModifier_Record>;
  let descStr: String;
  let fastTravelmappin: ref<FastTravelMappin>;
  let inputInteractStr: String;
  let inputOpenJournalStr: String;
  let inputSetWaypointStr: String;
  let inputTrackQuestStr: String;
  let inputZoomToStr: String;
  let journalID: String;
  let levelState: CName;
  let m_mappin: ref<JournalQuestMapPin>;
  let m_objective: ref<JournalQuestObjective>;
  let m_phase: ref<JournalQuestPhase>;
  let m_quest: ref<JournalQuest>;
  let mappinPhase: gamedataMappinPhase;
  let mappinVariant: gamedataMappinVariant;
  let pointData: ref<FastTravelPointData>;
  let prefix: String;
  let suffix: String;
  let threatString: String;
  let titleStr: String;
  let vehicleMappin: ref<VehicleMappin>;
  let vehicleObject: wref<VehicleObject>;
  let isTrackedQuest: Bool = false;
  let recommendedLvlVisible: Bool = false;
  let recommendedLvl: Uint32 = 0u;
  let inputSetWaypoint: Bool = false;
  let inputTrackQuest: Bool = false;
  let inputInteract: Bool = false;
  let inputZoomTo: Bool = false;
  let inputOpenJournal: Bool = false;
  let journalManager: ref<JournalManager> = menu.GetJournalManager();
  let player: wref<GameObject> = menu.GetPlayer();
  let playerLevel: Int32 = RoundMath(GameInstance.GetStatsSystem(player.GetGame()).GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.Level));
  if data.controller != null && data.mappin != null && journalManager != null && player != null {
    // Custom data for popup
    let mappinData = data.mappin.GetScriptData() as GameplayRoleMappinData;
    if IsDefined(mappinData) && mappinData.m_isMappinCustom {
      titleStr = mappinData.m_customMappinTitle;
      descStr = mappinData.m_customMappinDescription;
    };
    //
    mappinVariant = data.mappin.GetVariant();
    mappinPhase = data.mappin.GetPhase();
    fastTravelmappin = data.mappin as FastTravelMappin;
    vehicleMappin = data.mappin as VehicleMappin;
    if IsDefined(vehicleMappin) {
      vehicleObject = vehicleMappin.GetVehicle();
      titleStr = IsDefined(vehicleObject) ? vehicleObject.GetDisplayName() : GetLocalizedText("UI-MappinTypes-PersonalVehicle");
      descStr = GetLocalizedText("UI-MappinTypes-PersonalVehicleDescription");
    } else {
      if IsDefined(fastTravelmappin) {
        pointData = fastTravelmappin.GetPointData();
        titleStr = GetLocalizedText("UI-MappinTypes-FastTravel");
        descStr = data.isCollection ? GetLocalizedText("UI-MappinTypes-FastTravelDescription") : pointData.GetPointDisplayName();
        inputInteract = data.fastTravelEnabled;
        inputInteractStr = GetLocalizedText("UI-ResourceExports-FastTravel");
        inputSetWaypoint = !menu.IsFastTravelEnabled();
      } else {
        if Equals(mappinPhase, gamedataMappinPhase.UndiscoveredPhase) {
          titleStr = "UI-MappinTypes-Undiscovered";
          descStr = "UI-MappinTypes-UndiscoveredDescription";
        } else {
          m_mappin = data.journalEntry as JournalQuestMapPin;
          if m_mappin != null {
            m_objective = journalManager.GetParentEntry(m_mappin) as JournalQuestObjective;
            if m_objective != null {
              m_phase = journalManager.GetParentEntry(m_objective) as JournalQuestPhase;
              if m_phase != null {
                m_quest = journalManager.GetParentEntry(m_phase) as JournalQuest;
                if m_quest != null {
                  titleStr = m_quest.GetTitle(journalManager);
                  descStr = m_objective.GetDescription();
                };
              };
            };
          };
          if Equals(titleStr, "") {
            titleStr = NameToString(MappinUIUtils.MappinToString(mappinVariant, mappinPhase));
          };
          if Equals(descStr, "") {
            descStr = NameToString(MappinUIUtils.MappinToDescriptionString(mappinVariant));
          };
        };
        if !menu.IsFastTravelEnabled() {
          if menu.CanQuestTrackMappin(data.mappin) {
            isTrackedQuest = data.controller.IsTracked();
            if !isTrackedQuest {
              inputTrackQuest = true;
              inputTrackQuestStr = GetLocalizedTextByKey(n"UI-Menus-WorldMap-TrackQuest");
            };
          } else {
            if menu.CanPlayerTrackMappin(data.mappin) {
              inputSetWaypoint = true;
            };
          };
        };
        if data.journalEntry != null {
          recommendedLvl = journalManager.GetRecommendedLevel(data.journalEntry);
          if IsDefined(m_quest) {
            contentID = m_quest.GetRecommendedLevelID();
          } else {
            journalID = data.journalEntry.GetId();
            if StrBeginsWith(journalID, "mq") || StrBeginsWith(journalID, "sq") || StrBeginsWith(journalID, "q") {
              StrSplitFirst(journalID, "_", prefix, suffix);
              journalID = prefix;
            };
            contentID = TDBID.Create("DeviceContentAssignment." + journalID);
          };
          contentRecord = TweakDBInterface.GetContentAssignmentRecord(contentID);
          if IsDefined(contentRecord) {
            curveModifier = contentRecord.PowerLevelMod() as CurveStatModifier_Record;
            if IsDefined(curveModifier) {
              recommendedLvl = Cast<Uint32>(RoundF(GameInstance.GetStatsDataSystem(player.GetGame()).GetValueFromCurve(StringToName(curveModifier.Id()), Cast<Float>(playerLevel), StringToName(curveModifier.Column()))));
            } else {
              recommendedLvl = Cast<Uint32>(GameInstance.GetLevelAssignmentSystem(player.GetGame()).GetLevelAssignment(contentID));
            };
          };
          recommendedLvlVisible = Cast<Int32>(recommendedLvl) > 0;
        };
        levelState = QuestLogUtils.GetLevelState(playerLevel, Cast<Int32>(recommendedLvl));
        switch levelState {
          case n"ThreatVeryLow":
            threatString = GetLocalizedText("UI-Tooltips-ThreatVeryLow");
            break;
          case n"ThreatLow":
            threatString = GetLocalizedText("UI-Tooltips-Low");
            break;
          case n"ThreatMedium":
            threatString = GetLocalizedText("UI-Tooltips-ThreatMedium");
            break;
          case n"ThreatHigh":
            threatString = GetLocalizedText("UI-Tooltips-ThreatHigh");
            break;
          case n"ThreatVeryHigh":
            threatString = GetLocalizedText("UI-Tooltips-ThreatVeryHigh");
            break;
          default:
            threatString = GetLocalizedText("UI-Tooltips-ThreatMedium");
        };
        inkWidgetRef.SetState(this.m_threatLevelCaption, levelState);
        inkWidgetRef.SetState(this.m_threatLevelValue, levelState);
        inkTextRef.SetText(this.m_threatLevelValue, threatString);
      };
    };
    if inputSetWaypoint {
      inputSetWaypointStr = data.controller.IsPlayerTracked() ? GetLocalizedText("UI-ScriptExports-Untrack0") : GetLocalizedText("UI-ResourceExports-Track");
    };
    inputOpenJournal = data.readJournal;
    inputOpenJournalStr = GetLocalizedText("UI-PanelNames-JOURNAL");
    inputZoomTo = menu.CanZoomToMappin(data.controller);
    inputZoomToStr = GetLocalizedText("Gameplay-InputHints-DeviceControl-ZoomIn");
  };
  inkWidgetRef.SetVisible(this.m_collectionCountContainer, data.isCollection);
  if data.isCollection {
    inkTextRef.SetText(this.m_collectionCountText, IntToString(data.collectionCount));
    inputSetWaypoint = false;
    inputTrackQuest = false;
    inputOpenJournal = false;
    inputInteract = false;
    isTrackedQuest = false;
    recommendedLvlVisible = false;
  };
  inkTextRef.SetText(this.m_titleText, titleStr);
  inkTextRef.SetText(this.m_descText, descStr);
  inkWidgetRef.SetVisible(this.m_trackedQuestContainer, isTrackedQuest);
  inkTextRef.SetText(this.m_requiredLevelValue, IntToString(Cast<Int32>(recommendedLvl)));
  inkWidgetRef.SetState(this.m_requiredLevelValue, this.GetLevelState(playerLevel, Cast<Int32>(recommendedLvl)));
  inkWidgetRef.SetState(this.m_requiredLevelText, this.GetLevelState(playerLevel, Cast<Int32>(recommendedLvl)));
  inkWidgetRef.SetVisible(this.m_requiredLevelCanvas, recommendedLvlVisible);
  inkWidgetRef.SetVisible(this.m_inputSetWaypointContainer, inputSetWaypoint);
  inkTextRef.SetText(this.m_inputSetWaypointText, inputSetWaypointStr);
  inkWidgetRef.SetVisible(this.m_inputTrackQuestContainer, inputTrackQuest);
  inkTextRef.SetText(this.m_inputTrackQuestText, inputTrackQuestStr);
  inkWidgetRef.SetVisible(this.m_inputInteractContainer, inputInteract);
  inkTextRef.SetText(this.m_inputInteractText, inputInteractStr);
  inkWidgetRef.SetVisible(this.m_inputOpenJournalContainer, inputOpenJournal);
  inkTextRef.SetText(this.m_inputOpenJournalText, inputOpenJournalStr);
  inkWidgetRef.SetVisible(this.m_inputZoomToContainer, inputZoomTo);
  inkTextRef.SetText(this.m_inputZoomToText, inputZoomToStr);
}