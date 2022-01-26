module LimitedHudAnimators

@addMethod(inkGameController)
protected func AnimateAlphaLHUD(targetWidget: wref<inkWidget>, endAlpha: Float, duration: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
  transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
  transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
  transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
  transparencyInterpolator.SetEndTransparency(endAlpha);
  transparencyInterpolator.SetDuration(duration);
  moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
  proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
  return proxy;
}

@addMethod(inkGameController)
protected func AnimateAlphaLHUD(targetWidget: inkWidgetRef, endAlpha: Float, duration: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
  transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
  transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
  transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
  transparencyInterpolator.SetEndTransparency(endAlpha);
  transparencyInterpolator.SetDuration(duration);
  moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
  proxy = inkWidgetRef.PlayAnimation(targetWidget, moveElementsAnimDef);
  return proxy;
}
