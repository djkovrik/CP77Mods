# Gameplay restrictions, player state machines and audio

Read for temporary player locks, custom PSMs or sound playback. Reviewed 2026-11-02; wiki examples are starting points. Local source checks below establish static behavior, not in-game acceptance.

## Temporary restrictions and fast travel

Trace the exact restriction and its consumers. `VehicleNoInteraction` inherits a savable, infinite-duration status-effect base in the local REDmod database. For a temporary mod-owned restriction, consider a uniquely named clone with `savable: false` after verifying consumers use inherited tags rather than the original record ID. Inspect TweakXL diagnostics and test save/load with the effect active. Remove only the mod's own effect IDs; removing a vanilla effect on attachment can undo a quest's lock. A nonpersistent field alone cannot track an effect that survives loading. Use the existing player-attachment lifecycle rules, rather than the guide's shortcut hook. [Restriction guide][restriction]

Fast travel has a separate named-lock API. Use a unique reason and pair acquisition/release on normal exit, cancellation and restoration. The local `core/systems/fastTravelSystem.swift` shows:

- Static `AddFastTravelLock`/`RemoveFastTravelLock` queue requests; they are not immediate state changes.
- `m_fastTravelLocks` is persistent. `EvaluateFastTravelLocksOnRestore` removes a lock with a valid linked status-effect ID only when that effect is absent from the player. The wiki's unconditional reload-expiry claim is too broad. An unlinked lock has no such restore cleanup.
- Removal identifies the lock by reason. `RemoveAllFastTravelLocks` clears other owners' locks too; normal mod cleanup should release only its own reason.
- Add/remove scan the lock array. A state change can queue updates across all registered fast-travel points; the DataTerm handler performs interaction/UI work. Update locks when the blocking condition changes, rather than per frame or per UI row. Native status-effect lookup and downstream UI costs remain unknown.

Acceptance includes restart/load with an active lock, interrupted behavior, other quest/mod locks and recovery or uninstall behavior. This project's localization policy applies to any explanation shown to the player.

## Player state machines

PSM configuration uses free flats, including `playerStateMachine.*`, `playerStateMachineDefinitions.*` and the state package. Preserve scalar/array element types explicitly when creating flats through TweakXL; a record-shaped YAML mapping is not a substitute. Register the definition and execution list, and keep `transitionTo` and `transitionCondition` aligned by index. [PSM guide][psm]

Check the real Decisions/Events class names, capitalization, callback signatures and owner against local PSM sources. Pair on-demand add/remove events. `hasOnUpdate`, `hasOnTick` and condition flags control callbacks: prefer change listeners or an appropriate tick for expensive checks; unregister listeners on detach. Native `EnableOnEnterCondition` exists and game transitions use listener-driven gating; its internal cost is unknown. Verify transition conditions, load/player changes and cleanup before enabling the machine by default.

## Audio playback and scheduling

Resolve a sound's event identifier separately from its archive path/hash. Local `core/entity/gameObject.swift::PlaySoundEvent` creates an `AudioEvent` and queues it on `self`; it does not implement the tutorial's claimed null-target/global-audio fallback. Validate the target and session before calling. [Playback guide][playback]

For Audioware, inspect the installed manifest schema, emitter API and lifecycle before use; classify `r6/audioware` YAML as Audioware input, not TweakXL. The example schedules a new delayed callback on every hit and extends the last callback's remaining delay. That serializes requests but does not bound their count. Choose cooldown, coalescing or an intentionally bounded queue, track/cancel pending work and validate the emitter after despawn/session change. Do not reuse the example as a debounce implementation or assume its signatures/static field are valid locally. [Audioware guide][audioware]

[restriction]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/world-editing/miscellaneous/apply-gameplayrestriction
[psm]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/everything-else/player-state-machines
[playback]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/sound/playing-sounds-in-game-basics
[audioware]: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/sound/custom-sounds-and-custom-emitters-with-audioware
