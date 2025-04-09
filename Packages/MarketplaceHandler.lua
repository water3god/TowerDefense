--!strict

-- By Wa1er_God --

-- Stop Using this its useless --

local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");

local Marketplace = {};
local Types: {[string]: string} = {
	["Premium"] = "Premium";
	["Gamepass"] = "Gamepass";
	["Subscription"] = "Subscription";
	["Product"] = "Product";
}

--first is for one product, second is to trigger when anything is purchased
local ProductOnlyFunctions: {[number]: (...any) -> any} = {
	[343435] = function()
		return "Success";
	end,
};
local PurchasedFunctions: {[number]: (...any) -> any} = {};

type ReceiptInfo = {
	PurchaseId: number;
	PlayerId: number;
	ProductId: number;
	PlaceIdWherePurchased: number;
	CurrencySpent: number;
	CurrencyType: number; -- Robux
};

if RunService:IsServer() then
	MarketplaceService.ProcessReceipt = function(Recipt: ReceiptInfo)
		local PurchaseId = Recipt.PurchaseId;
		local PlayerId = Recipt.PlayerId;
		local ProductId = Recipt.ProductId;
		local PlaceId = Recipt.PlaceIdWherePurchased;
		local CurrencySpent = Recipt.CurrencySpent;
		
		local Success = false;
		
		if ProductOnlyFunctions[ProductId] then
			local SuccessValue: string = ProductOnlyFunctions[ProductId](PlayerId, ProductId);
			if SuccessValue == "Success" then
				Success = true;
			end
		end
		
		for _, PurchaseFunction in ipairs(PurchasedFunctions) do
			local SuccessValue: string = PurchaseFunction(PlayerId, ProductId);
			if SuccessValue == "Success" then
				Success = true;
			end
		end
		
		if Success then
			return Enum.ProductPurchaseDecision.PurchaseGranted;
		else
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		end
	end
end

function Marketplace:PromptPurchase(ProductId: number, Type: string, Player: Player?)
	
	if RunService:IsServer() then
		
		if not Player then
			error(tostring(Player).."NoPlayerParameterProvided")
		end
	else
		Player = Players.LocalPlayer;
	end
	
	if not Types[Type] then
		error(tostring(Type).."PurchaseNotValidType")
	end

	if Type == "Premium" then
		MarketplaceService:PromptPremiumPurchase(Player);
	elseif Type == "Gamepass" then
		MarketplaceService:PromptGamePassPurchase(Player, ProductId);
	elseif Type == "Subscription" then
		MarketplaceService:PromptSubscriptionPurchase(Player, ProductId);
	elseif Type == "Product" then
		MarketplaceService:PromptProductPurchase(Player, ProductId);
	end
end

function Marketplace:AddCallBack(Callback: (any) -> any, ProductOnly: boolean)
	if RunService:IsClient() then
		return;
	end
	
	assert(typeof(Callback) == "function", "CallbackIsNotFunction");
	
	if ProductOnly then
		table.insert(ProductOnlyFunctions, Callback);
	else
		table.insert(PurchasedFunctions, Callback);
	end
end

return Marketplace
