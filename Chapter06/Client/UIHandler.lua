local modules = {}

shared.UIMod = function(moduleName)
	local module = script:FindFirstChild(moduleName)

	if modules[moduleName] then
		return modules[moduleName]
	elseif module then
		return require(module)
	else
		error("Module not found!")
	end
end

for _, module in script:GetChildren() do
	if module:IsA("ModuleScript") then
		task.spawn(function()
			modules[module.Name] = require(module)
		end)
	end
end