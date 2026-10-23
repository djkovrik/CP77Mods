// Store custom note for the last created save
public native func AddCustomNoteToNewestSave(note: String) -> Void
// Get custom note by save index
public native func GetNoteForSaveIndex(index: Int32) -> String
