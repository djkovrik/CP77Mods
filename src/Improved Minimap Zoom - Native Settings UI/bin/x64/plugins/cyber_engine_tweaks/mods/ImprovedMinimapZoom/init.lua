local defaults = {
	Combat = 60,
	QuestArea = 40,
	SecurityArea = 60,
	Interior = 40,
	Exterior = 60,
	Peek = 40,
	MinZoom = 80,
	MaxZoom = 140,
	MinSpeed = 20,
	MaxSpeed = 120,
	IsDynamicZoomEnabled = true,
	ReplaceHoldWithToggle = false
}

local settings = {
	Combat = 60,
	QuestArea = 40,
	SecurityArea = 60,
	Interior = 40,
	Exterior = 60,
	Peek = 40,
	MinZoom = 80,
	MaxZoom = 140,
	MinSpeed = 20,
	MaxSpeed = 120,
	IsDynamicZoomEnabled = true,
	ReplaceHoldWithToggle = false
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

	nativeSettings.addTab("/imz", "IZoom")
	
	nativeSettings.addSubcategory("/imz/zoom", "Static zoom Values")
	
	nativeSettings.addRangeInt("/imz/zoom", "Combat zoom", "Zoom value for active combat mode", 20, 200, 5, settings.Combat, defaults.Combat, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.Combat = value
	end)
	
	nativeSettings.addRangeInt("/imz/zoom", "Quest area zoom", "Zoom value for quest areas", 20, 200, 5, settings.QuestArea, defaults.QuestArea, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.QuestArea = value
	end)
	
	nativeSettings.addRangeInt("/imz/zoom", "Security area zoom", "Zoom value for restricted and dangerous areas", 20, 200, 5, settings.SecurityArea, defaults.SecurityArea, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.SecurityArea = value
	end)
	
	nativeSettings.addRangeInt("/imz/zoom", "Interior zoom", "Zoom value for interiors", 20, 200, 5, settings.Interior, defaults.Interior, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.Interior = value
	end)
	
	nativeSettings.addRangeInt("/imz/zoom", "Exterior zoom", "Zoom value for remained cases: (not in interior, not in vehicle, not in security area, no active combat)", 20, 200, 5, settings.Exterior, defaults.Exterior, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.Exterior = value
	end)
	
	nativeSettings.addSubcategory("/imz/peek", "Minimap Peek hotkey")
	
	nativeSettings.addRangeInt("/imz/peek", "Peek hotkey zoom increment", "Non-vehicle zoom increment value for peek mode", 20, 200, 5, settings.Peek, defaults.Peek, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.Peek = value
	end)
	
	nativeSettings.addSwitch("/imz/peek", "Toggleable hotkey", "By default peek hotkey zooms minimap only while you hold it, enable this option to make it toggleable", settings.ReplaceHoldWithToggle, defaults.ReplaceHoldWithToggle, function(state)
		-- print("Changed SWITCH to ", state)
		settings.ReplaceHoldWithToggle = state
	end)
	
	nativeSettings.addSubcategory("/imz/dynamic", "Dynamic Zoom")
	
	nativeSettings.addSwitch("/imz/dynamic", "Enable dynamic zoom", "This option enables vehicle minimap dynamic zoom based on speed, if disabled then vehicle minimap will use value from Min zoom option", settings.IsDynamicZoomEnabled, defaults.IsDynamicZoomEnabled, function(state)
		-- print("Changed SWITCH to ", state)
		settings.IsDynamicZoomEnabled = state
	end)
	
	nativeSettings.addRangeInt("/imz/dynamic", "Min zoom", "Minimal zoom value", 20, 200, 5, settings.MinZoom, defaults.MinZoom, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.MinZoom = value
	end)
	
	nativeSettings.addRangeInt("/imz/dynamic", "Min speed", "Speed threshold when zoom will start increasing from Min zoom", 20, 200, 5, settings.MinSpeed, defaults.MinSpeed, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.MinSpeed = value
	end)
	
	nativeSettings.addRangeInt("/imz/dynamic", "Max zoom", "Maximal zoom value", 20, 200, 5, settings.MaxZoom, defaults.MaxZoom, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.MaxZoom = value
	end)
	
	nativeSettings.addRangeInt("/imz/dynamic", "Max speed", "Speed threshold when zoom will reach the value from Max zoom", 20, 200, 5, settings.MaxSpeed, defaults.MaxSpeed, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.MaxSpeed = value
	end)
end

registerForEvent("onInit", function()

	LoadSettings()
	SetupSettingsMenu()
	
	Override("ImprovedMinimapMain.ZoomConfig", "Combat;", function(_) return settings.Combat end)
	Override("ImprovedMinimapMain.ZoomConfig", "QuestArea;", function(_) return settings.QuestArea end)
	Override("ImprovedMinimapMain.ZoomConfig", "SecurityArea;", function(_) return settings.SecurityArea end)
	Override("ImprovedMinimapMain.ZoomConfig", "Interior;", function(_) return settings.Interior end)
	Override("ImprovedMinimapMain.ZoomConfig", "Exterior;", function(_) return settings.Exterior end)
	Override("ImprovedMinimapMain.ZoomConfig", "IsDynamicZoomEnabled;", function(_) return settings.IsDynamicZoomEnabled end)
	Override("ImprovedMinimapMain.ZoomConfig", "MinZoom;", function(_) return settings.MinZoom end)
	Override("ImprovedMinimapMain.ZoomConfig", "MaxZoom;", function(_) return settings.MaxZoom end)
	Override("ImprovedMinimapMain.ZoomConfig", "MinSpeed;", function(_) return settings.MinSpeed end)
	Override("ImprovedMinimapMain.ZoomConfig", "MaxSpeed;", function(_) return settings.MaxSpeed end)
	Override("ImprovedMinimapMain.ZoomConfig", "Peek;", function(_) return settings.Peek end)
	Override("ImprovedMinimapMain.ZoomConfig", "ReplaceHoldWithToggle;", function(_) return settings.ReplaceHoldWithToggle end)

end)

registerForEvent("onShutdown", function()
    SaveSettings()
end)
