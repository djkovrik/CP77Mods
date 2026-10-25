#include <RED4ext/RED4ext.hpp>
#include "CustomNotesManager.h"
#include <limits>
#include <new>

namespace
{
    CustomNotesManager* manager = nullptr;
    const RED4ext::v1::Sdk* sdk = nullptr;
    RED4ext::v1::PluginHandle pluginHandle{};

    void ReportError(const char* aOperation, DWORD aError) noexcept
    {
        try
        {
            if (sdk && sdk->logger && sdk->logger->ErrorF)
                sdk->logger->ErrorF(pluginHandle, "%s failed (0x%08lX)", aOperation, aError);
        }
        catch (...) {}
    }

    bool StoreCustomNote(RED4ext::CStackFrame* aFrame) noexcept
    {
        try
        {
            RED4ext::CString note;
            RED4ext::GetParameter(aFrame, &note);
            aFrame->code++;
            if (!manager) { ReportError("note manager unavailable", ERROR_NOT_READY); return false; }
            return manager->StoreCustomNote(std::string_view(note.c_str(), note.Length()));
        }
        catch (const std::bad_alloc&) { ReportError("store note API", ERROR_NOT_ENOUGH_MEMORY); }
        catch (...) { ReportError("store note API: unexpected exception", ERROR_UNHANDLED_EXCEPTION); }
        return false;
    }
}

void AddCustomNoteToNewestSave(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4) noexcept
{
    StoreCustomNote(aFrame);
}

void TryAddCustomNoteToNewestSave(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, bool* aOut, int64_t a4) noexcept
{
    const bool result = StoreCustomNote(aFrame);
    if (aOut) *aOut = result;
}

void GetNoteForSaveIndex(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::CString* aOut, int64_t a4) noexcept
{
    try
    {
        if (aOut) *aOut = RED4ext::CString();
        INT32 index;
        RED4ext::GetParameter(aFrame, &index);
        aFrame->code++;
        if (!manager) { ReportError("note manager unavailable", ERROR_NOT_READY); return; }
        const auto note = manager->GetCustomNoteByIndex(index);
        if (note.size() > (std::numeric_limits<uint32_t>::max)())
        {
            ReportError("note exceeds game String size", ERROR_FILE_TOO_LARGE);
            return;
        }
        if (aOut) *aOut = RED4ext::CString(note);
    }
    catch (const std::bad_alloc&) { ReportError("read note API", ERROR_NOT_ENOUGH_MEMORY); }
    catch (...) { ReportError("read note API: unexpected exception", ERROR_UNHANDLED_EXCEPTION); }
}

RED4EXT_C_EXPORT void RED4EXT_CALL RegisterTypes() {}

RED4EXT_C_EXPORT void RED4EXT_CALL PostRegisterTypes()
{
    try
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
            auto func = RED4ext::CGlobalFunction::Create("TryAddCustomNoteToNewestSave", "TryAddCustomNoteToNewestSave", &TryAddCustomNoteToNewestSave);
            func->flags = flags;
            func->AddParam("String", "note");
            func->SetReturnType("Bool");
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
    catch (const std::bad_alloc&) { ReportError("register note API", ERROR_NOT_ENOUGH_MEMORY); }
    catch (...) { ReportError("register note API: unexpected exception", ERROR_UNHANDLED_EXCEPTION); }
}

RED4EXT_C_EXPORT bool RED4EXT_CALL Main(RED4ext::v1::PluginHandle aHandle, RED4ext::v1::EMainReason aReason, const RED4ext::v1::Sdk* aSdk)
{
    try
    {
        switch (aReason)
        {
            case RED4ext::v1::EMainReason::Load:
            {
                sdk = aSdk;
                pluginHandle = aHandle;
                manager = new CustomNotesManager(&ReportError);
                auto rtti = RED4ext::CRTTISystem::Get();
                rtti->AddRegisterCallback(RegisterTypes);
                rtti->AddPostRegisterCallback(PostRegisterTypes);
                break;
            }
            case RED4ext::v1::EMainReason::Unload:
            {
                delete manager;
                manager = nullptr;
                sdk = nullptr;
                break;
            }
        }
        return true;
    }
    catch (const std::bad_alloc&) { ReportError("plugin lifecycle", ERROR_NOT_ENOUGH_MEMORY); }
    catch (...) { ReportError("plugin lifecycle: unexpected exception", ERROR_UNHANDLED_EXCEPTION); }
    delete manager;
    manager = nullptr;
    return false;
}

RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::v1::PluginInfo* aInfo)
{
    aInfo->name = L"NamedSaves";
    aInfo->author = L"DJ_Kovrik";
    aInfo->version = RED4EXT_V1_SEMVER(2, 7, 0);
    aInfo->runtime = RED4EXT_V1_RUNTIME_VERSION_INDEPENDENT;
    aInfo->sdk = RED4EXT_V1_SDK_VERSION_CURRENT;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports()
{
    return RED4EXT_API_VERSION_1;
}
