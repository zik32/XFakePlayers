
function Attack()
	if Idle then
		return
	end
	
	--if not AI_InPostReaction(AI_LastNeedToAttackTime, 0.7) then // post reaction including the needattack triger
	--	Exit;W
	
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

	LastAttackTime = Ticks()
	
	if GetGameDir() == "valve" then
		Attack_HL()
	elseif GetGameDir() == "cstrike" then
		Attack_CS()
	elseif GetGameDir() == "czero" then
		Attack_CS()
	else
		PrimaryAttack()
	end
end

function Attack_HL()
	
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