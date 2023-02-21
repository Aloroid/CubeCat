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

local widget
function AppToolbarService:GetWidget()
	if widget then return widget end
	
	local guiInfo = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,
		true,
		false,
		200,
		200,
		200,
		200
	)
	widget = plugin:CreateDockWidgetPluginGui("example", guiInfo)
	
	return widget
	
end

function AppToolbarService:Init()
	local toolbar = AppToolbarService:GetToolbar()
	local button = toolbar:CreateButton(
		"exampleInterface",
		"Opens Example Interface",
		"",
		"Example"
	)
	
	local widget = AppToolbarService:GetWidget()
	local enabled = widget.Enabled
	
	local function swapState()
		enabled = not enabled
		button:SetActive(enabled)
		widget.Enabled = enabled		
	end
	
	button:SetActive(enabled)
	button.Click:Connect(swapState)
	widget:BindToClose(swapState)
	
	App {
		Parent = widget
	}
	Exported {}
	
end

return AppToolbarService