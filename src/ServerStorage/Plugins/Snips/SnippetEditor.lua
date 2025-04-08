--[[
	Thank you for using Snip!
	
	All snippets must follow this form:
	
	[<snippet_name>] = function(line: string, args: any[], doc: ScriptDocument)
		-- Return a string.
	end
	
	args represents the arguments given to the snippet. Example:
	!snip(5, ok, 99) => args = {5, "ok", 99}
	As you can see, you don't need to use quotation marks.
	
	The snippet_name must begin with an exclamation mark(!), otherwise the code won't be replaced.
	
	Note that the plugin will not work if Script Editor API isn't enabled in Beta Features. To do so, go to:
	FILE > Beta Features > Enable Script Editor API
	Restart studio for changes to take effect.
]]--
local StudioService = game:GetService("StudioService")
local Players = game:GetService("Players")
local playerName = Players:GetNameFromUserIdAsync(StudioService:GetUserId())
local fmt = string.format
return {
	-- add your snippets here
	["!gs"] = function(line, args)
		if not args then
			return line
		end
		return fmt("local %s = game:GetService(\"%s\")", args[1], args[1])
	end,
	["!hdr"] = function(line, args, doc)
		local str = fmt("-- %s\n-- %s\n-- %s\n", doc:GetScript().Name, playerName, os.date("%x"))

		-- Optional argument for extra comment
		if args[1] and args[1] ~= "" then
			str = str .. fmt("-- %s\n", args[1])
		end
		return str 
	end,
	["!class"] = function(line, args)
		local str = [[local %s = {}
%s.__index = %s
function %s.new()
	local self = setmetatable({}, %s)
			
	return self
end
return %s]]
		return fmt(str, args[1], args[1], args[1], args[1], args[1], args[1])
	end,
	["!new"] = function(line, args)
		return string.format("local %s = Instance.new(\"%s\")", args[1], args[1])
	end,
	["!newclass"] = function(line, args)
		local str = [[
type %sData = {
	
};

type %sImpl = {
	new: () -> %s;
	Delete: (self: %s) -> ();

	__index: %sImpl;
};

type %s = typeof(setmetatable({} :: %sData, {} :: %sImpl))

local %s: %sImpl = {} :: %sImpl;
%s.__index = %s;

function %s.new()
	local self = setmetatable({}, %s) :: %s;
	
	return self;
end

function %s:Delete()
	table.clear(self :: any);
	setmetatable(self :: any, nil);
end

return %s;
]]
		return fmt(str, args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1], args[1])
	end,
}

--[[

type %sData = {
	
};

type %sImpl = {
	new: () -> ();
	Delete: (self: %s) -> ();

	__index: %sImpl;
};

type %s = typeof(setmetatable({} :: %sData, {} :: %sImpl))

local %s = {};
%s.__index = %s;

function %s.new()
	local self = setmetatable({}, %s) :: %s;
	
	return self;
end

function %s:Delete()
	table.clear(self :: any);
	setmetatable(self :: any, nil);
end
]]