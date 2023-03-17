import Codeware.UI.*
import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.System.PurchasableVehicleSystem

@addField(WebPage) let purchaseSystem: ref<PurchasableVehicleSystem>;
@addField(WebPage) let vehiclesStock: array<ref<PurchasableVehicleBundle>>;
@addField(WebPage) let vehicleIndex: Int32;
@addField(WebPage) let vehicleVariantIndex: Int32;
@addField(WebPage) let vehicleLastIndex: Int32;
@addField(WebPage) let vehicleVariantLastIndex: Int32;
@addField(WebPage) let playerPuppet: wref<PlayerPuppet>;

@addField(WebPage) let dealerPanelRoot: wref<inkVerticalPanel>;
@addField(WebPage) let dealerPanelInfoContainer: wref<inkVerticalPanel>;
@addField(WebPage) let buttonPrev: wref<CustomHubButton>;
@addField(WebPage) let buttonNext: wref<CustomHubButton>;
@addField(WebPage) let buttonBuy: wref<CustomHubButton>;
@addField(WebPage) let buttonColor: wref<CustomHubButton>;
@addField(WebPage) let buttonFixer: wref<CustomHubButton>;

