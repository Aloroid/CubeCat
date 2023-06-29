local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)

type TextInputHandle = {

	filter: (TextInputHandle, filter: (current: string) -> string) -> TextInputHandle,
	validate: (TextInputHandle, validator: (current: string) -> (boolean, string)) -> TextInputHandle,
	focuslost: (TextInputHandle) -> (boolean, boolean),
	text: (TextInputHandle, text: (text: string) -> ()) -> TextInputHandle,
}

type Options = {
	disabled: boolean?,
	multiLine: boolean?,
	errorLocation: "Bottom" | "Right" | "None"?,
}

return FusionPlasma.wrap(
	require(Components.Interactable.TextInput),
	function(text, options)
		options = options or {}
		return {
			Text = text,
			Disabled = options.disabled,
			MultiLine = options.multiLine,
			ErrorLocation = options.errorLocation,
		}
	end,
	{
		Text = "",
		Disabled = false,
		MultiLine = false,
		ErrorLocation = "Right",
		Filter = function() end,
		Validator = function() end,
	}
) :: (text: string, options: Options?) -> TextInputHandle
