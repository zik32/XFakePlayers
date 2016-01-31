
function Tasks()
	BuyWeapons()
	PlantBomb()
	DefuseBomb()
	DestroyBreakables() 
	
	-- TODO: add health & armor recharging stations using in HL
	-- TODO: add hostages using in CS, CZ
	
	
end

function BuyWeapons()
	if not IsSlowThink then
		return
	end
	
	if not NeedToBuyWeapons then
		return
	end
	
	if (GetGameDir() ~= "cstrike") and (GetGameDir() ~= "czero") then
		return
	end

	Icon = FindStatusIconByName("buyzone") -- also, we can using world to find buyzone
	
	if Icon == nil then
		return
	end
	
	if GetStatusIconStatus(Icon) == 0 then -- byuzone icon is not on screen
		return
	end
	
	ExecuteCommand("autobuy")
	
	NeedToBuyWeapons = false
end

function PlantBomb()
	if not IsSlowThink and not IsPlantingBomb then
		return
	end
	
	IsPlantingBomb = false

	if (GetGameDir() ~= "cstrike") and (GetGameDir() ~= "czero") then	
		return
	end
	
	Icon = FindStatusIconByName("c4") -- also, we can using world to find c4 zone
	
	if Icon == nil then
		return
	end
	
	if GetStatusIconStatus(Icon) ~= 2 then -- c4 icon is not flashing
		return
	end

	IsPlantingBomb = true

	if Behavior.DuckWhenPlantingBomb then
		Duck()
	end
	
	if GetWeaponAbsoluteIndex() ~= CS_WEAPON_C4 then
		ChooseWeapon(GetWeaponByAbsoluteIndex(CS_WEAPON_C4))
	else
		PrimaryAttack() 
	end
end

function DefuseBomb()
	if not IsSlowThink and not IsDefusingBomb then
		return
	end

	IsDefusingBomb = false

	if (GetGameDir() ~= "cstrike") and (GetGameDir() ~= "czero") then	
		return
	end
	
	if GetPlayerTeam(GetClientIndex()) ~= "CT" then
		return
	end
	
	Entity = FindActiveEntityByModelName("models/w_c4")
	
	if Entity == nil then
		return
	end
	
	if GetGroundedDistance(Entity) > 50 then
		return 
	end

	IsDefusingBomb = true

	LookAtEx(Entity)

	if Behavior.DuckWhenDefusingBomb then
		Duck()
	end

	if GetGroundedDistance(Entity) > 25 then
		MoveTo(Entity)
	end

	PressButton(Button.USE)
end

function DestroyBreakables()
	if not IsSlowThink then
		return
	end
	
	if not HasWorld() then
		return
	end
	
	-- TODO: we need to destroy objects only when this objects prevent our path
	
	NeedToDestroy = false
	
	Distance = MAX_UNITS

	for I = 0, GetEntitiesCount() - 1 do
		if IsEntityActive(I) then
			R = FindResourceModelByIndex(GetEntityModelIndex(I))
			
			if R ~= nil then
				S = GetResourceName(R)
				
				if string.sub(S, 1, 1) == "*" then
					E = GetWorldEntity("model", GetResourceName(R))
				
					if E ~= nil then
						if GetWorldEntityField(E, "classname") == "func_breakable" then 
							if GetWorldEntityField(E, "spawnflags") == "" then -- TODO: add extended flag checking 
								
								-- TODO: add entity health checking here
								-- 		 try to break only if health less or equals 200
								
								J = tonumber(string.sub(S, 2))
								
								C = GetModelGabaritesCenter(J)
								
								-- TODO: add explosion radius checking here
								
								-- TODO: add Behavior.DestroyExplosions
								
								if (GetDistance(Vec3Unpack(C)) < Distance) and IsVisible(Vec3Unpack(C)) then
									BreakablePosition = C
									NeedToDestroy = true
									Distance = GetDistance(Vec3Unpack(C))
								end	
							end
						end
					end
				end
			end
		end
	end
end