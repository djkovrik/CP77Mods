local VERSION = 2
local PATH = "persistency.json"
local names = { "NewTracker", "NewMinimap", "NewWanted", "NewQuestNotifications", "NewItemNotifications", "NewVehicleSummon", "NewWeaponRoster", "NewCrouchIndicator", "NewDpad", "NewHealthBar", "NewStaminaBar", "NewInputHint", "NewCarHud", "NewAutoDrive", "NewCrystalCoat", "NewVehicleRadio", "NewVehicleHotkey", "NewPhoneHotkey", "NewPhoneAvatar", "NewPhoneControl", "NewBossHealthbar", "NewDialogChoices", "NewDialogSubtitles", "NewProgressBar", "NewCompass", "NewFpsCounter" }
local state

local function report(message)
    print("[HUDitor] " .. tostring(message))
end

local function finite(value)
    return type(value) == "number" and value == value and value >= -3.402823466e38 and value <= 3.402823466e38
end

local function axis(value, fallback, zoom)
    if not finite(value) then return fallback end
    if zoom then return math.max(0.1, math.min(5, value)) end
    return value
end

local function normalize(data)
    local result = { version = VERSION, slots = {} }
    local slots = type(data) == "table" and data.version == VERSION and type(data.slots) == "table" and data.slots or {}
    for _, name in ipairs(names) do
        local entry = type(slots[name]) == "table" and slots[name] or {}
        local translation = type(entry.translation) == "table" and entry.translation or {}
        local zoom = type(entry.zoom) == "table" and entry.zoom or {}
        result.slots[name] = {
            translation = { X = axis(translation.X, 0, false), Y = axis(translation.Y, 0, false) },
            zoom = { X = axis(zoom.X, 1, true), Y = axis(zoom.Y, 1, true) }
        }
    end
    return result
end

local function read(path)
    local ok, file, err = pcall(io.open, path, "r")
    if not ok or not file then return nil, tostring(err or file) end
    local readOK, contents = pcall(file.read, file, "*a")
    local closeOK, closed, closeError = pcall(file.close, file)
    if not readOK or type(contents) ~= "string" then return nil, tostring(contents) end
    if not closeOK or not closed then return nil, tostring(closeError or closed) end
    local decoded, data = pcall(json.decode, contents)
    if not decoded or type(data) ~= "table" then return nil, tostring(data) end
    return data
end

local function exists(path)
    local ok, file = pcall(io.open, path, "r")
    if not ok or not file then return false end
    local closeOK, closed = pcall(file.close, file)
    return closeOK and closed ~= nil
end

local function operation(fn, ...)
    local ok, result, err = pcall(fn, ...)
    if not ok or not result then return false, tostring(err or result) end
    return true
end

local function save()
    local encoded, contents = pcall(json.encode, state)
    if not encoded or type(contents) ~= "string" then return false, "JSON encode failed: " .. tostring(contents) end
    local temporary, backup = PATH .. ".tmp", PATH .. ".bak"
    local opened, file, err = pcall(io.open, temporary, "w")
    if not opened or not file then return false, "Cannot open temporary file: " .. tostring(err or file) end
    local wrote, writeError = operation(file.write, file, contents)
    local flushed, flushError = operation(file.flush, file)
    local closed, closeError = operation(file.close, file)
    if not wrote or not flushed or not closed then
        return false, "Temporary write failed: " .. tostring(writeError or flushError or closeError)
    end
    local replaced, replaceError = operation(os.rename, temporary, PATH)
    if replaced then return true end
    if not exists(PATH) then return false, "Cannot install temporary file: " .. tostring(replaceError) end
    if exists(backup) then
        local removed, removeError = operation(os.remove, backup)
        if not removed then return false, "Cannot clear old backup: " .. tostring(removeError) end
    end
    local backedUp, backupError = operation(os.rename, PATH, backup)
    if not backedUp then return false, "Cannot preserve current file: " .. tostring(backupError) end
    replaced, replaceError = operation(os.rename, temporary, PATH)
    if not replaced then
        local restored, restoreError = operation(os.rename, backup, PATH)
        return false, "Replacement failed: " .. tostring(replaceError) .. (restored and "; original restored" or "; original remains in .bak: " .. tostring(restoreError))
    end
    return true
end

registerForEvent("onInit", function()
    local data, err = read(PATH)
    if not data and not exists(PATH) then data = read(PATH .. ".bak") end
    state = normalize(data)
    if not data then report("Using default layout: " .. tostring(err)) end
    if data and data.version ~= VERSION then report("Old/unsupported layout ignored; reset and configure HUD again.") end

    Observe("HUDitorCustomSlot", "LoadPersistedState", function(self)
        local entry = state.slots[Game.NameToString(self:GetName())]
        if entry then self:SetPersistedState(entry.translation.X, entry.translation.Y, entry.zoom.X, entry.zoom.Y) end
    end)
    Observe("HUDitorCustomSlot", "UpdatePersistedState", function(self, translation, zoom)
        local name = Game.NameToString(self:GetName())
        if not state.slots[name] then return end
        state.slots[name] = {
            translation = { X = axis(translation.X, 0, false), Y = axis(translation.Y, 0, false) },
            zoom = { X = axis(zoom.X, 1, true), Y = axis(zoom.Y, 1, true) }
        }
    end)
    Observe("HUDitorInputListener", "PersistHUDWidgetsState", function()
        local ok, err = save()
        if not ok then report("Layout not saved; in-memory changes retained. " .. tostring(err)) end
    end)
end)
