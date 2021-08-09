// Press Z to toggle the game HUD
// kudos to psiberx for the events based approach sample

public class ToggleHudEvent extends Event {}

@addMethod(inkGameController)
protected cb func OnToggleHud(evt: ref<ToggleHudEvent>) -> Bool {
    let isVisible: Bool;
    if this.IsA(n"gameuiRootHudGameController") {
        isVisible = this.GetRootWidget().IsVisible();
        this.GetRootWidget().SetVisible(!isVisible);
    };
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    wrappedMethod(action, consumer);

    if ListenerAction.IsAction(action, n"brightness_settings") && ListenerAction.IsButtonJustReleased(action) {
        GameInstance.GetUISystem(this.GetGame()).QueueEvent(new ToggleHudEvent());
    };
}
