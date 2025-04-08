-- By Wa1er_God --

local x = game.StarterPlayer.StarterPlayerScripts.InventoryClient; -- Script;
local Split = x.Source:split("\n");

local Count = 0;

for _, S in ipairs(Split) do
	local Index = S:find("local")
	if Index == 1 then
		Count += 1 print(S)
	end 
end

print(Count)