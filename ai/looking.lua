
function Looking()
	if HasEnemiesNear and ((IsReloading() and Behavior.AimWhenReloading) or not IsReloading()) then		
		LookAtEx(NearestEnemy)
		return
	end
	
	if HasNavigation() then
		ObjectiveLooking()
	else
		PrimitiveLooking()
	end
	
	LookAtEx(LookingPoint.X, LookingPoint.Y, LookingPoint.Z)
end

function PrimitiveLooking()
	V = Vec3.New(GetVelocity())
		
	if V.Length == 0 then
		return
	end
	
	LookingPoint = Origin + V
end

function ObjectiveLooking()
	if not HasChain() then
		return
	end
	
	if not IsAreaChanged then
		return
	end
	
	ViewArea = nil
	
	for I = 0, NavAreaGetField(Area, NavAreaField.ApproachesCount) - 1 do
		for J = #Chain, ChainIndex, -1 do
			A = NavAreaApproachGetField(Area, I, NavApproachField.Here)
			
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

	LookingPoint = Vec3.New(NavAreaGetField(ViewArea, NavAreaField.Center)) + Vec3.New(0, 0, MyHeight())
end











