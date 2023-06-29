--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

type ButtonHandle = (
	text: string,
	options: { disabled: boolean }?
) -> { clicked: (any) -> boolean, pressed: (any) -> boolean }

return FusionPlasma.wrap(require(Components.Interactable.Button), function(text, options)
	options = options or { disabled = false }
	return {
		Text = text,
		Disabled = options.disabled,
	}
end, {}) :: ButtonHandle
