--[[
	TextInput is a wrapper around BaseTextInput, but fancier.
	Provides validator and filter functions to allow you to gain control over
	what the player types and give a error based on it.
	
	Validator:
		Validators are used to tell the user if they have given a input that is
		considered bad. You should use these most of the time.
	Filter:
		Filters are used to stop the user from inputting a certain piece of text
		and overwriting it. These should rarely be used.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local CubeCat = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local FusionPlasma = require(Packages.FusionPlasma)
local Util = require(CubeCat.Utility)

local Background = require(Components.Decoration.Background)
local BaseTextInput = require(Components.Interactable.BaseTextInput)
local BaseMultiLine = require(Components.Interactable.BaseMultiLine)
local Text = require(Components.Display.Text)
local Button = require(Components.Interactable.Button)

local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local Observer = Fusion.Observer
local Cleanup = Fusion.Cleanup
local Spring = Fusion.Spring

local Statify = Util.Statify
local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type TextInput = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Text: CanBeState<string>?,
	MultiLine: boolean?,
	PlaceholderText: CanBeState<string>?,
	ErrorLocation: CanBeState<"Bottom" | "Right" | "None">?,

	Disabled: CanBeState<boolean>?,
	Focused: CanBeState<boolean>?,

	Validator: CanBeState<(text: string) -> (boolean, string)>?,
	Filter: CanBeState<(text: string) -> string>?,
	FocusLost: CanBeState<(text: string) -> string>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Text",
	"MultiLine",
	"PlaceholderText",
	"ErrorLocation",
	"Validator",
	"Filter",
	"Disabled",
	"Focused",
	"FocusLost",
	Children,
}

local function TextInput(props: TextInput)
	local text = Statify(props.Text or "")
	local fail = Value(false)
	local message = Value("")
	local focused = Statify(props.Focused or false)
	local hovering = Value(false)
	local filter = props.Filter
	local validator = props.Validator
	local errorLocation = props.ErrorLocation
	local disabled = props.Disabled

	local BaseTextInput = if props.MultiLine then BaseMultiLine else BaseTextInput

	local oldText = unwrap(text)
	local onTextChanged
	local skip = false
	local function validate()
		local currentText = unwrap(text)
		if currentText == nil or skip then
			return
		end

		local filter = unwrap(filter) or function(s)
			return s
		end
		local validator = unwrap(validator) or function()
			return true
		end

		local filteredText = filter(currentText, oldText)

		if type(filteredText) == "string" then
			currentText = filteredText
		end

		local ok, result = validator(currentText)

		oldText = currentText
		fail:set(not ok)
		message:set(if result == nil then "" else result)
		skip = true
		text:set(currentText)
		skip = false

		if onTextChanged then
			onTextChanged(currentText)
			onTextChanged = nil
		end
	end

	local enterPressed = false
	local focusLost = false

	local textUpdated = Observer(text):onChange(validate)

	local TextInput = Background {
		Name = "TextInput",

		Size = UDim2.fromOffset(300, 24),
		AutomaticSize = Enum.AutomaticSize.Y,

		BackgroundTransparency = 1,

		VerticalAlignment = Computed(function()
			local location = unwrap(errorLocation)
			if location == "Bottom" then
				return Enum.VerticalAlignment.Top
			else
				return Enum.VerticalAlignment.Center
			end
		end),
		FillDirection = Computed(function()
			local location = unwrap(errorLocation)
			if location == "Bottom" then
				return Enum.FillDirection.Vertical
			else
				return Enum.FillDirection.Horizontal
			end
		end),
		NoPadding = true,

		[Children] = {

			Button {

				Size = UDim2.new(1, 0, 0, 24),
				AutomaticSize = if props.MultiLine then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,

				Hovering = hovering,
				Selected = focused,
				Disabled = disabled,

				BackgroundColor = Enum.StudioStyleGuideColor.InputFieldBackground,
				BorderColor = Computed(function()
					if unwrap(fail) then
						return Enum.StudioStyleGuideColor.ErrorText
					else
						return Enum.StudioStyleGuideColor.InputFieldBorder
					end
				end),

				NoText = true,

				[Children] = {

					BaseTextInput {
						Size = UDim2.new(1, 0, 0, 24),

						Text = text,
						PlaceholderText = props.PlaceholderText,

						Disabled = disabled,
						Focused = focused,

						OnFocusLost = props.FocusLost or function(v)
							enterPressed = v
							focusLost = true
						end,
					},

					props[Children],
				},
			},

			Text {

				Text = message,
				TextColor = Computed(function()
					if unwrap(fail) then
						return Enum.StudioStyleGuideColor.ErrorText
					else
						return Enum.StudioStyleGuideColor.DimmedText
					end
				end),

				TextTransparency = Spring(
					Computed(function()
						local message = unwrap(message)

						if message ~= "" then
							return 0
						else
							return 1
						end
					end),
					40,
					1
				),

				Visible = Computed(function()
					return unwrap(message) ~= ""
				end),
			},
		},
		[Cleanup] = textUpdated,
	}

	FusionPlasma.expose(function()
		return {
			filter = function(self, callback)
				filter:set(callback)
				return self
			end,
			validate = function(self, callback)
				if unwrap(validator) == callback then
					return self
				end
				validator:set(callback)
				validate()
				return self
			end,
			focusLost = function(self)
				local focus = focusLost
				local pressed = enterPressed
				focusLost = false
				enterPressed = false
				return focus, pressed
			end,
			text = function(self, callback)
				onTextChanged = callback
				return self
			end,
		}
	end)

	validate()

	return Fusion.Hydrate(TextInput)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return TextInput
