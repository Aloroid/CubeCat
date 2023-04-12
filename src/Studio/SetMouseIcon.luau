local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local plugin = script:FindFirstAncestorWhichIsA("Plugin")

local function SetMouseIcon(icon: string)
	
	if plugin then
		plugin:Activate()
		local mouse = plugin:GetMouse()
		mouse.Icon = icon
	elseif RunService:IsRunning() then
		UserInputService.MouseIcon = icon
	end
	
end

return SetMouseIcon