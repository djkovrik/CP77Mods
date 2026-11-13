# Журнал, цель на карте и телефон

## Подготовить дерево и пути

1. Найди аналогичную ветку в `cooked_journal.journal` и её использование в ванильной фазе. В модовом `gameJournalResource.entry` описывается дерево `gameJournalRootFolderEntry → gameJournalPrimaryFolderEntry → …`. Используй стабильные `id` для записей и уникальные ID собственных веток. Для задания типовой маршрут идёт через папки к `gameJournalQuest → gameJournalQuestPhase → gameJournalQuestObjective`; сверь точную вложенность. Под целью могут находиться маркеры и ссылки. Для телефона маршрут `contacts/<contact>/<conversation>/<message>` соответствует типам `gameJournalContact → gameJournalPhoneConversation → gameJournalPhoneMessage`.
2. Упакуй `.journal` по собственному depot path и зарегистрируй ресурс в ArchiveXL. Для локализуемого текста свяжи поля записей с ключами фактических языковых ресурсов мода. Уточняй расположение исходных JSON при работе с конкретной локализацией.

```yaml
journal:
  - example\gig\dispatch.journal
localization:
  onscreens:
    en-us: example\gig\localization\en-us.json
```

3. В `gameJournalPath` проверь `realPath` и RTTI `className`. При авторинге графа возьми структуру пути того же вида из рабочего аналога, проверь поля, включая `fileEntryIndex`. Для запросов `JournalManager` используй путь по ID со слешами и имя ресурса вроде `"gameJournalQuestObjective"`. Скриптовое имя для приведения типа — `JournalQuestObjective`. `GetEntryByString(path, className)` позволяет отдельно диагностировать отсутствие записи, неверный класс и состояние уже существующей записи. В `core\systems\journalManager.swift` у ряда методов `CreateScriptedQuestFromTemplate`/`SetScriptedQuest…` видны заглушки: сначала проверь реализацию в целевой сборке.

## Провести игрока между стадиями

Обычно ветка журнала поставляется целиком. На старте активируй нужные родительские записи, фазу и первую цель. При продвижении поставь предыдущей цели `Succeeded` или `Failed` и активируй следующую. Заверши нужную фазу и задание, сними прежний маркер. Уточни по образцу условия и распространение изменений на дочерние записи. `TrackEntry` используй при намеренном переключении отслеживаемой цели, учитывая текущий выбор игрока.

Этот фрагмент внутри функции меняет одну заранее найденную цель. `notify` задаёт вызывающий код: для первого показа — `JournalNotifyOption.Notify`, для синхронизации интерфейса после загрузки — `DoNotNotify`. По результату `false` отличи отсутствующую запись от отклонённого изменения, прежде чем продвинуть стадию.

```reds
public static func SetObjective(journal: ref<JournalManager>, path: String,
                                state: gameJournalEntryState, notify: JournalNotifyOption) -> Bool {
  let entry = journal.GetEntryByString(path, "gameJournalQuestObjective");
  if !IsDefined(entry) {
    return false;
  };
  if Equals(journal.GetEntryState(entry), state) {
    return true;
  };
  return journal.ChangeEntryState(path, "gameJournalQuestObjective", state, notify);
}
```

В графе ориентируйся на `questJournalNodeDefinition.type`. `questJournalQuestEntry_NodeType` содержит `path`, `sendNotification` и `trackQuest`. Важен сигнал на **именованном входе** узла — найди в экспорте, каким входом конкретная ветка переводит запись в нужное состояние (например, `Active`, `Succeeded`, `Failed` в q001). `questJournalBulkUpdate_NodeType` содержит фильтр типа и состояния, целевое состояние и `propagateChange`; проверь затрагиваемое поддерево перед массовым обновлением. Для счётчиков и optional-целей существуют `questJournalQuestObjectiveCounter_NodeType` и `questJournalQuestSetObjectiveOptional_NodeType`.

## Выбрать маркер

### Отслеживаемая цель с расстоянием

1. В модовом журнале создай под нужной `gameJournalQuestObjective` дочернюю `gameJournalQuestMapPin`. Для статической точки проверена комбинация `enableGPS = 1`, `mappinData.active = 1`, `Mappins.QuestStaticMappinDefinition`, `DefaultQuestVariant` и `slotName = UI_Interaction`.
2. Найди именованный `worldStaticMarkerNode` в секторе категории `AlwaysLoaded`, чтобы цель разрешалась издалека. Возьми полный **путь узла мира** вида `$/…/#имя` из `nodeRefs` сектора и его мировую позицию из трансформа соответствующего экземпляра. В журнале укажи этот путь в `reference.reference` (`NodeRef`, тип ссылки `EntityRef`). Для статического маркера ArchiveXL вычисли `offset = мировая позиция цели − мировая позиция узла`. После сборки проверь по повторному экспорту, что позиция узла плюс смещение попадает в область, по которой мод засчитывает прибытие. Пустой NodeRef с мировыми координатами в `offset` в игровом тесте оставил цель без видимой метки и расстояния.
3. Активируй задание, фазу и цель. Для самой метки создай `gameJournalPath`: `realPath` ведёт до **листа метки**, `className = n"gameJournalQuestMapPin"`. Поле `fileEntryIndex` — индекс сегмента задания в пути, считая с нуля. Для `quests/side_quest/my_job/visit/market/pin` это 2; дополнительная папка перед `my_job` сдвинет индекс. Проверь лист через `GetEntryByString`, передай путь в `questMappinManagerNodeDefinition.path`, выставь `disablePreviousMappins = false` и вызови `qs.ExecuteNode(node, n"Active")`. В авторском графе направь сигнал на одноимённый вход этой ноды. При завершении подай `Inactive`. В `q001.questphase` так управляется дочерняя метка `…/go_to_jackie/jackie`.
4. Для автоматического отслеживания при первом старте передай в `JournalManager.TrackEntry` запись **цели**. При восстановлении активной стадии старый сейв может содержать лист в состоянии `Active` без созданной метки. Для этой собственной метки один раз при восстановлении выполни `Inactive → Active` через ту же ноду. Сохрани пользовательский выбор отслеживаемой цели.
5. Если задание есть, а расстояние отсутствует, на следующем тике запроси `MappinSystem.GetQuestMappinPositionsByObjective(Cast<Uint32>(jm.GetEntryHash(objective)), positions)` и `jm.GetDistanceToNearestMappin(objective)`. Проверь число позиций и XYZ относительно точки прибытия. Для проверки отдельного листа используй `GetQuestMappinPosition` с хешем метки. В игре выбери цель вдали от точки и проверь расстояние в журнале, метку на карте и в мире.

### Отдельная отметка

- **Временная отметка по позиции или объекту.** Заполни `MappinData.mappinType` и `variant` из подходящего ванильного примера. `GameInstance.GetMappinSystem(gi).RegisterMappin(data, position)` или `RegisterMappinWithObject(data, object, slotName, offset)` возвращает `NewMappinID`. Сохраняй ID в сессионном владельце для `UnregisterMappin(id)` при отмене или завершении. При восстановлении по сохранённой стадии заново разреши цель и избеги дублей. Созданный таким образом маркер сам по себе не создаёт запись журнала и связь с GPS цели.

## SMS, выбор ответа, история

Для обычного диалога задай contact, conversation, message и при необходимости `gameJournalPhoneChoiceGroup` с отдельными `gameJournalPhoneChoiceEntry`. Чтобы открыть выбор после сообщения, отдельно активируй запись группы вариантов. После ответа оставь применённые игрой состояния. Активируй родителей и сообщение тем же `ChangeEntryState` с правильным классом; для следующего сообщения активируй следующий ID. Графовый вариант — `questPhoneManagerNodeDefinition.type → questSendMessage_NodeType(msg, sendNotification)`, либо журнал и явные изменения состояния по ванильному образцу.

**Изменение текста существующего SMS.** Найди контакт и сообщение в `cooked_journal.journal`. Число после `LocKey#` в нужном поле сопоставь с `primaryKey` записи в языковом `onscreens`. Проверь остальные ссылки на этот ключ: замена общего текста затронет и их. Для локальной правки текста достаточно подать нужные переводы через ArchiveXL. [Изменение сообщений игры](https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/quest/how-to-edit-in-game-messages)

**Фото в сообщении.** `gameJournalPhoneMessage.imageId` ссылается на TweakDB-запись `UIJournalIcons.*` типа `gamedataJournalIcon_Record`; у неё должны совпасть depot path в `atlasResourcePath` и имя части атласа в `atlasPartName`. В графовой переписке пути группы ответов и отдельных выбранных реплик различаются. Проверь каждую ветку, в том числе отображение фото. [Переписка и её ресурсы](https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/quest/how-to-add-new-text-messages-thread-to-cyberpunk-2077)

### Входящий баннер при загрузке сейва

Телефон реагирует на прямое изменение записи сообщения в `Active` с `JournalNotifyOption.Notify` после того, как `NewHudPhoneGameController.OnInitialize` подписался на журнал. Если SMS уже видно в переписке, а баннер пропущен, проверь порядок инициализации и предыдущий статус записи. `Session/Ready` с фиксированной задержкой не гарантирует готовность телефонного HUD.

Для сообщения, которое должно всплыть при старте или восстановлении задания, в игре проверен такой порядок:

1. Активируй контакт и беседу. Разреши лист как `JournalPhoneMessage` с `sender = NPC` и родителем `JournalPhoneConversation`. После `wrappedMethod()` в обёртке `NewHudPhoneGameController.OnInitialize` передай сессионной системе слабую ссылку на контроллер. В `OnUninitialize` сбрось её, если она всё ещё указывает на этот экземпляр.
2. Дождись, когда контроллер связан с текущим `JournalManager`, создан `phoneIconElement.widget`, корневой виджет видим, список контактов закрыт, `m_CurrentFunction == EHudPhoneFunction.Inactive`, игра вне меню и паузы. Пока доставка ожидает, повторяй проверку сессионным callback; отмени его при выходе из сессии.
3. Если запись ещё не активна, вызови `ChangeEntryState(path, "gameJournalPhoneMessage", Active, DoNotNotify)` и проверь результат. Затем вызови `phoneHUD.ShowNewMessage(entry, gameJournalEntryState.Active)` один раз для этого сообщения. Это штатный путь через `PushSMSNotification` с открытием беседы из баннера. В этой схеме тихая активация оставляет одного отправителя уведомления; обычную доставку через `Notify` используй отдельно.
4. Сразу после вызова сохрани в сейве признак постановки **конкретного SMS** в очередь. При повторной загрузке он защищает от дубликатов. При миграции сейва без такого признака у уже активного задания проверь `jm.IsEntryVisited(entry)`: прочитанному сообщению повторный баннер не нужен, непрочитанное можно поставить в очередь один раз. Завершённую стадию не открывай заново. Постановку в очередь можно логировать; фактический показ проверяй на экране.

### Ответ игрока

В `base\quest\side_quests\sq028\phases\sq028_kerrys_sms.questphase` проследи фазы внутри `phaseGraph`: развилка по fact отношений, сообщения по `contacts/kerry_eurodyne/…`, ожидание `questJournalCondition → questJournalEntryState_ConditionType` по пути конкретного варианта ответа. В игре `messengerDialogView.swift` переводит выбранный вариант в `Succeeded` и снимает остальные варианты. Из скрипта можно подписаться через `RegisterScriptCallback(owner, callback, gameJournalListenerType.State)`, отфильтровать конкретную запись и состояние, обработать это один раз и затем снять подписку через `UnregisterScriptCallback(owner, callback)`. У слушателя State сигнатура `OnJournalUpdate(entryHash: Uint32, className: CName, notifyOption: JournalNotifyOption, changeType: JournalChangeType) -> Bool`. Получи запись через `GetEntry(entryHash)` и сравни её с нужным вариантом. При восстановлении прочитай текущее состояние ответа, чтобы обработать уже сделанный выбор. Холозвонок с постановкой потребует другой цепочки: см. `questCallContact_NodeType`, ресурс сцены, записи контактов и `prefabNodeRef`.

**Динамическая история** нужна, когда текст или число событий зависят от сохранения. Можно заранее выделить конечный набор слотов-сообщений, хранить данные событий в сохраняемой системе и восстановить их тексты, когда готовы и журнал, и данные сейва. Обновляй один слот при добавлении, всю затронутую часть — при сдвиге или восстановлении. Переактивация `Inactive → Active` подходит для явного повторного уведомления при переиспользовании слота. Для фиксированного сюжета достаточно активировать авторские записи. Проверяй входящее сообщение, доступность ответа, вид после перезагрузки, отсутствие повторных уведомлений и появление новой цели.
