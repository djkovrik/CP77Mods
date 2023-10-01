import EnhancedCraft.Common.L

public class EnhancedCraftItemsGenerator extends ScriptableTweak {

  private let counter: Int32;

  protected cb func OnApply() -> Void {
    let weaponsVariants: array<CName>;
    let id: TweakDBID;
    let name: String;
    this.counter = 0;
    L("Checking weapon items...");
    for record in TweakDBInterface.GetRecords(n"WeaponItem") {
      let item = record as Item_Record;
      id = item.GetID();
      name = TweakDBInterface.GetString(id + t".stringName", "");
      weaponsVariants = TweakDBInterface.GetCNameArray(id + t".weaponVariants");
      if ArraySize(weaponsVariants) > 0 {
        this.GenerateNewWeaponItem(name, item, weaponsVariants);
      };
    };

    L(s"Generated records: \(this.counter)");
  }

  private func GenerateNewWeaponItem(baseName: String, baseRecord: ref<Item_Record>, variants: array<CName>) -> Void {
    let baseRecordId: TweakDBID = baseRecord.GetID();
    let baseRecordType: gamedataItemType = baseRecord.ItemType().Type();
    let variantRecord: ref<Item_Record>;
    let variantVisualTags: array<CName>;
    let firstTag: CName;
    let newRecordId: TweakDBID;
    let newRecordIdStr: String;
    let newRecordIdStrName: CName;
    let craftingVariants: array<TweakDBID>;
    let isPresetIconic: Bool;
    let projectileTemplateName: CName;
    let useProjectileAppearance: Bool;

    L(s"Generating variants for: \(TDBID.ToStringDEBUG(baseRecordId)) - \(baseName)");

    for variant in variants {
      variantRecord = TweakDBInterface.GetItemRecord(TDBID.Create(NameToString(variant)));
      variantVisualTags = variantRecord.VisualTags();
      isPresetIconic = TweakDBInterface.GetBool(TDBID.Create(s"\(variant).iconicVariant"), false);

      // -- GENERATE VISUAL TAG VARIANT
      if ArraySize(variantVisualTags) > 0 {
        firstTag = variantVisualTags[0];
        newRecordIdStr = s"\(baseName)_\(firstTag)";
        newRecordIdStrName = StringToName(newRecordIdStr);
        newRecordId = TDBID.Create(newRecordIdStr);
        TweakDBManager.CloneRecord(newRecordIdStrName, baseRecordId);
        // Set flats
        TweakDBManager.SetFlat(newRecordIdStrName + n".isPresetIconic", isPresetIconic);
        TweakDBManager.SetFlat(newRecordIdStrName + n".usesVariants", true);
        TweakDBManager.SetFlat(newRecordIdStrName + n".visualTags", variantVisualTags);
        TweakDBManager.SetFlat(newRecordIdStrName + n".iconPath", variantRecord.IconPath());
        // Add projectiles for knives
        if Equals(baseRecordType, gamedataItemType.Wea_Knife) {
          projectileTemplateName = TweakDBInterface.GetCName(baseRecordId + t".projectileTemplateName", n"");
          useProjectileAppearance = TweakDBInterface.GetBool(baseRecordId + t".useProjectileAppearance", false);
          L(s" ---- knife detected: \(projectileTemplateName) - \(useProjectileAppearance)");
          if NotEquals(projectileTemplateName, n"") {
            TweakDBManager.SetFlat(newRecordIdStrName + n".projectileTemplateName", projectileTemplateName);
          };
          TweakDBManager.SetFlat(newRecordIdStrName + n".useProjectileAppearance", useProjectileAppearance);
        };
        TweakDBManager.UpdateRecord(newRecordId);
        ArrayPush(craftingVariants, newRecordId);
        L(s" - generated - \(firstTag) variant for \(GetLocalizedTextByKey(baseRecord.DisplayName())): type \(baseRecord.Quality().Type()), iconic: \(isPresetIconic) -> \(newRecordIdStrName)");
        this.counter += 1;
      };
    };

    if ArraySize(craftingVariants) > 0 {
      TweakDBManager.SetFlat(baseRecordId + t".ecraftVariants", ToVariant(craftingVariants));
    };
  }
}
