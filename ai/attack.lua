
function Attack()
	if NeedToDestroy then
		AttackEx()
		return
	end
	
	if Idle then
		return
	end
	
	if not HasEnemiesNear then
		return
	end

	if CurrentWeapon == nil then
		return
	end
	
	if not CanAttack() then
		return
	end

	if IsReloading() then
		return
	end
	
	if HasWorld() then
	
	else
		if (GetGameDir() == "cstrike") or (GetGameDir() == "czero") then
		
		end
	end
	
	AttackEx()
end

function AttackEx() -- fuck this 
	LastAttackTime = Ticks()
	
	if GetGameDir() == "valve" then
		Attack_HL()
	elseif (GetGameDir() == "cstrike") or (GetGameDir() == "czero") then
		Attack_CS()
	elseif GetGameDir() == "hlfx" then
		Attack_HL()
	else
		PrimaryAttack()
	end
end

function Attack_HL()
	Index = GetWeaponIndex(CurrentWeapon)
	
	if Index == HL_WEAPON_CROWBAR then
		KnifeAttack(false)
	elseif Index == HL_WEAPON_EGON then
		PrimaryAttack()
	else
		FastPrimaryAttack()
	end
end

function Attack_CS()
	Slot = GetWeaponSlotID(CurrentWeapon)
	
	if Slot == CS_WEAPON_SLOT_RIFLE then
		if CanUseWeapon(CurrentWeapon, true) then -- for reload able
			PrimaryAttack()
		end
	elseif Slot == CS_WEAPON_SLOT_PISTOL then
		FastPrimaryAttack()
	elseif Slot == CS_WEAPON_SLOT_KNIFE then
		KnifeAttack(true)
	end
end

function KnifeAttack(CanAlternativeAttack)
	if not HasEnemiesNear then
		return
	end
	
	MoveTo(NearestEnemy)
	
	if CanAlternativeAttack and Behavior.AlternativeKnifeAttack then
		if GetDistance(NearestEnemy) < KNIFE_ALTERNATIVE_ATTACK_DISTANCE then
			SecondaryAttack()
		end
	else
		if GetDistance(NearestEnemy) < KNIFE_PRIMARY_ATTACK_DISTANCE then
			PrimaryAttack()
		end	
	end
end