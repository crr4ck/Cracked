-- XZPDP
-- TT: 23.74s -- [TIME TAKEN]
-- Variables: 43
-- Constants: 15
-- Total Lines of Code: 417
-- STATUS: Incomplete

local XD_ = {}

XD_.ReplicatedStorage = game:GetService("ReplicatedStorage")
XD_.Players = game:GetService("Players")
XD_.HttpService = game:GetService("HttpService")
XD_.StarterGui = game:GetService("StarterGui")
XD_.RunService = game:GetService("RunService")
XD_.VirtualUser = game:GetService("VirtualUser")
XD_.LocalPlayer = XD_.Players.LocalPlayer
XD_.RemoteEvent = XD_.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"):WaitForChild("Network"):WaitForChild("Events"):WaitForChild("RemoteEvent")
XD_.RemoteFunction = XD_.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"):WaitForChild("Network"):WaitForChild("Functions"):WaitForChild("RemoteFunction")

XD_.Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
XD_.ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
XD_.SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

XD_.Config = {
	AutoFish = false,
	AutoSell = false,
	AutoLock = true,
	NotifyEnabled = true,
	WebhookEnabled = false,
	WebhookUrl = "",
	RodDelay = 0.1,
	CatchDelay = 0.1,
	SellDelay = 5,
	LockWhitelist = {Mythical = true, Exotic = true, Legendary = true},
	NotifyWhitelist = {Mythical = true, Exotic = true, Legendary = true},
	WebhookWhitelist = {Mythical = true, Exotic = true},
}

XD_.Stats = {
	StartTime = tick(),
	TotalFish = 0,
	TotalMoney = 0,
	Rarities = {},
}

XD_.Version = "4.1"
XD_.LogoUrl = "https://i.imgur.com/YOURLOGO.png"
XD_.FrameTime = 0.016
XD_.IslandTP = {
	["Fisherman Island"] = Vector3.new(-575.984, 453.296, -185.477),
	["Ignis Island"] = Vector3.new(-1117.768, 452.517, 255.903),
}

-- XZ.Local.Function.ValidateDelay
local function XD_.ValidateDelay(input)
	local num = tonumber(input)
	if num and num > 0 then
		return math.max(num, XD_.FrameTime)
	end
	return 0.1
end

-- XZ.Local.Function.FormatTime
local function XD_.FormatTime(seconds)
	return string.format("%02d:%02d:%02d", math.floor(seconds / 3600), math.floor(seconds % 3600 / 60), math.floor(seconds % 60))
end

-- XZ.Local.Function.Notify
local function XD_.Notify(title, text)
	if not XD_.Config.NotifyEnabled then return end
	pcall(function()
		XD_.StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 5,
		})
	end)
end

-- XZ.Local.Function.SendWebhook
local function XD_.SendWebhook(fishName, rarity, value)
	if not XD_.Config.WebhookEnabled or XD_.Config.WebhookUrl == "" then return end
	local shouldSend = false
	for k, v in pairs(XD_.Config.WebhookWhitelist) do
		if string.lower(k) == string.lower(rarity) and v then
			shouldSend = true
			break
		end
	end
	if not shouldSend then return end

	local embed = {
		title = "QweenHub: Rare Fish Caught!",
		description = "**Fish:** " .. fishName .. "\n**Rarity:** " .. rarity .. "\n**Value:** $" .. (value or "???"),
		color = 16776960,
		footer = {text = "QweenHub v" .. XD_.Version},
		timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
		thumbnail = {url = XD_.LogoUrl},
	}
	local data = XD_.HttpService:JSONEncode({embeds = {embed}})
	if request then
		request({
			Url = XD_.Config.WebhookUrl,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = data
		})
	end
end

-- XZ.Local.Function.LockFish
local function XD_.LockFish(tool)
	if not tool then return end
	pcall(function() XD_.RemoteEvent:FireServer("FavouriteItem", {Item = tool, Favourited = true}) end)
	pcall(function() XD_.RemoteEvent:FireServer("ToggleLock", tool) end)
	pcall(function() XD_.RemoteEvent:FireServer("Lock", tool) end)
	pcall(function() XD_.RemoteEvent:FireServer("LockItem", tool) end)
end

-- XZ.Local.Function.IsLocked
local function XD_.IsLocked(tool)
	if not tool then return false end
	if tool:FindFirstChild("Favorited") and tool.Favorited.Value == true then return true end
	if tool:GetAttribute("Locked") == true then return true end
	return false
end

-- XZ.Local.Function.Teleport
local function XD_.Teleport(pos)
	local char = XD_.LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(pos)
		XD_.Library:Notify("Teleported!")
	end
end

-- XZ.Local.Event.FishCaughtHandler
XD_.RemoteEvent.OnClientEvent:Connect(function(eventName, fishData)
	if eventName == "FishOnHook" or eventName == "FishCaught" or eventName == "GotFish" then
		if type(fishData) ~= "table" then return end

		local fishName = fishData.Name or "Fish"
		local rarity = fishData.Rarity or "Common"
		local value = fishData.Value or 0

		XD_.Stats.TotalFish = XD_.Stats.TotalFish + 1
		XD_.Stats.TotalMoney = XD_.Stats.TotalMoney + value
		XD_.Stats.Rarities[rarity] = (XD_.Stats.Rarities[rarity] or 0) + 1

		local shouldNotify = false
		for k, v in pairs(XD_.Config.NotifyWhitelist) do
			if string.lower(k) == string.lower(rarity) and v then
				shouldNotify = true
				break
			end
		end
		if shouldNotify then
			XD_.Notify("CAUGHT: " .. fishName, "[" .. rarity .. "] Value: $" .. value)
		end

		task.spawn(XD_.SendWebhook, fishName, rarity, value)

		if XD_.Config.AutoLock then
			local shouldLock = false
			for k, v in pairs(XD_.Config.LockWhitelist) do
				if string.lower(k) == string.lower(rarity) and v then
					shouldLock = true
					break
				end
			end
			if shouldLock then
				task.spawn(function()
					task.wait(0.3)
					local backpack = XD_.LocalPlayer:FindFirstChild("Backpack")
					if backpack then
						for _, tool in pairs(backpack:GetChildren()) do
							if tool:IsA("Tool") and tool.Name == fishName and not XD_.IsLocked(tool) then
								XD_.LockFish(tool)
								XD_.Library:Notify("Locked: " .. fishName .. " (" .. rarity .. ")")
							end
						end
					end
				end)
			end
		end
	end
end)

-- XZ.Local.Loop.AutoFish
task.spawn(function()
	local lastCast = 0
	local lastCatch = 0
	while true do
		if XD_.Config.AutoFish then
			local now = os.clock()
			if now - lastCast >= XD_.Config.RodDelay then
				pcall(function()
					local char = XD_.LocalPlayer.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						XD_.RemoteEvent:FireServer("RodActivated", {
							LuckMulti = 2,
							Mouse = {
								Target = workspace.World.Map.Holder:FindFirstChild("Water"),
								Hit = char.HumanoidRootPart.CFrame * CFrame.new(0, -5, 5),
							},
						}, tick())
					end
				end)
				lastCast = now
			end
			if now - lastCatch >= XD_.Config.CatchDelay then
				pcall(function()
					XD_.RemoteEvent:FireServer("GotFish")
				end)
				lastCatch = now
			end
		end
		task.wait(XD_.FrameTime)
	end
end)

-- XZ.Local.Loop.AutoSell
task.spawn(function()
	while true do
		if XD_.Config.AutoSell then
			pcall(function()
				XD_.RemoteEvent:FireServer("SellInventory")
				XD_.Library:Notify("Inventory Sold!")
			end)
			task.wait(XD_.Config.SellDelay)
		else
			task.wait(1)
		end
	end
end)

-- XZ.Local.AntiAFK
XD_.LocalPlayer.Idled:Connect(function()
	XD_.VirtualUser:CaptureController()
	XD_.VirtualUser:ClickButton2(Vector2.new())
end)

-- XZ.Local.UI.Window
local Window = XD_.Library:CreateWindow({
	Title = "QweenHub v" .. XD_.Version .. " - Ultra Fast Fishing",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

local Tab = {
	Home = Window:AddTab("> Home"),
	Main = Window:AddTab("* Main"),
	Teleport = Window:AddTab("+ Teleport"),
	Stats = Window:AddTab("# Stats"),
	Misc = Window:AddTab("~ Misc"),
	Settings = Window:AddTab("= Settings"),
}

local gHomeLeft = Tab.Home:AddLeftGroupbox("> QweenHub Fishing")
gHomeLeft:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")
gHomeLeft:AddLabel("         QweenHub v" .. XD_.Version)
gHomeLeft:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")
gHomeLeft:AddDivider()
gHomeLeft:AddLabel("> Ultra Fast Fishing Script")
gHomeLeft:AddLabel("> Frame-Perfect Timing")
gHomeLeft:AddLabel("> Auto Lock Rare Fish")
gHomeLeft:AddLabel("> Discord Webhook Support")
gHomeLeft:AddDivider()
gHomeLeft:AddLabel("Warning: Very Blatant!")
gHomeLeft:AddLabel("Use at your own risk")

local gHomeRight = Tab.Home:AddRightGroupbox("+ Links & Support")
gHomeRight:AddButton("Copy Discord Link", function()
	if setclipboard then
		setclipboard("https://discord.gg/BbHbwgRfMS")
		XD_.Library:Notify("Discord link copied!")
	end
end)
gHomeRight:AddButton("Visit Website", function()
	if setclipboard then
		setclipboard("https://qweenhub.netlify.app/")
		XD_.Library:Notify("Website link copied!")
	end
end)
gHomeRight:AddDivider()
gHomeRight:AddLabel("Discord: discord.gg/BbHbwgRfMS")
gHomeRight:AddLabel("Web: qweenhub.netlify.app")

local gMainLeft = Tab.Main:AddLeftGroupbox("* Fishing Controls")
local gMainRight = Tab.Main:AddRightGroupbox("* Item Management")

gMainLeft:AddToggle("AutoFishToggle", {Text = "Auto Fish (Super Blatant)", Default = false, Callback = function(v) XD_.Config.AutoFish = v end})
gMainLeft:AddInput("RodDelayInput", {Default = "0.1", Numeric = true, Finished = true, Text = "Cast Delay (seconds)", Tooltip = "Min: 0.016s (1 frame) | Example: 0.5, 0.1, 0.05", Callback = function(v)
	XD_.Config.RodDelay = XD_.ValidateDelay(v)
	XD_.Library:Notify("Cast Delay: " .. string.format("%.3f", XD_.Config.RodDelay) .. "s")
end})
gMainLeft:AddInput("CatchDelayInput", {Default = "0.1", Numeric = true, Finished = true, Text = "Catch Delay (seconds)", Tooltip = "Min: 0.016s (1 frame) | Example: 0.5, 0.1, 0.05", Callback = function(v)
	XD_.Config.CatchDelay = XD_.ValidateDelay(v)
	XD_.Library:Notify("Catch Delay: " .. string.format("%.3f", XD_.Config.CatchDelay) .. "s")
end})
gMainLeft:AddLabel("> Min: 0.016s | Lower = Faster")

gMainRight:AddToggle("AutoSellToggle", {Text = "Auto Sell Inventory", Default = false, Callback = function(v) XD_.Config.AutoSell = v end})
gMainRight:AddToggle("AutoLockToggle", {Text = "Auto Lock/Favorite", Default = true, Callback = function(v) XD_.Config.AutoLock = v end})
gMainRight:AddDropdown("LockList", {Values = {"Common","Uncommon","Rare","Epic","Legendary","Mythical","Exotic"}, Default = {"Mythical","Exotic","Legendary"}, Multi = true, Text = "Rarities to Lock", Callback = function(v) XD_.Config.LockWhitelist = v end})

local gTeleport = Tab.Teleport:AddLeftGroupbox("+ Island Teleport")
gTeleport:AddDropdown("IslandSelect", {Values = {"Fisherman Island","Ignis Island"}, Default = 0, Multi = false, Text = "Select Island", Tooltip = "Instantly teleports to selected island", Callback = function(v)
	if XD_.IslandTP[v] then XD_.Teleport(XD_.IslandTP[v]) end
end})
gTeleport:AddLabel("> Fisherman: -575, 453, -185")
gTeleport:AddLabel("> Ignis: -1117, 452, 255")

local gStatsLeft = Tab.Stats:AddLeftGroupbox("# Live Statistics")
local gStatsRight = Tab.Stats:AddRightGroupbox("# Discord Webhook")

local lblRuntime = gStatsLeft:AddLabel("Runtime: 00:00:00")
local lblFish = gStatsLeft:AddLabel("Total Fish: 0")
local lblMoney = gStatsLeft:AddLabel("Estimated Earned: $0")
local lblBest = gStatsLeft:AddLabel("Top Catch: None")
local lblDelay = gStatsLeft:AddLabel("Delay: Cast=0.1s | Catch=0.1s")

task.spawn(function()
	while true do
		lblRuntime:SetText("Runtime: " .. XD_.FormatTime(tick() - XD_.Stats.StartTime))
		lblFish:SetText("Total Fish: " .. XD_.Stats.TotalFish)
		lblMoney:SetText("Estimated Earned: $" .. XD_.Stats.TotalMoney)
		lblDelay:SetText(string.format("Delay: Cast=%.2fs | Catch=%.2fs", XD_.Config.RodDelay, XD_.Config.CatchDelay))
		local best = "None"
		if XD_.Stats.Rarities.Exotic then best = "Exotic x" .. XD_.Stats.Rarities.Exotic
		elseif XD_.Stats.Rarities.Mythical then best = "Mythical x" .. XD_.Stats.Rarities.Mythical
		elseif XD_.Stats.Rarities.Legendary then best = "Legendary x" .. XD_.Stats.Rarities.Legendary end
		lblBest:SetText("Top Catch: " .. best)
		task.wait(1)
	end
end)

gStatsRight:AddInput("WebhookURL", {Default = "", Text = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/...", Callback = function(v) XD_.Config.WebhookUrl = v end})
gStatsRight:AddToggle("WebhookToggle", {Text = "Enable Webhook", Default = false, Callback = function(v) XD_.Config.WebhookEnabled = v end})
gStatsRight:AddDropdown("WebhookList", {Values = {"Rare","Epic","Legendary","Mythical","Exotic"}, Default = {"Mythical","Exotic"}, Multi = true, Text = "Rarities to Send", Callback = function(v) XD_.Config.WebhookWhitelist = v end})
gStatsRight:AddButton("Test Webhook", function()
	XD_.SendWebhook("Test Fish", "Mythical", 999999)
	XD_.Library:Notify("Test sent!")
end)

local gMiscLeft = Tab.Misc:AddLeftGroupbox("~ Performance")
local gMiscRight = Tab.Misc:AddRightGroupbox("~ Server")

gMiscLeft:AddToggle("WhiteScreen", {Text = "Black Screen Mode (3D Off)", Default = false, Callback = function(v) XD_.RunService:Set3dRenderingEnabled(not v) end})
gMiscLeft:AddButton("Cap FPS 15", function() if setfpscap then setfpscap(15) end end)
gMiscLeft:AddButton("Uncap FPS", function() if setfpscap then setfpscap(999) end end)

gMiscRight:AddButton("Server Hop", function()
	local servers = XD_.HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
	local list = {}
	for _, server in ipairs(servers) do
		if type(server) == "table" and server.playing < server.maxPlayers and server.id ~= game.JobId then
			table.insert(list, server.id)
		end
	end
	if #list > 0 then
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, list[math.random(1, #list)], XD_.LocalPlayer)
	end
end)

XD_.ThemeManager:SetLibrary(XD_.Library)
XD_.SaveManager:SetLibrary(XD_.Library)
XD_.SaveManager:IgnoreThemeSettings()
XD_.SaveManager:SetIgnoreIndexes({"WhiteScreen"})
XD_.ThemeManager:SetFolder("QweenHub")
XD_.SaveManager:SetFolder("QweenHub/configs")
XD_.SaveManager:BuildConfigSection(Tab.Settings)
XD_.ThemeManager:ApplyToTab(Tab.Settings)

local gAbout = Tab.Settings:AddLeftGroupbox("= About QweenHub")
gAbout:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")
gAbout:AddLabel("    QweenHub v" .. XD_.Version)
gAbout:AddLabel("    Ultra Fast Fishing")
gAbout:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")
gAbout:AddDivider()
gAbout:AddLabel("Made with love")
gAbout:AddLabel("Frame-Perfect Timing Engine")
gAbout:AddDivider()
gAbout:AddLabel("Discord: discord.gg/BbHbwgRfMS")
gAbout:AddLabel("Web: qweenhub.netlify.app")
gAbout:AddDivider()
gAbout:AddLabel("Use at your own risk!")
gAbout:AddLabel("Version: " .. XD_.Version .. " | 2024")

task.spawn(function()
	task.wait(0.5)
	XD_.SaveManager:LoadAutoloadConfig()
	task.wait(0.1)
	if Toggles then
		if Toggles.AutoFishToggle then XD_.Config.AutoFish = Toggles.AutoFishToggle.Value end
		if Toggles.AutoSellToggle then XD_.Config.AutoSell = Toggles.AutoSellToggle.Value end
		if Toggles.AutoLockToggle then XD_.Config.AutoLock = Toggles.AutoLockToggle.Value end
	end
	if Options then
		if Options.RodDelayInput and Options.RodDelayInput.Value then XD_.Config.RodDelay = XD_.ValidateDelay(Options.RodDelayInput.Value) end
		if Options.CatchDelayInput and Options.CatchDelayInput.Value then XD_.Config.CatchDelay = XD_.ValidateDelay(Options.CatchDelayInput.Value) end
	end
	XD_.Library:Notify("Config loaded! AutoFish: " .. tostring(XD_.Config.AutoFish))
end)

XD_.Library:OnUnload(function()
	XD_.Config.AutoFish = false
	XD_.Config.AutoSell = false
	XD_.Config.AutoLock = false
	XD_.RunService:Set3dRenderingEnabled(true)
	XD_.Library.Unloaded = true
end)

XD_.Notify("QweenHub v" .. XD_.Version, "Script Loaded Successfully!")

-- GG, QweenHub.lua
