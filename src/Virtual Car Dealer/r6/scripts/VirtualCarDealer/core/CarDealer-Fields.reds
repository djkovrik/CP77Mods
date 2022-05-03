import CarDealer.Codeware.UI.*
import CarDealer.Classes.PurchasableVehicle
import CarDealer.System.PurchasableVehicleSystem

@addField(WebPage)
let dealerPanelRoot: ref<inkVerticalPanel>;

@addField(WebPage)
let dealerPanelInfoContainer: ref<inkVerticalPanel>;

@addField(WebPage)
let purchaseSystem: ref<PurchasableVehicleSystem>;

@addField(WebPage)
let vehiclesStock: array<ref<PurchasableVehicle>>;

@addField(WebPage)
let vehicleIndex: Int32;

@addField(WebPage)
let vehicleLastIndex: Int32;

@addField(WebPage)
let buttonPrev: ref<CustomHubButton>;

@addField(WebPage)
let buttonNext: ref<CustomHubButton>;

@addField(WebPage)
let buttonBuy: ref<CustomHubButton>;

@addField(WebPage)
let playerPuppet: wref<PlayerPuppet>;
