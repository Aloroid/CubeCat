local CubeCat = script.Parent.Parent
local Packages = CubeCat.Parent
local Components = CubeCat.Components

local Fusion = require(Packages.Fusion)

local Button = require(Components.Interactable.Button)
local Background = require(Components.Decoration.Background)
local Text = require(Components.Display.Text)
local ExpandablePane = require(Components.Interactable.ExpandablePane)

local Children = Fusion.Children

return function(target)
	local background = Background {
		Parent = target,

		[Children] = {

			ExpandablePane {
				PaneText = "Hello!",

				[Children] = {

					Button {
						Text = "Sadge",
					},

					Text {
						Text = "Hello there!",
					},
				},
			},

			ExpandablePane {},
		},
	}

	return function()
		background:Destroy()
	end
end
