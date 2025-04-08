--!strict

-- By Wa1er_God --

-- Accesses Instances easily --

-- Name = Hello.Hello

local IsStudio = game:GetService("RunService"):IsStudio();

local function GetChild(Parent: Instance, Names: string): Instance?
	local ChildHierarchy: {string} = string.split(Names, ".");
	
	local Parent: Instance = Parent;
	
	for _, ChildName in ipairs(ChildHierarchy) do
		
		local Child = Parent:FindFirstChild(ChildName);
		
		if Child == nil then
			--error("No Object Access of "..ChildName.." of "..Parent:GetFullName());
			return nil;
		else
			Parent = Child;
		end
	end
	
	return Parent;
end

return GetChild;