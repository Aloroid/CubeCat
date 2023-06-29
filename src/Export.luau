--[[
	A special key for property-tables, which specify a key to export the given instance to.
	This is used to allow other developers to export the current instance into another key.
]]

local sharedState = require(script.Parent.sharedState)

local function Export(as: string)
	local exportAs = {}

	exportAs.type = "SpecialKey"
	exportAs.kind = "Export"
	exportAs.stage = "observer"

	function exportAs:apply(exports: { [any]: any }, applyTo: Instance, cleanupTasks: { any })
		assert(
			sharedState.PublicExportInstances[as] == nil,
			`[CubeCat] Attempted to overwrite existing Export "{as}" with {applyTo.Name}`
		)

		sharedState.PublicExportInstances[as] = {
			instance = applyTo,
			values = exports,
		}

		table.insert(cleanupTasks, function()
			sharedState.PublicExportInstances[as] = nil
		end)
	end

	return exportAs
end

return Export
