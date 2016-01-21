function Chance(Percent)
	return math.random(100) < Percent
end

function DeltaTicks(ATicks)
	return Ticks() - ATicks
end