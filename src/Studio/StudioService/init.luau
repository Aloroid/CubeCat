local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local classIconsIndex = require(script.classIconsIndex)

type StudioServiceImpl = {
	__index: StudioServiceImpl,
	new: () -> StudioService,
}

export type StudioService = typeof(setmetatable(
	{} :: {
		ClassName: "StudioService",
		
	},
	{} :: StudioServiceImpl
))

local StudioService = {} :: StudioServiceImpl
StudioService.__index = StudioService

function StudioService.new()
	local self = setmetatable({
		ClassName = "StudioService",
		
		ActiveScript = nil,
		DraggerSolveConstraints = nil,
		DrawConstraintsOnTop = nil,
		GridSize = 1,
		RotateIncrement = 1,
		ShowConstraintDetails = false,
		StudioLocaleId = LocalizationService.SystemLocaleId,
		UseLocalSpace = false
		
	}, StudioService)
	
	return self
end

function StudioService:GetClassIcon(className: string)
	assert(classIconsIndex[className], `GetClassIcon: {className} is not a Roblox class.`)
	
	return classIconsIndex[className]
end

function StudioService:GetUserId()
	return Players.LocalPlayer.UserId
end

function StudioService:PromptImportFile(fileTypeFilter: {string})
	error("Cannot emulate PromptImportFile")
end

function StudioService:PromptImportFiles(fileTypeFilter: {string})
	error("Cannot emulate PromptImportFiles")
end

return StudioService.new()