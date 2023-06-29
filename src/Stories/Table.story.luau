local CubeCat = script.Parent.Parent
local Packages = CubeCat.Parent
local Components = CubeCat.Components

local Fusion = require(Packages.Fusion)

local Background = require(Components.Decoration.Background)
local Table = require(Components.Display.Table)

local Children = Fusion.Children

return function(target)
	local background = Background {

		Parent = target,

		[Children] = {

			Table {
				Table = {
					a = true,
					b = true,
					c = "d",
					d = "trolled",
					e = "gaa",
				},

				DisplayTotal = 4,
			},

			Table {
				Rows = {
					{ Id = 1, Version = 1, Transform = CFrame.new(), Health = 100 },
				},
				Order = {
					"Id",
					"Version",
					"Transform",
					"Health",
				},
				InitialSizes = { 0.075, 0.075 },

				DisplayTotal = 4,
			},
		},
	}

	return function()
		background:Destroy()
	end
end
