local HttpService = game:GetService("HttpService")
local Packages = script.Parent.Parent.Parent
local Components = Packages.CubeCat.Components

local Fusion = require(Packages.Fusion)

local getPluginInfo = require(script.Parent.getPluginInfo)
local Permission = require(script.Permission)
local application = require(script.Parent.application)

local Background = require(Components.Decoration.Background)
local ScrollingFrame = require(Components.Decoration.ScrollingFrame)
local Widget = require(Components.Display.Widget)
local Button = require(Components.Interactable.Button)
local Image = require(Components.Display.Image)
local Text = require(Components.Display.Text)
local Padding = require(Components.Decoration.Padding)

local Value = Fusion.Value
local ForValues = Fusion.ForValues
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

type CanBeState<T> = Fusion.CanBeState<T>
export type Prompt = {
	ProductInfo: getPluginInfo.ProductData,
	PermissionsRequested: {{name: string, description: string}},
	
	[any]: any
}

local function Prompt(props: Prompt)
	
	local checkedPermissions = {}
	local denyAll = false
	local thread = coroutine.running()
	
	local Prompt = Widget {
		
		WidgetId = `Permissions:{HttpService:GenerateGUID(false)}`,
		DockWidgetInfo = DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,
			true,
			true,
			300,
			400,
			300,
			400
		),
		
		[Children] = Background {
			Name = "Info",
			
			ListPadding = 0,
			
			[Children] = {
				
				ScrollingFrame {
					
					Size = UDim2.new(1, 0, 1, -32),
					Padding = 8,
					ListPadding = 16,
					
					[Children] = {
						Background {
							
							Size = UDim2.fromScale(1, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							
							NoPadding = true,
							
							[Children] = {
								
								Padding {
									Padding = 24,
									PaddingTop = UDim.new(0, 0),
									PaddingBottom = UDim.new(0, 0)
								},
								
								Text {
									Size = UDim2.fromScale(1, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									
									Text = `This plugin is requesting for the following permissions in <b>{application.Name}</b>`,
									TextWrapped = true,
									RichText = true,
									
									TextColor = Enum.StudioStyleGuideColor.SubText,
									TextSize = 16
									
								},
								
								Background {
									
									Size = UDim2.fromScale(1, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									
									ListPadding = 16,
									NoPadding = true,
									
									[Children] = {
										Image {
											Image = if props.ProductInfo.AssetId ~= 0
											then	`rbxthumb://type=asset&id={props.ProductInfo.AssetId}&w=420&h=420`
											else	"rbxasset://textures/ui/GuiImagePlaceholder.png"
											
										},
										
										Text {
											Text = props.ProductInfo.Name,
											TextSize = 32,
											Font = Enum.Font.SourceSansBold
											
										}
										
									}
									
								},
								
								Text {
									
									Name = "Description",
									
									Text = props.ProductInfo.Description,
									Visible = #(props.ProductInfo.Description or "") > 0
									
								}
							}
							
						},
						
						ForValues(props.PermissionsRequested, function(permission)
						
							checkedPermissions[permission] = Value(true)
							
							return Permission {
								
								Name = permission.name,
								Description = permission.description,
								
								Value = checkedPermissions[permission]
								
							}
							
						end, Fusion.cleanup)
						
					}
					
				},
				
				Background {
					
					Size = UDim2.new(1, 0, 0, 32),
					
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					FillDirection = Enum.FillDirection.Horizontal,
					
					[Children] = {
						
						Button {
							Text = "Accept",
							
							[OnEvent "Activated"] = function()
								coroutine.resume(thread)
							end
						},
						
						Button {
							Text = "Deny All",
							
							[OnEvent "Activated"] = function()
								denyAll = true
								coroutine.resume(thread)
							end
						}
						
					}
					
				}
				
			}
			
		}
		
	}
	
	-- User shouldn't close, but just reject or accept.
	Prompt:BindToClose(function()
	end)
	
	coroutine.yield()
	Prompt:Destroy()
	
	local results = {}
	
	for permission, value in checkedPermissions do
		results[permission] = if not denyAll then value:get() else false
		
	end
	
	return results
	
end

return Prompt