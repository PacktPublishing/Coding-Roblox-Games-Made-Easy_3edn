local playerService = game:GetService("Players")
local dataService = game:GetService("DataStoreService")
local insertService = game:GetService("InsertService")
local marketService = game:GetService("MarketplaceService")
local dataMod = shared.mod("Data")
local monetizationMod = {}

monetizationMod.insertTool = function(player, assetId)
	local asset = insertService:LoadAsset(assetId)
	local tool = asset:FindFirstChildOfClass("Tool")
	tool.Parent = player.Backpack
	asset:Destroy()
end

monetizationMod[000000] = function(player)
	--Speed coil
	monetizationMod.insertTool(player, 99119158)
end

monetizationMod[000000] = function(player)
	--Gravity coil
	monetizationMod.insertTool(player, 16688968)
end

monetizationMod[000000] = function(player)
	--Radio
	monetizationMod.insertTool(player, 212641536)
end

monetizationMod[000000] = function(player)
	--100 Coins
	dataMod.increment(player, "Coins", 100)
end

monetizationMod.ownsPass = function(userId, passId)
	local success, doesOwnPass = shared.mod("Utilities").promiseReturn(function()
		return marketService:UserOwnsGamePassAsync(userId, passId)
	end)

	if not success then
		warn("Couldn't determine if user owns pass")
	end

	return doesOwnPass 
end 

marketService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
	if wasPurchased then
		player:AddTag(gamePassId)
		monetizationMod[gamePassId](player)
	end
end)

local PurchaseHistory = dataService:GetDataStore("PurchaseHistory")

function marketService.ProcessReceipt(receiptInfo)
	local playerProductKey = receiptInfo.PlayerId .. ":" .. receiptInfo.PurchaseId
	if PurchaseHistory:GetAsync(playerProductKey) then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	local player = playerService:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	monetizationMod[receiptInfo.ProductId](player)

	shared.mod("Utilities").promiseReturn(1, function()
		PurchaseHistory:SetAsync(playerProductKey, true)
	end)

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

return monetizationMod