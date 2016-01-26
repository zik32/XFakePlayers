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
	
	if HasNavigation() and not Idle then
		ObjectiveMovement()
	else
		PrimitiveMovement()		
	end
		
	if HasFriendsNear and (GetDistance(NearestFriend) < 50) --[[and IsPlayerPriority(NearestFriend)]] then
		MoveOut(NearestFriend)
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
	
	if Scenario == ScenarioType.None then
		UpdateScenario()
	elseif Scenario == ScenarioType.Walking then
		ObjectiveWalking()
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
	
	if GetDistance(StuckOrigin.X, StuckOrigin.Y, StuckOrigin.Z) < GetMaxSpeed() / Divider then 
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
		if GetGroundedDistance(ChainFinalPoint.X, ChainFinalPoint.Y, ChainFinalPoint.Z) > HUMAN_WIDTH then
			MoveTo(ChainFinalPoint.X, ChainFinalPoint.Y, ChainFinalPoint.Z)
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
				
				if GetDistance2D(Portal.X, Portal.Y, Portal.Z) > HUMAN_WIDTH + HUMAN_WIDTH_HALF then
					MoveTo(Portal.X, Portal.Y, Portal.Z)
				else 
					MoveTo(BestPoint.X, BestPoint.Y, BestPoint.Z)
					
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
					V = Vec3.New(GetNavAreaCenter(Next))
					MoveTo(V.X, V.Y, V.Z)
				end
			end
		end
	end
	
	return true
end

function BuildChain(AHintText, ADestinationArea)
	ResetObjectiveMovement()
	ResetStuckMonitor()
	
	Chain = {GetNavChain(Area, ADestinationArea)}
	
	if HasChain() then
		ChainFinalPoint = Vec3.New(GetNavAreaCenter(ADestinationArea))
		print(AHintText .. GetNavAreaName(ADestinationArea))
		
		return true
	else
		return false
	end
end

function ObjectiveWalking()
	if not MoveOnChain() then
		BuildChain("walking to ", GetRandomNavArea())
	end
end