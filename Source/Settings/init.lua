local Settings = { }

for _, module in script:GetChildren() do
	Settings[module.Name] = require(module)
end

return Settings