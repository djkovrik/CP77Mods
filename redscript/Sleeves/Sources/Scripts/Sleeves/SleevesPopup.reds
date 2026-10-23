import Codeware.UI.*

public class SleevesPopup extends InMenuPopup {
  let data: ref<SleevesInfoBundle>;

  protected cb func OnCreate() {
    super.OnCreate();

    let content: ref<InMenuPopupContent> = InMenuPopupContent.Create();
    content.SetTitle(GetLocalizedTextByKey(n"Mod-Sleeves-Title"));
    content.Reparent(this);

    let component: ref<SleevesPopupComponent> = new SleevesPopupComponent();
    component.SetData(this.data);
    component.Reparent(content.GetContainerWidget());

    let footer: ref<InMenuPopupFooter> = InMenuPopupFooter.Create();
    footer.Reparent(this);

    let button: ref<PopupButton> = PopupButton.Create();
    button.SetText(GetLocalizedTextByKey(n"UI-ScriptExports-Done0"));
    button.SetInputAction(n"one_click_confirm");
    button.Reparent(footer);
  }

  protected cb func OnConfirm() {
    this.PlaySound(n"Button", n"OnPress");
  }

  public static func Show(requester: ref<inkGameController>, data: ref<SleevesInfoBundle>) -> Void {
    let popup: ref<SleevesPopup> = new SleevesPopup();
    popup.data = data;
    popup.Open(requester);
  }
}
