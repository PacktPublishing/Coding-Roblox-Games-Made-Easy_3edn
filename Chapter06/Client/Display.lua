local replicatedStorage = game:GetService("ReplicatedStorage")
local gui = script.Parent.Parent
local message = replicatedStorage.Message
local remaining = replicatedStorage.Remaining
local display = {}

local topBar = gui:WaitForChild("TopBar")
local messageLabel = topBar:WaitForChild("Message")
local remainingLabel = topBar:WaitForChild("Remaining")

messageLabel.Text = message.Value
remainingLabel.Text = remaining.Value

message:GetPropertyChangedSignal("Value"):Connect(function()
	messageLabel.Text = message.Value
end)

remaining:GetPropertyChangedSignal("Value"):Connect(function()
	remainingLabel.Text = remaining.Value
end)

return display