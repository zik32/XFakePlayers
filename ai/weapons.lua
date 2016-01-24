
function Weapons()
	ReloadCurrentWeapon()
	ChooseBestWeapon()
	BuyWeapons()
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

	if GetGameDir() == "valve" then
		ChooseBestWeapon_HL()
	elseif GetGameDir() == "cstrike" then
		ChooseBestWeapon_CS()
	elseif GetGameDir() == "czero" then
		ChooseBestWeapon_CS()
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

function BuyWeapons()
	if not NeedToBuyWeapons then
		return
	end
	
	if (GetGameDir() ~= "cstrike") and (GetGameDir() ~= "czero") then
		return
	end
	
	if not IsSlowThink then
		return
	end

	Icon = FindStatusIconByName("buyzone")
	
	if Icon == nil then
		return
	end
	
	if GetStatusIconStatus(Icon) == 0 then
		return
	end
	
	ExecuteCommand("autobuy")
	
	NeedToBuyWeapons = false
end