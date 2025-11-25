local starterGui = game:GetService("StarterGui")
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)


local physics = game:GetService("PhysicsService")

physics:RegisterCollisionGroup("Players")
physics:CollisionGroupSetCollidable("Players", "Players", false)

player.CharacterAdded:Connect(function(char)
	for _, part in char:GetDescendants() do
		if part:IsA("BasePart") then
			part.CollisionGroup = "Players"
		end
	end

	print(player.Name.. " added to group!")
end)


local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, typing)
	if typing then
		return
	end

	if input.KeyCode == Enum.KeyCode.E then
		print("Client pressed E!")
	end
end)