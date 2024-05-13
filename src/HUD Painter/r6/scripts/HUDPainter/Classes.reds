public class HudPainterStylePropertyDTO {
  let name: String;
  let red: Float;
  let green: Float;
  let blue: Float;
  let alpha: Int32;
}

public class HudPainterStyleDTO {
  let propertiesDefault: array<ref<HudPainterStylePropertyDTO>>;
  let propertiesJohnny: array<ref<HudPainterStylePropertyDTO>>;
}

public class HudPainterColorItem {
  let name: String;
  let type: HudPainterColorType;
  let defaultColor: HDRColor;
  let presetColor: HDRColor;
  let customColor: HDRColor;
}

public class HudPainterPresetItem {
  let name: String;
  let fileName: String;
  let active: Bool;
}

enum HudPainterColorType {
  Default = 0,
  Johnny = 1,
}

enum SliderColorType {
  Red = 0,
  Green = 1,
  Blue = 2,
}

public class HudPainterSoundEmitted extends Event {
  let name: CName;

  public static func Create(name: CName) -> ref<HudPainterSoundEmitted> {
    let evt: ref<HudPainterSoundEmitted> = new HudPainterSoundEmitted();
    evt.name = name;
    return evt;
  }
}

public class HudPainterSliderUpdated extends Event {
  let color: SliderColorType;
  let value: Int32;

  public static func Create(color: SliderColorType, value: Int32) -> ref<HudPainterSliderUpdated> {
    let evt: ref<HudPainterSliderUpdated> = new HudPainterSliderUpdated();
    evt.color = color;
    evt.value = value;
    return evt;
  }
}

public class HudPainterColorSelected extends Event {
  let data: ref<HudPainterColorItem>;

  public static func Create(data: ref<HudPainterColorItem>) -> ref<HudPainterColorSelected> {
    let evt: ref<HudPainterColorSelected> = new HudPainterColorSelected();
    evt.data = data;
    return evt;
  }
}

public class HudPainterColorChanged extends Event {
  let name: String;
  let type: HudPainterColorType;
  let color: HDRColor;

  public static func Create(name: String, type: HudPainterColorType, color: HDRColor) -> ref<HudPainterColorChanged> {
    let evt: ref<HudPainterColorChanged> = new HudPainterColorChanged();
    evt.name = name;
    evt.type = type;
    evt.color = color;
    return evt;
  };
}

public class HudPainterPresetSaved extends Event {}
