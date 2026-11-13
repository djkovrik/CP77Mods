# ArchiveXL и прямая правка CR2W

## Подключить авторскую фазу через ArchiveXL

Для новой фазы с ожиданиями упакуй отдельную `.questphase` и при наличии ArchiveXL подключи её из `.archive.xl`. Этот пример использует scope из штатного `Bundle/QuestBaseScope.xl` и внутренний `questInputNodeDefinition.socketName = In1`. Далее из `Out` внутреннего входа веди сигнал к проверке или ожиданию.

```yaml
quest:
  phases:
    - path: example\gig\intro.questphase
      parent: cyberpunk2077.quest
```

Без явного `input` расширение ищет стартовую ноду. Для конкретной врезки укажи родительский depot path и `input: {node: [12, 34], socket: "True"}` с фактическими ID и именем. Последовательность ID спускается через встроенные `phaseGraph`; для внешнего файла выбери сам файл родителем. При наличии `output` выход новой фазы подсоединяется к выбранному получателю. `intercept: true` меняет исходную связь; проверь другие переходы между той же парой нод. [Разбор конфигурации ArchiveXL](https://github.com/psiberx/cp2077-archive-xl/blob/main/src/App/Extensions/QuestPhase/Config.cpp)

У ArchiveXL есть специальное восстановление добавленных к `questQuestResource` фаз на существующем сейве через `In1` с отметкой запуска. У вложенной `.questphase` такой же гарантии из этой реализации не следует. При корневой инъекции проверь сюжетное условие внутри новой фазы даже при настроенном якоре: при восстановлении точка запуска может отличаться от обычного прохода. Сохраняй путь модовой фазы и ID якоря между версиями. [Загрузка, соединения и восстановление фаз](https://github.com/psiberx/cp2077-archive-xl/blob/main/src/App/Extensions/QuestPhase/Extension.cpp)

### Пример последовательной врезки

В экспорте версии 2.5 у `base\quest\jackie_gun_fix.questphase` ребро `0.True → 2.In` ведёт от проверки инвентаря к первому действию. Чтобы вставить свою фазу именно на этой ветке, пример конфигурации для `QuestFix.archive.xl` выглядит так:

```yaml
quest:
  phases:
    - path: example\questfix\before_item_action.questphase
      parent: base\quest\jackie_gun_fix.questphase
      input: {node: [0], socket: "True"}
      output: {node: [2], socket: "In"}
      intercept: true
```

`input` описывает **выход родителя**, от которого новая фаза получит сигнал. `output` указывает **вход следующей ноды родителя**, куда вернётся управление. В модовой фазе задай `socketName = In1` входной ноде и `socketName = Out1` выходной. Доведи до выхода каждую ветку, после которой должно продолжаться исходное действие. Для независимого параллельного действия достаточно `input`: опусти `output` и `intercept`, чтобы исходный сигнал шёл и прежним путём. Перед переносом примера на другую версию сверь путь, классы нод и ребро по её экспорту. [Реализация соединений](https://github.com/psiberx/cp2077-archive-xl/blob/main/src/App/Extensions/QuestPhase/Extension.cpp)

Положи бинарную фазу в `QuestFix.archive` под путём из `path`, а файл конфигурации рядом с архивом в `archive\pc\mod`. При загрузке соответствующего родителя проверь свежий лог ArchiveXL: найди имя своей фазы и сообщение `Merged phase` либо диагностику отсутствующего ресурса, якоря или коллизии ID. Затем проверь в игре обе ветки родительского условия и возврат из новой фазы.

Для записей журнала используется отдельная секция [`journal:`](journal.md). Общая секция `resource.patch` применяет обработчики поддерживаемых типов и свойств. Наличие параметра `props` в патче внешности или меша само по себе не даёт операции «найти quest-ноду по ID и заменить её поле». Для такой правки подходят Codeware и прямая замена содержащего ноду файла. [Обработчики ResourcePatch](https://github.com/psiberx/cp2077-archive-xl/blob/main/src/App/Extensions/ResourcePatch/Extension.cpp)

## Отредактировать игровой ресурс напрямую

1. **Выбери самый узкий файл, который действительно загружается.** Иди по ссылкам от родителя. Изменение внешней `phaseResource` или `sceneFile` можно выпустить заменой этой фазы или сцены. Встроенная `phaseGraph` хранится в файле родителя. Для `.gamedef` сначала проверь, какой режим кампании использует именно этот файл.
2. **Зафиксируй базу для правки.** Проверь, какие архивы игры, EP1 и установленных модов поставляют точный depot path. Извлеки выбранную версию в рабочий проект. Две полные замены одного пути конкурируют целиком, даже если авторы меняли разные ноды. Для совместимости перенеси нужные изменения на общую базу и выпусти согласованную версию ресурса. После обновления игры сверь с новым оригиналом целевые поля и соседние ветви.
3. **Измени копию в WolvenKit** или выполни JSON → CR2W через `convert deserialize`. Сохрани ID существующих узлов, внешние имена входов/выходов и зависимости. Для `.quest` и `.questphase` проверь [принадлежность сокетов и рёбер](graphs.md); для `.scene` проверь `nodeId`, stamp и destinations, точки входа/выхода и ссылки на актёров. Для прямого override бинарный файл должен занять **точный исходный depot path**. Новые вспомогательные ресурсы клади по своим уникальным путям и свяжи с родителем.
4. **Собери отдельный модовый архив.** В каталоге для `pack` воспроизведи дерево depot. Например, вход `QuestFix/base/quest/…/target.questphase` должен дать запись `base\quest\…\target.questphase`. Держи экспортированные JSON, заметки и выходной архив вне входного дерева. Самостоятельному override достаточно `.archive`; соседний `.archive.xl` нужен при использовании функций ArchiveXL.

Команды для Cyberpunk 2077 2.5 проверены с WolvenKit CLI 10. Перед сборкой проверь версию командой `& $wk --version`. Подставь свои пути. `$depot` — полный путь ресурса внутри архива, `$editedJson` — экспорт с именем вида `target.questphase.json`; `$stage` — отдельная папка с именем мода, `$dist` и `$inspect` — отдельные существующие пустые каталоги.

```powershell
$asset = Join-Path $stage $depot
$assetDir = (New-Item -ItemType Directory -Force -Path (Split-Path $asset)).FullName
& $wk convert deserialize $editedJson --outpath $assetDir
Get-Item -LiteralPath $asset -ErrorAction Stop
& $wk pack $stage --outpath $dist
$archive = Join-Path $dist ((Split-Path $stage -Leaf) + '.archive')
& $wk archive $archive --list
& $wk extract $archive --outpath $inspect --regex ('^' + [regex]::Escape($depot) + '$')
$extracted = Join-Path $inspect $depot
if ((Get-FileHash $asset).Hash -ne (Get-FileHash $extracted -ErrorAction Stop).Hash) {
  throw 'Extracted CR2W differs from staged resource'
}
```

Сериализуй **извлечённый** файл заново и сравни изменённые поля и переходы с задуманными. Для проверки в игре положи собранный `.archive` в `archive\pc\mod`. Пройди вход с сейва до изменения и загрузи сейв внутри или после затронутой стадии. Изменение определения графа само по себе не воспроизводит уже прошедший одноразовый сигнал.
