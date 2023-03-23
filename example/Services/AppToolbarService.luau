--[[
	AppToolbarService creates a Plugin Toolbar and Plugin Button which are used
	to open a DockWidgetPluginGui to display the interface in which will show
	the players the current State from StateService.

]]

local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local Plugin = script.Parent.Parent
local Packages = Plugin.Packages
local Components = Plugin.Components

local CubeCat = require(Packages.CubeCat)
local App = require(Components.App)
local Exported = require(Components.Exported)
local Fusion = require(Packages.Fusion)

local Value = Fusion.Value

local AppToolbarService = CubeCat.CreateService({
	Name = "AppToolbarService",
	Public = {}
})

local toolbar
function AppToolbarService:GetToolbar()
	if toolbar then return toolbar end
	toolbar = plugin:CreateToolbar("Example Plugin")
	
	return toolbar
end

function AppToolbarService:Init()
	
	if CubeCat.Studio.IsFake == false then
		local toolbar = AppToolbarService:GetToolbar()
		local button = toolbar:CreateButton(
			"exampleInterface",
			"Opens Example Interface",
			"",
			"Example"
		)
		
		local enabled = Value(true)
		local widget = App {}
		
		local function swapState()
			enabled:set(not enabled)
			button:SetActive(enabled:get())
			widget.Enabled = enabled:get()
		end
		
		button:SetActive(enabled:get())
		button.Click:Connect(swapState)
		widget:BindToClose(swapState)
	else
		App {}
	end
	
	Exported {}
	
end

return AppToolbarService