import CarDealer.Codeware.UI.*
import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.System.PurchasableVehicleSystem

@addField(WebPage)
let dealerPanelRoot: ref<inkVerticalPanel>;

@addField(WebPage)
let dealerPanelInfoContainer: ref<inkVerticalPanel>;

@addField(WebPage)
let purchaseSystem: ref<PurchasableVehicleSystem>;

@addField(WebPage)
let vehiclesStock: array<ref<PurchasableVehicleBundle>>;

@addField(WebPage)
let vehicleIndex: Int32;

@addField(WebPage)
let vehicleVariantIndex: Int32;

@addField(WebPage)
let vehicleLastIndex: Int32;

@addField(WebPage)
let vehicleVariantLastIndex: Int32;

@addField(WebPage)
let buttonPrev: ref<CustomHubButton>;

@addField(WebPage)
let buttonNext: ref<CustomHubButton>;

@addField(WebPage)
let buttonBuy: ref<CustomHubButton>;

@addField(WebPage)
let buttonColor: ref<CustomHubButton>;

@addField(WebPage)
let playerPuppet: wref<PlayerPuppet>;

@addField(WebPage)
let infoPanel: ref<inkFlex>;

@addField(WebPage)
let carName: ref<inkText>;

@addField(WebPage)
let carPrice: ref<inkText>;

@addField(WebPage)
let carImage: ref<inkImage>;

@addField(WebPage)
let carStatus: ref<inkText>;
