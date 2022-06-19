local Exploits = { }

for _, module in script:GetChildren() do
	Exploits[module.Name] = require(module)
end

return Exploits