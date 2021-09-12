local mainModule = {}

function doProtect(uiObject)
	if syn then syn.protect_gui(uiObject) end
end

local nonil = {}

mainModule.keyboardSettings = { -- only works on the client
	["toggle"] = Enum.KeyCode.T,
	["hard_exit"] = Enum.KeyCode.X
}

mainModule.colourScheme = {
	["primary"]   = Color3.fromRGB(72, 72, 72),
	["secondary"] = Color3.fromRGB(48, 48, 48),
	["text"]      = Color3.fromRGB(255, 255, 255)
}

mainModule.Create = function(title, player)
	if game:GetService("RunService"):IsServer() and not player then error("When initializing a new LanjtUI UI on the server, a player parameter must be specified.") end
	if game:GetService("RunService"):IsClient() and player then player = nil warn("A player parameter was specified on LanjtUI intiialization, but it will not be used because script is running on the client.") end
	-- initialize resources
	local baseUI = Instance.new("ScreenGui")
	doProtect(baseUI)
	if syn or PROTOSMASHER_LOADED then
		baseUI.Parent = game.CoreGui
	else
		if player then
			if type(player) ~= "userdata" or not player:FindFirstChild("PlayerGui") then error("Player parameter was not a player") end
			baseUI.Parent = player.PlayerGui
		else
			baseUI.Parent = game:GetService("Players").LocalPlayer.PlayerGui
		end
	end
	nonil[#nonil+1] = baseUI
	local glob = {}
	glob.BaseUi = baseUI
	
	local removedBindable = Instance.new("BindableEvent")
	removedBindable.Parent = glob.BaseUi
	glob.Destroyed = removedBindable.Event -- glob.Destroyed:Connect(function()...
	baseUI.Parent.DescendantRemoving:Connect(function(c)
		if c == baseUI then
			removedBindable:Fire(tick())
		end
	end)
	
	-- i created this all programatically and by sight so dont bully me please :(
	local currentPage = 0
	local pages = 0
	local background = Instance.new("Frame")
	doProtect(background)
	background.Parent = glob.BaseUi
	background.Size = UDim2.new(0.5, 0,0.5, 0)
	background.Position = UDim2.new(0.25, 0,0.249, 0)
	background.Transparency = 1
	background.ClipsDescendants = true
	local sidebar = Instance.new("ScrollingFrame")
	doProtect(sidebar)
	sidebar.Parent = background
	sidebar.Size = UDim2.new(0.2, 0,1, 0)
	sidebar.BackgroundColor3 = mainModule.colourScheme.secondary
	sidebar.BorderSizePixel = 0
	sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
	sidebar.ScrollBarThickness = 5
	local UILL = Instance.new("UIListLayout")
	doProtect(UILL)
	UILL.Parent = sidebar
	UILL.Padding = UDim.new(0,5)
	local titleText = Instance.new("TextButton")
	doProtect(titleText)
	titleText.Parent = sidebar
	titleText.Text = title
	titleText.Size = UDim2.new(1, 0,0.05, 0)
	titleText.BackgroundTransparency = 1
	titleText.BorderSizePixel = 0
	titleText.TextColor3 = mainModule.colourScheme.text
	local sidepanel = Instance.new("Frame")
	doProtect(sidepanel)
	sidepanel.Parent = background
	sidepanel.Size = UDim2.new(0.8, 0,1, 0)
	sidepanel.Position = UDim2.new(0.199, 0,0, 0)
	sidepanel.BorderSizePixel = 0
	sidepanel.BackgroundColor3 = mainModule.colourScheme.primary
	
	function glob:Page(title,description)
		local re = {}
		re.title = title or "Untitled Page"
		re.description = description or "This is a page"
		local titleText = Instance.new("TextButton")
		doProtect(titleText)
		titleText.Parent = sidebar
		titleText.Text = re.title.."\n"..re.description
		titleText.Size = UDim2.new(1, 0,0.05, 0)
		titleText.BackgroundTransparency = 1
		titleText.BorderSizePixel = 0
		titleText.TextColor3 = mainModule.colourScheme.text
		return re
	end
	return glob
end

return mainModule
