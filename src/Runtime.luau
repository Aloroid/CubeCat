local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent

local Fusion = require(Packages.Fusion)

local Value = Fusion.Value
local Computed = Fusion.Computed

local WEAK_KEYS_METATABLE = {__mode = "k"}

local weakReferences = setmetatable({}, WEAK_KEYS_METATABLE)

local function Runtime<T>(func: (old: T?) -> T): Fusion.Computed<T>
	
	local result, success = func(nil)
	local realValue = Value(if success ~= false then result else nil)
	local wrapper = Computed(function()
		return realValue:get()
	end, Fusion.doNothing)
	local connection
	
	connection = RunService.Heartbeat:Connect(function()
		if weakReferences[wrapper] then
			local result, success = func(realValue:get(false))
			if success == false then return end
			realValue:set(result)
		else
			connection:Disconnect()
		end
	end)
	
	weakReferences[wrapper] = true
	wrapper.kind = "Runtime"
	
	return wrapper
	
end

return Runtime