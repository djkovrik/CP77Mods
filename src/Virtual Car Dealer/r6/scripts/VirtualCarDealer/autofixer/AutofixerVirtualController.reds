module CarDealer
import CarDealer.System.PurchasableVehicleSystem
import CarDealer.Classes.VehiclesListTemplateClassifier
import CarDealer.Classes.AutofixerSellEvent
import CarDealer.Classes.AutofixerItemData

public class AutofixerVirtualController extends inkGameController {
  private let m_vehiclesList: ref<inkVirtualGridController>;
  private let m_vehiclesListScrollController: wref<inkScrollController>;
  private let m_vehiclesDataSource: ref<ScriptableDataSource>;
  private let m_vehiclesDataView: ref<AutofixerItemDataView>;
  private let m_vehiclesTemplateClassifier: ref<VehiclesListTemplateClassifier>;
  private let m_carDealerSystem: ref<PurchasableVehicleSystem>;

  protected cb func OnInitialize() -> Bool {
    this.m_vehiclesList = this.GetChildWidgetByPath(n"scrollWrapper/scrollArea/VehicleList").GetController() as inkVirtualGridController;
    this.m_vehiclesListScrollController = this.GetChildWidgetByPath(n"scrollWrapper").GetControllerByType(n"inkScrollController") as inkScrollController;

    this.m_vehiclesDataSource = new ScriptableDataSource();
    this.m_vehiclesDataView = new AutofixerItemDataView();
    this.m_vehiclesDataView.SetSource(this.m_vehiclesDataSource);
    this.m_vehiclesTemplateClassifier = new VehiclesListTemplateClassifier();
    this.m_vehiclesList.SetClassifier(this.m_vehiclesTemplateClassifier);
    this.m_vehiclesList.SetSource(this.m_vehiclesDataView);
    this.m_carDealerSystem = PurchasableVehicleSystem.GetInstance(this.GetPlayerControlledObject().GetGame());

    this.PopulateVehicleList();
  }

  protected cb func OnAutofixerSellEvent(evt: ref<AutofixerSellEvent>) -> Bool {
    let player: ref<GameObject> = this.GetPlayerControlledObject();
    GameObject.PlaySoundEvent(player, n"ui_menu_item_sold");
    this.m_carDealerSystem.SellOwnedVehicle(player, evt.data);
  }

  private func PopulateVehicleList() -> Void {
    let vehicles: array<ref<AutofixerItemData>> = this.m_carDealerSystem.GetOwnedVehiclesData();
    let items: array<ref<IScriptable>>;

    for vehicle in vehicles {
      ArrayPush(items, vehicle);
    };

    this.m_vehiclesDataSource.Reset(items);
    this.m_vehiclesDataView.UpdateView();
  }
}