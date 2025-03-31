module AtelierDelivery

@wrapMethod(VendingMachine)
protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
  wrappedMethod(ri);

  let hash: Uint32 = EntityID.GetHash(this.GetEntityID());
  if Equals(hash, 3852533768u) // Megabuilding H10
  || Equals(hash, 555307173u)  // Kabuki Market
  || Equals(hash, 900418829u)  // Martin St
  || Equals(hash, 3180019791u) // Cherry Blossom Market
  || Equals(hash, 2960900634u) // Sarasti&Republic
  || Equals(hash, 672384566u)  // Megabuilding H3
  || Equals(hash, 936522229u)  // Congress&MLK
  || Equals(hash, 2864649619u) // Cannery Plaza
  || Equals(hash, 2223155765u) // Wollesen St
  || Equals(hash, 1818591582u) // Megabuilding H7
  || Equals(hash, 4230006327u) // Pacifica Stadium
  || Equals(hash, 3081670176u) // West Wind Estate
  || Equals(hash, 3145583149u) // Sunset Motel
  || Equals(hash, 2444101793u) // Longshore Stacks
  { 
    EntityGameInterface.Destroy(this.GetEntity());
  };
}

@wrapMethod(DropPoint)
protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
  wrappedMethod(ri);

  let hash: Uint32 = EntityID.GetHash(this.GetEntityID());
  if Equals(hash, 2080424202u) // Eisenhower St
  { 
    EntityGameInterface.Destroy(this.GetEntity());
  };
}

@wrapMethod(InteractiveDevice)
protected cb func OnPerformedAction(evt: ref<PerformedAction>) -> Bool {
  if VirtualAtelierDeliveryConfig.Debug() {
    ModLog(n"EntityHash", s"\(this.GetClassName()): \(EntityID.GetHash(this.GetEntityID())) at \(this.GetWorldPosition()) with \(this.GetWorldOrientation())");
  };
  return wrappedMethod(evt);
}
