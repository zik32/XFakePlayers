
function Look()
	if HasEnemiesNear and ((IsReloading() and Behavior.AimWhenReloading) or not IsReloading()) and not Idle then		
		LookAtEx(NearestEnemy)
		return
	end
	
	if NeedToDestroy then
		LookAtEx(Vec3Unpack(BreakablePosition))
		return
	end
	
	if HasNavigation() and not Idle then
		ObjectiveLook()
	else
		PrimitiveLook()
	end
	
	LookAtEx(Vec3Unpack(LookPoint))
end

function PrimitiveLook()
	V = Vec3.New(GetVelocity())
		
	if Vec3Length(V) == 0 then
		return
	end
	
	LookPoint = Origin + V
end

function ObjectiveLook()
	if not HasChain() then
		return
	end
	
	if not IsAreaChanged then
		return
	end
	
	ViewArea = nil
	
	for I = 0, GetNavAreaApproachesCount(Area) - 1 do
		for J = #Chain, ChainIndex, -1 do
			A = GetNavAreaApproachHere(Area, I)
			
			if A == Chain[J] then
				ViewArea = A
				break
			end
		end
		
		if ViewArea ~= nil then
			break
		end
	end
	
	if ViewArea == nil then
		if #Chain > ChainIndex + OBJECTIVE_LOOKING_AREA_OFFSET then
			ViewArea = Chain[ChainIndex + OBJECTIVE_LOOKING_AREA_OFFSET]
		else
			ViewArea = Chain[#Chain]
		end
	end

	LookPoint = Vec3.New(GetNavAreaCenter(ViewArea)) + Vec3.New(0, 0, MyHeight())
end