local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent
local Components = CubeCat.Components

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local Background = require(Components.Decoration.Background)
local Line = require(Components.Decoration.Line)
local Text = require(Components.Display.Text)
local Padding = require(Components.Decoration.Padding)
local Checkbox = require(Components.Interactable.Checkbox)

local Children = Fusion.Children

local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Permission = {
	
	Name: string,
	Description: string,
	
	Value: CanBeState<boolean>,

	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {

	"Description",
	"Value"
	
}

local function Permission(props: Permission)
	
	local Permission = Background {
		
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		
		NoPadding = true,
		ListPadding = 12,
		
		[Children] = {
			
			Line {},
			
			Background {
				
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				
				NoPadding = true,
				
				[Children] = {
					
					Padding {
						Padding = 24,
						PaddingBottom = UDim.new(0, 0),
						PaddingTop = UDim.new(0, 0)
					},
					
					Checkbox {
					
						Size = UDim2.fromScale(1, 0),
						
						Checked = props.Value,
						
						[Children] = Background {
							
							Size = UDim2.fromScale(1, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							
							Padding = 0,
							
							[Children] = {
								
								Text {
									Name = "Name",
									
									Size = UDim2.new(1, -24, 0, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									
									Text = props.Name,
									TextXAlignment = Enum.TextXAlignment.Left,
									Font = Enum.Font.SourceSansBold,
									TextSize = 24,
								},
								
								Text {
									Name = "Description",
									
									Size = UDim2.new(1, -24, 0, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									
									Text = props.Description,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextWrapped = true,
									Font = Enum.Font.SourceSans,
									TextSize = 18,
								}
								
							}
						}
					
				}
					
				}
				
			}
			
		}
		
	}
	
	
	return Fusion.Hydrate(Permission)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Permission