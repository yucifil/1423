local function hexToColor3(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16) or 0
    local g = tonumber(hex:sub(3, 4), 16) or 0
    local b = tonumber(hex:sub(5, 6), 16) or 0
    return Color3.fromRGB(r, g, b)
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
if not WindUI then
    warn("WindUI 库加载失败，请检查网络或更换执行器。")
    return
end

WindUI:AddTheme({
    Name = "Amber",
    Accent = hexToColor3("#92400e"),
    Background = hexToColor3("#1c140f"),
    Outline = hexToColor3("#fcd34d"),
    Text = hexToColor3("#fffbeb"),
    Placeholder = hexToColor3("#a8a29e"),
    Button = hexToColor3("#78350f"),
    Icon = hexToColor3("#fbbf24")
})

WindUI:AddTheme({
    Name = "Plant",
    Accent = hexToColor3("#166534"),
    Background = hexToColor3("#0f1f17"),
    Outline = hexToColor3("#4ade80"),
    Text = hexToColor3("#f0fdf4"),
    Placeholder = hexToColor3("#86efac"),
    Button = hexToColor3("#14532d"),
    Icon = hexToColor3("#22c55e")
})

WindUI:AddTheme({
    Name = "Cotton Candy",
    Accent = hexToColor3("#7e22ce"),
    Background = hexToColor3("#1a1026"),
    Outline = hexToColor3("#e879f9"),
    Text = hexToColor3("#faf5ff"),
    Placeholder = hexToColor3("#c4b5fd"),
    Button = hexToColor3("#6b21a8"),
    Icon = hexToColor3("#d946ef")
})

WindUI:AddTheme({
    Name = "Monokai Pro",
    Accent = hexToColor3("#272822"),
    Background = hexToColor3("#1e1f1c"),
    Outline = hexToColor3("#f8f8f2"),
    Text = hexToColor3("#f7f7f7"),
    Placeholder = hexToColor3("#90908a"),
    Button = hexToColor3("#3e3d32"),
    Icon = hexToColor3("#a6e22e")
})

WindUI:AddTheme({
    Name = "Crimson",
    Accent = hexToColor3("#991b1b"),
    Background = hexToColor3("#200c0c"),
    Outline = hexToColor3("#f87171"),
    Text = hexToColor3("#fef2f2"),
    Placeholder = hexToColor3("#fca5a5"),
    Button = hexToColor3("#7f1d1d"),
    Icon = hexToColor3("#ef4444")
})

WindUI:AddTheme({
    Name = "Violet",
    Accent = hexToColor3("#4c1d95"),
    Background = hexToColor3("#17102b"),
    Outline = hexToColor3("#a78bfa"),
    Text = hexToColor3("#f5f3ff"),
    Placeholder = hexToColor3("#c4b5fd"),
    Button = hexToColor3("#5b21b6"),
    Icon = hexToColor3("#8b5cf6")
})

WindUI:AddTheme({
    Name = "Midnight",
    Accent = hexToColor3("#1e3a8a"),
    Background = hexToColor3("#0f172a"),
    Outline = hexToColor3("#93c5fd"),
    Text = hexToColor3("#eff6ff"),
    Placeholder = hexToColor3("#94a3b8"),
    Button = hexToColor3("#1e40af"),
    Icon = hexToColor3("#3b82f6")
})

WindUI:AddTheme({
    Name = "Rose",
    Accent = hexToColor3("#881337"),
    Background = hexToColor3("#230e16"),
    Outline = hexToColor3("#fda4af"),
    Text = hexToColor3("#fff1f2"),
    Placeholder = hexToColor3("#fda4af"),
    Button = hexToColor3("#9f1239"),
    Icon = hexToColor3("#f43f5e")
})

WindUI:AddTheme({
    Name = "Mellowsi",
    Accent = hexToColor3("#78350f"),
    Background = hexToColor3("#1c120a"),
    Outline = hexToColor3("#fcd34d"),
    Text = hexToColor3("#fffbeb"),
    Placeholder = hexToColor3("#a8a29e"),
    Button = hexToColor3("#713f12"),
    Icon = hexToColor3("#fbbf24")
})

WindUI:AddTheme({
    Name = "Sky",
    Accent = hexToColor3("#0e7490"),
    Background = hexToColor3("#0c1d24"),
    Outline = hexToColor3("#5eead4"),
    Text = hexToColor3("#ecfeff"),
    Placeholder = hexToColor3("#5eead4"),
    Button = hexToColor3("#155e75"),
    Icon = hexToColor3("#14b8a6")
})

WindUI:AddTheme({
    Name = "Indigo",
    Accent = hexToColor3("#312e81"),
    Background = hexToColor3("#12142d"),
    Outline = hexToColor3("#a5b4fc"),
    Text = hexToColor3("#eef2ff"),
    Placeholder = hexToColor3("#a5b4fc"),
    Button = hexToColor3("#3730a3"),
    Icon = hexToColor3("#6366f1")
})

WindUI:AddTheme({
    Name = "Red",
    Accent = hexToColor3("#b91c1c"),
    Background = hexToColor3("#1f0d0d"),
    Outline = hexToColor3("#fca5a5"),
    Text = hexToColor3("#fef2f2"),
    Placeholder = hexToColor3("#fca5a5"),
    Button = hexToColor3("#991b1b"),
    Icon = hexToColor3("#ef4444")
})

WindUI:AddTheme({
    Name = "Emerald",
    Accent = hexToColor3("#047857"),
    Background = hexToColor3("#0c1c16"),
    Outline = hexToColor3("#6ee7b7"),
    Text = hexToColor3("#f0fdfa"),
    Placeholder = hexToColor3("#6ee7b7"),
    Button = hexToColor3("#065f46"),
    Icon = hexToColor3("#10b981")
})

WindUI:AddTheme({
    Name = "Dark",
    Accent = hexToColor3("#18181b"),
    Background = hexToColor3("#101010"),
    Outline = hexToColor3("#FFFFFF"),
    Text = hexToColor3("#FFFFFF"),
    Placeholder = hexToColor3("#7a7a7a"),
    Button = hexToColor3("#52525b"),
    Icon = hexToColor3("#a1a1aa")
})

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local BG_LIST = {
    "rbxassetid://116211389465318",
    "rbxassetid://92883588549999",
    "rbxassetid://108917308701664",
    "rbxassetid://101390233693690",
}

local BG_NAMES = { "背景 1", "背景 2", "背景 3", "背景 4" }

local CurrentBG = BG_LIST[1]
local CurrentBGTransparency = 0.15
local UIDarkTransparency = 0.75
local EnhancedTransparency = false
local ENHANCED_VALUE = 0.92
local MainWindowFrame = nil
local DarkFrames = {}

task.spawn(function()
    pcall(function()
        ContentProvider:PreloadAsync(BG_LIST)
    end)
end)

local function normalizeImageId(id)
    if not id or type(id) ~= "string" or id == "" then
        return nil
    end
    id = tostring(id):gsub("%s", "")
    if id == "" then
        return nil
    end
    if string.find(id, "rbxassetid://") or string.find(id, "rbxthumb://") or string.find(id, "http") then
        return id
    end
    if string.match(id, "^%d+$") then
        return "rbxassetid://" .. id
    end
    return nil
end

function applyBackgroundImage(id)
    if not id or type(id) ~= "string" or id == "" then
        return
    end
    local normalized = normalizeImageId(id)
    if not normalized then
        WindUI:Notify({
            Title = "错误",
            Content = "无效的图片 ID",
            Icon = "x",
            Duration = 3
        })
        return
    end

    CurrentBG = normalized
    task.spawn(function()
        pcall(function()
            ContentProvider:PreloadAsync({ CurrentBG })
        end)
    end)

    if MainWindowFrame and MainWindowFrame.Parent then
        local holder = MainWindowFrame:FindFirstChild("BgImageHolder")
        if holder then
            local img = holder:FindFirstChild("WindowBackground")
            if img then
                img.Image = ""
                task.wait(0.05)
                img.Image = CurrentBG
                img.ImageTransparency = CurrentBGTransparency
            end
        end
    end

    WindUI:Notify({
        Title = "背景已更新",
        Content = CurrentBG,
        Icon = "check",
        Duration = 2
    })
end

local function collectDarkFrames()
    DarkFrames = {}
    if not MainWindowFrame then
        return
    end

    local function scan(obj)
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("Frame") then
                if child.Name ~= "BgImageHolder" and child.Name ~= "MarqueeOverlay" and child.Name ~= "WindowBackground" and child.Visible then
                    local c = child.BackgroundColor3
                    local area = child.AbsoluteSize.X * child.AbsoluteSize.Y
                    local isDark = c.R < 0.5 and c.G < 0.5 and c.B < 0.5
                    if isDark and area > 200 and child.BackgroundTransparency < 0.95 then
                        table.insert(DarkFrames, child)
                    end
                end
                scan(child)
            elseif child:IsA("CanvasGroup") then
                scan(child)
            end
        end
    end

    scan(MainWindowFrame)
end

function applyUIDarkTransparency()
    local target = EnhancedTransparency and ENHANCED_VALUE or UIDarkTransparency
    for _, f in ipairs(DarkFrames) do
        if f and f.Parent then
            f.BackgroundTransparency = target
        end
    end
end

local function findWindUIWindow()
    local containers = { game:GetService("CoreGui") }
    local ok, hui = pcall(function()
        return gethui()
    end)
    if ok and hui then
        table.insert(containers, 1, hui)
    end
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        table.insert(containers, pg)
    end

    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local screenArea = viewport.X * viewport.Y

    for _, c in ipairs(containers) do
        for _, sg in ipairs(c:GetChildren()) do
            if sg:IsA("ScreenGui") and (string.find(string.lower(sg.Name), "windui") or string.find(string.lower(sg.Name), "wind")) then
                local bestFrame = nil
                local bestArea = 0
                for _, d in ipairs(sg:GetDescendants()) do
                    if d:IsA("Frame") and d.Visible and d:FindFirstChildOfClass("UICorner") then
                        local area = d.AbsoluteSize.X * d.AbsoluteSize.Y
                        if area > 10000 and area < screenArea * 0.9 then
                            if area > bestArea then
                                bestArea = area
                                bestFrame = d
                            end
                        end
                    end
                end
                if bestFrame then
                    return bestFrame
                end
            end
        end
    end
    return nil
end

local function ensureMarquee(main, radius)
    local old = main:FindFirstChild("MarqueeOverlay")
    if old then
        old:Destroy()
    end

    for _, child in ipairs(main:GetChildren()) do
        if child:IsA("UIStroke") and child.Name ~= "MarqueeStroke" then
            child.Transparency = 1
        end
    end

    local overlay = Instance.new("Frame")
    overlay.Name = "MarqueeOverlay"
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.ZIndex = 99999
    overlay.ClipsDescendants = false
    overlay.Parent = main

    local oc = Instance.new("UICorner")
    oc.CornerRadius = UDim.new(0, radius)
    oc.Parent = overlay

    local stroke = Instance.new("UIStroke")
    stroke.Name = "MarqueeStroke"
    stroke.Thickness = 3
    stroke.Transparency = 0.05
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = overlay

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 210, 255)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(130, 80, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 60, 160)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 210, 255)),
    })
    grad.Parent = stroke

    task.spawn(function()
        local t = 0
        while overlay.Parent do
            t += task.wait(0.03)
            grad.Rotation = (t * 180) % 360
        end
    end)

    task.spawn(function()
        while overlay.Parent do
            TweenService:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.4 }):Play()
            task.wait(1.2)
            if not overlay.Parent then break end
            TweenService:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.05 }):Play()
            task.wait(1.2)
        end
    end)
end

local function applyWindUITheme()
    local main = findWindUIWindow()
    if not main then
        return
    end

    MainWindowFrame = main
    main.ClipsDescendants = false

    collectDarkFrames()
    applyUIDarkTransparency()

    local radius = 12
    local mc = main:FindFirstChildOfClass("UICorner")
    if mc and typeof(mc.CornerRadius) == "UDim" then
        radius = mc.CornerRadius.Offset
    end

    if not main:FindFirstChild("BgImageHolder") then
        local holder = Instance.new("Frame")
        holder.Name = "BgImageHolder"
        holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        holder.BackgroundTransparency = 0.85
        holder.Size = UDim2.new(1, 0, 1, 0)
        holder.ClipsDescendants = true
        holder.ZIndex = -10
        holder.Parent = main

        local hc = Instance.new("UICorner")
        hc.CornerRadius = UDim.new(0, radius)
        hc.Parent = holder

        local img = Instance.new("ImageLabel")
        img.Name = "WindowBackground"
        img.BackgroundTransparency = 1
        img.Size = UDim2.new(1, 0, 1, 0)
        img.Image = CurrentBG
        img.ScaleType = Enum.ScaleType.Crop
        img.ImageTransparency = CurrentBGTransparency
        img.ZIndex = 0
        img.Parent = holder
    end

    ensureMarquee(main, radius)
end

task.spawn(function()
    for _ = 1, 50 do
        task.wait(0.1)
        if findWindUIWindow() then
            break
        end
    end

    task.wait(0.5)
    applyWindUITheme()

    local tick = 0
    while true do
        task.wait(0.5)
        tick = tick + 1

        if MainWindowFrame and MainWindowFrame.Parent then
            local holder = MainWindowFrame:FindFirstChild("BgImageHolder")
            if holder then
                holder.ZIndex = -10
                local img = holder:FindFirstChild("WindowBackground")
                if img then
                    img.ZIndex = 0
                    img.ImageTransparency = CurrentBGTransparency
                end
            end

            if not MainWindowFrame:FindFirstChild("MarqueeOverlay") then
                local radius = 12
                local mc = MainWindowFrame:FindFirstChildOfClass("UICorner")
                if mc and typeof(mc.CornerRadius) == "UDim" then
                    radius = mc.CornerRadius.Offset
                end
                ensureMarquee(MainWindowFrame, radius)
            end

            if tick % 4 == 0 then
                collectDarkFrames()
            end

            applyUIDarkTransparency()
        else
            MainWindowFrame = nil
            DarkFrames = {}
            applyWindUITheme()
        end
    end
end)

local NotifyEnabled = true
local MaxNotices = 5
local NoticeDuration = 3.0
local activeNotices = {}

local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "iOSNotifyGui"
NotifyGui.ResetOnSpawn = false
NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifyGui.Parent = player:WaitForChild("PlayerGui")

local RightContainer = Instance.new("Frame")
RightContainer.Name = "RightContainer"
RightContainer.Size = UDim2.new(0, 300, 1, -60)
RightContainer.Position = UDim2.new(1, -310, 0, 30)
RightContainer.BackgroundTransparency = 1
RightContainer.ClipsDescendants = true
RightContainer.Parent = NotifyGui

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 12)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIList.VerticalAlignment = Enum.VerticalAlignment.Top
UIList.Parent = RightContainer

local function addCardMarquee(card)
    local stroke = Instance.new("UIStroke")
    stroke.Name = "CardMarquee"
    stroke.Thickness = 2
    stroke.Transparency = 0.1
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = card

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 210, 255)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(130, 80, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 60, 160)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 210, 255)),
    })
    grad.Parent = stroke

    task.spawn(function()
        local t = 0
        while card.Parent do
            t += task.wait(0.03)
            grad.Rotation = (t * 180) % 360
        end
    end)

    task.spawn(function()
        while card.Parent do
            TweenService:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.45 }):Play()
            task.wait(1.2)
            if not card.Parent then break end
            TweenService:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.05 }):Play()
            task.wait(1.2)
        end
    end)
end

local function createNotice(plrName, isJoin)
    if not NotifyEnabled then
        return
    end

    if #activeNotices >= MaxNotices then
        local oldest = table.remove(activeNotices, 1)
        if oldest and oldest.Parent then
            oldest:Destroy()
        end
    end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 280, 0, 56)
    card.BackgroundColor3 = isJoin and Color3.fromRGB(48, 209, 88) or Color3.fromRGB(255, 59, 48)
    card.BackgroundTransparency = 0.75
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.LayoutOrder = tick()
    card.Parent = RightContainer

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 16)
    cardCorner.Parent = card

    addCardMarquee(card)

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 0.5, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    overlay.BackgroundTransparency = 0.88
    overlay.BorderSizePixel = 0
    overlay.Parent = card

    local oc = Instance.new("UICorner")
    oc.CornerRadius = UDim.new(0, 16)
    oc.Parent = overlay

    local textX = 28

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 280 - textX - 16, 0, 22)
    title.Position = UDim2.new(0, textX, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = isJoin and "玩家加入" or "玩家离开"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 15
    title.Font = Enum.Font.GothamSemibold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTransparency = 1
    title.Parent = card

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 280 - textX - 16, 0, 18)
    nameLabel.Position = UDim2.new(0, textX, 0, 30)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plrName
    nameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTransparency = 1
    nameLabel.Parent = card

    card.Position = UDim2.new(0, 300, 0, 0)
    table.insert(activeNotices, card)

    TweenService:Create(card, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, 0) }):Play()
    TweenService:Create(title, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
    TweenService:Create(nameLabel, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()

    task.delay(NoticeDuration, function()
        TweenService:Create(card, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), { Position = UDim2.new(0, -300, 0, 0) }):Play()
        TweenService:Create(title, TweenInfo.new(0.6), { TextTransparency = 1 }):Play()
        TweenService:Create(nameLabel, TweenInfo.new(0.6), { TextTransparency = 1 }):Play()

        task.delay(0.8, function()
            if card and card.Parent then
                card:Destroy()
            end
            for i, v in ipairs(activeNotices) do
                if v == card then
                    table.remove(activeNotices, i)
                    break
                end
            end
        end)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        createNotice(plr.Name, true)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr ~= player then
        createNotice(plr.Name, false)
    end
end)

task.defer(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            createNotice(plr.Name, true)
        end
    end
end)

-- ============================================================
-- 音乐模块（并入本脚本 · 作者：大肥鱼）
-- ============================================================
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
        WindUI:Notify({ Title = "播放失败", Content = name .. " 无法播放", Icon = "x", Duration = 3 })
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

    WindUI:Notify({ Title = "正在播放", Content = name, Icon = "music", Duration = 2 })
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

local function buildMusicTab(Window)
    local MusicTab = Window:Tab({ Title = "音乐", Icon = "music", Locked = false })

    MusicTab:Paragraph({
        Title = "音乐播放器",
        Desc = "作者：大肥鱼\n点曲名直接播放，切歌会自动停掉上一首。",
        Image = "music",
        ImageSize = 20
    })

    MusicTab:Section({ Title = "播放控制" })
    MusicTab:Slider({
        Title = "音量",
        Desc = "0 = 静音，1 = 原始音量，拖动即时生效",
        Value = { Min = 0, Max = 1, Default = 1 },
        Callback = function(value)
            MusicVolume = value
            if currentSound then
                currentSound.Volume = value
            end
        end
    })
    MusicTab:Toggle({
        Title = "单曲循环",
        Value = false,
        Callback = function(value)
            MusicLoop = value
            if currentSound then
                currentSound.Looped = value
            end
        end
    })
    MusicTab:Button({
        Title = "停止播放",
        Desc = currentSongName or "当前没有正在播放的音乐",
        Icon = "square",
        Callback = function()
            if StopMusic() then
                WindUI:Notify({ Title = "已停止", Content = "音乐已停止播放", Icon = "check", Duration = 2 })
            else
                WindUI:Notify({ Title = "已停止", Content = "当前没有正在播放的音乐", Icon = "info", Duration = 2 })
            end
        end
    })

    MusicTab:Section({ Title = "曲库（" .. #SONGS .. " 首）" })
    for _, song in ipairs(SONGS) do
        local songName = song[1]
        local songId = song[2]
        MusicTab:Button({
            Title = "▶ " .. songName,
            Desc = "rbxassetid://" .. songId,
            Icon = "play",
            Callback = function()
                PlayMusic(songId, songName)
            end
        })
    end

    MusicTab:Space()
    MusicTab:Section({ Title = "自定义" })
    local CustomId = ""
    MusicTab:Input({
        Title = "自定义音乐 ID",
        Desc = "填 rbxassetid 数字或完整链接，回车保存后点下方按钮播放",
        Icon = "music",
        Callback = function(text)
            CustomId = text or ""
        end
    })
    MusicTab:Button({
        Title = "播放自定义音乐",
        Desc = "使用上方输入的 ID 播放",
        Icon = "play-circle",
        Callback = function()
            if CustomId:gsub("%s", "") == "" then
                WindUI:Notify({ Title = "播放失败", Content = "请先填写音乐 ID", Icon = "alert-triangle", Duration = 3 })
                return
            end
            PlayMusic(CustomId, "自定义音乐")
        end
    })
end

local function loadExternalScript(name, url)
    WindUI:Notify({
        Title = "加载中",
        Content = "正在加载 " .. name .. "...",
        Icon = "loader",
        Duration = 2
    })

    task.spawn(function()
        local ok, srcOrErr = pcall(function()
            return game:HttpGet(url, true)
        end)

        if not ok then
            WindUI:Notify({
                Title = "下载失败",
                Content = name .. " 错误: " .. tostring(srcOrErr),
                Icon = "x",
                Duration = 5
            })
            return
        end

        local success, err = pcall(function()
            loadstring(srcOrErr)()
        end)

        if success then
            WindUI:Notify({
                Title = "加载成功",
                Content = name .. " 已加载",
                Icon = "check",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "执行失败",
                Content = name .. " 错误: " .. tostring(err),
                Icon = "x",
                Duration = 5
            })
        end
    end)
end

WindUI:Popup({
    Title = "冰缝合脚本",
    Icon = "info",
    Content = "点击执行进入脚本主界面\n作者：榆 | 参与者：心意冰存(嵩)",
    Buttons = {
        {
            Title = "退出",
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function()
                local Window = WindUI:CreateWindow({
                    Title = "冰缝合脚本",
                    Icon = "door-open",
                    Author = "榆",
                    HideSearchBar = false,
                })

                Window:ToggleTransparency(true)
                EnhancedTransparency = true

                local NoticeTab = Window:Tab({ Title = "公告", Icon = "megaphone", Locked = false })
                NoticeTab:Paragraph({ Title = "欢迎使用", Desc = "本脚本由 榆 开发，仅供学习交流使用。" })
                NoticeTab:Paragraph({
                    Title = "玩家信息",
                    Desc = "用户名: " .. player.Name .. "\n显示名称: " .. player.DisplayName .. "\n账号年龄: " .. player.AccountAge .. " 天\n用户ID: " .. player.UserId,
                    Image = "user",
                    ImageSize = 20
                })

                local MainTab = Window:Tab({ Title = "主要", Icon = "house", Locked = false })
                MainTab:Paragraph({ Title = "作者信息", Desc = "作者：榆\n参与者：心意冰存(嵩)\n音乐模块：大肥鱼" })
                MainTab:Dropdown({
                    Title = "切换背景图片",
                    Values = BG_NAMES,
                    Value = BG_NAMES[1],
                    Callback = function(selected)
                        for i, name in ipairs(BG_NAMES) do
                            if name == selected then
                                applyBackgroundImage(BG_LIST[i])
                                break
                            end
                        end
                    end
                })
                MainTab:Slider({
                    Title = "UI 黑色透明度",
                    Desc = "0 = 纯黑 1 = 完全透明（开启透明窗口时会被拉满）",
                    Value = { Min = 0, Max = 1, Default = UIDarkTransparency },
                    Callback = function(value)
                        UIDarkTransparency = value
                        if #DarkFrames == 0 then
                            collectDarkFrames()
                        end
                        applyUIDarkTransparency()
                    end
                })
                MainTab:Input({
                    Title = "自定义背景图片 ID",
                    Desc = "输入图片 ID 后按回车应用",
                    Icon = "image",
                    Callback = function(text)
                        if text and text ~= "" then
                            applyBackgroundImage(text)
                        end
                    end
                })
                MainTab:Button({
                    Title = "应用 / 刷新背景",
                    Desc = "重新加载当前背景图片",
                    Icon = "refresh-cw",
                    Callback = function()
                        applyBackgroundImage(CurrentBG)
                    end
                })

                local NotifyTab = Window:Tab({ Title = "进出提示", Icon = "bell", Locked = false })
                NotifyTab:Toggle({
                    Title = "启用玩家进出提示",
                    Value = true,
                    Callback = function(value)
                        NotifyEnabled = value
                        NotifyGui.Enabled = value
                    end
                })
                NotifyTab:Slider({
                    Title = "提示停留时间（秒）",
                    Value = { Min = 1, Max = 8, Default = 3 },
                    Callback = function(value)
                        NoticeDuration = value
                    end
                })
                NotifyTab:Slider({
                    Title = "最大同时显示条数",
                    Value = { Min = 1, Max = 10, Default = 5 },
                    Callback = function(value)
                        MaxNotices = math.floor(value)
                    end
                })
                NotifyTab:Section({ Title = "测试" })
                NotifyTab:Button({
                    Title = "测试 - 玩家加入",
                    Callback = function()
                        createNotice("TestPlayer_Join", true)
                    end
                })
                NotifyTab:Button({
                    Title = "测试 - 玩家离开",
                    Callback = function()
                        createNotice("TestPlayer_Leave", false)
                    end
                })

                local ScriptTab = Window:Tab({ Title = "脚本库", Icon = "code", Locked = false })
                ScriptTab:Section({ Title = "Aero 脚本库" })
                ScriptTab:Button({
                    Title = "▶ 加载 超高速跑者",
                    Callback = function()
                        loadExternalScript("超高速跑者", "https://raw.githubusercontent.com/wwd6ng2j66-art/-/main/%E8%B6%85%E9%AB%98%E9%80%9F%E8%B7%91%E8%80%85.lua")
                    end
                })
                ScriptTab:Button({
                    Title = "▶ 加载 99夜脚本",
                    Callback = function()
                        loadExternalScript("99夜", "https://raw.githubusercontent.com/wwd6ng2j66-art/-/38aa514a561dd344e3b75c60e21197e484fc31aa/99%20%E5%A4%9C.lua")
                    end
                })
                ScriptTab:Section({ Title = "其他脚本库" })
                ScriptTab:Button({
                    Title = "▶ 加载 偷一个蛋 (TX Script)",
                    Callback = function()
                        loadExternalScript("偷一个蛋", "https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/Steal-Eggs")
                    end
                })

                ScriptTab:Section({ Title = "远程仓库" })
                ScriptTab:Button({
                    Title = "▶ 加载 竞争对手服务器",
                    Desc = "BigFatFish67 / sinister-spooky-orb · 老外竞争对手源码",
                    Icon = "download",
                    Callback = function()
                        loadExternalScript("竞争对手服务器", "https://raw.githubusercontent.com/BigFatFish67/sinister-spooky-orb/refs/heads/main/%E8%80%81%E5%A4%96%E7%AB%9E%E4%BA%89%E5%AF%B9%E6%89%8B%E6%BA%90%E7%A0%81.lua")
                    end
                })
                ScriptTab:Button({
                    Title = "▶ 加载 间谍抓包服务器",
                    Desc = "spy抓包.txt",
                    Icon = "download",
                    Callback = function()
                        loadExternalScript("间谍抓包服务器", "https://raw.githubusercontent.com/BigFatFish67/sinister-spooky-orb/refs/heads/main/spy%E6%8A%93%E5%8C%85.txt")
                    end
                })
                ScriptTab:Button({
                    Title = "▶ 加载 秒交互服务器",
                    Desc = "秒交互",
                    Icon = "download",
                    Callback = function()
                        loadExternalScript("秒交互服务器", "https://raw.githubusercontent.com/BigFatFish67/sinister-spooky-orb/refs/heads/main/%E7%A7%92%E4%BA%A4%E4%BA%92")
                    end
                })
                ScriptTab:Button({
                    Title = "▶ 加载 恐脚本中心服务器",
                    Desc = "恐脚本全源最新9月27(3).lua",
                    Icon = "download",
                    Callback = function()
                        loadExternalScript("恐脚本中心服务器", "https://raw.githubusercontent.com/BigFatFish67/sinister-spooky-orb/refs/heads/main/%E6%81%90%E8%84%9A%E6%9C%AC%E5%85%A8%E6%BA%90%E6%9C%80%E6%96%B09%E6%9C%8827(3).lua")
                    end
                })
                ScriptTab:Button({
                    Title = "▶ 加载 Dat++服务器",
                    Desc = "Dex++.lua",
                    Icon = "download",
                    Callback = function()
                        loadExternalScript("Dat++服务器", "https://raw.githubusercontent.com/BigFatFish67/sinister-spooky-orb/refs/heads/main/Dex%2B%2B.lua")
                    end
                })

                buildMusicTab(Window)

                local SettingsTab = Window:Tab({ Title = "设置", Icon = "settings", Locked = false })
                SettingsTab:Toggle({
                    Title = "切换透明窗口",
                    Desc = "开启后 UI 会变得非常透明，可清晰看到背景图",
                    Callback = function(e)
                        Window:ToggleTransparency(e)
                        EnhancedTransparency = e
                        applyUIDarkTransparency()
                    end,
                    Value = WindUI:GetTransparency()
                })
                SettingsTab:Dropdown({
                    Title = "切换主题",
                    Values = { "Dark", "Amber", "Plant", "Cotton Candy", "Monokai Pro", "Crimson", "Violet", "Midnight", "Rose", "Mellowsi", "Sky", "Indigo", "Red", "Emerald", "透明" },
                    Value = "Dark",
                    Callback = function(selected)
                        if selected == "透明" then
                            -- 开启透明窗口模式
                            EnhancedTransparency = true
                            pcall(function()
                                Window:ToggleTransparency(true)
                            end)
                            if #DarkFrames == 0 then
                                collectDarkFrames()
                            end
                            applyUIDarkTransparency()
                            WindUI:Notify({
                                Title = "透明模式",
                                Content = "已开启透明窗口，可清晰看到背景图",
                                Icon = "eye",
                                Duration = 2
                            })
                        else
                            WindUI:SetTheme(selected)
                            WindUI:UpdateTheme()
                        end
                    end
                })
                SettingsTab:Space()
                SettingsTab:Button({
                    Title = "重新加入当前服务器",
                    Desc = "自动读取当前服务器 ID 并重新加入",
                    Icon = "refresh-cw",
                    Callback = function()
                        local jobId = game.JobId
                        if jobId and jobId ~= "" then
                            local success, err = pcall(function()
                                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId, player)
                            end)
                            if success then
                                WindUI:Notify({
                                    Title = "正在重连",
                                    Content = "正在返回当前服务器...",
                                    Icon = "check",
                                    Duration = 3
                                })
                            else
                                WindUI:Notify({
                                    Title = "重连失败",
                                    Content = "无法返回当前服务器。",
                                    Icon = "x",
                                    Duration = 5
                                })
                            end
                        else
                            WindUI:Notify({
                                Title = "重连失败",
                                Content = "无法获取当前服务器 ID",
                                Icon = "x",
                                Duration = 3
                            })
                        end
                    end
                })
                SettingsTab:Space()
                SettingsTab:Button({
                    Title = "服务器跳跃",
                    Desc = "寻找一个新的随机服务器",
                    Icon = "globe",
                    Callback = function()
                        local TS = game:GetService("TeleportService")
                        local HS = game:GetService("HttpService")
                        local success, res = pcall(function()
                            return HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                        end)
                        if success and res and res.data and #res.data > 0 then
                            local chosen = res.data[math.random(1, #res.data)]
                            TS:TeleportToPlaceInstance(game.PlaceId, chosen.id, player)
                        else
                            WindUI:Notify({
                                Title = "跳跃失败",
                                Content = "没有找到可用的服务器",
                                Icon = "x"
                            })
                        end
                    end
                })
                SettingsTab:Space()
                SettingsTab:Button({
                    Title = "加入人少的服务器",
                    Desc = "自动寻找并加入当前在线人数最少的服务器",
                    Icon = "users",
                    Callback = function()
                        local TS = game:GetService("TeleportService")
                        local HS = game:GetService("HttpService")
                        local success, res = pcall(function()
                            return HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                        end)
                        if success and res and res.data and #res.data > 0 then
                            table.sort(res.data, function(a, b)
                                return a.playing < b.playing
                            end)
                            local chosenServer = res.data[1]
                            TS:TeleportToPlaceInstance(game.PlaceId, chosenServer.id, player)
                            WindUI:Notify({
                                Title = "正在跳跃",
                                Content = "当前人数：" .. chosenServer.playing,
                                Icon = "check",
                                Duration = 3
                            })
                        else
                            WindUI:Notify({
                                Title = "跳跃失败",
                                Content = "没有找到可用的服务器",
                                Icon = "x"
                            })
                        end
                    end
                })
                SettingsTab:Space()
                SettingsTab:Button({
                    Title = "复制当前服务器 ID",
                    Desc = "将当前服务器的 ID 复制到剪贴板",
                    Icon = "copy",
                    Callback = function()
                        if game.JobId and game.JobId ~= "" then
                            setclipboard(game.JobId)
                            WindUI:Notify({
                                Title = "复制成功",
                                Content = "服务器 ID 已复制",
                                Icon = "check",
                                Duration = 3
                            })
                        else
                            WindUI:Notify({
                                Title = "复制失败",
                                Content = "无法获取当前服务器 ID",
                                Icon = "x",
                                Duration = 3
                            })
                        end
                    end
                })
                SettingsTab:Space()

                local TargetJobId = ""
                SettingsTab:Input({
                    Title = "输入服务器 ID",
                    Desc = "粘贴你想加入的服务器 JobId",
                    Icon = "hash",
                    Callback = function(value)
                        TargetJobId = value
                    end
                })
                SettingsTab:Space()
                SettingsTab:Button({
                    Title = "加入特定服务器",
                    Desc = "使用上方输入框中的 ID 加入对应服务器",
                    Icon = "log-in",
                    Callback = function()
                        if not TargetJobId or TargetJobId == "" then
                            WindUI:Notify({
                                Title = "加入失败",
                                Content = "请先粘贴服务器 ID",
                                Icon = "alert-triangle",
                                Duration = 3
                            })
                            return
                        end
                        local TS = game:GetService("TeleportService")
                        local success, err = pcall(function()
                            TS:TeleportToPlaceInstance(game.PlaceId, TargetJobId, player)
                        end)
                        if success then
                            WindUI:Notify({
                                Title = "正在传送",
                                Content = "正在加入: " .. TargetJobId,
                                Icon = "check",
                                Duration = 3
                            })
                        else
                            WindUI:Notify({
                                Title = "加入失败",
                                Content = tostring(err),
                                Icon = "x",
                                Duration = 5
                            })
                        end
                    end
                })

                task.delay(0.5, function()
                    applyWindUITheme()
                end)
            end,
            Variant = "Primary",
        }
    }
})
