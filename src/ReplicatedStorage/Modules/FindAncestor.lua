--!strict

-- By Wa1er_God --

local Ancestors = {};

function Ancestors.FindLastAncestor(Descendant: Instance, AncestorName: string)
	local Parent: Instance? = Descendant;
	local LastAncestor: Instance? = nil;
	
	repeat
		Parent = (Parent :: any).Parent;
		if Parent == nil then
			return LastAncestor;
		end
		if Parent.Name == AncestorName and Parent ~= workspace then
			LastAncestor = Parent;
		end
	until Parent.Parent == nil;
	
	return LastAncestor;
end

function Ancestors.FindLastAncestorWhichIsA(Descendant: Instance, ClassName: string)
	local Parent: Instance? = Descendant;
	local LastAncestor: Instance? = nil;

	repeat
		Parent = (Parent :: any).Parent;
		if Parent == nil then
			return LastAncestor;
		end
		if Parent:IsA(ClassName) and Parent ~= workspace then
			LastAncestor = Parent;
		end
	until Parent.Parent == nil;

	return LastAncestor;
end

function Ancestors.FindFirstHumanoid(Instance: Instance): Humanoid?
	for _, Parent in ipairs(Ancestors.GetAncestors(Instance)) do
		local FoundHumanoid = Parent:FindFirstChildWhichIsA("Humanoid");

		if FoundHumanoid then
			return FoundHumanoid;
		end
	end
	
	return;
end

function Ancestors.GetAncestors(Instance: Instance)
	local CurrentParent: Instance = Instance;
	local Ancestors = {};
	
	repeat
		table.insert(Ancestors, CurrentParent :: Instance);
		CurrentParent = (CurrentParent :: any).Parent;
	until CurrentParent == nil;
	
	return Ancestors;
end

function Ancestors.FindDescendantNameAndClass(Parent: Instance, ChildName: string, ChildClass: string): Instance?
	
	for _, Descendant in ipairs(Parent:GetDescendants()) do
		if Descendant.Name == ChildName and Descendant.ClassName == ChildClass then
			return Descendant;
		end
	end
	
	return;
end

function Ancestors.FindChildNameAndClass(Parent: Instance, ChildName: string, ChildClass: string): Instance?
	for _, Descendant in ipairs(Parent:GetChildren()) do
		if Descendant.Name == ChildName and Descendant.ClassName == ChildClass then
			return Descendant;
		end
	end

	return;
end

return Ancestors;