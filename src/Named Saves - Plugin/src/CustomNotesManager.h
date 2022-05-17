#pragma once

#include <fstream>
#include <chrono>
#include <string>
#include <map>

#include <RED4ext/RED4ext.hpp>

using std::map;
using std::multimap;
using std::wstring;

using namespace std::chrono;

namespace fs = std::filesystem;

class CustomNotesManager
{
    public:
        CustomNotesManager();
        ~CustomNotesManager() = default;

        void StoreCustomNote(RED4ext::CString note);
        RED4ext::CString GetCustomNoteByIndex(INT32 index);

    private:
        wstring GetCurrentSavesPath();
        wstring GetFilePathByIndex(INT32 index);
        INT32 GetLastSaveIndex();

        map<INT32, RED4ext::CString> notes;
        wstring savedGamesPath;
};

template<typename TP>
time_t to_time_t(TP tp)
{
    auto sctp = time_point_cast<system_clock::duration>(tp - TP::clock::now() + system_clock::now());
    return system_clock::to_time_t(sctp);
}
