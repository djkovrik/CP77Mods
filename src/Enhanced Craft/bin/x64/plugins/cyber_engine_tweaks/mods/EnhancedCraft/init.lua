local defaults = {
	CustomNamesEnabled = true,
	RandomizerEnabled = false,
	PerkToUnlockStandard = 3,
	PerkToUnlockIconics = 5,
	IconicRecipeCondition = 2,
	IconicIngredientsMultiplier = 5,
	ControllerSupportEnabled = false,
	CustomizedDamageEnabled = true,
	PerkToUnlockDamageTypes = 2,
	PerkToUnlockClothes = 2,
	IncludeJacketsFromDLC = false
}

local settings = {
	CustomNamesEnabled = true,
	RandomizerEnabled = false,
	PerkToUnlockStandard = 3,
	PerkToUnlockIconics = 5,
	IconicRecipeCondition = 2,
	IconicIngredientsMultiplier = 5,
	ControllerSupportEnabled = false,
	CustomizedDamageEnabled = true,
	PerkToUnlockDamageTypes = 2,
	PerkToUnlockClothes = 2,
	IncludeJacketsFromDLC = false
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
	
	local basicRequirements = {
		[1] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-None"),
		[2] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Craftsman"),
		[3] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Monkey"),
		[4] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Artisan")
	}
	
	local iconicRequirements = {
		[1] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-None"),
		[2] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Block"),
		[3] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Craftsman"),
		[4] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Monkey"),
		[5] = GetLocalizedTextByKey("Mod-Craft-Settings-Perk-Artisan")
	}

	local qualities = {
		[1] = GetLocalizedTextByKey("Mod-Craft-Settings-Quality-Rare"),
		[2] = GetLocalizedTextByKey("Mod-Craft-Settings-Quality-Epic"),
		[3] = GetLocalizedTextByKey("Mod-Craft-Settings-Quality-Legendary")
	}

	nativeSettings.addTab("/ecraft", "ECRAFT")
	
	nativeSettings.addSubcategory("/ecraft/damage", GetLocalizedTextByKey("Mod-Craft-UI-Damage-Type"))
	
	nativeSettings.addSwitch("/ecraft/damage", GetLocalizedTextByKey("Mod-Craft-UI-Damage-Type-Enable"), GetLocalizedTextByKey("Mod-Craft-UI-Damage-Type-Enable-Desc"), settings.CustomizedDamageEnabled, defaults.CustomizedDamageEnabled, function(state) 
		settings.CustomizedDamageEnabled = state
		SaveSettings()
	end)
	
	nativeSettings.addSelectorString("/ecraft/damage", GetLocalizedTextByKey("Mod-Craft-UI-Damage-Perk"), GetLocalizedTextByKey("Mod-Craft-UI-Damage-Perk-Desc"), basicRequirements, settings.PerkToUnlockDamageTypes, defaults.PerkToUnlockDamageTypes, function(value)
		settings.PerkToUnlockDamageTypes = value
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/ecraft/basic", GetLocalizedTextByKey("Mod-Craft-Settings-Base"))

	nativeSettings.addSelectorString("/ecraft/basic", GetLocalizedTextByKey("Mod-Craft-Settings-Basic"), GetLocalizedTextByKey("Mod-Craft-Settings-Basic-Desc"), basicRequirements, settings.PerkToUnlockStandard, defaults.PerkToUnlockStandard, function(value)
		settings.PerkToUnlockStandard = value
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/ecraft/iconic", GetLocalizedTextByKey("Mod-Craft-Settings-Iconic"))

	nativeSettings.addSelectorString("/ecraft/iconic", GetLocalizedTextByKey("Mod-Craft-Settings-Iconic-Unlock"), GetLocalizedTextByKey("Mod-Craft-Settings-Iconic-Unlock-Desc"), iconicRequirements, settings.PerkToUnlockIconics, defaults.PerkToUnlockIconics, function(value)
		settings.PerkToUnlockIconics = value
		SaveSettings()
	end)
	
	nativeSettings.addSelectorString("/ecraft/iconic", GetLocalizedTextByKey("Mod-Craft-Settings-Iconic-Condition"), GetLocalizedTextByKey("Mod-Craft-Settings-Iconic-Condition-Desc"), qualities, settings.IconicRecipeCondition, defaults.IconicRecipeCondition, function(value)
		settings.IconicRecipeCondition = value
		SaveSettings()
	end)
	
	nativeSettings.addRangeInt("/ecraft/iconic", GetLocalizedTextByKey("Mod-Craft-Iconic-Ingredients"), GetLocalizedTextByKey("Mod-Craft-Iconic-Ingredients-Desc"), 1, 25, 1, settings.IconicIngredientsMultiplier, defaults.IconicIngredientsMultiplier, function(value)
		settings.IconicIngredientsMultiplier = value
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/ecraft/clothes", GetLocalizedTextByKey("Mod-Craft-Settings-Clothes"))
	
	nativeSettings.addSelectorString("/ecraft/clothes", GetLocalizedTextByKey("Mod-Craft-UI-Damage-Perk"), GetLocalizedTextByKey("Mod-Craft-Settings-Clothes-Unlock-Desc"), basicRequirements, settings.PerkToUnlockClothes, defaults.PerkToUnlockClothes, function(value)
		settings.PerkToUnlockClothes = value
		SaveSettings()
	end)
	
	nativeSettings.addSwitch("/ecraft/clothes", GetLocalizedTextByKey("Mod-Craft-Settings-Jackets"), GetLocalizedTextByKey("Mod-Craft-Settings-Jackets-Desc"), settings.IncludeJacketsFromDLC, defaults.IncludeJacketsFromDLC, function(state)
		settings.IncludeJacketsFromDLC = state
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/ecraft/misc", GetLocalizedTextByKey("Mod-Craft-Settings-Misc"))
	
	nativeSettings.addSwitch("/ecraft/misc", GetLocalizedTextByKey("Mod-Craft-Settings-Randomizer"), GetLocalizedTextByKey("Mod-Craft-Settings-Randomizer-Desc"), settings.RandomizerEnabled, defaults.RandomizerEnabled, function(state) 
		settings.RandomizerEnabled = state
		SaveSettings()
	end)
	
	nativeSettings.addSwitch("/ecraft/misc", GetLocalizedTextByKey("Mod-Craft-Settings-Naming"), GetLocalizedTextByKey("Mod-Craft-Settings-Naming-Desc"), settings.CustomNamesEnabled, defaults.CustomNamesEnabled, function(state)
		settings.CustomNamesEnabled = state
		SaveSettings()
	end)
	
	nativeSettings.addSwitch("/ecraft/misc", GetLocalizedTextByKey("Mod-Craft-UI-Controller"), GetLocalizedTextByKey("Mod-Craft-UI-Controller-Desc"), settings.ControllerSupportEnabled, defaults.ControllerSupportEnabled, function(state) 
		settings.ControllerSupportEnabled = state
		SaveSettings()
	end)
end

registerForEvent("onInit", function()

	LoadSettings()
	SetupSettingsMenu()
	
	Override("EnhancedCraft.Config.Config", "CustomNamesEnabled;", function(_) return settings.CustomNamesEnabled end)
	Override("EnhancedCraft.Config.Config", "RandomizerEnabled;", function(_) return settings.RandomizerEnabled end)
	Override("EnhancedCraft.Config.Config", "PerkToUnlockStandard;", function(_) return settings.PerkToUnlockStandard end)
	Override("EnhancedCraft.Config.Config", "PerkToUnlockIconics;", function(_) return settings.PerkToUnlockIconics end)
	Override("EnhancedCraft.Config.Config", "IconicRecipeCondition;", function(_) return settings.IconicRecipeCondition end)
	Override("EnhancedCraft.Config.Config", "IconicIngredientsMultiplier;", function(_) return settings.IconicIngredientsMultiplier end)
	Override("EnhancedCraft.Config.Config", "ControllerSupportEnabled;", function(_) return settings.ControllerSupportEnabled end)
	Override("EnhancedCraft.Config.Config", "CustomizedDamageEnabled;", function(_) return settings.CustomizedDamageEnabled end)
	Override("EnhancedCraft.Config.Config", "PerkToUnlockDamageTypes;", function(_) return settings.PerkToUnlockDamageTypes end)
	Override("EnhancedCraft.Config.Config", "PerkToUnlockClothes;", function(_) return settings.PerkToUnlockClothes end)
	Override("EnhancedCraft.Config.Config", "IncludeJacketsFromDLC;", function(_) return settings.IncludeJacketsFromDLC end)
end)

