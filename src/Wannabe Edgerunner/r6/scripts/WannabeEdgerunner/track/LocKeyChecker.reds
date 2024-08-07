import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

public class EdgerunnerInteractionChecker extends ScriptableEnv {
  let sleep: array<String>;
  let shower: String = "LocKey#46419";
  let donate: String = "LocKey#45546";
  let pet: array<String>;
  let apartment: array<String>;
  let lover: array<String>;
  let social: array<String>;

  private cb func OnLoad() {
    this.sleep = [
	  "LocKey#46047",  // Interacting with lover while in bed, or as part of the sleep action when they are over.
	  "LocKey#46418"   // bed
	];
    this.pet = [ 
      "LocKey#39016", // Iguana
      "LocKey#32348", // Cat
      "LocKey#32183", // Nibbles
      "LocKey#32185", // Nibbles
	  "LocKey#80033", // Cat, near Pacifica Rollercoaster
	  "Elmo", // Deceptious Cat Petting Mod Support
	  "Nali", // Deceptious Cat Petting Mod Support
	  "Leia", // Deceptious Cat Petting Mod Support
	  "Jack", // Deceptious Cat Petting Mod Support
	  "Suzi", // Deceptious Cat Petting Mod Support
	  "Nibbles" // Deceptious Cat Petting Mod Support
    ];
	this.social = [
	  "LocKey#46442",  // Rollercoaster
	  "LocKey#48683",  // Rollercoaster, "raise hands" in excitement.
	  "LocKey#49986",  // Dance interaction; Triggers on dance start in vanilla. Triggers on selecting partner and going back in menu w/ Deceptious mods.
	  "LocKey#42930",  // Sitting down to drink or standing up to stop. Triggers on selecting partner and going back in menu w/ Deceptious mods.
	  "LocKey#6820"    // Actually drinking or talking to your drinking partner.
	];
	this.lover = [
	  "LocKey#34479",   // Judy @ her home and a few other places in the main story
      "Judy",           // Judy @ your house
	  "River",          // River @ his home and a few other places in the main story
	  "Kerry",          // Kerry @ his home and a few other places in the main story
	  "Panam"           // Panam @ her home and a few other places in the main story
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
    if ArrayContains(env.sleep, locKey) { return HumanityRestoringAction.Sleep; };
    if Equals(env.shower, locKey) { return HumanityRestoringAction.Shower; };
    if Equals(env.donate, locKey) { return HumanityRestoringAction.Donation; };
    if ArrayContains(env.pet, locKey) { return HumanityRestoringAction.Pet; };
    if ArrayContains(env.apartment, locKey) { return HumanityRestoringAction.Apartment; };
	if ArrayContains(env.lover, locKey) { return HumanityRestoringAction.Lover; };
	if ArrayContains(env.social, locKey) { return HumanityRestoringAction.Social; };

    return HumanityRestoringAction.Unknown;
  }
}