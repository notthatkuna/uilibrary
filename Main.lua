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
    function draw()
        local background = Instance.new("Frame")
        doProtect(background)
        background.Name = title
        background.Parent = glob.BaseUi
        background.Size = UDim2.new(0.5, 0,0.5, 0)
        background.Position = UDim2.new(0.25, 0,0.249, 0)
        background.Transparency = 1
        background.ClipsDescendants = true
        local sidebar = Instance.new("ScrollingFrame")
        doProtect(sidebar)
        sidebar.Name = "PageList"
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
        titleText.Name = "Title"
        titleText.Parent = sidebar
        titleText.Text = title
        titleText.Size = UDim2.new(1, 0,0.05, 0)
        titleText.BackgroundTransparency = 1
        titleText.BorderSizePixel = 0
        titleText.TextColor3 = mainModule.colourScheme.text
        local sidepanel = Instance.new("Frame")
        doProtect(sidepanel)
        sidepanel.Name = "Content"
        sidepanel.Parent = background
        sidepanel.Size = UDim2.new(0.8, 0,1, 0)
        sidepanel.Position = UDim2.new(0.199, 0,0, 0)
        sidepanel.BorderSizePixel = 0
        sidepanel.BackgroundColor3 = mainModule.colourScheme.primary
    end
    draw()
	
	function glob:Page(title,description)
		local re = {}
        re.bts = {}
        re.disabled = false
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
        local hoverBar = Instance.new("Frame")
        doProtect(hoverBar)
        hoverBar.Name = re.title.."hoverbar"
        hoverbar.Parent = titleText
        hoverbar.BackgroundColor3 = mainModule.colourScheme.hover
        hoverbar.Position = UDim2.new(0,-100,0,100)
        hoverbar.Size = UDim2.new(1,0,0.05,0)
        hoverbar.BorderSizePixel = 0
        hoverbar.BackgroundTransparency = .5
        local conen
        local conle
        function onEnter()
            local goal = {}
            goal.Position = UDim2.new(0,50,0,100)
            local t = TweenService.Create(hoverbar,TweenInfo.new(.7),goal)
            t:Play()
        end
        function onLeave()
            local goal = {}
            goal.Position = UDim2.new(0,-100,0,100)
            local t = TweenService.Create(hoverbar,TweenInfo.new(.7),goal)
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
            local bu = Instance.new("Button")
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
    function glob:Redraw()
        glob.BaseUi:Destroy()
        draw()
    end
    -- start keybinds
    if RunService:IsClient() then
        local toggle = mainModule.keybinds["toggle"] or Enum.KeyCode.T
        local exit = mainModule.keybinds["hard_exit"] or Enum.KeyCode.X
        UserInputService.InputBegan:Connect(function(input,gameproc)
            if input.KeyCode == toggle then
                glob.BaseUi.Enabled = not glob.BaseUi.Enabled
            elseif input.KeyCode == exit then
                glob.BaseUi:Destroy()
            end
        end)
    end
	return glob
end

return mainModule
