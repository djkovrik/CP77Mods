module EnhancedCraft.Core
import EnhancedCraft.Common.L
import EnhancedCraft.Events.*

// -- Enable clothes crafting preview rotation
@addMethod(CraftingGarmentItemPreviewGameController)
protected cb func OnInitialize() -> Bool {
  this.m_isRotatable = true;
  super.OnInitialize();
  this.m_preview = this.GetRootCompoundWidget().GetWidget(n"preview");
  this.m_preview.SetInteractive(true);
  this.m_preview.RegisterToCallback(n"OnPress", this, n"OnPreviewClicked");
  this.m_preview.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
  this.m_preview.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
}

// -- Save LMB state
@addMethod(CraftingGarmentItemPreviewGameController)
protected cb func OnPreviewClicked(e: ref<inkPointerEvent>) -> Bool {
  if e.IsAction(n"mouse_left") {
    this.m_isMouseDown = true;
  };
}

@addMethod(CraftingGarmentItemPreviewGameController)
protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
  this.m_isHoveredByCursor = true;
}

@addMethod(CraftingGarmentItemPreviewGameController)
protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
  this.m_isHoveredByCursor = false;
}


// -- Save LMB state
@addMethod(CraftingGarmentItemPreviewGameController)
protected cb func OnGlobalRelease(e: ref<inkPointerEvent>) -> Bool {
  super.OnGlobalRelease(e);
  if e.IsAction(n"mouse_left") {
    this.m_isMouseDown = false;
  };
}

// -- Scale and move player puppet preview
@addMethod(CraftingGarmentItemPreviewGameController)
protected cb func OnRelativeInput(e: ref<inkPointerEvent>) -> Bool {
  super.OnRelativeInput(e);

  let amount: Float = e.GetAxisData();
  let currentScale: Vector2;
  let diff: Float;
  let newScale: Float;
  
  if e.IsAction(n"mouse_wheel") && this.m_isHoveredByCursor {
    currentScale = this.m_preview.GetScale();
    diff = amount / 10.0;
    newScale = currentScale.X + diff;
    if newScale < 0.4 {
      newScale = 0.4;
    } else {
      if newScale > 2.0 {
        newScale = 2.0;
      };
    };
    this.m_preview.SetScale(new Vector2(newScale, newScale));
  };

  if this.m_isMouseDown {
    if e.IsAction(n"mouse_x") {
      this.m_preview.ChangeTranslation(new Vector2(amount, 0.0));      
    };
    if e.IsAction(n"mouse_y") {
      this.m_preview.ChangeTranslation(new Vector2(0.0, -1.0 * amount));
    };
  };
}
