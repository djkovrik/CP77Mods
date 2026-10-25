#include "CustomNotesManager.h"
#include <ShlObj.h>
#include <algorithm>
#include <atomic>
#include <limits>
#include <memory>
#include <new>
#include <utility>

namespace
{
    struct CoTaskMemDeleter
    {
        void operator()(wchar_t* value) const noexcept { CoTaskMemFree(value); }
    };

    class NoteFile
    {
        public:
            NoteFile(HANDLE value, const NoteFileOperations& operations) noexcept
                : value(value), operations(operations) {}
            NoteFile(const NoteFile&) = delete;
            NoteFile& operator=(const NoteFile&) = delete;
            ~NoteFile() { if (value != INVALID_HANDLE_VALUE) operations.close(value); }
            bool Close() noexcept
            {
                const auto handle = std::exchange(value, INVALID_HANDLE_VALUE);
                return operations.close(handle) != FALSE;
            }
            HANDLE Get() const noexcept { return value; }
        private:
            HANDLE value;
            const NoteFileOperations& operations;
    };

    struct TemporaryNote
    {
        fs::path path;
        CustomNotesManager::ErrorLogger logger;
        bool committed = false;
        ~TemporaryNote()
        {
            if (!committed && !DeleteFileW(path.c_str()))
            {
                const auto error = GetLastError();
                if (logger && error != ERROR_FILE_NOT_FOUND && error != ERROR_PATH_NOT_FOUND)
                    logger("remove temporary note", error);
            }
        }
    };

    bool GetSaveIndex(const fs::path& path, std::int32_t& index)
    {
        const auto filename = path.filename();
        const std::wstring_view name = filename.native();
        constexpr std::wstring_view prefix = L"ManualSave-";
        if (!name.starts_with(prefix) || name.size() == prefix.size()) return false;
        const auto digits = name.substr(prefix.size());
        if (digits.size() > 1 && digits.front() == L'0') return false;
        std::int32_t result = 0;
        for (const auto digit : digits)
        {
            if (digit < L'0' || digit > L'9') return false;
            const auto value = digit - L'0';
            if (result > ((std::numeric_limits<std::int32_t>::max)() - value) / 10) return false;
            result = result * 10 + value;
        }
        index = result;
        return true;
    }

    std::atomic<std::uint64_t> temporaryId{0};
}

CustomNotesManager::CustomNotesManager(ErrorLogger logger, NoteFileOperations operations) noexcept
    : logger(logger), operations(operations) {}

CustomNotesManager::CustomNotesManager(fs::path root, ErrorLogger logger, NoteFileOperations operations)
    : savedGamesPath(std::move(root)), logger(logger), operations(operations) {}

void CustomNotesManager::Report(const char* operation, DWORD error) const noexcept
{
    if (logger) logger(operation, error);
}

bool CustomNotesManager::StoreCustomNote(std::string_view note) noexcept
{
    try
    {
        const std::lock_guard lock(mutex);
        if (!EnsureSavesPath()) return false;
        const auto index = GetLastSaveIndex();
        if (index < 0 || !WriteNote(GetFilePathByIndex(index), note)) return false;
        try { notes.insert_or_assign(index, std::string(note)); }
        catch (...)
        {
            // The file is committed: discard an old cache entry rather than report a false write failure.
            notes.erase(index);
            Report("cache committed note", ERROR_NOT_ENOUGH_MEMORY);
        }
        return true;
    }
    catch (const std::bad_alloc&) { Report("store note", ERROR_NOT_ENOUGH_MEMORY); }
    catch (...) { Report("store note: unexpected exception", ERROR_UNHANDLED_EXCEPTION); }
    return false;
}

std::string CustomNotesManager::GetCustomNoteByIndex(std::int32_t index) noexcept
{
    if (index < 0) return {};
    try
    {
        const std::lock_guard lock(mutex);
        if (const auto it = notes.find(index); it != notes.end()) return it->second;
        if (!EnsureSavesPath()) return {};
        const auto path = GetFilePathByIndex(index);
        const auto handle = operations.create(path.c_str(), GENERIC_READ,
            FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
        if (handle == INVALID_HANDLE_VALUE)
        {
            const auto error = GetLastError();
            if (error != ERROR_FILE_NOT_FOUND && error != ERROR_PATH_NOT_FOUND) Report("open note", error);
            return {};
        }
        NoteFile file(handle, operations);
        std::string result;
        char buffer[4096];
        while (true)
        {
            DWORD count = 0;
            if (!operations.read(file.Get(), buffer, sizeof(buffer), &count, nullptr))
            {
                Report("read note", GetLastError());
                return {};
            }
            if (count == 0) break;
            result.append(buffer, count);
        }
        if (!file.Close()) { Report("close note after read", GetLastError()); return {}; }
        try { notes.insert_or_assign(index, result); }
        catch (...) { Report("cache read note", ERROR_NOT_ENOUGH_MEMORY); }
        return result;
    }
    catch (const std::bad_alloc&) { Report("read note", ERROR_NOT_ENOUGH_MEMORY); }
    catch (...) { Report("read note: unexpected exception", ERROR_UNHANDLED_EXCEPTION); }
    return {};
}

bool CustomNotesManager::WriteNote(const fs::path& path, std::string_view note)
{
    std::error_code error;
    if (!fs::is_directory(path.parent_path(), error))
    {
        Report("note directory unavailable", error ? static_cast<DWORD>(error.value()) : ERROR_PATH_NOT_FOUND);
        return false;
    }
    fs::path temporaryPath;
    HANDLE handle = INVALID_HANDLE_VALUE;
    for (int attempt = 0; attempt < 16; ++attempt)
    {
        temporaryPath = path.parent_path() / (L".NamedSave-" + std::to_wstring(GetCurrentProcessId()) +
            L"-" + std::to_wstring(temporaryId.fetch_add(1)) + L".tmp");
        handle = operations.create(temporaryPath.c_str(), GENERIC_WRITE, 0, nullptr,
            CREATE_NEW, FILE_ATTRIBUTE_NORMAL, nullptr);
        if (handle != INVALID_HANDLE_VALUE) break;
        const auto code = GetLastError();
        if (code != ERROR_FILE_EXISTS && code != ERROR_ALREADY_EXISTS)
        {
            Report("create temporary note", code);
            return false;
        }
    }
    if (handle == INVALID_HANDLE_VALUE) { Report("temporary note name collision", ERROR_FILE_EXISTS); return false; }
    TemporaryNote temporary{std::move(temporaryPath), logger};
    NoteFile file(handle, operations);
    std::size_t offset = 0;
    while (offset < note.size())
    {
        const auto count = static_cast<DWORD>((std::min)(note.size() - offset, std::size_t{1024 * 1024}));
        DWORD written = 0;
        if (!operations.write(file.Get(), note.data() + offset, count, &written, nullptr))
        {
            Report("write temporary note", GetLastError());
            return false;
        }
        if (written == 0 || written > count) { Report("incomplete note write", ERROR_WRITE_FAULT); return false; }
        offset += written;
    }
    if (!operations.flush(file.Get())) { Report("flush temporary note", GetLastError()); return false; }
    if (!file.Close()) { Report("close temporary note", GetLastError()); return false; }
    if (!operations.replace(temporary.path.c_str(), path.c_str(), MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH))
    {
        Report("commit note", GetLastError());
        return false;
    }
    temporary.committed = true;
    return true;
}

bool CustomNotesManager::EnsureSavesPath()
{
    if (savedGamesPath.empty()) savedGamesPath = GetCurrentSavesPath();
    return !savedGamesPath.empty();
}

fs::path CustomNotesManager::GetCurrentSavesPath()
{
    PWSTR buffer = nullptr;
    const auto result = operations.resolveFolder(FOLDERID_SavedGames, 0, nullptr, &buffer);
    const std::unique_ptr<wchar_t, CoTaskMemDeleter> path(buffer);
    if (FAILED(result)) { Report("resolve Saved Games", static_cast<DWORD>(result)); return {}; }
    if (!path) { Report("resolve Saved Games: empty path", ERROR_PATH_NOT_FOUND); return {}; }
    return fs::path(path.get()) / L"CD Projekt Red" / L"Cyberpunk 2077";
}

fs::path CustomNotesManager::GetFilePathByIndex(std::int32_t index) const
{
    return savedGamesPath / (L"ManualSave-" + std::to_wstring(index)) / L"NamedSave.txt";
}

std::int32_t CustomNotesManager::GetLastSaveIndex()
{
    std::error_code error;
    fs::directory_iterator it(savedGamesPath, error), end;
    if (error) { Report("enumerate manual saves", static_cast<DWORD>(error.value())); return -1; }
    std::int32_t result = -1;
    fs::file_time_type newest{};
    bool ambiguous = false;
    while (it != end)
    {
        const auto& entry = *it;
        std::int32_t index = -1;
        if (entry.is_directory(error) && GetSaveIndex(entry.path(), index))
        {
            const auto time = entry.last_write_time(error);
            if (error) { Report("read manual save timestamp", static_cast<DWORD>(error.value())); return -1; }
            if (result < 0 || time > newest) { result = index; newest = time; ambiguous = false; }
            else if (time == newest) ambiguous = true;
        }
        if (error) { Report("inspect manual save directory", static_cast<DWORD>(error.value())); return -1; }
        it.increment(error);
        if (error) { Report("enumerate manual saves", static_cast<DWORD>(error.value())); return -1; }
    }
    if (ambiguous) { Report("ambiguous latest manual save", ERROR_INVALID_DATA); return -1; }
    if (result < 0) Report("manual save target missing", ERROR_FILE_NOT_FOUND);
    return result;
}
