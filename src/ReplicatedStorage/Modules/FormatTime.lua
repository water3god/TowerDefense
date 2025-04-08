--!strict

-- By Wa1er_God --

return function(Time: number)
	local TimeVar: number = Time;

	local Hours = math.floor(TimeVar / 3600);
	TimeVar -= Hours * 3600;
	local Minutes = math.floor(TimeVar / 60);
	TimeVar -= Minutes * 60;
	local Seconds = math.round(TimeVar);

	if Hours == 0 then
		return string.format("%u:%s", Minutes, string.format("%0.2i", Seconds));
	end

	return string.format("%u:%s:%s", Hours, string.format("%0.2i", Minutes), string.format("%0.2i", Seconds));
end
