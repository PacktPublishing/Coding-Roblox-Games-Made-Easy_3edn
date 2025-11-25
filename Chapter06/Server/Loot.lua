local replicatedStorage = game:GetService("ReplicatedStorage")
local lootSpawns = workspace.LootSpawns
local weaponFolder = replicatedStorage.Weapons
local random = Random.new()
local weapons = shared.mod("Weapons")
local loot = {}

local function makeWeaponModel(weapon)
	local weaponModel = Instance.new("Model")

	for _, child in weapon:GetDescendants() do
		if child:IsA("BasePart") then
			child.Parent = weaponModel
			child.Anchored = true
			child:ClearAllChildren()
		end
	end

	weapon:Destroy()

	return weaponModel
end

loot.spawnWeapons = function()
	for _, spawnPoint in lootSpawns:GetChildren() do
		local oldModel = spawnPoint:FindFirstChildOfClass("Model")
		if oldModel then
			oldModel:Destroy()
		end

		local weaponPool = weaponFolder:GetChildren()
		local randomIndex = random:NextInteger(1, #weaponPool)
		local weapon = weaponPool[randomIndex]:Clone()
		local weaponName = weapon.Name
		local weaponModel = makeWeaponModel(weapon)
		weaponModel.Parent = spawnPoint

		local primaryPart = Instance.new("Part")
		primaryPart.Anchored = true
		primaryPart.CanCollide = false
		primaryPart.Transparency = 1
		primaryPart.CFrame, primaryPart.Size = weaponModel:GetBoundingBox()
		primaryPart.Parent = weaponModel

		weaponModel.PrimaryPart = primaryPart
		local newCFrame = CFrame.new(spawnPoint.Position) * CFrame.new(0,2,0)
		weaponModel:PivotTo(newCFrame)

		primaryPart.Touched:Connect(function(hit)
			local player, char = weapons.playerFromHit(hit)
			if player and char then
				local tool = weaponFolder:FindFirstChild(weaponName):Clone()
				tool.Parent = player.Backpack
				char.Humanoid:EquipTool(tool)
				weaponModel:Destroy()
			end
		end)
	end
end

for _, spawnPoint in lootSpawns:GetChildren() do
	spawnPoint.Anchored = true
	spawnPoint.CanCollide = false
	spawnPoint.Transparency = 1
end

return loot