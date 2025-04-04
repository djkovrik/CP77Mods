module AtelierDelivery

@if(ModuleExists("VirtualAtelier.Compat"))
import VirtualAtelier.Compat.VersionManager

@if(ModuleExists("NumeralsGetCommas.Functions"))
import NumeralsGetCommas.Functions.*    

public abstract class CompatManager {
  public final static func RequiredAtelierVersionCode() -> Int32 = 1302
  public final static func RequiredAtelierVersionName() -> String = "1.3.2"
}

@if(ModuleExists("VirtualAtelier.Compat"))
@addMethod(SingleplayerMenuGameController)
private final func GetCurrentAtelierVersionCode() -> Int32 {
  return VersionManager.VersionCode();
}

@if(!ModuleExists("VirtualAtelier.Compat"))
@addMethod(SingleplayerMenuGameController)
private final func GetCurrentAtelierVersionCode() -> Int32 {
  return 0;
}

@if(ModuleExists("VirtualAtelier.Compat"))
@addMethod(SingleplayerMenuGameController)
private final func GetCurrentAtelierVersionName() -> String {
  return VersionManager.VersionName();
}

@if(!ModuleExists("VirtualAtelier.Compat"))
@addMethod(SingleplayerMenuGameController)
private final func GetCurrentAtelierVersionName() -> String {
  return "<= 1.2.10";
}

@if(ModuleExists("VendorPreview.Config"))
@addMethod(SingleplayerMenuGameController)
private final func IsAtelierMissing() -> Bool {
  return false;
}

@if(!ModuleExists("VendorPreview.Config"))
@addMethod(SingleplayerMenuGameController)
private final func IsAtelierMissing() -> Bool {
  return true;
}

@addField(SingleplayerMenuGameController)
protected let atelierDetectionPopup: ref<inkGameNotificationToken>;

@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let message: String = "";
  let hasNoAtelierInstalled: Bool = this.IsAtelierMissing();
  let hasIncompatibleAtelierVersion: Bool = this.GetCurrentAtelierVersionCode() < CompatManager.RequiredAtelierVersionCode();

  if hasNoAtelierInstalled {
    message = GetLocalizedTextByKey(n"Mod-VAD-Error-No-VA");
  } else if hasIncompatibleAtelierVersion {
    message = s"\(GetLocalizedTextByKey(n"Mod-VAD-Error-VA-Required")) \(CompatManager.RequiredAtelierVersionName())+.\n" + 
      s"\(GetLocalizedTextByKey(n"Mod-VAD-Error-VA-Current")): \(this.GetCurrentAtelierVersionName())";
  };

  if hasNoAtelierInstalled || hasIncompatibleAtelierVersion {
    this.atelierDetectionPopup = GenericMessageNotification.Show(
      this, 
      GetLocalizedText("LocKey#11447"), 
      message,
      GenericMessageNotificationType.OK
    );

    this.atelierDetectionPopup.RegisterListener(this, n"OnAtelierDetectionPopupClosed");
  };
}

@addMethod(SingleplayerMenuGameController)
protected cb func OnAtelierDetectionPopupClosed(data: ref<inkGameNotificationData>) {
  this.atelierDetectionPopup = null;
}

@if(!ModuleExists("NumeralsGetCommas.Functions"))
public static final func GetFormattedMoneyVAD(money: Int32) -> String {
  return IntToString(money);
}

@if(ModuleExists("NumeralsGetCommas.Functions"))
public static final func GetFormattedMoneyVAD(money: Int32) -> String {
  return CommaDelineateInt32(money);
}
