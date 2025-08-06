--!strict

-- By Wa1er_God --

-- Services --

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Network.Server)
local OwnedGamepasses = Network.OwnedGamepasses
local UseProduct = Network.UseProduct
local SendWarning = Network.SendWarning

local Shared = ReplicatedStorage.Shared
local ProductInfo = require(Shared.ProductInfo)
local GiftIds = ProductInfo.GiftIds

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Products: { [number]: (Data: PlayerData.PlayerData) -> boolean } = {
	[3348441372] = function(Data: PlayerData.PlayerData): boolean
		Data:AddGold(1000)
		return true
	end,
	[3348441586] = function(Data: PlayerData.PlayerData): boolean
		Data:AddGold(2000)
		return true
	end,
	[3348442115] = function(Data: PlayerData.PlayerData): boolean
		Data:AddGold(5000)
		return true
	end,
	[3348442394] = function(Data: PlayerData.PlayerData): boolean
		Data:AddGold(20000)
		return true
	end,
	[3348443298] = function(Data: PlayerData.PlayerData): boolean
		Data:AddGold(100000)
		return true
	end,
	[3359651817] = function(Data: PlayerData.PlayerData): boolean
		Data:AddBoost("2x Luck", 3600)
		return true
	end,
	[3359652520] = function(Data: PlayerData.PlayerData): boolean
		Data:AddBoost("3x Luck", 3600)
		return true
	end,
	[3359654911] = function(Data: PlayerData.PlayerData): boolean
		Data:AddResource("Omen Coins", 10)
		return true
	end,
	[3359655092] = function(Data: PlayerData.PlayerData): boolean
		Data:AddResource("Omen Coins", 50)
		return true
	end,
	[3359656288] = function(Data: PlayerData.PlayerData): boolean
		Data:AddResource("Omen Coins", 100)
		return true
	end,
	[3359656647] = function(Data: PlayerData.PlayerData): boolean
		Data:AddResource("Omen Coins", 1000)
		return true
	end,
}

local Gamepasses: { [number]: (Data: PlayerData.PlayerData) -> () } = {}

type ReceiptInfo = {
	PurchaseId: number,
	PlayerId: number,
	ProductId: number,
	PlaceIdWherePurchased: number,
	CurrencySpent: number,
	CurrencyType: Enum.CurrencyType,
	ProductPurchaseChannel: Enum.ProductPurchaseChannel,
}

MarketplaceService.ProcessReceipt = function(ReceiptInfo: ReceiptInfo): Enum.ProductPurchaseDecision
	local Player = Players:GetPlayerByUserId(ReceiptInfo.PlayerId)

	if Player then
		local Data = PlayerData.GetPlayerData(Player)

		if Data then
			local ProductFunc = Products[ReceiptInfo.ProductId]

			if ProductFunc then
				local Success = ProductFunc(Data)

				if Success then
					Data:AddRobuxSpent(ReceiptInfo.CurrencySpent)
					Data.Profile:Save()
					return Enum.ProductPurchaseDecision.PurchaseGranted
				end
			else
				local GiftId = GiftIds[ReceiptInfo.ProductId]

				if GiftId then
					Data:AddProduct(GiftId)
					Data:AddRobuxSpent(ReceiptInfo.CurrencySpent)
					Data.Profile:Save()
					return Enum.ProductPurchaseDecision.PurchaseGranted
				else
					task.spawn(function()
						error(string.format("NO PRODUCT WITH ID: %u", ReceiptInfo.ProductId))
					end)
				end
			end
		end
	end

	return Enum.ProductPurchaseDecision.NotProcessedYet
end

UseProduct.SetCallback(function(Player: Player, ProductId: number, IsGamepass: boolean)
	if typeof(ProductId) ~= "number" or typeof(IsGamepass) ~= "boolean" then
		return
	end

	local Data = PlayerData.GetPlayerData(Player)

	if Data then
		if Data:HasProduct(ProductId, IsGamepass) then
			if IsGamepass then
				if Data:HasRedeemedGamepass(ProductId) then
					SendWarning.Fire(Player, "You have already redeemed this gamepass.", Color3.fromRGB(255, 0, 0))
					return
				end
				Data:RedeemGamepass(ProductId)
			else
				Data:RedeemProduct(ProductId)
			end
		end
	end
end)

local function OnPlayerData(Data: PlayerData.PlayerData)
	local ProfData = Data.Profile.Data

	for ProductId, _ in pairs(ProductInfo.GamepassInfo) do
		if Data:HasRedeemedGamepass(ProductId) and not table.find(ProfData.Gamepasses, ProductId) then
			table.insert(ProfData.Gamepasses, ProductId)
			Data.ProductRedeemed:Fire(ProductId, true)
		end
	end

	OwnedGamepasses.Fire(Data.Player, ProfData.Gamepasses)

	local function Redeem(ProductId: number)
		local Success = Products[ProductId](Data)
		if Success then
			if ProfData.CachedProducts[ProductId] == 1 then
				ProfData.CachedProducts[ProductId] = nil
			else
				ProfData.CachedProducts[ProductId] -= 1
			end
		end
		Data.Profile:Save()
	end

	if next(ProfData.CachedProducts) then
		for CachedProduct, Count in ipairs(ProfData.CachedProducts) do
			for _ = 1, Count, 1 do
				task.spawn(Redeem, CachedProduct)
			end
		end
	end

	Data.ProductRedeemed:Connect(function(ProductId: number, IsGamepass: boolean)
		if not IsGamepass then
			Redeem(ProductId)
		end
		local ProductData = ProductInfo.GetProductFromId({
			Id = ProductId,
			IsGamepass = IsGamepass,
		})
		if ProductData then
			local Message = if IsGamepass then "Gamepass" else "Product"
			SendWarning.Fire(
				Data.Player,
				string.format("%s %s has been successfully redeemed.", Message, ProductData.Name),
				Color3.fromRGB(0, 255, 0)
			)
		end
	end)
end

for _, Data in pairs(PlayerData.GetDatas()) do
	OnPlayerData(Data)
end
PlayerData.DataAdded:Connect(OnPlayerData)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(
	function(Player: Player, GamepassId: number, Purchased: boolean)
		if Purchased and MarketplaceService:UserOwnsGamePassAsync(Player.UserId, GamepassId) then
			local Data = PlayerData.GetPlayerData(Player)
			if Data then
				Data:RedeemGamepass(GamepassId)
			end
		end
	end
)
