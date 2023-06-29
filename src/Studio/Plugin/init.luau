local Packages = script.Parent.Parent.Parent

local Signal = require(Packages.Signal)

type PluginImpl = {
	__index: PluginImpl,
	new: () -> Plugin,
}

export type Plugin = typeof(setmetatable(
	{} :: {
		ClassName: "Plugin",

		CollisionEnabled: boolean,
		GridSize: number,
	},
	{} :: PluginImpl
))

local Plugin = {} :: PluginImpl
Plugin.__index = Plugin

function Plugin.new()
	local self = setmetatable({
		ClassName = "Plugin",

		CollisionEnabled = false,
		GridSize = 1,

		_activated = false,
		_exclusiveMouse = false,
		_settings = {},

		Deactivation = Signal.new(),
		Unloading = Signal.new(),
	}, Plugin)

	game:BindToClose(function()
		self.Unloading:Fire()
	end)

	return self
end

function Plugin:Activate(exclusiveMouse: boolean)
	self._activated = true
	self._exclusiveMouse = exclusiveMouse
	self.Deactivation:Fire()
end

function Plugin:CreatePluginAction(
	actionId: string,
	text: string,
	statusTip: string,
	iconName: string,
	allowBinding: boolean
)
	--TODO: Add PluginActions
end

function Plugin:CreatePluginMenu(id: string, title: string, icon: string)
	--TODO: Add PluginMenus
end

function Plugin:CreateToolbar(name: string)
	--TODO: Add PluginToolbars
end

function Plugin:Deactivate()
	self._activated = false
end

function Plugin:GetSelectedRibbonTool()
	return Enum.RibbonTool.None
end

function Plugin:GetSetting(key: string)
	return self._settings[key]
end

function Plugin:IsActivated()
	return self._activated
end

function Plugin:IsActivatedWithExclusiveMouse()
	return self._activated and self._exclusiveMouse
end

function Plugin:Negate(objects: { BasePart })
	error("Unimplemented")
end

function Plugin:OpenScript(scirpt, lineNumber)
	error("Cannot emulate OpenScript")
end

function Plugin:OpenWikiPage(url)
	error("Cannot emulate OpenWikiPage")
end

function Plugin:SaveSelectedToRoblox()
	error("Cannot emulate SaveSelectedToRoblox")
end

function Plugin:SelectRibbonTool()
	error("Unimplemented")
end

function Plugin:Separate()
	error("Cannot emulate Separate")
end

function Plugin:SetSetting(key: string, value: any)
	self._settings[key] = value
end

function Plugin:StartDrag(...)
	error("Unimplemented")
end

function Plugin:Union()
	error("Unimplemented")
end

function Plugin:CreateDockWidgetPluginGui()
	error("Cannot emulate CreateDockWidgetPluginGui; Use Widget class instead")
end

function Plugin:ImportFbxAnimation()
	error("Cannot emulate ImportFbxAnimation")
end

function Plugin:ImportFbxRig()
	error("Cannot emulate ImportFbxRig")
end

function Plugin:PromptForExistingAssetId(assetType: string)
	error("Unimplemented")
end

function Plugin:PromptSaveSelection(assetType: string)
	error("Cannot emulate PromptSaveSelection")
end

return Plugin
