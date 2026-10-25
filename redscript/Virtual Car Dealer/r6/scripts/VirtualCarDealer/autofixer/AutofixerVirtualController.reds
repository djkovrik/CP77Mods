module CarDealer
import CarDealer.System.PurchasableVehicleSystem
import CarDealer.Classes.VehiclesListTemplateClassifier
import CarDealer.Classes.AutofixerSellEvent
import CarDealer.Classes.AutofixerItemData
import CarDealer.Classes.AutofixerSellConfirmationEvent
import CarDealer.Classes.AutofixerSellConfirmedEvent
import CarDealer.Classes.AutofixerSellCompletedEvent
import CarDealer.Classes.AutofixerSellResultEvent
import CarDealer.Classes.AutofixerViewToken
import CarDealer.Transactions.VehicleTradeResult

public class AutofixerVirtualController extends inkGameController {
  private let m_vehiclesList: ref<inkVirtualGridController>;
  private let m_vehiclesListScrollController: wref<inkScrollController>;
  private let m_vehiclesDataSource: ref<ScriptableDataSource>;
  private let m_vehiclesDataView: ref<AutofixerItemDataView>;
  private let m_vehiclesTemplateClassifier: ref<VehiclesListTemplateClassifier>;
  private let m_carDealerSystem: ref<PurchasableVehicleSystem>;
  private let m_confirmationListener: ref<AutofixerSaleConfirmationListener>;
  private let m_sellConfirmationToken: ref<inkGameNotificationToken>;
  private let m_viewToken: ref<AutofixerViewToken>;

  protected cb func OnInitialize() -> Bool {
    this.m_viewToken = new AutofixerViewToken();
    this.m_viewToken.active = true;
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

  protected cb func OnUninitialize() -> Bool {
    if IsDefined(this.m_viewToken) {
      this.m_viewToken.active = false;
    };
    this.m_viewToken = null;
    if IsDefined(this.m_confirmationListener) {
      if IsDefined(this.m_confirmationListener.data) {
        this.m_confirmationListener.data.busy = false;
        this.m_confirmationListener.data.handledSerial = this.m_confirmationListener.requestSerial;
      };
      this.m_confirmationListener.owner = null;
      this.m_confirmationListener.data = null;
    };
    if IsDefined(this.m_vehiclesList) {
      this.m_vehiclesList.SetSource(null);
      this.m_vehiclesList.SetClassifier(null);
    };
    if IsDefined(this.m_vehiclesDataView) {
      this.m_vehiclesDataView.SetSource(null);
    };
    this.m_vehiclesList = null;
    this.m_vehiclesListScrollController = null;
    this.m_vehiclesDataSource = null;
    this.m_vehiclesDataView = null;
    this.m_vehiclesTemplateClassifier = null;
    this.m_carDealerSystem = null;
    this.m_confirmationListener = null;
    this.m_sellConfirmationToken = null;
  }

  protected cb func OnAutofixerSellEvent(evt: ref<AutofixerSellEvent>) -> Bool {
    if IsDefined(evt) {
      this.HandleSell(evt.data, evt.requestSerial);
    };
  }

  protected cb func OnAutofixerSellConfirmationEvent(evt: ref<AutofixerSellConfirmationEvent>) -> Bool {
    if !IsDefined(evt) || !this.OwnsRequest(evt.data) || NotEquals(evt.requestSerial, evt.data.requestSerial) || evt.requestSerial <= evt.data.handledSerial {
      return false;
    };
    if IsDefined(this.m_confirmationListener) || !IsDefined(this.m_carDealerSystem) {
      if IsDefined(this.m_confirmationListener) && Equals(this.m_confirmationListener.data, evt.data) && Equals(this.m_confirmationListener.requestSerial, evt.requestSerial) {
        return false;
      };
      this.FinishSell(evt.data, VehicleTradeResult.Rejected);
      evt.data.handledSerial = evt.requestSerial;
      return false;
    };
    this.m_confirmationListener = new AutofixerSaleConfirmationListener();
    this.m_confirmationListener.owner = this;
    this.m_confirmationListener.data = evt.data;
    this.m_confirmationListener.requestSerial = evt.requestSerial;
    this.m_sellConfirmationToken = VirtualCarDealerSellingPopup.Show(this);
    if IsDefined(this.m_sellConfirmationToken) {
      this.m_sellConfirmationToken.RegisterListener(this.m_confirmationListener, n"OnClosed");
    } else {
      evt.data.handledSerial = evt.requestSerial;
      this.FinishSell(evt.data, VehicleTradeResult.Rejected);
      this.m_confirmationListener = null;
    };
  }

  public func OnSaleConfirmation(listener: ref<AutofixerSaleConfirmationListener>, data: ref<inkGameNotificationData>) -> Void {
    if NotEquals(listener, this.m_confirmationListener) {
      return;
    };
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    let sellingData: ref<AutofixerItemData> = listener.data;
    let requestSerial: Uint32 = listener.requestSerial;
    listener.owner = null;
    listener.data = null;
    this.m_confirmationListener = null;
    this.m_sellConfirmationToken = null;
    if !IsDefined(sellingData) || !IsDefined(this.m_carDealerSystem) {
      return;
    };
    if IsDefined(resultData) && Equals(resultData.result, GenericMessageNotificationResult.Yes) {
      this.HandleSell(sellingData, requestSerial);
    } else {
      sellingData.handledSerial = requestSerial;
      this.FinishSell(sellingData, VehicleTradeResult.Rejected);
    };
  }

  private func HandleSell(data: ref<AutofixerItemData>, requestSerial: Uint32) -> Void {
    if !this.OwnsRequest(data) || !IsDefined(this.m_carDealerSystem) || NotEquals(requestSerial, data.requestSerial) || requestSerial <= data.handledSerial {
      return;
    };
    data.handledSerial = requestSerial;
    let result: VehicleTradeResult = this.m_carDealerSystem.SellOwnedVehicleDetailed(this.GetPlayerControlledObject(), data);
    this.FinishSell(data, result);
    if Equals(result, VehicleTradeResult.Completed) {
      GameObject.PlaySoundEvent(this.GetPlayerControlledObject(), n"ui_menu_item_sold");
    } else {
      VirtualCarDealerTradePopup.Show(this, result, data.vehicleID);
    };
  }

  private func OwnsRequest(data: ref<AutofixerItemData>) -> Bool {
    // Queued actions from a previous screen must not start a new transaction.
    if !IsDefined(data) || !IsDefined(this.m_viewToken) {
      return false;
    };
    let token: ref<AutofixerViewToken> = data.viewToken;
    return IsDefined(token) && this.m_viewToken.active && Equals(token, this.m_viewToken);
  }

  private func FinishSell(data: ref<AutofixerItemData>, result: VehicleTradeResult) -> Void {
    data.busy = false;
    data.tradeResult = result;
    data.sold = Equals(result, VehicleTradeResult.Completed);
    if data.sold {
      let completedEvent: ref<AutofixerSellCompletedEvent> = new AutofixerSellCompletedEvent();
      completedEvent.data = data;
      this.QueueEvent(completedEvent);
    } else {
      let resultEvent: ref<AutofixerSellResultEvent> = new AutofixerSellResultEvent();
      resultEvent.data = data;
      this.QueueEvent(resultEvent);
    };
  }

  private func PopulateVehicleList() -> Void {
    let vehicles: array<ref<AutofixerItemData>> = this.m_carDealerSystem.GetOwnedVehiclesData();
    let items: array<ref<IScriptable>>;

    for vehicle in vehicles {
      vehicle.viewToken = this.m_viewToken;
      ArrayPush(items, vehicle);
    };

    this.m_vehiclesDataSource.Reset(items);
    this.m_vehiclesDataView.UpdateView();
  }
}

public class AutofixerSaleConfirmationListener extends IScriptable {
  public let owner: wref<AutofixerVirtualController>;
  public let data: ref<AutofixerItemData>;
  public let requestSerial: Uint32;

  protected cb func OnClosed(notification: ref<inkGameNotificationData>) -> Void {
    if IsDefined(this.owner) {
      this.owner.OnSaleConfirmation(this, notification);
    };
  }
}
