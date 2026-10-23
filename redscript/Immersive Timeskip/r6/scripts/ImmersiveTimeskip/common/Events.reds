module ImmersiveTimeskip.Events

public class OpenTimeSkipMenuEvent extends Event {}

public class InterruptCustomTimeSkipEvent extends Event {}

public class TimeSkipMenuVisibilityEvent extends Event {
  public let visible: Bool;
}
