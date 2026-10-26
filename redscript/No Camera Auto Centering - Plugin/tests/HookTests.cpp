#include "../src/Main.cpp"
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iterator>
#include <vector>

namespace
{
    std::array<uint8_t, 0x700> owner{};
    unsigned originalCalls = 0;
    uint64_t receivedGroup = 0;
    uintptr_t receivedUnused = 0;
    bool receivedDeferred = false;
    void Require(bool aValue, const char* aMessage)
    {
        if (!aValue) { std::fprintf(stderr, "FAILED: %s\n", aMessage); std::exit(1); }
    }
    void SetThreshold(float aValue) { std::memcpy(owner.data() + thresholdOffset, &aValue, sizeof(aValue)); }
    float GetThreshold() { float value; std::memcpy(&value, owner.data() + thresholdOffset, sizeof(value)); return value; }
    void FakeRead(void* aOwner) { Require(aOwner == owner.data(), "owner forwarded"); ++originalCalls; SetThreshold(1.0f); }
    void FakeChanged(void* aOwner, uint64_t aGroup, uint64_t, uintptr_t aUnused, bool aDeferred)
    {
        Require(aOwner == owner.data(), "callback owner forwarded");
        ++originalCalls; receivedGroup = aGroup; receivedUnused = aUnused; receivedDeferred = aDeferred;
        SetThreshold(2.0f);
    }
    void Log(RED4ext::v1::PluginHandle, const char*, ...) {}
}

int main(int argc, char** argv)
{
    RED4ext::v1::Logger logger{};
    logger.InfoF = &Log; logger.WarnF = &Log;
    RED4ext::v1::Sdk fakeSdk{}; fakeSdk.logger = &logger; sdk = &fakeSdk;
    readSettings = &FakeRead; settingsChanged = &FakeChanged;
    owner.fill(0xA5); active = true;
    OnReadSettings(owner.data());
    Require(originalCalls == 1 && GetThreshold() == testThreshold, "original read followed by override");
    for (size_t i = 0; i < owner.size(); ++i)
        if (i < thresholdOffset || i >= thresholdOffset + sizeof(float)) Require(owner[i] == 0xA5, "unrelated memory unchanged");
    OnSettingsChanged(owner.data(), 0x123456789ull, timerName, 0xABCDEF123ull, false);
    Require(originalCalls == 2 && receivedGroup == 0x123456789ull && receivedUnused == 0xABCDEF123ull && !receivedDeferred, "callback arguments forwarded");
    Require(GetThreshold() == testThreshold, "timer change reapplies override");
    OnSettingsChanged(owner.data(), 1, timerName + 1, 2, false);
    Require(GetThreshold() == 2.0f, "unrelated setting not overridden");
    OnSettingsChanged(owner.data(), 1, timerName, 2, true);
    Require(receivedDeferred && GetThreshold() == 2.0f, "deferred callback not overridden");
    active = false; OnReadSettings(owner.data());
    Require(GetThreshold() == 1.0f, "inactive hook preserves original");
    active = true; SetThreshold(-1.0f); ApplyThreshold(owner.data(), "test");
    Require(GetThreshold() == -1.0f, "invalid threshold rejected");
    std::array<uint8_t, 4096> invalidImage{};
    Require(!ValidateImage(invalidImage.data()), "invalid PE rejected");
    Require(argc == 2, "provide the supported EXE path for read-only validation");
    std::ifstream stream(argv[1], std::ios::binary);
    Require(stream.good(), "EXE opened read-only");
    std::vector<uint8_t> file((std::istreambuf_iterator<char>(stream)), std::istreambuf_iterator<char>());
    Require(file.size() > 4096, "EXE headers available");
    const auto dos = reinterpret_cast<const IMAGE_DOS_HEADER*>(file.data());
    const auto nt = reinterpret_cast<const IMAGE_NT_HEADERS64*>(file.data() + dos->e_lfanew);
    std::vector<uint8_t> mapped(nt->OptionalHeader.SizeOfImage);
    std::memcpy(mapped.data(), file.data(), nt->OptionalHeader.SizeOfHeaders);
    auto section = IMAGE_FIRST_SECTION(nt);
    for (unsigned i = 0; i < nt->FileHeader.NumberOfSections; ++i)
    {
        Require(section[i].PointerToRawData + section[i].SizeOfRawData <= file.size(), "section source bounds");
        Require(section[i].VirtualAddress + section[i].SizeOfRawData <= mapped.size(), "section destination bounds");
        std::memcpy(mapped.data() + section[i].VirtualAddress, file.data() + section[i].PointerToRawData, section[i].SizeOfRawData);
    }
    Require(ValidateImage(mapped.data()), "supported image accepted");
    mapped[readerRva] ^= 1;
    Require(!ValidateImage(mapped.data()), "modified reader rejected");
    mapped[readerRva] ^= 1; mapped[changedRva] ^= 1;
    Require(!ValidateImage(mapped.data()), "modified callback rejected");
    std::puts("PASS: supported EXE accepted; modified hook targets rejected (read-only PE fixture).");
    std::puts("PASS: original calls, ABI forwarding, write isolation, settings filter, inactive mode, invalid input.");
}
