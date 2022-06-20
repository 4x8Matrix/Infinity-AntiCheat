local Settings = { }

Settings.DebugMode = true
Settings.MaxAngleRagdoll = 40
Settings.HumanoidStateMargin = 5

for _, module in script:GetChildren() do
	Settings[module.Name] = require(module)
end

return Settings