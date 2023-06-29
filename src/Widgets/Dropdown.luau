--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

return FusionPlasma.wrap(
	require(Components.Interactable.Dropdown),
	function(choices, selected)
		return {
			DropdownItems = choices,
			Selected = selected,
		}
	end,
	{
		DropdownItems = {},
		Selected = "",
	}
) :: (
		choices: { string },
		selected: string?
	) -> { current: (any) -> string, selected: (any, (selected: string) -> ()) -> () }
