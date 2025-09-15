--!strict

-- By Wa1er_God --

-- Default Spawn Values

local Id = "rbxassetid://72426763128452"
local MapName = "Lobby"

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TeleportService = game:GetService("TeleportService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui: PlayerGui = Player:WaitForChild("PlayerGui")

local ArrivingGui = TeleportService:GetArrivingTeleportGui()

local Images = {
	"rbxassetid://74009505104489",
	"rbxassetid://71328723623167",
	"rbxassetid://103876432340370",
	"rbxassetid://136225745099933",
	"rbxassetid://102726491343737",
	"rbxassetid://104916487733826",
	"rbxassetid://82588529589997",
	"rbxassetid://127534545947776",
	"rbxassetid://84303396250595",
	"rbxassetid://127755477028917",
	"rbxassetid://122297615155487",
	"rbxassetid://83575157481281",
	"rbxassetid://126699154547860",
	"rbxassetid://129112984948528",
	"rbxassetid://94313610250421",
	"rbxassetid://71136210616050",
	"rbxassetid://127454767718648",
	"rbxassetid://101776796683201",
	"rbxassetid://81610858783975",
	"rbxassetid://107455378505876",
	"rbxassetid://138023884285339",
	"rbxassetid://103903141717286",
	"rbxassetid://89320025049396",
	"rbxassetid://123330760022670",
	"rbxassetid://79204844412737",
	"rbxassetid://139425566538837",
	"rbxassetid://119517743005872",
	"rbxassetid://94302946042531",
	"rbxassetid://82032478319533",
	"rbxassetid://113696247140901",
	"rbxassetid://140619810808433",
	"rbxassetid://99690855271720",
	"rbxassetid://76678277757329",
	"rbxassetid://103111320314677",
	"rbxassetid://106849723034867",
	"rbxassetid://132123775824899",
	"rbxassetid://92595145450368",
	"rbxassetid://117289508099114",
	"rbxassetid://73864431143188",
	"rbxassetid://129813693449315",
	"rbxassetid://84122625667430",
	"rbxassetid://87375490001692",
	"rbxassetid://129925572059119",
	"rbxassetid://72606508098140",
	"rbxassetid://79538742814909",
	"rbxassetid://79289950256029",
	"rbxassetid://106321434861726",
	"rbxassetid://120110890373605",
	"rbxassetid://127875702608033",
	"rbxassetid://128406610117555",
	"rbxassetid://139365412622384",
	"rbxassetid://96949064415731",
	"rbxassetid://125478192482439",
	"rbxassetid://101498044445732",
	"rbxassetid://91607803296847",
	"rbxassetid://107661014718459",
	"rbxassetid://123586559835070",
	"rbxassetid://99487877589033",
	"rbxassetid://124325015691256",
	"rbxassetid://110783523635885",
	"rbxassetid://76696356635070",
	"rbxassetid://101118925074854",
	"rbxassetid://105684513155812",
	"rbxassetid://120918635081566",
	"rbxassetid://93189258734983",
	"rbxassetid://90997125561155",
	"rbxassetid://75971006528952",
	"rbxassetid://85379476276657",
	"rbxassetid://90225038866735",
	"rbxassetid://91075509318519",
	"rbxassetid://139210428987187",
	"rbxassetid://90650317828395",
	"rbxassetid://110715473491790",
	"rbxassetid://111252960349158",
	"rbxassetid://76295055563521",
	"rbxassetid://97483072794272",
	"rbxassetid://92481753039926",
	"rbxassetid://124346473405464",
	"rbxassetid://95171919754669",
	"rbxassetid://116153831042938",
	"rbxassetid://91664006560613",
	"rbxassetid://134876951462162",
	"rbxassetid://136581013754707",
	"rbxassetid://123523875685886",
	"rbxassetid://121336998793729",
	"rbxassetid://82394198587561",
	"rbxassetid://80739823452825",
	"rbxassetid://76346604778427",
	"rbxassetid://120986367718593",
}

local function ConvertIdsToDecals(ImagesInput: { string })
	local Decals = {}

	for _, Image in ipairs(ImagesInput) do
		local Decal = Instance.new("Decal")
		Decal.Texture = Image
		table.insert(Decals, Decal)
	end

	return Decals
end

local function PreloadAsync()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	ContentProvider:PreloadAsync(ConvertIdsToDecals(Images))

	if not Player.Character then
		Player.CharacterAdded:Wait()
	end
	local InventoryService = require(ReplicatedStorage.Client.GlobalClient.InventoryService)

	if not InventoryService.IsSynced then
		InventoryService.Synced:Wait()
	end
	task.wait(1)
	local Variables = require(ReplicatedStorage.Shared.Variables)
	local Network = ReplicatedStorage.Network
	local Client = require(Network.Client)
	local ClientOnly = require(Network.ClientOnly)
	task.defer(function()
		Variables.Loaded = true
		ClientOnly.Loaded:Fire()
		Client.GameLoaded.Fire()
	end)
end

local function HandleNewGui(Gui: typeof(script.LoadingGui))
	local Main = Gui:WaitForChild("Main")

	Main:WaitForChild("MapImage").Image = Id
	Main:WaitForChild("MapInfoLabel").Text = MapName
end

local function AnimateGui(Gui: typeof(script.LoadingGui))
	local Main = Gui:WaitForChild("Main")
	local LoadImage = Main:WaitForChild("LoadImage")
	local Connection = RunService.PostSimulation:Connect(function(Delta: number)
		LoadImage.Rotation += Delta * 100
	end)

	LoadImage.Destroying:Once(function()
		Connection:Disconnect()
	end)
end

local Gui: typeof(script.LoadingGui) = nil

if ArrivingGui then
	AnimateGui(ArrivingGui)
	ArrivingGui.Parent = PlayerGui

	Gui = ArrivingGui
else
	local LoadingGui = script:WaitForChild("LoadingGui"):Clone()
	HandleNewGui(LoadingGui)
	AnimateGui(LoadingGui)
	LoadingGui.Parent = PlayerGui
	Gui = LoadingGui
end

ReplicatedFirst:RemoveDefaultLoadingScreen()
PreloadAsync()

local Tween = TweenService:Create(
	Gui:WaitForChild("Main"),
	TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
	{ GroupTransparency = 1 }
)

Tween.Completed:Connect(function()
	Gui:Destroy()
end)

Tween:Play()
