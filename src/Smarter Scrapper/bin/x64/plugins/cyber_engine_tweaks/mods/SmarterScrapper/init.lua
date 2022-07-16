local defaults = {
	ClothesLegendary = false,
	ClothesEpic = false,
	ClothesRare = false,
	ClothesUncommon = false,
	ClothesCommon = true,
	WeaponsLegendary = false,
	WeaponsEpic = false,
	WeaponsRare = false,
	WeaponsUncommon = false,
	WeaponsCommon = true,
	GrenadesRare = false,
	GrenadesUncommon = false,
	GrenadesCommon = false,
	BounceBackRare = false,
	BounceBackUncommon = false,
	BounceBackCommon = false,
	MaxDocEpic = false,
	MaxDocRare = false,
	MaxDocUncommon = false,
}

local settings = {
	ClothesLegendary = false,
	ClothesEpic = false,
	ClothesRare = false,
	ClothesUncommon = false,
	ClothesCommon = true,
	WeaponsKnives = false,
	WeaponsLegendary = false,
	WeaponsEpic = false,
	WeaponsRare = false,
	WeaponsUncommon = false,
	WeaponsCommon = true,
	GrenadesRare = false,
	GrenadesUncommon = false,
	GrenadesCommon = false,
	BounceBackRare = false,
	BounceBackUncommon = false,
	BounceBackCommon = false,
	MaxDocEpic = false,
	MaxDocRare = false,
	MaxDocUncommon = false,
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

	nativeSettings.addTab("/scrapper", "Scrapper")
	
	nativeSettings.addSubcategory("/scrapper/clothes", GetLocalizedText("LocKey#53753") .. " - " .. GetLocalizedText("LocKey#261"))
	nativeSettings.addSwitch("/scrapper/clothes", GetLocalizedText("LocKey#1815"), "", settings.ClothesLegendary, defaults.ClothesLegendary, function(state)
		settings.ClothesLegendary = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/clothes", GetLocalizedText("LocKey#1813"), "", settings.ClothesEpic, defaults.ClothesEpic, function(state) 
		settings.ClothesEpic = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/clothes", GetLocalizedText("LocKey#1816"), "", settings.ClothesRare, defaults.ClothesRare, function(state)
		settings.ClothesRare = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/clothes", GetLocalizedText("LocKey#1817"), "", settings.ClothesUncommon, defaults.ClothesUncommon, function(state)
		settings.ClothesUncommon = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/clothes", GetLocalizedText("LocKey#1814"), "", settings.ClothesCommon, defaults.ClothesCommon, function(state)
		settings.ClothesCommon = state
		SaveSettings()
	end)

	nativeSettings.addSubcategory("/scrapper/weapons", GetLocalizedText("LocKey#53751") .. " - " .. GetLocalizedText("LocKey#261"))
	nativeSettings.addSwitch("/scrapper/weapons", GetLocalizedText("LocKey#778"), "", settings.WeaponsKnife, defaults.WeaponsKnife, function(state)
		settings.WeaponsKnife = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/weapons", GetLocalizedText("LocKey#1815"), "", settings.WeaponsLegendary, defaults.WeaponsLegendary, function(state)
		settings.WeaponsLegendary = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/weapons", GetLocalizedText("LocKey#1813"), "", settings.WeaponsEpic, defaults.WeaponsEpic, function(state)
		settings.WeaponsEpic = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/weapons", GetLocalizedText("LocKey#1816"), "", settings.WeaponsRare, defaults.WeaponsRare, function(state)
		settings.WeaponsRare = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/weapons", GetLocalizedText("LocKey#1817"), "", settings.WeaponsUncommon, defaults.WeaponsUncommon, function(state)
		settings.WeaponsUncommon = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/weapons", GetLocalizedText("LocKey#1814"), "", settings.WeaponsCommon, defaults.WeaponsCommon, function(state)
		settings.WeaponsCommon = state
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/scrapper/grenades", GetLocalizedText("LocKey#76995") .. " - " .. GetLocalizedText("LocKey#261"))
	nativeSettings.addSwitch("/scrapper/grenades", GetLocalizedText("LocKey#1816"), "", settings.GrenadesRare, defaults.GrenadesRare, function(state)
		settings.GrenadesRare = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/grenades", GetLocalizedText("LocKey#1817"), "", settings.GrenadesUncommon, defaults.GrenadesUncommon, function(state)
		settings.GrenadesUncommon = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/grenades", GetLocalizedText("LocKey#1814"), "", settings.GrenadesCommon, defaults.GrenadesCommon, function(state)
		settings.GrenadesCommon = state
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/scrapper/consumable", GetLocalizedText("LocKey#23418") .. " - " .. GetLocalizedText("LocKey#261"))
	nativeSettings.addSwitch("/scrapper/consumable", GetLocalizedText("LocKey#35420"), "", settings.BounceBackRare, defaults.BounceBackRare, function(state)
		settings.BounceBackRare = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/consumable", GetLocalizedText("LocKey#34157"), "", settings.BounceBackUncommon, defaults.BounceBackUncommon, function(state)
		settings.BounceBackUncommon = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/consumable", GetLocalizedText("LocKey#35418"), "", settings.BounceBackCommon, defaults.BounceBackCommon, function(state)
		settings.BounceBackCommon = state
		SaveSettings()
	end)
	
	nativeSettings.addSwitch("/scrapper/consumable", GetLocalizedText("LocKey#35387"), "", settings.MaxDocEpic, defaults.MaxDocEpic, function(state)
		settings.MaxDocEpic = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/consumable", GetLocalizedText("LocKey#2679"), "", settings.MaxDocRare, defaults.MaxDocRare, function(state)
		settings.MaxDocRare = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/scrapper/consumable", GetLocalizedText("LocKey#35384"), "", settings.MaxDocUncommon, defaults.MaxDocUncommon, function(state)
		settings.MaxDocUncommon = state
		SaveSettings()
	end)
	
end

registerForEvent("onInit", function()

	LoadSettings()
	SetupSettingsMenu()
	
	Override("SmarterScrapperClothesConfig", "Legendary;", function(_) return settings.ClothesLegendary end)
	Override("SmarterScrapperClothesConfig", "Epic;", function(_) return settings.ClothesEpic end)
	Override("SmarterScrapperClothesConfig", "Rare;", function(_) return settings.ClothesRare end)
	Override("SmarterScrapperClothesConfig", "Uncommon;", function(_) return settings.ClothesUncommon end)
	Override("SmarterScrapperClothesConfig", "Common;", function(_) return settings.ClothesCommon end)
	
	Override("SmarterScrapperWeaponsConfig", "Knife;", function(_) return settings.WeaponsKnife end)
	Override("SmarterScrapperWeaponsConfig", "Legendary;", function(_) return settings.WeaponsLegendary end)
	Override("SmarterScrapperWeaponsConfig", "Epic;", function(_) return settings.WeaponsEpic end)
	Override("SmarterScrapperWeaponsConfig", "Rare;", function(_) return settings.WeaponsRare end)
	Override("SmarterScrapperWeaponsConfig", "Uncommon;", function(_) return settings.WeaponsUncommon end)
	Override("SmarterScrapperWeaponsConfig", "Common;", function(_) return settings.WeaponsCommon end)
	
	Override("SmarterScrapperGrenadeConfig", "Rare;", function(_) return settings.GrenadesRare end)
	Override("SmarterScrapperGrenadeConfig", "Uncommon;", function(_) return settings.GrenadesUncommon end)
	Override("SmarterScrapperGrenadeConfig", "Common;", function(_) return settings.GrenadesCommon end)
		
	Override("SmarterScrapperBounceBackConfig", "Rare;", function(_) return settings.BounceBackRare end)
	Override("SmarterScrapperBounceBackConfig", "Uncommon;", function(_) return settings.BounceBackUncommon end)
	Override("SmarterScrapperBounceBackConfig", "Common;", function(_) return settings.BounceBackCommon end)
		
	Override("SmarterScrapperMaxDocConfig", "Epic;", function(_) return settings.MaxDocEpic end)
	Override("SmarterScrapperMaxDocConfig", "Rare;", function(_) return settings.MaxDocRare end)
	Override("SmarterScrapperMaxDocConfig", "Uncommon;", function(_) return settings.MaxDocUncommon end)

end)
