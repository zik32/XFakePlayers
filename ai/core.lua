-- ai core file

dofile "ai/vector.lua" 
dofile "ai/shared.lua"
dofile "ai/protocol.lua"  -- see this file to get help

dofile "ai/think.lua"

function Initialization()
	math.randomseed(os.time())

	LastKnownWeapon = GetWeaponByAbsoluteIndex(GetWeaponAbsoluteIndex())
	IsSpawned = IsAlive()
	
	if GetGameDir() == "dmc" then
		ExecuteCommand("_firstspawn") 
	end
	
	if (GetGameDir() == "valve") 
	or (GetGameDir() == "dmc") 
	or (GetGameDir() == "gearbox") then
		if not IsTeamPlay() then
			if GetGameDir() == "gearbox" then
				ExecuteCommand("model " .. OPFOR_PLAYER_MODELS[math.random(#OPFOR_PLAYER_MODELS)])
			else
				ExecuteCommand("model " .. HL_PLAYER_MODELS[math.random(#HL_PLAYER_MODELS)])
			end
		end
		
		ExecuteCommand("topcolor " .. math.random(255))
		ExecuteCommand("bottomcolor " .. math.random(255))
	end
	
	if Idle then
		print "Idle mode"
	end
end

function Finalization()
	
end

function Frame() 
	if GetIntermission() ~= 0 then -- end of map ?
		return
	end
	
	if IsPaused() then
		return
	end
	
	PreThink()
	Think()
	PostThink()
end	

function OnTrigger(ATrigger)
	if ATrigger == "RoundStart" then
		IsEndOfRound = false
		Spawn()
	elseif ATrigger == "RoundEnd" then
		IsEndOfRound = true
		IsBombPlanted = false
	elseif ATrigger == "BombPlanted" then
		IsBombPlanted = true
	elseif ATrigger == "BombDropped" then
		IsBombDropped = true
	elseif ATrigger == "BombPickedUp" then
		IsBombDropped = false
	else
		print("Unknown trigger: " .. ATrigger)
	end
end