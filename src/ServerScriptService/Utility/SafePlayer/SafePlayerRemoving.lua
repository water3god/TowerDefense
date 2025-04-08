--!strict

-- By Wa1er_God --

local Players = game:GetService("Players");

local SafePlayerRemoving = {};

local Connections: {[string]: RBXScriptConnection} = {};
local BindConnections: {[string]: boolean} = {};

function SafePlayerRemoving:Connect(Callback: (Player: Player) -> (), BindToClose: boolean?, Name: string?)
	if typeof(Name) == "string" then
		Connections[Name] = Players.PlayerRemoving:Connect(function(Player)
			Callback(Player);
		end)
		
		if BindToClose then
			BindConnections[Name] = true;
			
			game:BindToClose(function()
				if BindConnections[Name] then
					for _, Player in ipairs(Players:GetPlayers()) do
						Callback(Player)
					end
				end
			end)
		end
	else
		Players.PlayerRemoving:Connect(function(Player)
			Callback(Player);
		end)
		
		if BindToClose then
			game:BindToClose(function()
				for _, Player in ipairs(Players:GetPlayers()) do
					Callback(Player)
				end
			end)
		end
	end
end

function SafePlayerRemoving:Once(Callback: (Player: Player) -> ())
	Players.PlayerAdded:Once(Callback)
end

function SafePlayerRemoving:Wait()
	Players.PlayerAdded:Wait();
end

function SafePlayerRemoving:Disconnect(Name: string)
	if typeof(Name) == "string" then
		if Connections[Name] then
			Connections[Name]:Disconnect();
			Connections[Name] = nil;
		end
		
		if BindConnections[Name] then
			BindConnections[Name] = false;
		end
	end
end

return SafePlayerRemoving
