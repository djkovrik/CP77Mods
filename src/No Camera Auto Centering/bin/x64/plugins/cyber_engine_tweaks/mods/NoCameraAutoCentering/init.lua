-- No Camera Auto Centering
-- by DJ_Kovrik
-- Nexus: https://www.nexusmods.com/cyberpunk2077/mods/2169

local NoCameraAutoCentering = {
	title = "No Camera Auto Centering",
	version = "v0.4",
	showMenu = false
}

local disabledForFpp = true

local disabledForTpp = true

local newTimeoutValue = 99999.00000

local defaults = {}

local fppTweakDbIds = {
	'fppCameraParamSets.Bike.headingResetTimeout',
	'fppCameraParamSets.Vehicle.headingResetTimeout'
}

local tppTweakDbIds = {
	'Camera.VehicleTPP_2w_DefaultParams.autoCenterStartTimeGamepad',
	'Camera.VehicleTPP_2w_DefaultParams.autoCenterStartTimeMouse',
	'Camera.VehicleTPP_DefaultParams.autoCenterStartTimeGamepad',
	'Camera.VehicleTPP_DefaultParams.autoCenterStartTimeMouse',
	'RTDB.VehicleTPPCameraParams.autoCenterStartTimeGamepad',
	'RTDB.VehicleTPPCameraParams.autoCenterStartTimeMouse',
	'Vehicle.VehicleTPP_Params_v_militech_basilisk.autoCenterStartTimeGamepad',
	'Vehicle.VehicleTPP_Params_v_militech_basilisk.autoCenterStartTimeMouse'
}

function saveDefaultValues(tdbids)
	for _, tdbid in pairs(tdbids) do
		value = TweakDB:GetFlat(TweakDBID.new(tdbid))
		defaults[tdbid] = value
	end
end

function restoreDefaultTimeouts(tdbids)
	for _, tdbid in pairs(tdbids) do
		value = defaults[tdbid]
		TweakDB:SetFlat(TweakDBID.new(tdbid), value)
		TweakDB:Update(TweakDBID.new(tdbid))
	end
end

function adjustTimeouts(tdbids)
	for _, tdbid in pairs(tdbids) do
		TweakDB:SetFlat(TweakDBID.new(tdbid), newTimeoutValue)
		TweakDB:Update(TweakDBID.new(tdbid))
	end
end

function refreshTimeouts()
	if disabledForFpp == true then
		adjustTimeouts(fppTweakDbIds)
	else
		restoreDefaultTimeouts(fppTweakDbIds)
	end
	
	if disabledForTpp == true then
		adjustTimeouts(tppTweakDbIds)
	else
		restoreDefaultTimeouts(tppTweakDbIds)
	end
end

function initDatabase() 
	db:exec("CREATE TABLE IF NOT EXISTS cameras (name TEXT NOT NULL PRIMARY KEY, state INTEGER NOT NULL);")
end

function saveFeatureStates()
	if disabledForFpp then
		db:exec("INSERT OR REPLACE INTO cameras VALUES('FPP', 1)")
	else
		db:exec("INSERT OR REPLACE INTO cameras VALUES('FPP', 0)")
	end
	
	if disabledForTpp then
		db:exec("INSERT OR REPLACE INTO cameras VALUES('TPP', 1)")
	else
		db:exec("INSERT OR REPLACE INTO cameras VALUES('TPP', 0)")
	end
end

function restoreFeatureStates()	
	for state in db:urows("SELECT state FROM cameras WHERE name = 'FPP'") do
		if state == 0 then disabledForFpp = false else disabledForFpp = true end
	end
	
	for state in db:urows("SELECT state FROM cameras WHERE name = 'TPP'") do
		if state == 0 then disabledForTpp = false else disabledForTpp = true end
	end
end


registerForEvent("onInit", function()
	initDatabase() 
	restoreFeatureStates()
	saveDefaultValues(tppTweakDbIds)
	saveDefaultValues(fppTweakDbIds)
	refreshTimeouts()
	
	print(NoCameraAutoCentering.title, NoCameraAutoCentering.version, 'loaded.')
end)

registerForEvent("onOverlayOpen", function()
	NoCameraAutoCentering.showMenu = true
end)

registerForEvent("onOverlayClose", function()
	NoCameraAutoCentering.showMenu = false
end)

registerForEvent("onDraw", function()
	if not NoCameraAutoCentering.showMenu then
		return
	end
	
	ImGui.PushStyleColor(ImGuiCol.Text, 0.90, 0.90, 0.90, 0.90)
	ImGui.PushStyleColor(ImGuiCol.Border, 0.70, 0.70, 0.70, 0.70)

	ImGui.Begin(NoCameraAutoCentering.title, ImGuiWindowFlags.AlwaysAutoResize)
	
	state, pressed = ImGui.Checkbox("Disable for First Person view", disabledForFpp)
	if pressed then 
		disabledForFpp = state
		refreshTimeouts()
		saveFeatureStates()
	end
	
	state, pressed = ImGui.Checkbox("Disable for Third Person view", disabledForTpp)
	if pressed then 
		disabledForTpp = state
		refreshTimeouts()
		saveFeatureStates()
	end
	
	ImGui.End()
end)
