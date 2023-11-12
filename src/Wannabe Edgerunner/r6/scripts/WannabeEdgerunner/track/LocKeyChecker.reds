import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

public class EdgerunnerInteractionChecker extends ScriptableEnv {
  let sleep: String = "LocKey#46418";
  let shower: String = "LocKey#46419";
  let donate: String = "LocKey#45546";
  let pet: array<String>;
  let apartment: array<String>;

  private cb func OnLoad() {
    this.pet = [ 
      "LocKey#39016", // Iguana
      "LocKey#32348", // Cat
      "LocKey#32183", // Nibbles
      "LocKey#32185"  // Nibbles
    ];
    this.apartment = [ 
      "LocKey#47352",   // Tea Set
      "LocKey#2061",    // Coffee Machine
      "LocKey#46089",   // Record player
      "LocKey#80877",   // Pool table
      "LocKey#45726",   // Incense
      "LocKey#39629"    // Guitar
    ];
  }

  public static func Check(locKey: String) -> HumanityRestoringAction {
    // LogChannel(n"DEBUG", s"locKey = \(locKey)");
    let env: ref<EdgerunnerInteractionChecker> = ScriptableEnv.Get(n"EdgerunnerInteractionChecker") as EdgerunnerInteractionChecker;
    if Equals(env.sleep, locKey) { return HumanityRestoringAction.Sleep; };
    if Equals(env.shower, locKey) { return HumanityRestoringAction.Shower; };
    if Equals(env.donate, locKey) { return HumanityRestoringAction.Donation; };
    if ArrayContains(env.pet, locKey) { return HumanityRestoringAction.Pet; };
    if ArrayContains(env.apartment, locKey) { return HumanityRestoringAction.Apartment; };

    return HumanityRestoringAction.Unknown;
  }
}
