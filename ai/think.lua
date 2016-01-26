-- common vars		
	Origin = {}

	IsSlowThink = false
	LastSlowThinkTime = 0

	IsSpawned = false
	
	IsEndOfRound = false

-- global constants
	Idle = false

	SLOW_THINK_PERIOD = 1000
	
	KNIFE_PRIMARY_ATTACK_DISTANCE = HUMAN_WIDTH * 2
	KNIFE_ALTERNATIVE_ATTACK_DISTANCE = KNIFE_PRIMARY_ATTACK_DISTANCE / 1.5
	
	OBJECTIVE_LOOKING_AREA_OFFSET = 2;

dofile "ai/utils.lua" 

dofile "ai/movement.lua" 
dofile "ai/look.lua" 
dofile "ai/weapons.lua"
dofile "ai/attack.lua"
dofile "ai/tasks.lua"

function Think()
	if IsAlive() then
		if not IsSpawned then
			Spawn()
		end
		
		Movement()
		Look()
		Weapons()
		Attack()
		Tasks()
	else
		if IsSpawned then
			Die()
		end
	end
end 

function PreThink()
	Origin = Vec3.New(GetOrigin())
	
	IsSlowThink = DeltaTicks(LastSlowThinkTime) >= SLOW_THINK_PERIOD

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
	-- decrease recoil
	V = Vec3.New(GetViewAngles()) - Vec3.New(GetPunchAngle())
	SetViewAngles(V.X, V.Y, V.Z)
end

function Spawn()
	IsSpawned = true
	
	NeedToBuyWeapons = true
	
	Behavior.Randomize()
	
	print "spawned"
end

function Die()
	IsSpawned = false
	
	print "died"
end