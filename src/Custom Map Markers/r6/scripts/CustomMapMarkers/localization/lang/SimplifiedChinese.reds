module CustomMarkers.Localization

import CustomMapMarkers.Codeware.Localization.*

public class SimplifiedChinese extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("CustomMarkers-MarkerTitle", "自定义标记");
    this.Text("CustomMarkers-DescriptionLabel", "输入新的标记描述:");
    this.Text("CustomMarkers-PickIconLabel", "选择标记图标:");
    this.Text("CustomMarkers-ButtonLabelDelete", "删除");
    this.Text("CustomMarkers-AddedMessage", "添加了新的标记");
    this.Text("CustomMarkers-LimitMessage", "您已达到标记的限制");
    this.Text("CustomMarkers-AlreadyExists", "此位置的标记已存在");
  }
}
