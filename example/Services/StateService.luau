--[[
	StateService contains a single function which is used to get the current
	state that has to be displayed in a interface.
	
]]

local Plugin = script.Parent.Parent
local Packages = Plugin.Packages

local CubeCat = require(Packages.CubeCat)

local StateService = CubeCat.CreateService({
	Name = "StateService",
	Public = {}
})

local StartTime = 0

function StateService:getState()
	local difference = os.clock() - StartTime
	
	return math.floor(difference)
	
end

function StateService.Public:getState()
	assert(CubeCat.Permissions.has("readState"))
	
	return StateService:getState()
end

function StateService:Init()
	CubeCat.Permissions.new("readState", "Read State", "Allows the client plugin to read the current state.")
	
	print("Initiated StateService")
	StartTime = os.clock()
	
end

return StateService