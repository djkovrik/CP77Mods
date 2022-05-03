// -----------------------------------------------------------------------------
// CarDealer.Codeware.UI.inkCustomEvent
// -----------------------------------------------------------------------------
//
// public abstract class inkCustomEvent extends inkEvent {
//   public func GetController() -> wref<inkCustomController>
// }
//

module CarDealer.Codeware.UI

public abstract class inkCustomEvent extends inkEvent {
	protected let controller: ref<inkCustomController>;

	public func GetController() -> wref<inkCustomController> {
		return this.controller;
	}
}
