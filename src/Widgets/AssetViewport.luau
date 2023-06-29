--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

return FusionPlasma.wrap(require(Components.Display.AssetViewport), function(object: Instance, draggable: boolean?)
	return { Object = object, Draggable = draggable }
end, { Object = FusionPlasma.None, Draggable = false })
