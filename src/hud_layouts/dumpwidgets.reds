// Press F1 to dump widget tree

public class DumpWidgetTreeEvent extends Event {}

@addMethod(inkGameController)
protected cb func OnDumpWidgetTreeEvent(evt: ref<DumpWidgetTreeEvent>) -> Bool {
    if this.IsA(n"gameuiRootHudGameController") {
        PrintWidgetsTree(this.GetRootCompoundWidget(), 0, 0);
    }
}

public class DumpWidgetTreeInputListener {

  private let m_player: ref<PlayerPuppet>;

  public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
    this.m_player = player;
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if ListenerAction.IsAction(action, n"restore_default_settings") && ListenerAction.IsButtonJustReleased(action) {
      GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(new DumpWidgetTreeEvent());
    };
  }
}

@addField(PlayerPuppet)
private let m_inputListener: ref<DumpWidgetTreeInputListener>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();
    this.m_inputListener = new DumpWidgetTreeInputListener();
    this.m_inputListener.SetPlayer(this);
    this.RegisterInputListener(this.m_inputListener);
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();
    this.UnregisterInputListener(this.m_inputListener);
    this.m_inputListener = null;
}

@addField(inkWidget)
native let logicController: ref<inkLogicController>;

@addField(inkWidget)
native let secondaryControllers: array<ref<inkLogicController>>;

public static func BuildPrefix(str: String, level: Int32, counter: Int32) -> String {
  let result: String = "[Nested: " + ToString(level) + " - index: " + ToString(counter) +  "]";
  let i: Int32 = 0;

  while i < level {
    result += str;
    i += 1;
  };

  return result + " - ";
}

public static func WidgetAsString(node: ref<inkWidget>) -> String {
  return "[Class: " + NameToString(node.GetClassName()) + ", name: " + NameToString(node.GetName()) + ", state: " + NameToString(node.GetState()) + ", visible: " 
    + ToString(node.IsVisible()) + ", interactive: " + ToString(node.IsInteractive()) + ", affects layout when hidden: " + ToString(node.GetAffectsLayoutWhenHidden()) 
    + ", margin: " + ToString(node.GetMargin()) + ", padding: " + ToString(node.GetPadding()) + ", HAlign: " + ToString(node.GetHAlign()) 
    + ", VAlign: " + ToString(node.GetVAlign()) + ", anchor: " + ToString(node.GetAnchor()) 
    + ", anchor point: " + ToString(node.GetAnchorPoint()) + ", size rule: " + ToString(node.GetSizeRule()) + ", size coeff: " 
    + ToString(node.GetSizeCoefficient()) + ", fit to content: " + ToString(node.GetFitToContent()) + ", size: " + ToString(node.GetSize()) 
    + ", pivot: " + ToString(node.GetRenderTransformPivot()) + ", scale: " + ToString(node.GetScale()) + ", shear: " + ToString(node.GetShear()) 
    + ", rotation: " + ToString(node.GetRotation()) + ", translation: " + ToString(node.GetTranslation()) + "]";
}

public static func PrintWidgetsTree(node: ref<inkWidget>, level: Int32, counter: Int32) -> Void {
  let currentLevel = level + 1;
  let str: String = "";

  str += BuildPrefix("  ", currentLevel, counter);
  str += NameToString(node.GetName());
  str += " / ";

  if IsDefined(node.logicController) {
    str += NameToString(node.logicController.GetClassName());
    str += " / ";
  };

  str += WidgetAsString(node);

  if ArraySize(node.secondaryControllers) > 0 {
    str += ", Secondary controllers [";
    let j: Int32 = 0;
    while j < ArraySize(node.secondaryControllers) {
      str += " ";
      str += NameToString(node.secondaryControllers[j].GetClassName());
      str += ", ";
      j += 1;
    };
    str += "]";
  };

  LogChannel(n"DEBUG", str);

  if node.IsA(n"inkCompoundWidget") {
    let compound: wref<inkCompoundWidget> = node as inkCompoundWidget;
    let numChild: Int32 = compound.GetNumChildren();
    let i: Int32 = 0;

    while i < numChild {
      PrintWidgetsTree(compound.GetWidget(i), currentLevel, i);
      i += 1;
    };
  };
}
