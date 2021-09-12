local mainModule = {}

function doProtect(uiObject)
	if syn then syn.protect_gui(uiObject) end
end

local nonil = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

mainModule.keyboardSettings = { -- only works on the client
	["toggle"] = Enum.KeyCode.T,
	["hard_exit"] = Enum.KeyCode.X
}

mainModule.colourScheme = {
	["primary"]   = Color3.fromRGB(72, 72, 72),
	["secondary"] = Color3.fromRGB(48, 48, 48),
	["text"]      = Color3.fromRGB(255, 255, 255),
	["hover"]     = Color3.fromRGB(252, 3, 102)
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
	glob.init = false

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
	local background
	local sidebar
	local UILL
	local titleText
	local sidepanel
	background = Instance.new("Frame")
	doProtect(background)
	background.Name = title
	background.Parent = glob.BaseUi
	background.Size = UDim2.new(0.5, 0,0.5, 0)
	background.Position = UDim2.new(0.25, 0,0.249, 0)
	background.Transparency = 1
	background.ClipsDescendants = true
	sidebar = Instance.new("ScrollingFrame")
	doProtect(sidebar)
	sidebar.Name = "PageList"
	sidebar.Parent = background
	sidebar.Size = UDim2.new(0.2, 0,1, 0)
	sidebar.BackgroundColor3 = mainModule.colourScheme.secondary
	sidebar.BorderSizePixel = 0
	sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
	sidebar.ScrollBarThickness = 5
	UILL = Instance.new("UIListLayout")
	doProtect(UILL)
	UILL.Parent = sidebar
	UILL.Padding = UDim.new(0,5)
	UILL.FillDirection = Enum.FillDirection.Vertical
	UILL.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UILL.SortOrder = Enum.SortOrder.LayoutOrder
	UILL.VerticalAlignment = Enum.VerticalAlignment.Top
	titleText = Instance.new("TextButton")
	doProtect(titleText)
	titleText.Name = "Title"
	titleText.Parent = sidebar
	titleText.Text = title
	titleText.Size = UDim2.new(1, 0,0.05, 0)
	titleText.BackgroundTransparency = 1
	titleText.BorderSizePixel = 0
	titleText.TextColor3 = mainModule.colourScheme.text
	sidepanel = Instance.new("Frame")
	doProtect(sidepanel)
	sidepanel.Name = "Content"
	sidepanel.Parent = background
	sidepanel.Size = UDim2.new(0.8, 0,1, 0)
	sidepanel.Position = UDim2.new(0.199, 0,0, 0)
	sidepanel.BorderSizePixel = 0
	sidepanel.BackgroundColor3 = mainModule.colourScheme.primary
	glob.init = true
	glob.exiting = false
	glob.cantoggle = true

	function glob:Page(title,description)
		repeat wait() until glob.init
		local re = {}
		re.bts = {}
		re.disabled = false
		re.title = title or "Untitled Page"
		re.description = description or "This is a page"
		wait(.1)
		local titleText = Instance.new("TextButton")
		doProtect(titleText)
		titleText.Parent = sidebar
		titleText.Text = re.title.."\n"..re.description
		titleText.Size = UDim2.new(1, 0,0.05, 0)
		titleText.BackgroundTransparency = 1
		titleText.BorderSizePixel = 0
		titleText.TextColor3 = mainModule.colourScheme.text
		local hoverbar = Instance.new("Frame")
		doProtect(hoverbar)
		hoverbar.Name = re.title.."hoverbar"
		hoverbar.Parent = titleText
		hoverbar.Position = UDim2.new(0,-175,0,25)
		hoverbar.Size = UDim2.new(1,0,0.05,0)
		hoverbar.BorderSizePixel = 0
		hoverbar.BackgroundTransparency = .5
		hoverbar.BackgroundColor3 = mainModule.colourScheme.primary
		local conen
		local conle
		local function onEnter()
			local goal = {}
			goal.Position = UDim2.new(0,0,0,25)
			goal.BackgroundColor3 = mainModule.colourScheme.hover
			local t = TweenService:Create(hoverbar,TweenInfo.new(.5),goal)
			t:Play()
		end
		local function onLeave()
			local goal = {}
			goal.Position = UDim2.new(0,-175,0,25)
			goal.BackgroundColor3 = mainModule.colourScheme.primary
			local t = TweenService:Create(hoverbar,TweenInfo.new(.5),goal)
			t:Play()
		end
		conen = titleText.MouseEnter:Connect(onEnter)
		conle = titleText.MouseLeave:Connect(onLeave)
		function re:OverwriteMouseEnter(func)
			assert(typeof(func)=="function","Parameter must be a function")
			conen:Disconnect()
			conen = titleText.MouseEnter:Connect(func)
			return conen
		end
		function re:OverwriteMouseLeave(func)
			assert(typeof(func)=="function","Parameter must be a function")
			conle:Disconnect()
			conle = titleText.MouseLeave:Connect(func)
			return conle
		end
		function re:Destroy()
			titleText:Destroy()
			conen:Disconnect()
			conle:Disconnect()
			return true
		end
		function re:Disable()
			re.disabled = true
		end
		function re:Enable()
			re.disabled = false
		end
		function re:LockState(timeoutorfunc)
			if typeof(timeoutorfunc=="number") then
				local reached = false
				spawn(function()
					while not reached do
						wait()
						re:Disable()
					end
				end)
				wait(timeoutorfunc)
				reached = true
				wait()
				re:Enable()
			elseif typeof(timeoutorfunc=="function") then
				local reached = false
				spawn(function()
					while not reached do
						wait()
						re:Disable()
					end
				end)
				local r = timeoutorfunc()
				repeat wait() until r
				reached = true
				wait()
				re:Enable()
			else
				error("Parameter must be a timeout (number in seconds) or a function")
			end
		end
		function re:AddButton(bTitle)
			local butable = {}
			local bu = Instance.new("TextButton")
			doProtect(bu)
			bu.Parent = workspace
			local addr = {}
			addr["name"] = bTitle
			addr["reference"] = bu
			table.insert(re.bts,addr)
			local cev = Instance.new("BindableEvent")
			cev.Parent = glob.BaseUi
			butable.Clicked = cev.Event
			bu.Button1Down:Connect(function()
				cev:Fire()
			end)
			return butable
		end
		return re
	end
	-- start keybinds
	if game:GetService("RunService"):IsClient() then
		local toggle = mainModule.keyboardSettings["toggle"] or Enum.KeyCode.T
		local exit = mainModule.keyboardSettings["hard_exit"] or Enum.KeyCode.X
		UserInputService.InputBegan:Connect(function(input,gameproc)
			if input.KeyCode == toggle then
				if not glob.cantoggle then return end
				glob.BaseUi.Enabled = not glob.BaseUi.Enabled
			elseif input.KeyCode == exit then
				if glob.exiting then return end
				glob.cantoggle = false
				glob.exiting = true
				local goal = {}
				goal.Position = UDim2.new(1,0,0.249,0)
				local outTween = TweenService:Create(background,TweenInfo.new(3),goal)
				for index,pair in pairs(background:GetDescendants()) do
					if pair:IsA("GuiObject") then
						local goal = {}
						goal.BackgroundTransparency = 1
						if pair:IsA("TextButton") then
							goal.TextTransparency = 1
						end
						local outTween = TweenService:Create(pair,TweenInfo.new(4),goal)
						outTween:Play()
					end
				end
				outTween:Play()
				outTween.Completed:Connect(function()
					glob.BaseUi:Destroy()
				end)
			end
		end)
	end
	spawn(function()
		local blacklist = {}
		while wait() do
			for i,v in pairs(nonil) do
				if v.Parent == nil and not table.find(blacklist,v) then
					table.insert(blacklist,v)
					warn(v:GetFullName().." (NO_NIL_LIST) was found to be nil.")
				end
			end
		end
	end)
	return glob
end

return mainModule
