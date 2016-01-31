function Movement()
	if IsAttacking() then
		ResetStuckMonitor()
	end
	
	if Behavior.CrouchWhenShooting and IsAttacking() and not NeedToDestroy then
		Duck()
	end
	
	if not Behavior.MoveWhenShooting and IsAttacking() then
		return
	end

	if not Behavior.MoveWhenReloading and IsReloading() and IsAttacking() then
		return
	end
	
	if IsPlantingBomb then
		return
	end
	
	if IsDefusingBomb then
		return
	end
	
	if HasNavigation() and not Idle then
		ObjectiveMovement()
	else
		PrimitiveMovement()		
	end
		
	if not Idle then
		if HasFriendsNear and (GetDistance(NearestFriend) < 50) then
			MoveOut(NearestFriend)
		end
	else
		if HasPlayersNear and (GetDistance(NearestPlayer) < 50) then
			MoveOut(NearestPlayer)
		end
	end
end

function PrimitiveMovement()
	if HasPlayersNear then
		if GetDistance(NearestPlayer) > 200 then
			MoveTo(NearestPlayer)
		end
	end
end

function ObjectiveMovement()
	if GetMaxSpeed() <= 1 then
		return
	end
	
	A = GetNavArea() 
	IsAreaChanged = Area ~= A
	
	if IsAreaChanged then
		PrevArea = Area
		Area = A
	end
	
	if GetNavAreaFlags(Area) & NAV_AREA_CROUCH > 0 then
		Duck()
	end
	
	if IsSlowThink then
		UpdateScenario()
	end
	
	if Scenario ~= ChainScenario then
		ResetObjectiveMovement()
	end
	
	if Scenario == ScenarioType.Walking then
		ObjectiveWalking()
	elseif Scenario == ScenarioType.PlantingBomb then
		ObjectivePlantingBomb()
	elseif Scenario == ScenarioType.DefusingBomb then
		ObjectiveDefusingBomb()
	elseif Scenario == ScenarioType.SearchingBomb then
		ObjectiveSearchingBomb()
	else
		print("ObjectiveMovement: unknown scenario " .. Scenario)
	end
end

function ResetObjectiveMovement()
	Chain = {}
	ChainIndex = 1
end

function ResetStuckMonitor()
	StuckWarnings = 0
end

function CheckStuckMonitor()
	if DeltaTicks(LastStuckMonitorTime) < STUCK_CHECK_PERIOD then
		return
	end
	
	LastStuckMonitorTime = Ticks()
	
	if DeltaTicks(LastStuckCheckTime) >= STUCK_CHECK_PERIOD * 2 then
		ResetStuckMonitor()
	end
	
	LastStuckCheckTime = Ticks()
	
	if IsCrouching() then
		Divider = 5
	else
		Divider = 3
	end
	
	if GetDistance(Vec3Unpack(StuckOrigin)) < GetMaxSpeed() / Divider then 
		StuckWarnings = StuckWarnings + 1
	else
		StuckWarnings = StuckWarnings - 1
		
		if TryedToUnstuck then
			UnstuckWarnings = UnstuckWarnings + 1
			
			if UnstuckWarnings >= 2 then
				TryedToUnstuck = false
			end
		else
			UnstuckWarnings = 0
		end
	end
	
	if StuckWarnings > 3 then
		StuckWarnings = 3
	end
	
	if StuckWarnings < 0 then
		StuckWarnings = 0
	end
	
	if StuckWarnings >= 3 then
		if TryedToUnstuck then
			ResetObjectiveMovement()
			TryedToUnstuck = false 
		else
			DuckJump()
			ResetStuckMonitor()
			TryedToUnstuck = true
		end
	end
	
	StuckOrigin = Origin
end

function MoveOnChain()
	CheckStuckMonitor()
	
	if not HasChain() then
		return false
	end

	if ChainIndex > #Chain then
		return false
	end
	
	for I = ChainIndex + 1, #Chain do
		if Area == Chain[I] then
			ChainIndex = I
			break
		end
	end
	
	Next = Chain[ChainIndex]
	Last = Chain[#Chain]
	
	if Area == Last then
		if GetGroundedDistance(Vec3Unpack(ChainFinalPoint)) > HUMAN_WIDTH then
			MoveTo(Vec3Unpack(ChainFinalPoint))
		else
			return false
		end
	else
		if Area == Next then
			ChainIndex = ChainIndex + 1
			MoveOnChain()
		else
			if IsNavAreaConnected(Area, Next) then			
				if ChainIndex == #Chain then
					BestPoint = ChainFinalPoint
				else
					for I = ChainIndex, #Chain - 1 do
						Finished = false
						
						if IsNavAreaConnected(Chain[I], Chain[I + 1]) then
							Portal = Vec3.New(GetNavAreaPortal(Chain[I], Chain[I + 1]))
						else
							BestPoint = Vec3.New(GetNavAreaCenter(Next))
							break
						end
						
						Path = Vec2Line.New(Origin.X, Origin.Y, Portal.X, Portal.Y)
						
						for J = ChainIndex + 1, I do
							Window = Vec3Line.New(GetNavAreaWindow(Chain[J - 1], Chain[J]))
							
							if not IsVecLinesIntersectedIn2D(Window, Path) then
								Finished = true
								break
							end
						end
						
						if Finished then
							break
						end
						
						BestPoint = Portal
					end
				end
				
				Portal = Vec3.New(GetNavAreaPortal(Area, Next, Origin.X, Origin.Y, Origin.Z, BestPoint.X, BestPoint.Y, BestPoint.Z))
				
				if GetDistance2D(Vec3Unpack(Portal)) > HUMAN_WIDTH + HUMAN_WIDTH_HALF then
					MoveTo(Vec3Unpack(Portal))
				else 
					MoveTo(Vec3Unpack(BestPoint))
					
					if ((GetNavAreaFlags(Area) & NAV_AREA_NO_JUMP == 0) and not IsNavAreaBiLinked(Area, Next)) -- to prevent erroneous jumps - we need to add height comparing between two areas
					or (GetNavAreaFlags(Next) & NAV_AREA_JUMP > 0) -- area must be small for working, add checking for area sizes
					or (GetNavAreaFlags(Area) & NAV_AREA_JUMP > 0) then
						SlowDuckJump()
					end
					
					if GetNavAreaFlags(Next) & NAV_AREA_CROUCH > 0 then
						Duck()
					end 
				end
			else
				if IsSlowThink and IsOnGround() then
					return false
				else
					MoveTo(Vec3Unpack(Vec3.New(GetNavAreaCenter(Next))))
				end
			end
		end
	end
	
	return true
end

function BuildChain(AFinalPoint)
	ResetObjectiveMovement()
	ResetStuckMonitor()
	
	Chain = {GetNavChain(Area, GetNavArea(Vec3Unpack(AFinalPoint)))}
	
	if HasChain() then
		ChainFinalPoint = AFinalPoint
		ChainScenario = Scenario
		return true
	else	
		return false
	end
end

function BuildChainEx(AHintText, AFinalPoint)
	if BuildChain(AFinalPoint) then
		print(AHintText .. " " .. GetNavAreaName(Chain[#Chain]))

		return true
	else
		return false
	end
end

function BuildChainToArea(ADestinationArea)
	return BuildChain(Vec3.New(GetNavAreaCenter(ADestinationArea)))
end

function BuildChainToAreaEx(AHintText, ADestinationArea)
	return BuildChainEx(AHintText, Vec3.New(GetNavAreaCenter(ADestinationArea)))
end


function ObjectiveWalking()
	if not MoveOnChain() then
		BuildChainToAreaEx("walking to", GetRandomNavArea())
	end
end

function ObjectivePlantingBomb()
	if not IsWeaponExists(CS_WEAPON_C4) then
		return
	end
	
	if IsAreaChanged then
	--	AI_Area.Flags := AI_Area.Flags or NAV_AREA_PLANTER_MARK;
	end

	if not MoveOnChain() and IsSlowThink then
		if HasWorld() then
			E = GetWorldRandomEntityByClassName("func_bomb_target")

			if E == -1 then
				--do nav searching
				return
			end

			M = GetModelForEntity(E)
			
			if M == -1 then
				-- do nav searching
				return
			end
			
			C = GetModelGabaritesCenter(M)
			
			BuildChainEx("walking to bomb place at", C)
		else
			-- TODO: 
			-- we can find bomb places by navigation map:
			
			-- - we can randomly walk on every new nav area
			-- and finally reach bomb place (and remember this area)
			
			-- - we can use the nav place names list
			-- and find bomb place by BombplaceA, BombplaceB, BombplaceC fields (also remember it to some array)
			
			-- it is not 100% searching method to find bomb place
			-- but it can work without *.bsp
		end
	end
end

function ObjectiveDefusingBomb() 
	--[[if not IsBombPlanted then
		return
	end
	
	C4 = FindActiveEntityByModelName("models/w_c4")
	
	if not MoveOnChain() then
		if C4 ~= nil then
			O = Vec3.New(GetEntityOrigin(C4))
			BuildChainEx("walking to bomb at", O)
		else
			BuildChainToAreaEx("searching bomb at", GetAreaForSearching)
		end
	else
		if C4 ~= nil then
			O = Vec3.New(GetEntityOrigin(C4))
			
			if O ~= ChainFinalPoint then
				ResetObjectiveMovement()
			end
		end
	end]]
	
	-- fuck this !!!
	
	ObjectiveWalking()
end

function ObjectiveSearchingBomb()
	if not IsBombDropped then
		return
	end
	
	C4 = FindActiveEntityByModelName('models/w_backpack');
	
	if C4 ~= nil then
		O = Vec3.New(GetEntityOrigin(C4))
	else
		O = Vec3.New(GetBombStatePosition()) -- find bomb on radar
	end
	
	if not MoveOnChain() then
		BuildChainEx("searching bomb at", O)
	else
		if (O ~= ChainFinalPoint) and IsSlowThink then
			ResetObjectiveMovement()
		end
	end
end