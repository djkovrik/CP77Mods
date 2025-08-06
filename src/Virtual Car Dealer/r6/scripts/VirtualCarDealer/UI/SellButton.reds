import Codeware.UI.*

public class SellButton extends SimpleButton {
  public static func Create() -> ref<SellButton> {
    let self: ref<SellButton> = new SellButton();
    self.CreateInstance();
    return self;
  }

  public func SetDisabledState(isDisabled: Bool) {
    super.SetDisabledState(isDisabled);
  }
}
