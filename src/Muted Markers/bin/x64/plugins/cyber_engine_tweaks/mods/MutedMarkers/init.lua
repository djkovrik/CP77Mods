local MarkerVisibilityStr = {
	ThroughWalls = "Through Walls",
	LineOfSight = "Line Of Sight",
	Scanner = "Scanner",
	Hidden = "Hidden",
	Default = "Default"
}

local defaults = {
	LootIconic = 1,
	LootLegendary = 1,
	LootEpic = 2,
	LootRare = 2,
	LootUncommon = 3,
	LootCommon = 3,
	LootShards = 2,
	HideAccessPoints = false,
	HideBodyContainers = false,
	HideCameras = false,
	HideDoors = false,
	HideDistractions = false,
	HideExplosives = false,
	HideNetworking = false,
	HideLegendary = false,
	HideEpic = false,
	HideRare = false,
	HideUncommon = false,
	HideCommon = false,
	HideEnemies = false,
	HideShards = false,
	HideDelay = 5.0
}

local settings = {
	LootIconic = 1,
	LootLegendary = 1,
	LootEpic = 2,
	LootRare = 2,
	LootUncommon = 3,
	LootCommon = 3,
	LootShards = 2,
	HideAccessPoints = false,
	HideBodyContainers = false,
	HideCameras = false,
	HideDoors = false,
	HideDistractions = false,
	HideExplosives = false,
	HideNetworking = false,
	HideLegendary = false,
	HideEpic = false,
	HideRare = false,
	HideUncommon = false,
	HideCommon = false,
	HideEnemies = false,
	HideShards = false,
	HideDelay = 5.0
}

local list = {
	[1] = MarkerVisibilityStr.ThroughWalls, 
	[2] = MarkerVisibilityStr.LineOfSight, 
	[3] = MarkerVisibilityStr.Scanner, 
	[4] = MarkerVisibilityStr.Hidden
}

function GetEnumFromIndex(index)
	if index == 1 then return MarkerVisibility.ThroughWalls end
	if index == 2 then return MarkerVisibility.LineOfSight end
	if index == 3 then return MarkerVisibility.Scanner end
	if index == 4 then return MarkerVisibility.Hidden end
	return MarkerVisibility.Default
end

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

	nativeSettings.addTab("/mutedmarkers", "Muted Markers")
	
	nativeSettings.addSubcategory("/mutedmarkers/loot", "Loot markers")

	nativeSettings.addSelectorString("/mutedmarkers/loot", "Iconic", "Visibility for iconic items", list, settings.LootIconic, defaults.LootIconic, function(value)
		settings.LootIconic = value
		SaveSettings()
	end)

	nativeSettings.addSelectorString("/mutedmarkers/loot", "Legendary", "Visibility for legendary items", list, settings.LootLegendary, defaults.LootLegendary, function(value)
		settings.LootLegendary = value
		SaveSettings()
	end)
	
	nativeSettings.addSelectorString("/mutedmarkers/loot", "Epic", "Visibility for epic items", list, settings.LootEpic, defaults.LootEpic, function(value)
		settings.LootEpic = value
		SaveSettings()
	end)
	
	nativeSettings.addSelectorString("/mutedmarkers/loot", "Rare", "Visibility for rare items", list, settings.LootRare, defaults.LootRare, function(value)
		settings.LootRare = value
		SaveSettings()
	end)
	
	nativeSettings.addSelectorString("/mutedmarkers/loot", "Uncommon", "Visibility for uncommon items", list, settings.LootUncommon, defaults.LootUncommon, function(value)
		settings.LootUncommon = value
		SaveSettings()
	end)
	
	nativeSettings.addSelectorString("/mutedmarkers/loot", "Common", "Visibility for common items", list, settings.LootCommon, defaults.LootCommon, function(value)
		settings.LootCommon = value
		SaveSettings()
	end)
	
	nativeSettings.addRangeFloat("/mutedmarkers/loot", "Markers hide delay", "Delay in seconds between scanner disabling and markers hiding", 0.1, 30.0, 1.0, "%.1f", settings.HideDelay, defaults.HideDelay, function(value)
		settings.HideDelay = value
		SaveSettings()
	end)
	
	nativeSettings.addSelectorString("/mutedmarkers/loot", "Shards", "Visibility for shards", list, settings.LootShards, defaults.LootShards, function(value)
		settings.LootShards = value
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/mutedmarkers/world", "World markers")
	nativeSettings.addSwitch("/mutedmarkers/world", "Hide access points", "Enable if you want to hide icons for access points", settings.HideAccessPoints, defaults.HideAccessPoints, function(state) 
		settings.HideAccessPoints = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/world", "Hide body containers", "Enable if you want to hide icons for body containers", settings.HideBodyContainers, defaults.HideBodyContainers, function(state) 
		settings.HideBodyContainers = state 
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/world", "Hide cameras", "Enable if you want to hide icons for cameras", settings.HideCameras, defaults.HideCameras, function(state) 
		settings.HideCameras = state 
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/world", "Hide doors", "Enable if you want to hide icons for doors", settings.HideDoors, defaults.HideDoors, function(state) 
		settings.HideDoors = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/world", "Hide distractions", "Enable if you want to hide icons for distraction objects", settings.HideDistractions, defaults.HideDistractions, function(state)
		settings.HideDistractions = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/world", "Hide explosives", "Enable if you want to hide icons for explosive objects", settings.HideExplosives, defaults.HideExplosives, function(state)
		settings.HideExplosives = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/world", "Hide networking", "Enable if you want to hide icons for misc network devices (computers, smart screens etc.)", settings.HideNetworking, defaults.HideNetworking, function(state)
		settings.HideNetworking = state
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/mutedmarkers/minimap", "Minimap markers")
	nativeSettings.addSwitch("/mutedmarkers/minimap", "Hide Legendary loot", "Enable if you want to hide legendary loot markers from minimap", settings.HideLegendary, defaults.HideLegendary, function(state)
		settings.HideLegendary = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/minimap", "Hide Epic loot", "Enable if you want to hide epic loot markers from minimap", settings.HideEpic, defaults.HideEpic, function(state)
		settings.HideEpic = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/minimap", "Hide Rare loot", "Enable if you want to hide rare loot markers from minimap", settings.HideRare, defaults.HideRare, function(state)
		settings.HideRare = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/minimap", "Hide Uncommon loot", "Enable if you want to hide uncommon loot markers from minimap", settings.HideUncommon, defaults.HideUncommon, function(state)
		settings.HideUncommon = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/minimap", "Hide Common loot", "Enable if you want to hide common loot markers from minimap", settings.HideCommon, defaults.HideCommon, function(state)
		settings.HideCommon = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/minimap", "Hide enemies", "Enable if you want to hide enemy markers from minimap", settings.HideEnemies, defaults.HideEnemies, function(state)
		settings.HideEnemies = state
		SaveSettings()
	end)
	nativeSettings.addSwitch("/mutedmarkers/minimap", "Hide shards", "Enable if you want to hide shard markers from minimap", settings.HideShards, defaults.HideShards, function(state)
		settings.HideShards = state
		SaveSettings()
	end)
end

registerForEvent("onInit", function()

	LoadSettings()
	SetupSettingsMenu()
	
	Override("MutedMarkersConfig.LootConfig", "Iconic;", function(_) return GetEnumFromIndex(settings.LootIconic) end)
	Override("MutedMarkersConfig.LootConfig", "Legendary;", function(_) return GetEnumFromIndex(settings.LootLegendary) end)
	Override("MutedMarkersConfig.LootConfig", "Epic;", function(_) return GetEnumFromIndex(settings.LootEpic) end)
	Override("MutedMarkersConfig.LootConfig", "Rare;", function(_) return GetEnumFromIndex(settings.LootRare) end)
	Override("MutedMarkersConfig.LootConfig", "Uncommon;", function(_) return GetEnumFromIndex(settings.LootUncommon) end)
	Override("MutedMarkersConfig.LootConfig", "Common;", function(_) return GetEnumFromIndex(settings.LootCommon) end)
	Override("MutedMarkersConfig.LootConfig", "Shards;", function(_) return GetEnumFromIndex(settings.LootShards) end)
	Override("MutedMarkersConfig.LootConfig", "HideDelay;", function(_) return settings.HideDelay end)
	Override("MutedMarkersConfig.WorldConfig", "HideAccessPoints;", function(_) return settings.HideAccessPoints end)
	Override("MutedMarkersConfig.WorldConfig", "HideBodyContainers;", function(_) return settings.HideBodyContainers end)
	Override("MutedMarkersConfig.WorldConfig", "HideCameras;", function(_) return settings.HideCameras end)
	Override("MutedMarkersConfig.WorldConfig", "HideDoors;", function(_) return settings.HideDoors end)
	Override("MutedMarkersConfig.WorldConfig", "HideDistractions;", function(_) return settings.HideDistractions end)
	Override("MutedMarkersConfig.WorldConfig", "HideExplosives;", function(_) return settings.HideExplosives end)
	Override("MutedMarkersConfig.WorldConfig", "HideNetworking;", function(_) return settings.HideNetworking end)
	Override("MutedMarkersConfig.MiniMapConfig", "HideLegendary;", function(_) return settings.HideLegendary end)
	Override("MutedMarkersConfig.MiniMapConfig", "HideEpic;", function(_) return settings.HideEpic end)
	Override("MutedMarkersConfig.MiniMapConfig", "HideRare;", function(_) return settings.HideRare end)
	Override("MutedMarkersConfig.MiniMapConfig", "HideUncommon;", function(_) return settings.HideUncommon end)
	Override("MutedMarkersConfig.MiniMapConfig", "HideCommon;", function(_) return settings.HideCommon end)
	Override("MutedMarkersConfig.MiniMapConfig", "HideEnemies;", function(_) return settings.HideEnemies end)
	Override("MutedMarkersConfig.MiniMapConfig", "HideShards;", function(_) return settings.HideShards end)
end)

