import Codeware.UI.*
import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.Classes.PurchasableVehicleVariant
import CarDealer.System.PurchasableVehicleSystem
import CarDealer.Utils.DealerTexts
import CarDealer.Utils.CarDealerLog

// Show core dealer page
@addMethod(WebPage)
private func PopulateDealerView(owner: ref<GameObject>) {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  this.dealerPanelRoot = root.GetWidget(n"page") as inkCompoundWidget;
  this.dealerPanelRoot.RemoveAllChildren();
  this.dealerPanelRoot.SetInteractive(true);
  this.GetRootCompoundWidget().SetInteractive(true);

  let player: ref<PlayerPuppet> = owner as PlayerPuppet;
  if IsDefined(player) {
    this.playerPuppet = player;
  };

  this.SpawnFromExternal(
    this.dealerPanelRoot, 
    r"base\\gameplay\\gui\\dealer.inkwidget", 
    n"CarDealer:CarDealer.Content.CarDealerContentController"
  );
}
