function Chance(Percent)
	return math.random(100) < Percent
end

function Ticks()
	return os.clock() * 1000
end

function DeltaTicks(ATicks)
	return Ticks() - ATicks
end