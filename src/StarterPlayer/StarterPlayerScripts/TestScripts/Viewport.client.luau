print(workspace.CurrentCamera.ViewportSize)

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	print(workspace.CurrentCamera.ViewportSize)
end)
