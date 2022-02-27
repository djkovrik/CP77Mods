module ReducedLootExclusions

public class RL_Exclusions {
  // Exclusion list for items
  public static func KeepForItemId(id: TweakDBID) -> Bool {
    return 
      // Quest related keycards
      Equals(id, t"Keycards.q005_keycard") ||
      Equals(id, t"Keycards.q103_afterlife_keycard_hades") ||
      Equals(id, t"Keycards.q105_keycard_dollhouse_vip") ||
      Equals(id, t"Keycards.q110_chapel_door_key") ||
      Equals(id, t"Keycards.q112_parade_keycard") ||
      Equals(id, t"Keycards.q114_arasaka_basement_sec_room_keycard") ||
      Equals(id, t"Keycards.q115_garden_sec_room_card") ||
      Equals(id, t"Keycards.q115_nest_keycard") ||
      Equals(id, t"Keycards.q115_solo_keycard") ||
      Equals(id, t"Keycards.q116_smasher_keycard") ||
      // Stadium Love
      Equals(id, t"Items.Preset_MQ008_Nova") ||
      // Sasquatch Hammer
      Equals(id, t"Items.Preset_Hammer_Sasquatch") ||
      // Ozob's Nose
      Equals(id, t"Items.GrenadeOzobsNose") ||
    false;
  }

  // Exclusion list for quest targets
  public static func KeepForQuestTarget(objectiveId: String) -> Bool {
    return 
      // Tutorial
      Equals(objectiveId, "01a_pick_weapon") ||
      Equals(objectiveId, "01c_pick_up_reanimator") ||
      Equals(objectiveId, "03_pick_up_katana") ||
    false;
  }

  // Keep for side quest
  public static func KeepForSQ(id: TweakDBID) -> Bool {
    return
      Equals(id, t"Items.sq006_conspiracy_note_uncracked") ||
      Equals(id, t"Items.sq006_maelstrom_note") ||
      Equals(id, t"Items.sq012_animals_orders") ||
      Equals(id, t"Items.sq012_animals_training_journal") ||
      Equals(id, t"Items.SQ012_Shirt_VoteForPeralez") ||
      Equals(id, t"Items.sq017_concert_ticket") ||
      Equals(id, t"Items.sq017_electric_guitar_kerry") ||
      Equals(id, t"Items.sq017_spike_trap") ||
      Equals(id, t"Items.sq021_drugs") ||
      Equals(id, t"Items.sq021_key_drawer") ||
      Equals(id, t"Items.SQ021_Lab_Costume") ||
      Equals(id, t"Items.sq021_peter_pan_baton") ||
      Equals(id, t"Items.SQ021_Wraiths_Vest") ||
      Equals(id, t"Items.sq023_ent_bd_hammer") ||
      Equals(id, t"Items.sq023_joshua_conversion_shard") ||
      Equals(id, t"Items.sq023_killing_jablonsky_shard") ||
      Equals(id, t"Items.SQ023_Switchblade_Pants") ||
      Equals(id, t"Items.SQ023_Switchblade_Shirt") ||
      Equals(id, t"Items.sq024_book_shard") ||
      Equals(id, t"Items.sq024_magazine_shard") ||
      Equals(id, t"Items.sq024_race_shard") ||
      Equals(id, t"Items.sq025_scanner") ||
      Equals(id, t"Items.sq026_hiromi_katana") ||
      Equals(id, t"Items.sq026_judy_coffee") ||
      Equals(id, t"Items.sq026_judy_sandwich") ||
      Equals(id, t"Items.sq026_judys_bd_brainstorm") ||
      Equals(id, t"Items.sq026_judys_bot_notes") ||
      Equals(id, t"Items.sq026_judys_goodbye_v") ||
      Equals(id, t"Items.sq026_judys_underwater_village") ||
      Equals(id, t"Items.sq026_maikos_dh_report") ||
      Equals(id, t"Items.sq027_locomotive_specs") ||
      Equals(id, t"Items.sq027_onboarding") ||
      Equals(id, t"Items.sq027_punchcard") ||
      Equals(id, t"Items.sq027_punchcards") ||
      Equals(id, t"Items.sq029_coffee_cup") ||
      Equals(id, t"Items.SQ029_Police_Suit") ||
      Equals(id, t"Items.sq029_rice") ||
      Equals(id, t"Items.SQ029_River_Romance_Shirt") ||
      Equals(id, t"Items.sq029_rivers_gun") ||
      Equals(id, t"Items.SQ030_MaxTac_Chest") ||
      Equals(id, t"Items.SQ030_MaxTac_Helmet") ||
      Equals(id, t"Items.SQ030_MaxTac_Pants") ||
      Equals(id, t"Items.sq030_mox_shotgun") ||
      Equals(id, t"Items.sq031_ebunike_morleys") ||
      Equals(id, t"Items.sq031_porsche_cargo_key") ||
      Equals(id, t"Items.SQ031_Samurai_Jacket") ||
      Equals(id, t"Items.SQ031_Samurai_Jacket_Epic") ||
      Equals(id, t"Items.SQ031_Samurai_Jacket_Legendary") ||
    false;
  }

  // Keep for main quest
  public static func KeepForMQ(id: TweakDBID) -> Bool {
    return
      Equals(id, t"Items.mq001_action_figure") ||
      Equals(id, t"Items.mq001_scorpions_knife") ||
      Equals(id, t"Items.mq003_painting") ||
      Equals(id, t"Items.mq003_shard") ||
      Equals(id, t"Items.mq007_skippy") ||
      Equals(id, t"Items.mq008_golden_knuckledusters") ||
      Equals(id, t"Items.mq011_wilson_gun") ||
      Equals(id, t"Items.mq014_air_braindance") ||
      Equals(id, t"Items.mq016_bartmoss_cyberdeck_decrypted") ||
      Equals(id, t"Items.mq016_bartmoss_cyberdeck_encrypted") ||
      Equals(id, t"Items.mq023_samurai_bootleg") ||
      Equals(id, t"Items.mq024_data_carrier_shard") ||
      Equals(id, t"Items.mq024_data_nightcorp_shard") ||
      Equals(id, t"Items.mq024_data_nightcorp2_shard") ||
      Equals(id, t"Items.mq024_data_nightcorp3_shard") ||
      Equals(id, t"Items.mq024_sandra_data_carrier") ||
      Equals(id, t"Items.mq024_sandra_data_carrier_cracked") ||
      Equals(id, t"Items.mq025_boxing_twins_shard") ||
      Equals(id, t"Items.mq025_buck_gun") ||
      Equals(id, t"Items.mq026_conspiracy_loot") ||
      Equals(id, t"Items.mq026_conspiracy_loot_cracked") ||
      Equals(id, t"Items.mq026_conspiracy_shard") ||
      Equals(id, t"Items.mq028_evidence") ||
      Equals(id, t"Items.mq028_stalker_diary_shard") ||
      Equals(id, t"Items.mq028_uscracks_lyrics_shard") ||
      Equals(id, t"Items.mq029_james_note") ||
      Equals(id, t"Items.mq029_josie_last_note") ||
      Equals(id, t"Items.mq033_dreamcatcher") ||
      Equals(id, t"Items.mq036_unmarked_bd_cartridge") ||
    false;
  }

  // Keep for quest
  public static func KeepForQ(id: TweakDBID) -> Bool {
    return
      Equals(id, t"Items.q004_access_card") ||
      Equals(id, t"Items.q005_iguana_egg") ||
      Equals(id, t"Items.q103_nash_shard") ||
      Equals(id, t"Items.q103_panam_car_key") ||
      Equals(id, t"Items.q105_evelyns_cigarette_case") ||
      Equals(id, t"Items.q105_evelyns_handbag") ||
      Equals(id, t"Items.q105_item_blackmarket_braindance") ||
      Equals(id, t"Items.q105_mox_handgun") ||
      Equals(id, t"Items.q115_grenades") ||
      Equals(id, t"Items.q115_katana") ||
      Equals(id, t"Items.q115_pistol") ||
      Equals(id, t"Items.q115_revolver") ||
      Equals(id, t"Items.q115_rifle") ||
      Equals(id, t"Items.q115_rogue_shard_1") ||
      Equals(id, t"Items.q115_rogue_shard_2") ||
      Equals(id, t"Items.q115_shotgun") ||
      Equals(id, t"Items.q115_soul_shard") ||
      Equals(id, t"Items.q116_mikoshi_shard") ||
      Equals(id, t"Items.q204_rogue_gun") ||
      Equals(id, t"Items.q204_samurai_jacket") ||
    false;
  }
}
