public class DialogOption {

  public let id: Int32;

  public let index: Int32;
  
  public let hub: Int32;

  public let choice: ListChoiceData;

  public let valid: Bool;

  public let selected: Bool;

  public static func Create(id: Int32, index: Int32, hub: Int32, choice: ListChoiceData, valid: Bool, selected: Bool) -> ref<DialogOption> {
    let result: ref<DialogOption> = new DialogOption();
    result.id = id;
    result.index = index;
    result.hub = hub;
    result.choice = choice;
    result.valid = valid;
    result.selected = selected;
    return result;
  }

  public static func Empty() -> ref<DialogOption> {
    let result: ref<DialogOption> = new DialogOption();
    result.id = -1;
    result.hub = -1;
    result.valid = true;
    return result;
  }

  public func AsString() -> String {
    if this.IsNotEmpty() {
      return this.choice.localizedName + ", global id:" + this.id + ", index:" + this.index + ", hub:" + this.hub + ", selected:" + this.selected + ", valid:" + this.valid;
    } else {
      return "EMPTY";
    };
  }

  public func IsEmpty() -> Bool {
    return this.id == -1;
  }

  public func IsNotEmpty() -> Bool {
    return this.id != -1;
  }

  public func IsValid() -> Bool {
    return this.valid;
  }

  public func IsNotValid() -> Bool {
    return !this.valid;
  }
}

public class DialogTree {

  private let populated: Bool;

  private let invalid: Bool;

  private let hubs: array<ListChoiceHubData>;

  private let hubsIds: array<Int32>;

  private let hubsIdsAvailable: array<Int32>;

  private let hubsIdsUnavailable: array<Int32>;

  private let lastGlobalId: Int32;

  private let currSelectedIndex: Int32;

  private let currSelectedHub: Int32;

  private let prevTree: array<ref<DialogOption>>;

  private let currTree: array<ref<DialogOption>>;

  public func Init() -> Void {
    this.lastGlobalId = 0;
    this.currSelectedIndex = -1;
    this.currSelectedHub = -1;
  }

  public func Rebuild(hubs: array<ListChoiceHubData>) -> Void {
    let newTree: array<ref<DialogOption>>;
    let singleHubData: ListChoiceHubData;
    let singleChoice: ListChoiceData;
    let hubId: Int32;
    let i: Int32 = 0;
    let j: Int32;
    let isValid: Bool;
    let isSelected: Bool;
    let isHubAvailable: Bool;
    let option: ref<DialogOption>;
    let globalId: Int32 = 0;

    ArrayClear(this.hubs);
    ArrayClear(this.hubsIds);
    ArrayClear(this.hubsIdsAvailable);
    ArrayClear(this.hubsIdsUnavailable);

    this.invalid = false;
    this.hubs = hubs;
    this.populated = ArraySize(hubs) > 0;
    while i < ArraySize(this.hubs) {
      singleHubData = this.hubs[i];
      hubId = singleHubData.id;
      ArrayPush(this.hubsIds, hubId);
      isHubAvailable = this.IsHubAvailable(singleHubData.choices);
     
      if isHubAvailable {
        ArrayPush(this.hubsIdsAvailable, hubId);
      } else {
        ArrayPush(this.hubsIdsUnavailable, hubId);
      };

      j = 0;
      while j < ArraySize(singleHubData.choices) {
        singleChoice = singleHubData.choices[j];
        isValid = this.IsChoiceAvailable(singleChoice);
        isSelected = singleHubData.id == this.currSelectedHub && this.currSelectedIndex == j;
        option = DialogOption.Create(globalId, j, singleHubData.id, singleChoice, isValid, isSelected);
        ArrayPush(newTree, option);

        j += 1;
        globalId += 1;
      };
      i += 1;
    };

    if ArraySize(this.hubsIdsAvailable) == 0 && ArraySize(this.hubsIdsUnavailable) != 0 {
      this.invalid = true;
    };

    this.lastGlobalId = globalId - 1;
    this.prevTree = this.currTree;
    this.currTree = newTree;
  }

  public func IsStateInvalid() -> Bool {
    return this.populated && this.invalid;
  }

  public func SetCurrentSelectedIndex(index: Int32) -> Void {
    this.currSelectedIndex = index;
  }

  public func SetCurrentSelectedHub(index: Int32) -> Void {
    this.currSelectedHub = index;
  }

  public func IsHubOnTop(hubId: Int32) -> Bool {
    if ArraySize(this.hubsIds) == 0 {
      return false;
    };

    return this.hubsIds[0] == hubId;
  }

  public static func HasBlockedLifepath(argList: array<ref<InteractionChoiceCaptionPart>>) -> Bool {
    let currBluelineHolder: wref<InteractionChoiceCaptionBluelinePart>;
    let currBlueLinePart: wref<LifePathBluelinePart>;
    let currType: gamedataChoiceCaptionPartType;
    let i: Int32 = 0;
    while i < ArraySize(argList) {
      currType = argList[i].GetType();
      if Equals(currType, gamedataChoiceCaptionPartType.Blueline) {
        currBluelineHolder = argList[i] as InteractionChoiceCaptionBluelinePart;
        currBlueLinePart = currBluelineHolder.blueline.parts[0] as LifePathBluelinePart;
        if IsDefined(currBlueLinePart) {
          return currBlueLinePart.additionalData;
        };
      };
      i = i + 1;
    };

    return false;
  }

  public func GetCurrentOption() -> ref<DialogOption> {
    return this.GetSelectedOption(this.currTree);
  }

  public func GetPreviousOption() -> ref<DialogOption> {
    return this.GetSelectedOption(this.prevTree);
  }

  public func IsSelectedItemNotAvailable() -> Bool {
    let current: ref<DialogOption> = this.GetCurrentOption();
    return !current.valid;
  }

  public func GetNextAvailableOption() -> ref<DialogOption> {
    let prevOption: ref<DialogOption> = this.GetPreviousOption();
    let currOption: ref<DialogOption> = this.GetCurrentOption();

    if prevOption.id == currOption.id {
      return DialogOption.Empty();
    };

    // Find direction
    let lastId: Int32 = this.lastGlobalId;
    let movesDown: Bool = false;
    if prevOption.id == 0 && currOption.id == lastId {
      movesDown = false;
    } else {
      if prevOption.id == lastId && currOption.id == 0 {
        movesDown = true;
      } else {
        if prevOption.IsNotEmpty() {
          movesDown = prevOption.id < currOption.id;
        } else {
          movesDown = true;
        };
      };
    };

    let option: ref<DialogOption>;
    let startedFrom: Int32 = currOption.id;
    let i: Int32 = this.GetNextIndexFor(startedFrom, movesDown);
    while i != startedFrom {
      option = this.currTree[i];
      if option.valid {
        return option;
      };
      i = this.GetNextIndexFor(i, movesDown);
    };

    return DialogOption.Empty();
  }

  private func GetSelectedOption(options: array<ref<DialogOption>>) -> ref<DialogOption> {
    let i: Int32 = 0;
    while i < ArraySize(options) {
      if options[i].selected {
        return options[i];
      };
      i += 1;
    };
    return DialogOption.Empty();
  }

  private func GetNextIndexFor(index: Int32, movesDown: Bool) -> Int32 {
    let i: Int32 = index;
    if movesDown { i += 1; } else { i -= 1; };
    if i > this.lastGlobalId { i = 0; };
    if i < 0 { i = this.lastGlobalId; };
    return i;
  }

  private func IsChoiceAvailable(data: ListChoiceData) -> Bool {
    return NotEquals(DialogTree.HasBlockedLifepath(data.captionParts.parts), true);
  }

  private func IsHubAvailable(choices: array<ListChoiceData>) -> Bool {
    let choiceData: ListChoiceData;
    let hasAvailableChoices: Bool = false;
    let i: Int32 = 0;
    while i < ArraySize(choices) {
      choiceData = choices[i];
      if !hasAvailableChoices && this.IsChoiceAvailable(choiceData) {
        hasAvailableChoices = true;
      };
      i += 1;
    };
    return hasAvailableChoices;
  }

  // public func Print() -> Void {
  //   let i: Int32 = 0;
  //   if this.populated {
  //     LLL("Previous tree:");
  //     while i < ArraySize(this.prevTree) {
  //       LLL(s" - \(this.prevTree[i].AsString())");
  //       i += 1;
  //     };
  //     i = 0;
  //     LLL("Current tree:");
  //     while i < ArraySize(this.currTree) {
  //       LLL(s" - \(this.currTree[i].AsString())");
  //       i += 1;
  //     };
  //   };
  //   LLL("--------------------------");
  // }
}

// private static func LLL(str: String) -> Void {
//   LogChannel(n"DEBUG", s"Lifepaths: \(str)");
// }
