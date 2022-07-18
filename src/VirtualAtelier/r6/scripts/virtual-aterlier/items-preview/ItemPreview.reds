@replaceMethod(ItemPreviewGameController)
 protected cb func OnGlobalRelease(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"mouse_left") {
      this.m_isMouseDown = false;
    };
    if e.IsAction(n"cancel") {
      this.m_data.token.TriggerCallback(null);
    };
  }

@replaceMethod(ItemPreviewGameController)
protected cb func OnRelativeInput(e: ref<inkPointerEvent>) -> Bool {
    let amount: Float = e.GetAxisData();
    let ration: Float = 0.25;

    if this.m_isMouseDown {
      if e.IsAction(n"mouse_x") {
        this.RotateVector(new Vector3(0.00, 0.00, amount * ration));
      };
      if e.IsAction(n"mouse_y") {
        this.RotateVector(new Vector3(0.00, amount * ration, 0.00));
      };
    };

    if e.IsAction(n"mouse_wheel") {
        let previewWidgetPath = inkWidgetPath.Build(n"wrapper", n"preview");
        let previewWidget = this.GetRootCompoundWidget().GetWidgetByPath(previewWidgetPath) as inkImage;

        let currentScale = previewWidget.GetScale();

        let finalXScale = currentScale.X + (amount * ration);
        let finalYScale = currentScale.Y + (amount * ration);

        if (finalXScale < 0.25) {
            finalXScale = 0.25;
        }

        if (finalYScale > 2.0) {
            finalYScale = 2.0;
        }

        if (finalYScale < 0.25) {
            finalYScale = 0.25;
        }

        if (finalXScale > 2.0) {
            finalXScale = 2.0;
        }
      
        previewWidget.SetScale(new Vector2(finalXScale, finalYScale));
    };
}