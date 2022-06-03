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
	
	nativeSettings.addSubcategory("/imz/zoom", GetLocalizedTextByKey("Mod-IMZ-Static"))
	
	nativeSettings.addRangeInt("/imz/zoom", GetLocalizedTextByKey("Mod-IMZ-Combat"), GetLocalizedTextByKey("Mod-IMZ-Combat-Desc"), 20, 200, 5, settings.Combat, defaults.Combat, function(value)
		settings.Combat = value
		SaveSettings()
	end)
	
	nativeSettings.addRangeInt("/imz/zoom", GetLocalizedTextByKey("Mod-IMZ-Quest"), GetLocalizedTextByKey("Mod-IMZ-Quest-Desc"), 20, 200, 5, settings.QuestArea, defaults.QuestArea, function(value)
		settings.QuestArea = value
		SaveSettings()
	end)
	
	nativeSettings.addRangeInt("/imz/zoom", GetLocalizedTextByKey("Mod-IMZ-Security"), GetLocalizedTextByKey("Mod-IMZ-Security-Desc"), 20, 200, 5, settings.SecurityArea, defaults.SecurityArea, function(value)
		settings.SecurityArea = value
		SaveSettings()
	end)
	
	nativeSettings.addRangeInt("/imz/zoom", GetLocalizedTextByKey("Mod-IMZ-Interior"), GetLocalizedTextByKey("Mod-IMZ-Interior-Desc"), 20, 200, 5, settings.Interior, defaults.Interior, function(value)
		settings.Interior = value
		SaveSettings()
	end)
	
	nativeSettings.addRangeInt("/imz/zoom", GetLocalizedTextByKey("Mod-IMZ-Exterior"), GetLocalizedTextByKey("Mod-IMZ-Exterior-Desc"), 20, 200, 5, settings.Exterior, defaults.Exterior, function(value)
		settings.Exterior = value
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/imz/peek", GetLocalizedTextByKey("Mod-IMZ-Peek-Hotkey"))
	
	nativeSettings.addRangeInt("/imz/peek", GetLocalizedTextByKey("Mod-IMZ-Peek-Increment"), GetLocalizedTextByKey("Mod-IMZ-Peek-Increment-Desc"), 20, 200, 5, settings.Peek, defaults.Peek, function(value)
		settings.Peek = value
		SaveSettings()
	end)
	
	nativeSettings.addSwitch("/imz/peek", GetLocalizedTextByKey("Mod-IMZ-Peek-Toggleable"), GetLocalizedTextByKey("Mod-IMZ-Peek-Toggleable-Desc"), settings.ReplaceHoldWithToggle, defaults.ReplaceHoldWithToggle, function(state)
		settings.ReplaceHoldWithToggle = state
		SaveSettings()
	end)
	
	nativeSettings.addSubcategory("/imz/dynamic", GetLocalizedTextByKey("Mod-IMZ-Max-Dynamic"))
	
	nativeSettings.addSwitch("/imz/dynamic", GetLocalizedTextByKey("Mod-IMZ-Max-Dynamic-Enable"), GetLocalizedTextByKey("Mod-IMZ-Max-Dynamic-Enable-Desc"), settings.IsDynamicZoomEnabled, defaults.IsDynamicZoomEnabled, function(state)
		settings.IsDynamicZoomEnabled = state
		SaveSettings()
	end)
	
	nativeSettings.addRangeInt("/imz/dynamic", GetLocalizedTextByKey("Mod-IMZ-Min-Zoom"), GetLocalizedTextByKey("Mod-IMZ-Min-Zoom-Desc"), 20, 200, 5, settings.MinZoom, defaults.MinZoom, function(value)
		settings.MinZoom = value
		SaveSettings()
	end)
	
	nativeSettings.addRangeInt("/imz/dynamic", GetLocalizedTextByKey("Mod-IMZ-Min-Speed"), GetLocalizedTextByKey("Mod-IMZ-Min-Speed-Desc"), 20, 200, 5, settings.MinSpeed, defaults.MinSpeed, function(value)
		settings.MinSpeed = value
		SaveSettings()
	end)
	
	nativeSettings.addRangeInt("/imz/dynamic", GetLocalizedTextByKey("Mod-IMZ-Max-Zoom"), GetLocalizedTextByKey("Mod-IMZ-Max-Zoom-Desc"), 20, 200, 5, settings.MaxZoom, defaults.MaxZoom, function(value)
		settings.MaxZoom = value
		SaveSettings()
	end)
	
	nativeSettings.addRangeInt("/imz/dynamic", GetLocalizedTextByKey("Mod-IMZ-Max-Speed"), GetLocalizedTextByKey("Mod-IMZ-Max-Speed-Desc"), 20, 200, 5, settings.MaxSpeed, defaults.MaxSpeed, function(value)
		settings.MaxSpeed = value
		SaveSettings()
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
