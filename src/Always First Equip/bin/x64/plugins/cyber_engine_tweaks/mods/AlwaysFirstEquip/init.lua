local defaults = {
	PercentageProbability = 50,
	PlayInCombatMode = false,
	PlayInStealthMode = false,
	PlayWhenMagazineIsEmpty = false,
	PlayWhileSprinting = false,
	ExcludeArmsCyberware = true,
	TrackLastUsedSlot = true,
	DefaultSlotNumber = 1,
	AnimationProbability = 10,
	AnimationCheckPeriod = 5,
	BindToHotkeyIdleBreak = true,
	UseCooldowns = false,
	DefaultCooldown = 20,
	CooldownUnits = 1
}

local settings = {
	PercentageProbability = 50,
	PlayInCombatMode = false,
	PlayInStealthMode = false,
	PlayWhenMagazineIsEmpty = false,
	PlayWhileSprinting = false,
	ExcludeArmsCyberware = true,
	TrackLastUsedSlot = true,
	DefaultSlotNumber = 1,
	AnimationProbability = 10,
	AnimationCheckPeriod = 5,
	BindToHotkeyIdleBreak = true,
	UseCooldowns = false,
	DefaultCooldown = 20,
	CooldownUnits = 1
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
	
	local cooldownUnit = {
		[1] = GetLocalizedTextByKey("Mod-First-Equip-Seconds"),
		[2] = GetLocalizedTextByKey("Mod-First-Equip-Minutes")
	}

	nativeSettings.addTab("/equip", "First Equip")
	
	nativeSettings.addSubcategory("/equip/common", GetLocalizedTextByKey("Mod-First-Equip-Triggering"))
	
	nativeSettings.addRangeInt("/equip/common", GetLocalizedTextByKey("Mod-First-Equip-Percentage"), GetLocalizedTextByKey("Mod-First-Equip-Percentage-Desc"), 0, 100, 5, settings.PercentageProbability, defaults.PercentageProbability, function(value)
		settings.PercentageProbability = value
	end)
	
	nativeSettings.addSwitch("/equip/common", GetLocalizedTextByKey("Mod-First-Equip-Cooldowns"), GetLocalizedTextByKey("Mod-First-Equip-Cooldowns-Desc"), settings.UseCooldowns, defaults.UseCooldowns, function(state)
		settings.UseCooldowns = state
	end)
	
	nativeSettings.addRangeInt("/equip/common", GetLocalizedTextByKey("Mod-First-Equip-Cooldowns-Time"), GetLocalizedTextByKey("Mod-First-Equip-Cooldowns-Time-Desc"), 0, 120, 1, settings.DefaultCooldown, defaults.DefaultCooldown, function(value)
		settings.DefaultCooldown = value
	end)
	
	nativeSettings.addSelectorString("/equip/common", GetLocalizedTextByKey("Mod-First-Equip-Cooldowns-Time-Unit"), GetLocalizedTextByKey("Mod-First-Equip-Cooldowns-Time-Unit-Desc"), cooldownUnit, settings.CooldownUnits, defaults.CooldownUnits, function(value)
		settings.CooldownUnits = value
	end)
	
	nativeSettings.addSubcategory("/equip/restr", GetLocalizedTextByKey("Mod-First-Equip-Restrictions"))
	
	nativeSettings.addSwitch("/equip/restr", GetLocalizedTextByKey("Mod-First-Equip-Restrictions-Combat"), GetLocalizedTextByKey("Mod-First-Equip-Restrictions-Combat-Desc"), settings.PlayInCombatMode, defaults.PlayInCombatMode, function(state)
		settings.PlayInCombatMode = state
	end)
	
	nativeSettings.addSwitch("/equip/restr", GetLocalizedTextByKey("Mod-First-Equip-Restrictions-Stealth"), GetLocalizedTextByKey("Mod-First-Equip-Restrictions-Stealth-Desc"), settings.PlayInStealthMode, defaults.PlayInStealthMode, function(state)
		settings.PlayInStealthMode = state
	end)
	
	nativeSettings.addSwitch("/equip/restr", GetLocalizedTextByKey("Mod-First-Equip-Restrictions-Magazine"), GetLocalizedTextByKey("Mod-First-Equip-Restrictions-Magazine-Desc"), settings.PlayWhenMagazineIsEmpty, defaults.PlayWhenMagazineIsEmpty, function(state)
		settings.PlayWhenMagazineIsEmpty = state
	end)
	
	nativeSettings.addSwitch("/equip/restr", GetLocalizedTextByKey("Mod-First-Equip-Restrictions-Sprinting"), GetLocalizedTextByKey("Mod-First-Equip-Restrictions-Sprinting-Desc"), settings.PlayWhileSprinting, defaults.PlayWhileSprinting, function(state)
		settings.PlayWhileSprinting = state
	end)
	
	nativeSettings.addSwitch("/equip/restr", GetLocalizedTextByKey("Mod-First-Equip-Restrictions-ArmsCW"), GetLocalizedTextByKey("Mod-First-Equip-Restrictions-ArmsCW-Desc"), settings.ExcludeArmsCyberware, defaults.ExcludeArmsCyberware, function(state)
		settings.ExcludeArmsCyberware = state
	end)
	

	nativeSettings.addSubcategory("/equip/hotkey", GetLocalizedTextByKey("Mod-First-Equip-Hotkey"))
	
	nativeSettings.addSwitch("/equip/hotkey", GetLocalizedTextByKey("Mod-First-Equip-Hotkey-Track"), GetLocalizedTextByKey("Mod-First-Equip-Hotkey-Track-Desc"), settings.TrackLastUsedSlot, defaults.TrackLastUsedSlot, function(state)
		settings.TrackLastUsedSlot = state
	end)
	
	nativeSettings.addRangeInt("/equip/hotkey", GetLocalizedTextByKey("Mod-First-Equip-Hotkey-Default"), GetLocalizedTextByKey("Mod-First-Equip-Hotkey-Default-Desc"), 1, 4, 1, settings.DefaultSlotNumber, defaults.DefaultSlotNumber, function(value)
		-- print("Changed SLIDER INT to ", value)
		settings.DefaultSlotNumber = value
	end)
	
	nativeSettings.addSubcategory("/equip/idle", GetLocalizedTextByKey("Mod-First-Equip-IdleBreak"))

	nativeSettings.addSwitch("/equip/idle", GetLocalizedTextByKey("Mod-First-Equip-IdleBreak-Bind"), GetLocalizedTextByKey("Mod-First-Equip-IdleBreak-Bind-Desc"), settings.BindToHotkeyIdleBreak, defaults.BindToHotkeyIdleBreak, function(state)
		settings.BindToHotkeyIdleBreak = state
	end)

	nativeSettings.addRangeInt("/equip/idle", GetLocalizedTextByKey("Mod-First-Equip-IdleBreak-Probability"), GetLocalizedTextByKey("Mod-First-Equip-IdleBreak-Probability-Desc"), 1, 100, 5, settings.AnimationProbability, defaults.AnimationProbability, function(value)
		settings.AnimationProbability = value
	end)
	
	nativeSettings.addRangeInt("/equip/idle", GetLocalizedTextByKey("Mod-First-Equip-IdleBreak-Check"), GetLocalizedTextByKey("Mod-First-Equip-IdleBreak-Check-Desc"), 1, 100, 5, settings.AnimationCheckPeriod, defaults.AnimationCheckPeriod, function(value)
		settings.AnimationCheckPeriod = value
	end)
end

registerForEvent("onInit", function()

	LoadSettings()
	SetupSettingsMenu()
	
	Override("FirstEquipConfig", "PercentageProbability;", function(_) return settings.PercentageProbability end)
	Override("FirstEquipConfig", "PlayInCombatMode;", function(_) return settings.PlayInCombatMode end)
	Override("FirstEquipConfig", "PlayInStealthMode;", function(_) return settings.PlayInStealthMode end)
	Override("FirstEquipConfig", "PlayWhenMagazineIsEmpty;", function(_) return settings.PlayWhenMagazineIsEmpty end)
	Override("FirstEquipConfig", "PlayWhileSprinting;", function(_) return settings.PlayWhileSprinting end)
	Override("FirstEquipConfig", "ExcludeArmsCyberware;", function(_) return settings.ExcludeArmsCyberware end)
	Override("FirstEquipConfig", "TrackLastUsedSlot;", function(_) return settings.TrackLastUsedSlot end)
	Override("FirstEquipConfig", "DefaultSlotNumber;", function(_) return settings.DefaultSlotNumber end)
	Override("IdleBreakConfig", "AnimationProbability;", function(_) return settings.AnimationProbability end)
	Override("IdleBreakConfig", "AnimationCheckPeriod;", function(_) return settings.AnimationCheckPeriod end)
	Override("IdleBreakConfig", "BindToHotkey;", function(_) return settings.BindToHotkeyIdleBreak end)
	Override("FirstEquipConfig", "UseCooldownBasedCheck;", function(_) return settings.UseCooldowns end)
	Override("FirstEquipConfig", "CooldownTime;", function(_) return settings.DefaultCooldown end)
	Override("FirstEquipConfig", "CooldownTimeUnits;", function(_) return settings.CooldownUnits end)

end)

registerForEvent("onShutdown", function()
    SaveSettings()
end)
