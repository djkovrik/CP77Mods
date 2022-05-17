#include <filesystem>
#include <fstream>
#include <iostream>
#include <map>
#include <string>

#include <windows.h>
#include <KnownFolders.h>
#include <ShlObj.h>
#include <initguid.h>

#include <RED4ext/RED4ext.hpp>
#include "CustomNotesManager.h"

CustomNotesManager::CustomNotesManager()
{
    savedGamesPath = GetCurrentSavesPath();
}

void CustomNotesManager::StoreCustomNote(RED4ext::CString note)
{
    auto index = GetLastSaveIndex();
    notes[index] = note;

    auto persistedPath = GetFilePathByIndex(index);
    std::wofstream result(persistedPath, std::ios::out | std::ios::trunc);
    if (result.is_open())
    {
        result << note.c_str();
        result.close();
    }
}

RED4ext::CString CustomNotesManager::GetCustomNoteByIndex(INT32 index)
{
    auto result = RED4ext::CString("");

    if (notes.contains(index))
    {
        result = notes[index];
        return result;
    }

    auto persistedPath = GetFilePathByIndex(index);
    std::ifstream source(persistedPath, std::ios::in);

    if (source.is_open())
    {
        std::string note;
        std::copy(std::istreambuf_iterator<char>(source), std::istreambuf_iterator<char>(), std::back_inserter(note));
        result = RED4ext::CString(note.c_str());
        notes[index] = result;
        source.close();
    }

    return result;
}

wstring CustomNotesManager::GetCurrentSavesPath()
{
    wstring resultingPath;
    WCHAR* pathBuffer;
    if (FAILED(SHGetKnownFolderPath(FOLDERID_SavedGames, 0, 0, &pathBuffer)))
        throw std::runtime_error("Unable to find saves data directory");

    resultingPath.assign(pathBuffer);
    CoTaskMemFree(pathBuffer);

    resultingPath += L"\\CD Projekt Red\\Cyberpunk 2077";

    return resultingPath;
}

wstring CustomNotesManager::GetFilePathByIndex(INT32 index)
{
    auto filePath = GetCurrentSavesPath() + L"\\ManualSave-" + std::to_wstring(index) + L"\\NamedSave.txt";
    return filePath;
}

INT32 CustomNotesManager::GetLastSaveIndex()
{
    multimap<time_t, fs::directory_entry> sortedByTime;

    for (auto& entry : fs::directory_iterator(savedGamesPath))
        if (entry.is_directory() && entry.path().filename().wstring().find(L"ManualSave") != wstring::npos)
        {
            auto time = to_time_t(entry.last_write_time());
            sortedByTime.insert(std::pair<time_t, fs::directory_entry>(time, entry));
        }

    if (sortedByTime.empty())
    {
        return -1;
    }

    auto lastPair = sortedByTime.rbegin();
    auto lastEntry = lastPair->second;
    auto pathString = lastEntry.path().filename().wstring();
    return stoi(pathString.substr(pathString.find(L"-") + 1));
}
