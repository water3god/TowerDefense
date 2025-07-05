--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local Promise = require(Packages.Promise)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local AllEquipped = require(GlobalClient.AllEquipped)

local Gui = ReplicatedStorage.Gui
local GameFrames = Gui.GameFrames
local DisplayTitle = require(GameFrames.DisplayTitle)

local function HandleCharacter(Player: Player, Character: Model)
	local Cancel = function() end

	local CharPromise = Promise.try(function()
		return Character:WaitForChild("HumanoidRootPart") :: BasePart
	end)
		:andThen(function(RootPart: BasePart)
			local Billboard = Instance.new("BillboardGui")
			Billboard.Name = "DisplayTitleGui"
			Billboard.Adornee = RootPart
			Billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			Billboard.Size = UDim2.fromScale(5, 5)
			Billboard.StudsOffsetWorldSpace = Vector3.new(0, 4, 0)
			Billboard.Parent = RootPart

			return Billboard
		end)
		:andThen(function(Billboard: BillboardGui)
			local Data = AllEquipped.Equipped[Player]

			if Data then
				return Billboard, Data
			else
				return Billboard, AllEquipped.GetChangedSignal(Player):Wait()
			end
		end)
		:andThen(function(Billboard: BillboardGui, Data: AllEquipped.DataSent)
			local Root = ReactRoblox.createRoot(Billboard)

			local function ReRender(NewData: AllEquipped.DataSent)
				Root:render(e(DisplayTitle, {
					Name = Player.Name,
					Level = NewData.Level,
					Title = NewData.Title,
					native = {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
					},
				}))
			end

			ReRender(Data)

			local Connection = AllEquipped.GetChangedSignal(Player):Connect(ReRender)

			Cancel = function()
				Connection:Disconnect()
				Root:unmount()
				Billboard:Destroy()
			end
		end)

	Character.Destroying:Once(function()
		CharPromise:cancel()
		Cancel()
	end)
end

local function HandlePlayer(Player: Player)
	if Player.Character then
		HandleCharacter(Player, Player.Character)
	end
	Player.CharacterAdded:Connect(function(Character)
		HandleCharacter(Player, Character)
	end)
end

for _, Player in pairs(Players:GetPlayers()) do
	HandlePlayer(Player)
end

Players.PlayerAdded:Connect(HandlePlayer)
