-- ai core file

dofile "ai/vector.lua" 
dofile "ai/shared.lua"
dofile "ai/protocol.lua"  -- see this file to get help

dofile "ai/think.lua"

function Initialization()
	LastKnownWeapon = FindWeaponByIndex(GetWeaponIndex())
	IsSpawned = IsAlive()
	FindModification()
	
	if Idle then
		print "Idle mode"
	end
	
	if Modification == ModificationType.Unknown then
		print "AI cannot be run under this modification"
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

function OnTrigger(A)

end