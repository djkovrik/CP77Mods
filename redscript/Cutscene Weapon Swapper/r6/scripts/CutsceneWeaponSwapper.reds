module CutsceneWeaponSwap

// misc stuff for Nocturne support
public class CutsceneRoofOriginal extends IScriptable {
  public let id: Uint64;
  public let component: wref<IComponent>;
}

public class CutsceneRoofVisual extends IScriptable {
  public let path: ResRef;
  public let definition: CName;
  public let alias: CName;
}

public class CutsceneRoofContext extends IScriptable {
  public let sectorPath: ResRef;
  public let nodeRef: NodeRef;
  public let entityID: EntityID;
  public let selected: ref<CutsceneRoofVisual>;
  public let selectedRecord: TweakDBID;
  public let baseline: array<ref<CutsceneRoofOriginal>>;
  public let node: wref<worldEntityNode>;
  public let ownsNode: Bool;
  public let hidden: array<wref<entSkinnedMeshComponent>>;
  public let resolvedEntity: wref<Entity>;
}

public class CutsceneRoofAppearanceEvent extends CallbackSystemEvent {
  public let carrierRecord: TweakDBID;
  public let carrierVisual: ref<CutsceneRoofVisual>;
  public let stage: CName;
  public let path: ResRef;
  public let entityID: EntityID;
  public let resource: ref<CResource>;
  public let entity: wref<Entity>;
  public let builder: ref<EntityBuilderWrapper>;
}

public class CutsceneRoofAppearance extends IScriptable {
  private let contexts: array<ref<CutsceneRoofContext>>;
  private let templateToken: ref<ResourceToken>;
  private let factoryToken: ref<ResourceToken>;
  private let appTokens: array<ref<ResourceToken>>;
  private let aliases: array<ref<CutsceneRoofVisual>>;
  private let closing: Bool;

  private static func TemplatePath() -> ResRef = r"base\\quest\\main_quests\\part1\\q115\\entities\\q115_ripperdoc_gun.ent"
  private static func AppearancePath() -> ResRef = r"base\\weapons\\firearms\\revolver\\malorian_overture\\w_revolver__malorian_overture.app"
  
  private func AddContext(sector: ResRef, reference: String) -> Void {
    let context = new CutsceneRoofContext();
    context.sectorPath = sector;
    context.nodeRef = CreateNodeRef(reference);
    ArrayPush(this.contexts, context);
  }

  private func FindContext(work: ref<CutsceneRoofAppearanceEvent>) -> ref<CutsceneRoofContext> {
    for context in this.contexts {
      if Equals(work.stage, n"Sector") {
        if Equals(work.path, context.sectorPath) { return context; };
      } else {
        if EntityID.IsDefined(work.entityID) && Equals(work.entityID, context.entityID) { return context; };
      };
    };

    return null;
  }

  public func Initialize() -> Void {
    this.AddContext(r"base\\worlds\\03_night_city\\_compiled\\default\\exterior_-25_18_0_0.streamingsector", "$/03_night_city/c_watson/little_china/loc_q115_mistyc_mistys_ripperdoc_roof_prefabDR5IG6A/loc_q115_mystic_mistys_ripperdoc_roof_gameplay_prefab75UZAWI/loc_q115_mystic_mistys_ripperdoc_roof_devices_prefabNCP6VPY/#q115_ent_v_gun");
    this.AddContext(r"base\\worlds\\03_night_city\\_compiled\\default\\exterior_-25_19_0_0.streamingsector", "$/03_night_city/c_watson/little_china/loc_mystic_mistys_ripperdoc_prefabH2DWJJI/#loc_mystic_mistys_ripperdoc_gameplay/#q115_ripperdoc_gun_prop");
    
    let callbacks: ref<CallbackSystem> = GameInstance.GetCallbackSystem();

    callbacks.RegisterEvent(n"CutsceneWeaponSwap.CutsceneRoofAppearanceEvent");
    callbacks.RegisterCallback(n"CutsceneWeaponSwap.CutsceneRoofAppearanceEvent", this, n"OnWork", true);
    callbacks.RegisterCallback(n"Session/BeforeStart", this, n"OnSession", true);
    callbacks.RegisterCallback(n"Session/BeforeEnd", this, n"OnSession", true);

    callbacks.RegisterCallback(n"Resource/PostLoad", this, n"OnResource", true)
      .AddTarget(ResourceTarget.Path(r"base\\worlds\\03_night_city\\_compiled\\default\\exterior_-25_18_0_0.streamingsector"))
      .AddTarget(ResourceTarget.Path(r"base\\worlds\\03_night_city\\_compiled\\default\\exterior_-25_19_0_0.streamingsector"));

    callbacks.RegisterCallback(n"Entity/Extract", this, n"OnExtract", true)
      .AddTarget(EntityTarget.Template(CutsceneRoofAppearance.TemplatePath()));

    callbacks.RegisterCallback(n"Entity/AfterAttach", this, n"OnAttached", true)
      .AddTarget(EntityTarget.Template(CutsceneRoofAppearance.TemplatePath()));
  }

  private cb func OnSession(event: ref<GameSessionEvent>) {
    let work = new CutsceneRoofAppearanceEvent();
    work.stage = event.GetEventName();
    GameInstance.GetCallbackSystem().DispatchEvent(work);
  }

  private cb func OnResource(event: ref<ResourceEvent>) {
    let work = new CutsceneRoofAppearanceEvent();
    work.stage = n"Sector";
    work.resource = event.GetResource();
    work.path = event.GetPath();
    GameInstance.GetCallbackSystem().DispatchEvent(work);
  }

  private cb func OnExtract(event: ref<EntityBuilderEvent>) {
    let builder = event.GetEntityBuilder();
    if !IsDefined(builder) { return; };
    let work = new CutsceneRoofAppearanceEvent();
    work.stage = n"Extract";
    work.builder = builder;
    work.entityID = builder.GetEntityID();

    GameInstance.GetCallbackSystem().DispatchEvent(work);
  }

  private cb func OnAttached(event: ref<EntityLifecycleEvent>) {
    let entity = event.GetEntity();
    if !IsDefined(entity) { return; };

    let work = new CutsceneRoofAppearanceEvent();
    work.stage = n"Attached";
    work.entity = entity;
    work.entityID = entity.GetEntityID();
    GameInstance.GetCallbackSystem().DispatchEvent(work);
  }

  private func PreloadApp(path: ResRef) -> Void {
    let depot: ref<ResourceDepot> = GameInstance.GetResourceDepot();
    if depot.ResourceExists(path) { 
      ArrayPush(this.appTokens, depot.LoadResource(path)); 
    };
  }

  // vanilla weapons list
  private func BeginPreload() -> Void {
    if IsDefined(this.templateToken) { return; };

    let depot = GameInstance.GetResourceDepot();
    this.templateToken = depot.LoadResource(CutsceneRoofAppearance.TemplatePath());
    this.factoryToken = depot.LoadResource(r"base\\gameplay\\factories\\items\\weapons\\weapons_appearances.csv");

    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\militech_lexington\\w_handgun__militech_lexington.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\militech_omaha\\w_handgun__militech_omaha.app");
    this.PreloadApp(r"base\\weapons\\firearms\\revolver\\malorian_overture\\w_revolver__malorian_overture.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\militech_lexington\\w_handgun__militech_lexington__silenced.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\w_handgun__arasaka_kenshin.app");
    this.PreloadApp(r"base\\weapons\\firearms\\revolver\\darra_quasar\\w_revolver__darra_quasar.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\tsunami_nue\\w_handgun__tsunami_nue.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\budget_slaughtomatic\\w_handgun__budget_slaughtomatic.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\tsunami_nue\\w_handgun__tsunami_nue_jackie.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\arasaka_yukimura\\w_handgun__arasaka_yukimura.app");
    this.PreloadApp(r"base\\weapons\\firearms\\revolver\\techtronika_burya\\w_revolver__techtronika_burya.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\tsunami_nue\\w_handgun__tsunami_nue_scope.app");
    this.PreloadApp(r"base\\weapons\\firearms\\revolver\\darra_nova\\w_revolver__darra_nova.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\constitutional_liberty\\w_handgun__constitutional_liberty__rogue.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\kangtao_chao\\w_handgun__kangtao_chao.app");
    this.PreloadApp(r"base\\weapons\\firearms\\revolver\\militech_crusher\\w_revolver__militech_crusher.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\constitutional_unity\\w_handgun__constitutional_unity.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\malorian_silverhand\\w_handgun__malorian_silverhand.app");
    this.PreloadApp(r"base\\weapons\\firearms\\handgun\\tsunami_kappa\\w_handgun__arasaka_kappa.app");
    this.PreloadApp(r"ep1\\weapons\\firearms\\revolver\\techtronika_metel\\w_revolver__techtronika_metel.app");
    this.PreloadApp(r"ep1\\weapons\\firearms\\handgun\\krausser_grit\\w_handgun__krausser_grit.app");
    this.PreloadApp(r"ep1\\weapons\\firearms\\handgun\\militech_ticon\\w_handgun__militech_ticon.app");
  }

  private func ResolveVisual(context: ref<CutsceneRoofContext>, opt suppliedRecord: TweakDBID) -> Bool {
    context.selected = null;
    context.selectedRecord = t"";

    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    let service = CutsceneWeaponSwapper.Get();
    if !IsDefined(player) || !IsDefined(service) {
       return false;
    };

    context.selectedRecord = suppliedRecord;

    if Equals(suppliedRecord, t"") { 
      context.selectedRecord = service.GetRoofWeaponToDisplay(player); 
    };

    if Equals(context.selectedRecord, t"") { 
      return false; 
    };

    let record = TweakDBInterface.GetItemRecord(context.selectedRecord);

    if !IsDefined(record) { return false; };

    let key = record.AppearanceResourceName();
    let tags = record.VisualTags();

    if ArraySize(tags) == 0 || ArraySize(tags) > 32 { 
      return false; 
    };

    if !IsDefined(this.factoryToken) || !this.factoryToken.IsLoaded() {
       return false;
    };

    let factory = this.factoryToken.GetResource() as C2dArray;

    if !IsDefined(factory) || ArraySize(factory.data) > 4096 { 
      return false; 
    };

    let names: Int32 = -1;
    let paths: Int32 = -1;
    let i: Int32 = 0;

    for header in factory.headers {
      if Equals(header, "name") { if names >= 0 { return false; }; names = i; };
      if Equals(header, "path") { if paths >= 0 { return false; }; paths = i; };
      i += 1;
    };

    if names < 0 || paths < 0 { return false; };

    let matches: Int32 = 0;
    let path: ResRef;
    for row in factory.data {
      if ArraySize(row) > names && ArraySize(row) > paths && Equals(StringToName(row[names]), key) {
        matches += 1;
        path = ResRef.FromString(row[paths]);
      };
    };

    if matches != 1 { return false; };

    let token: ref<ResourceToken>;
    for candidate in this.appTokens { 
      if Equals(candidate.GetPath(), path) { 
        token = candidate; 
      }; 
    };

    if !IsDefined(token) { return false; };
    if !token.IsLoaded() { return false; };

    let app = token.GetResource() as appearanceAppearanceResource;
    if !IsDefined(app) || ArraySize(app.appearances) > 256 { 
      return false; 
    };

    matches = 0;
    let chosen: CName;
    let accepted: Bool;
    for definition in app.appearances {
      if IsDefined(definition) {
        accepted = true;
        for tag in tags {
          if Equals(tag, n"None") || (!ArrayContains(definition.visualTags.tags, tag) && !ArrayContains(definition.inheritedVisualTags.tags, tag)) { accepted = false; };
        };
        if accepted { matches += 1; chosen = definition.name; };
      };
    };

    if matches != 1 || Equals(chosen, n"None") { return false; };
    matches = 0;

    for definition in app.appearances { 
      if IsDefined(definition) && Equals(definition.name, chosen) { 
        matches += 1; 
      }; 
    };

    if matches != 1 { return false; };

    context.selected = new CutsceneRoofVisual();
    context.selected.path = path;
    context.selected.definition = chosen;
    return true;
  }

  public func ResolveCarrierVisual(record: TweakDBID) -> ref<CutsceneRoofVisual> {
    let work = new CutsceneRoofAppearanceEvent();
    work.stage = n"CarrierVisual";
    work.carrierRecord = record;

    GameInstance.GetCallbackSystem().DispatchEvent(work);
    return work.carrierVisual;
  }

  private func ResolveCarrierVisualLocked(record: TweakDBID) -> ref<CutsceneRoofVisual> {
    if Equals(record, t"") { return null; };
    this.BeginPreload();
    let context = new CutsceneRoofContext();
    if !this.ResolveVisual(context, record) || !this.PrepareAlias(context) { return null; };
    return context.selected;
  }

  public func ValidateCarierStructure(components: array<ref<IComponent>>, index: ref<inkHashMap>, baseline: array<ref<CutsceneRoofOriginal>>) -> Bool {
    let context = new CutsceneRoofContext();
    context.baseline = baseline;
    return this.ValidateStructure(components, index, context);
  }

  private func PrepareAlias(context: ref<CutsceneRoofContext>) -> Bool {
    if !IsDefined(context.selected) || !IsDefined(this.templateToken) || !this.templateToken.IsLoaded() { return false; };
    
    let template = this.templateToken.GetResource() as entEntityTemplate;
    if !IsDefined(template) || NotEquals(template.defaultAppearance, n"default") { return false; };

    let owned: Bool = false;
    for previous in this.aliases {
      if Equals(previous.path, context.selected.path) && Equals(previous.definition, context.selected.definition) {
        context.selected = previous; owned = true;
      };
    };

    if !owned {
      if ArraySize(this.aliases) >= 128 { return false; };
      context.selected.alias = StringToName(s"cws_roof_player_app_\(ArraySize(this.aliases))");
    };

    let matches: Int32 = 0;
    let valid: Bool = false;
    for entry in template.appearances {
      if Equals(entry.name, context.selected.alias) {
        matches += 1;
        valid = Equals(entry.appearanceName, context.selected.definition) && Equals(ResourceAsyncRef.GetPath(entry.appearanceResource), context.selected.path);
      };
    };

    if owned { return matches == 1 && valid; };
    if matches != 0 { return false; };

    let entry: entTemplateAppearance;
    entry.name = context.selected.alias;
    entry.appearanceName = context.selected.definition;
    ResourceAsyncRef.SetPath(entry.appearanceResource, context.selected.path);
    ArrayPush(template.appearances, entry);
    ArrayPush(this.aliases, context.selected);

    return true;
  }

  private func RestoreNode(context: ref<CutsceneRoofContext>) -> Void {
    if context.ownsNode && IsDefined(context.node) && IsDefined(context.selected) {
      if Equals(ResourceAsyncRef.GetPath(context.node.entityTemplate), CutsceneRoofAppearance.TemplatePath()) && Equals(context.node.appearanceName, context.selected.alias) {
        context.node.appearanceName = n"default";
      };
    };
    context.ownsNode = false;
  }

  private func SelectNode(context: ref<CutsceneRoofContext>) -> Void {
    if !IsDefined(context.node) || this.closing { return; };
    if NotEquals(ResourceAsyncRef.GetPath(context.node.entityTemplate), CutsceneRoofAppearance.TemplatePath()) 
      || NotEquals(context.node.appearanceName, n"default") 
      || IsDefined(context.node.instanceData) {
        return;
    };

    if !this.ResolveVisual(context) || !this.PrepareAlias(context) {
      return;
    };
    context.node.appearanceName = context.selected.alias;
    context.ownsNode = true;
  }

  private func ReadSector(sector: ref<worldStreamingSector>, context: ref<CutsceneRoofContext>) -> Void {
    if !IsDefined(sector) { return; };

    let count = sector.GetNodeSetupCount();
    let targetRef = context.nodeRef;
    let target: ref<worldEntityNode>;
    let matches: Int32 = 0;
    let i: Int32 = 0;
    let setup: ref<WorldNodeSetupWrapper>;

    while i < count {
      setup = sector.GetNodeSetup(i);
      if IsDefined(setup) && Equals(setup.GetNodeRef(), targetRef) {
        matches += 1;
        target = setup.GetNode() as worldEntityNode;
      };
      i += 1;
    };

    if matches == 1 && IsDefined(target) {
      let previousNode: ref<worldEntityNode> = context.node;
      if Equals(previousNode, target) { return; };
      this.RestoreNode(context);
      context.node = target;
      context.resolvedEntity = null;
      ArrayClear(context.baseline);
      this.SelectNode(context);
    };
  }

  private func RestoreMeshes(context: ref<CutsceneRoofContext>) -> Void {
    for mesh in context.hidden {
      if IsDefined(mesh) {
        if !mesh.IsEnabled() { mesh.Toggle(true); };
      };
    };

    ArrayClear(context.hidden);
  }

  private static func Match(index: ref<inkHashMap>, id: Uint64, name: CName, type: CName, bind: CName, slot: CName, path: ResRef) -> Bool {
    let component = index.Get(id) as IComponent;
    if !IsDefined(component) || NotEquals(component.name, name) || NotEquals(component.GetClassName(), type) {
      return false;
    };
    let placed = component as IPlacedComponent;
    if IsDefined(placed) {
      if Equals(bind, n"None") {
        if IsDefined(placed.parentTransform) { return false; };
      } else {
        let binding = placed.parentTransform as entHardTransformBinding;
        if !IsDefined(binding) || NotEquals(binding.bindName, bind) || NotEquals(binding.slotName, slot) { return false; };
      };
    };
    let mesh = component as entSkinnedMeshComponent;
    if IsDefined(mesh) && NotEquals(ResourceAsyncRef.GetPath(mesh.mesh), path) { return false; };
    return true;
  }

  private func ValidateDonor(index: ref<inkHashMap>, context: ref<CutsceneRoofContext>) -> Bool {
    if !CutsceneRoofAppearance.Match(index, 1611189863225266176ul, n"Barrel", n"entAnimatedComponent", n"Receiver", n"None", r"") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1611238324750553092ul, n"w_revolver__malorian_overture__base1_010570", n"entSkinnedMeshComponent", n"Barrel", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__base1_01.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 2099813352632643584ul, n"w_revolver__malorian_overture__rail", n"entSkinnedMeshComponent", n"Barrel", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__base1_01_rail.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1600895446266449920ul, n"Receiver", n"entAnimatedComponent", n"None", n"None", r"") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1611248720802779140ul, n"w_revolver__malorian_overture__rcv1_017720", n"entSkinnedMeshComponent", n"Receiver", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__rcv1_01.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1782332049551159296ul, n"w_revolver__malorian_overture__rcv1_diode", n"entSkinnedMeshComponent", n"Receiver", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__rcv1_01_diode.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1824175987189911556ul, n"Magazine", n"entAnimatedComponent", n"Barrel", n"None", r"") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471378405330944ul, n"w_revolver__malorian_overture__mag_std_01_01_shell", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_01_shell.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471494268784640ul, n"w_revolver__malorian_overture__mag_std_01_01_tip", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_01_tip.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471539282055168ul, n"w_revolver__malorian_overture__mag_std_01_02_shell", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_02_shell.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471641086201856ul, n"w_revolver__malorian_overture__mag_std_01_02_tip", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_02_tip.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471730257104896ul, n"w_revolver__malorian_overture__mag_std_01_03_shell", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_03_shell.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471796241895424ul, n"w_revolver__malorian_overture__mag_std_01_03_tip", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_03_tip.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471890177527808ul, n"w_revolver__malorian_overture__mag_std_01_04_shell", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_04_shell.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471912306675712ul, n"w_revolver__malorian_overture__mag_std_01_04_tip", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_04_tip.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471941633249280ul, n"w_revolver__malorian_overture__mag_std_01_05_shell", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_05_shell.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471970993377280ul, n"w_revolver__malorian_overture__mag_std_01_05_tip", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_05_tip.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786471998390571008ul, n"w_revolver__malorian_overture__mag_std_01_06_shell", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_06_shell.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786472035300446208ul, n"w_revolver__malorian_overture__mag_std_01_06_tip", n"entSkinnedMeshComponent", n"Magazine", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_std_01_06_tip.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 2044601134467411968ul, n"w_revolver__malorian_overture__base1_01_decal_n", n"entSkinnedMeshComponent", n"Barrel", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__base1_01_decal_n.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 2044600057705689088ul, n"w_revolver__malorian_overture__base1_01_decal_d", n"entSkinnedMeshComponent", n"Barrel", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__base1_01_decal_d.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 2044603614039273472ul, n"w_revolver__malorian_overture__rcv1_01_decal_n", n"entSkinnedMeshComponent", n"Barrel", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__rcv1_01_decal_n.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1824176849203269636ul, n"MagazineReload", n"entAnimatedComponent", n"Barrel", n"None", r"") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786475431881379840ul, n"w_revolver__malorian_overture__mag_stdr_01_01", n"entSkinnedMeshComponent", n"MagazineReload", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_stdr_01_01.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786475531135389696ul, n"w_revolver__malorian_overture__mag_stdr_01_02", n"entSkinnedMeshComponent", n"MagazineReload", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_stdr_01_02.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786475554355056640ul, n"w_revolver__malorian_overture__mag_stdr_01_03", n"entSkinnedMeshComponent", n"MagazineReload", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_stdr_01_03.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786475580930166784ul, n"w_revolver__malorian_overture__mag_stdr_01_04", n"entSkinnedMeshComponent", n"MagazineReload", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_stdr_01_04.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786475614987915264ul, n"w_revolver__malorian_overture__mag_stdr_01_05", n"entSkinnedMeshComponent", n"MagazineReload", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_stdr_01_05.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786475683539619840ul, n"w_revolver__malorian_overture__mag_stdr_01_handle", n"entSkinnedMeshComponent", n"MagazineReload", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_stdr_01_handle.mesh") { return false; };
    if !CutsceneRoofAppearance.Match(index, 1786483909995827200ul, n"w_revolver__malorian_overture__mag_stdr_01_06", n"entSkinnedMeshComponent", n"MagazineReload", n"None", r"base\\weapons\\firearms\\revolver\\malorian_overture\\entities\\meshes\\w_revolver__malorian_overture__mag_stdr_01_06.mesh") { return false; };
    return true;
  }

  private func ValidateStructure(components: array<ref<IComponent>>, index: ref<inkHashMap>, context: ref<CutsceneRoofContext>) -> Bool {
    if ArraySize(context.baseline) != 20 { return false; };
    let originalIDs = new inkHashMap();
    for original in context.baseline {
      if originalIDs.KeyExist(original.id) { return false; };
      originalIDs.Insert(original.id, original);
    };

    for id in [1186531487147298816ul, 1186533189145530368ul, 1263305940216905728ul, 2186680792687583232ul, 2186681124876460032ul, 2502632666255785984ul] {
      let original = originalIDs.Get(id) as CutsceneRoofOriginal;
      if !IsDefined(original) || !IsDefined(original.component) || index.Get(id) != original.component {
         return false;
      };
    };

    let names = new inkHashMap();
    let ambiguous = new inkHashMap();
    for component in components {
      if IsDefined(component) {
        let key = NameToHash(component.name);
        if names.KeyExist(key) { ambiguous.Insert(key, component); }
        else { names.Insert(key, component); };
      };
    };
    let meshes: Int32 = 0;
    let animated: Int32 = 0;
    for component in components {
      if IsDefined(component) && !originalIDs.KeyExist(CRUIDToHash(component.id)) {
        let mesh = component as entSkinnedMeshComponent;
        if IsDefined(mesh) {
          if ResourceAsyncRef.IsEmpty(mesh.mesh) { return false; };
          meshes += 1;
        };
        if IsDefined(component as AnimatedComponent) { animated += 1; };
        let placed = component as IPlacedComponent;
        if IsDefined(placed) && IsDefined(placed.parentTransform) {
          let binding = placed.parentTransform as entHardTransformBinding;
          if !IsDefined(binding) { return false; };
          let key = NameToHash(binding.bindName);
          let parent = names.Get(key) as IComponent;
          if !IsDefined(parent) || NotEquals(parent.name, binding.bindName) || ambiguous.KeyExist(key) {
             return false;
          };
        };
      };
    };

    return meshes > 0 && animated > 0;
  }

  private func ApplyVisual(entity: ref<Entity>, context: ref<CutsceneRoofContext>) -> Void {
    if !IsDefined(entity) || !IsDefined(context.selected) 
      || !context.ownsNode 
      || !Equals(entity.GetEntityID(), context.entityID) 
      || NotEquals(entity.GetTemplatePath(), CutsceneRoofAppearance.TemplatePath()) 
      || NotEquals(entity.GetCurrentAppearanceName(), context.selected.alias) {
        return;
    };
    if !IsDefined(context.resolvedEntity) || context.resolvedEntity != entity {
      this.RestoreNode(context);
      return;
    };

    this.RestoreMeshes(context);

    let components = entity.GetComponents();
    if ArraySize(components) > 512 { this.RestoreNode(context); return; };
    let index = new inkHashMap();
    let duplicates: Bool = false;

    for componet in components {
      if IsDefined(componet) {
        let key = CRUIDToHash(componet.id);
        if index.KeyExist(key) { duplicates = true; } else { index.Insert(key, componet); };
      };
    };

    if duplicates || !this.ValidateStructure(components, index, context) 
      || (Equals(context.selected.path, CutsceneRoofAppearance.AppearancePath()) 
      && Equals(context.selected.definition, n"default") 
      && !this.ValidateDonor(index, context)) {
        this.RestoreNode(context);
      return;
    };

    if !CutsceneRoofAppearance.Match(index, 1186531487147298816ul, n"HitPhysicalQueryMesh", n"entColliderComponent", n"Slot5946", n"Base", r"") { this.RestoreNode(context); return; };
    if !CutsceneRoofAppearance.Match(index, 1186533189145530368ul, n"Animated5005", n"entAnimatedComponent", n"None", n"None",r"") { this.RestoreNode(context); return; };
    if !CutsceneRoofAppearance.Match(index, 1263305940216905728ul, n"Slot5946", n"entSlotComponent", n"Animated5005", n"None", r"") { this.RestoreNode(context); return; };
    if !CutsceneRoofAppearance.Match(index, 2186680792687583232ul, n"w_handgun__constitutional_unity__base1_01", n"entSkinnedMeshComponent", n"None", n"None", r"base\\weapons\\firearms\\handgun\\constitutional_unity\\entities\\meshes\\w_handgun__constitutional_unity__base1_01.mesh") { this.RestoreNode(context); return; };
    if !CutsceneRoofAppearance.Match(index, 2186681124876460032ul, n"w_handgun__constitutional_unity__base1_01_decal_n01", n"entSkinnedMeshComponent", n"None", n"None", r"base\\weapons\\firearms\\handgun\\constitutional_unity\\entities\\meshes\\w_handgun__constitutional_unity__base1_01_decal_n01.mesh") { this.RestoreNode(context); return; };
    if !CutsceneRoofAppearance.Match(index, 2502632666255785984ul, n"w_handgun__constitutional_liberty__mag_std_01", n"entSkinnedMeshComponent", n"None", n"None", r"base\\weapons\\firearms\\handgun\\constitutional_liberty\\entities\\meshes\\w_handgun__constitutional_liberty__mag_std_01.mesh") { this.RestoreNode(context); return; };
    
    let meshes: array<ref<entSkinnedMeshComponent>>;
    ArrayPush(meshes, index.Get(2186680792687583232ul) as entSkinnedMeshComponent);
    ArrayPush(meshes, index.Get(2186681124876460032ul) as entSkinnedMeshComponent);
    ArrayPush(meshes, index.Get(2502632666255785984ul) as entSkinnedMeshComponent);
    for mesh in meshes {
      if !IsDefined(mesh) || !mesh.IsEnabled() {
        this.RestoreNode(context);
        return;
      };
    };

    for mesh in meshes {
      ArrayPush(context.hidden, mesh);
      mesh.Toggle(false);
    };
  }

  private func Cleanup(context: ref<CutsceneRoofContext>) -> Void {
    this.RestoreMeshes(context);
    this.RestoreNode(context);
    context.resolvedEntity = null;
    context.node = null;
    context.selected = null;
    context.selectedRecord = t"";
    ArrayClear(context.baseline);
  }

  private cb func OnWork(work: ref<CutsceneRoofAppearanceEvent>) {
    if Equals(work.stage, n"CarrierVisual") {
      if !this.closing { work.carrierVisual = this.ResolveCarrierVisualLocked(work.carrierRecord); };
      return;
    };

    if Equals(work.stage, n"Session/BeforeEnd") {
      this.closing = true;
      for entry in this.contexts { this.Cleanup(entry); };
      return;
    };

    if Equals(work.stage, n"Session/BeforeStart") {
      this.closing = false;
      for entry in this.contexts {
        entry.entityID = Cast<EntityID>(ResolveNodeRef(entry.nodeRef, Cast<GlobalNodeRef>(GlobalNodeID.GetRoot())));
      };
      this.BeginPreload();
      return;
    };

    if this.closing { return; };

    let context = this.FindContext(work);
    if !IsDefined(context) { return; };

    if Equals(work.stage, n"Sector") { this.ReadSector(work.resource as worldStreamingSector, context); };
    if Equals(work.stage, n"Extract") {
      let builder = work.builder;
      context.resolvedEntity = null;
      ArrayClear(context.baseline);

      let appearance = builder.GetAppearance();
      if IsDefined(appearance) {
        let resource = appearance.GetResource();
        let definition = appearance.GetDefinition();
        if IsDefined(resource) && IsDefined(definition) {
          if IsDefined(context.selected) && Equals(resource.path, context.selected.path) && Equals(definition.name, context.selected.definition) && Equals(builder.GetAppearanceName(), context.selected.alias) && builder.HasEntity() {
            context.resolvedEntity = builder.GetTemplate().GetEntity();
            let originals = builder.GetTemplate().GetComponents();
            if ArraySize(originals) <= 512 {
              for component in originals {
                if IsDefined(component) {
                  let snapshot = new CutsceneRoofOriginal();
                  snapshot.id = CRUIDToHash(component.id);
                  snapshot.component = component;
                  ArrayPush(context.baseline, snapshot);
                };
              };
            };
          };
        }
      };
    };

    if Equals(work.stage, n"Attached") { 
      this.ApplyVisual(work.entity, context); 
    };
  }
}

public class CutsceneWeaponDrawContext extends IScriptable {
  public let path: ResRef;
  public let weapon: TweakDBID;
}

public class CutsceneWeaponSwapper extends ScriptableService {

  private let roofAppearance: ref<CutsceneRoofAppearance>;

  private let singleDrawPlayer: wref<PlayerPuppet>;
  private let singleDrawContexts: array<ref<CutsceneWeaponDrawContext>>;

  public static func Get() -> ref<CutsceneWeaponSwapper> {
    return GameInstance.GetScriptableServiceContainer().GetService(n"CutsceneWeaponSwap.CutsceneWeaponSwapper") as CutsceneWeaponSwapper;
  }

  private cb func OnSessionEnd(event: ref<GameSessionEvent>) {
    this.singleDrawPlayer = null;
    ArrayClear(this.singleDrawContexts);
  }

  public func FindSingleDrawContext(owner: ref<GameObject>, record: TweakDBID) -> ref<CutsceneWeaponDrawContext> {
    if !IsDefined(this.singleDrawPlayer) || this.singleDrawPlayer != owner { return null; };
    if GameInstance.GetPlayerSystem(owner.GetGame()).GetLocalPlayerMainGameObject() != owner { return null; };
    let index: Int32 = ArraySize(this.singleDrawContexts) - 1;
    while index >= 0 {
      if Equals(this.singleDrawContexts[index].weapon, record) { return this.singleDrawContexts[index]; };
      index -= 1;
    };
    return null;
  }

  private func RemoveSingleDrawContext(path: ResRef) -> Void {
    let index: Int32 = ArraySize(this.singleDrawContexts) - 1;
    while index >= 0 {
      if Equals(this.singleDrawContexts[index].path, path) { ArrayErase(this.singleDrawContexts, index); };
      index -= 1;
    };
  }

  private cb func OnLoad() {
    this.roofAppearance = new CutsceneRoofAppearance();
    this.roofAppearance.Initialize();
    GameInstance.GetCallbackSystem().RegisterCallback(n"Session/End", this, n"OnSessionEnd");
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/PostLoad", this, n"OnSceneLoaded")
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q103\\scenes\\q103_14_maelstrom.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_05_av_debris.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_07b_haru_found.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_08_courier_talks.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q110\\scenes\\q110_16b_closing_funeral.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q112\\scenes\\q112_11_shotgun.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\prologue\\q001\\scenes\\q001_04_ripperdoc.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\prologue\\q003\\scenes\\q003_03_deal.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\prologue\\q005\\scenes\\q005_02_cab_ride.scene"))
      .AddTarget(ResourceTarget.Path(r"ep1\\quest\\main_quests\\q302\\scenes\\q302_02_spider.scene"))
      .AddTarget(ResourceTarget.Path(r"ep1\\quest\\main_quests\\q306\\scenes\\q306_10_finale.scene"))
      .AddTarget(ResourceTarget.Path(r"ep1\\openworld\\street_stories\\sts_ep1_03\\scenes\\sts_ep1_03_wagner_standoff.scene"));
  }

  public func GetRoofWeaponToDisplay(player: ref<PlayerPuppet>) -> TweakDBID {
    let types: array<gamedataItemType>;
    ArrayPush(types, gamedataItemType.Wea_Handgun);
    ArrayPush(types, gamedataItemType.Wea_Revolver);
    return this.GetWeaponToDisplayRightFirst(player, types);
  }

  public func GetReedWeaponToDisplay(player: ref<PlayerPuppet>) -> TweakDBID {
    let types: array<gamedataItemType> = [gamedataItemType.Wea_Handgun, gamedataItemType.Wea_Revolver];
    return this.GetWeaponToDisplayRightFirst(player, types, true);
  }

  public func ResolveCarrierVisual(record: TweakDBID) -> ref<CutsceneRoofVisual> {
    return this.roofAppearance.ResolveCarrierVisual(record);
  }

  public func ValidateCarierStructure(components: array<ref<IComponent>>, index: ref<inkHashMap>, baseline: array<ref<CutsceneRoofOriginal>>) -> Bool {
    return this.roofAppearance.ValidateCarierStructure(components, index, baseline);
  }

  private cb func OnSceneLoaded(event: ref<ResourceEvent>) {
    if Equals(event.GetPath(), CutsceneReedAppearance.ScenePath()) {
      let reed = CutsceneReedAppearance.Get();
      if IsDefined(reed) { reed.HandleScene(event); };
      return;
    };
    this.ProcessScene(event, t"");
  }

  public func ProcessScene(event: ref<ResourceEvent>, reedRecord: TweakDBID) -> Void {
    let scenePath: ResRef = event.GetPath();
    this.RemoveSingleDrawContext(scenePath);
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if !IsDefined(player) {
      return ;
    };

    if this.singleDrawPlayer != player {
      ArrayClear(this.singleDrawContexts);
      this.singleDrawPlayer = player;
    };

    let pistols: array<gamedataItemType> = [ gamedataItemType.Wea_Handgun, gamedataItemType.Wea_Revolver ];
    let shotgun: array<gamedataItemType> = [ gamedataItemType.Wea_Shotgun ];
    let weaponToDisplay: TweakDBID;
    if Equals(scenePath, CutsceneReedAppearance.ScenePath()) {
      weaponToDisplay = reedRecord;
    } else if Equals(scenePath, r"base\\quest\\main_quests\\part1\\q112\\scenes\\q112_11_shotgun.scene") {
      weaponToDisplay = this.GetWeaponToDisplay(player, shotgun);
    } else {
      weaponToDisplay = this.GetWeaponToDisplayRightFirst(player, pistols);
    };

    this.HandleCompat(player);

    let path: ResRef = event.GetPath();

    let q001: Bool = Equals(path, r"base\\quest\\main_quests\\prologue\\q001\\scenes\\q001_04_ripperdoc.scene");
    let q003: Bool = Equals(path, r"base\\quest\\main_quests\\prologue\\q003\\scenes\\q003_03_deal.scene");
    let q005: Bool = Equals(path, r"base\\quest\\main_quests\\prologue\\q005\\scenes\\q005_02_cab_ride.scene");
    let q103: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q103\\scenes\\q103_14_maelstrom.scene");
    let q104_05: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_05_av_debris.scene");
    let q104_07: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_07b_haru_found.scene");
    let q104_08: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_08_courier_talks.scene");
    let q110: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q110\\scenes\\q110_16b_closing_funeral.scene");
    let q112: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q112\\scenes\\q112_11_shotgun.scene");
    let q302: Bool = Equals(path, r"ep1\\quest\\main_quests\\q302\\scenes\\q302_02_spider.scene");
    let q306: Bool = Equals(path, r"ep1\\quest\\main_quests\\q306\\scenes\\q306_10_finale.scene");
    let sts03: Bool = Equals(path, r"ep1\\openworld\\street_stories\\sts_ep1_03\\scenes\\sts_ep1_03_wagner_standoff.scene");

    if Equals(weaponToDisplay, t"") {
      return ;
    };

    let scene: ref<scnSceneResource> = event.GetResource() as scnSceneResource;
    if !IsDefined(scene) || !IsDefined(scene.sceneGraph) { return; };

    // Patch props (replace scene.props item with a new one)
    let patchingIndexes: array<Int32>;
    let patchedProps: array<scnPropDef>;
    let propIndex: Int32 = 0;

    for prop in scene.props {

      // The Ripperdoc - ammo counter implant testing
      if q001 && (prop.propId.id == 3u || prop.propId.id == 16u) && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity_Cutscene") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 1281u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // The Pickup - Royce conversation
      if q003 && prop.propId.id == 6u && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // The Heist - Delamain ride to Konpeki
      if q005 && prop.propId.id == 5u && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Ghost Town - Panam negotiations with 6th Street
      if q103 && prop.propId.id == 2u && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 2561u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Life During Wartime - negotiating with KangTao pilot
      if q104_05 && prop.propId.id == 0u && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 1537u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Life During Wartime - Hellman first meet
      if q104_07 && prop.propId.id == 0u && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        let weaponProp: TweakDBID = this.CreateWeaponProp(player, weaponToDisplay);
        weaponToDisplay = weaponProp;
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 1281u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Life During Wartime - Hellman interrogation
      if q104_08 && prop.propId.id == 3u && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 769u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Search and Destroy - hotel talk
      if q112 && prop.propId.id == 4u && Equals(prop.specPropRecordId, t"Items.Preset_Tactician_Default") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Spider and the Fly (Phantom Liberty) - boss fight
      if q302 && prop.propId.id == 15u && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity_Cutscene") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Gig: The Man Who Killed Jason Foreman (Phantom Liberty)
      if sts03 && prop.propId.id == 2u && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity_Cutscene") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      propIndex += 1;
    };

    let patchedPropsCount: Int32 = ArraySize(patchedProps);
    let patchingIndexesCount: Int32 = ArraySize(patchingIndexes);
    if NotEquals(patchedPropsCount, 0) && Equals(patchedPropsCount, patchingIndexesCount) {
      let index: Int32 = 0;
      while index < patchingIndexesCount {
        let newProp: scnPropDef = patchedProps[index];
        let indexToPatch: Int32 = patchingIndexes[index];
        scene.props[indexToPatch] = newProp;
        index += 1;
      };
    };

    let equipIds: array<Int32>;
    let unequipIds: array<Int32>;
    let hasEquip: Bool = false;
    if q001 {
      equipIds = [2493];
      unequipIds = [2497];
    };
    if q003 {
      equipIds = [7521, 8704, 10191];
      unequipIds = [10186];
    };
    if q005 {
      equipIds = [1899];
      unequipIds = [1901];
    };
    if q104_05 {
      equipIds = [4739];
    };
    if q110 {
      equipIds = [141];
    };
    if q112 {
      equipIds = [1139];
      unequipIds = [2509];
    };
    if q302 {
      equipIds = [4690, 10573];
      unequipIds = [630];
    };
    if q306 {
      equipIds = [5429];
    };
    if sts03 {
      equipIds = [2290];
    };
    let questNode: ref<scnQuestNode>;
    let nodeDefinition: ref<questEquipItemNodeDefinition>;
    for node in scene.sceneGraph.graph {
      questNode = node as scnQuestNode;
      if IsDefined(questNode) {
        nodeDefinition = questNode.questNode as questEquipItemNodeDefinition;
        if this.PatchQuestEquipItemNodeDefinition(nodeDefinition, weaponToDisplay, equipIds, unequipIds, q005, q112, q306, q110) {
          hasEquip = true;
        };
      };
    };
    if hasEquip && !q112 {
      let context: ref<CutsceneWeaponDrawContext> = new CutsceneWeaponDrawContext();
      context.path = path;
      context.weapon = weaponToDisplay;
      ArrayPush(this.singleDrawContexts, context);
    };
  }

  private final func PatchSpawnInEntityProp(baseProp: scnPropDef, weaponId: TweakDBID) -> scnPropDef {
    if NotEquals(ToString(baseProp.entityAcquisitionPlan), "findInEntity") {
      return baseProp;
    };
    let patchedProp: scnPropDef = baseProp;
    patchedProp.findEntityInEntityParams.itemID = weaponId;
    patchedProp.specPropRecordId = weaponId;
    return patchedProp;
  }

  private final func PatchSpawnDespawnProp(baseProp: scnPropDef, performer: Uint32, weaponId: TweakDBID) -> scnPropDef {
    if NotEquals(ToString(baseProp.entityAcquisitionPlan), "spawnDespawn") {
      return baseProp;
    };
    let performerId: scnPerformerId;
    performerId.id = performer;
    let patchedProp: scnPropDef = baseProp;
    patchedProp.spawnDespawnParams.findInWorld = true;
    patchedProp.spawnDespawnParams.forceMaxVisibility = true;
    patchedProp.spawnDespawnParams.itemOwnerId = performerId;
    patchedProp.spawnDespawnParams.specRecordId = weaponId;
    patchedProp.specPropRecordId = weaponId;
    return patchedProp;
  }

  private final func PatchQuestEquipItemNodeDefinition(nodeDefinition: ref<questEquipItemNodeDefinition>, weaponId: TweakDBID, equipIds: array<Int32>, unequipIds: array<Int32>, isQ005: Bool, isQ112: Bool, isQ306: Bool, isQ110: Bool) -> Bool {
    if !IsDefined(nodeDefinition) || !IsDefined(nodeDefinition.params) || !nodeDefinition.params.isPlayer { return false; };
    let expected: TweakDBID = t"Items.Preset_V_Unity_Cutscene";
    if isQ005 { expected = t"Items.Preset_V_Unity"; };
    if isQ112 { expected = t"Items.Preset_Tactician_Default"; };
    if isQ306 { expected = t"Items.Preset_Overture_Default"; };
    if NotEquals(nodeDefinition.params.itemId, expected) && NotEquals(nodeDefinition.params.itemId, weaponId) { return false; };
    let id: Int32 = Cast<Int32>(nodeDefinition.id);
    if Equals(nodeDefinition.params.type, questNodeType.Equip) && ArrayContains(equipIds, id) {
      if !nodeDefinition.params.byItem {
        if !isQ110 || NotEquals(ToString(nodeDefinition.params.equipTypes), "LastUsedRangedWeapon") { return false; };
        nodeDefinition.params.byItem = true;
      };
      nodeDefinition.params.itemId = weaponId;
      return true;
    };
    if Equals(nodeDefinition.params.type, questNodeType.Unequip) && nodeDefinition.params.byItem && ArrayContains(unequipIds, id) {
      nodeDefinition.params.itemId = weaponId;
    };
    return false;
  }

  private final func GetWeaponToDisplayRightFirst(player: ref<PlayerPuppet>, types: array<gamedataItemType>, opt excludeBlackwall: Bool) -> TweakDBID {
    let slot: Int32;
    let item: ItemID = EquipmentSystem.GetData(player).CutsceneWeaponGetActiveRightItem(slot);
    let data: wref<gameItemData>;
    let selected: TweakDBID = t"";
    let accepted: Bool = false;
    let manager: ref<InventoryDataManagerV2>;
    if ItemID.IsValid(item) {
      data = RPGManager.GetItemData(player.GetGame(), player, item);
      if IsDefined(data) {
        accepted = ArrayContains(types, data.GetItemType());
      };
    };
    if excludeBlackwall && Equals(ItemID.GetTDBID(item), t"Items.BlackwallForce") {
      accepted = false;
    };

    if accepted {
      selected = ItemID.GetTDBID(item);
    } else {
      selected = this.GetPlayerWeaponLastUsed(player, types);
      if excludeBlackwall && Equals(selected, t"Items.BlackwallForce") {
        selected = t"";
      };

      if Equals(selected, t"") {
        manager = new InventoryDataManagerV2();
        manager.Initialize(player);
        selected = this.GetPlayerWeaponInventory(player, manager, types, excludeBlackwall);
        manager.UnInitialize();
      };
    };

    return selected;
  }

  private final func GetWeaponToDisplay(player: ref<PlayerPuppet>, types: array<gamedataItemType>) -> TweakDBID {
    let manager: ref<InventoryDataManagerV2> = new InventoryDataManagerV2();
    manager.Initialize(player);

    let pistolLastUsed: TweakDBID = this.GetPlayerWeaponLastUsed(player, types);
    let pistolEquipped: TweakDBID = this.GetPlayerWeaponEquipped(player, manager, types);
    let pistolFromInventory: TweakDBID = this.GetPlayerWeaponInventory(player, manager, types);

    let weaponToDisplay: TweakDBID = t"";

    if NotEquals(pistolLastUsed, t"") {
      weaponToDisplay = pistolLastUsed;
    } else if NotEquals(pistolEquipped, t"") {
      weaponToDisplay = pistolEquipped;
    } else if NotEquals(pistolFromInventory, t"") {
      weaponToDisplay = pistolFromInventory;
    };

    manager.UnInitialize();
    return weaponToDisplay;
  }

  private final func GetPlayerWeaponEquipped(player: ref<PlayerPuppet>, manager: ref<InventoryDataManagerV2>, types: array<gamedataItemType>) -> TweakDBID {
    let weapons: array<InventoryItemData> = manager.GetEquippedWeapons();
    let type: gamedataItemType;
    for weapon in weapons {
      type = InventoryItemData.GetItemType(weapon);
      if ArrayContains(types, type) {
        return ItemID.GetTDBID(InventoryItemData.GetID(weapon));
      };
    };

    return t"";
  }

  private final func GetPlayerWeaponLastUsed(player: ref<PlayerPuppet>, types: array<gamedataItemType>) -> TweakDBID {
    let lastUsedItemID: ItemID = EquipmentSystem.GetData(player).GetLastUsedWeaponItemID();
    let itemData: ref<gameItemData> = RPGManager.GetItemData(player.GetGame(), player, lastUsedItemID);

    if !IsDefined(itemData) { return t""; };
    let type: gamedataItemType = itemData.GetItemType();

    if ArrayContains(types, type) {
      return ItemID.GetTDBID(lastUsedItemID);
    };

    return t"";
  }

  private final func GetPlayerWeaponInventory(player: ref<PlayerPuppet>, manager: ref<InventoryDataManagerV2>, types: array<gamedataItemType>, opt excludeBlackwall: Bool) -> TweakDBID {
    let weapons: array<InventoryItemData> = manager.GetPlayerEquipmentAreaInventoryData(gamedataEquipmentArea.Weapon);
    let type: gamedataItemType;
    for weapon in weapons {
      let id: TweakDBID = ItemID.GetTDBID(InventoryItemData.GetID(weapon));
      type = InventoryItemData.GetItemType(weapon);
      if (!excludeBlackwall || NotEquals(id, t"Items.BlackwallForce")) && ArrayContains(types, type) && NotEquals(t"Items.Preset_V_Unity", id) && NotEquals(t"Items.Preset_V_Unity_Cutscene", id) {
        return id;
      };
    };

    return t"";
  }

  private final func CreateWeaponProp(player: ref<PlayerPuppet>, base: TweakDBID) -> TweakDBID {
    let newRecordId: TweakDBID = base + t"_Prop";
    let cloned: Bool = TweakDBManager.CloneRecord(newRecordId, base);
    let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(newRecordId);
    let tags: array<CName> = record.Tags();
    ArrayPush(tags, n"HideInUI");
    ArrayPush(tags, n"SkipActivityLog");
    TweakDBManager.SetFlat(newRecordId + t".tags", ToVariant(tags));
    TweakDBManager.UpdateRecord(newRecordId);
    let ts: ref<TransactionSystem>;
    if cloned {
      ts = GameInstance.GetTransactionSystem(player.GetGame());
      ts.GiveItemByTDBID(player, newRecordId, 1);
    };
    return newRecordId;
  }

  @if(!ModuleExists("AlwaysFirstEquip"))
  private final func HandleCompat(player: ref<PlayerPuppet>) -> Void {
    // do nothing
  }

  @if(ModuleExists("AlwaysFirstEquip"))
  private final func HandleCompat(player: ref<PlayerPuppet>) -> Void {
    player.SetSkipFirstEquipEQ(true);
  }
}

@addField(EquipmentSystemPlayerData)
private let cutsceneWeaponSingleDraw: Bool;

@addField(EquipmentSystemPlayerData)
private let cutsceneWeaponDrawItem: ItemID;

@addMethod(EquipmentSystemPlayerData)
public final func CutsceneWeaponGetActiveRightItem(out slot: Int32) -> ItemID {
  let area: Int32 = this.GetEquipAreaIndex(gamedataEquipmentArea.Weapon);
  slot = -1;
  if area < 0 || area >= ArraySize(this.m_equipment.equipAreas) { return ItemID.None(); };
  slot = this.m_equipment.equipAreas[area].activeIndex;

  if slot < 0 || slot > 2 || slot >= ArraySize(this.m_equipment.equipAreas[area].equipSlots) { return ItemID.None(); };
  return this.m_equipment.equipAreas[area].equipSlots[slot].itemID;
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnDrawItemRequest(request: ref<DrawItemRequest>) -> Void {
  let service: ref<CutsceneWeaponSwapper> = CutsceneWeaponSwapper.Get();
  let selectedRecord: TweakDBID;
  let context: ref<CutsceneWeaponDrawContext>;
  if IsDefined(service) && IsDefined(request) {
    context = service.FindSingleDrawContext(this.m_owner, ItemID.GetTDBID(request.itemID));
    if IsDefined(context) {
      selectedRecord = context.weapon;
    };
  };
  let previousSingleDraw: Bool = this.cutsceneWeaponSingleDraw;
  let previousDrawItem: ItemID = this.cutsceneWeaponDrawItem;
  let originalItem: ItemID;
  let resolvedItem: ItemID;
  let normalizationItem: ItemID;
  let rightItem: ItemID;
  let rightSlot: Int32;
  let itemData: wref<gameItemData>;
  let normalized: Bool = false;
  let tier: Int32;
  let query: Bool;
  let selected: Bool;

  this.cutsceneWeaponSingleDraw = false;
  this.cutsceneWeaponDrawItem = ItemID.None();
  if IsDefined(request) && NotEquals(selectedRecord, t"") {
    tier = PlayerPuppet.GetSceneTier(this.m_owner as PlayerPuppet);
    query = ItemID.IsQuery(request.itemID);
    selected = ItemID.IsValid(request.itemID) && Equals(ItemID.GetTDBID(request.itemID), selectedRecord);
    if tier >= 3 && query && selected {
      originalItem = request.itemID;
      normalizationItem = originalItem;
      rightItem = this.CutsceneWeaponGetActiveRightItem(rightSlot);
      if ItemID.IsValid(rightItem) && !ItemID.IsQuery(rightItem) && Equals(ItemID.GetTDBID(rightItem), selectedRecord) {
        normalizationItem = rightItem;
      };
      itemData = GameInstance.GetTransactionSystem(this.m_owner.GetGame()).GetItemData(this.m_owner, normalizationItem);
      if IsDefined(itemData) {
        resolvedItem = itemData.GetID();
        normalized = ItemID.IsValid(resolvedItem) && !ItemID.IsQuery(resolvedItem) && Equals(ItemID.GetTDBID(resolvedItem), selectedRecord);
        if !ItemID.IsQuery(normalizationItem) {
          normalized = normalized && resolvedItem == normalizationItem;
        };
      };
      if normalized {
        request.itemID = resolvedItem;
        this.cutsceneWeaponDrawItem = resolvedItem;
        this.cutsceneWeaponSingleDraw = true;
      };
    };
  };
  wrappedMethod(request);
  if normalized {
    request.itemID = originalItem;
  };
  this.cutsceneWeaponSingleDraw = previousSingleDraw;
  this.cutsceneWeaponDrawItem = previousDrawItem;
}

@wrapMethod(EquipmentSystemPlayerData)
public final func GetItemIDfromEquipmentManipulationAction(eqManipulationAction: EquipmentManipulationAction, currentState: SSlotActiveItems) -> SSlotActiveItems {
  let result: SSlotActiveItems = wrappedMethod(eqManipulationAction, currentState);
  let leftRecord: ref<Item_Record>;
  if this.cutsceneWeaponSingleDraw && Equals(eqManipulationAction, EquipmentManipulationAction.RequestSlotActiveWeapon) {
    if ItemID.IsValid(result.rightHandItem) && !ItemID.IsQuery(result.rightHandItem) && result.rightHandItem == this.cutsceneWeaponDrawItem && ItemID.IsValid(result.leftHandItem) {
      leftRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(result.leftHandItem));
      if IsDefined(leftRecord) && IsDefined(leftRecord.ItemCategory()) && Equals(leftRecord.ItemCategory().Type(), gamedataItemCategory.Weapon) && !WeaponObject.IsCyberwareWeapon(result.leftHandItem) {
        result.leftHandItem = ItemID.None();
      };
    };
  };
  return result;
}

public class CutsceneReedHidden extends IScriptable {
  public let component: wref<IComponent>;
  public let enabled: Bool;
}

public class CutsceneReedAppearanceEvent extends CallbackSystemEvent {
  public let sceneEvent: ref<ResourceEvent>;
  public let stage: CName;
  public let resource: ref<CResource>;
  public let builder: ref<EntityBuilderWrapper>;
  public let entity: wref<Entity>;
}

public class CutsceneReedAppearance extends ScriptableService {
  private let selected: ref<CutsceneRoofVisual>;
  private let selectedRecord: TweakDBID;
  private let selectionAttempted: Bool;
  private let active: Bool;
  private let equip: wref<questEquipItemNodeDefinition>;
  private let originalEquip: TweakDBID;
  private let node: wref<worldEntityNode>;
  private let ownsNode: Bool;
  private let originalTemplate: ResRef;
  private let originalAppearance: CName;
  private let hidden: array<ref<CutsceneReedHidden>>;
  private let hiddenOwner: wref<Entity>;
  private let matchedAppearance: Bool;
  private let target: EntityID;
  private let closing: Bool;
  private let baseline: array<ref<CutsceneRoofOriginal>>;
  private let extracted: wref<Entity>;
  private let attached: wref<Entity>;

  private static func SourceTemplate() -> ResRef = r"ep1\\quest\\main_quests\\q306\\entities\\w_revolver__malorian_overture__base1_01_q306.ent"
  private static func Template() -> ResRef = r"base\\quest\\main_quests\\part1\\q115\\entities\\q115_ripperdoc_gun.ent"
  private static func TargetRef() -> NodeRef = CreateNodeRef("$/03_night_city/nw4/#loc_q306_spaceport/#loc_q306_spaceport_questdesign/#q306_pr_launchpad/#q306_10_finale/#q306_v_gun_finale")

  public static func ScenePath() -> ResRef = r"ep1\\quest\\main_quests\\q306\\scenes\\q306_10_finale.scene"

  public static func Get() -> ref<CutsceneReedAppearance> {
    return GameInstance.GetScriptableServiceContainer().GetService(n"CutsceneWeaponSwap.CutsceneReedAppearance") as CutsceneReedAppearance;
  }

  public func HandleScene(event: ref<ResourceEvent>) -> Void {
    let work = new CutsceneReedAppearanceEvent();
    work.stage = n"Scene";
    work.sceneEvent = event;
    GameInstance.GetCallbackSystem().DispatchEvent(work);
  }

  private func Donor() -> ResRef {
    if IsDefined(this.selected) { return this.selected.path; };
    return r"";
  }

  private func Alias() -> CName {
    if IsDefined(this.selected) { return this.selected.alias; };
    return n"None";
  }

  private func EnsureSelection() -> Void {
    if this.selectionAttempted { return; };
    let service = CutsceneWeaponSwapper.Get();
    let player = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if !IsDefined(service) || !IsDefined(player) {

      return;
    };
    this.selectionAttempted = true;
    this.selectedRecord = service.GetReedWeaponToDisplay(player);
    this.selected = service.ResolveCarrierVisual(this.selectedRecord);
  }

  private func RestoreEquip() -> Void {
    if IsDefined(this.equip) && IsDefined(this.equip.params) {
      if Cast<Int32>(this.equip.id) == 5429 && this.equip.params.isPlayer && this.equip.params.byItem && Equals(this.equip.params.type, questNodeType.Equip) && Equals(this.equip.params.itemId, this.selectedRecord) {
        this.equip.params.itemId = this.originalEquip;
      };
    };
    this.equip = null;
  }

  private func ProcessScene(event: ref<ResourceEvent>) -> Void {
    if !IsDefined(event) || NotEquals(event.GetPath(), CutsceneReedAppearance.ScenePath()) { return; };
    let scene = event.GetResource() as scnSceneResource;
    if !IsDefined(scene) || !IsDefined(scene.sceneGraph) { return; };
    let target: ref<questEquipItemNodeDefinition>;
    let matches: Int32 = 0;
    for node in scene.sceneGraph.graph {
      let quest = node as scnQuestNode;
      if IsDefined(quest) {
        let candidate = quest.questNode as questEquipItemNodeDefinition;
        if IsDefined(candidate) && Cast<Int32>(candidate.id) == 5429 { matches += 1; target = candidate; };
      };
    };
    if matches != 1 || !IsDefined(target) || !IsDefined(target.params) { return; };
    if !target.params.isPlayer || !target.params.byItem || NotEquals(target.params.type, questNodeType.Equip) { return; };
    let previous: ref<questEquipItemNodeDefinition> = this.equip;
    if Equals(previous, target) && Equals(target.params.itemId, this.selectedRecord) { return; };
    this.RestoreEquip();
    if NotEquals(target.params.itemId, t"Items.Preset_Overture_Default") { return; };
    this.EnsureSelection();
    this.originalEquip = target.params.itemId;
    let service = CutsceneWeaponSwapper.Get();
    if !IsDefined(service) { return; };
    service.ProcessScene(event, this.selectedRecord);
    if NotEquals(this.selectedRecord, t"") && Equals(target.params.itemId, this.selectedRecord) {
      this.equip = target;
    };
  }

  private static func MeshEnabled(component: ref<IComponent>) -> Bool {
    let skinned = component as entSkinnedMeshComponent;
    if IsDefined(skinned) { return skinned.IsEnabled(); };
    let mesh = component as MeshComponent;
    return IsDefined(mesh) && mesh.IsEnabled();
  }

  private static func ToggleMesh(component: ref<IComponent>, enabled: Bool) -> Void {
    let skinned = component as entSkinnedMeshComponent;
    if IsDefined(skinned) { skinned.Toggle(enabled); return; };
    let mesh = component as MeshComponent;
    if IsDefined(mesh) { mesh.Toggle(enabled); };
  }

  private func RestoreMeshes() -> Void {
    let valid = IsDefined(this.hiddenOwner) && Equals(this.hiddenOwner.GetEntityID(), this.target) && Equals(this.hiddenOwner.GetTemplatePath(), CutsceneReedAppearance.Template()) && Equals(this.hiddenOwner.GetCurrentAppearanceName(), this.Alias());

    for snapshot in this.hidden {
      if valid && IsDefined(snapshot.component) {
        CutsceneReedAppearance.ToggleMesh(snapshot.component, snapshot.enabled);
      };
    };
    ArrayClear(this.hidden);
    this.hiddenOwner = null;
  }

  private static func CheckMesh(index: ref<inkHashMap>, id: Uint64, name: CName, type: CName, path: ResRef, parent: CName) -> Bool {
    let component = index.Get(id) as IComponent;
    if !IsDefined(component) || NotEquals(component.name, name) || NotEquals(component.GetClassName(), type) { return false; };
    let skinned = component as entSkinnedMeshComponent;
    let mesh = component as MeshComponent;
    if IsDefined(skinned) {
      if NotEquals(ResourceAsyncRef.GetPath(skinned.mesh), path) { return false; };
    } else {
      if !IsDefined(mesh) || NotEquals(ResourceAsyncRef.GetPath(mesh.mesh), path) { return false; };
    };
    let placed = component as IPlacedComponent;
    if !IsDefined(placed) { return false; };
    if Equals(parent, n"None") { return !IsDefined(placed.parentTransform); };
    let binding = placed.parentTransform as entHardTransformBinding;
    return IsDefined(binding) && Equals(binding.bindName, parent) && Equals(binding.slotName, n"None");
  }

  private func ValidateKenshinControls(index: ref<inkHashMap>) -> Bool {
    let barrel = index.Get(1885206007329955840ul) as AnimatedComponent;
    let receiver = index.Get(1604100407620046860ul) as AnimatedComponent;
    if index.KeyExist(1611189863225266176ul) || !IsDefined(barrel) || !IsDefined(receiver) { return false; };
    if NotEquals(barrel.name, n"Barrel") || NotEquals(receiver.name, n"Receiver") { return false; };
    let parent = barrel.parentTransform as entHardTransformBinding;
    let control = barrel.controlBinding;
    let receiverControl = receiver.controlBinding;

    if !IsDefined(parent) || !IsDefined(control) || !IsDefined(receiverControl) { return false; };

    if NotEquals(ResourceRef.GetPath(barrel.rig), r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\rig\\w_handgun__arasaka_kenshin__base1.rig") ||
       NotEquals(ResourceRef.GetPath(receiver.rig), r"base\\weapons\\firearms\\handgun\\rig\\w_handgun__rcv1.rig") { return false; };
    if NotEquals(parent.bindName, n"Receiver") || NotEquals(parent.slotName, n"None") || NotEquals(control.bindName, n"Receiver") || !parent.enabled || !control.enabled { return false; };
    if IsDefined(receiver.parentTransform) || NotEquals(receiverControl.bindName, n"AnimationController0854") || !receiverControl.enabled { return false; };
    let controller = index.Get(1604100407620046864ul) as IComponent;
    if !IsDefined(controller) || NotEquals(controller.name, n"AnimationController0854") || NotEquals(controller.GetClassName(), n"entAnimationControllerComponent") { return false; };
    let magMagazineReload = index.Get(1821491723780526080ul) as AnimatedComponent;
    if !IsDefined(magMagazineReload) || NotEquals(magMagazineReload.name, n"MagazineReload") { return false; };

    if NotEquals(ResourceRef.GetPath(magMagazineReload.rig), r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\rig\\w_handgun__arasaka_kenshin__mag_std.rig") || IsDefined(magMagazineReload.parentTransform) || !IsDefined(magMagazineReload.controlBinding) { return false; };
    if NotEquals(magMagazineReload.controlBinding.bindName, n"Barrel") || !magMagazineReload.controlBinding.enabled { return false; };
    let magMagazine = index.Get(1821493529596170244ul) as AnimatedComponent;
    if !IsDefined(magMagazine) || NotEquals(magMagazine.name, n"Magazine") { return false; };

    if NotEquals(ResourceRef.GetPath(magMagazine.rig), r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\rig\\w_handgun__arasaka_kenshin__mag_std.rig") || IsDefined(magMagazine.parentTransform) || !IsDefined(magMagazine.controlBinding) { return false; };
    if NotEquals(magMagazine.controlBinding.bindName, n"Barrel") || !magMagazine.controlBinding.enabled { return false; };

    return true;
  }

  private func ValidateCarrierControls(index: ref<inkHashMap>) -> Bool {
    let carrierAnimation = index.Get(1186533189145530368ul) as AnimatedComponent;
    let carrierSlot = index.Get(1263305940216905728ul) as IPlacedComponent;
    let collider = index.Get(1186531487147298816ul) as IPlacedComponent;
    if !IsDefined(carrierAnimation) || !IsDefined(carrierSlot) || !IsDefined(collider) { return false; };
    let slotBinding = carrierSlot.parentTransform as entHardTransformBinding;
    let colliderBinding = collider.parentTransform as entHardTransformBinding;
    if NotEquals(carrierAnimation.name, n"Animated5005") || IsDefined(carrierAnimation.parentTransform) ||
       NotEquals(carrierSlot.name, n"Slot5946") || NotEquals(carrierSlot.GetClassName(), n"entSlotComponent") ||
       NotEquals(collider.name, n"HitPhysicalQueryMesh") || NotEquals(collider.GetClassName(), n"entColliderComponent") { return false; };
    if !IsDefined(slotBinding) || !IsDefined(colliderBinding) { return false; };
    if NotEquals(slotBinding.bindName, n"Animated5005") || NotEquals(slotBinding.slotName, n"None") || NotEquals(colliderBinding.bindName, n"Slot5946") || NotEquals(colliderBinding.slotName, n"Base") { return false; };
    return true;
  }

  private func ValidateKenshinMeshes(index: ref<inkHashMap>) -> Bool {
    if !CutsceneReedAppearance.CheckMesh(index, 1885199189673353216ul, n"w_handgun__arasaka_kenshin__base1_01", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__base1_01.mesh", n"Barrel") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 2002791582385713152ul, n"w_handgun__arasaka_kenshin__base1_7731", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__base1_01_diode1.mesh", n"Barrel") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 2021291185248370688ul, n"w_handgun__arasaka_kenshin__base1_0670", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__base1_01_ironsights.mesh", n"Barrel") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 2101013775170547712ul, n"w_handgun__arasaka_kenshin__base1_8337", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__base1_01_rail_01.mesh", n"Barrel") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 3902746428388757504ul, n"w_handgun__arasaka_kenshin__base1_0660", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__base1_01_rail_01_shadow.mesh", n"Barrel") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 1821484201648623620ul, n"w_handgun__arasaka_kenshin__mag_stdr_018670", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__mag_stdr_01.mesh", n"MagazineReload") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 1821483523077345284ul, n"w_handgun__arasaka_kenshin__mag_std_018488", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__mag_std_01.mesh", n"Magazine") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 2076604868658802692ul, n"w_handgun__arasaka_kenshin__base1_01_decal_01_d6524", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__base1_01_decal_01_d.mesh", n"Barrel") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 2076605580415414276ul, n"w_handgun__arasaka_kenshin__base1_01_decal_01_n2706", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__base1_01_decal_01_n.mesh", n"Barrel") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 2076606320055758852ul, n"w_handgun__arasaka_kenshin__mag_std_01_decal_01_n5346", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__mag_std_01_decal_01_n.mesh", n"Magazine") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 2076606459407314948ul, n"w_handgun__arasaka_kenshin__mag_stdr_01_decal_01_n4455", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__mag_stdr_01_decal_01_n.mesh", n"MagazineReload") { return false; };
    if !CutsceneReedAppearance.CheckMesh(index, 2199563208091136004ul, n"w_handgun__arasaka_kenshin__base1_01_decal_maelstrom_d7832", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\entities\\meshes\\w_handgun__arasaka_kenshin__base1_01_decal_maelstrom_d.mesh", n"Barrel") { return false; };

    return true;
  }

  private func ValidateControls(components: array<ref<IComponent>>, index: ref<inkHashMap>) -> Bool {
    let service = CutsceneWeaponSwapper.Get();
    if !IsDefined(service) || !service.ValidateCarierStructure(components, index, this.baseline) { return false; };
    let originals = new inkHashMap();
    for original in this.baseline { originals.Insert(original.id, original); };
    let names = new inkHashMap();
    for component in components { if IsDefined(component) { names.Insert(NameToHash(component.name), component); }; };
    for component in components {
      if IsDefined(component) && !originals.KeyExist(CRUIDToHash(component.id)) {
        let animated = component as AnimatedComponent;
        if IsDefined(animated) {
          let control = animated.controlBinding;

          if IsDefined(control) {
            let target = names.Get(NameToHash(control.bindName)) as IComponent;

            if !IsDefined(target) || NotEquals(target.name, control.bindName) { return false; };
          };
        };
      };
    };
    if Equals(this.Donor(), r"base\\weapons\\firearms\\handgun\\arasaka_kenshin\\w_handgun__arasaka_kenshin.app") && Equals(this.selected.definition, n"maelstrom") {
      return this.ValidateKenshinControls(index) && this.ValidateKenshinMeshes(index);
    };

    return true;
  }

  private func HideOriginals(entity: ref<Entity>, components: array<ref<IComponent>>, index: ref<inkHashMap>, retained: Int32, collisionsValid: Bool, duplicateNames: Int32) -> Void {
    if !this.ownsNode || !this.matchedAppearance || !IsDefined(this.extracted) || this.extracted != entity || NotEquals(entity.GetCurrentAppearanceName(), this.Alias()) {
       return;
    };
    if !this.ValidateCarrierControls(index) { return; };
    if !this.ValidateControls(components, index) { return; };
    if ArraySize(this.baseline) != 20 || retained != 20 || !collisionsValid || duplicateNames != 0 {
       return;
    };
    if !CutsceneReedAppearance.CheckMesh(index, 2186680792687583232ul, n"w_handgun__constitutional_unity__base1_01", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\constitutional_unity\\entities\\meshes\\w_handgun__constitutional_unity__base1_01.mesh", n"None") ||
       !CutsceneReedAppearance.CheckMesh(index, 2186681124876460032ul, n"w_handgun__constitutional_unity__base1_01_decal_n01", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\constitutional_unity\\entities\\meshes\\w_handgun__constitutional_unity__base1_01_decal_n01.mesh", n"None") ||
       !CutsceneReedAppearance.CheckMesh(index, 2502632666255785984ul, n"w_handgun__constitutional_liberty__mag_std_01", n"entSkinnedMeshComponent", r"base\\weapons\\firearms\\handgun\\constitutional_liberty\\entities\\meshes\\w_handgun__constitutional_liberty__mag_std_01.mesh", n"None") {
       return;
    };
    this.RestoreMeshes();
    this.hiddenOwner = entity;
    for id in [2186680792687583232ul, 2186681124876460032ul, 2502632666255785984ul] {
      let component = index.Get(id) as IComponent;
      let snapshot = new CutsceneReedHidden();
      snapshot.component = component;
      snapshot.enabled = CutsceneReedAppearance.MeshEnabled(component);
      ArrayPush(this.hidden, snapshot);
      CutsceneReedAppearance.ToggleMesh(component, false);
    };
  }

  private func RestoreNode() -> Void {
    if this.ownsNode && IsDefined(this.node) {
      if Equals(ResourceAsyncRef.GetPath(this.node.entityTemplate), CutsceneReedAppearance.Template()) && Equals(this.node.appearanceName, this.Alias()) {
        ResourceAsyncRef.SetPath(this.node.entityTemplate, this.originalTemplate);
        this.node.appearanceName = this.originalAppearance;
      };
    };
    this.ownsNode = false;
    this.node = null;
  }

  private func PatchNode(node: ref<worldEntityNode>) -> Void {
    if !IsDefined(node) { return; };
    let previous: ref<worldEntityNode> = this.node;
    if this.ownsNode && Equals(previous, node) { return; };
    this.RestoreNode();
    if NotEquals(ResourceAsyncRef.GetPath(node.entityTemplate), CutsceneReedAppearance.SourceTemplate()) || NotEquals(node.appearanceName, n"default") || IsDefined(node.instanceData) { return; };
    this.EnsureSelection();
    if !IsDefined(this.selected) { return; };
    this.originalTemplate = ResourceAsyncRef.GetPath(node.entityTemplate);
    this.originalAppearance = node.appearanceName;
    this.node = node;
    ResourceAsyncRef.SetPath(node.entityTemplate, CutsceneReedAppearance.Template());
    node.appearanceName = this.Alias();
    this.ownsNode = true;
  }

  private cb func OnLoad() {
    let callbacks = GameInstance.GetCallbackSystem();
    callbacks.RegisterEvent(n"CutsceneWeaponSwap.CutsceneReedAppearanceEvent");
    callbacks.RegisterCallback(n"CutsceneWeaponSwap.CutsceneReedAppearanceEvent", this, n"OnWork", true);
    callbacks.RegisterCallback(n"Session/BeforeStart", this, n"OnSession", true);
    callbacks.RegisterCallback(n"Session/BeforeEnd", this, n"OnSession", true);
    callbacks.RegisterCallback(n"Resource/PostLoad", this, n"OnResource", true)
      .AddTarget(ResourceTarget.Path(r"base\\worlds\\03_night_city\\_compiled\\default\\ep1\\quest_ba00840f83052002.streamingsector"));
    callbacks.RegisterCallback(n"Entity/Extract", this, n"OnExtract", true)
      .AddTarget(EntityTarget.Template(CutsceneReedAppearance.Template()));
    callbacks.RegisterCallback(n"Entity/AfterAttach", this, n"OnAttached", true)
      .AddTarget(EntityTarget.Template(CutsceneReedAppearance.Template()));
  }

  private cb func OnSession(event: ref<GameSessionEvent>) {
    let work = new CutsceneReedAppearanceEvent();
    work.stage = event.GetEventName();
    GameInstance.GetCallbackSystem().DispatchEvent(work);
  }

  private cb func OnResource(event: ref<ResourceEvent>) {
    let work = new CutsceneReedAppearanceEvent();
    work.stage = n"Sector";
    work.resource = event.GetResource();
    GameInstance.GetCallbackSystem().DispatchEvent(work);
  }

  private cb func OnExtract(event: ref<EntityBuilderEvent>) {
    let builder = event.GetEntityBuilder();
    if !IsDefined(builder) { return; };
    let work = new CutsceneReedAppearanceEvent();
    work.stage = n"Extract";
    work.builder = builder;
    // Synchronous dispatch only: the builder must not survive this callback.
    GameInstance.GetCallbackSystem().DispatchEvent(work);
  }

  private cb func OnAttached(event: ref<EntityLifecycleEvent>) {
    let work = new CutsceneReedAppearanceEvent();
    work.stage = n"Attached";
    work.entity = event.GetEntity();
    GameInstance.GetCallbackSystem().DispatchEvent(work);
  }

  private cb func OnWork(work: ref<CutsceneReedAppearanceEvent>) {
    if Equals(work.stage, n"Session/BeforeStart") {
      this.closing = false;
      this.active = true;
      this.target = Cast<EntityID>(ResolveNodeRef(CutsceneReedAppearance.TargetRef(), Cast<GlobalNodeRef>(GlobalNodeID.GetRoot())));

      return;
    };
    if Equals(work.stage, n"Session/BeforeEnd") {
      this.closing = true;
      this.active = false;

      this.RestoreMeshes();
      this.RestoreNode();
      this.RestoreEquip();
      this.selected = null;
      this.selectedRecord = t"";
      this.selectionAttempted = false;
      this.matchedAppearance = false;
      ArrayClear(this.baseline);
      this.extracted = null;
      this.attached = null;
      return;
    };

    if this.closing || !this.active { return; };
    if Equals(work.stage, n"Scene") { this.ProcessScene(work.sceneEvent); return; };

    if Equals(work.stage, n"Sector") {
      let sector = work.resource as worldStreamingSector;
      if !IsDefined(sector) { return; };
      let count = sector.GetNodeSetupCount();
      let i: Int32 = 0;
      let matches: Int32 = 0;
      let targetRef = CutsceneReedAppearance.TargetRef();
      let selectedNode: ref<worldEntityNode>;
      while i < count {
        let setup = sector.GetNodeSetup(i);
        if IsDefined(setup) && Equals(setup.GetNodeRef(), targetRef) {
          matches += 1;
          let node = setup.GetNode() as worldEntityNode;
          selectedNode = node;
        };
        i += 1;
      };

      if matches == 1 { this.PatchNode(selectedNode); };
      return;
    };
    if Equals(work.stage, n"Extract") {
      let builder = work.builder;
      if !IsDefined(builder) || !EntityID.IsDefined(this.target) || NotEquals(builder.GetEntityID(), this.target) || NotEquals(builder.GetTemplatePath(), CutsceneReedAppearance.Template()) { return; };
      this.RestoreMeshes();
      this.matchedAppearance = false;
      ArrayClear(this.baseline);
      this.extracted = null;
      this.attached = null;

      let appearance = builder.GetAppearance();
      if IsDefined(appearance) {
        let resource = appearance.GetResource();
        let definition = appearance.GetDefinition();
        if IsDefined(resource) && IsDefined(definition) {
          this.matchedAppearance = IsDefined(this.selected) && Equals(resource.path, this.Donor()) && Equals(definition.name, this.selected.definition) && Equals(builder.GetAppearanceName(), this.Alias());
        };
      };
      if !builder.HasEntity() { return; };
      this.extracted = builder.GetTemplate().GetEntity();
      let originals = builder.GetTemplate().GetComponents();

      if ArraySize(originals) > 512 { return; };
      for component in originals {
        if IsDefined(component) {
          let snapshot = new CutsceneRoofOriginal();
          snapshot.id = CRUIDToHash(component.id);
          snapshot.component = component;
          ArrayPush(this.baseline, snapshot);
        };
      };
      return;
    };
    if Equals(work.stage, n"Attached") {
      let entity = work.entity;
      if !IsDefined(entity) || !EntityID.IsDefined(this.target) || NotEquals(entity.GetEntityID(), this.target) || NotEquals(entity.GetTemplatePath(), CutsceneReedAppearance.Template()) { return; };
      if IsDefined(this.attached) && this.attached == entity { return; };
      this.attached = entity;

      let components = entity.GetComponents();
      if ArraySize(components) > 512 { return; };
      let index = new inkHashMap();
      let duplicates: Int32 = 0;
      let collisionsValid: Bool = true;
      let names = new inkHashMap();
      let duplicateNames: Int32 = 0;
      for component in components {
        if IsDefined(component) {
          let id = CRUIDToHash(component.id);
          if index.KeyExist(id) {
            duplicates += 1;
            collisionsValid = false;
          } else { index.Insert(id, component); };
          let nameKey = NameToHash(component.name);
          if names.KeyExist(nameKey) {
            duplicateNames += 1;
          } else { names.Insert(nameKey, component); };
        };
      };
      let retained: Int32 = 0;
      for original in this.baseline {
        let live = index.Get(original.id) as IComponent;
        let same = IsDefined(live) && IsDefined(original.component) && live == original.component;
        if same { retained += 1; };
      };
      if duplicates > 0 { collisionsValid = false; };

      this.HideOriginals(entity, components, index, retained, collisionsValid, duplicateNames);
    };
  }
}
