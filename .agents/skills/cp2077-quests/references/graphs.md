# Графы, условия и соединения

## Определи уровень

| Ресурс | RootChunk и поля |
| --- | --- |
| `.gamedef` | `gsmGameDefinition`. Ссылки `mainQuests[].questFile`, `world`, `streamingWorld`, стартовые теги. При обычном добавлении фазы основной файл кампании заменять не требуется |
| `.quest` | `questQuestResource` наследует `questQuestPhaseResource`. `graph → questGraphDefinition.nodes[]`, вход исполнения обычно виден как `questStartNodeDefinition` |
| `.questphase` | `questQuestPhaseResource`. В родительской `questPhaseNodeDefinition` проверь `phaseResource` (внешний путь) и `phaseGraph` (встроенный граф). Нулевой путь встречается у заполненного `phaseGraph`. Проверь `phasePrefabs` ресурса, `phaseInstancePrefabs` узла и связанные `NodeRef`, если нужны объекты мира |
| `.scene` | `scnSceneResource`. `questSceneNodeDefinition.sceneFile` ссылается на него из квеста. Сама сцена владеет `sceneGraph`, входами/выходами, актёрами, реквизитом и маркерами |

`questNodeDefinition.id` — `Uint16` внутри графа. Для адресации используй путь ресурса, цепочку вложенных phase-node ID и ID нужной ноды. `HandleId` присваивает сериализатор объекту в данном экспорте. `scnNodeId`, `NodeRef` мира, `gameJournalPath` и имя fact адресуют другие объекты.

При переходе по `phaseResource` проверь `Flags`. Для `Embedded` сопоставь `DepotPath.$value` с `Data.EmbeddedFiles[].FileName.$value` в том же документе и открой `Content`. Например, в `sts_std_rancho_corronado.questphase` нода 7 ссылается так на `sts_std_rcr_02_phase.questphase`. Отдельно экспортированный одноимённый файл сам по себе не устанавливает, какой экземпляр загрузит игра.

## Как выбрать тип

| Задача | Что искать в JSON и `Codeware.Global.reds` |
| --- | --- |
| Начать, войти во вложенную фазу, вернуться | `questStartNodeDefinition`/`questEndNodeDefinition` на корне. `questInputNodeDefinition`/`questOutputNodeDefinition` внутри фазы. Их `socketName` задаёт имя соответствующего внешнего сокета родительской ноды. Проверь также `questOutputNodeDefinition.type` |
| Проверить сейчас или ждать | `questConditionNodeDefinition.condition` с выходами `True`/`False`; `questPauseConditionNodeDefinition.condition` ждёт выполнения условия и продолжает поток. Неподключённая ветка допустима. При условии на изменение отдельно проверь вход, когда условие уже истинно |
| Выбрать один или несколько маршрутов | `questSwitchNodeDefinition.conditions[]` хранит `condition` и `socketId`, `behaviour` бывает `First_Fulfilled`/`All_Fulfilled`. Сохрани соответствие выходам и порядок. У `questRandomizerNodeDefinition` проверь `mode` и `outputWeights` |
| Свести/синхронизировать сигналы или прервать ветку | `questLogicalHubNodeDefinition`, `questLogicalAndNodeDefinition`, `questLogicalXorNodeDefinition`. У базового класса есть `inputSocketCount`/`outputSocketCount`. Для прерывания — `questCutControlNodeDefinition` и пара `CutSource`/`CutDestination`; учитывай `permanent`. Для логики предикатов есть отдельная `questLogicalCondition(operation, conditions[])` |
| Facts | Читать: `questFactsDBCondition.type → questVarComparison_ConditionType(factName, comparisonType, value)` либо `questVarVsVarComparison_ConditionType`. Писать: `questFactsDBManagerNodeDefinition.type → questSetVar_NodeType`, где `setExactValue` различает установку и изменение на величину |
| Время и пространство | `questTimeCondition.type` → `questRealtimeDelay_ConditionType` или `questGameTimeDelay_ConditionType`. У первого есть поле `miliseconds` именно с таким написанием. `questTriggerCondition` содержит `triggerAreaRef`, вид события, активатора; `questDistanceCondition.type` описывает измерение и сравнение |
| Акторы, объекты, мир | `questCharacterCondition` (например, `questCharacterSpawned_ConditionType`), `questObjectCondition` (инвентарь), `questSpawnManagerNodeDefinition.actions[]`, `questWorldDataManagerNodeDefinition`, `questUseWorkspotNodeDefinition`. Для `EntityReference` и `NodeRef` проверь спавн и фазу присутствия объекта |
| Сцены, события, предметы и награды | `questSceneNodeDefinition` запускает ресурс; `questSceneManagerNodeDefinition.type` выполняет действие менеджера. `questEventManagerNodeDefinition.event` и адресат связывают граф и игровую систему. `questItemManagerNodeDefinition` и `questRewardManagerNodeDefinition.type → questGiveReward_NodeType.rewards[]` имеют разные входные данные |
| Прогресс, представление и телефон | `questJournalNodeDefinition.type`, `questMappinManagerNodeDefinition.path`, `questPhoneManagerNodeDefinition.type`. Для ожидания ответа проследи `questJournalCondition.type` и состояние записи. [Пути и состояния](journal.md) |

У `questCheckpointNodeDefinition` есть настройки `saveLock`, `ignoreSaveLocks`, `retryOnFailure` и др. При сохранении на границе фаз проверь возобновление ожидающего узла. Для незнакомого типа найди его в действующей фазе, затем проследи объявление до конкретного подтипа полей `type`/`condition`. Одного названия менеджера недостаточно для выбора действия.

### Развилка, объединение и ожидание нескольких сигналов

У Switch выход `Case{socketId}` соответствует `conditions[].socketId`. При `First_Fulfilled` порядок задаёт приоритет, `Otherwise` даёт запасной путь. Для параллельных подходящих веток проверь `All_Fulfilled`. Hub пропускает каждое поступление — две завершившиеся ветки могут дважды запустить общее действие. Для продолжения после всех входов используй And, для первого из конкурирующих событий рассмотри Xor и проверь его повторное взведение. У Flow Control есть начальное `isOpen` и пороги `opensAt`/`closesAt`; проверь последовательность импульсов на выбранном классе. Автор руководства помечает ручное управление сокетами сценового варианта как непроверенное. [Справочник нод](https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/quest/scene-node-definitions)

Для `.scene` со встроенным `scnQuestNode` см. [штампы, таблицы соответствия и выбор реплики](scenes-and-dialogue.md).

## Дождаться прибытия игрока

Для цели «доберись до места» заведи в исполняемой `.quest` или `.questphase` узел `questPauseConditionNodeDefinition` с `condition = questTriggerCondition`. Задай `triggerAreaRef` области мира, `isPlayerActivator = true` и `type = IsInside`. Подай сигнал на `In` после выдачи цели. На `Out` подключи нужное продолжение: скрыть метку, отправить следующее SMS, завершить цель. Ожидание ведёт движок, скриптовый таймер для проверки позиции не требуется. `Entered` подходит, когда важен именно новый вход; для `IsInside` проверь также старт и загрузку сейва с игроком уже внутри зоны.

В `base\quest\minor_quests\mq055\phases\mq055_apartment_megabuilding.questphase` префаб `#mq055_pr_megabuilding` перечислен в `phasePrefabs`. Во встроенном графе нода 6 ждёт игрока в `#mq055_tr_megabuilding_apartment` с типом `IsInside`. Ребро `6.Out → 12.Inactive` выключает маркер через `questMappinManagerNodeDefinition`. В соседних встроенных графах ID отличаются.

У области есть объём, у маркера — отображаемая позиция. Если игрок должен подойти на 8 м к метке со смещением, размести область у **итоговой точки назначения** и подбери форму и размеры под допустимое расстояние. Можно использовать существующую область с подходящей геометрией или добавить свою и обеспечить загрузку её сектора/префаба на время ожидания. Для движущейся сущности рассмотри `questDistanceCondition → questDistanceComparison_ConditionType`: проверь, что ссылки на игрока и объект разрешаются, и сравни расстояние с порогом. При переносе действующего квеста со скриптового опроса предусмотри вход в фазу для сейва на стадии пути и исключи двойное срабатывание при прибытии.

## Добавить ноду между двумя сокетами

Проверенный малый пример — `base\quest\cyberpunk2077.quest`. Нода `0`, сокет `Out` (handle `3`), ребро `4`, сокет `Start` (handle `5`) ноды `2`. В файле первый экземпляр сокета `5` находится **внутри destination ребра**. В `nodes[1].sockets` хранится `HandleRefId: "5"`. Поэтому сначала индексируй все `HandleId → Data` во всём ресурсе, затем восстанавливай принадлежность через `nodes[].sockets[]`. На обоих концах хранится одно ребро.

Для вставки `A.Out → N.In → B.In`:

1. Раскрой конкретный граф, найди A и B и их сокеты по **направлению и имени**. Зафиксируй нужное исходное ребро и все соседние ветви. Ожидание на последовательном пути от корневого Start задержит весь ванильный путь за ним. Для независимого задания выбери отдельную ветку. Для параллельного действия сохрани `A → B` и добавь ответвление. Для последовательной вставки замени только выбранное ребро.
2. Добавь в `graph.nodes` подходящую конкретную ноду N со свободным `Uint16 id` и payload. Создай сокеты конкретного класса `questSocketDefinition` с именами и типами, которые ожидает действие. В runtime новый сокет должен знать `owner` и входить в `node.sockets`. В обычном JSON владение видно по `sockets`, даже когда `owner` не сериализован.
3. При последовательной вставке можно сохранить объект исходного ребра: перенеси его назначение с B на N, убери его из `B.In.connections` и добавь в `N.In.connections`, сохранив его запись у A. Создай одно второе `graphGraphConnectionDefinition` с `source=N.Out` и `destination=B.In`. Добавь **один и тот же** объект в `N.Out.connections` и `B.In.connections`. Для другого выбранного имени входа подставь его с обеих сторон операции.
4. В JSON назначай новые `HandleId`, свободные во всём ресурсе, и один раз определяй `Data` каждого объекта. Расположи определение объекта при первом появлении в порядке чтения JSON. Этот порядок проверен при сборке и повторном экспорте графа в WolvenKit CLI 10. Остальные ссылки на объект — `HandleRefId`. Если удаляемая ветвь JSON содержала первое определение сокета/ребра, перенеси определение к сохранившейся ссылке. Удобно редактировать граф в WolvenKit и проверить его повторный экспорт. При правке из Codeware это объекты `ref`/`wref`, без манипуляций с номерами JSON. [Пример соединения в redscript](codeware-patch.md) Составь изменение полностью до публикации в графе.
5. Проверь оба ребра в обеих коллекциях, прежние побочные ветви, внешние имена фазы и ожидаемую активацию. При JSON-правке собери CR2W, сериализуй заново и сравни семантические тройки «нода/сокет → нода/сокет» в нужной области. CLI скилла показывает их для вложенных фаз. Нумерация handle может измениться после сериализации.

**Сцены используют другую модель.** `scnSceneResource.sceneGraph.graph[]` содержит `scnSceneGraphNode`. Переход хранится у источника как `outputSockets[].stamp` и `destinations[]` со значениями `nodeId.id` и `isockStamp.{name,ordinal}` у получателя. Используй реальные stamp подходящего входа и выхода; один `nodeId` не различает входы. Для внешнего контракта проверь `entryPoints`/`exitPoints` и `startNodes`/`endNodes`. У `scnQuestNode` есть вложенная `questNode` и таблицы `isockMappings`/`osockMappings`, связывающие сцену с именами квестовых сокетов. При точечной коррекции содержимого сохрани эти таблицы, ID и связи сцены.

Для подключения новой фазы, прямой замены файла и проверки пакета см. [ArchiveXL и прямая правка CR2W](resource-patches.md).
