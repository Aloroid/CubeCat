--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

return FusionPlasma.wrap(require(Components.Decoration.Line), function(thickness: number)
	return { LineThickness = thickness }
end, { LineThickness = 2 })
