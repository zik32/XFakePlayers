Vec3 = {}
Vec3.__index = Vec3

function Vec3.New(X, Y, Z)
  return setmetatable({X = X or 0, Y = Y or 0, Z = Z or 0}, Vec3)
end

function Vec3.__add(A, B)
	return Vec3.New(A.X + B.X, A.Y + B.Y, A.Z + B.Z)
end

function Vec3.__sub(A, B)
	return Vec3.New(A.X - B.X, A.Y - B.Y, A.Z - B.Z)
end

function Vec3.__mul(A, B)
	return Vec3.New(A.X * B.X, A.Y * B.Y, A.Z * B.Z)
end

function Vec3.__div(A, B)
	return Vec3.New(A.X / B.X, A.Y / B.Y, A.Z / B.Z)
end

function Vec3DotProduct(A, B)
  return((A.X * B.X) + (A.Y * B.Y) + (A.Z * B.Z))
end

function Vec3Length(V)
	return math.sqrt(Vec3DotProduct(V, V))
end

function Vec3.__tostring(A)
	return("X: " .. math.floor(A.X) .. ", Y: " .. math.floor(A.Y) .. ", Z: " .. math.floor(A.Z))
end

Vec2 = {}
Vec2.__index = Vec2

function Vec2.New(X, Y)
	return setmetatable({X = X or 0, Y = Y or 0}, Vec2)
end

function Vec2.__add(A, B)
	return Vec2.New(A.X + B.X, A.Y + B.Y)
end

function Vec2.__sub(A, B)
	return Vec2.New(A.X - B.X, A.Y - B.Y)
end

function Vec2.__mul(A, B)
	return Vec2.New(A.X * B.X, A.Y * B.Y)
end

function Vec2.__div(A, B)
	return Vec2.New(A.X / B.X, A.Y / B.Y)
end

function Vec2Length(V)
	return math.sqrt((X * X) + (Y * Y))
end

function Vec2.__tostring(A)
	return("X: " .. math.floor(A.X) .. ", Y: " .. math.floor(A.Y))
end

Vec3Line = {}
Vec3Line.__index = Vec3Line

function Vec3Line.New(HiX, HiY, HiZ, LoX, LoY, LoZ)
	return setmetatable({HiX = HiX or 0, HiY = HiY or 0, HiZ = HiZ or 0, LoX = LoX or 0, LoY = LoY or 0, LoZ = LoZ or 0}, Vec3Line)
end

function Vec3Line.__tostring(A)
	return("Hi: [X: " .. A.HiX .. ", Y: " .. A.HiY .. ", Z: " .. A.HiZ .. "], Lo [X: " .. A.LoX .. ", Y: " .. A.LoY .. ", Z: " .. A.LoZ .. "]") 
end

Vec2Line = {}
Vec2Line.__index = Vec2Line

function Vec2Line.New(HiX, HiY, LoX, LoY)
	return setmetatable({HiX = HiX or 0, HiY = HiY or 0, LoX = LoX or 0, LoY = LoY or 0}, Vec2Line)
end

function Vec2Line.__tostring(A)
	return("Hi: [X: " .. A.HiX .. ", Y: " .. A.HiY .. "], Lo [X: " .. A.LoX .. ", Y: " .. A.LoY .. "]") 
end

function IsVecLinesIntersectedIn2D(A, B)
	ADX = A.LoX - A.HiX
	ADY = A.LoY - A.HiY
	
	BDX = B.LoX - B.HiX
	BDY = B.LoY - B.HiY
	
	F1 = ADX * (B.HiY - A.HiY) - ADY * (B.HiX - A.HiX)
	F2 = ADX * (B.LoY - A.HiY) - ADY * (B.LoX - A.HiX)
	F3 = BDX * (A.HiY - B.HiY) - BDY * (A.HiX - B.HiX)
	F4 = BDX * (A.LoY - B.HiY) - BDY * (A.LoX - B.HiX)

	return ((F1 * F2 < 0) and (F3 * F4 < 0))	
end
















