return function(children: { ModuleScript })
	for _, value in children do
		if value:IsA("ModuleScript") == false then
			continue
		end
		require(value)
	end
end
