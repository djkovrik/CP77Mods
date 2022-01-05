@addField(QuestDetailsPanelController)
let m_selectedVehicleQuestId: String;

@replaceMethod(QuestDetailsPanelController)
public final func Setup(questData: wref<JournalQuest>, journalManager: wref<JournalManager>, phoneSystem: wref<PhoneSystem>, mappinSystem: wref<MappinSystem>, game: GameInstance, opt skipAnimation: Bool) -> Void {
  let playerLevel: Float = GameInstance.GetStatsSystem(game).GetStatValue(Cast(GameInstance.GetPlayerSystem(game).GetLocalPlayerMainGameObject().GetEntityID()), gamedataStatType.Level);
  let recommendedLevel: Int32 = GameInstance.GetLevelAssignmentSystem(game).GetLevelAssignment(questData.GetRecommendedLevelID());
  this.m_currentQuestData = questData;
  this.m_journalManager = journalManager;
  this.m_phoneSystem = phoneSystem;
  this.m_mappinSystem = mappinSystem;
  inkWidgetRef.SetVisible(this.m_noSelectedQuestContainer, false);
  inkWidgetRef.SetVisible(this.m_contentContainer, true);
  inkTextRef.SetText(this.m_questTitle, questData.GetTitle(journalManager));
  inkWidgetRef.SetState(this.m_questLevel, QuestLogUtils.GetLevelState(RoundMath(playerLevel), recommendedLevel));
  inkTextRef.SetText(this.m_questLevel, QuestLogUtils.GetThreatText(RoundMath(playerLevel), recommendedLevel));
  inkTextRef.SetText(this.m_questDescription, "");
  this.m_trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;
  inkCompoundRef.RemoveAllChildren(this.m_codexLinksContainer);
  if Equals(questData.GetType(), gameJournalQuestType.VehicleQuest) {
    this.m_selectedVehicleQuestId = questData.GetId();
  } else {
    this.m_selectedVehicleQuestId = "";
  };
  this.PopulateObjectives();
}

@replaceMethod(QuestDetailsPanelController)
public func SpawnMappinLink(mappinEntry: ref<JournalQuestMapPinBase>, jumpTo: Vector3) -> Void {
  let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_codexLinksContainer), n"linkMappin");
  let controller: ref<QuestMappinLinkController> = widget.GetController() as QuestMappinLinkController;

  if NotEquals(this.m_selectedVehicleQuestId, "") {
    controller.Setup(mappinEntry, this.m_selectedVehicleQuestId, jumpTo);
  } else {
    controller.Setup(mappinEntry, jumpTo);
  };
}


@addMethod(QuestMappinLinkController)
public func Setup(mappinEntry: ref<JournalQuestMapPinBase>, questId: String, jumpTo: Vector3) -> Void {
  Log("Quest id: " + questId);
  let iconRecord: ref<UIIcon_Record>;
  this.m_mappinEntry = mappinEntry;
  if NotEquals(questId, "") {
    iconRecord = GetVehicleIcon(questId);
    inkImageRef.SetAtlasResource(this.m_linkImage, iconRecord.AtlasResourcePath());
    inkImageRef.SetTexturePart(this.m_linkImage, iconRecord.AtlasPartName());
  };
  inkTextRef.SetText(this.m_linkLabel, this.m_mappinEntry.GetCaption());
  this.m_jumpTo = jumpTo;
}

public static func GetVehicleIcon(questId: String) -> ref<UIIcon_Record> {
  let iconRecord: ref<UIIcon_Record>;
  switch (questId) {
    // Bikes
    case "yaiba_kusanagi": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sportbike1_yaiba_kusanagi_player"));
    case "arch": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sportbike2_arch_player"));
    case "brennan_apollo": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sportbike3_brennan_apollo_player"));
    // Sport
    case "herrera_outlaw": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport1_herrera_outlaw_player"));
    case "rayfield_aerondight": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport1_rayfield_aerondight_player"));
    case "rayfield_caliburn": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport1_rayfield_caliburn_player"));
    case "quadra_turbo": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport1_quadra_turbo_player"));
    // Sport 2
    case "mizutani_shion": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_mizutani_shion_player"));
    case "mizutani_shion_nomad": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_mizutani_shion_nomad_player"));
    case "quadra_type66": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_quadra_type66_player"));
    case "quadra_type66_avenger": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_quadra_type66_avenger_player"));
    case "quadra_type66_nomad": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_quadra_type66_nomad_player"));
    case "quadra_type66_nomad_ncu": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_quadra_type66_ncu_player"));
    case "villefort_alvarado": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_villefort_alvarado_player"));
    // Standard 2
    case "archer_quartz": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_archer_quartz_player"));
    case "chevalier_thrax": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_chevalier_thrax_player"));
    case "makigai_maimai": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_makigai_maimai_player"));
    case "thorton_colby": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_thorton_colby_player"));
    case "thorton_galena": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_thorton_galena_player"));
    case "thorton_galena_nomad": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_thorton_galena_nomad_player"));
    case "villefort_cortes": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_villefort_cortes_player"));
    // Standard 2.5
    case "mahir_supron": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard25_mahir_supron_player"));
    case "thorton_colby_nomad": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard25_thorton_colby_nomad_player"));
    case "thorton_colby_pickup": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard25_thorton_colby_pickup_player"));
    case "villefort_columbus": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard25_villefort_columbus_player"));
    // Standard 3
    case "chevalier_emperor": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard3_chevalier_emperor_player"));
    case "thorton_mackinaw":return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard3_thorton_mackinaw_player"));   
  };

  return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_" + questId));
}
