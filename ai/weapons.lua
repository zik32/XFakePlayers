
function Weapons()
	ReloadCurrentWeapon()
	ChooseBestWeapon()
end

function ReloadCurrentWeapon()
	if not IsSlowThink then
		return
	end
	
	if not NeedReloadWeapon(CurrentWeapon) then
		return
	end
	
	if HasEnemiesNear then
		return
	end

	--if AI_DefusingBomb then
	--Exit;

	if IsReloading() then
		return
	end
	
	PressButton(Button.RELOAD);
end

function ChooseBestWeapon()
	if IsReloading() then
		return
	end

	if Modification == ModificationType.HalfLife then
		ChooseBestWeapon_HL()
	elseif Modification == ModificationType.CounterStrike then
		ChooseBestWeapon_CS()
	elseif Modification == ModificationType.ConditionZero then
		ChooseBestWeapon_CS()
	elseif Modification == ModificationType.DeathmatchClassic then
		ChooseBestWeapon_DMC()
	elseif Modification == ModificationType.TeamFortressClassic then
		ChooseBestWeapon_TFC()
	end
end

function ChooseBestWeapon_HL()

end

function ChooseBestWeapon_CS()
	Rifle = FindWeaponBySlot(CS_WEAPON_SLOT_RIFLE)
	Pistol = FindWeaponBySlot(CS_WEAPON_SLOT_PISTOL)
	Knife = FindWeaponBySlot(CS_WEAPON_SLOT_KNIFE)
	
	if HasEnemiesNear then
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
		if CanUseWeapon(Rifle, false) and NeedReloadWeapon(Rifle) and CanReload() then
			ChooseWeapon(Rifle)
		elseif CanUseWeapon(Pistol, false) and NeedReloadWeapon(Pistol) and CanReload() then
			ChooseWeapon(Pistol)
		else
			ChooseWeapon(Knife)
		end
	end
end

function ChooseBestWeapon_DMC()

end

function ChooseBestWeapon_TFC()

end