// Wannabe Edgerunner Add-on - cigarette humanity (ー_ー)旦~~
// compatible with vanilla, FAC, Consumable Animations, Dark Future smoking items

module Edgerunning.System
import Edgerunning.Common.*

// 5-param overload
@wrapMethod(ItemActionsHelper)
public final static func ProcessItemAction(gi: GameInstance, executor: wref<GameObject>, itemData: wref<gameItemData>, actionID: TweakDBID, fromInventory: Bool) -> Bool {
    let result = wrappedMethod(gi, executor, itemData, actionID, fromInventory);
    if result && IsDefined(itemData) {
        WEA_TrySmokeCigarette(gi, executor, itemData, actionID);
    };
    return result;
}

// 6-param overload with quantity
@wrapMethod(ItemActionsHelper)
public final static func ProcessItemAction(gi: GameInstance, executor: wref<GameObject>, itemData: wref<gameItemData>, actionID: TweakDBID, fromInventory: Bool, quantity: Int32) -> Bool {
    let result = wrappedMethod(gi, executor, itemData, actionID, fromInventory, quantity);
    if result && IsDefined(itemData) {
        WEA_TrySmokeCigarette(gi, executor, itemData, actionID);
    };
    return result;
}

public static func WEA_TrySmokeCigarette(gi: GameInstance, executor: wref<GameObject>, itemData: wref<gameItemData>, actionID: TweakDBID) -> Void {
    let player = executor as PlayerPuppet;
    if !IsDefined(player) { return; };

    let config = WEAConfig.Get();
    if !config.smokeEnabled { return; };

    // only Consume/Eat/Drink actions
    let actionRecord = TweakDBInterface.GetObjectActionRecord(actionID);
    if !IsDefined(actionRecord) { return; };
    let actionType = actionRecord.ActionName();
    if !Equals(actionType, n"Consume") && !Equals(actionType, n"Eat") && !Equals(actionType, n"Drink") {
        return;
    };

    let itemRecord = TweakDBInterface.GetItemRecord(itemData.GetID().GetTDBID());
    if !IsDefined(itemRecord) { return; };
    if !WEA_IsCigarette(itemRecord) { return; };

    let sys = EdgerunningSystem.GetInstance(gi);
    if !IsDefined(sys) { return; };

    let today = WEA_GetGameDay(gi);
    let lastDay = sys.WEA_GetSmokeLastDay();

    // new day resets counter
    if today != lastDay {
        sys.WEA_SetSmokeCount(0);
        sys.WEA_SetSmokeLastDay(today);
    };

    let smokeCount = sys.WEA_GetSmokeCount();
    if smokeCount >= config.smokeDailyLimit {
        return;
    };

    sys.WEA_SetSmokeCount(smokeCount + 1);
    sys.RemoveHumanityDamage(config.smokeRestoreAmount);
    E("! Smoked a cigarette, humanity restored (" + ToString(smokeCount + 1) + "/" + ToString(config.smokeDailyLimit) + ")");
}

// checks multiple signals for mod compatibility
public static func WEA_IsCigarette(record: ref<Item_Record>) -> Bool {
    if record.TagsContains(n"DarkFutureAnimSmoking") { return true; };
    if record.TagsContains(n"Smoking") { return true; };
    if record.TagsContains(n"Cigarette") { return true; };

    let recordName = TDBID.ToStringDEBUG(record.GetID());
    if StrContains(recordName, "Cigarette") { return true; };
    if StrContains(recordName, "cigarette") { return true; };
    if StrContains(recordName, "Cigar") { return true; };

    return false;
}
