import VirtualAtelier.Systems.VirtualAtelierPreviewManager

public abstract class AtelierInputHelper {
  
  public static func RegisterGlobalInputListeners(controller: ref<WardrobeSetPreviewGameController>) {
    controller.RegisterToGlobalInputCallback(n"OnPostOnPress", controller, n"OnGlobalPress");
    controller.RegisterToGlobalInputCallback(n"OnPostOnPress", controller, n"OnReleaseButton");
    controller.RegisterToGlobalInputCallback(n"OnPostOnRelative", controller, n"OnRelativeInput");
    controller.RegisterToGlobalInputCallback(n"OnPostOnHold", controller, n"OnPostOnHold");
  }

  public static func OnGarmentPreviewAxisInput(controller: ref<WardrobeSetPreviewGameController>, event: ref<inkPointerEvent>) -> Void {
    let amount: Float = event.GetAxisData();

    if event.IsAction(n"character_preview_rotate") {
      controller.Rotate(amount * -60.0);
    } else {
      if event.IsAction(n"left_trigger") {
        controller.Rotate(amount * -60.0);
      } else {
        if event.IsAction(n"right_trigger") {
          controller.Rotate(amount * 60.0);
        };
      };
    };
  }      

  public static func OnGarmentPreviewRelativeInput(controller: ref<WardrobeSetPreviewGameController>, event: ref<inkPointerEvent>) -> Bool {
    let previewWidget: ref<inkImage> = controller.GetRootCompoundWidget().GetWidgetByPath(inkWidgetPath.Build(n"wrapper", n"preview")) as inkImage;
    let widget: ref<inkWidget> = event.GetTarget();
    
    // Allow player puppet dragging and scrolling only for left side of the screen
    let screenPosition: Vector2 = event.GetScreenSpacePosition();
    let limit: Float = VirtualAtelierPreviewManager.GetInstance(controller.GetPlayerControlledObject().GetGame()).GetScreenWidthLimit();
    let isScaleAllowed: Bool = screenPosition.X < limit;

    if !Equals(NameToString(widget.GetName()), "None") {
      return true;
    } else {
      let amount: Float = event.GetAxisData();
      let zoomRatio: Float = 0.1;

      if controller.isLeftMouseDown {
        if event.IsAction(n"mouse_x") && isScaleAllowed {
          previewWidget.ChangeTranslation(new Vector2(amount, 0.0));      
        };
        if event.IsAction(n"mouse_y") && isScaleAllowed {
          previewWidget.ChangeTranslation(new Vector2(0.0, -1.0 * amount));
        };
      };

      if event.IsAction(n"mouse_wheel") && isScaleAllowed {
        let currentScale = previewWidget.GetScale();

        let finalXScale = currentScale.X + (amount * zoomRatio);
        let finalYScale = currentScale.Y + (amount * zoomRatio);

        if (finalXScale < 0.5) {
          finalXScale = 0.5;
        };

        if (finalYScale > 3.0) {
          finalYScale = 3.0;
        };

        if (finalYScale < 0.5) {
          finalYScale = 0.5;
        };

        if (finalXScale > 3.0) {
          finalXScale = 3.0;
        };
            
        previewWidget.SetScale(new Vector2(finalXScale, finalYScale));
      }; 
    };

    return true;
  }
}
