// public class MySaveData {
//   public persistent let counter: Int32;
//   public let temp: Int32;
// }

// @addField(GameSessionDataSystem)
// private persistent let m_mySaveData: ref<MySaveData>;

// @wrapMethod(GameSessionDataSystem)
// private final func Initialize() -> Void {
//   wrappedMethod();

//   if !IsDefined(this.m_mySaveData) {
//     this.m_mySaveData = new MySaveData();
//     this.m_mySaveData.counter = 1;
//     this.m_mySaveData.temp = 777;
//   } else {
//     this.m_mySaveData.counter += 1;
//   }

//   LogChannel(n"DEBUG", "Persist: " + ToString(this.m_mySaveData.counter) + " / " + ToString(this.m_mySaveData.temp));
// }
