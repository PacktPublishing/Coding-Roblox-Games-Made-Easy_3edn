local playerService = game:GetService("Players")
local dataService = game:GetService("DataStoreService")
local store = dataService:GetDataStore("DataStoreV1")
local teleportService = game:GetService("TeleportService")

local sessionData = {}
local dataMod = {}
local AUTOSAVE_INTERVAL = 120

local defaultData = {
	Coins = 0;
	Stage = 1;
}

dataMod.load = function(player)
	local key = player.UserId

	local success, data = shared.mod("Utilities").promiseReturn(1, function()
		return store:GetAsync(key)
	end)

	if not success then
		teleportService:Teleport(game.PlaceId, player)
		return
	end

	player:SetAttribute("DataLoaded", true)

	return data
end

dataMod.setupData = function(player)
	local key = player.UserId
	local data = dataMod.load(player)

	sessionData[key] = shared.mod("Utilities").recursiveCopy(defaultData)

	if data then
		for index, value in data do
			print(index, value)
			dataMod.set(player, index, value)
		end

		print(player.Name.. "'s data has been loaded!")
	else
		print(player.Name.. " is a new player!")
	end
end

playerService.PlayerAdded:Connect(function(player)
	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"
	folder.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Parent = folder
	coins.Value = defaultData.Coins

	local stage = Instance.new("IntValue")
	stage.Name = "Stage"
	stage.Parent = folder
	stage.Value = defaultData.Stage

	dataMod.setupData(player)
end)

dataMod.set = function(player, stat, value)
	local key = player.UserId
	sessionData[key][stat] = value

	local statVal = player.leaderstats:FindFirstChild(stat)

	if statVal then
		statVal.Value = value
	end
end

dataMod.increment = function(player, stat, value)
	local key = player.UserId
	sessionData[key][stat] = dataMod.get(player, stat) + value

	local statVal = player.leaderstats:FindFirstChild(stat)

	if statVal then
		statVal.Value = sessionData[key][stat]
	end
end

dataMod.get = function(player, stat)
	local key = player.UserId
	return sessionData[key][stat]
end

dataMod.save = function(player)
	if not player:GetAttribute("DataLoaded") then
		return
	end

	local key = player.UserId
	local data = shared.mod("Utilities").recursiveCopy(sessionData[key])

	local success, err = shared.mod("Utilities").promiseReturn(1, function()
		store:SetAsync(key, data)
	end)

	if success then
		print(player.Name.. "'s data has been saved!")
	else
		warn("Failed to save data for".. player.Name)
	end
end

dataMod.removeSessionData = function(player)
	local key = player.UserId
	sessionData[key] = nil
end

playerService.PlayerRemoving:Connect(function(player)
	dataMod.save(player)
	dataMod.removeSessionData(player)
end)


local function autoSave()
	while task.wait(AUTOSAVE_INTERVAL) do
		print("Auto-saving data for all players")

		for key, dataTable in sessionData do
			local player = playerService:GetPlayerByUserId(key)
			dataMod.save(player)
		end
	end
end

task.spawn(autoSave) --Initialize autosave loop

game:BindToClose(function()
	for _, player in playerService:GetPlayers() do
		dataMod.save(player)
		player:Kick("Shutting down game. All data saved.")
	end
end)

return dataMod