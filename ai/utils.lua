-- movement
	SlowJumpTime = 0
	
	ScenarioType = {
		None = 0,
		Walking = 1
	}
	
	Scenario = ScenarioType.None

	Area = nil
	PrevArea = nil
	IsAreaChanged = false
	
	Chain = {}
	ChainIndex = 0
	ChainFinalPoint = {}
	
	LastStuckCheckTime = 0
	StuckWarnings = 0
	UnstuckWarnings = 0
	StuckOrigin = {}
	TryedToUnstuck = false
	
-- looking

	LookingPoint = {}
	
-- weapons

	CurrentWeapon = nil
	LastKnownWeapon = nil -- only for hint
	
-- attack
	LastAttackTime = 0
	
-- common
	Behavior = {
		MoveWhenShooting = true,
		CrouchWhenShooting = false,
		MoveWhenReloading = true,
		AimWhenReloading = true,
		AlternativeKnifeAttack = false
		
	}

    NearestEnemy = nil
    NearestLeaderEnemy = nil
    EnemiesNearCount = 0
    HasEnemiesNear = false

    NearestFriend = nil
    NearestLeaderFriend = nil
    FriendsNearCount = 0
    HasFriendsNear = false

-- movement utils

function HasChain()
	if type(Chain) ~= "table" then
		return false
	else
		return(#Chain > 0)
	end
end
	
function SlowDuckJump()
	if DeltaTicks(SlowJumpTime) < SLOWTHINK_PERIOD then
		return
	end
	
	DuckJump()
	
	SlowJumpTime = Ticks()
end

-- weapon utils	
	
function FindCurrentWeapon()
	CurrentWeapon = GetWeaponByAbsoluteIndex(GetWeaponAbsoluteIndex())

	if (LastKnownWeapon ~= CurrentWeapon) and (CurrentWeapon ~= 0) and (LastKnownWeapon ~= 0) then
		print("choosed: " .. GetWeaponNameEx(CurrentWeapon))
	end

	LastKnownWeapon = CurrentWeapon
end

function FindWeaponBySlot(ASlot)
	Weapon = nil
	Weight = -1
	
	for I = 0, GetWeaponsCount() - 1 do
		if IsWeaponExists(GetWeaponIndex(I)) then
			if GetWeaponSlotID(I) == ASlot then
				if GetWeaponWeight(I) > Weight then
					Weapon = I
					Weight = GetWeaponWeight(I)
				end
			end
		end
	end
	
	return Weapon
end

function ChooseWeapon(AWeapon)
	if not IsSlowThink then
		return
	end
	
	if AWeapon == nil then
		return
	end
	
	if AWeapon == CurrentWeapon then
		return
	end
	
	ExecuteCommand(GetWeaponName(AWeapon))
end

function GetWeaponClip(AWeapon)
	if not HasWeaponData(GetWeaponIndex(AWeapon)) then
		return 0
	end
	
	return GetWeaponDataField(GetWeaponIndex(AWeapon), WeaponDataField.Clip)
end

function HasWeaponClip(AWeapon)
	return GetWeaponClip(AWeapon) > 0
end

function GetWeaponPrimaryAmmo(AWeapon) 
	return GetAmmo(GetWeaponPrimaryAmmoID(AWeapon))
end

function HasWeaponPrimaryAmmo(AWeapon)
	return GetWeaponPrimaryAmmo(AWeapon) > 0
end

function GetWeaponSecondaryAmmo(AWeapon)
	return GetAmmo(GetWeaponSecondaryAmmoID(AWeapon))
end

function HasWeaponSeconadryAmmo(AWeapon)
	return GetWeaponSecondaryAmmo(AWeapon) > 0
end

function CanUseWeapon(AWeapon, IsInstant)
	if AWeapon == nil then
		return false
	end
	
	Clip = GetWeaponClip(AWeapon)
	PrimaryAmmo = GetWeaponPrimaryAmmo(AWeapon)
	SecondaryAmmo = GetWeaponSecondaryAmmo(AWeapon)
	
	if Clip ~= WEAPON_NOCLIP then -- weapon can be reloaded
		if IsInstant then
			return(Clip > 0)
		else
			return(Clip + PrimaryAmmo + SecondaryAmmo > 0)
		end
	else
		return(PrimaryAmmo > 0)
	end
end

function GetWeaponMaxClip(AWeapon)
	if (GetGameDir() == "cstrike") or (GetGameDir() == "czero") then
		return CSWeapons[GetWeaponIndex(AWeapon)].MaxClip
	elseif GetGameDir() == "valve" then
		return HLWeapons[GetWeaponIndex(AWeapon)].MaxClip
	else
		print "GetWeaponMaxClip(AWeapon) doesnt support this game modification"
		return nil
	end
end

function GetWeaponWeight(AWeapon)
	if (GetGameDir() == "cstrike") or (GetGameDir() == "czero") then
		return CSWeapons[GetWeaponIndex(AWeapon)].Weight
	elseif GetGameDir() == "valve" then
		return HLWeapons[GetWeaponIndex(AWeapon)].Weight
	else
		print "GetWeaponWeight(AWeapon) doesnt support this game modification"
		return nil
	end	
end

function IsWeaponFullyLoaded(AWeapon)
	if AWeapon == nil then
		return true
	end
 
	Clip = GetWeaponClip(AWeapon)
	
	if Clip == WEAPON_NOCLIP then
		return true
	end
	
	if not HasWeaponPrimaryAmmo(AWeapon) then
		return true
	end

	return Clip >= GetWeaponMaxClip(AWeapon)
end

function NeedReloadWeapon(AWeapon)
	return not IsWeaponFullyLoaded(AWeapon)
end

function CanReload()
	-- TODO
	
	return true
end

-- attack

function IsAttacking()
	return DeltaTicks(LastAttackTime) < 500 -- fix
end

-- common utils

function Behavior.Randomize()
	if (GetGameDir() == "cstrike") or (GetGameDir() == "czero") then
		Behavior.MoveWhenShooting = Chance(50)
		Behavior.CrouchWhenShooting = Chance(50)
		Behavior.MoveWhenReloading = Chance(50)
		Behavior.AimWhenReloading = Chance(50)
		Behavior.AlternativeKnifeAttack = Chance(50)
	end
end

function MyHeight()
	if IsCrouching() then
		return HUMAN_HEIGHT_DUCK
	else
		return HUMAN_HEIGHT_STAND
	end
end

function IsEnemy(player_index)
	if IsTeamPlay() --[[and not FriendlyFire]] then
		if (GetGameDir() == "tfc") or (GetGameDir() == "dod") then
			-- dod & tfc not using absolute team names, we need to compare team indexes from entities array
		
			T1 = GetEntityTeam(GetClientIndex() + 1)
			T2 = GetEntityTeam(player_index + 1)
			
			return T1 ~= T2
		else 		
			-- we can compare team names from players array for all other mods
		
			T1 = GetPlayerTeam(GetClientIndex())
			T2 = GetPlayerTeam(player_index)
			
			return T1 ~= T2
		end
	else
		return true
	end
end

function IsPlayerPriority(APlayer)
	return APlayer < GetClientIndex()
end

function FindEnemiesAndFriends()
	NearestEnemy = nil;
	NearestLeaderEnemy = nil;
	EnemiesNearCount = 0;

	NearestFriend = nil;
	NearestLeaderFriend = nil;
	FriendsNearCount = 0;

	EnemyDistance = MAX_UNITS
	EnemyKills = 0

	FriendDistance = MAX_UNITS
	FriendKills = 0
		
	for I = 1, GetPlayersCount() do
		if I ~= GetClientIndex() + 1 then
			if IsEntityActive(I) then
				if IsPlayerAlive(I - 1) then
					if (HasWorld() and IsVisible(I)) or not HasWorld() then
						if IsEnemy(I - 1) then
							EnemiesNearCount = EnemiesNearCount + 1
						
							if GetDistance(I) < EnemyDistance then
								EnemyDistance = GetDistance(I)
								NearestEnemy = I
							end
						
							if GetPlayerKills(I - 1) > EnemyKills then
								EnemyKills = GetPlayerKills(I - 1)
								NearestLeaderEnemy = I
							end					
						else
							FriendsNearCount = FriendsNearCount + 1
						
							if GetDistance(I) < FriendDistance then
								FriendDistance = GetDistance(I)
								NearestFriend = I
							end
						
							if GetPlayerKills(I - 1) > FriendKills then
								FriendKills = GetPlayerKills(I - 1)
								NearestLeaderFriend = I
							end	
						end
					end
				end
			end			
		end
	end

	HasEnemiesNear = EnemiesNearCount > 0
	HasFriendsNear = FriendsNearCount > 0
end