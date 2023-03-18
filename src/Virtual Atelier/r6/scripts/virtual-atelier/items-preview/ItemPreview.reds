@wrapMethod(ItemPreviewGameController)
protected cb func OnRelativeInput(e: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(e);

  if e.IsAction(n"mouse_wheel") {
      let previewWidgetPath: inkWidgetPath = inkWidgetPath.Build(n"wrapper", n"preview");
      let previewWidget: ref<inkWidget> = this.GetRootCompoundWidget().GetWidgetByPath(previewWidgetPath) as inkImage;

      let number: Float = e.GetAxisData();
      let ratio: Float = 0.25;
      let currentScale: Vector2 = previewWidget.GetScale();
      let finalXScale = currentScale.X + (number * ratio);
      let finalYScale = currentScale.Y + (number * ratio);

      if (finalXScale < 0.25) {
        finalXScale = 0.25;
      };

      if (finalYScale > 2.0) {
        finalYScale = 2.0;
      };

      if (finalYScale < 0.25) {
        finalYScale = 0.25;
      };

      if (finalXScale > 2.0) {
        finalXScale = 2.0;
      };
    
      previewWidget.SetScale(new Vector2(finalXScale, finalYScale));
  };
}
