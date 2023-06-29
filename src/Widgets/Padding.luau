--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

return FusionPlasma.wrap(require(Components.Decoration.Padding), function(padding: number)
	return { Padding = padding }
end, { Padding = 4 })
