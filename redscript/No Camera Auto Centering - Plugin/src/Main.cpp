#include <RED4ext/Common.hpp>
#include <RED4ext/Api/ApiVersion.hpp>
#include <RED4ext/Api/v1/EMainReason.hpp>
#include <RED4ext/Api/v1/PluginInfo.hpp>
#include <RED4ext/Api/v1/Sdk.hpp>
#include <RED4ext/Api/v1/Version.hpp>
#include <array>
#include <atomic>
#include <cmath>
#include <cstring>

namespace
{
    constexpr uintptr_t readerRva = 0x1234B38;
    constexpr uintptr_t changedRva = 0x2B95014;
    constexpr size_t thresholdOffset = 0x5BC;
    constexpr uint64_t timerName = 0x079888E3BAE09215;
    constexpr float testThreshold = 10000.0f;
    const RED4ext::v1::Sdk* sdk = nullptr;
    RED4ext::v1::PluginHandle pluginHandle{};
    using ReadSettings = void (*)(void*);
    using SettingsChanged = void (*)(void*, uint64_t, uint64_t, uintptr_t, bool);
    ReadSettings readSettings = nullptr;
    SettingsChanged settingsChanged = nullptr;
    void* readerTarget = nullptr;
    void* changedTarget = nullptr;
    bool readerAttached = false;
    bool changedAttached = false;
    std::atomic_bool active = false;
    std::atomic_uint logCount = 0;

    uint64_t HashBytes(const uint8_t* aData, size_t aSize)
    {
        uint64_t hash = 14695981039346656037ull;
        for (size_t i = 0; i < aSize; ++i)
            hash = (hash ^ aData[i]) * 1099511628211ull;
        return hash;
    }

    bool ValidateImage(const uint8_t* aBase)
    {
        const auto dos = reinterpret_cast<const IMAGE_DOS_HEADER*>(aBase);
        if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0 || dos->e_lfanew > 0x1000)
            return false;
        const auto nt = reinterpret_cast<const IMAGE_NT_HEADERS64*>(aBase + dos->e_lfanew);
        if (nt->Signature != IMAGE_NT_SIGNATURE || nt->FileHeader.Machine != IMAGE_FILE_MACHINE_AMD64 ||
            nt->OptionalHeader.Magic != IMAGE_NT_OPTIONAL_HDR64_MAGIC ||
            nt->FileHeader.TimeDateStamp != 0x6AD55DAF || nt->OptionalHeader.SizeOfImage != 0x581B000)
            return false;
        return HashBytes(aBase + readerRva, 0x142) == 0x4B296584DFFC8DD0ull &&
               HashBytes(aBase + changedRva, 0xA3) == 0xFAE27135C07FC470ull;
    }

    void ApplyThreshold(void* aOwner, const char* aSource)
    {
        if (!active.load(std::memory_order_acquire) || !aOwner)
            return;
        auto location = static_cast<uint8_t*>(aOwner) + thresholdOffset;
        float before;
        std::memcpy(&before, location, sizeof(before));
        if (!std::isfinite(before) || before < 0.0f || before > testThreshold)
        {
            if (logCount.fetch_add(1) < 32)
                sdk->logger->WarnF(pluginHandle, "%s: unexpected cached threshold %g; skipped", aSource, before);
            return;
        }
        std::memcpy(location, &testThreshold, sizeof(testThreshold));
    }

    void OnReadSettings(void* aOwner)
    {
        readSettings(aOwner);
        ApplyThreshold(aOwner, "ReadSettings");
    }

    void OnSettingsChanged(void* aOwner, uint64_t aGroup, uint64_t aName, uintptr_t aUnused, bool aDeferred)
    {
        settingsChanged(aOwner, aGroup, aName, aUnused, aDeferred);
        if (aName == timerName && !aDeferred)
            ApplyThreshold(aOwner, "SettingsChanged");
    }

    bool RemoveHooks()
    {
        active.store(false, std::memory_order_release);
        bool success = true;
        if (changedAttached)
        {
            if (sdk->hooking->Detach(pluginHandle, changedTarget)) changedAttached = false;
            else success = false;
        }
        if (readerAttached)
        {
            if (sdk->hooking->Detach(pluginHandle, readerTarget)) readerAttached = false;
            else success = false;
        }
        return success;
    }
}

RED4EXT_C_EXPORT bool RED4EXT_CALL Main(RED4ext::v1::PluginHandle aHandle, RED4ext::v1::EMainReason aReason, const RED4ext::v1::Sdk* aSdk)
{
    if (aReason == RED4ext::v1::EMainReason::Load)
    {
        if (!aSdk || !aSdk->logger || !aSdk->hooking)
            return false;
        sdk = aSdk;
        pluginHandle = aHandle;
        const auto base = reinterpret_cast<const uint8_t*>(GetModuleHandleW(nullptr));
        if (!base || !ValidateImage(base))
        {
            sdk->logger->Error(pluginHandle, "Unsupported EXE or conflicting hook: exact 2.50 function checks failed. No hooks installed.");
            return false;
        }
        readerTarget = const_cast<uint8_t*>(base) + readerRva;
        changedTarget = const_cast<uint8_t*>(base) + changedRva;
        readerAttached = sdk->hooking->Attach(pluginHandle, readerTarget, reinterpret_cast<void*>(&OnReadSettings), reinterpret_cast<void**>(&readSettings));
        if (!readerAttached)
        {
            sdk->logger->Error(pluginHandle, "Could not attach settings reader.");
            return false;
        }
        changedAttached = sdk->hooking->Attach(pluginHandle, changedTarget, reinterpret_cast<void*>(&OnSettingsChanged), reinterpret_cast<void**>(&settingsChanged));
        if (!changedAttached)
        {
            const bool removed = RemoveHooks();
            sdk->logger->Error(pluginHandle, removed ? "Could not attach settings callback; reader hook rolled back." : "Hook rollback failed; plugin retained inactive until process exit.");
            return !removed;
        }
        active.store(true, std::memory_order_release);
        sdk->logger->Info(pluginHandle, "0.1.0: hooks installed for verified 2.50 EXE; cached TPP timeout = 10000 seconds. UserSettings unchanged.");
        return true;
    }
    if (aReason == RED4ext::v1::EMainReason::Unload)
        return !sdk || RemoveHooks();
    return true;
}

RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::v1::PluginInfo* aInfo)
{
    aInfo->name = L"NoCameraAutoCentering";
    aInfo->author = L"DJ_Kovrik";
    aInfo->version = RED4EXT_V1_SEMVER(0, 1, 0);
    aInfo->runtime = RED4ext::v1::FileVer{3, 0, 88, 46235};
    aInfo->sdk = RED4EXT_V1_SDK_VERSION_CURRENT;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports()
{
    return RED4EXT_API_VERSION_1;
}
