module CustomMarkers.Localization

import CustomMapMarkers.Codeware.Localization.*

public class TraditionalChinese extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("CustomMarkers-MarkerTitle", "自訂地圖標記");
    this.Text("CustomMarkers-DescriptionLabel", "輸入新標記的說明：");
    this.Text("CustomMarkers-PickIconLabel", "選擇標記圖示：");
    this.Text("CustomMarkers-ButtonLabelDelete", "刪除");
    this.Text("CustomMarkers-AddedMessage", "新標記已增添");
    this.Text("CustomMarkers-LimitMessage", "你已達到標記的限制");
    this.Text("CustomMarkers-AlreadyExists", "此位置的標記已經存在");
  }
}
