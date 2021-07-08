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
      // Space Oddity
      Equals(id, t"Items.mq003_painting") ||

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
}
