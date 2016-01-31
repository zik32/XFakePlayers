
-- constants

	Idle = false

	SLOW_THINK_PERIOD = 1000

	KNIFE_PRIMARY_ATTACK_DISTANCE = HUMAN_WIDTH * 2
	KNIFE_ALTERNATIVE_ATTACK_DISTANCE = KNIFE_PRIMARY_ATTACK_DISTANCE / 1.5

	OBJECTIVE_LOOKING_AREA_OFFSET = 2;
	
-- movement

	SLOW_JUMP_PERIOD = 1000
	SlowJumpTime = 0
	
	ScenarioType = {
		Walking = 1, -- randomly walk on navigation map, nothing more
		
		-- cstrike, czero scenarios:
		
		PlantingBomb = 2, -- run to random bomb place
		DefusingBomb = 3, -- search planted c4 at bomb places
		
		-- DefendingBomb = 4 -- find and stay near planted c4 at bomb place (terrorist)
							 -- or find and stay near dropped c4 (backpack) (counter-terrorist)
		SearchingBomb = 5 -- if bomb was dropped - i need to pick up it (terrorist)
		
		-- EscapingFromBomb = 6 -- fuck you
		
		-- TODO: add hostages rescuing scenarios for cstrike, czero
		
		-- TODO: add VIP escaping scenario for cstrike, czero 
		
	}
	
	Scenario = ScenarioType.Walking
	ChainScenarion = ScenarioType.Walking
	LastScenarioChangeTime = 0

	Area = nil
	PrevArea = nil
	IsAreaChanged = false

	Chain = {}
	ChainIndex = 0
	ChainFinalPoint = {}

	STUCK_CHECK_PERIOD = 500
	LastStuckMonitorTime = 0

	LastStuckCheckTime = 0
	StuckWarnings = 0
	UnstuckWarnings = 0
	StuckOrigin = {}
	TryedToUnstuck = false

-- look

	LookPoint = {}
	
-- weapons

	CurrentWeapon = nil
	LastKnownWeapon = nil -- only for hint

	NeedToBuyWeapons = false

-- attack

	LastAttackTime = 0
	
-- tasks

	IsPlantingBomb = false
	IsDefusingBomb = false

	NeedToDestroy = false
	BreakablePosition = {}
	
-- common

	Origin = {}

	IsSlowThink = false
	LastSlowThinkTime = 0

	IsSpawned = false

	IsEndOfRound = false

	IsBombPlanted = false
	IsBombDropped = false
	
	Behavior = {
		MoveWhenShooting = true,
		CrouchWhenShooting = false,
		MoveWhenReloading = true,
		AimWhenReloading = true,
		AlternativeKnifeAttack = false,
		ReloadDelay = 0,
		DuckWhenPlantingBomb = false,
		DuckWhenDefusingBomb = false
		
	}

	NearestEnemy = nil
	NearestLeaderEnemy = nil
	EnemiesNearCount = 0
	HasEnemiesNear = false

	NearestFriend = nil
	NearestLeaderFriend = nil
	FriendsNearCount = 0
	HasFriendsNear = false
	
	NearestPlayer = nil
	NearestLeaderPlayer = nil
	PlayersNearCount = 0
	HasPlayersNear = false

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
		
		TryToRespawn()
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
	SetViewAngles(Vec3Unpack(V))
end

function Spawn()
	IsSpawned = true
	
	NeedToBuyWeapons = true
	
	Behavior.Randomize()
	
	ResetObjectiveMovement()
	ResetStuckMonitor()
	
	print "spawned"
end

function Die()
	IsSpawned = false
	
	print "died"
end

function TryToRespawn()
	if not IsSlowThink then
		return
	end
	
	if (GetGameDir() == "valve")
	or (GetGameDir() == "dmc")
	or (GetGameDir() == "tfc")
	or (GetGameDir() == "gearbox") then
		PrimaryAttack()
	end
end