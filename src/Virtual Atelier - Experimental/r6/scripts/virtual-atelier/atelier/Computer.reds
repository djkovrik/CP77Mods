import VendorPreview.Config.VirtualAtelierConfig
import VendorPreview.Utils.AtelierLog

@wrapMethod(ComputerInkGameController)
private final func ShowMenuByName(elementName: String) -> Void {
  if Equals(elementName, "Atelier") {
    this.GetMainLayoutController().ShowInternet("Atelier");
    this.RequestMainMenuButtonWidgetsUpdate();
  } else {
    wrappedMethod(elementName);
  };
}

@wrapMethod(ComputerControllerPS)
public final func GetMenuButtonWidgets() -> array<SComputerMenuButtonWidgetPackage> {
  let packages: array<SComputerMenuButtonWidgetPackage> = wrappedMethod();
  let package: SComputerMenuButtonWidgetPackage;

  let isInSafeZone: Bool = CurrentPlayerZoneManager.IsInSafeZone(this.GetLocalPlayerControlledGameObject() as PlayerPuppet) || VirtualAtelierConfig.DisableDangerZoneChecker();

  if isInSafeZone {
    if this.IsMenuEnabled(EComputerMenuType.INTERNET) && ArraySize(packages) > 0 {
      package.widgetName = "Atelier";
      package.displayName = VirtualAtelierText.Name();
      package.ownerID = this.GetID();
      package.iconID = n"iconInternet";
      package.widgetTweakDBID = this.GetMenuButtonWidgetTweakDBID();
      package.isValid = true;
      ArrayPush(packages, package);
    };
  } else {
    AtelierLog("PC is in dangerous or restricted zone, Atelier tab was hidden");
  };

  return packages;
}
