-- movement
	SlowJumpTime = 0

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
	CurrentWeapon = FindWeaponByIndex(GetWeaponIndex())

	if (LastKnownWeapon ~= CurrentWeapon) and (CurrentWeapon ~= 0) and (LastKnownWeapon ~= 0) then
		print("choosed: " .. GetWeaponField(CurrentWeapon, WeaponField.ResolvedName))
	end

	LastKnownWeapon = CurrentWeapon
end

function FindWeaponByIndex(AIndex)
	for I = 0, GetWeaponsCount() - 1 do
		if GetWeaponField(I, WeaponField.Index) == AIndex then
			return(I)
		end
	end
	
	return nil
end

function FindWeaponBySlot(ASlot)
	Weapon = nil
	Weight = 0
	
	for I = 0, GetWeaponsCount() - 1 do
		if IsWeaponExists(GetWeaponField(I, WeaponField.Index)) then
			if GetWeaponField(I, WeaponField.SlotID) == ASlot then
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
	
	ExecuteCommand(GetWeaponField(AWeapon, WeaponField.Name))
end

function GetWeaponClip(AWeapon)
	if not HasWeaponData(GetWeaponField(AWeapon, WeaponField.Index)) then
		return(0)
	end
	
	return GetWeaponDataField(GetWeaponField(AWeapon, WeaponField.Index), WeaponDataField.Clip)
end

function HasWeaponClip(AWeapon)
	return GetWeaponClip(AWeapon) > 0
end

function GetWeaponPrimaryAmmo(AWeapon) 
	return GetAmmo(GetWeaponField(AWeapon, WeaponField.PrimaryAmmoID))
end

function HasWeaponPrimaryAmmo(AWeapon)
	return GetWeaponPrimaryAmmo(AWeapon) > 0
end

function GetWeaponSecondaryAmmo(AWeapon)
	return GetAmmo(GetWeaponField(AWeapon, WeaponField.SecondaryAmmoID))
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
	Index = GetWeaponField(AWeapon, WeaponField.Index)
	
	if (Modification == ModificationType.CounterStrike) or (Modification == ModificationType.ConditionZero) then
		return CSWeapons[Index].MaxClip
	elseif Modification == ModificationType.HalfLife then
		return HLWeapons[Index].MaxClip
	else
		print "GetWeaponMaxClip(AWeapon) doesnt support this game modification"
		return nil
	end
end

function GetWeaponWeight(AWeapon)
	Index = GetWeaponField(AWeapon, WeaponField.Index)
	
	if (Modification == ModificationType.CounterStrike) or (Modification == ModificationType.ConditionZero) then
		return CSWeapons[Index].Weight
	elseif Modification == ModificationType.HalfLife then
		return HLWeapons[Index].Weight
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
	if (Modification == ModificationType.CounterStrike) or (Modification == ModificationType.ConditionZero) then
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
		if (Modification == ModificationType.TeamFortressClassic) 
		or (Modification == ModificationType.DayOfDefeat) then
			-- dod & tfc not using absolute team names, we need to compare team indexes from entities array
		
			T1 = GetEntityField(GetServerInfo(ServerInfoType.Index) + 1, EntityField.Team)
			T2 = GetEntityField(player_index + 1, EntityField.Team)
			
			return T1 ~= T2
		else 		
			-- we can compare team names from players array for all other mods
		
			T1 = GetPlayerField(GetServerInfo(ServerInfoType.Index), PlayerField.Team)
			T2 = GetPlayerField(player_index, PlayerField.Team)
			
			return T1 ~= T2
		end
	else
		return true
	end
end

function IsPlayerPriority(APlayer)
	return APlayer > GetServerInfo(ServerInfoType.Index)
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
		if I ~= GetServerInfo(ServerInfoType.Index) + 1 then
			if GetEntityField(I, EntityField.IsActive) then
				if GetPlayerField(I - 1, PlayerField.IsCSAlive) then
					if (HasWorld() and IsVisible(I)) or not HasWorld() then
						if IsEnemy(I - 1) then
							EnemiesNearCount = EnemiesNearCount + 1
						
							if GetDistance(I) < EnemyDistance then
								EnemyDistance = GetDistance(I)
								NearestEnemy = I
							end
						
							if GetPlayerField(I - 1, PlayerField.Kills) > EnemyKills then
								EnemyKills = GetPlayerField(I - 1, PlayerField.Kills)
								NearestLeaderEnemy = I
							end					
						else
							FriendsNearCount = FriendsNearCount + 1
						
							if GetDistance(I) < FriendDistance then
								FriendDistance = GetDistance(I)
								NearestFriend = I
							end
						
							if GetPlayerField(I - 1, PlayerField.Kills) > FriendKills then
								FriendKills = GetPlayerField(I - 1, PlayerField.Kills)
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

function FindModification()
	Folder = GetServerInfo(ServerInfoType.GameDir)
	
	if Folder == "valve" then
		Modification = ModificationType.HalfLife
	elseif Folder == "cstrike" then
		Modification = ModificationType.CounterStrike
	elseif Folder == "czero" then
		Modification = ModificationType.ConditionZero
	elseif Folder == "dod" then
		Modification = ModificationType.DayOfDefeat
	elseif Folder == "dmc" then
		Modification = ModificationType.DeathmatchClassic
	elseif Folder == "gearbox" then
		Modification = ModificationType.OpposingForce
	elseif Folder == "ricochet" then
		Modification = ModificationType.Ricochet
	elseif Folder == "tfc" then
		Modification = ModificationType.TeamFortressClassic
	end		
end