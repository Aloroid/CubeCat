--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

type ButtonHandle = (text: string, options: { disabled: boolean }) -> { clicked: (any) -> boolean }

return FusionPlasma.wrap(
	require(Components.Interactable.ImageButton),
	function(image)
		return {
			Image = image,
		}
	end,
	{}
) :: (image: string) -> { clicked: (any) -> boolean }
