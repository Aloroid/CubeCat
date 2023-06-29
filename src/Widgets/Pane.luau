--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

return FusionPlasma.wrap(require(Components.Decoration.Pane), function(name: string, children: () -> ())
	return { PaneText = name }, children
end, { PaneText = "" })
