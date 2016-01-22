-- common vars		
	Origin = {}

	IsSlowThink = false
	LastSlowThinkTime = 0

	IsSpawned = false

-- global constants
	Idle = false

	SLOWTHINK_PERIOD = 500
	
	KNIFE_PRIMARY_ATTACK_DISTANCE = HUMAN_HEIGHT_STAND * 2
	KNIFE_ALTERNATIVE_ATTACK_DISTANCE = KNIFE_PRIMARY_ATTACK_DISTANCE / 1.5
	
	OBJECTIVE_LOOKING_AREA_OFFSET = 2;

dofile "ai/utils.lua" 

dofile "ai/movement.lua" 
dofile "ai/looking.lua" 
dofile "ai/weapons.lua"
dofile "ai/attack.lua"

function Think()
	if IsAlive() then
		if not IsSpawned then
			Spawn()
		end
		
		Movement()
		Looking()
		Weapons()
		Attack()
	else
		if IsSpawned then
			Die()
		end
	end
end 

function PreThink()
	Origin = Vec3.New(GetOrigin())
	
	IsSlowThink = DeltaTicks(LastSlowThinkTime) >= SLOWTHINK_PERIOD

	if IsSlowThink then
		LastSlowThinkTime = Ticks()
	end
	
	if not IsAlive() then
		return
	end
	
	FindCurrentWeapon()
	FindEnemiesAndFriends()
end

function PostThink()

end

function Spawn()
	IsSpawned = true
	
	Behavior.Randomize()
	
	print "spawned"
end

function Die()
	IsSpawned = false
	
	print "died"
end