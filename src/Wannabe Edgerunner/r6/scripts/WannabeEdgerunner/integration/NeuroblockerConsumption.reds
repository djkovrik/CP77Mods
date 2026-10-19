@wrapMethod(ConsumeAction)
protected func ProcessStatusEffects(const actionEffects: script_ref<array<wref<ObjectActionEffect_Record>>>, gameInstance: GameInstance) -> Void {
  let itemData: wref<gameItemData> = this.GetItemData();
  let itemID: TweakDBID = ItemID.GetTDBID(itemData.GetID());
  let neuroblockerEffectID: TweakDBID;
  switch itemID {
    case t"Items.ripperdoc_med_common":
      neuroblockerEffectID = t"BaseStatusEffect.RipperDocMedBuffCommon";
      break;
    case t"Items.ripperdoc_med_uncommon":
      neuroblockerEffectID = t"BaseStatusEffect.RipperDocMedBuffUncommon";
      break;
    case t"Items.ripperdoc_med":
      neuroblockerEffectID = t"BaseStatusEffect.RipperDocMedBuff";
      break;
    default:
      wrappedMethod(actionEffects, gameInstance);
      return;
  };

  // The engine enum has no neuroblocker family. Its grouping pass can remove unrelated buffs;
  // bypass it only for our items and refresh the same effect without a protection gap.
  if ArraySize(Deref(actionEffects)) == 0 { return; };
  let executor: wref<GameObject> = this.GetExecutor();
  let executorID: EntityID = executor.GetEntityID();
  let statusSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(gameInstance);
  let duration: Float = itemData.GetStatValueByType(gamedataStatType.MaxDuration);
  let actionEffect: wref<ObjectActionEffect_Record>;
  let effect: wref<StatusEffect_Record>;
  let effectID: TweakDBID;
  let refreshed: Bool;
  let i: Int32 = 0;
  while i < ArraySize(Deref(actionEffects)) {
    actionEffect = Deref(actionEffects)[i];
    if IsDefined(actionEffect) {
      effect = actionEffect.StatusEffect();
      if IsDefined(effect) {
        effectID = effect.GetID();
        refreshed = false;
        if effectID == neuroblockerEffectID && duration > 0.0 && statusSystem.HasStatusEffect(executorID, effectID) {
          refreshed = statusSystem.SetStatusEffectRemainingDuration(executorID, effectID, duration);
        };
        if !refreshed {
          StatusEffectHelper.ApplyStatusEffect(executor, effectID, itemID);
        };
      };
    };
    i += 1;
  };
}
