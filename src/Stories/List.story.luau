local CubeCat = script.Parent.Parent
local Packages = CubeCat.Parent
local Components = CubeCat.Components

local Fusion = require(Packages.Fusion)

local Background = require(Components.Decoration.Background)
local Text = require(Components.Display.Text)
local List = require(Components.Optimization.List)

local Computed = Fusion.Computed
local Children = Fusion.Children

return function(target)
	local background = Background {

		Parent = target,

		[Children] = {

			List {

				StreamIn = function(index)
					return Text {
						Size = UDim2.new(1, 0, 0, 24),
						Position = Computed(function()
							return UDim2.fromOffset(0, index:get() * 24)
						end),

						AutomaticSize = Enum.AutomaticSize.None,

						Text = Computed(function()
							return tostring(index:get())
						end),
					}
				end,
				ItemSize = 24,
			},
		},
	}

	return function()
		background:Destroy()
	end
end
