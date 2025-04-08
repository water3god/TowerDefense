local fxv3 = {}
fxv3.__index = fxv3

local runsv = game:GetService("RunService")
local rstep = runsv.RenderStepped
if runsv:IsServer() then
	rstep = runsv.Heartbeat
end

local tws = game:GetService("TweenService")
local rs = game:GetService("ReplicatedStorage")

local cfn,cfa,v3n,c3n,fromExist,tspawn,twait = CFrame.new,CFrame.Angles,Vector3.new,Color3.new,Instance.fromExisting,task.spawn,task.wait
local r,rd = math.rad,math.random
local sin,cos,pi,round = math.sin,math.cos,math.pi,math.round


local function lerp(start,goal,alpha):number
	return start+(goal-start)*alpha
end

local EasingStyleOverrides = require(script.EasingOverrides)

local function GetValue(x, style, direction, overshoot)
	if EasingStyleOverrides[style] then
		if EasingStyleOverrides[style][direction] then
			return EasingStyleOverrides[style][direction](x, overshoot)
		else
			return tws:GetValue(x, style, direction)
		end
	else
		return tws:GetValue(x, style, direction)
	end
end

function fxv3:Animate(inc:number) --Can be written to/overridden
	local newalpha = GetValue(inc, self.EasingStyle, self.EasingDirection, self.Overshoot)
	local p1 = self.Properties1
	local p2 = self.Properties2
	
	for index,value in pairs(p2) do
		if type(value) == "number" then
			self.Part[index] = lerp(p1[index], value, newalpha)
			
		elseif type(value) == "userdata" or type(value) == "vector" then
			
			if self.DrawLine == true then
				if index == "CFrame" or index == "Size" then
					continue
				end
			end
			self.Part[index] = p1[index]:Lerp(value, newalpha)
		end
	end
	
	if self.DrawLine == true then
		local pos1:Vector3 = p1.CFrame.Position
		local pos2:Vector3 = p2.CFrame.Position
		local width = lerp(self.Width1, self.Width2, newalpha)
		local spin = 0
		if self.LineRotate then
			spin = r(lerp(self.LineOffset,self.LineOffset+180,newalpha))
		end
		self.Part.CFrame = cfn(pos1:Lerp(pos2, .5), pos2)*cfa(0,0,spin)
		self.Part.Size = v3n(width,width,(pos1-pos2).Magnitude )
	end
end

function fxv3.new(startcf:CFrame, endcf:CFrame, part:string, randomRot:{number}?, fromExisting)
	local part = rs.VFX:FindFirstChild(part)
	if not part then
		warn("couldnt find part "..part..", creating block...")
		local newpart = Instance.new("Part")
		newpart.Name = part
		newpart.Parent = rs.VFX
		part = newpart:Clone()
	end
	
	
	if randomRot then
		local rd1 = {}
		local rd2 = {}
		for i = 1,3 do
			rd1[i] = rd(-randomRot[i],randomRot[i])
			rd2[i] = rd(-randomRot[i],randomRot[i])
		end
		startcf = cfn(startcf.Position)*cfa(r(rd1[1]), r(rd1[2]), r(rd1[3]))
		endcf = cfn(endcf.Position)*cfa(r(rd2[1]), r(rd2[2]), r(rd2[3]))
	end
	
	local self = setmetatable({ --DEFAULT SETTINGS
		EasingStyle = Enum.EasingStyle.Quad,
		EasingDirection = Enum.EasingDirection.Out,
		Overshoot = nil, --Optional number to control things like overshoot
		Steps = 0.01,
		
		DrawLine = false,
		Width1 = 1, --only used if drawline is true
		Width2 = 2,
		
		Material = Enum.Material.Neon,
		Properties1 = {
			Color = c3n(1),
			Size = Vector3.one,
			CFrame = startcf,
			Transparency = 0,
		},
		Properties2 = {
			Color = c3n(0,0,1),
			Size = Vector3.one*2,
			CFrame = endcf,
			Transparency = 1,
		},
		
	}, fxv3)
	
	if not fromExisting then
		self.Part = fromExist(part)
		self.Part.Anchored = true
		self.Part.CanCollide = false
		self.Part.CanQuery = false
		self.Part.CanTouch = false
		self.Part.Material = self.Material
		self.Part.Parent = workspace.ClientParts.Effects
	end
	
	
	self.LineOffset = rd(-360,360)
	self.LineRotate = true
	
	self.Pause = false
	self.Finished = false
	
	if not fromExisting then
		tspawn(function()
			task.wait()
			for index,value in pairs(self.Properties1) do
				self.Part[index] = value
			end
			for i = 0,1,self.Steps do
				rstep:Wait()
				self.Animate(self,i)
				while self.Pause == true do
					twait()
				end

				if self.Break or not self.Part.Parent then break end
			end
			self.Part:Destroy()
			self.Finished = true
		end)
	end
	
	
	
	return self
end

function fxv3.fromExisting(fx)
	local partname = fx.Part.Name
	local part = rs.VFX:FindFirstChild(partname)
	local self = fxv3.new(fx.Properties1.CFrame, fx.Properties2.CFrame, partname, nil, true)
	for i,v in pairs(fx) do
		self[i] = v
	end
	self.Properties1 = table.clone(fx.Properties1)
	self.Properties2 = table.clone(fx.Properties2)
	
	self.Part = nil
	self.Part = fromExist(part)
	self.Part.Anchored = true
	self.Part.CanCollide = false
	self.Part.CanQuery = false
	self.Part.CanTouch = false
	self.Part.Material = self.Material
	self.Part.Parent = workspace.ClientParts.Effects
	
	
	tspawn(function()
		task.wait()
		for index,value in pairs(self.Properties1) do
			self.Part[index] = value
		end
		for i = 0,1,self.Steps do
			rstep:Wait()
			self.Animate(self,i)
			while self.Pause == true do
				twait()
			end

			if self.Break or not self.Part.Parent then break end
		end
		self.Part:Destroy()
		self.Finished = true
	end)


	return self
end

return fxv3
