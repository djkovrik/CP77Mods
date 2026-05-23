// Wannabe Edgerunner Add-on - module-level helper ╰(*°▽°*)╯

module Edgerunning.System

// what game-day is it - used by the cigarette counter to know when to reset
public static func WEA_GetGameDay(gi: GameInstance) -> Int32 {
    let gameTime = GameInstance.GetTimeSystem(gi).GetGameTime();
    return GameTime.Days(gameTime);
}
