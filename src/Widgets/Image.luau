--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

return FusionPlasma.wrap(require(Components.Display.Image), function(image: string)
	return { Image = image }
end, { Image = "" })
