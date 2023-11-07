import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

@addField(PlayerStateMachineDef)
public let HumanityDamage: BlackboardID_Int;

@addField(inkGameController)
let humanityCounter: ref<inkText>;  

@addField(InventoryTooltipData)
public let humanity: Int32;

@addField(RipperDocGameController)
public let edgerunningSystem: wref<EdgerunningSystem>;

@addField(RipperDocGameController)
public let humanityIcon: ref<inkImage>;

@addField(RipperDocGameController)
public let humanityLabel: ref<inkText>;

@addField(RipperDocGameController)
public let humanityBarFull: ref<inkRectangle>;

@addField(RipperDocGameController)
public let humanityBarProgress: ref<inkRectangle>;

@addField(ItemTooltipCommonController)
public let humanityLabel: ref<inkText>;

@addField(healthbarWidgetGameController)
public let humanityBarContainer: ref<inkCanvas>;

@addField(healthbarWidgetGameController)
public let humanityBarFull: ref<inkRectangle>;

@addField(healthbarWidgetGameController)
public let humanityBarProgress: ref<inkRectangle>;

@addField(healthbarWidgetGameController)
public let edgerunningSystem: ref<EdgerunningSystem>;

@addField(RipperdocBarTooltipTooltipData)
public let isHumanityTooltip: Bool;

@addField(RipperdocBarTooltipTooltipData)
public let humanityCurrent: Int32;

@addField(RipperdocBarTooltipTooltipData)
public let humanityTotal: Int32;

@addField(RipperdocBarTooltipTooltipData)
public let humanityAdditionalDesc: String;
