module LimitedHudAnimators

@addMethod(inkGameController)
protected func AnimateScale(targetWidget: wref<inkWidget>, startScale: Float, endScale: Float, duration: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let scaleInterpolator: ref<inkAnimScale> = new inkAnimScale();
  scaleInterpolator.SetType(inkanimInterpolationType.Linear);
  scaleInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
  scaleInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
  scaleInterpolator.SetStartScale(new Vector2(startScale, startScale));
  scaleInterpolator.SetEndScale(new Vector2(endScale, endScale));
  scaleInterpolator.SetDuration(duration);
  moveElementsAnimDef.AddInterpolator(scaleInterpolator);
  proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
  proxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnScaleStarted");
  proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnScaleCompleted");
  return proxy;
}

@addMethod(inkGameController)
protected func AnimateTranslation(targetWidget: wref<inkWidget>, startTranslation: Float, endTranslation: Float, duration: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
  translationInterpolator.SetType(inkanimInterpolationType.Exponential);
  translationInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
  translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
  translationInterpolator.SetStartTranslation(new Vector2(startTranslation, 0.00));
  translationInterpolator.SetEndTranslation(new Vector2(endTranslation, 0.00));
  translationInterpolator.SetDuration(duration);
  moveElementsAnimDef.AddInterpolator(translationInterpolator);
  proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
  proxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnTranslationStarted");
  proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnTranslationCompleted");
  return proxy;
}

@addMethod(inkGameController)
protected func AnimateSize(targetWidget: wref<inkWidget>, startSize: Vector2, endSize: Vector2, duration: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let sizeInterpolator: ref<inkAnimSize> = new inkAnimSize();
  sizeInterpolator.SetType(inkanimInterpolationType.Linear);
  sizeInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
  sizeInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
  sizeInterpolator.SetStartSize(startSize);
  sizeInterpolator.SetEndSize(endSize);
  sizeInterpolator.SetDuration(duration * 1.50);
  moveElementsAnimDef.AddInterpolator(sizeInterpolator);
  proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
  proxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnSizeStarted");
  proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnSizeCompleted");
  return proxy;
}

@addMethod(inkGameController)
protected func AnimateAlpha(targetWidget: wref<inkWidget>, endAlpha: Float, duration: Float) -> ref<inkAnimProxy> {
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
  proxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnAlphaStarted");
  proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnAlphaCompleted");
  return proxy;
}

@addMethod(inkGameController)
protected func AnimateAlpha(targetWidget: wref<inkWidget>, startAlpha: Float, endAlpha: Float, duration: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
  transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
  transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
  transparencyInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
  transparencyInterpolator.SetStartTransparency(startAlpha);
  transparencyInterpolator.SetEndTransparency(endAlpha);
  transparencyInterpolator.SetDuration(duration);
  moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
  proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
  proxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnAlphaStarted");
  proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnAlphaCompleted");
  return proxy;
}

@addMethod(inkGameController)
protected func AnimateColor(targetWidget: ref<inkWidget>, startColor: HDRColor, endColor: HDRColor, duration: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let colorElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let colorInterpolator: ref<inkAnimColor> = new inkAnimColor();
  colorInterpolator.SetType(inkanimInterpolationType.Linear);
  colorInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
  colorInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
  colorInterpolator.SetStartColor(startColor);
  colorInterpolator.SetEndColor(endColor);
  colorInterpolator.SetDuration(duration);
  colorElementsAnimDef.AddInterpolator(colorInterpolator);
  proxy = targetWidget.PlayAnimation(colorElementsAnimDef);
  proxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnColorStarted");
  proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnColorCompleted");
  return proxy;
}

/**

  Callback:

  @addMethod(TargetClass)
  protected cb func OnColorStarted(anim: ref<inkAnimProxy>) -> Bool {
    // do stuff
  }

*/