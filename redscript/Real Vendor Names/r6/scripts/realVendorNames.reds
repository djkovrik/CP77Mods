@wrapMethod(WorldMapTooltipController)
public func SetData(const data: script_ref<WorldMapTooltipData>, menu: ref<WorldMapMenuGameController>) -> Void {
  wrappedMethod(data, menu);

  let vendorName: String = this.GetRealVendorName(data);
  let variant: gamedataMappinVariant = Deref(data).mappin.GetVariant();
  if NotEquals(vendorName, "") && NotEquals(variant, gamedataMappinVariant.ServicePointRipperdocVariant) {
    inkTextRef.SetText(this.m_titleText, vendorName);
  };
}

@addMethod(WorldMapTooltipController)
private func GetRealVendorName(const data: script_ref<WorldMapTooltipData>) -> String {
  let entry: String = Deref(data).journalEntry.GetId();
  let targetId: TweakDBID = TDBID.Create(s"Vendors.\(entry).localizedName");
  let vendorName: String = TweakDBInterface.GetString(targetId, "");

  // LogChannel(n"DEBUG", s"entry = \(entry), variant = \(Deref(data).mappin.GetVariant()), name = \(vendorName)");

  // Some hardcoded thingies
  switch entry {
    // Fingers M.D.
    case "wbr_jpn_netrunner_02":
      if Equals(Deref(data).mappin.GetVariant(), gamedataMappinVariant.ServicePointRipperdocVariant) {
        vendorName = "LocKey#45149";
      };
      if Equals(Deref(data).mappin.GetVariant(), gamedataMappinVariant.ServicePointNetTrainerVariant) {
        vendorName = "LocKey#45176";
      };
      break;
    // Chan Hoon Nam 
    case "wbr_jpn_netrun_02":
      vendorName = "LocKey#45176";
      break;
    // Ded Zed
    case "wat_nid_clothingshop_01":
      vendorName = "Ded Zed";
      break;
    // Stylishly
    case "std_rcr_cloth_01":
      vendorName = "LocKey#44380";
      break;
    // Stylishly
    case "hey_spr_cloth_01":
      vendorName = "LocKey#44380";
      break;
    // Stylishly
    case "wat_lch_clothingshop_01":
      vendorName = "LocKey#44380";
      break;
    // Capitan Caliente
    case "std_rcr_foodshop_01":
      vendorName = "LocKey#44384";
      break;
    // Gun-O-Rama
    case "std_rcr_guns_01":
      vendorName = "LocKey#44381";
      break;
    // Red Dirt
    case "std_arr_food_01":
      vendorName = "LocKey#44379";
      break;
    // 2nd Amendment
    case "hey_rey_guns_01":
      vendorName = "LocKey#45094";
      break;
    // 2nd Amendment
    case "hey_gle_guns_01":
      vendorName = "LocKey#45094";
      break;
    // 2nd Amendment
    case "pac_wwd_guns_01":
      vendorName = "LocKey#45094";
      break;
    // Dicky Twister
    case "hey_rey_food_02":
      vendorName = "LocKey#45076";
      break;
    // Avante
    case "cct_cpz_clothingstore_02":
      vendorName = "Avante";
      break;
    // Avante
    case "wbr_hil_clothingshop_01":
      vendorName = "Avante";
      break;
    // Red Peaks
    case "bls_ina_se1_foodshop_03":
      vendorName = "LocKey#51260";
      break;
    // Red Peaks
    case "bls_ina_se1_junkshop_01":
      vendorName = "LocKey#51260";
      break;
    // Fresh Food
    case "hey_spr_food_01":
      vendorName = "LocKey#45074";
      break;
    // El Pinche Pollo
    case "hey_gle_food_02":
      vendorName = "LocKey#45080";
      break;
    // Nina Kraviz
    case "wbr_hil_ripperdoc_01":
      vendorName = "LocKey#45150";
      break;
    // Ginger Panda
    case "wbr_jpn_food_04":
      vendorName = "LocKey#45066";
      break;
    // Christine Markov
    case "wbr_jpn_tech_01":
      vendorName = "LocKey#33127";
      break;
    // Shinto Shrine (Monk Merchant)
    case "wbr_jpn_junk_03":
      vendorName = "LocKey#45111";
      break;
    // The Manufactory - Weapons
    case "std_arr_guns_01":
      vendorName = s"\(GetLocalizedText("LocKey#21251")) - \(GetLocalizedText("LocKey#45222"))";
      break;
    // The Manufactory - Clothes
    case "std_arr_cloth_01":
      vendorName = s"\(GetLocalizedText("LocKey#21251")) - \(GetLocalizedText("LocKey#46807"))";
      break;
    // The Manufactory - Meds
    case "std_arr_medic_01":
      vendorName = s"\(GetLocalizedText("LocKey#21251")) - \(GetLocalizedText("LocKey#39888"))";
      break;
    // Jig-Jig Street - Dealer
    case "wbr_jpn_junk_02":
      vendorName = s"\(GetLocalizedText("LocKey#79214")) - \(GetLocalizedText("LocKey#47308"))";
      break;
    // Saeko's (Blossoming Sakura Clothier)
    case "wbr_jpn_cloth_01":
      vendorName = "LocKey#54065";
      break;
    // Old Nature Clinic
    case "cct_cpz_medicstore_01":
      vendorName = "LocKey#45135";
      break;
    // Spector Cheng
    case "wbr_jpn_ws_melee_01":
      vendorName = "LocKey#45164";
      break;
    // Ramen Joint
    case "wbr_jpn_food_01":
      vendorName = "LocKey#45063";
      break;
    // Just Food
    case "wbr_jpn_foodshop_05_japantown":
      vendorName = "LocKey#45067";
      break;
    // El Coyote Cojo
    case "hey_rey_food_01":
      vendorName = "LocKey#45075";
      break;
    // Pacifica Melee Vendor
    case "pac_wwd_ripperdoc_01":
      vendorName = "";
      break;
    default:
      // do nothing
      break;
  };

  return vendorName;
}
