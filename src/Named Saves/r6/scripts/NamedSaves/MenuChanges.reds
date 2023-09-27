module NamedSaves.UI
import Codeware.UI.*
import NamedSaves.Utils.*

@addField(SaveGameMenuGameController)
private let m_nameInput: wref<HubTextInput>;

@wrapMethod(SaveGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  // Insert input
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let outerContainer: ref<inkCompoundWidget> = root.GetWidget(n"holder") as inkCompoundWidget;

  let container = new inkVerticalPanel();
  container.SetName(n"InputContainer");
  container.SetFitToContent(true);
  container.SetTranslation(new Vector2(730.0, 140.0));
  container.SetHAlign(inkEHorizontalAlign.Left);
  container.SetVAlign(inkEVerticalAlign.Center);
  container.SetAnchor(inkEAnchor.CenterLeft );
  container.SetAnchorPoint(new Vector2(1.0, 0.0));
  container.Reparent(outerContainer, 1);

  let input = HubTextInput.Create(); 
  input = HubTextInput.Create();
  input.SetName(n"InputText");
  input.SetMaxLength(64);
  input.Reparent(container);
  this.m_nameInput = input;
}

// Reset input focus on elsewhere click - copy-pasted from psiberx samples ^^
@wrapMethod(SaveGameMenuGameController)
protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.IsAction(n"mouse_left") {
    if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
      this.RequestSetFocus(null);
    };
  };
}

// Save input text on save completion event
@wrapMethod(SaveGameMenuGameController)
protected cb func OnSavingComplete(success: Bool, locks: array<gameSaveLock>) -> Bool {
  let inputText: String = this.m_nameInput.GetText();
  if NotEquals(inputText, "") {
    AddCustomNoteToNewestSave(inputText);
    this.m_nameInput.SetText("");
  };

  wrappedMethod(success, locks);
}

@addField(LoadListItem)
private let m_customNote: wref<inkText>;

@wrapMethod(LoadListItem)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidget(n"Not_Empty_Slot/inkHorizontalPanelWidget3") as inkCompoundWidget;

  let newText = new inkText();
  newText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  newText.SetName(n"NamedSaveLabel");
  newText.SetFontStyle(n"Regular");
  newText.SetFontSize(38);
  newText.SetLetterCase(textLetterCase.OriginalCase);
  newText.SetFitToContent(true);
  newText.SetHAlign(inkEHorizontalAlign.Fill);
  newText.SetVAlign(inkEVerticalAlign.Fill);
  newText.SetAnchor(inkEAnchor.BottomRight);
  newText.SetMargin(new inkMargin(20.0, 0.0, 50.0, 0.0));
  newText.SetAnchorPoint(new Vector2(1.0, 1.0));
  newText.SetOpacity(0.6);
  newText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  newText.BindProperty(n"tintColor", n"MainColors.Green");
  newText.Reparent(container);
  this.m_customNote = newText;
  container.SetChildOrder(inkEChildOrder.Backward);
}

// Read custom notes by save index
@wrapMethod(LoadListItem)
public final func SetMetadata(metadata: ref<SaveMetadataInfo>, opt isEp1Enabled: Bool) -> Void {
  wrappedMethod(metadata, isEp1Enabled);

  let index: Int32 = GetSaveIndexFromInternalName(metadata.internalName);
  let note: String = GetNoteForSaveIndex(index);
  if NotEquals(index, -1) && NotEquals(note, "") {
    this.m_customNote.SetVisible(true);
    this.m_customNote.SetText(note);
  } else {
    this.m_customNote.SetVisible(false);
  };
}
