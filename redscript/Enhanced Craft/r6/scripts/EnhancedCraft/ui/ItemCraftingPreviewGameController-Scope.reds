module EnhancedCraft.UI

@addField(ItemCraftingPreviewGameController)
private let scopePreviewZoomed: Bool;

@addField(ItemCraftingPreviewGameController)
private let scopePreviewOriginalScale: Vector2;

@addField(ItemCraftingPreviewGameController)
private let scopePreviewOriginalPivot: Vector2;

@addMethod(ItemCraftingPreviewGameController)
private final func RestoreScopePreviewScale() -> Void {
  if this.scopePreviewZoomed {
    if inkWidgetRef.IsValid(this.image) {
      inkWidgetRef.SetScale(this.image, this.scopePreviewOriginalScale);
      inkWidgetRef.SetRenderTransformPivot(this.image, this.scopePreviewOriginalPivot);
    };

    this.scopePreviewZoomed = false;
  };
}

@wrapMethod(ItemCraftingPreviewGameController)
protected cb func OnCrafrtingPreview(evt: ref<CraftingItemPreviewEvent>) -> Bool {
  let previewID: TweakDBID;
  let pivotX: Float;
  let pivotY: Float;
  let zoom: Float;
  this.RestoreScopePreviewScale();
  wrappedMethod(evt);
  previewID = ItemID.GetTDBID(evt.itemID);
  pivotX = TweakDBInterface.GetFloat(previewID + t".ecraftScopePivotX", 0.0);
  if !evt.isGarment && inkWidgetRef.IsValid(this.image) && pivotX > 0.0 {
    this.scopePreviewOriginalScale = inkWidgetRef.GetScale(this.image);
    this.scopePreviewOriginalPivot = inkWidgetRef.GetRenderTransformPivot(this.image);
    pivotY = TweakDBInterface.GetFloat(previewID + t".ecraftScopePivotY", 0.35);
    zoom = TweakDBInterface.GetFloat(previewID + t".ecraftScopeZoom", 3.50);
    inkWidgetRef.SetRenderTransformPivot(this.image, pivotX, pivotY);
    inkWidgetRef.SetScale(this.image, Vector2(this.scopePreviewOriginalScale.X * zoom, this.scopePreviewOriginalScale.Y * zoom));
    this.scopePreviewZoomed = true;
  };
}

@addMethod(ItemCraftingPreviewGameController)
protected cb func OnUninitialize() -> Bool {
  this.RestoreScopePreviewScale();
  super.OnUninitialize();
}
