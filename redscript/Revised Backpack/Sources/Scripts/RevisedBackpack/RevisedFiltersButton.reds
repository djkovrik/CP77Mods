module RevisedBackpack
import Codeware.UI.SimpleButton
import Codeware.UI.inkCustomController

public class RevisedFiltersButton extends SimpleButton {

    protected cb func OnInitialize() {
      super.OnInitialize();
      this.m_label.SetFontSize(40);
      this.m_rootWidget.SetSize(340.0, 80.0);
    }

    public final func SetAsDangerous() -> Void {
      this.m_label.BindProperty(n"tintColor", n"MainColors.Red");
    }

    public static func Create() -> ref<RevisedFiltersButton> {
      let self: ref<RevisedFiltersButton> = new RevisedFiltersButton();
      self.CreateInstance();
      return self;
    }
}
