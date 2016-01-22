function Movement()
	if Behavior.CrouchWhenShooting and IsAttacking() then
		Duck()
	end
	
	if not Behavior.MoveWhenShooting and IsAttacking() then
		return
	end

	if not Behavior.MoveWhenReloading and IsReloading() then
		return
	end
	
	if HasNavigation() then
		ObjectiveMovement()
	else
		PrimitiveMovement()		
	end
	
	if HasFriendsNear and (GetDistance(NearestFriend) < 50) and IsPlayerPriority(NearestFriend) then
		MoveOut(NearestFriend)
	end
end

function PrimitiveMovement()
	if HasFriendsNear and IsPlayerPriority(NearestFriend) then
		if GetDistance(NearestFriend) > 200 then
			MoveTo(NearestFriend)
		end
	end
	
	if HasEnemiesNear then
		if GetDistance(NearestEnemy) > 200 then
			MoveTo(NearestEnemy)
		end		
	end
end

function ObjectiveMovement()
	if GetMaxSpeed() <= 1 then
		return
	end
	
	A = NavGetArea(GetGroundedOrigin()) 
	IsAreaChanged = Area ~= A
	
	if IsAreaChanged then
		PrevArea = Area
		Area = A
	end
	
	if NavAreaGetField(Area, NavAreaField.Flags) & NAV_AREA_CROUCH > 0 then
		Duck()
	end
	
	
	-- scenario case here
	
	--RandomWalking()
	ObjectiveWalking()
end

function ResetObjectiveMovement()
	Chain = {}
	ChainIndex = 1
end

function ResetStuckMonitor()
	StuckWarnings = 0
end

function CheckStuckMonitor()
	if not IsSlowThink then
		return
	end
	
	if DeltaTicks(LastStuckCheckTime) >= SLOWTHINK_PERIOD * 2 then
		ResetStuckMonitor()
	end
	
	LastStuckCheckTime = Ticks()
	
	if IsCrouching() then
		Divider = 4
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
			if NavAreaIsConnected(Area, Next) then			
				if ChainIndex == #Chain then
					BestPoint = ChainFinalPoint
				else
					for I = ChainIndex, #Chain - 1 do
						Finished = false
						
						if NavAreaIsConnected(Chain[I], Chain[I + 1]) then
							Portal = Vec3.New(NavAreaGetPortal(Chain[I], Chain[I + 1]))
						else
							BestPoint = Vec3.New(NavAreaGetField(Next, NavAreaField.Center))
							break
						end
						
						Path = Vec2Line.New(Origin.X, Origin.Y, Portal.X, Portal.Y)
						
						for J = ChainIndex + 1, I do
							Window = Vec3Line.New(NavAreaGetWindow(Chain[J - 1], Chain[J]))
							
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
				
				Portal = Vec3.New(NavAreaGetPortal(Area, Next, Origin.X, Origin.Y, Origin.Z, BestPoint.X, BestPoint.Y, BestPoint.Z))
				
				if GetDistance2D(Portal.X, Portal.Y, Portal.Z) > HUMAN_WIDTH + HUMAN_WIDTH_HALF then
					MoveTo(Portal.X, Portal.Y, Portal.Z)
				else 
					MoveTo(BestPoint.X, BestPoint.Y, BestPoint.Z)
					
					if (not NavAreaIsBiLinked(Area, Next) and (NavAreaGetField(Area, NavAreaField.Flags) & NAV_AREA_NO_JUMP == 0))
					or (NavAreaGetField(Next, NavAreaField.Flags) & NAV_AREA_JUMP > 0)
					or (NavAreaGetField(Area, NavAreaField.Flags) & NAV_AREA_JUMP > 0) then
						SlowDuckJump()
					end
					
					if NavAreaGetField(Next, NavAreaField.Flags) & NAV_AREA_CROUCH > 0 then
						Duck()
					end 
				end
			else
				if IsSlowThink and IsOnGround() then
					return false
				else
					V = Vec3.New(NavAreaGetField(Next, NavAreaField.Center))
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
	
	Chain = {NavGetChain(Area, ADestinationArea)}
	
	--Chain = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27}
	
	--[[Chain = {
		NavGetAreaByIndex(22),
		NavGetAreaByIndex(1787),
		NavGetAreaByIndex(14),
		NavGetAreaByIndex(13),
		NavGetAreaByIndex(280),
		NavGetAreaByIndex(48),
		NavGetAreaByIndex(1809),
		NavGetAreaByIndex(93),
		NavGetAreaByIndex(228),
		NavGetAreaByIndex(15),
		NavGetAreaByIndex(43),
		NavGetAreaByIndex(2318),
		NavGetAreaByIndex(2283),
		NavGetAreaByIndex(2284),
		NavGetAreaByIndex(283),
		NavGetAreaByIndex(29)
	}]]
	
	if HasChain() then
		ChainFinalPoint = Vec3.New(NavAreaGetField(ADestinationArea, NavAreaField.Center))
		print(AHintText .. NavAreaGetField(ADestinationArea, NavAreaField.TextName))
		
		return true
	else
		return false
	end
end

function RandomWalking()
	if not MoveOnChain() then
		ResetObjectiveMovement()
		ResetStuckMonitor()
		Chain[1] = NavAreaGetRandomConnection(Area)
		ChainFinalPoint = Vec3.New(NavAreaGetField(Chain[1], NavAreaField.Center))
	end
end

function ObjectiveWalking()
	if not MoveOnChain() then
		BuildChain("walking to ", NavGetRandomArea())
	end
end