class NamedSavesEnv extends ScriptableEnv {
  private let lastUsedName: String  = "";

  public func Set(name: String) -> Void {
    this.lastUsedName = name;
  }

  public func Get() -> String {
    return this.lastUsedName;
  }

  public static func SetName(name: String) -> Void {
    let env: ref<NamedSavesEnv> = ScriptableEnv.Get(n"NamedSavesEnv") as NamedSavesEnv;
    env.Set(name);
  }

  public static func GetName() -> String {
    let env: ref<NamedSavesEnv> = ScriptableEnv.Get(n"NamedSavesEnv") as NamedSavesEnv;
    return env.Get();
  }

  public static func IsNotEmpty() -> Bool {
    let env: ref<NamedSavesEnv> = ScriptableEnv.Get(n"NamedSavesEnv") as NamedSavesEnv;
    let name: String = env.Get();
    return NotEquals(name, "");
  }
}
