module CombatAwareness

class PreparationPanel {
  public let root: ref<inkCanvas>;
  public let choices: array<ref<inkText>>;
  public let balance: ref<inkText>;
  public let detail: ref<inkText>;
  public let draft: Int32;
  public let selected: Int32;

  private let underlying: array<wref<inkWidget>>;
  private let opacities: array<Float>;

  public func Init(parent: ref<inkCompoundWidget>) -> Void {
    let i: Int32 = 0;

    while i < parent.GetNumChildren() {
      let child = parent.GetWidgetByIndex(i);
      ArrayPush(this.underlying, child);
      ArrayPush(this.opacities, child.GetOpacity());
      child.SetOpacity(0.0);
      i += 1;
    }

    i = 0;

    this.root = new inkCanvas();
    this.root.SetAnchor(inkEAnchor.Fill);
    this.root.Reparent(parent);

    let shade: ref<inkRectangle> = new inkRectangle();
    shade.SetAnchor(inkEAnchor.Fill);
    // TODO: replace with MainColors binding
    shade.SetTintColor(HDRColor(0.015, 0.025, 0.035, 1.0));
    shade.SetOpacity(0.87);
    shade.Reparent(this.root);

    while i < 7 {
      let angle = Cast<Float>(i) * 6.2831853 / 7.0;
      ArrayPush(this.choices, AwarenessUI.Label(this.root, SinF(angle) * 435.0, -CosF(angle) * 245.0, 28));
      i += 1;
    };

    this.balance = AwarenessUI.Label(this.root, 0.0, 0.0, 42);
    this.detail = AwarenessUI.Label(this.root, 0.0, 325.0, 26);
    this.detail.SetWrappingAtPosition(900.0);
    this.detail.SetHorizontalAlignment(textHorizontalAlignment.Center);

    AwarenessUI.Label(this.root, 0.0, 405.0, 23).SetText(AwarenessUI.Text("Controls"));
  }

  public func Close(parent: ref<inkCompoundWidget>) -> Void {
    parent.RemoveChild(this.root);
    let i = 0;

    while i < ArraySize(this.underlying) {
      if IsDefined(this.underlying[i]) { this.underlying[i].SetOpacity(this.opacities[i]); };
      i += 1;
    }
  }

  public func Refresh(system: ref<AwarenessSystem>) -> Void {
    let i: Int32 = 0;

    while i < 7 {
      let data = TweakDBInterface.GetStatusEffectRecord(Training.Record(i)).UiData();
      let label = GetLocalizedText(data.DisplayName()) + "  " + IntToString(Training.Cost(i));
      let bit = Training.Bit(i);
      if (this.draft & bit) != 0 {
        label = "[+] " + label;
        if (system.spent & bit) != 0 { label += " · " + AwarenessUI.Text("Spent"); };
      };
      this.choices[i].SetText(label);
      // TODO: replace with MainColors binding
      this.choices[i].SetTintColor(i == this.selected ? HDRColor(1.0, 0.75, 0.25, 1.0) : HDRColor(0.6, 0.9, 0.95, 1.0));
      if i == this.selected { this.detail.SetText(GetLocalizedText(data.Description())); };
      i += 1;
    };

    this.balance.SetText(AwarenessUI.Text("Points") + "  " + IntToString(Training.Budget() - Training.Total(this.draft)));
  }
}
