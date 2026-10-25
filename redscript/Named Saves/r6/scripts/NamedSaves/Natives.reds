// Store custom note for the last created save
public native func AddCustomNoteToNewestSave(note: String) -> Void
public native func TryAddCustomNoteToNewestSave(note: String) -> Bool
// Get custom note by save index
public native func GetNoteForSaveIndex(index: Int32) -> String
