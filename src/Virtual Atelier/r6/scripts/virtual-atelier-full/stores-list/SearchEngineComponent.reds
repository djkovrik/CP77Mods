module VirtualAtelier.UI
import VirtualAtelier.Systems.VirtualAtelierStoresManager
import VirtualAtelier.Logs.*
import Codeware.UI.*
public class VirtualAtelierStoreSearchCallback extends DelayCallback {
  public let component: wref<SearchEngineComponent>;
  public let token: Int32;

  public func Call() -> Void {
    if IsDefined(this.component) {
      this.component.ContinueSearch(this.token);
    };
  }

  public static func Create(component: ref<SearchEngineComponent>, token: Int32) -> ref<VirtualAtelierStoreSearchCallback> {
    let callback: ref<VirtualAtelierStoreSearchCallback> = new VirtualAtelierStoreSearchCallback();
    callback.component = component;
    callback.token = token;
    return callback;
  }
}

public class SearchEngineComponent extends inkComponent {
  private let player: wref<PlayerPuppet>;
  private let storeManagerSystem: wref<VirtualAtelierStoresManager>;
  private let uiSystem: wref<UISystem>;

  private let indicatorShowAnimproxy: ref<inkAnimProxy>;
  private let indicatorHideAnimproxy: ref<inkAnimProxy>;

  // Widgets
  private let searchInput: wref<HubTextInputSearch>;
  private let buttonReset: wref<SimpleButtonSearch>;
  private let buttonSearch: wref<SimpleButtonSearch>;
  private let buttonResults: wref<SimpleButtonSearch>;

  private let searchIndicator: wref<inkText>;
  private let resultsLabel: wref<inkText>;

  private let checkboxRangedWeapons: wref<inkCompoundWidget>;
  private let checkboxMeleeWeapons: wref<inkCompoundWidget>;
  private let checkboxClothes: wref<inkCompoundWidget>;
  private let checkboxConsumables: wref<inkCompoundWidget>;
  private let checkboxGrenades: wref<inkCompoundWidget>;
  private let checkboxAttachments: wref<inkCompoundWidget>;
  private let checkboxPrograms: wref<inkCompoundWidget>;
  private let checkboxCyberware: wref<inkCompoundWidget>;
  private let checkboxJunk: wref<inkCompoundWidget>;
  private let checkboxFace: wref<inkCompoundWidget>;
  private let checkboxFeet: wref<inkCompoundWidget>;
  private let checkboxHead: wref<inkCompoundWidget>;
  private let checkboxLegs: wref<inkCompoundWidget>;
  private let checkboxInnerChest: wref<inkCompoundWidget>;
  private let checkboxOuterChest: wref<inkCompoundWidget>;
  private let checkboxOutfit: wref<inkCompoundWidget>;
  private let checkboxNewWardrobe: wref<inkCompoundWidget>;

  // State
  private let searchInputQuery: String;
  private let storesCount: Int32;
  private let resultsCounter: Int32;
  private let searchRequestToken: Int32;
  private let searchDelayId: DelayID;
  private let isSearching: Bool;
  private let searchBatchSize: Int32 = 100;
  private let searchInitialDelay: Float = 0.16;
  private let searchBatchDelay: Float = 0.01;

  private let checkboxRangedWeaponsChecked: Bool;
  private let checkboxMeleeWeaponsChecked: Bool;
  private let checkboxClothesChecked: Bool;
  private let checkboxConsumablesChecked: Bool;
  private let checkboxGrenadesChecked: Bool;
  private let checkboxAttachmentsChecked: Bool;
  private let checkboxProgramsChecked: Bool;
  private let checkboxCyberwareChecked: Bool;
  private let checkboxJunkChecked: Bool;
  private let checkboxFaceChecked: Bool;
  private let checkboxFeetChecked: Bool;
  private let checkboxHeadChecked: Bool;
  private let checkboxLegsChecked: Bool;
  private let checkboxInnerChestChecked: Bool;
  private let checkboxOuterChestChecked: Bool;
  private let checkboxOutfitChecked: Bool;
  private let checkboxNewWardrobeChecked: Bool;

  protected cb func OnCreate() -> ref<inkWidget> {
    this.Log("OnCreate");

    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(n"Root");
    root.SetAnchor(inkEAnchor.Centered);
    root.SetInteractive(true);
    root.SetFitToContent(true);
    root.SetAnchorPoint(Vector2(0.5, 0.5));

    return root;
  }

  protected cb func OnInitialize() -> Void {
    this.Log("OnInitialize");
    this.player = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
    this.storeManagerSystem = VirtualAtelierStoresManager.GetInstance(this.player.GetGame());
    this.uiSystem = GameInstance.GetUISystem(this.player.GetGame());
    this.storesCount = this.storeManagerSystem.GetStoresCount();
    this.indicatorShowAnimproxy = new inkAnimProxy();
    this.indicatorHideAnimproxy = new inkAnimProxy();
    this.InitializeWidgets();
    this.InitializeListeners();
  }

  protected cb func OnUninitialize() -> Void {
    this.isSearching = false;
    this.searchRequestToken += 1;
    this.CancelScheduledSearchCallback();
    if IsDefined(this.storeManagerSystem) {
      this.storeManagerSystem.CancelSearchStores();
    };

    if IsDefined(this.indicatorShowAnimproxy) {
      this.indicatorShowAnimproxy.Stop();
      this.indicatorShowAnimproxy = null;
    };

    if IsDefined(this.indicatorHideAnimproxy) {
      this.indicatorHideAnimproxy.Stop();
      this.indicatorHideAnimproxy = null;
    };

    this.UninitializeListeners();
  }

  protected cb func OnHandleGlobalRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"mouse_left") {
      if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
        if IsDefined(this.uiSystem) {
          this.uiSystem.QueueEvent(new SearchComponentClearFocusEvent());
        };
      };
    };
  }

  protected cb func OnSearchInput(widget: wref<inkWidget>) {
    if IsDefined(this.searchInput) {
      this.searchInputQuery = UTF8StrLower(this.searchInput.GetText());
      this.ClearSearchResults();
      this.InvalidateSearchControls();
    };
  }

  protected cb func OnWidgetClick(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let checkbox: ref<inkCompoundWidget> = this.ResolveCheckboxTarget(target);
    let targetName: CName = target.GetName();
    let isCheckbox: Bool = IsDefined(checkbox);
    let shouldReactToClick: Bool = isCheckbox
      || Equals(targetName, n"buttonReset")
      || Equals(targetName, n"buttonSearch")
      || Equals(targetName, n"buttonResults");

    if shouldReactToClick && evt.IsAction(n"click") {
      this.PlaySound(n"ui_menu_onpress"); 

      if isCheckbox {
        this.OnCheckboxClick(checkbox);
      } else {
        switch targetName {
          case n"buttonReset":
            if this.buttonReset.IsEnabled() {
              this.OnResetClick();
            };
            break;
          case n"buttonSearch":
            if this.buttonSearch.IsEnabled() {
              this.OnSearchClick();
            };
            break;
          case n"buttonResults":
            if this.buttonResults.IsEnabled() {
              this.OnResultsClick();
            };
            break;
          default:
            break;
        };
      };
    };
	}

  private final func OnResetClick() -> Void {
    this.searchInput.SetText("");
    this.searchIndicator.SetVisible(false);
    this.resultsLabel.SetVisible(false);

    this.UpdateCheckbox(this.checkboxRangedWeapons, false);
    this.UpdateCheckbox(this.checkboxMeleeWeapons, false);
    this.UpdateCheckbox(this.checkboxClothes, false);
    this.UpdateCheckbox(this.checkboxConsumables, false);
    this.UpdateCheckbox(this.checkboxGrenades, false);
    this.UpdateCheckbox(this.checkboxAttachments, false);
    this.UpdateCheckbox(this.checkboxPrograms, false);
    this.UpdateCheckbox(this.checkboxCyberware, false);
    this.UpdateCheckbox(this.checkboxJunk, false);
    this.UpdateCheckbox(this.checkboxFace, false);
    this.UpdateCheckbox(this.checkboxFeet, false);
    this.UpdateCheckbox(this.checkboxHead, false);
    this.UpdateCheckbox(this.checkboxLegs, false);
    this.UpdateCheckbox(this.checkboxInnerChest, false);
    this.UpdateCheckbox(this.checkboxOuterChest, false);
    this.UpdateCheckbox(this.checkboxOutfit, false);
    this.UpdateCheckbox(this.checkboxNewWardrobe, false);

    this.searchInputQuery = "";
    this.ClearSearchResults();

    this.checkboxRangedWeaponsChecked = false;
    this.checkboxMeleeWeaponsChecked = false;
    this.checkboxClothesChecked = false;
    this.checkboxConsumablesChecked = false;
    this.checkboxGrenadesChecked = false;
    this.checkboxAttachmentsChecked = false;
    this.checkboxProgramsChecked = false;
    this.checkboxCyberwareChecked = false;
    this.checkboxJunkChecked = false;
    this.checkboxFaceChecked = false;
    this.checkboxFeetChecked = false;
    this.checkboxHeadChecked = false;
    this.checkboxLegsChecked = false;
    this.checkboxInnerChestChecked = false;
    this.checkboxOuterChestChecked = false;
    this.checkboxOutfitChecked = false;
    this.checkboxNewWardrobeChecked = false;

    this.InvalidateSearchControls();
  }


  private final func OnSearchClick() -> Void {
    this.Log("OnSearchClick");
    this.ShowSearchingIndicator();
    this.resultsCounter = 0;
    this.isSearching = true;
    this.searchRequestToken = this.storeManagerSystem.BeginSearchStores(this.CreateSearchCriteria());
    this.InvalidateSearchControls();
    this.ScheduleSearchBatch(this.searchRequestToken, this.searchInitialDelay);
  }

  private final func ScheduleSearchBatch(token: Int32, delay: Float) -> Void {
    if !this.isSearching || NotEquals(token, this.searchRequestToken) || !IsDefined(this.player) {
      return;
    };

    this.CancelScheduledSearchCallback();
    this.searchDelayId = GameInstance.GetDelaySystem(this.player.GetGame()).DelayCallback(VirtualAtelierStoreSearchCallback.Create(this, token), delay, false);
  }

  public final func ContinueSearch(token: Int32) -> Void {
    let finished: Bool;

    if !this.isSearching || NotEquals(token, this.searchRequestToken) || !IsDefined(this.storeManagerSystem) {
      return;
    };

    this.searchDelayId = GetInvalidDelayID();
    finished = this.storeManagerSystem.ContinueSearchStores(token, this.searchBatchSize);
    if !this.isSearching || NotEquals(token, this.searchRequestToken) {
      return;
    };

    if finished {
      this.isSearching = false;
      this.searchDelayId = GetInvalidDelayID();
      this.resultsCounter = this.storeManagerSystem.GetSearchResultsCounter();
      this.ShowResultsIndicator();
      this.InvalidateSearchControls();
    } else {
      this.ScheduleSearchBatch(token, this.searchBatchDelay);
    };
  }

  private final func OnResultsClick() -> Void {
    let results: array<ref<VirtualStoreSearchResult>> = this.storeManagerSystem.GetSearchResults();
    let result: ref<VirtualStoreSearchResult>;
    this.Log("OnResultsClick");

    if this.isSearching || this.resultsCounter <= 0 || ArraySize(results) <= 0 {
      return;
    };

    result = results[0];
    if IsDefined(result) && IsDefined(result.store) {
      this.OpenVirtualStore(result.store);
    };
  }

  private final func CreateSearchCriteria() -> ref<VirtualStoreSearchCriteria> {
    let criteria: ref<VirtualStoreSearchCriteria> = new VirtualStoreSearchCriteria();

    if IsDefined(this.searchInput) {
      this.searchInputQuery = UTF8StrLower(this.searchInput.GetText());
    };

    criteria.query = this.searchInputQuery;
    criteria.rangedWeapons = this.checkboxRangedWeaponsChecked;
    criteria.meleeWeapons = this.checkboxMeleeWeaponsChecked;
    criteria.clothes = this.checkboxClothesChecked;
    criteria.consumables = this.checkboxConsumablesChecked;
    criteria.grenades = this.checkboxGrenadesChecked;
    criteria.attachments = this.checkboxAttachmentsChecked;
    criteria.programs = this.checkboxProgramsChecked;
    criteria.cyberware = this.checkboxCyberwareChecked;
    criteria.junk = this.checkboxJunkChecked;
    criteria.face = this.checkboxFaceChecked;
    criteria.feet = this.checkboxFeetChecked;
    criteria.head = this.checkboxHeadChecked;
    criteria.legs = this.checkboxLegsChecked;
    criteria.innerChest = this.checkboxInnerChestChecked;
    criteria.outerChest = this.checkboxOuterChestChecked;
    criteria.outfit = this.checkboxOutfitChecked;
    criteria.newWardrobe = this.checkboxNewWardrobeChecked;

    return criteria;
  }

  private final func CancelScheduledSearchCallback() -> Void {
    if this.searchDelayId != GetInvalidDelayID() && IsDefined(this.player) {
      GameInstance.GetDelaySystem(this.player.GetGame()).CancelCallback(this.searchDelayId);
    };
    this.searchDelayId = GetInvalidDelayID();
  }
  private final func ClearSearchResults() -> Void {
    this.isSearching = false;
    this.searchRequestToken += 1;
    this.CancelScheduledSearchCallback();
    this.resultsCounter = 0;
    if IsDefined(this.storeManagerSystem) {
      this.storeManagerSystem.ClearSearchResults();
    };
    if IsDefined(this.searchIndicator) {
      this.searchIndicator.SetVisible(false);
    };
    if IsDefined(this.resultsLabel) {
      this.resultsLabel.SetVisible(false);
    };
  }

  private final func OpenVirtualStore(store: ref<VirtualShop>) -> Void {
    let vendorData: ref<VendorPanelData>;

    if !IsDefined(store) {
      return;
    };

    vendorData = new VendorPanelData();
    vendorData.data.vendorId = "VirtualVendor";
    vendorData.data.entityID = this.player.GetEntityID();
    vendorData.data.isActive = true;
    this.storeManagerSystem.SetCurrentStore(store);
    GameInstance.GetUISystem(this.player.GetGame()).RequestVendorMenu(vendorData);
  }

  private final func OnCheckboxClick(target: ref<inkWidget>) -> Void {
    let name: CName = target.GetName();
    let container: ref<inkCompoundWidget> = target as inkCompoundWidget;
    if !IsDefined(container) {
      return;
    };

    let newValue: Bool = !container.GetWidget(n"flexbox/foreground").IsVisible();
    this.UpdateCheckbox(container, newValue);

    switch name {
      case n"checkboxRangedWeapons":
        this.checkboxRangedWeaponsChecked = newValue;
        break;
      case n"checkboxMeleeWeapons":
        this.checkboxMeleeWeaponsChecked = newValue;
        break;
      case n"checkboxClothes":
        this.checkboxClothesChecked = newValue;
        break;
      case n"checkboxConsumables":
        this.checkboxConsumablesChecked = newValue;
        break;
      case n"checkboxGrenades":
        this.checkboxGrenadesChecked = newValue;
        break;
      case n"checkboxAttachments":
        this.checkboxAttachmentsChecked = newValue;
        break;
      case n"checkboxPrograms":
        this.checkboxProgramsChecked = newValue;
        break;
      case n"checkboxCyberware":
        this.checkboxCyberwareChecked = newValue;
        break;
      case n"checkboxJunk":
        this.checkboxJunkChecked = newValue;
        break;
      case n"checkboxFace":
        this.checkboxFaceChecked = newValue;
        this.EnableClothesCheckboxIfDisabled();
        break;
      case n"checkboxFeet":
        this.checkboxFeetChecked = newValue;
        this.EnableClothesCheckboxIfDisabled();
        break;
      case n"checkboxHead":
        this.checkboxHeadChecked = newValue;
        this.EnableClothesCheckboxIfDisabled();
        break;
      case n"checkboxLegs":
        this.checkboxLegsChecked = newValue;
        this.EnableClothesCheckboxIfDisabled();
        break;
      case n"checkboxInnerChest":
        this.checkboxInnerChestChecked = newValue;
        this.EnableClothesCheckboxIfDisabled();
        break;
      case n"checkboxOuterChest":
        this.checkboxOuterChestChecked = newValue;
        this.EnableClothesCheckboxIfDisabled();
        break;
      case n"checkboxOutfit":
        this.checkboxOutfitChecked = newValue;
        this.EnableClothesCheckboxIfDisabled();
        break;
      case n"checkboxNewWardrobe":
        this.checkboxNewWardrobeChecked = newValue;
        this.EnableClothesCheckboxIfDisabled();
        break;
      default:
        break;
    };

    this.ClearSearchResults();
    this.InvalidateSearchControls();
  }

  private final func EnableClothesCheckboxIfDisabled() -> Void {
    if !this.checkboxClothesChecked {
      this.checkboxClothesChecked = true;
      this.UpdateCheckbox(this.checkboxClothes, true);
    };
  }

  private final func UpdateCheckbox(container: ref<inkCompoundWidget>, newValue: Bool) -> Void {
    let thumb: ref<inkWidget> = container.GetWidget(n"flexbox/foreground");
    if !IsDefined(thumb) {
      return ;
    };

    thumb.SetVisible(newValue);
  }

  private final func ResolveCheckboxTarget(target: ref<inkWidget>) -> ref<inkCompoundWidget> {
    let current: ref<inkWidget> = target;
    let nameStr: String;
    let i: Int32 = 0;

    while IsDefined(current) && i < 3 {
      nameStr = NameToString(current.GetName());
      if StrContains(nameStr, "checkbox") {
        return current as inkCompoundWidget;
      };

      current = current.GetParentWidget();
      i += 1;
    };

    return null;
  }

  private final func OnCheckboxHoverOver(target: ref<inkWidget>) -> Void {
    let container: ref<inkCompoundWidget> = target as inkCompoundWidget;
    if !IsDefined(container) {
      return;
    };

    let frame: ref<inkWidget> = container.GetWidget(n"flexbox/border");
    let label: ref<inkWidget> = container.GetWidget(n"label");
    let thumb: ref<inkWidget> = container.GetWidget(n"flexbox/foreground");

    if !IsDefined(frame) || !IsDefined(label) || !IsDefined(thumb) {
      return ;
    };

    frame.BindProperty(n"tintColor", n"MainColors.Blue");
    label.BindProperty(n"tintColor", n"MainColors.ActiveRed");
    thumb.BindProperty(n"tintColor", n"MainColors.Blue");
  }

  private final func OnCheckboxHoverOut(target: ref<inkWidget>) -> Void {
    let container: ref<inkCompoundWidget> = target as inkCompoundWidget;
    if !IsDefined(container) {
      return;
    };

    let frame: ref<inkWidget> = container.GetWidget(n"flexbox/border");
    let label: ref<inkWidget> = container.GetWidget(n"label");
    let thumb: ref<inkWidget> = container.GetWidget(n"flexbox/foreground");

    if !IsDefined(frame) || !IsDefined(label) || !IsDefined(thumb) {
      return ;
    };

    frame.BindProperty(n"tintColor", n"MainColors.MildRed");
    label.BindProperty(n"tintColor", n"MainColors.White");
    thumb.BindProperty(n"tintColor", n"MainColors.MildRed");
  }

  private final func ShowSearchingIndicator() -> Void {
    this.indicatorShowAnimproxy.Stop();
    this.indicatorHideAnimproxy.Stop();
 
    if this.resultsLabel.IsVisible() {
      this.indicatorHideAnimproxy = this.AnimatedHide(this.resultsLabel, 0.15, 0.0);
      this.indicatorHideAnimproxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnResultsAnimationFinish");
      this.indicatorShowAnimproxy = this.AnimatedShow(this.searchIndicator, 0.15, 0.0);
      this.indicatorShowAnimproxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnSearchAnimationStart");
    } else {
      this.indicatorShowAnimproxy = this.AnimatedShow(this.searchIndicator, 0.15, 0.0);
      this.indicatorShowAnimproxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnSearchAnimationStart");
    };
  }

  private final func ShowResultsIndicator() -> Void {
    this.indicatorShowAnimproxy.Stop();
    this.indicatorHideAnimproxy.Stop();

    if this.resultsCounter > 9999 {
      this.resultsLabel.SetText(s"\(GetLocalizedTextByKey(n"VA-Search-Items-Count")) 9999+");
    } else {
      this.resultsLabel.SetText(s"\(GetLocalizedTextByKey(n"VA-Search-Items-Count")) \(this.resultsCounter)");
    };

    if this.searchIndicator.IsVisible() {
      this.indicatorHideAnimproxy = this.AnimatedHide(this.searchIndicator, 0.15, 0.0);
      this.indicatorHideAnimproxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnSearchAnimationFinish");
      this.indicatorShowAnimproxy = this.AnimatedShow(this.resultsLabel, 0.15, 0.0);
      this.indicatorShowAnimproxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnResultsAnimationStart");
    } else {
      this.indicatorShowAnimproxy = this.AnimatedShow(this.resultsLabel, 0.15, 0.0);
      this.indicatorShowAnimproxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnResultsAnimationStart");
    };
  }

  protected cb func OnSearchAnimationStart(e: ref<inkAnimProxy>) -> Bool {
    e.UnregisterFromCallback(inkanimEventType.OnStart, this, n"OnSearchAnimationStart");
    this.searchIndicator.SetVisible(true);
  }

  protected cb func OnSearchAnimationFinish(e: ref<inkAnimProxy>) -> Bool {
    e.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnSearchAnimationFinish");
    this.searchIndicator.SetVisible(false);
  }

  protected cb func OnResultsAnimationStart(e: ref<inkAnimProxy>) -> Bool {
    e.UnregisterFromCallback(inkanimEventType.OnStart, this, n"OnResultsAnimationStart");
    this.resultsLabel.SetVisible(true);
  }

  protected cb func OnResultsAnimationFinish(e: ref<inkAnimProxy>) -> Bool {
    e.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnResultsAnimationFinish");
    this.resultsLabel.SetVisible(false);
  }

  protected cb func OnWidgetHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let checkbox: ref<inkCompoundWidget> = this.ResolveCheckboxTarget(target);
    let targetName: CName = target.GetName();
    let isCheckbox: Bool = IsDefined(checkbox);
    let shouldReactToHover: Bool = isCheckbox
      || Equals(targetName, n"buttonReset")
      || Equals(targetName, n"buttonSearch")
      || Equals(targetName, n"buttonResults");

    if shouldReactToHover {
      this.PlaySound(n"ui_menu_hover"); 

      if isCheckbox {
        this.OnCheckboxHoverOver(checkbox);
      };
    };
  }

  protected cb func OnWidgetHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let checkbox: ref<inkCompoundWidget> = this.ResolveCheckboxTarget(target);
    let targetName: CName = target.GetName();
    let isCheckbox: Bool = IsDefined(checkbox);
    let shouldReactToHover: Bool = isCheckbox
      || Equals(targetName, n"buttonReset")
      || Equals(targetName, n"buttonSearch")
      || Equals(targetName, n"buttonResults");

    if shouldReactToHover {
      if isCheckbox {
        this.OnCheckboxHoverOut(checkbox);
      };
    };
  }

  private final func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  
    let outer: ref<inkVerticalPanel> = new inkVerticalPanel();
    outer.SetName(n"outer");
    outer.SetAnchor(inkEAnchor.Centered);
    outer.SetFitToContent(false);
    outer.SetAnchorPoint(Vector2(0.5, 0.5));
    outer.SetFitToContent(true);
    outer.Reparent(root);

    // Search row
    let searchRow: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    searchRow.SetName(n"searchRow");
    searchRow.SetHAlign(inkEHorizontalAlign.Center);
    searchRow.SetChildMargin(inkMargin(8.0, 0.0, 8.0, 0.0));
    searchRow.Reparent(outer);

    let searchInput: ref<HubTextInputSearch> = HubTextInputSearch.Create();
    searchInput.SetName(n"searchInput");
    searchInput.SetLetterCase(textLetterCase.UpperCase);
    searchInput.SetMaxLength(120);
    searchInput.SetDefaultText(GetLocalizedTextByKey(n"VA-Search-Input-Hint"));
    searchInput.RegisterToCallback(n"OnInput", this, n"OnSearchInput");
    searchInput.Reparent(searchRow);
    this.searchInput = searchInput;

    let buttonReset: ref<SimpleButtonSearch> = SimpleButtonSearch.Create();
    buttonReset.SetName(n"buttonReset");
    buttonReset.SetText("x");
    buttonReset.SetSize(120.0, 80.0);
    buttonReset.SetDisabled(true);
    buttonReset.Reparent(searchRow);
    this.buttonReset = buttonReset;

    let buttonSearch: ref<SimpleButtonSearch> = SimpleButtonSearch.Create();
    buttonSearch.SetName(n"buttonSearch");
    buttonSearch.SetText(GetLocalizedTextByKey(n"VA-Search-Title"));
    buttonSearch.SetSize(300.0, 80.0);
    buttonSearch.SetDisabled(true);
    buttonSearch.Reparent(searchRow);
    this.buttonSearch = buttonSearch;

    // Stores counter
    let storesCount: ref<inkText> = new inkText();
    let counterParams: ref<inkTextParams> = new inkTextParams();
    let counterLabel: String = GetLocalizedTextByKey(n"VA-Search-Stores-Count");
    storesCount.SetName(n"storesCount");
    storesCount.SetFontSize(46);
    storesCount.SetFontStyle(n"Regular");
    storesCount.SetMargin(0.0, 16.0, 0.0, 16.0);
    storesCount.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    storesCount.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    storesCount.BindProperty(n"tintColor", n"MainColors.White");
    storesCount.SetHorizontalAlignment(textHorizontalAlignment.Center);
    storesCount.SetOpacity(0.4);
    counterParams.AddString("label", counterLabel);
    counterParams.AddNumber("count", this.storesCount);
    storesCount.SetText("{label} {count}", counterParams);
    storesCount.Reparent(outer);

    // Filters label
    let filtersLabel: ref<inkText> = new inkText();
    filtersLabel.SetName(n"filtersLabel");
    filtersLabel.SetText(GetLocalizedTextByKey(n"VA-Search-Filters"));
    filtersLabel.SetFontSize(50);
    filtersLabel.SetFontStyle(n"Regular");
    filtersLabel.SetMargin(0.0, 0.0, 0.0, 16.0);
    filtersLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    filtersLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    filtersLabel.BindProperty(n"tintColor", n"MainColors.Blue");
    filtersLabel.SetHorizontalAlignment(textHorizontalAlignment.Center);
    filtersLabel.Reparent(outer);

    // Main filters
    let mainFiltersCanvas: ref<inkCanvas> = new inkCanvas();
    mainFiltersCanvas.SetName(n"mainFiltersCanvas");
    mainFiltersCanvas.SetAnchor(inkEAnchor.Centered);
    mainFiltersCanvas.SetAnchorPoint(Vector2(0.5, 0.5));
    mainFiltersCanvas.SetInteractive(true);
    mainFiltersCanvas.SetSize(Vector2(0.0, 240.0));
    mainFiltersCanvas.SetFitToContent(true);
    mainFiltersCanvas.SetHAlign(inkEHorizontalAlign.Center);
    mainFiltersCanvas.Reparent(outer);

    let mainFiltersContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    mainFiltersContainer.SetName(n"mainFiltersContainer");
    mainFiltersContainer.SetAnchor(inkEAnchor.TopCenter);
    mainFiltersContainer.SetAnchorPoint(Vector2(0.5, 0.0));
    mainFiltersContainer.Reparent(mainFiltersCanvas);
    let mainColumn1: ref<inkVerticalPanel> = new inkVerticalPanel();
    mainColumn1.SetName(n"mainColumn1");
    mainColumn1.SetMargin(inkMargin(0.0, 0.0, 32.0, 0.0));
    mainColumn1.SetChildMargin(inkMargin(0.0, 4.0, 0.0, 4.0));
    mainColumn1.Reparent(mainFiltersContainer);
    let mainColumn2: ref<inkVerticalPanel> = new inkVerticalPanel();
    mainColumn2.SetName(n"mainColumn2");
    mainColumn2.SetMargin(inkMargin(32.0, 0.0, 32.0, 0.0));
    mainColumn2.SetChildMargin(inkMargin(0.0, 4.0, 0.0, 4.0));
    mainColumn2.Reparent(mainFiltersContainer);
    let mainColumn3: ref<inkVerticalPanel> = new inkVerticalPanel();
    mainColumn3.SetName(n"mainColumn3");
    mainColumn3.SetMargin(inkMargin(32.0, 0.0, 0.0, 0.0));
    mainColumn3.SetChildMargin(inkMargin(0.0, 4.0, 0.0, 4.0));
    mainColumn3.Reparent(mainFiltersContainer);

    let rangedWeapons: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxRangedWeapons", n"UI-Filters-RangedWeapons");
    let meleeWeapons: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxMeleeWeapons", n"UI-Filters-MeleeWeapons");
    let clothes: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxClothes", n"UI-Filters-Clothes");
    let consumables: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxConsumables", n"UI-Filters-Consumables");
    let grenades: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxGrenades", n"UI-Filters-Grenades");
    let attachments: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxAttachments", n"UI-Filters-Attachments");
    let programs: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxPrograms", n"UI-Filters-Hacks");
    let cyberware: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxCyberware", n"UI-Filters-Cyberware");
    let junk: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxJunk", n"UI-Filters-Junk");
    
    rangedWeapons.Reparent(mainColumn1);
    meleeWeapons.Reparent(mainColumn1);
    clothes.Reparent(mainColumn1);
    this.checkboxRangedWeapons = rangedWeapons;
    this.checkboxMeleeWeapons = meleeWeapons;
    this.checkboxClothes = clothes;

    consumables.Reparent(mainColumn2);
    grenades.Reparent(mainColumn2);
    attachments.Reparent(mainColumn2);
    this.checkboxConsumables = consumables;
    this.checkboxGrenades = grenades;
    this.checkboxAttachments = attachments;

    programs.Reparent(mainColumn3);
    cyberware.Reparent(mainColumn3);
    junk.Reparent(mainColumn3);
    this.checkboxPrograms = programs;
    this.checkboxCyberware = cyberware;
    this.checkboxJunk = junk;

    // Additional clothing filters
    let secondaryFiltersCanvas: ref<inkCanvas> = new inkCanvas();
    secondaryFiltersCanvas.SetName(n"secondaryFiltersCanvas");
    secondaryFiltersCanvas.SetAnchor(inkEAnchor.Centered);
    secondaryFiltersCanvas.SetInteractive(true);
    secondaryFiltersCanvas.SetAnchorPoint(Vector2(0.5, 0.5));
    secondaryFiltersCanvas.SetSize(Vector2(0.0, 200.0));
    secondaryFiltersCanvas.SetFitToContent(true);
    secondaryFiltersCanvas.SetHAlign(inkEHorizontalAlign.Center);
    secondaryFiltersCanvas.Reparent(outer);

    let secondaryFiltersContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    secondaryFiltersContainer.SetName(n"secondaryFiltersContainer");
    secondaryFiltersContainer.SetAnchor(inkEAnchor.TopCenter);
    secondaryFiltersContainer.SetAnchorPoint(Vector2(0.5, 0.0));
    secondaryFiltersContainer.Reparent(secondaryFiltersCanvas);
    let secondaryColumn1: ref<inkVerticalPanel> = new inkVerticalPanel();
    secondaryColumn1.SetName(n"secondaryColumn1");
    secondaryColumn1.SetMargin(inkMargin(0.0, 0.0, 32.0, 0.0));
    secondaryColumn1.SetChildMargin(inkMargin(0.0, 4.0, 0.0, 4.0));
    secondaryColumn1.Reparent(secondaryFiltersContainer);
    let secondaryColumn2: ref<inkVerticalPanel> = new inkVerticalPanel();
    secondaryColumn2.SetName(n"secondaryColumn2");
    secondaryColumn2.SetMargin(inkMargin(32.0, 0.0, 32.0, 0.0));
    secondaryColumn2.SetChildMargin(inkMargin(0.0, 4.0, 0.0, 4.0));
    secondaryColumn2.Reparent(secondaryFiltersContainer);
    let secondaryColumn3: ref<inkVerticalPanel> = new inkVerticalPanel();
    secondaryColumn3.SetName(n"secondaryColumn3");
    secondaryColumn3.SetMargin(inkMargin(32.0, 0.0, 0.0, 0.0));
    secondaryColumn3.SetChildMargin(inkMargin(0.0, 4.0, 0.0, 4.0));
    secondaryColumn3.Reparent(secondaryFiltersContainer);

    let face: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxFace", n"Gameplay-Items-Item Type-Clo_Face");
    let feet: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxFeet", n"Gameplay-Items-Item Type-Clo_Feet");
    let head: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxHead", n"Gameplay-Items-Item Type-Clo_Head");
    let legs: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxLegs", n"Gameplay-Items-Item Type-Clo_Legs");
    let innerChest: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxInnerChest", n"Gameplay-Items-Item Type-Clo_InnerChest");
    let outerChest: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxOuterChest", n"Gameplay-Items-Item Type-Clo_OuterChest");
    let outfit: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxOutfit", n"UI-Inventory-Labels-Outfit");
    let newWardrobe: ref<inkCompoundWidget> = this.BuildFilterCheckbox(n"checkboxNewWardrobe", n"UI-Filters-NewWardrobeAppearances");

    face.Reparent(secondaryColumn1);
    feet.Reparent(secondaryColumn1);
    head.Reparent(secondaryColumn1);
    this.checkboxFace = face;
    this.checkboxFeet = feet;
    this.checkboxHead = head;

    legs.Reparent(secondaryColumn2);
    innerChest.Reparent(secondaryColumn2);
    outerChest.Reparent(secondaryColumn2);
    this.checkboxLegs = legs;
    this.checkboxInnerChest = innerChest;
    this.checkboxOuterChest = outerChest;

    outfit.Reparent(secondaryColumn3);
    newWardrobe.Reparent(secondaryColumn3);
    this.checkboxOutfit = outfit;
    this.checkboxNewWardrobe = newWardrobe;

    // Search indicators
    let searchIndicators: ref<inkCanvas> = new inkCanvas();
    searchIndicators.SetName(n"searchIndicators");
    searchIndicators.SetHAlign(inkEHorizontalAlign.Center);
    searchIndicators.SetSize(0.0, 100.0);
    searchIndicators.SetFitToContent(true);
    searchIndicators.SetMargin(0.0, 32.0, 0.0, 0.0);
    searchIndicators.Reparent(outer);

    // Progress
    let searchIndicator: ref<inkText> = new inkText();
    searchIndicator.SetName(n"searchIndicator");
    searchIndicator.SetFontSize(50);
    searchIndicator.SetFontStyle(n"Regular");
    searchIndicator.SetAnchor(inkEAnchor.TopCenter);
    searchIndicator.SetAnchorPoint(0.5, 0.0);
    searchIndicator.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    searchIndicator.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    searchIndicator.BindProperty(n"tintColor", n"MainColors.White");
    searchIndicator.SetText(GetLocalizedTextByKey(n"VA-Search-Indicator"));
    searchIndicator.SetVisible(false);
    searchIndicator.Reparent(searchIndicators);
    this.searchIndicator = searchIndicator;

    // Results
    let resultsLabel: ref<inkText> = new inkText();
    resultsLabel.SetName(n"resultsLabel");
    resultsLabel.SetFontSize(50);
    resultsLabel.SetFontStyle(n"Regular");
    resultsLabel.SetAnchor(inkEAnchor.TopCenter);
    resultsLabel.SetAnchorPoint(0.5, 0.0);
    resultsLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    resultsLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    resultsLabel.BindProperty(n"tintColor", n"MainColors.White");
    resultsLabel.SetText(s"\(GetLocalizedTextByKey(n"VA-Search-Items-Count")) 9999+");
    resultsLabel.SetVisible(false);
    resultsLabel.Reparent(searchIndicators);
    this.resultsLabel = resultsLabel;

    let buttonResults: ref<SimpleButtonSearch> = SimpleButtonSearch.Create();
    buttonResults.SetName(n"buttonResults");
    buttonResults.SetText(GetLocalizedTextByKey(n"VA-Search-Results"));
    buttonResults.SetDisabled(true);
    buttonResults.Reparent(outer);
    this.buttonResults = buttonResults;
  }

  private final func BuildFilterCheckbox(name: CName, locKey: CName) -> ref<inkCompoundWidget> {
    let checkboxWrapper: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    checkboxWrapper.SetName(name);
    checkboxWrapper.SetInteractive(true);
    checkboxWrapper.SetAnchor(inkEAnchor.CenterLeft);
    checkboxWrapper.SetAnchorPoint(0.0, 0.5);
    checkboxWrapper.SetMargin(0.0, 0.0, 0.0, 0.0);
    checkboxWrapper.SetSize(300.0, 0.0);

    let flexbox: ref<inkFlex> = new inkFlex();
    flexbox.SetName(n"flexbox");
    flexbox.SetInteractive(true);
    flexbox.SetAnchor(inkEAnchor.Fill);
    flexbox.SetAnchorPoint(0.5, 0.5);
    flexbox.SetVAlign(inkEVerticalAlign.Center);
    flexbox.SetMargin(6.0, 0.0, 6.0, 0.0);
    flexbox.SetSize(100.0, 100.0);
    flexbox.Reparent(checkboxWrapper);

    let foreground1: ref<inkRectangle> = new inkRectangle();
    foreground1.SetName(n"foreground1");
    foreground1.SetInteractive(true);
    foreground1.SetAnchor(inkEAnchor.Centered);
    foreground1.SetAnchorPoint(0.5, 0.5);
    foreground1.SetHAlign(inkEHorizontalAlign.Right);
    foreground1.SetVAlign(inkEVerticalAlign.Top);
    foreground1.SetSize(40.0, 40.0);
    foreground1.SetOpacity(0.5);
    foreground1.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    foreground1.BindProperty(n"tintColor", n"MainColors.Fullscreen_PrimaryBackgroundDarkest");
    foreground1.Reparent(flexbox);

    let foreground: ref<inkRectangle> = new inkRectangle();
    foreground.SetName(n"foreground");
    foreground.SetInteractive(true);
    foreground.SetAnchor(inkEAnchor.Centered);
    foreground.SetAnchorPoint(0.5, 0.5);
    foreground.SetHAlign(inkEHorizontalAlign.Right);
    foreground.SetVAlign(inkEVerticalAlign.Top);
    foreground.SetMargin(inkMargin(0.0, 8.0, 8.0, 0.0));
    foreground.SetSize(25.0, 25.0);
    foreground.SetVisible(false);
    foreground.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    foreground.BindProperty(n"tintColor", n"MainColors.MildRed");
    foreground.Reparent(flexbox);

    let border: ref<inkBorderVA> = new inkBorderVA();
    border.SetName(n"border");
    border.SetSize(40.0, 40.0);
    border.SetOpacity(0.3);
    border.SetAnchor(inkEAnchor.Centered);
    border.SetAnchorPoint(0.5, 0.5);
    border.SetHAlign(inkEHorizontalAlign.Right);
    border.SetVAlign(inkEVerticalAlign.Top);
    border.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    border.BindProperty(n"tintColor", n"MainColors.MildRed");
    border.SetThickness(4.0);
    border.Reparent(flexbox);

    let checkboxLabel: ref<inkText> = new inkText();
    checkboxLabel.SetName(n"label");
    checkboxLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    checkboxLabel.SetFontSize(44);
    checkboxLabel.SetFontStyle(n"Regular");
    checkboxLabel.SetMargin(inkMargin(12.0, 0.0, 32.0, 0.0));
    checkboxLabel.SetLetterCase(textLetterCase.OriginalCase);
    checkboxLabel.SetVerticalAlignment(textVerticalAlignment.Center);
    checkboxLabel.SetText(GetLocalizedTextByKey(locKey));
    checkboxLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    checkboxLabel.BindProperty(n"tintColor", n"MainColors.White");
    checkboxLabel.Reparent(checkboxWrapper);

    return checkboxWrapper;
  }

  private final func InvalidateSearchControls() -> Void {
    let filtersChanged: Bool = NotEquals(this.searchInputQuery, "")
      || this.checkboxRangedWeaponsChecked
      || this.checkboxMeleeWeaponsChecked
      || this.checkboxClothesChecked
      || this.checkboxConsumablesChecked
      || this.checkboxGrenadesChecked
      || this.checkboxAttachmentsChecked
      || this.checkboxProgramsChecked
      || this.checkboxCyberwareChecked
      || this.checkboxJunkChecked
      || this.checkboxFaceChecked
      || this.checkboxFeetChecked
      || this.checkboxHeadChecked
      || this.checkboxLegsChecked
      || this.checkboxInnerChestChecked
      || this.checkboxOuterChestChecked
      || this.checkboxOutfitChecked
      || this.checkboxNewWardrobeChecked;

    let resultsAvailable: Bool = this.resultsCounter > 0 && !this.isSearching;

    this.buttonReset.SetDisabled(!filtersChanged);
    this.buttonSearch.SetDisabled(!filtersChanged || this.isSearching);
    this.buttonResults.SetDisabled(!resultsAvailable);
  }

  private final func InitializeListeners() -> Void {
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnHandleGlobalRelease");

    this.RegisterToCallback(n"OnClick", this, n"OnWidgetClick");
    this.RegisterToCallback(n"OnHoverOver", this, n"OnWidgetHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnWidgetHoverOut");
  }

  private final func UninitializeListeners() -> Void {
    if IsDefined(this.searchInput) {
      this.searchInput.UnregisterFromCallback(n"OnInput", this, n"OnSearchInput");
    };

    this.UnregisterFromCallback(n"OnClick", this, n"OnWidgetClick");
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnWidgetHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnWidgetHoverOut");

    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnHandleGlobalRelease");
  }

  private final func PlaySound(eventName: CName) -> Void {
    GameObject.PlaySoundEvent(this.player, eventName);
  }

  private final func AnimatedShow(target: wref<inkWidget>, duration: Float, delay: Float) -> ref<inkAnimProxy> {
    let proxy: ref<inkAnimProxy>;
    let elementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let currentTranslation: Vector2 = target.GetTranslation();

    let translationInterpolator = new inkAnimTranslation();
    translationInterpolator.SetDuration(duration);
    translationInterpolator.SetStartDelay(delay);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetType(inkanimInterpolationType.Linear);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    translationInterpolator.SetStartTranslation(Vector2(currentTranslation.X, -60.0));
    translationInterpolator.SetEndTranslation(Vector2(currentTranslation.X, 0.0));
    elementsAnimDef.AddInterpolator(translationInterpolator);

    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetStartTransparency(0.0);
    transparencyInterpolator.SetEndTransparency(1.0);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    transparencyInterpolator.SetDuration(duration);
    elementsAnimDef.AddInterpolator(transparencyInterpolator);

    proxy = target.PlayAnimation(elementsAnimDef);

    return proxy;
  }

  private final func AnimatedHide(target: wref<inkWidget>, duration: Float, delay: Float) -> ref<inkAnimProxy> {
    let proxy: ref<inkAnimProxy>;
    let elementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let currentTranslation: Vector2 = target.GetTranslation();

    let translationInterpolator = new inkAnimTranslation();
    translationInterpolator.SetDuration(duration);
    translationInterpolator.SetStartDelay(delay);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetType(inkanimInterpolationType.Linear);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    translationInterpolator.SetStartTranslation(Vector2(currentTranslation.X, 0));
    translationInterpolator.SetEndTranslation(Vector2(currentTranslation.X, 60.0));
    elementsAnimDef.AddInterpolator(translationInterpolator);

    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetStartTransparency(1.0);
    transparencyInterpolator.SetEndTransparency(0.0);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    transparencyInterpolator.SetDuration(duration);
    elementsAnimDef.AddInterpolator(transparencyInterpolator);

    proxy = target.PlayAnimation(elementsAnimDef);

    return proxy;
  }

  private final func Log(str: String) -> Void {
    AtelierDebug(str);
  }
}

private class HubTextInputSearch extends HubTextInput {
    public static func Create() -> ref<HubTextInputSearch> {
      let self: ref<HubTextInputSearch> = new HubTextInputSearch();
      self.CreateInstance();
      return self;
    }

    protected func CreateWidgets() -> Void {
      super.CreateWidgets();
      this.m_root.SetWidth(800.0);
      this.m_root.SetHeight(80.0);
      this.m_root.SetHAlign(inkEHorizontalAlign.Center);
      this.m_frame.BindProperty(n"tintColor", n"MainColors.MildRed");
      this.m_hover.BindProperty(n"tintColor", n"MainColors.Red");
      this.m_focus.BindProperty(n"tintColor", n"MainColors.ActiveRed");
    }
}

private class SimpleButtonSearch extends SimpleButton {
    public static func Create() -> ref<SimpleButtonSearch> {
      let self: ref<SimpleButtonSearch> = new SimpleButtonSearch();
      self.CreateInstance();
      return self;
    }

    protected func CreateWidgets() -> Void {
      super.CreateWidgets();
      this.m_label.SetFontSize(42);
    }

  public final func SetSize(width: Float, height: Float) -> Void {
    this.m_root.SetSize(Vector2(width, height));
  }
}
