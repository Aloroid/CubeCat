local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent

local Fusion = require(Packages.Fusion)

local Value = Fusion.Value
local Computed = Fusion.Computed

local function Runtime<T>(func: (old: T?) -> T): Fusion.Computed<T>
	
	local result, success = func(nil)
	local realValue = Value(if success ~= false then result else nil)
	local wrapper = Computed(function()
		return realValue:get()
	end, Fusion.doNothing)
	
	wrapper._connection = RunService.Heartbeat:Connect(function()
		-- If there is nothing left in the dependentSet, we'll disconnnect the
		-- connection because nobody depends on it anymore.
		if next(wrapper.dependentSet) then
			local result, success = func(realValue:get(false))
			if success == false then return end
			realValue:set(result)
		else
			wrapper._connection:Disconnect()
		end
	end)
	
	wrapper.kind = "Runtime"
	
	return wrapper
	
end

return Runtime