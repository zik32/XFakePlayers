
function Weapons()
	ReloadWeapon()
	ChooseBestWeapon()
end

function ReloadWeapon()
	if not IsSlowThink then
		return
	end
	
	if IsAttacking() then
		return
	end
	
	if DeltaTicks(LastAttackTime) < Behavior.ReloadDelay then
		return
	end
	
	if not NeedReloadWeapon(CurrentWeapon) then
		return
	end
	
	if HasEnemiesNear then
		return
	end

	if IsDefusingBomb then
		return
	end

	if IsReloading() then
		return
	end
	
	PressButton(Button.RELOAD);
end

function ChooseBestWeapon()
	if IsReloading() then
		return
	end
	
	if IsPlantingBomb then
		return
	end

	if GetGameDir() == "valve" then
		ChooseBestWeapon_HL()
	elseif (GetGameDir() == "cstrike") or (GetGameDir() == "czero") then
		ChooseBestWeapon_CS()
	end
end

function ChooseBestWeapon_HL()
	Crowbar = GetWeaponByAbsoluteIndex(HL_WEAPON_CROWBAR)
	Best = FindHeaviestWeapon(HasEnemiesNear or NeedToDestroy)
	
	ChooseWeapon(Best)
end

function ChooseBestWeapon_CS()
	Rifle = FindHeaviestWeaponInSlot(CS_WEAPON_SLOT_RIFLE)
	Pistol = FindHeaviestWeaponInSlot(CS_WEAPON_SLOT_PISTOL)
	Knife = FindHeaviestWeaponInSlot(CS_WEAPON_SLOT_KNIFE)
	
	if HasEnemiesNear or NeedToDestroy then
		if CanUseWeapon(Rifle, true) then
			ChooseWeapon(Rifle)
		elseif CanUseWeapon(Pistol, true) then
			ChooseWeapon(Pistol)
		elseif CanUseWeapon(Rifle, false) then
			ChooseWeapon(Rifle)
		elseif CanUseWeapon(Pistol, false) then
			ChooseWeapon(Pistol)
		else
			ChooseWeapon(Knife)
		end
	else 
		if DeltaTicks(LastAttackTime) > Behavior.ReloadDelay then
			if CanUseWeapon(Rifle, false) and NeedReloadWeapon(Rifle) and CanReload() then
				ChooseWeapon(Rifle)
			elseif CanUseWeapon(Pistol, false) and NeedReloadWeapon(Pistol) and CanReload() then
				ChooseWeapon(Pistol)
			else
				ChooseWeapon(Knife)
			end
		end
	end
end