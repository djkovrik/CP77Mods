# Управление из redscript и Codeware

## Кто за что отвечает

| Действие | Объявление, которое стоит открыть |
| --- | --- |
| Прочитать прогресс, подписаться на изменение | Игровой `QuestsSystem` в `orphans.swift`. `GameInstance.GetQuestsSystem(gi)`, `GetFact/SetFact(CName, Int32)`, строковые `GetFactStr/SetFactStr`. `RegisterListener(factName, listener, funcName) → Uint32` и `UnregisterListener(factName, id)` |
| Разобрать установленный тип | `red4ext\plugins\Codeware\Scripts\Codeware.Global.reds`. Ищи точный `$type`, его предков, `@addField` и `@addMethod`. Для журналов у типа ресурса часто есть скриптовый псевдоним |
| Выполнить действие, у которого есть подходящая quest-нода | Расширение Codeware `QuestsSystem.ExecuteNode(node: ref<questNodeDefinition>, opt inputSocket: CName)`. Выбери конкретные класс и payload по ванильному графу, включая имя входа, если действие различает входы |
| Получить сигнал готовности сессии или загруженный ресурс | Codeware `GameInstance.GetCallbackSystem()`, `GameSessionEvent`, `ResourceEvent`, `ResourceTarget.Path`. Область жизни регистрации зависит от владельца |
| Проверить скриптовую часть условия | `cyberpunk\quest\questCondition.swift`. У `ScriptConditionTypeBase` есть `Evaluate(playerObject)`, у `LifePath_ScriptConditionType` и `Build_ScriptConditionType` — конкретная логика. В Codeware проверь соответствующий контейнер, например `questLifePath_ConditionType` и унаследованное поле `scriptCondition`. У прочих native-условий реализация может быть только в движке |

### Три варианта старта

1. **После загрузки.** Зарегистрируй `Session/Ready` заранее, например в `OnAttach` сессионной `ScriptableSystem` с `SetLifetime(CallbackLifetime.Session)`. В обработчике прочитай стадию из текущего сейва. При первом запуске создай начальную стадию, при последующих — восстанови отображение и временные связи. Если действие требует активный puppet или загруженный объект, привяжи эту часть к событию его готовности. `OnLoad` у сервиса подходит для регистрации обработчиков ещё до загрузки ресурсов.
2. **После сюжетной вехи.** Найди fact, его авторов, значение и оператор сравнения в фазах конкретной линии. Подпишись и сразу проверь текущее значение через тот же обработчик перехода. Сохрани ID подписки и освободи его тем же именем fact при завершении владельца. В `base\quest\main_quests\prologue\prologue.questphase` встречается условие `q003_done > 0`, а также составные проверки с `q004_done`. Выбор одного из них меняет доступность для игрока.
3. **Повторяемое задание.** Раздели постоянную разблокировку и экземпляр выполнения. Храни в сейве номер цикла, стадию и условие следующего допуска (при таймере — срок в выбранной шкале времени). По завершении один раз закрой цель и выдай результат для этого цикла, убери его маркер и подписки. Новый сигнал допуска создаёт следующий цикл. На загрузке синхронизируй текущий цикл; отложенный сигнал проверь по номеру цикла и ожидаемой стадии. Для ожидания после перемотки времени сравни сохранённый срок с игровыми часами.

Пример владельца **стартового fact**. Значение `10` здесь означает принятие задания модом. Обработчик стадии может отдельно активировать заранее зарегистрированный журнал. `q003_done` выбран для примера, имя `my_gig_stage` при использовании замени уникальным именем. Подписка нужна для игры, в которой сюжетная веха будет пройдена позже.

```reds
module QuestSkillExample

public class StoryGate extends ScriptableSystem {
  private let listenerID: Uint32;
  private let listening: Bool;

  private func OnAttach() -> Void {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Session/Ready", this, n"OnReady")
      .SetLifetime(CallbackLifetime.Session);
  }

  private cb func OnReady(event: ref<GameSessionEvent>) {
    let qs = GameInstance.GetQuestsSystem(this.GetGameInstance());
    if !this.listening {
      this.listenerID = qs.RegisterListener(n"q003_done", this, n"OnStoryFact");
      this.listening = true;
    };
    this.OnStoryFact(qs.GetFact(n"q003_done"));
  }

  public final func OnStoryFact(value: Int32) -> Void {
    let qs = GameInstance.GetQuestsSystem(this.GetGameInstance());
    if value > 0 && qs.GetFact(n"my_gig_stage") == 0 {
      qs.SetFact(n"my_gig_stage", 10);
    };
  }

  private func OnDetach() -> Void {
    if this.listening {
      GameInstance.GetQuestsSystem(this.GetGameInstance())
        .UnregisterListener(n"q003_done", this.listenerID);
      this.listening = false;
    };
  }
}
```

Одна функция перехода должна принимать событие только из ожидаемой стадии. При восстановлении сверяй желаемое и фактическое состояние журнала и маркеров. Повторное уведомление и выдача награды — отдельные побочные эффекты. Для ветвящегося квеста оставляй явные конечные состояния успеха и провала. Не изменяй сюжетный fact игры для старта собственного задания.

## Прямое выполнение и исправление ресурсов

Для самостоятельного действия собери экземпляр ноды и её конкретный payload. Например, `questFactsDBManagerNodeDefinition.type = questSetVar_NodeType` задаёт `factName`, `value` и `setExactValue`, затем `qs.ExecuteNode(node)`. Для простого присваивания fact достаточно `SetFact`. Полезнее `ExecuteNode` для движковых действий со специализированными параметрами. В реализации Codeware создаётся контекст корневой фазы, native-вызов получает один вход, а массив выходов остаётся внутри вызова. Продолжение по рёбрам, сохранение места ожидания и контекст локальной вложенной фазы этим API не предоставлены как контракт. Для них включи фазу в исполняемый граф. [Реализация ExecuteNode](https://github.com/psiberx/cp2077-codeware/blob/main/src/App/Quest/QuestsSystemEx.hpp)

**Для исправления существующего действия** найди депо-путь, граф-владелец, ID и класс ноды, чтó должно было быть в payload, соседние связи. В `ScriptableService.OnLoad` подпишись на `Resource/PostLoad` с `.AddTarget(ResourceTarget.Path(r"base\\quest\\…"))`. В `private cb func OnLoaded(event: ref<ResourceEvent>)` получи `event.GetResource()`, приведи к `questQuestPhaseResource` либо `scnSceneResource` и проверь `IsDefined`. Для внешней фазы подписывайся на её собственный путь; для inline-фазы спустись по цепочке ID в `phaseGraph`. Найди цель одним проходом, проверь ожидаемые исходные поля и измени лишь их. При повторном вызове распознавай уже применённую правку. У ресурса может быть несколько пользователей и он может загрузиться до появления игрока.

Полный пример обработчика и соединения двух сокетов см. в [примерах патчинга Codeware](codeware-patch.md).

Изменение определения влияет на его последующее использование. Если одноразовый сигнал уже прошёл, исправление перехода на старом сейве проверяй отдельно. При необходимости предусмотрен отдельный путь восстановления: узкое условие проблемного состояния, однократная корректировка собственного прогресса, повторная проверка. Пройди сейвы до, внутри и после исправляемой ветки; сохрани остальные исходы. Для разных профилей, включая старт сразу с Phantom Liberty, проверь доступность всех используемых ресурсов.
