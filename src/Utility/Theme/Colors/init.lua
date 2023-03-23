local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent.Parent.Packages

local Fusion = require(Packages.Fusion)
local unwrap = require(script.Parent.Parent.unwrap)

local Value = Fusion.Value
local Computed = Fusion.Computed

if RunService:IsStudio() and RunService:FindFirstAncestorWhichIsA("Plugin") then
	
	local Studio: Studio = settings():GetService("Studio")
	local CurrentTheme = Value(Studio.Theme)
	
	Studio.ThemeChanged:Connect(function(newTheme)
		CurrentTheme:set(Studio.Theme, true)
	end)
	
	return function(guideColor, guideModifier)
		
		if guideColor == nil then
			return Computed(function()
				return unwrap(CurrentTheme).Name
			end)
		end
		
		return Computed(function()
		
			local guideColor = unwrap(guideColor)
			local guideModifier = unwrap(guideModifier)
			
			return unwrap(CurrentTheme):GetColor(
				guideColor or Enum.StudioStyleGuideColor.MainBackground,
				guideModifier or Enum.StudioStyleGuideModifier.Default
			)
			
		end)
	end
else
	
	local CurrentThemeName = Value("Dark")
	
	return function(guideColor, guideModifier)
		
		if guideColor == nil then
			return CurrentThemeName
		end
		
		return Computed(function()
		
			local guideColor = unwrap(guideColor)
			local guideModifier = unwrap(guideModifier)
			
			local themeModule = require(script:FindFirstChild(unwrap(CurrentThemeName)))
			
			return themeModule[guideColor or Enum.StudioStyleGuideColor.MainBackground][guideModifier or Enum.StudioStyleGuideModifier.Default]
			
		end)
		
	end
end