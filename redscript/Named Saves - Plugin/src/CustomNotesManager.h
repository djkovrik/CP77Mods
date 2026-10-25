#pragma once

#include <Windows.h>
#include <ShlObj.h>
#include <cstdint>
#include <filesystem>
#include <map>
#include <mutex>
#include <string>
#include <string_view>

namespace fs = std::filesystem;

struct NoteFileOperations
{
    decltype(&SHGetKnownFolderPath) resolveFolder = &SHGetKnownFolderPath;
    decltype(&CreateFileW) create = &CreateFileW;
    decltype(&ReadFile) read = &ReadFile;
    decltype(&WriteFile) write = &WriteFile;
    decltype(&FlushFileBuffers) flush = &FlushFileBuffers;
    decltype(&CloseHandle) close = &CloseHandle;
    decltype(&MoveFileExW) replace = &MoveFileExW;
};

class CustomNotesManager
{
    public:
        using ErrorLogger = void (*)(const char*, DWORD) noexcept;
        explicit CustomNotesManager(ErrorLogger logger = nullptr, NoteFileOperations operations = {}) noexcept;
        explicit CustomNotesManager(fs::path root, ErrorLogger logger = nullptr,
                                    NoteFileOperations operations = {});
        ~CustomNotesManager() = default;

        bool StoreCustomNote(std::string_view note) noexcept;
        std::string GetCustomNoteByIndex(std::int32_t index) noexcept;

    private:
        bool EnsureSavesPath();
        fs::path GetCurrentSavesPath();
        fs::path GetFilePathByIndex(std::int32_t index) const;
        std::int32_t GetLastSaveIndex();
        bool WriteNote(const fs::path& path, std::string_view note);
        void Report(const char* operation, DWORD error) const noexcept;

        std::map<std::int32_t, std::string> notes;
        fs::path savedGamesPath;
        ErrorLogger logger;
        NoteFileOperations operations;
        std::mutex mutex;
};
