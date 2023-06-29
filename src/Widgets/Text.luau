--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

return FusionPlasma.wrap(require(Components.Display.Text), function(text: string, children: (() -> ())?)
	return { Text = text }, children
end, { Text = "" })
