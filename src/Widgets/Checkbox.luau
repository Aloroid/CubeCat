--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

return FusionPlasma.wrap(require(Components.Interactable.Checkbox), function(text, options)
	return {
		Text = text,
		Checked = options.checked,
		Disabled = options.disabled,
	}
end, {
	Text = FusionPlasma.None,
	Checked = false,
	Disabled = false,
}) :: (
	text: string,
	options: { disabled: boolean, checked: boolean }
) -> { clicked: (any) -> boolean, checked: (any) -> boolean }
