module CustomMarkers.Localization

import Codeware.Localization.*

public class Russian extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("CustomMarkers-MarkerTitle", "Пользовательский маркер");
    this.Text("CustomMarkers-DescriptionLabel", "Введите описание маркера:");
    this.Text("CustomMarkers-PickIconLabel", "Выберите иконку:");
    this.Text("CustomMarkers-ButtonLabelDelete", "Удалить");
    this.Text("CustomMarkers-AddedMessage", "Новый маркер добавлен");
    this.Text("CustomMarkers-LimitMessage", "Вы достигли максимального количества маркеров");
    this.Text("CustomMarkers-AlreadyExists", "Маркер на этой позиции уже установлен");
  }
}
