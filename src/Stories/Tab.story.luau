
local CubeCat = script.Parent.Parent
local Components = CubeCat.Components

local Tab = require(Components.Interactable.Tab)
local Text = require(Components.Display.Text)

return function(target)
	
	local background = Tab {
		
		Parent = target,
		
		Tabs = {
			
			{
				
				Name = "tab 1",
				Children = Text {
					Text = "tab 1"
				}
				
			},
			
			{
				
				Name = "tab 2",
				Children = Text {
					Text = "tab 2"
				}
				
			},
			
			{
				
				Name = "tab 3",
				Children = Text {
					Text = "tab 3"
				}
				
			},
			
			
		}
		
	}
	
	
	return function()
		
		background:Destroy()
		
	end
	
end