local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Lighting   = game:GetService("Lighting")

local LP = Players.LocalPlayer

local function getContainer()
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LP:WaitForChild("PlayerGui")
end

local screen = Instance.new("ScreenGui")
screen.Name = "MarqueeUI"
screen.ResetOnSpawn = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.DisplayOrder = 999
screen.IgnoreGuiInset = false

local parented = pcall(function() screen.Parent = getContainer() end)
if not parented then
    screen.Parent = LP:WaitForChild("PlayerGui")
end

local PANEL_W, PANEL_H = 300, 228

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
panel.Position = UDim2.new(1, -PANEL_W - 24, 1, -PANEL_H - 24)
panel.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
panel.BackgroundTransparency = 0.05
panel.BorderSizePixel = 0
panel.Active = true
panel.ClipsDescendants = false
panel.Parent = screen

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 8)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Thickness = 1
panelStroke.Color = Color3.fromRGB(45, 47, 56)
panelStroke.Parent = panel

local EDGE_THICK = 2
local edges = {}

local function makeEdge(size, position, rotation)
    local f = Instance.new("Frame")
    f.Size = size
    f.Position = position
    f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    f.BorderSizePixel = 0
    f.ZIndex = 2
    f.Parent = panel

    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 72, 96)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 196, 64)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(72, 200, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 72, 96)),
    })
    g.Rotation = rotation
    g.Offset = Vector2.new(0, 0)
    g.Parent = f

    table.insert(edges, g)
    return f
end

makeEdge(UDim2.new(1, 0, 0, EDGE_THICK), UDim2.new(0, 0, 0, 0), 0)
makeEdge(UDim2.new(1, 0, 0, EDGE_THICK), UDim2.new(0, 0, 1, -EDGE_THICK), 0)
makeEdge(UDim2.new(0, EDGE_THICK, 1, 0), UDim2.new(0, 0, 0, 0), 90)
makeEdge(UDim2.new(0, EDGE_THICK, 1, 0), UDim2.new(1, -EDGE_THICK, 0, 0), 90)

local dot = Instance.new("Frame")
dot.Name = "MarqueeDot"
dot.AnchorPoint = Vector2.new(0.5, 0.5)
dot.Size = UDim2.fromOffset(9, 9)
dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dot.BorderSizePixel = 0
dot.ZIndex = 4
dot.Parent = panel

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot

local dotGlow = Instance.new("UIStroke")
dotGlow.Thickness = 5
dotGlow.Color = Color3.fromRGB(130, 205, 255)
dotGlow.Transparency = 0.45
dotGlow.Parent = dot

local function edgePoint(t, w, h)
    local perimeter = 2 * (w + h)
    local p = (t % 1) * perimeter
    if p < w then
        return Vector2.new(p, 0)
    elseif p < w + h then
        return Vector2.new(w, p - w)
    elseif p < 2 * w + h then
        return Vector2.new(w - (p - w - h), h)
    else
        return Vector2.new(0, h - (p - 2 * w - h))
    end
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 20)
title.Position = UDim2.new(0, 12, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "MARQUEE · FPS · LATENCY"
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(230, 232, 240)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = panel

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -24, 0, 16)
fpsLabel.Position = UDim2.new(0, 12, 0, 32)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.Code
fpsLabel.Text = "FPS: --"
fpsLabel.TextSize = 12
fpsLabel.TextColor3 = Color3.fromRGB(130, 220, 160)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.ZIndex = 3
fpsLabel.Parent = panel

local function trySetFpsCap(n)
    if type(setfpscap) == "function" then
        local ok = pcall(setfpscap, n)
        if ok then return true, "setfpscap(" .. n .. ")" end
    end
    if type(sethiddenproperty) == "function" then
        local rs = game:GetService("RunService")
        for _, prop in ipairs({ "FPSLimit", "FrameRateCap", "MaxFPS" }) do
            local ok = pcall(sethiddenproperty, rs, prop, n)
            if ok then return true, "sethiddenproperty." .. prop .. "(" .. n .. ")" end
        end
    end
    return false, "当前环境不支持改帧率上限（需要执行器 setfpscap）"
end

local function optimizeLocal()
    local done = {}

    local ok1 = pcall(function() settings().Network.IncomingReplicationLag = 0 end)
    table.insert(done, "ReplicationLag: " .. (ok1 and "0" or "skip"))

    local ok2 = pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    table.insert(done, "QualityLevel: " .. (ok2 and "1" or "skip"))

    local ok3 = pcall(function() Lighting.GlobalShadows = false end)
    table.insert(done, "GlobalShadows: " .. (ok3 and "off" or "skip"))

    local post = 0
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then
            local ok = pcall(function() v.Enabled = false end)
            if ok then post += 1 end
        end
    end
    table.insert(done, "PostEffects off: " .. post)

    pcall(function() workspace.GlobalWind = Vector3.zero end)

    return table.concat(done, " | ")
end

local fpsBox = Instance.new("TextBox")
fpsBox.Size = UDim2.new(1, -108, 0, 28)
fpsBox.Position = UDim2.new(0, 12, 0, 56)
fpsBox.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
fpsBox.BorderSizePixel = 0
fpsBox.Font = Enum.Font.Code
fpsBox.Text = "240"
fpsBox.PlaceholderText = "输入帧率 30-999"
fpsBox.TextSize = 13
fpsBox.TextColor3 = Color3.fromRGB(230, 232, 240)
fpsBox.ClearTextOnFocus = false
fpsBox.ZIndex = 3
fpsBox.Parent = panel

local fpsBoxCorner = Instance.new("UICorner")
fpsBoxCorner.CornerRadius = UDim.new(0, 6)
fpsBoxCorner.Parent = fpsBox

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -24, 0, 34)
statusLabel.Position = UDim2.new(0, 12, 1, -46)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Code
statusLabel.Text = "就绪"
statusLabel.TextSize = 11
statusLabel.TextWrapped = true
statusLabel.TextColor3 = Color3.fromRGB(160, 165, 180)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Top
statusLabel.ZIndex = 3
statusLabel.Parent = panel

local function makeButton(text, pos, width, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(width, 28)
    b.Position = pos
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamMedium
    b.Text = text
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(235, 237, 243)
    b.AutoButtonColor = true
    b.ZIndex = 3
    b.Parent = panel

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b
    return b
end

local applyBtn   = makeButton("应用",   UDim2.new(1, -88, 0, 56), 76, Color3.fromRGB(52, 110, 210))
local defaultBtn = makeButton("默认 60", UDim2.new(0, 12, 0, 92),  88, Color3.fromRGB(44, 46, 56))
local maxBtn     = makeButton("无上限",  UDim2.new(0, 108, 0, 92), 88, Color3.fromRGB(44, 46, 56))
local optBtn     = makeButton("本地优化", UDim2.new(0, 204, 0, 92), 84, Color3.fromRGB(58, 92, 66))

applyBtn.MouseButton1Click:Connect(function()
    local n = tonumber(fpsBox.Text)
    if not n then
        statusLabel.Text = "帧率必须是数字"
        return
    end
    n = math.clamp(math.floor(n), 30, 999)
    local ok, msg = trySetFpsCap(n)
    statusLabel.Text = (ok and "已应用: " or "失败: ") .. msg
end)

defaultBtn.MouseButton1Click:Connect(function()
    local ok, msg = trySetFpsCap(60)
    statusLabel.Text = (ok and "已应用: " or "失败: ") .. msg
end)

maxBtn.MouseButton1Click:Connect(function()
    local ok, msg = trySetFpsCap(999)
    statusLabel.Text = (ok and "已应用: " or "失败: ") .. msg
end)

optBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = optimizeLocal()
end)

local dragging, dragStart, startPos = false, nil, nil

panel.InputBegan:Connect(function(input)
    if UIS:GetFocusedTextBox() then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local MARQUEE_CYCLES_PER_SEC = 0.35
local DOT_LAPS_PER_SEC       = 0.18

local gradientPhase = 0
local dotPhase      = 0
local fpsFrames     = 0
local fpsAccum      = 0

local connection = RunService.RenderStepped:Connect(function(dt)
    gradientPhase = (gradientPhase + MARQUEE_CYCLES_PER_SEC * dt) % 1
    local offset = Vector2.new(gradientPhase, 0)
    for _, g in ipairs(edges) do
        g.Offset = offset
    end

    dotPhase = (dotPhase + DOT_LAPS_PER_SEC * dt) % 1
    local w = panel.AbsoluteSize.X
    local h = panel.AbsoluteSize.Y
    local p = edgePoint(dotPhase, w, h)
    dot.Position = UDim2.fromOffset(p.X, p.Y)

    fpsFrames += 1
    fpsAccum += dt
    if fpsAccum >= 0.5 then
        local fps = fpsFrames / fpsAccum
        fpsLabel.Text = string.format("FPS: %.0f  |  frame: %.2f ms", fps, 1000 / fps)
        fpsFrames = 0
        fpsAccum = 0
    end
end)