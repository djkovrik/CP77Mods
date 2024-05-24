public abstract class ColorUtils {

  public final static func DecodeHex(from: String) -> ref<HudPainterCustomColor> {
    let decoded: array<Int32> = ColorUtils.Decode(from);
    let colorR: Int32 = decoded[0] * 16 + decoded[1];
    let colorG: Int32 = decoded[2] * 16 + decoded[3];
    let colorB: Int32 = decoded[4] * 16 + decoded[5];
    
    ColorUtils.Log(s"Hex \(from) converted to ( \(colorR) \(colorG) \(colorB) )");

    return HudPainterCustomColor.Create(colorR, colorG, colorB);
  }

  public static final func IsHexValid(from: String) -> Bool {
    if NotEquals(StrLen(from), 6) {
      ColorUtils.Log("Incorrect hex length");
      return false;
    };

    let decoded: array<Int32> = ColorUtils.Decode(from);
    if ArrayContains(decoded, -1) {
      ColorUtils.Log("Incorrect hex format");
      return false;
    }

    return true;
  }

  private static final func Decode(from: String) -> array<Int32> {
    let decoded: array<Int32>;
    ArrayPush(decoded, ColorUtils.HexToDec(StrMid(from, 0, 1)));
    ArrayPush(decoded, ColorUtils.HexToDec(StrMid(from, 1, 1)));
    ArrayPush(decoded, ColorUtils.HexToDec(StrMid(from, 2, 1)));
    ArrayPush(decoded, ColorUtils.HexToDec(StrMid(from, 3, 1)));
    ArrayPush(decoded, ColorUtils.HexToDec(StrMid(from, 4, 1)));
    ArrayPush(decoded, ColorUtils.HexToDec(StrMid(from, 5, 1)));
    return decoded;
  }

  private static final func HexToDec(character: String) -> Int32 {
    switch character {
      case "0": return 0;
      case "1": return 1;
      case "2": return 2;
      case "3": return 3;
      case "4": return 4;
      case "5": return 5;
      case "6": return 6;
      case "7": return 7;
      case "8": return 8;
      case "9": return 9;
      case "A": return 10;
      case "B": return 11;
      case "C": return 12;
      case "D": return 13;
      case "E": return 14;
      case "F": return 15;
    };

    return -1;
  }

  private static final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"Utils", str);
    };
  }
}

public final static func EnableHudPainterLogs() -> Bool = false
