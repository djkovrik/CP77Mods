#include <RED4ext/RED4ext.hpp>
#include "CustomNotesManager.h"

CustomNotesManager* manager;

void AddCustomNoteToNewestSave(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
    RED4ext::CString note;
    RED4ext::GetParameter(aFrame, &note);
    aFrame->code++;

    manager->StoreCustomNote(note);
}

void GetNoteForSaveIndex(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::CString* aOut, int64_t a4)
{
    INT32 index;
    RED4ext::GetParameter(aFrame, &index);
    aFrame->code++;

    RED4ext::CString result = manager->GetCustomNoteByIndex(index);
    *aOut = result;
}

RED4EXT_C_EXPORT void RED4EXT_CALL RegisterTypes()
{
}

RED4EXT_C_EXPORT void RED4EXT_CALL PostRegisterTypes()
{
    auto rtti = RED4ext::CRTTISystem::Get();
    RED4ext::CBaseFunction::Flags flags = {.isNative = true, .isStatic = true};

    {
        auto func = RED4ext::CGlobalFunction::Create("AddCustomNoteToNewestSave", "AddCustomNoteToNewestSave", &AddCustomNoteToNewestSave);
        func->flags = flags;
        func->AddParam("String", "note");
        rtti->RegisterFunction(func);
    }

    {
        auto func = RED4ext::CGlobalFunction::Create("GetNoteForSaveIndex", "GetNoteForSaveIndex", &GetNoteForSaveIndex);
        func->flags = flags;
        func->AddParam("Int32", "index");
        func->SetReturnType("String");
        rtti->RegisterFunction(func);
    }
}

RED4EXT_C_EXPORT bool RED4EXT_CALL Main(RED4ext::PluginHandle aHandle, RED4ext::EMainReason aReason, const RED4ext::Sdk* aSdk)
{
    switch (aReason)
    {
        case RED4ext::EMainReason::Load:
        {
            RED4ext::RTTIRegistrator::Add(RegisterTypes, PostRegisterTypes);
            manager = new CustomNotesManager();
            break;
        }
        case RED4ext::EMainReason::Unload:
        {
            delete manager;
            break;
        }
    }

    return true;
}

RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::PluginInfo* aInfo)
{
    aInfo->name = L"NamedSaves";
    aInfo->author = L"DJ_Kovrik";
    aInfo->version = RED4EXT_SEMVER(1, 6, 4);
    aInfo->runtime = RED4EXT_RUNTIME_LATEST;
    aInfo->sdk = RED4EXT_SDK_0_3_0;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports()
{
    return RED4EXT_API_VERSION_LATEST;
}
