import Codeware.UI.*
import Codeware.Localization.*

@addField(WorldMapMenuGameController)
let mpgUiSystem: wref<UISystem>;

@addField(WorldMapMenuGameController)
let metroButtonNavigate: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
let metroButtonCancel: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
let metroButtonStop: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
let metroButtonConfirm: wref<PocketMetroNavButton>;

@addField(WorldMapMenuGameController)
let routeSelectionEnabled: Bool;

@addField(WorldMapMenuGameController)
let previousCustomFilters: array<Int32>;

@addField(WorldMapMenuGameController)
let departureLabel: wref<inkText>;

@addField(WorldMapMenuGameController)
let destinationLabel: wref<inkText>;

@addField(WorldMapMenuGameController)
let activeRouteDetails: wref<inkText>;

@addField(WorldMapMenuGameController)
let mpgTranslator: ref<LocalizationSystem>;

@addField(WorldMapMenuGameController)
let pulseDeparture: ref<PulseAnimation>;

@addField(WorldMapMenuGameController)
let pulseDestination: ref<PulseAnimation>;

@addField(WorldMapMenuGameController)
let currentHoveredController: ref<BaseWorldMapMappinController>;

@addField(BaseWorldMapMappinController)
let selectionGlow: wref<inkImage>;

@wrapMethod(WorldMapMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.mpgUiSystem = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());

  this.AddMetroPocketGuideControls();
  this.AddMetroPocketGuideLabels();
  this.InvalidateActiveRouteState();

  this.pulseDeparture = new PulseAnimation();
  this.pulseDeparture.Configure(this.departureLabel, 1.0, 0.05, 1.0);

  this.pulseDestination = new PulseAnimation();
  this.pulseDestination.Configure(this.destinationLabel, 1.0, 0.05, 1.0);
}
