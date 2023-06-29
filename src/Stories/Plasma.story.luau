local RunService = game:GetService("RunService")
local CubeCat = script.Parent.Parent
local Packages = script.Parent.Parent.Parent

local Plasma = require(Packages.Plasma)
local Widgets = require(CubeCat.Widgets)

return function(target)
	local node = Plasma.new(game:GetService("CoreGui"))

	local connection = RunService.RenderStepped:Connect(function()
		Plasma.start(node, function()
			Widgets.Widget("Testing", {

				WidgetId = "PlasmaCubeCat",

				InitialDockState = Enum.InitialDockState,
				InitialEnabled = true,
				FloatingSize = Vector2.new(200, 200),
				MinimumSize = Vector2.new(200, 200),
				OverrideEnabled = false,
			}, function()
				local text, updateText = Plasma.useState("")

				Widgets.Background(function()
					Widgets.Text("just testing lol")
					Widgets.Button("yo")
					Widgets.ExpandablePane("lol", function()
						Widgets.TextInput(text)
							:validate(function(text)
								return not not tonumber(text), "must be a valid number"
							end)
							:text(function(trueText)
								updateText(trueText)
								text = trueText
							end)
					end)
				end)
			end)
		end)
	end)

	return function()
		connection:Disconnect()
	end
end
