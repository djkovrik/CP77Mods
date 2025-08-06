public enum HudPainterColorType {
  Default = 0,
  Johnny = 1,
}

public enum SliderColorType {
  Red = 0,
  Green = 1,
  Blue = 2,
}

public enum PreviewTabType {
  Healthbar = 0,
  QuestTracker = 1,
  AmmoCounter = 2,
  NotificationSafe = 3,
  UpdateMessage = 4,
  Subtitles = 5,
}

public class HudPainterStylePropertyDTO {
  public let name: String;
  public let red: Float;
  public let green: Float;
  public let blue: Float;
  public let alpha: Int32;

  public final func AsHDRColor() -> HDRColor {
    return new HDRColor(this.red, this.green, this.blue, Cast<Float>(this.alpha));
  }
}

public class HudPainterStyleDTO {
  public let propertiesDefault: array<ref<HudPainterStylePropertyDTO>>;
  public let propertiesJohnny: array<ref<HudPainterStylePropertyDTO>>;
}

public class HudPainterColorItem {
  public let name: String;
  public let type: HudPainterColorType;
  public let defaultColor: HDRColor;
  public let presetColor: HDRColor;
  public let customColor: HDRColor;
}

public class HudPainterPresetItem {
  public let name: String;
  public let fileName: String;
  public let active: Bool;
}

public class HudPainterCustomColor {
  public let colorR: Int32;
  public let colorG: Int32;
  public let colorB: Int32;

  public final static func Create(colorR: Int32, colorG: Int32, colorB: Int32) -> ref<HudPainterCustomColor> {
    let instance: ref<HudPainterCustomColor> = new HudPainterCustomColor();
    instance.colorR = colorR;
    instance.colorG = colorG;
    instance.colorB = colorB;
    return instance;
  }
}

public class HudPainterPreviewTab {
  public let tabName: String;
  public let tabType: PreviewTabType;
  public let previewResourcePath: ResRef;
  public let previewLibraryID: CName;
  public let previewAnchorPoint: Vector2;
  public let affectedColors: String;
}

public class HudPainterPreviewInfo {
  public let paths: array<CName>;

  public static final func Create( paths: array<CName>) -> ref<HudPainterPreviewInfo> {
    let instance: ref<HudPainterPreviewInfo> = new HudPainterPreviewInfo();
    instance.paths = paths;
    return instance;
  }
}

public class HudPainterSoundEmitted extends Event {
  public let name: CName;

  public final static func Create(name: CName) -> ref<HudPainterSoundEmitted> {
    let evt: ref<HudPainterSoundEmitted> = new HudPainterSoundEmitted();
    evt.name = name;
    return evt;
  }
}

public class HudPainterSliderUpdated extends Event {
  public let color: SliderColorType;
  public let value: Int32;

  public final static func Create(color: SliderColorType, value: Int32) -> ref<HudPainterSliderUpdated> {
    let evt: ref<HudPainterSliderUpdated> = new HudPainterSliderUpdated();
    evt.color = color;
    evt.value = value;
    return evt;
  }
}

public class HudPainterSliderReleased extends Event {
  public final static func Create() -> ref<HudPainterSliderReleased> {
    let evt: ref<HudPainterSliderReleased> = new HudPainterSliderReleased();
    return evt;
  }
}

public class HudPainterColorSelected extends Event {
  public let data: ref<HudPainterColorItem>;

  public final static func Create(data: ref<HudPainterColorItem>) -> ref<HudPainterColorSelected> {
    let evt: ref<HudPainterColorSelected> = new HudPainterColorSelected();
    evt.data = data;
    return evt;
  }
}

public class HudPainterColorChanged extends Event {
  public let name: String;
  public let type: HudPainterColorType;
  public let color: HDRColor;

  public final static func Create(name: String, type: HudPainterColorType, color: HDRColor) -> ref<HudPainterColorChanged> {
    let evt: ref<HudPainterColorChanged> = new HudPainterColorChanged();
    evt.name = name;
    evt.type = type;
    evt.color = color;
    return evt;
  };
}

public class HudPainterPresetSelected extends Event {
  public let data: ref<HudPainterPresetItem>;

  public final static func Create(data: ref<HudPainterPresetItem>) -> ref<HudPainterPresetSelected> {
    let evt: ref<HudPainterPresetSelected> = new HudPainterPresetSelected();
    evt.data = data;
    return evt;
  }
}

public class HudPainterPresetSaved extends Event {
  public final static func Create() -> ref<HudPainterPresetSaved> {
    let evt: ref<HudPainterPresetSaved> = new HudPainterPresetSaved();
    return evt;
  }
}

public class HudPainterPresetDeleted extends Event {
  public let deleted: Bool;

  public final static func Create(deleted: Bool) -> ref<HudPainterPresetDeleted> {
    let evt: ref<HudPainterPresetDeleted> = new HudPainterPresetDeleted();
    evt.deleted = deleted;
    return evt;
  }
}


public class HudPainterInkStyleRefreshed extends Event {
  public final static func Create() -> ref<HudPainterInkStyleRefreshed> {
    let evt: ref<HudPainterInkStyleRefreshed> = new HudPainterInkStyleRefreshed();
    return evt;
  }
}

public class HudPainterPreviewModeEnabled extends Event {
  public final static func Create() -> ref<HudPainterPreviewModeEnabled> {
    let evt: ref<HudPainterPreviewModeEnabled> = new HudPainterPreviewModeEnabled();
    return evt;
  }
}

public class HudPainterColorPreviewAvailable extends Event {
  public let color: ref<HudPainterColorItem>;

  public final static func Create(color: ref<HudPainterColorItem>) -> ref<HudPainterColorPreviewAvailable> {
    let evt: ref<HudPainterColorPreviewAvailable> = new HudPainterColorPreviewAvailable();
    evt.color = color;
    return evt;
  }
}