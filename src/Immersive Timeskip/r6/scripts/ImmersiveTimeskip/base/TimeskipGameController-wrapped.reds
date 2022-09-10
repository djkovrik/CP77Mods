@wrapMethod(TimeskipGameController)
private final func Apply() -> Void {
  let options: inkAnimOptions;
  let player: ref<PlayerPuppet> = this.m_player as PlayerPuppet;

  if player.itsTimeskipActive {
    if !this.m_inputEnabled {
      return;
    };
    this.m_inputEnabled = false;
    if this.m_hoursToSkip > 0 {
      // GameTimeUtils.FastForwardPlayerState(this.GetPlayerControlledObject());
      this.PlayTictocAnimation();
      this.m_timeSkipped = true;
      options.toMarker = this.m_loopAnimationMarkerFrom;
      this.PlayAnimation(this.m_progressAnimation, options);
      this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnStartProgressionLoop");
    };
    GameInstance.GetAudioSystem(this.m_gameInstance).Play(n"ui_menu_map_timeskip");
  } else {
    wrappedMethod();
  };
}

@wrapMethod(TimeskipGameController)
protected cb func OnStartProgressionLoop(proxy: ref<inkAnimProxy>) -> Bool {
  wrappedMethod(proxy);
  let player: ref<PlayerPuppet> = this.m_player as PlayerPuppet;
  if player.itsTimeskipActive && this.m_hoursToSkip > 0 {
    player.EnableCustomTimeFastForward();
  };
}

@wrapMethod(TimeskipGameController)
protected cb func OnProgressAnimationFinished(proxy: ref<inkAnimProxy>) -> Bool {
  wrappedMethod(proxy);
  let player: ref<PlayerPuppet> = this.m_player as PlayerPuppet;
  if player.itsTimeskipActive {
    player.DisableCustomTimeFastForward();
  };
}


@wrapMethod(TimeskipGameController)
protected cb func OnCloseAfterFinishing(proxy: ref<inkAnimProxy>) -> Bool {
  wrappedMethod(proxy);
  this.FinalizeTimeskip();
}

@wrapMethod(TimeskipGameController)
protected cb func OnCloseAfterCanceling(proxy: ref<inkAnimProxy>) -> Bool {
  wrappedMethod(proxy);
  this.FinalizeTimeskip();
}

@wrapMethod(TimeskipGameController)
private final func PlayTictocAnimation() -> Void {
  wrappedMethod();
  let angle = Deg2Rad(inkWidgetRef.GetRotation(this.m_currentTimePointerRef));
  if angle > this.m_targetTimeAngle {
    this.itsInitialDiff = Rad2Deg(6.28 - angle + this.m_targetTimeAngle);
  } else {
    this.itsInitialDiff = Rad2Deg(this.m_targetTimeAngle - angle);
  };
  this.itsInitialTimestamp = this.m_timeSystem.GetGameTimeStamp();
  let skipPeriod: Float = Cast<Float>(this.m_hoursToSkip) * 3600.0;
  this.itsSecondsPerDegree = skipPeriod / this.itsInitialDiff;
}


@wrapMethod(TimeskipGameController)
protected cb func OnUpdate(timeDelta: Float) -> Bool {
  let a: Float;
  let d: Float;

  if !this.m_inputEnabled && this.m_player.itsTimeskipActive {
    if IsDefined(this.m_progressAnimProxy) && this.m_progressAnimProxy.IsPlaying() {
      a = Deg2Rad(inkWidgetRef.GetRotation(this.m_currentTimePointerRef));
      if a > this.m_targetTimeAngle {
        d = Rad2Deg(6.28 - a + this.m_targetTimeAngle);
      } else {
        d = Rad2Deg(this.m_targetTimeAngle - a);
      };
      this.FastForwardTimeCustom(d);
    };
  };

  wrappedMethod(timeDelta);
}
