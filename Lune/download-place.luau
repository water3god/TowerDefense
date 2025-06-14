local net = require("@lune/net")
local roblox = require("@lune/roblox")
local fs = require("@lune/fs")

local MapId = 133996430724424 -- Lobby Id --

local function downloadPlaceAsset(placeId)
	local cookie = roblox.getAuthCookie()
	assert(cookie, "Failed to get auth cookie")

	local result = net.request({
		url = "https://assetdelivery.roblox.com/v1/asset/",
		headers = {
			Cookie = cookie,
		},
		query = {
			id = tostring(placeId),
		},
	})

	assert(result.ok, result.body)

	return result.body
end

local content = downloadPlaceAsset(MapId)
fs.writeFile("./Lobby.rbxl", content)
