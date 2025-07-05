--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)

local Gui = ReplicatedStorage.Gui
local GameFrames = Gui.GameFrames
local DisplayTitle = require(GameFrames.DisplayTitle)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local SafePlayerAdded = require(ServerScriptService.Utility.SafePlayer.SafePlayerAdded)

local GlobalWorkspace = workspace.GlobalWorkspace
local CharacterFolder = GlobalWorkspace.Characters

local function HandleChar(Character: Model)
	for _, Descendant in ipairs(Character:GetDescendants()) do
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "Character"
		end
	end

	Character.DescendantAdded:Connect(function(Descendant: Instance)
		if Descendant:IsA("BasePart") then
			Descendant.CollisionGroup = "Character"
		end
	end)

	Character.Parent = CharacterFolder
end

local function HandleData(Character: Model, Data: PlayerData.PlayerData)
	task.spawn(function()
		local ProfileData = Data.Profile.Data

		local TitlePromise = Promise.try(function()
			return Character:WaitForChild("HumanoidRootPart") :: BasePart
		end):andThen(function(RootPart)
			local Billboard = Instance.new("BillboardGui")
			Billboard.Name = "DisplayTitleGui"
			Billboard.Adornee = RootPart
			Billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			Billboard.Size = UDim2.fromScale(5, 5)
			Billboard.StudsOffsetWorldSpace = Vector3.new(0, 4, 0)
			Billboard.Parent = RootPart

			local Root = ReactRoblox.createRoot(Billboard)
			Root:render(e(DisplayTitle, {
				Name = Data.Player.Name,
				Title = ProfileData.EquippedTitle,
				Level = ProfileData.Level,
			}))
			Character.Destroying:Once(function()
				Root:unmount()
			end)
		end)

		Character.Destroying:Once(function()
			TitlePromise:cancel()
		end)
	end)
end

SafePlayerAdded:Connect(function(Player: Player)
	if Player.Character then
		HandleChar(Player.Character)
	end
	Player.CharacterAdded:Connect(HandleChar)
end, true)

local function DataAdded(Data: PlayerData.PlayerData)
	local Player = Data.Player
	if Data then
		if Player.Character then
			HandleData(Player.Character, Data)
		end
		Player.CharacterAdded:Connect(function(Character: Model)
			HandleData(Character, Data)
		end)
	end
end

for _, Data in pairs(PlayerData.GetDatas()) do
	DataAdded(Data)
end

PlayerData.DataAdded:Connect(DataAdded)
