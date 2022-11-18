@if(ModuleExists("StreetStyle.main"))
import StreetStyle.main.StreetStyleMod
@if(ModuleExists("StreetStyle.main"))
import StreetStyle.main.StreetStyleProperties

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  this.AddEnhancedCraftItemsToStreetStyle();
}

@if(ModuleExists("StreetStyle.main"))
@addMethod(PlayerPuppet)
private func AddEnhancedCraftItemsToStreetStyle() -> Void {
  let ssm: wref<StreetStyleMod> = StreetStyleMod.GetInstance();
  let prop: ref<StreetStyleProperties>;
  let tdbid: TweakDBID;
  let variantsArray: array<TweakDBID>;

  for record in TweakDBInterface.GetRecords(n"Clothing") {
    tdbid = record.GetID();
    variantsArray = TweakDBInterface.GetForeignKeyArray(tdbid + t".ecraftVariants");
    if ArraySize(variantsArray) > 0 {
      prop = ssm.SearchStreetStyleDB(tdbid);
      for newItemId in variantsArray {
        ArrayPush(ssm.StreetStyleDB, StreetStyleProperties.CreateItem(
          newItemId, prop.Strength, prop.Reflexes, prop.Technical, prop.Intelligence, prop.Cool, prop.Style, prop.Affiliation)
        );
      };
    };
  };
}

@if(!ModuleExists("StreetStyle.main"))
@addMethod(PlayerPuppet)
private func AddEnhancedCraftItemsToStreetStyle() -> Void {
  // do nothing
}
