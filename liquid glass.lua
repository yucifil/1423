local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local BACKGROUND_ID = "rbxassetid://116211389465318"

local FEATURES = {
	{ name = "界面显示", default = true },
	{ name = "背景模糊", default = true },
	{ name = "音效提示", default = false },
	{ name = "自动保存", default = false },
}

local old = playerGui:FindFirstChild("LiquidGlassMenu")
if old then
	old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "LiquidGlassMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = playerGui

local notifyContainer = Instance.new("Frame")
notifyContainer.Size = UDim2.new(0, 260, 0, 500)
notifyContainer.AnchorPoint = Vector2.new(1, 0.5)
notifyContainer.Position = UDim2.new(1, -20, 0.5, 0)
notifyContainer.BackgroundTransparency = 1
notifyContainer.ZIndex = 50
notifyContainer.Parent = gui

local notifyLayout = Instance.new("UIListLayout")
notifyLayout.Padding = UDim.new(0, 8)
notifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Center
notifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifyLayout.Parent = notifyContainer

local function showNotify(titleText, contentText)
	local notifyFrame = Instance.new("CanvasGroup")
	notifyFrame.Size = UDim2.new(1, 0, 0, 50)
	notifyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notifyFrame.BackgroundTransparency = 0.15
	notifyFrame.BorderSizePixel = 0
	notifyFrame.GroupTransparency = 1
	notifyFrame.Position = UDim2.new(1, 50, 0, 0)
	notifyFrame.ZIndex = 50
	notifyFrame.Parent = notifyContainer

	local nCorner = Instance.new("UICorner")
	nCorner.CornerRadius = UDim.new(0, 12)
	nCorner.Parent = notifyFrame

	local nStroke = Instance.new("UIStroke")
	nStroke.Color = Color3.fromRGB(255, 255, 255)
	nStroke.Transparency = 0.3
	nStroke.Thickness = 1
	nStroke.Parent = notifyFrame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 20)
	title.Position = UDim2.new(0, 10, 0, 6)
	title.BackgroundTransparency = 1
	title.Text = titleText
	title.TextColor3 = Color3.fromRGB(0, 0, 0)
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 51
	title.Parent = notifyFrame

	local content = Instance.new("TextLabel")
	content.Size = UDim2.new(1, -20, 0, 16)
	content.Position = UDim2.new(0, 10, 0, 26)
	content.BackgroundTransparency = 1
	content.Text = contentText
	content.TextColor3 = Color3.fromRGB(50, 50, 50)
	content.Font = Enum.Font.SourceSans
	content.TextSize = 12
	content.TextXAlignment = Enum.TextXAlignment.Left
	content.ZIndex = 51
	content.Parent = notifyFrame

	TweenService:Create(notifyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		GroupTransparency = 0,
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()

	task.delay(3, function()
		local t = TweenService:Create(notifyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			GroupTransparency = 1,
			Position = UDim2.new(1, 50, 0, 0)
		})
		t.Completed:Connect(function()
			notifyFrame:Destroy()
		end)
		t:Play()
	end)
end

local MusicVolume = 1
local MusicLoop = false
local currentSound = nil
local currentSongName = nil

local function StopMusic()
	if currentSound then
		pcall(function()
			currentSound:Stop()
			currentSound:Destroy()
		end)
		currentSound = nil
		currentSongName = nil
		return true
	end
	return false
end

local function PlayMusic(soundId, name)
	StopMusic()
	local id = tostring(soundId)
	if not string.find(id, "rbxassetid://") then
		id = "rbxassetid://" .. id:gsub("%s", "")
	end
	local s = Instance.new("Sound")
	s.Name = "榆Music"
	s.SoundId = id
	s.Volume = MusicVolume
	s.Looped = MusicLoop
	s.Parent = workspace

	local ok = pcall(function() s:Play() end)
	if not ok then
		pcall(function() s:Destroy() end)
		showNotify("播放失败", name .. " 无法播放")
		return
	end

	currentSound = s
	currentSongName = name
	pcall(function()
		s.Ended:Connect(function()
			if currentSound == s and not MusicLoop then
				currentSound = nil
				currentSongName = nil
			end
			pcall(function() s:Destroy() end)
		end)
	end)
	showNotify("正在播放", name)
end

local SONGS = {
	{ "进击的巨人",   "89711807693889" },
	{ "误闯天家",     "124384558101360" },
	{ "电音喂喂喂",   "90054735589094" },
	{ "不开心",       "88523902860927" },
	{ "震撼小曲二",   "137717310854691" },
	{ "曾经的王",     "121931252233493" },
	{ "离开我的依赖", "112834898401032" },
	{ "雨爱",         "79277371759525" },
	{ "爱酷",         "75047041148646" },
	{ "玉米饼",       "142376088" },
	{ "我太想进步了", "126846792948717" },
	{ "最初的记忆",   "108869978075942" },
	{ "海与你",       "76421239273915" },
	{ "失眠",         "138048397060431" },
	{ "传说之下",     "138048397060431" },
	{ "祖国人进行曲", "86555185586884" },
}

local function addMarquee(stroke)
	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 127, 0)),
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 150, 255)),
		ColorSequenceKeypoint.new(0.83, Color3.fromRGB(100, 0, 255)),
		ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 0, 255)),
	}
	grad.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.8),
		NumberSequenceKeypoint.new(0.5, 0.05),
		NumberSequenceKeypoint.new(1, 0.8),
	}
	grad.Parent = stroke
	local conn
	conn = RunService.RenderStepped:Connect(function(dt)
		if not stroke.Parent then
			conn:Disconnect()
			return
		end
		grad.Rotation = (grad.Rotation + dt * 120) % 360
	end)
	return conn
end

local main = Instance.new("CanvasGroup")
main.Name = "GlassPanel"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0, 540, 0, 360)
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Visible = false
main.GroupTransparency = 1
main.ZIndex = 10
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 24)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Transparency = 0.2
mainStroke.Thickness = 2
mainStroke.Parent = main
addMarquee(mainStroke)

local glassImage = Instance.new("ImageLabel")
glassImage.Name = "GlassImage"
glassImage.Size = UDim2.fromScale(1, 1)
glassImage.Position = UDim2.fromScale(0, 0)
glassImage.BackgroundTransparency = 1
glassImage.Image = BACKGROUND_ID
glassImage.ScaleType = Enum.ScaleType.Crop
glassImage.ImageTransparency = 0.15
glassImage.ZIndex = 11
glassImage.Parent = main

local imgCorner = Instance.new("UICorner")
imgCorner.CornerRadius = UDim.new(0, 24)
imgCorner.Parent = glassImage

local glassTint = Instance.new("Frame")
glassTint.Name = "GlassTint"
glassTint.Size = UDim2.fromScale(1, 1)
glassTint.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassTint.BackgroundTransparency = 0.85
glassTint.BorderSizePixel = 0
glassTint.ZIndex = 12
glassTint.Parent = main

local tintCorner = Instance.new("UICorner")
tintCorner.CornerRadius = UDim.new(0, 24)
tintCorner.Parent = glassTint

local glassTintGrad = Instance.new("UIGradient")
glassTintGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 245, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255)),
}
glassTintGrad.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.78),
	NumberSequenceKeypoint.new(0.5, 0.86),
	NumberSequenceKeypoint.new(1, 0.92),
}
glassTintGrad.Rotation = 135
glassTintGrad.Parent = glassTint

local topHighlight = Instance.new("Frame")
topHighlight.Name = "TopHighlight"
topHighlight.Size = UDim2.new(1, -24, 0, 2)
topHighlight.Position = UDim2.new(0, 12, 0, 4)
topHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topHighlight.BackgroundTransparency = 0.15
topHighlight.BorderSizePixel = 0
topHighlight.ZIndex = 13
topHighlight.Parent = main

local topHighlightCorner = Instance.new("UICorner")
topHighlightCorner.CornerRadius = UDim.new(1, 0)
topHighlightCorner.Parent = topHighlight

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundTransparency = 1
titleBar.Active = true
titleBar.ZIndex = 14
titleBar.Parent = main

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 16, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Liquid Glass"
titleText.TextColor3 = Color3.fromRGB(0, 0, 0)
titleText.TextStrokeTransparency = 0.5
titleText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 18
titleText.ZIndex = 15
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -12, 0.5, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 0.8
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.TextStrokeTransparency = 0.5
closeBtn.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 22
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 15
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 44)
content.Size = UDim2.new(1, 0, 1, -44)
content.BackgroundTransparency = 1
content.ZIndex = 14
content.Parent = main

local left = Instance.new("Frame")
left.Name = "LeftMenu"
left.Size = UDim2.new(0, 150, 1, 0)
left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
left.BackgroundTransparency = 0.94
left.BorderSizePixel = 0
left.ZIndex = 15
left.Parent = content

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 20)
leftCorner.Parent = left

local leftStroke = Instance.new("UIStroke")
leftStroke.Color = Color3.fromRGB(255, 255, 255)
leftStroke.Transparency = 0.5
leftStroke.Thickness = 1
leftStroke.Parent = left

local leftPad = Instance.new("UIPadding")
leftPad.PaddingTop = UDim.new(0, 18)
leftPad.PaddingBottom = UDim.new(0, 18)
leftPad.PaddingLeft = UDim.new(0, 12)
leftPad.PaddingRight = UDim.new(0, 12)
leftPad.Parent = left

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 24)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "菜单"
menuTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
menuTitle.TextStrokeTransparency = 0.5
menuTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.TextXAlignment = Enum.TextXAlignment.Left
menuTitle.Font = Enum.Font.SourceSansBold
menuTitle.TextSize = 14
menuTitle.ZIndex = 16
menuTitle.Parent = left

local menuList = Instance.new("Frame")
menuList.Position = UDim2.new(0, 0, 0, 32)
menuList.Size = UDim2.new(1, 0, 1, -32)
menuList.BackgroundTransparency = 1
menuList.ZIndex = 16
menuList.Parent = left

local menuLayout = Instance.new("UIListLayout")
menuLayout.Padding = UDim.new(0, 6)
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.Parent = menuList

local right = Instance.new("Frame")
right.Name = "RightPanel"
right.Position = UDim2.new(0, 154, 0, 0)
right.Size = UDim2.new(1, -154, 1, 0)
right.BackgroundTransparency = 1
right.BorderSizePixel = 0
right.ZIndex = 15
right.Parent = content

local rightPad = Instance.new("UIPadding")
rightPad.PaddingTop = UDim.new(0, 4)
rightPad.PaddingBottom = UDim.new(0, 4)
rightPad.PaddingLeft = UDim.new(0, 8)
rightPad.PaddingRight = UDim.new(0, 8)
rightPad.Parent = right

local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 24, 0, 24)
resizeHandle.AnchorPoint = Vector2.new(1, 1)
resizeHandle.Position = UDim2.new(1, -2, 1, -2)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Text = "◢"
resizeHandle.TextColor3 = Color3.fromRGB(0, 0, 0)
resizeHandle.TextTransparency = 0.5
resizeHandle.Font = Enum.Font.SourceSansBold
resizeHandle.TextSize = 20
resizeHandle.ZIndex = 25
resizeHandle.Parent = main

local resizing = false
local resizeStart = nil
local startSize = nil

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizing = true
		resizeStart = input.Position
		startSize = main.Size
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - resizeStart
		local newX = math.clamp(startSize.X.Offset + delta.X, 420, 850)
		local newY = math.clamp(startSize.Y.Offset + delta.Y, 300, 650)
		main.Size = UDim2.new(0, newX, 0, newY)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizing = false
	end
end)

local generalPanel = Instance.new("Frame")
generalPanel.Name = "GeneralPanel"
generalPanel.Size = UDim2.fromScale(1, 1)
generalPanel.BackgroundTransparency = 1
generalPanel.Visible = true
generalPanel.ZIndex = 16
generalPanel.Parent = right

local generalTitle = Instance.new("TextLabel")
generalTitle.Size = UDim2.new(1, 0, 0, 30)
generalTitle.BackgroundTransparency = 1
generalTitle.Text = "通用功能"
generalTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
generalTitle.TextStrokeTransparency = 0.5
generalTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
generalTitle.TextXAlignment = Enum.TextXAlignment.Left
generalTitle.Font = Enum.Font.SourceSansBold
generalTitle.TextSize = 20
generalTitle.ZIndex = 17
generalTitle.Parent = generalPanel

local list = Instance.new("ScrollingFrame")
list.Name = "FeatureList"
list.Position = UDim2.new(0, 0, 0, 38)
list.Size = UDim2.new(1, 0, 1, -38)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 0
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.ZIndex = 17
list.Parent = generalPanel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = list

local function createToggle(parent, text, default)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 46)
	row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	row.BackgroundTransparency = 0.9
	row.BorderSizePixel = 0
	row.ZIndex = 18
	row.Parent = parent

	local rc = Instance.new("UICorner")
	rc.CornerRadius = UDim.new(0, 12)
	rc.Parent = row

	local rs = Instance.new("UIStroke")
	rs.Color = Color3.fromRGB(255, 255, 255)
	rs.Transparency = 0.55
	rs.Thickness = 1
	rs.Parent = row

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -100, 1, 0)
	label.Position = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0.5
	label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 16
	label.ZIndex = 19
	label.Parent = row

	local btn = Instance.new("TextButton")
	btn.AnchorPoint = Vector2.new(1, 0.5)
	btn.Position = UDim2.new(1, -12, 0.5, 0)
	btn.Size = UDim2.new(0, 68, 0, 28)
	btn.BackgroundColor3 = default and Color3.fromRGB(180, 230, 255) or Color3.fromRGB(220, 220, 220)
	btn.Text = default and "ON" or "OFF"
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.TextStrokeTransparency = 0.5
	btn.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.ZIndex = 19
	btn.Parent = row

	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(1, 0)
	bc.Parent = btn

	local bs = Instance.new("UIStroke")
	bs.Color = Color3.fromRGB(255, 255, 255)
	bs.Transparency = 0.45
	bs.Thickness = 1
	bs.Parent = btn

	local state = default
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = state and "ON" or "OFF"
		TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = state and Color3.fromRGB(180, 230, 255) or Color3.fromRGB(220, 220, 220) }):Play()
	end)
end

for _, feature in ipairs(FEATURES) do
	createToggle(list, feature.name, feature.default)
end

local bgTransVal = 0.85

local bgTransRow = Instance.new("Frame")
bgTransRow.Size = UDim2.new(1, 0, 0, 46)
bgTransRow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bgTransRow.BackgroundTransparency = 0.9
bgTransRow.BorderSizePixel = 0
bgTransRow.ZIndex = 18
bgTransRow.Parent = list

local btrc = Instance.new("UICorner")
btrc.CornerRadius = UDim.new(0, 12)
btrc.Parent = bgTransRow

local btrs = Instance.new("UIStroke")
btrs.Color = Color3.fromRGB(255, 255, 255)
btrs.Transparency = 0.55
btrs.Thickness = 1
btrs.Parent = bgTransRow

local bgTransLabel = Instance.new("TextLabel")
bgTransLabel.Size = UDim2.new(1, -150, 1, 0)
bgTransLabel.Position = UDim2.new(0, 14, 0, 0)
bgTransLabel.BackgroundTransparency = 1
bgTransLabel.Text = "背景透明度"
bgTransLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
bgTransLabel.TextStrokeTransparency = 0.5
bgTransLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
bgTransLabel.TextXAlignment = Enum.TextXAlignment.Left
bgTransLabel.Font = Enum.Font.SourceSansBold
bgTransLabel.TextSize = 16
bgTransLabel.ZIndex = 19
bgTransLabel.Parent = bgTransRow

local btnMinus = Instance.new("TextButton")
btnMinus.Size = UDim2.new(0, 28, 0, 28)
btnMinus.AnchorPoint = Vector2.new(1, 0.5)
btnMinus.Position = UDim2.new(1, -84, 0.5, 0)
btnMinus.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
btnMinus.Text = "-"
btnMinus.TextColor3 = Color3.fromRGB(0, 0, 0)
btnMinus.Font = Enum.Font.SourceSansBold
btnMinus.TextSize = 18
btnMinus.AutoButtonColor = false
btnMinus.ZIndex = 19
btnMinus.Parent = bgTransRow

local bmc = Instance.new("UICorner")
bmc.CornerRadius = UDim.new(1, 0)
bmc.Parent = btnMinus

local transTxt = Instance.new("TextLabel")
transTxt.Size = UDim2.new(0, 44, 1, 0)
transTxt.AnchorPoint = Vector2.new(1, 0.5)
transTxt.Position = UDim2.new(1, -40, 0.5, 0)
transTxt.BackgroundTransparency = 1
transTxt.Text = math.floor(bgTransVal * 100) .. "%"
transTxt.TextColor3 = Color3.fromRGB(0, 0, 0)
transTxt.Font = Enum.Font.SourceSansBold
transTxt.TextSize = 14
transTxt.ZIndex = 19
transTxt.Parent = bgTransRow

local btnPlus = Instance.new("TextButton")
btnPlus.Size = UDim2.new(0, 28, 0, 28)
btnPlus.AnchorPoint = Vector2.new(1, 0.5)
btnPlus.Position = UDim2.new(1, -8, 0.5, 0)
btnPlus.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
btnPlus.Text = "+"
btnPlus.TextColor3 = Color3.fromRGB(0, 0, 0)
btnPlus.Font = Enum.Font.SourceSansBold
btnPlus.TextSize = 18
btnPlus.AutoButtonColor = false
btnPlus.ZIndex = 19
btnPlus.Parent = bgTransRow

local bpc = Instance.new("UICorner")
bpc.CornerRadius = UDim.new(1, 0)
bpc.Parent = btnPlus

local function updateBgTrans()
	glassTint.BackgroundTransparency = bgTransVal
	glassImage.ImageTransparency = math.clamp(bgTransVal * 0.6, 0.1, 0.7)
	transTxt.Text = math.floor(bgTransVal * 100) .. "%"
end

btnMinus.MouseButton1Click:Connect(function()
	bgTransVal = math.clamp(bgTransVal + 0.05, 0.1, 1)
	updateBgTrans()
end)

btnPlus.MouseButton1Click:Connect(function()
	bgTransVal = math.clamp(bgTransVal - 0.05, 0.1, 1)
	updateBgTrans()
end)

local testNotifyBtn = Instance.new("TextButton")
testNotifyBtn.Size = UDim2.new(1, 0, 0, 46)
testNotifyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
testNotifyBtn.BackgroundTransparency = 0.9
testNotifyBtn.BorderSizePixel = 0
testNotifyBtn.Text = "点击测试右侧提示"
testNotifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
testNotifyBtn.TextStrokeTransparency = 0.5
testNotifyBtn.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
testNotifyBtn.Font = Enum.Font.SourceSansBold
testNotifyBtn.TextSize = 16
testNotifyBtn.AutoButtonColor = false
testNotifyBtn.ZIndex = 18
testNotifyBtn.Parent = list

local tnCorner = Instance.new("UICorner")
tnCorner.CornerRadius = UDim.new(0, 12)
tnCorner.Parent = testNotifyBtn

local tnStroke = Instance.new("UIStroke")
tnStroke.Color = Color3.fromRGB(255, 255, 255)
tnStroke.Transparency = 0.55
tnStroke.Thickness = 1
tnStroke.Parent = testNotifyBtn

testNotifyBtn.MouseButton1Click:Connect(function()
	showNotify("系统提示", "这是一个从屏幕右侧滑入的提示！")
end)

local musicPanel = Instance.new("Frame")
musicPanel.Name = "MusicPanel"
musicPanel.Size = UDim2.fromScale(1, 1)
musicPanel.BackgroundTransparency = 1
musicPanel.Visible = false
musicPanel.ZIndex = 16
musicPanel.Parent = right

local musicTitle = Instance.new("TextLabel")
musicTitle.Size = UDim2.new(1, 0, 0, 30)
musicTitle.BackgroundTransparency = 1
musicTitle.Text = "音乐播放器"
musicTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
musicTitle.TextStrokeTransparency = 0.5
musicTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
musicTitle.TextXAlignment = Enum.TextXAlignment.Left
musicTitle.Font = Enum.Font.SourceSansBold
musicTitle.TextSize = 20
musicTitle.ZIndex = 17
musicTitle.Parent = musicPanel

local musicList = Instance.new("ScrollingFrame")
musicList.Position = UDim2.new(0, 0, 0, 38)
musicList.Size = UDim2.new(1, 0, 1, -38)
musicList.BackgroundTransparency = 1
musicList.BorderSizePixel = 0
musicList.ScrollBarThickness = 2
musicList.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
musicList.CanvasSize = UDim2.new(0, 0, 0, 0)
musicList.AutomaticCanvasSize = Enum.AutomaticSize.Y
musicList.ZIndex = 17
musicList.Parent = musicPanel

local mListLayout = Instance.new("UIListLayout")
mListLayout.Padding = UDim.new(0, 6)
mListLayout.SortOrder = Enum.SortOrder.LayoutOrder
mListLayout.Parent = musicList

local function createMusicBtn(title, desc, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundTransparency = 0.9
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.ZIndex = 18
	btn.Parent = musicList

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = btn

	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(255, 255, 255)
	s.Transparency = 0.5
	s.Thickness = 1
	s.Parent = btn

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -20, 0, 20)
	t.Position = UDim2.new(0, 10, 0, 4)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = Color3.fromRGB(0, 0, 0)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Font = Enum.Font.SourceSansBold
	t.TextSize = 14
	t.ZIndex = 19
	t.Parent = btn

	local d = Instance.new("TextLabel")
	d.Size = UDim2.new(1, -20, 0, 14)
	d.Position = UDim2.new(0, 10, 0, 22)
	d.BackgroundTransparency = 1
	d.Text = desc
	d.TextColor3 = Color3.fromRGB(100, 100, 100)
	d.TextXAlignment = Enum.TextXAlignment.Left
	d.Font = Enum.Font.SourceSans
	d.TextSize = 11
	d.ZIndex = 19
	d.Parent = btn

	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.7}):Play()
		task.delay(0.1, function()
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.9}):Play()
		end)
		callback()
	end)
	return btn
end

local volFrame = Instance.new("Frame")
volFrame.Size = UDim2.new(1, -6, 0, 40)
volFrame.BackgroundTransparency = 1
volFrame.LayoutOrder = 1
volFrame.ZIndex = 18
volFrame.Parent = musicList

local volBtnMinus = Instance.new("TextButton")
volBtnMinus.Size = UDim2.new(0, 30, 1, 0)
volBtnMinus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
volBtnMinus.BackgroundTransparency = 0.8
volBtnMinus.Text = "-"
volBtnMinus.TextColor3 = Color3.fromRGB(0, 0, 0)
volBtnMinus.Font = Enum.Font.SourceSansBold
volBtnMinus.TextSize = 18
volBtnMinus.ZIndex = 19
volBtnMinus.Parent = volFrame

local volCorner1 = Instance.new("UICorner")
volCorner1.CornerRadius = UDim.new(0, 10)
volCorner1.Parent = volBtnMinus

local volTxt = Instance.new("TextLabel")
volTxt.Size = UDim2.new(1, -80, 1, 0)
volTxt.Position = UDim2.new(0, 40, 0, 0)
volTxt.BackgroundTransparency = 1
volTxt.Text = "音量: 1.0"
volTxt.TextColor3 = Color3.fromRGB(0, 0, 0)
volTxt.Font = Enum.Font.SourceSansBold
volTxt.TextSize = 14
volTxt.ZIndex = 19
volTxt.Parent = volFrame

local volBtnPlus = Instance.new("TextButton")
volBtnPlus.Size = UDim2.new(0, 30, 1, 0)
volBtnPlus.Position = UDim2.new(1, -30, 0, 0)
volBtnPlus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
volBtnPlus.BackgroundTransparency = 0.8
volBtnPlus.Text = "+"
volBtnPlus.TextColor3 = Color3.fromRGB(0, 0, 0)
volBtnPlus.Font = Enum.Font.SourceSansBold
volBtnPlus.TextSize = 18
volBtnPlus.ZIndex = 19
volBtnPlus.Parent = volFrame

local volCorner2 = Instance.new("UICorner")
volCorner2.CornerRadius = UDim.new(0, 10)
volCorner2.Parent = volBtnPlus

volBtnMinus.MouseButton1Click:Connect(function()
	MusicVolume = math.clamp(MusicVolume - 0.1, 0, 1)
	volTxt.Text = string.format("音量: %.1f", MusicVolume)
	if currentSound then currentSound.Volume = MusicVolume end
end)

volBtnPlus.MouseButton1Click:Connect(function()
	MusicVolume = math.clamp(MusicVolume + 0.1, 0, 1)
	volTxt.Text = string.format("音量: %.1f", MusicVolume)
	if currentSound then currentSound.Volume = MusicVolume end
end)

createMusicBtn("单曲循环", "当前状态: 关闭", function()
	MusicLoop = not MusicLoop
	if currentSound then currentSound.Looped = MusicLoop end
	showNotify("播放设置", "单曲循环已" .. (MusicLoop and "开启" or "关闭"))
end).LayoutOrder = 2

createMusicBtn("停止播放", currentSongName or "当前没有播放", function()
	if StopMusic() then
		showNotify("已停止", "音乐已停止播放")
	else
		showNotify("提示", "当前没有正在播放的音乐")
	end
end).LayoutOrder = 3

local customInput = Instance.new("TextBox")
customInput.Size = UDim2.new(1, -6, 0, 36)
customInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
customInput.BackgroundTransparency = 0.7
customInput.PlaceholderText = "输入音乐 ID 或链接..."
customInput.Text = ""
customInput.TextColor3 = Color3.fromRGB(0, 0, 0)
customInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
customInput.Font = Enum.Font.SourceSans
customInput.TextSize = 14
customInput.LayoutOrder = 4
customInput.ZIndex = 18
customInput.Parent = musicList

local customCorner = Instance.new("UICorner")
customCorner.CornerRadius = UDim.new(0, 10)
customCorner.Parent = customInput

local customBtn = createMusicBtn("播放自定义音乐", "使用上方输入的 ID", function()
	local text = customInput.Text:gsub("%s", "")
	if text == "" then
		showNotify("播放失败", "请先填写音乐 ID")
	else
		PlayMusic(text, "自定义音乐")
	end
end)
customBtn.LayoutOrder = 5

for i, song in ipairs(SONGS) do
	local b = createMusicBtn("▶ " .. song[1], "ID: " .. song[2], function()
		PlayMusic(song[2], song[1])
	end)
	b.LayoutOrder = 10 + i
end

local lumaPanel = Instance.new("Frame")
lumaPanel.Name = "LumaPanel"
lumaPanel.Size = UDim2.fromScale(1, 1)
lumaPanel.BackgroundTransparency = 1
lumaPanel.Visible = false
lumaPanel.ZIndex = 16
lumaPanel.Parent = right

local lumaTitle = Instance.new("TextLabel")
lumaTitle.Size = UDim2.new(1, 0, 0, 30)
lumaTitle.BackgroundTransparency = 1
lumaTitle.Text = "音乐+翻译模块"
lumaTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
lumaTitle.TextStrokeTransparency = 0.5
lumaTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
lumaTitle.TextXAlignment = Enum.TextXAlignment.Left
lumaTitle.Font = Enum.Font.SourceSansBold
lumaTitle.TextSize = 20
lumaTitle.ZIndex = 17
lumaTitle.Parent = lumaPanel

local lumaDesc = Instance.new("TextLabel")
lumaDesc.Position = UDim2.new(0, 0, 0, 40)
lumaDesc.Size = UDim2.new(1, 0, 0, 60)
lumaDesc.BackgroundTransparency = 1
lumaDesc.Text = "点击下方按钮加载外部 Luma 翻译模块。\n加载成功后，当前 Liquid Glass UI 将自动隐藏。"
lumaDesc.TextColor3 = Color3.fromRGB(60, 60, 60)
lumaDesc.TextXAlignment = Enum.TextXAlignment.Left
lumaDesc.TextYAlignment = Enum.TextYAlignment.Top
lumaDesc.Font = Enum.Font.SourceSans
lumaDesc.TextSize = 14
lumaDesc.ZIndex = 17
lumaDesc.Parent = lumaPanel

local loadLumaBtn = Instance.new("TextButton")
loadLumaBtn.Size = UDim2.new(1, -6, 0, 50)
loadLumaBtn.Position = UDim2.new(0, 0, 0, 110)
loadLumaBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadLumaBtn.BackgroundTransparency = 0.8
loadLumaBtn.BorderSizePixel = 0
loadLumaBtn.Text = "🚀 启动 Luma 翻译模块"
loadLumaBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
loadLumaBtn.Font = Enum.Font.SourceSansBold
loadLumaBtn.TextSize = 16
loadLumaBtn.AutoButtonColor = false
loadLumaBtn.ZIndex = 18
loadLumaBtn.Parent = lumaPanel

local lumaBtnCorner = Instance.new("UICorner")
lumaBtnCorner.CornerRadius = UDim.new(0, 12)
lumaBtnCorner.Parent = loadLumaBtn

local lumaBtnStroke = Instance.new("UIStroke")
lumaBtnStroke.Color = Color3.fromRGB(255, 255, 255)
lumaBtnStroke.Transparency = 0.5
lumaBtnStroke.Thickness = 1
lumaBtnStroke.Parent = loadLumaBtn

loadLumaBtn.MouseButton1Click:Connect(function()
	TweenService:Create(loadLumaBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.6}):Play()
	task.delay(0.1, function()
		TweenService:Create(loadLumaBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.8}):Play()
	end)

	local success, err = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yucifil/1423/main/luma%E7%BF%BB%E8%AF%91.lua"))()
	end)

	if success then
		showNotify("加载成功", "Luma 翻译模块已启动")
		closePanel()
	else
		showNotify("加载失败", tostring(err))
	end
end)

local aboutPanel = Instance.new("ScrollingFrame")
aboutPanel.Name = "AboutPanel"
aboutPanel.Size = UDim2.fromScale(1, 1)
aboutPanel.BackgroundTransparency = 1
aboutPanel.BorderSizePixel = 0
aboutPanel.ScrollBarThickness = 0
aboutPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
aboutPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
aboutPanel.Visible = false
aboutPanel.ZIndex = 16
aboutPanel.Parent = right

local aboutLayout = Instance.new("UIListLayout")
aboutLayout.Padding = UDim.new(0, 6)
aboutLayout.SortOrder = Enum.SortOrder.LayoutOrder
aboutLayout.Parent = aboutPanel

local aboutTitle = Instance.new("TextLabel")
aboutTitle.Size = UDim2.new(1, 0, 0, 30)
aboutTitle.BackgroundTransparency = 1
aboutTitle.Text = "关于玩家 & 服务器"
aboutTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
aboutTitle.TextStrokeTransparency = 0.5
aboutTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
aboutTitle.TextXAlignment = Enum.TextXAlignment.Left
aboutTitle.Font = Enum.Font.SourceSansBold
aboutTitle.TextSize = 20
aboutTitle.LayoutOrder = 1
aboutTitle.ZIndex = 17
aboutTitle.Parent = aboutPanel

local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, -6, 0, 150)
infoFrame.BackgroundTransparency = 1
infoFrame.LayoutOrder = 2
infoFrame.ZIndex = 17
infoFrame.Parent = aboutPanel

local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, 80, 0, 80)
avatarFrame.AnchorPoint = Vector2.new(0.5, 0)
avatarFrame.Position = UDim2.new(0.5, 0, 0, 10)
avatarFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
avatarFrame.BackgroundTransparency = 0.8
avatarFrame.BorderSizePixel = 0
avatarFrame.ZIndex = 18
avatarFrame.Parent = infoFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarFrame

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.fromScale(1, 1)
avatarImg.BackgroundTransparency = 1
avatarImg.ZIndex = 19
avatarImg.Parent = avatarFrame

local avatarImgCorner = Instance.new("UICorner")
avatarImgCorner.CornerRadius = UDim.new(1, 0)
avatarImgCorner.Parent = avatarImg

pcall(function()
	local url = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
	avatarImg.Image = url
end)

local aboutName = Instance.new("TextLabel")
aboutName.Position = UDim2.new(0, 0, 0, 100)
aboutName.Size = UDim2.new(1, 0, 0, 20)
aboutName.BackgroundTransparency = 1
aboutName.Text = player.DisplayName .. "  @" .. player.Name
aboutName.TextColor3 = Color3.fromRGB(0, 0, 0)
aboutName.TextStrokeTransparency = 0.5
aboutName.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
aboutName.Font = Enum.Font.SourceSansBold
aboutName.TextSize = 16
aboutName.ZIndex = 18
aboutName.Parent = infoFrame

local function makeInfoRow(parent, label, value, yPos)
	local row = Instance.new("Frame")
	row.Position = UDim2.new(0, 0, 0, yPos)
	row.Size = UDim2.new(1, -6, 0, 26)
	row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	row.BackgroundTransparency = 0.9
	row.BorderSizePixel = 0
	row.ZIndex = 18
	row.Parent = parent
	row.LayoutOrder = yPos

	local rc = Instance.new("UICorner")
	rc.CornerRadius = UDim.new(0, 8)
	rc.Parent = row

	local key = Instance.new("TextLabel")
	key.Size = UDim2.new(0.4, 0, 1, 0)
	key.Position = UDim2.new(0, 10, 0, 0)
	key.BackgroundTransparency = 1
	key.Text = label
	key.TextColor3 = Color3.fromRGB(0, 0, 0)
	key.TextStrokeTransparency = 0.5
	key.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	key.TextXAlignment = Enum.TextXAlignment.Left
	key.Font = Enum.Font.SourceSans
	key.TextSize = 12
	key.ZIndex = 19
	key.Parent = row

	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0.6, -10, 1, 0)
	val.Position = UDim2.new(0.4, 0, 0, 0)
	val.BackgroundTransparency = 1
	val.Text = value
	val.TextColor3 = Color3.fromRGB(0, 0, 0)
	val.TextStrokeTransparency = 0.5
	val.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	val.TextXAlignment = Enum.TextXAlignment.Right
	val.Font = Enum.Font.SourceSansBold
	val.TextSize = 12
	val.TextTruncate = Enum.TextTruncate.AtEnd
	val.ZIndex = 19
	val.Parent = row

	return row
end

local serverTitle = Instance.new("TextLabel")
serverTitle.Size = UDim2.new(1, 0, 0, 24)
serverTitle.BackgroundTransparency = 1
serverTitle.Text = "服务器跳转"
serverTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
serverTitle.TextStrokeTransparency = 0.5
serverTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
serverTitle.TextXAlignment = Enum.TextXAlignment.Left
serverTitle.Font = Enum.Font.SourceSansBold
serverTitle.TextSize = 14
serverTitle.LayoutOrder = 4
serverTitle.ZIndex = 17
serverTitle.Parent = aboutPanel

local function createServerBtn(title, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundTransparency = 0.9
	btn.BorderSizePixel = 0
	btn.Text = title
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.ZIndex = 18
	btn.Parent = aboutPanel

	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 8)
	bc.Parent = btn

	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.7}):Play()
		task.delay(0.1, function()
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.9}):Play()
		end)
		callback()
	end)
	return btn
end

local TargetJobId = ""

makeInfoRow(aboutPanel, "玩家 ID", tostring(player.UserId), 3).LayoutOrder = 3
makeInfoRow(aboutPanel, "服务器 ID", game.JobId ~= "" and game.JobId or "本地测试", 5).LayoutOrder = 5

createServerBtn("重新加入当前服务器", function()
	if game.JobId and game.JobId ~= "" then
		pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)
	else
		showNotify("重连失败", "无法获取当前服务器 ID")
	end
end).LayoutOrder = 6

createServerBtn("服务器跳跃 (随机)", function()
	local success, res = pcall(function()
		return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
	end)
	if success and res and res.data and #res.data > 0 then
		local chosen = res.data[math.random(1, #res.data)]
		TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen.id, player)
	else
		showNotify("跳跃失败", "没有找到可用的服务器")
	end
end).LayoutOrder = 7

createServerBtn("加入人少的服务器", function()
	local success, res = pcall(function()
		return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
	end)
	if success and res and res.data and #res.data > 0 then
		table.sort(res.data, function(a, b) return a.playing < b.playing end)
		TeleportService:TeleportToPlaceInstance(game.PlaceId, res.data[1].id, player)
	else
		showNotify("跳跃失败", "没有找到可用的服务器")
	end
end).LayoutOrder = 8

createServerBtn("复制当前服务器 ID", function()
	if game.JobId and game.JobId ~= "" then
		if setclipboard then
			setclipboard(game.JobId)
			showNotify("复制成功", "服务器 ID 已复制到剪贴板")
		else
			showNotify("复制失败", "当前环境不支持 setclipboard")
		end
	else
		showNotify("复制失败", "无法获取当前服务器 ID")
	end
end).LayoutOrder = 9

local jobInput = Instance.new("TextBox")
jobInput.Size = UDim2.new(1, -6, 0, 32)
jobInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
jobInput.BackgroundTransparency = 0.7
jobInput.PlaceholderText = "粘贴服务器 JobId..."
jobInput.Text = ""
jobInput.TextColor3 = Color3.fromRGB(0, 0, 0)
jobInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
jobInput.Font = Enum.Font.SourceSans
jobInput.TextSize = 13
jobInput.LayoutOrder = 10
jobInput.ZIndex = 18
jobInput.Parent = aboutPanel

local jobCorner = Instance.new("UICorner")
jobCorner.CornerRadius = UDim.new(0, 8)
jobCorner.Parent = jobInput

jobInput:GetPropertyChangedSignal("Text"):Connect(function()
	TargetJobId = jobInput.Text
end)

createServerBtn("加入特定服务器", function()
	if not TargetJobId or TargetJobId == "" then
		showNotify("加入失败", "请先在上方粘贴服务器 ID")
		return
	end
	local success, err = pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, TargetJobId, player)
	end)
	if success then
		showNotify("正在传送", "正在加入: " .. TargetJobId)
	else
		showNotify("加入失败", tostring(err))
	end
end).LayoutOrder = 11

local menuButtons = {}
local MENU_ITEMS = {
	{ name = "通用功能", key = "general" },
	{ name = "音乐播放", key = "music" },
	{ name = "音乐+翻译", key = "luma" },
	{ name = "关于/服务器", key = "about" },
}

local function setActiveMenu(key)
	for k, item in pairs(menuButtons) do
		if k == key then
			item.Button.BackgroundTransparency = 0.7
			item.Stroke.Transparency = 0.15
		else
			item.Button.BackgroundTransparency = 0.95
			item.Stroke.Transparency = 0.7
		end
	end
	generalPanel.Visible = (key == "general")
	musicPanel.Visible = (key == "music")
	lumaPanel.Visible = (key == "luma")
	aboutPanel.Visible = (key == "about")
end

for i, item in ipairs(MENU_ITEMS) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundTransparency = 0.95
	btn.BorderSizePixel = 0
	btn.Text = item.name
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.TextStrokeTransparency = 0.5
	btn.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.LayoutOrder = i
	btn.ZIndex = 18
	btn.Parent = menuList

	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 12)
	bc.Parent = btn

	local bs = Instance.new("UIStroke")
	bs.Color = Color3.fromRGB(255, 255, 255)
	bs.Transparency = 0.7
	bs.Thickness = 1
	bs.Parent = btn

	btn.MouseButton1Click:Connect(function()
		setActiveMenu(item.key)
	end)

	menuButtons[item.key] = { Button = btn, Stroke = bs }
end

setActiveMenu("general")

local uiScale = Instance.new("UIScale")
uiScale.Parent = main

local camera = workspace.CurrentCamera
local function updateScale()
	if not camera then camera = workspace.CurrentCamera end
	local vp = camera and camera.ViewportSize or Vector2.new(1280, 720)
	uiScale.Scale = math.clamp(math.min(vp.X / 700, vp.Y / 500), 0.7, 1.15)
end
updateScale()
if camera then
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

local dialogOverlay = Instance.new("TextButton")
dialogOverlay.Name = "DialogOverlay"
dialogOverlay.Size = UDim2.fromScale(1, 1)
dialogOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dialogOverlay.BackgroundTransparency = 0.5
dialogOverlay.Text = ""
dialogOverlay.AutoButtonColor = false
dialogOverlay.Visible = false
dialogOverlay.ZIndex = 30
dialogOverlay.Parent = gui

local dialog = Instance.new("CanvasGroup")
dialog.Name = "ConfirmDialog"
dialog.AnchorPoint = Vector2.new(0.5, 0.5)
dialog.Position = UDim2.fromScale(0.5, 0.5)
dialog.Size = UDim2.new(0, 280, 0, 160)
dialog.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dialog.BackgroundTransparency = 0.9
dialog.BorderSizePixel = 0
dialog.GroupTransparency = 1
dialog.Visible = false
dialog.ZIndex = 31
dialog.Parent = gui

local dCorner = Instance.new("UICorner")
dCorner.CornerRadius = UDim.new(0, 16)
dCorner.Parent = dialog

local dStroke = Instance.new("UIStroke")
dStroke.Color = Color3.fromRGB(255, 255, 255)
dStroke.Transparency = 0.5
dStroke.Thickness = 1.5
dStroke.Parent = dialog

local dTitle = Instance.new("TextLabel")
dTitle.Size = UDim2.new(1, 0, 0, 40)
dTitle.Position = UDim2.new(0, 0, 0, 10)
dTitle.BackgroundTransparency = 1
dTitle.Text = "提示"
dTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
dTitle.TextStrokeTransparency = 0.5
dTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
dTitle.Font = Enum.Font.SourceSansBold
dTitle.TextSize = 18
dTitle.ZIndex = 32
dTitle.Parent = dialog

local dMsg = Instance.new("TextLabel")
dMsg.Size = UDim2.new(1, -20, 0, 40)
dMsg.Position = UDim2.new(0, 10, 0, 50)
dMsg.BackgroundTransparency = 1
dMsg.Text = "要关闭所有 UI 吗？"
dMsg.TextColor3 = Color3.fromRGB(0, 0, 0)
dMsg.TextStrokeTransparency = 0.5
dMsg.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
dMsg.Font = Enum.Font.SourceSans
dMsg.TextSize = 16
dMsg.ZIndex = 32
dMsg.Parent = dialog

local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, -40, 0, 36)
btnContainer.Position = UDim2.new(0, 20, 1, -50)
btnContainer.BackgroundTransparency = 1
btnContainer.ZIndex = 32
btnContainer.Parent = dialog

local btnLayout = Instance.new("UIListLayout")
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
btnLayout.Padding = UDim.new(0, 12)
btnLayout.Parent = btnContainer

local function createDialogBtn(text, isPrimary)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 100, 0, 34)
	b.BackgroundColor3 = isPrimary and Color3.fromRGB(180, 230, 255) or Color3.fromRGB(220, 220, 220)
	b.Text = text
	b.TextColor3 = Color3.fromRGB(0, 0, 0)
	b.TextStrokeTransparency = 0.5
	b.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 15
	b.AutoButtonColor = false
	b.ZIndex = 33
	b.Parent = btnContainer
	
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = b
	
	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(255, 255, 255)
	s.Transparency = 0.5
	s.Thickness = 1
	s.Parent = b
	
	return b
end

local btnCancel = createDialogBtn("取消", false)
local btnConfirm = createDialogBtn("确定", true)

local dialogScale = Instance.new("UIScale")
dialogScale.Scale = 0.8
dialogScale.Parent = dialog

local function showConfirmDialog()
	dialogOverlay.Visible = true
	dialog.Visible = true
	dialog.GroupTransparency = 1
	dialogScale.Scale = 0.8
	TweenService:Create(dialog, TweenInfo.new(0.2), {GroupTransparency = 0}):Play()
	TweenService:Create(dialogScale, TweenInfo.new(0.2), {Scale = 1}):Play()
end

local function hideConfirmDialog()
	dialog.Visible = false
	dialogOverlay.Visible = false
end

local function openPanel()
	if main.Visible then return end
	main.Visible = true
	main.GroupTransparency = 1
	TweenService:Create(main, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
end

local function closePanel()
	main.Visible = false
	main.GroupTransparency = 1
	dialog.Visible = false
	dialogOverlay.Visible = false
end

closeBtn.MouseButton1Click:Connect(showConfirmDialog)
btnCancel.MouseButton1Click:Connect(hideConfirmDialog)
dialogOverlay.MouseButton1Click:Connect(hideConfirmDialog)

btnConfirm.MouseButton1Click:Connect(function()
	hideConfirmDialog()
	StopMusic()
	gui:Destroy()
end)

local draggingMain = false
local dragStartMain = nil
local startPosMain = nil

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingMain = true
		dragStartMain = input.Position
		startPosMain = main.Position
	end
end)

local isDraggingIsland = false
local islandDragStart = nil
local islandStartPos = nil

local island = Instance.new("TextButton")
island.Name = "DynamicIsland"
island.AnchorPoint = Vector2.new(0.5, 0)
island.Position = UDim2.new(0.5, 0, 0, 8)
island.Size = UDim2.new(0, 128, 0, 34)
island.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
island.BackgroundTransparency = 0.65
island.Text = "Liquid Glass"
island.TextColor3 = Color3.fromRGB(255, 255, 255)
island.TextStrokeTransparency = 0.6
island.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
island.Font = Enum.Font.SourceSansBold
island.TextSize = 14
island.AutoButtonColor = false
island.ZIndex = 20
island.Parent = gui

local islandCorner = Instance.new("UICorner")
islandCorner.CornerRadius = UDim.new(1, 0)
islandCorner.Parent = island

local islandHighLight = Instance.new("UIGradient")
islandHighLight.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
}
islandHighLight.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.7),
	NumberSequenceKeypoint.new(0.5, 0.95),
	NumberSequenceKeypoint.new(1, 0.9),
}
islandHighLight.Rotation = 90
islandHighLight.Parent = island

local islandStroke = Instance.new("UIStroke")
islandStroke.Color = Color3.fromRGB(255, 255, 255)
islandStroke.Transparency = 0.5
islandStroke.Thickness = 1.5
islandStroke.Parent = island
addMarquee(islandStroke)

local islandScale = Instance.new("UIScale")
islandScale.Parent = island

island.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDraggingIsland = false
		islandDragStart = input.Position
		islandStartPos = island.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = Vector2.new(input.Position.X - dragStartMain.X, input.Position.Y - dragStartMain.Y)
		main.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
	end
	
	if islandDragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = Vector2.new(input.Position.X - islandDragStart.X, input.Position.Y - islandDragStart.Y)
		if delta.Magnitude > 5 then
			isDraggingIsland = true
		end
		if isDraggingIsland then
			island.Position = UDim2.new(islandStartPos.X.Scale, islandStartPos.X.Offset + delta.X, islandStartPos.Y.Scale, islandStartPos.Y.Offset + delta.Y)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingMain = false
		if islandDragStart then
			if not isDraggingIsland then
				local t1 = TweenService:Create(islandScale, TweenInfo.new(0.1), { Scale = 0.88 })
				t1.Completed:Connect(function()
					TweenService:Create(islandScale, TweenInfo.new(0.18, Enum.EasingStyle.Back), { Scale = 1 }):Play()
				end)
				t1:Play()
				
				if main.Visible then
					closePanel()
				else
					openPanel()
				end
			end
			islandDragStart = nil
			isDraggingIsland = false
		end
	end
end)

main.Visible = false
openPanel()
