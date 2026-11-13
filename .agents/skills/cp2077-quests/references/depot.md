# Где искать квестовые ресурсы

Ниже — depot paths. Префиксы каталогов извлечения и суффикс `.json` экспорта WolvenKit в игровые ссылки не входят. Корни EP1 могут лежать в каталоге извлечения архива с таким же именем: `…\ep1\ep1\quest` на диске соответствует `ep1\quest` в depot. При пустом или повреждённом экспорте сверь путь с установленным архивом и сериализуй нужный CR2W в отдельный каталог. Проверь тип `Data.RootChunk` и доступность дочерних ресурсов. Размер файла и успешный выход CLI сами по себе не проверяют экспорт.

```text
base\quest\
  cyberpunk2077.gamedef → cyberpunk2077.quest → cyberpunk2077.questphase
  main_quests\prologue\q000, q001, q003, q004, q005
  main_quests\part1\…                 в т. ч. act_1.questphase
  main_quests\epilogue\…              эпилоги и final_boards
  side_quests\sq…\                    цепочки побочных заданий
  minor_quests\mq…\                   малые задания
  graph_templates\                    qb_holocall_*, random_time_*, switch_sits
  holocalls\                          общие телефонные фазы
  bugfixing\, player\, telemetry\     исправления, общие игровые ветки
  primary_characters\, secondary_characters\, tertiary_characters\, character_vehicles\
  demos\, test\, main_menu\           контекст проверяй по родителю
base\open_world\
  phases\open_world_content.questphase
  street_stories\<район>\…            заказы, также общие фазы фиксера и DLC
  minor_activities\<район>\…          активности района и templates
  fixers\, mini_world_stories\, combat_events\, dynamic_events\, city_scenes\
  community\, community_spawners\, quest_blocks\, scenes\, workspots\
  fast_travel\, metro\, vendors\, district_definitions\, police_system\
ep1\quest\
  ep1.gamedef, ep1_standalone.gamedef, ep1.quest, ep1_standalone.quest, ep1.questphase
  ep1_requirements.questphase, ep1_persistent_content.questphase, ep1_bugfixing.questphase
  main_quests\q301…q307\              ep1_main_quests.questphase в родителе
  minor_quests\mq3…\, mini_world_story\, holocalls\
  text_messages\                     отдельные фазы Alex и Songbird
  bugfixing\, primary_characters\, secondary_characters\, tertiary_characters\
ep1\openworld\
  ep1_open_world.quest, ep1_open_world.questphase, ep1_open_world.gamedef
  street_stories\sts_ep1_…\           ep1_street_stories.questphase в родителе
  fixers\mr_hands\, minor_activities\, mini_world_stories\, world_stories\
  sandbox_activities\                 в т. ч. air_drop_assets и courier_spot
  dynamic_events\, world_encounters\, community\, scene\, vendors\
  combat_zone_gate\, combat_zone_convoy\, combat_zone_drones\
```

**Точки входа.** `gsmGameDefinition.mainQuests[].questFile` перечисляет корни сессии. В базовом `cyberpunk2077.gamedef` это `base\quest\cyberpunk2077.quest`. В `ep1.gamedef` к базовому корню добавляются `ep1\quest\ep1.quest` и `ep1_preorder.quest` из того же каталога. В `ep1_standalone.gamedef` список другой: `ep1_standalone.quest`, `cyberpunk2077_ep1_standalone.quest` и `ep1_preorder.quest`. Учитывай режим старта при выборе общего родителя. Файлы для автономного теста миссии часто имеют такой же префикс, как игровая фаза.

**От общего к частному.** У `base\quest\main_quests\prologue\q001` лежат одноимённые `.gamedef`, `.quest` и `.questphase`. Соседние `phases`, `scenes`, `prefabs`, `communities`, `entities` и `workspots` содержат логику, постановку и её мировые зависимости. Для локального изменения ищи входящий `phaseResource` или `sceneFile` и конкретное действие; префикс `q001` встречается на всех этих уровнях. Аналогично `base\open_world\phases\open_world_content.questphase` содержит ссылки на агрегаторы `street_stories`, `minor_activities`, `fixers` и другие ветки.

**За пределами этих корней.** Базовый и EP1 журналы находятся по `base\journal\cooked_journal.journal` и `ep1\journal\cooked_journal.journal`. Позиции объектов и триггеры ищи по ссылкам в префабах и секторах мира. `gameJournalPath.realPath` — путь по ID записей журнала с `/`. `NodeRef` адресует узел мира. Ни то ни другое не является путём к файлу сцены. Уникальные имена модовых ресурсов лучше сохранять между релизами: на пути и ID могут ссылаться уже записанные состояния.
