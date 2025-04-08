--!strict

-- By Wa1er_God --

local Players = game:GetService("Players");

local SafePlayerAdded = {};

local Connections: {[string]: RBXScriptConnection} = {};

function SafePlayerAdded:Connect(Callback: (Player: Player) -> (), RunBefore: boolean?, Name: string?)
	if RunBefore then
		for _, Player in ipairs(Players:GetPlayers()) do
			Callback(Player);
		end
	end
	
	if typeof(Name) == "string" then
		Connections[Name] = Players.PlayerAdded:Connect(function(Player: Player)
			Callback(Player);
		end)
	else
		Players.PlayerAdded:Connect(function(Player: Player)
			Callback(Player);
		end)
	end
end

function SafePlayerAdded:Once(Callback: (Player: Player) -> ())
	Players.PlayerAdded:Once(Callback);
end

function SafePlayerAdded:Wait()
	Players.PlayerAdded:Wait();
end

function SafePlayerAdded:Disconnect(Name: string)
	if typeof(Name) == "string" then
		if Connections[Name] then
			Connections[Name]:Disconnect();
			Connections[Name] = nil;
		end
	end
end

return SafePlayerAdded
