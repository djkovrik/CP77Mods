// Store custom note for the last created save
public static native func AddCustomNoteToNewestSave(note: String) -> Void
// Get custom note by save index
public static native func GetNoteForSaveIndex(index: Int32) -> String
