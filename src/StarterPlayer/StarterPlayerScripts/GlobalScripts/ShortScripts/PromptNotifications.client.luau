--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ExperinceNotificationService = game:GetService("ExperienceNotificationService")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

Promise.try(function()
	return ExperinceNotificationService:CanPromptOptInAsync()
end)
	:andThen(function(Enabled: boolean)
		if Enabled then
			ExperinceNotificationService:PromptOptIn()
		end
	end)
	:catch(function(err)
		warn("Error checking Experience Notification Service opt-in status: ", err)
	end)
