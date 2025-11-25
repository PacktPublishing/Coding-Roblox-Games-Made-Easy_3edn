local playerService = game:GetService("Players")
local dataMod = shared.mod("Data")
local spawnParts = workspace.SpawnParts
local initializeMod = {}

local function getStage(stageNum)
	for _, stagePart in spawnParts:GetChildren() do
		if stagePart:GetAttribute("Stage") == stageNum then
			return stagePart
		end
	end
end

playerService.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		char:WaitForChild("HumanoidRootPart")
		initializeMod.givePremiumTools(player)
		local stageNum = dataMod.get(player, "Stage")
		local spawnPoint = getStage(stageNum)

		task.wait()
		char:PivotTo(spawnPoint.CFrame * CFrame.new(0,3,0))
	end)
end)

local marketService = game:GetService("MarketplaceService")
local monetization = shared.mod("Monetization")
local toolPasses = {}

initializeMod.givePremiumTools = function(player)
	for _, passId in toolPasses do
		local key = player.UserId
		local ownsPass = monetization.ownsPass(key, passId)
		local hasTag = player:HasTag(passId)

		if hasTag or ownsPass then
			monetization[passId](player)
		end
	end
end

return initializeMod