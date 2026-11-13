# Пример точечного патча Codeware

Этот пример предполагает уже поставленную фазу `example\gig\intro.questphase`. В её **корневом** графе нода `37` проверяет `my_gig_offers`, и известно требуемое изменение порога с 1 до 2 при операторе `Greater`. Для реального квеста сначала установи эти значения из его экспорта. При повторной загрузке изменяется только подходящая версия исходного условия.

```reds
module QuestSkillExample

public class OfferPatch extends ScriptableService {
  private cb func OnLoad() {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/PostLoad", this, n"OnPhase")
      .AddTarget(ResourceTarget.Path(r"example\\gig\\intro.questphase"));
  }

  private cb func OnPhase(event: ref<ResourceEvent>) {
    let phase = event.GetResource() as questQuestPhaseResource;
    let graph: ref<questGraphDefinition>;
    let check: ref<questConditionNodeDefinition>;
    let facts: ref<questFactsDBCondition>;
    let comparison: ref<questVarComparison_ConditionType>;
    if !IsDefined(phase) { return; };
    graph = phase.graph as questGraphDefinition;
    if !IsDefined(graph) { return; };
    for node in graph.nodes {
      check = node as questConditionNodeDefinition;
      if IsDefined(check) && Cast<Int32>(check.id) == 37 {
        facts = check.condition as questFactsDBCondition;
        if IsDefined(facts) {
          comparison = facts.type as questVarComparison_ConditionType;
          if IsDefined(comparison) && Equals(comparison.factName, "my_gig_offers")
            && Equals(comparison.comparisonType, EComparisonType.Greater)
            && comparison.value == 1 {
            comparison.value = 2;
          };
        };
        return;
      };
    };
  }
}
```

Для сцены аналогичный обработчик приводит `event.GetResource()` к `scnSceneResource`, читает `scene.sceneGraph.graph`, выбирает узел по `nodeId.id` и конкретному классу. Для `scnQuestNode` затем приводит `questNode` к ожидаемому типу. Поиск выполняется при загрузке целевого ресурса. У вложенной квестовой ноды собственный `id`, который нельзя использовать вместо ID узла сцены.

Пример ниже добавляет **новое** ребро между уже созданными и принадлежащими нодам обычными сокетами. Вызывающий код выбирает сокеты одного графа по владельцу и имени, проверяет, нет ли этого ребра, и при последовательной вставке отдельно переносит старое ребро. Оператор `ArrayPush` должен обновлять настоящие поля двух сокетов. При создании нового сокета присвой `owner`, `name` и `type` и добавь его в `owner.sockets`.

```reds
public class Wiring extends IScriptable {
  public static func Connect(output: ref<questSocketDefinition>,
                             input: ref<questSocketDefinition>) -> Void {
    let edge: ref<graphGraphConnectionDefinition>;
    if !IsDefined(output) || !IsDefined(input) { return; };
    if NotEquals(output.type, questSocketType.Output)
      || NotEquals(input.type, questSocketType.Input) { return; };
    edge = new graphGraphConnectionDefinition();
    edge.source = output;
    edge.destination = input;
    ArrayPush(output.connections, edge);
    ArrayPush(input.connections, edge);
  }
}
```

После правки графа проверь у источника и получателя идентичность одного и того же объекта ребра. Для исправлений с несколькими целями индексируй их за один обход ресурса. Время выполнения native-обработки графа измеряется в игре.
