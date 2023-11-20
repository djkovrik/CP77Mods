module Edgerunning.Core

class EdgerunningScriptableTweak extends ScriptableTweak {
  protected cb func OnApply() -> Void {
    let config: ref<EdgerunningConfig> = new EdgerunningConfig();
    // Prices
    this.CreatePriceRecord(t"Price.RipperdocMedModifierCommon", config.neuroblockersPriceCommon);
    this.CreatePriceRecord(t"Price.RipperdocMedModifierUncommon", config.neuroblockersPriceUncommon);
    this.CreatePriceRecord(t"Price.RipperdocMedModifierRare", config.neuroblockersPriceRare);
    this.CreatePriceRecord(t"Price.RipperdocMedModifierRecipeCommon", config.neuroblockersRecipePriceCommon);
    this.CreatePriceRecord(t"Price.RipperdocMedModifierRecipeUncommon", config.neuroblockersRecipePriceUncommon);
    this.CreatePriceRecord(t"Price.RipperdocMedModifierRecipeRare", config.neuroblockersRecipePriceRare);
    // Duration
    let id: TweakDBID;
    let modifiers: array<wref<StatModifier_Record>>;
    let durationRecord: ref<StatModifierGroup_Record> = TweakDBInterface.GetStatModifierGroupRecord(t"Items.EdgerunnerPsychosisDuration");
    if IsDefined(durationRecord) {
      durationRecord.StatModifiers(modifiers);
      if ArraySize(modifiers) > 0 {
        id = modifiers[0].GetID();
        TweakDBManager.SetFlat(id + t".value", config.psychoDuration);
        TweakDBManager.UpdateRecord(id);
      };
    };
  }

  private func CreatePriceRecord(name: TweakDBID, value: Int32) -> Void {
    let price: Float = Cast<Float>(value);
    TweakDBManager.SetFlat(name + t".value", price);
    TweakDBManager.UpdateRecord(name);
  }
}
