
function Tasks()
	BuyWeapons()
	PlantBomb()
	DefuseBomb()
	DestroyBreakables() 
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
	
	if GetStatusIconStatus(Icon) == 0 then
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
	
	if GetStatusIconStatus(Icon) ~= 2 then
		return
	end

	IsPlantingBomb = true

	if Behavior.DuckWhenPlantingBomb then
		Duck()
	end
	
	if GetWeaponAbsoluteIndex() ~= CS_WEAPON_C4 then
		ChooseWeapon(GetWeaponByAbsoluteIndex(CS_WEAPON_C4))
	else
		PrimaryAttack() -- planting
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
	
	if Entity == -1 then
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
	
	NeedToDestroy = false
	
	Distance = MAX_UNITS

	for I = 0, GetEntitiesCount() - 1 do
		if IsEntityActive(I) then
			R = FindResourceModelByIndex(GetEntityModelIndex(I))
			
			if R ~= -1 then
				S = GetResourceName(R)
				
				if string.sub(S, 1, 1) == "*" then
					E = GetWorldEntity("model", GetResourceName(R))
				
					if E ~= -1 then
						if GetWorldEntityField(E, "classname") == "func_breakable" then 
							if GetWorldEntityField(E, "spawnflags") == "" then -- TODO: add extended flag checking 
								J = tonumber(string.sub(S, 2))
								
								MinS = Vec3.New(GetWorldModelMinS(J))
								MaxS = Vec3.New(GetWorldModelMaxS(J))
								
								D = Vec3Line.New(MinS.X, MinS.Y, MinS.Z, MaxS.X, MaxS.Y, MaxS.Z)
								C = Vec3LineCenter(D)
								
								-- TODO: add explosion radius checking here
								
								if (GetDistance(C.X, C.Y, C.Z) < Distance) and IsVisible(C.X, C.Y, C.Z) then
									BreakablePosition = C
									NeedToDestroy = true
									Distance = GetDistance(C.X, C.Y, C.Z)
								end	
							end
						end
					end
				end
			end
		end
	end
end