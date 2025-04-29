--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Modules = ReplicatedStorage.Modules
local GenerateId = require(Modules.GenerateId)

local ListTemplate = script:WaitForChild("Container")
local ConfirmTemplate = script:WaitForChild("ConfirmFrame")

local Player = Players.LocalPlayer
local PlayerGui: typeof(ReplicatedStorage.CloneGui) & typeof(game:GetService("StarterGui")) = Player.PlayerGui

local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui")
local ConfirmStorage = GlobalGui.ConfirmStorage
local MainFrame = ConfirmStorage.MainFrame

type StoredData = {
	Frame: typeof(ConfirmTemplate),
	Func: (End: boolean?) -> (),
	Connections: { [string]: RBXScriptConnection },
}

local ConfirmData = {}
local ConfirmFrames: { [string]: StoredData } = {}

export type ConfirmInput = {
	Title: string,
	Description: string,
	YesText: string?,
	NoText: string?,
	ScaleMultiplier: number?,
	EndFunc: (End: boolean?) -> (), --true: yes, false: no, nil: closed;
	OnSide: boolean,
}

function ConfirmData.Create(Input: ConfirmInput)
	local ConfirmFrame = ConfirmTemplate:Clone()

	local Id = GenerateId.GenerateId()

	local InputStore: StoredData = {
		Frame = ConfirmFrame,
		Func = function(End: boolean?)
			--[[if Input.OnSide then
				
			end]]

			Input.EndFunc(End)
		end,
		Connections = {},
	}

	local ScaleMultiplier = Input.ScaleMultiplier or 1

	ConfirmFrame.TitleLabel.Text = Input.Title
	ConfirmFrame.DescriptionLabel.Text = Input.Description
	ConfirmFrame.NoButton.TextLabel.Text = Input.NoText or "No"
	ConfirmFrame.YesButton.TextLabel.Text = Input.YesText or "Yes"

	ConfirmFrame.NoButton.MouseButton1Click:Connect(function()
		ConfirmData.Close(Id, false)
	end)

	ConfirmFrame.YesButton.MouseButton1Click:Connect(function()
		ConfirmData.Close(Id, true)
	end)

	ConfirmFrame.CloseButton.MouseButton1Click:Connect(function()
		ConfirmData.Close(Id, nil)
	end)

	ConfirmFrame.UIScale.Scale = ScaleMultiplier

	TweenService:Create(
		ConfirmFrame.UIScale,
		TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{ Scale = 1.2 * ScaleMultiplier }
	):Play()

	if Input.OnSide then
		local Container = ListTemplate:Clone()

		ConfirmFrame.Size = UDim2.fromScale(1, 1)

		ConfirmFrame.Destroying:Once(function()
			Container:Destroy()
		end)

		ConfirmFrame.Parent = Container
		Container.Parent = MainFrame
	else
		ConfirmFrame.Parent = ConfirmStorage
	end

	ConfirmFrames[Id] = InputStore

	return ConfirmFrame, Id
end

function ConfirmData.Close(UniqueId: string, End: boolean?)
	if not ConfirmFrames[UniqueId] then
		return
	end

	local ConfirmFrame = ConfirmFrames[UniqueId].Frame
	local Tween = TweenService:Create(
		ConfirmFrame.UIScale,
		TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{ Scale = 1 }
	)

	task.spawn(ConfirmFrames[UniqueId].Func, End)
	local Frame = ConfirmFrames[UniqueId].Frame
	ConfirmFrames[UniqueId] = nil

	Tween.Completed:Once(function()
		Frame:Destroy()
	end)

	Tween:Play()
end

return ConfirmData
