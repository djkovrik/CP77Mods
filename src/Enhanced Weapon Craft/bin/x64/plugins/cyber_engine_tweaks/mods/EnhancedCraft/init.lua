local defaults = {
	CustomNamesEnabled = true,
	RandomizerEnabled = true,
	PerkToUnlockStandard = 3,
	PerkToUnlockIconics = 4
}

local settings = {
	CustomNamesEnabled = true,
	RandomizerEnabled = true,
	PerkToUnlockStandard = 3,
	PerkToUnlockIconics = 4
}

function SaveSettings() 
	local validJson, contents = pcall(function() return json.encode(settings) end)
	
	if validJson and contents ~= nil then
		local updatedFile = io.open("settings.json", "w+");
		updatedFile:write(contents);
		updatedFile:close();
	end
end

function LoadSettings() 
	local file = io.open("settings.json", "r")
	if file ~= nil then
		local contents = file:read("*a")
		local validJson, persistedState = pcall(function() return json.decode(contents) end)
		
		if validJson then
			file:close();
			for key, _ in pairs(settings) do
				if persistedState[key] ~= nil then
					settings[key] = persistedState[key]
				end
			end
		end
	end
end

function SetupSettingsMenu()
	local nativeSettings = GetMod("nativeSettings")
	
	if not nativeSettings then
		print("Error: NativeSettings not found!")
		return
	end
	
	local requirements = {
		[1] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-None"),
		[2] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Craftsman"),
		[3] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Monkey"),
		[4] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Artisan")
	}

	nativeSettings.addTab("/ecraft", "ECRAFT")
	
	nativeSettings.addSubcategory("/ecraft/settings", GetLocalizedTextByKey("Mod-Craft-Settings-Core"))

	nativeSettings.addSwitch("/ecraft/settings", GetLocalizedTextByKey("Mod-Craft-Settings-Naming"), GetLocalizedTextByKey("Mod-Craft-Settings-Naming-Desc"), settings.CustomNamesEnabled, defaults.CustomNamesEnabled, function(state) settings.CustomNamesEnabled = state end)
	nativeSettings.addSwitch("/ecraft/settings", GetLocalizedTextByKey("Mod-Craft-Settings-Randomizer"), GetLocalizedTextByKey("Mod-Craft-Settings-Randomizer-Desc"), settings.RandomizerEnabled, defaults.RandomizerEnabled, function(state) settings.RandomizerEnabled = state end)

	nativeSettings.addSelectorString("/ecraft/settings", GetLocalizedTextByKey("Mod-Craft-Settings-Basic"), GetLocalizedTextByKey("Mod-Craft-Settings-Basic-Desc"), requirements, settings.PerkToUnlockStandard, defaults.PerkToUnlockStandard, function(value)
		settings.PerkToUnlockStandard = value
	end)

	nativeSettings.addSelectorString("/ecraft/settings", GetLocalizedTextByKey("Mod-Craft-Settings-Iconic"), GetLocalizedTextByKey("Mod-Craft-Settings-Iconic-Desc"), requirements, settings.PerkToUnlockIconics, defaults.PerkToUnlockIconics, function(value)
		settings.PerkToUnlockIconics = value
	end)
end

registerForEvent("onInit", function()

	LoadSettings()
	SetupSettingsMenu()
	
	Override("EnhancedCraft.Config.Config", "CustomNamesEnabled;", function(_) return settings.CustomNamesEnabled end)
	Override("EnhancedCraft.Config.Config", "RandomizerEnabled;", function(_) return settings.RandomizerEnabled end)
	Override("EnhancedCraft.Config.Config", "PerkToUnlockStandard;", function(_) return settings.PerkToUnlockStandard end)
	Override("EnhancedCraft.Config.Config", "PerkToUnlockIconics;", function(_) return settings.PerkToUnlockIconics end)
end)

registerForEvent("onShutdown", function()
    SaveSettings()
end)
