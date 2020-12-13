if (game:GetService("RunService"):IsServer()) then
	return require(script.ServerCoreComponents)
else
	script.ServerCoreComponents:Destroy()
	return require(script.ClientCoreComponents)
end