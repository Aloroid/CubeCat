--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

return FusionPlasma.wrap(require(Components.Display.Markdown), function(text: string)
	return { Markdown = text }
end, { Markdown = "" })
