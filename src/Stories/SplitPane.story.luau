
local CubeCat = script.Parent.Parent
local Packages = CubeCat.Parent
local Components = CubeCat.Components

local Fusion = require(Packages.Fusion)

local Background = require(Components.Decoration.Background)
local SplitPane = require(Components.Interactable.SplitPane)
local Text = require(Components.Display.Text)

local Value = Fusion.Value
local Children = Fusion.Children

return function(target)
	
	local background = Background {
		
		Parent = target,
		
		[Children] = {
			
			SplitPane {
				
				Sizes = {Value(0.25), Value(0.25), Value(0.25), Value(0.25)},
				MinSizes = {Value(0.1), Value(0.1), Value(0.1), Value(0.1)},
				
				[Children] = {
					
					Text {Text = "first"},
					Text {Text = "second"},
					Text {Text = "third"},
					Text {Text = "fourth"}
					
				}
				
			}
			
		}
		
	}
	
	
	return function()
		
		background:Destroy()
		
	end
	
end