-- ai core file

dofile "ai/vector.lua" 
dofile "ai/shared.lua"
dofile "ai/protocol.lua"  -- see this file to get help

dofile "ai/think.lua"

function Initialization()
	LastKnownWeapon = GetWeaponByAbsoluteIndex(GetWeaponAbsoluteIndex())
	IsSpawned = IsAlive()
	
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

function OnTrigger(A)

end