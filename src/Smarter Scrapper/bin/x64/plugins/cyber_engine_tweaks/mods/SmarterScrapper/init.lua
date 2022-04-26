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
}

local settings = {
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
	
	nativeSettings.addSubcategory("/scrapper/clothes", "Auto disassemble clothes")
	nativeSettings.addSwitch("/scrapper/clothes", "Legendary", "Disassemble legendary clothes on pickup", settings.ClothesLegendary, defaults.ClothesLegendary, function(state) settings.ClothesLegendary = state end)
	nativeSettings.addSwitch("/scrapper/clothes", "Epic", "Disassemble epic clothes on pickup", settings.ClothesEpic, defaults.ClothesEpic, function(state) settings.ClothesEpic = state end)
	nativeSettings.addSwitch("/scrapper/clothes", "Rare", "Disassemble rare clothes on pickup", settings.ClothesRare, defaults.ClothesRare, function(state) settings.ClothesRare = state end)
	nativeSettings.addSwitch("/scrapper/clothes", "Uncommon", "Disassemble uncommon clothes on pickup", settings.ClothesUncommon, defaults.ClothesUncommon, function(state) settings.ClothesUncommon = state end)
	nativeSettings.addSwitch("/scrapper/clothes", "Common", "Disassemble common clothes on pickup", settings.ClothesCommon, defaults.ClothesCommon, function(state) settings.ClothesCommon = state end)

	nativeSettings.addSubcategory("/scrapper/weapons", "Auto disassemble weapons")
	nativeSettings.addSwitch("/scrapper/weapons", "Legendary", "Disassemble Legendary weapons on pickup", settings.WeaponsLegendary, defaults.WeaponsLegendary, function(state) settings.WeaponsLegendary = state end)
	nativeSettings.addSwitch("/scrapper/weapons", "Epic", "Disassemble epic weapons on pickup", settings.WeaponsEpic, defaults.WeaponsEpic, function(state) settings.WeaponsEpic = state end)
	nativeSettings.addSwitch("/scrapper/weapons", "Rare", "Disassemble rare weapons on pickup", settings.WeaponsRare, defaults.WeaponsRare, function(state) settings.WeaponsRare = state end)
	nativeSettings.addSwitch("/scrapper/weapons", "Uncommon", "Disassemble uncommon weapons on pickup", settings.WeaponsUncommon, defaults.WeaponsUncommon, function(state) settings.WeaponsUncommon = state end)
	nativeSettings.addSwitch("/scrapper/weapons", "Common", "Disassemble common weapons on pickup", settings.WeaponsCommon, defaults.WeaponsCommon, function(state) settings.WeaponsCommon = state end)

	
end

registerForEvent("onInit", function()

	LoadSettings()
	SetupSettingsMenu()
	
	Override("SmarterScrapperClothesConfig", "Legendary;", function(_) return settings.ClothesLegendary end)
	Override("SmarterScrapperClothesConfig", "Epic;", function(_) return settings.ClothesEpic end)
	Override("SmarterScrapperClothesConfig", "Rare;", function(_) return settings.ClothesRare end)
	Override("SmarterScrapperClothesConfig", "Uncommon;", function(_) return settings.ClothesUncommon end)
	Override("SmarterScrapperClothesConfig", "Common;", function(_) return settings.ClothesCommon end)
	Override("SmarterScrapperWeaponsConfig", "Legendary;", function(_) return settings.WeaponsLegendary end)
	Override("SmarterScrapperWeaponsConfig", "Epic;", function(_) return settings.WeaponsEpic end)
	Override("SmarterScrapperWeaponsConfig", "Rare;", function(_) return settings.WeaponsRare end)
	Override("SmarterScrapperWeaponsConfig", "Uncommon;", function(_) return settings.WeaponsUncommon end)
	Override("SmarterScrapperWeaponsConfig", "Common;", function(_) return settings.WeaponsCommon end)

end)

registerForEvent("onShutdown", function()
    SaveSettings()
end)
