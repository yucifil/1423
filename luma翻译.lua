local Config = {
    Title = "LUMA",
    Subtitle = "LIQUID WORKSPACE",
    Author = "榆 大肥鱼",
    AuthorQQ = "3347313900",
    ToggleKey = Enum.KeyCode.RightShift,
    Volume = 0.4,
    DefaultScale = 1.4,
    WindowScale = 0.88,
    MusicApi = "https://music.163.com",
    CacheFolder = "LumaMusicCache",
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Input = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
assert(player, "LUMA 需要在 Roblox 客户端运行")
local playerGui = player:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("LumaGlass")
if old then
    local stop = old:FindFirstChild("Shutdown")
    if stop then stop:Fire() end
    old:Destroy()
end

local UIS = Input
local PlayerGui = playerGui
local Player = player

local CONFIG = {
    TargetLang    = "zh-CN",
    RequestDelay  = 0.20,
    MaxLength     = 1500,
    IncludeCore   = true,
    PanelName     = "ZHFanyiPanelV2",
    ExcludeNames  = { "iosnotifygui", "lumaglass" },
    RetryTimes    = 2,
    MaxConcurrent = 3,
    MaxPending    = 400,
    MaxNodes      = 3000,
    BatchSize     = 6,
    BatchCharLimit= 400,
    MaxCache      = 2500,
    ProtectSensitive = true,
}

local State = {
    Cache        = {},
    Original     = setmetatable({}, { __mode = "k" }),
    pending      = {},
    Auto         = true,
    RestorGuard  = false,
    Paused       = false,
    Hooked       = false,
    success      = 0,
    failures     = 0,
    scanned      = 0,
    OnlyGuiName  = "",
    Running      = true,
    skipped      = 0,
    batched      = 0,
    rehook       = 0,
}

local DICT = {
    ["settings"]="设置", ["setting"]="设置", ["config"]="配置", ["configuration"]="配置",
    ["execute"]="执行", ["start"]="开始", ["stop"]="停止", ["close"]="关闭", ["clear"]="清空",
    ["refresh"]="刷新", ["reload"]="重载", ["save"]="保存", ["load"]="加载", ["help"]="帮助",
    ["about"]="关于", ["home"]="主页", ["main"]="主页", ["script"]="脚本", ["scripts"]="脚本",
    ["player"]="玩家", ["players"]="玩家", ["world"]="世界", ["worlds"]="世界",
    ["teleport"]="传送", ["fly"]="飞行", ["speed"]="速度", ["jump"]="跳跃",
    ["esp"]="透视", ["aimbot"]="自瞄", ["aim"]="瞄准", ["auto"]="自动",
    ["farm"]="刷取", ["collect"]="收集", ["open"]="打开", ["delete"]="删除", ["remove"]="移除",
    ["add"]="添加", ["list"]="列表", ["name"]="名称", ["value"]="数值", ["type"]="类型",
    ["search"]="搜索", ["filter"]="筛选", ["copy"]="复制", ["paste"]="粘贴", ["reset"]="重置",
    ["restart"]="重启", ["enable"]="启用", ["disable"]="禁用", ["enabled"]="已启用", ["disabled"]="已禁用",
    ["toggle"]="切换", ["select"]="选择", ["selected"]="已选择",
    ["target"]="目标", ["targets"]="目标", ["mode"]="模式", ["modes"]="模式", ["option"]="选项", ["options"]="选项",
    ["general"]="常规", ["misc"]="杂项", ["visual"]="视觉", ["visuals"]="视觉", ["combat"]="战斗",
    ["movement"]="移动", ["utility"]="工具", ["utilities"]="工具", ["credits"]="信用点",
    ["boss"]="Boss", ["chest"]="宝箱", ["coin"]="金币", ["coins"]="金币", ["money"]="金钱",
    ["gem"]="宝石", ["gems"]="宝石", ["pet"]="宠物", ["pets"]="宠物", ["egg"]="蛋", ["eggs"]="蛋",
    ["hatch"]="孵化", ["equip"]="装备", ["unequip"]="卸下", ["inventory"]="背包", ["backpack"]="背包",
    ["shop"]="商店", ["store"]="商店", ["buy"]="购买", ["purchase"]="购买", ["sell"]="出售",
    ["trade"]="交易", ["upgrade"]="升级", ["level"]="等级", ["xp"]="经验", ["exp"]="经验",
    ["rank"]="段位", ["rebirth"]="重生", ["prestige"]="转生", ["quest"]="任务", ["quests"]="任务",
    ["mission"]="任务", ["missions"]="任务", ["reward"]="奖励", ["rewards"]="奖励",
    ["daily"]="每日", ["weekly"]="每周", ["claim"]="领取", ["spin"]="抽奖", ["roll"]="抽取",
    ["lucky"]="幸运", ["luck"]="幸运", ["aura"]="光环", ["auras"]="光环",
    ["trail"]="轨迹", ["trails"]="轨迹", ["skin"]="皮肤", ["skins"]="皮肤",
    ["emote"]="动作", ["emotes"]="动作", ["music"]="音乐", ["sound"]="音效",
    ["graphics"]="画质", ["quality"]="画质", ["resolution"]="分辨率", ["fullscreen"]="全屏",
    ["borderless"]="无边框", ["window"]="窗口", ["fps"]="帧率", ["ping"]="延迟",
    ["apply"]="应用", ["cancel"]="取消", ["confirm"]="确认", ["accept"]="接受", ["deny"]="拒绝",
    ["exit"]="退出", ["quit"]="退出", ["leave"]="离开", ["join"]="加入", ["chat"]="聊天",
    ["message"]="消息", ["notification"]="通知", ["warning"]="警告", ["error"]="错误", ["success"]="成功",
    ["info"]="信息", ["tips"]="提示", ["hint"]="提示", ["details"]="详情", ["information"]="信息",
    ["loading"]="加载中", ["wait"]="等待", ["done"]="完成", ["finished"]="完成", ["complete"]="完成",
    ["failed"]="失败", ["retry"]="重试", ["ok"]="确定", ["yes"]="是", ["no"]="否",
    ["continue"]="继续", ["back"]="返回", ["next"]="下一页", ["previous"]="上一页",
    ["page"]="页", ["current"]="当前", ["max"]="最大", ["min"]="最小", ["all"]="全部",
    ["none"]="无", ["custom"]="自定义", ["default"]="默认", ["random"]="随机", ["fast"]="快",
    ["normal"]="普通", ["slow"]="慢", ["instant"]="立即", ["delay"]="延迟", ["duration"]="时长",
    ["range"]="范围", ["radius"]="半径", ["distance"]="距离", ["position"]="位置", ["location"]="位置",
    ["spawn"]="生成", ["respawn"]="重生", ["god"]="无敌", ["godmode"]="无敌模式",
    ["infinite"]="无限", ["noclip"]="穿墙", ["flyspeed"]="飞行速度", ["walkspeed"]="行走速度",
    ["jumppower"]="跳跃力", ["gravity"]="重力", ["fov"]="视野", ["camera"]="视角", ["lock"]="锁定", ["unlock"]="解锁",
    ["follow"]="跟随", ["track"]="追踪", ["trace"]="追踪", ["box"]="方框", ["lines"]="线条",
    ["chams"]="上色", ["glow"]="发光", ["highlight"]="高亮", ["skeleton"]="骨骼", ["nameesp"]="名字透视",
    ["weapon"]="武器", ["weapons"]="武器", ["ammo"]="弹药", ["shoot"]="射击", ["fire"]="开火",
    ["hitbox"]="判定框", ["silent"]="静默", ["rage"]="暴力", ["trigger"]="扳机", ["triggerbot"]="自动扳机",
    ["wall"]="透视", ["wallhack"]="穿墙透视", ["radar"]="雷达", ["minimap"]="小地图", ["map"]="地图",
    ["time"]="时间", ["freeze"]="冻结", ["invisible"]="隐身", ["ghost"]="幽灵", ["vanish"]="隐身",
    ["explode"]="爆炸", ["explosion"]="爆炸", ["kill"]="击杀", ["killall"]="击杀全部", ["damage"]="伤害",
    ["heal"]="治疗", ["health"]="生命", ["hunger"]="饥饿", ["stamina"]="体力", ["oxygen"]="氧气",
    ["armor"]="护甲", ["shield"]="护盾", ["cash"]="现金", ["bank"]="银行", ["steal"]="偷取",
    ["pickup"]="拾取", ["gather"]="采集", ["mine"]="挖矿", ["chop"]="砍伐", ["fish"]="钓鱼",
    ["hunt"]="狩猎", ["craft"]="制作", ["cook"]="烹饪", ["build"]="建造", ["destroy"]="破坏",
    ["vehicle"]="载具", ["car"]="汽车", ["boat"]="船", ["drive"]="驾驶", ["ride"]="骑乘",
    ["gun"]="枪", ["pistol"]="手枪", ["rifle"]="步枪", ["shotgun"]="霰弹枪", ["sniper"]="狙击枪",
    ["knife"]="小刀", ["sword"]="剑", ["axe"]="斧头", ["pickaxe"]="镐子",
    ["key"]="钥匙", ["loot"]="战利品", ["item"]="物品", ["items"]="物品",
    ["object"]="物体", ["objects"]="物体", ["entity"]="实体", ["entities"]="实体",
    ["npc"]="NPC", ["enemy"]="敌人", ["enemies"]="敌人", ["mob"]="怪物", ["mobs"]="怪物",
    ["friend"]="好友", ["friends"]="好友", ["team"]="队伍", ["teams"]="队伍", ["party"]="队伍",
    ["group"]="群组", ["groups"]="群组", ["clan"]="公会", ["guild"]="公会",
    ["server"]="服务器", ["servers"]="服务器", ["lobby"]="大厅", ["game"]="游戏",
    ["zone"]="区域", ["zones"]="区域", ["area"]="区域", ["areas"]="区域", ["region"]="区域",
    ["island"]="岛屿", ["dungeon"]="副本", ["dungeons"]="副本", ["raid"]="副本", ["raids"]="副本",
    ["checkpoint"]="检查点", ["waypoint"]="路标", ["tween"]="过渡动画",
    ["rainbow"]="彩虹", ["gold"]="金色", ["diamond"]="钻石", ["cosmic"]="宇宙",
    ["event"]="活动", ["events"]="活动", ["code"]="兑换码", ["codes"]="兑换码", ["redeem"]="兑换",
    ["gift"]="礼物", ["gifts"]="礼物", ["free"]="免费", ["premium"]="高级", ["vip"]="VIP",
    ["pass"]="通行证", ["passes"]="通行证", ["gamepass"]="游戏通行证", ["robux"]="Robux",
    ["support"]="支持", ["discord"]="Discord", ["github"]="GitHub",
    ["username"]="用户名", ["password"]="密码", ["email"]="邮箱", ["login"]="登录", ["logout"]="登出",
    ["register"]="注册", ["account"]="账号", ["profile"]="个人资料",
    ["play"]="开始游戏", ["pause"]="暂停", ["resume"]="继续",
    ["hotkey"]="快捷键", ["hotkeys"]="快捷键", ["keybind"]="按键绑定", ["keybinds"]="按键绑定",
    ["silentaim"]="静默自瞄", ["autofarm"]="自动刷取", ["autocollect"]="自动收集",
    ["autohatch"]="自动孵化", ["autoequip"]="自动装备", ["autosell"]="自动出售", ["autobuy"]="自动购买",
    ["debug"]="调试", ["console"]="控制台", ["output"]="输出",
    ["executor"]="执行器", ["inject"]="注入", ["attach"]="附加", ["detach"]="分离",
    ["locked"]="已锁定", ["unlocked"]="未锁定", ["premium_only"]="仅高级版", ["pro_only"]="仅专业版",
    ["whitelist"]="白名单", ["blacklist"]="黑名单", ["ignore"]="忽略", ["ignored"]="已忽略",
    ["block"]="拦截", ["blocked"]="已拦截", ["allow"]="允许", ["allowed"]="已允许",
    ["active"]="启用中", ["inactive"]="未启用", ["running"]="运行中", ["stopped"]="已停止",
    ["unknown"]="未知", ["empty"]="空", ["null"]="空",
    ["true"]="是", ["false"]="否",
}

local function urlEncode(s)
    return (tostring(s):gsub("([^%w%-%._~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local function isMostlyChinese(s)
    local total, zh = 0, 0
    local ok = pcall(function()
        for _, code in utf8.codes(s) do
            total = total + 1
            if code >= 0x4E00 and code <= 0x9FFF then
                zh = zh + 1
            end
        end
    end)
    if not ok or total == 0 then
        return false
    end
    return (zh / total) > 0.3
end

local SENSITIVE = {
    "password", "passwd", "passcode", "token", "secret", "api key", "apikey",
    "auth", "credential", "cookie", "session", "private key", "privatekey",
    "seed phrase", "mnemonic", "wallet", "credit card", "cvv", "ssn",
    "email", "mail", "phone", "address",
    "密码", "账号", "帐号", "邮箱", "手机号", "验证码", "私钥", "助记词",
    "身份", "身份证", "银行卡", "支付",
}

local function isSensitive(text)
    if not CONFIG.ProtectSensitive then return false end
    local lower = string.lower(text)
    for i = 1, #SENSITIVE do
        if string.find(lower, SENSITIVE[i], 1, true) then
            return true
        end
    end
    return false
end

local function shouldTranslate(text)
    if type(text) ~= "string" then return false end
    if text == "" then return false end
    if #(text:gsub("%s", "")) == 0 then return false end

    local hasLetters = text:find("%a") ~= nil
    local hasCJK     = isMostlyChinese(text)

    if not hasLetters and not hasCJK then return false end

    if isSensitive(text) then
        State.skipped = State.skipped + 1
        return false
    end

    if CONFIG.TargetLang:find("^zh") and hasCJK then return false end
    if CONFIG.TargetLang == "en" and hasLetters and not hasCJK then return false end

    return true
end

local function splitRich(text)
    local openTag  = text:match("^(<[^>]*>)")
    local closeTag = text:match("(</[^>]*>)$")
    local plain    = text:gsub("^<[^>]*>", ""):gsub("</[^>]*>$", "")
    return openTag, closeTag, plain
end

local function wrapRich(openTag, closeTag, translated)
    return (openTag or "") .. translated .. (closeTag or "")
end

local function collectTextObjects(root)
    local out = {}
    local queue = { root }
    local visited = 0

    while #queue > 0 and visited < CONFIG.MaxNodes do
        local node = table.remove(queue)
        visited = visited + 1

        local okList, children = pcall(function()
            return node:GetChildren()
        end)

        if okList and children then
            for _, child in ipairs(children) do
                local okType = pcall(function()
                    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                        table.insert(out, child)
                    end
                end)
                if okType then
                    table.insert(queue, child)
                end
            end
        end
    end

    return out
end

local function getRoots()
    local roots = {}
    local okHui, hui = pcall(function() return gethui() end)
    if okHui and hui then table.insert(roots, hui) end
    if PlayerGui then table.insert(roots, PlayerGui) end
    if CONFIG.IncludeCore then
        local okCore, core = pcall(function() return game:GetService("CoreGui") end)
        if okCore and core then table.insert(roots, core) end
    end
    return roots
end

local excludedCache = setmetatable({}, { __mode = "k" })
local panelNameLower = string.lower(CONFIG.PanelName)

local function isExcluded(inst)
    local cached = excludedCache[inst]
    if cached ~= nil then
        return cached
    end

    local node = inst
    local depth = 0
    while node and depth < 25 do
        local okName, name = pcall(function() return node.Name end)
        if okName and name then
            local lower = string.lower(name)
            if string.find(lower, panelNameLower, 1, true) then
                excludedCache[inst] = true
                return true
            end
            for _, excluded in ipairs(CONFIG.ExcludeNames) do
                if lower == excluded then
                    excludedCache[inst] = true
                    return true
                end
            end
        end
        local okParent, parent = pcall(function() return node.Parent end)
        if not okParent or not parent then break end
        node = parent
        depth = depth + 1
    end

    excludedCache[inst] = false
    return false
end

local function shouldSkip(inst)
    local only = State.OnlyGuiName
    if only and only ~= "" then
        local lowerTarget = string.lower(only)
        local node = inst
        while node do
            local okName, name = pcall(function() return node.Name end)
            if okName and name and string.lower(name) == lowerTarget then
                return false
            end
            local okParent, parent = pcall(function() return node.Parent end)
            if not okParent or not parent then break end
            node = parent
        end
        return true
    end
    return isExcluded(inst)
end

local function requestGoogle(plain, targetLang)
    local url = "https://translate.googleapis.com/translate_a/single"
        .. "?client=gtx&sl=auto&dt=t&tl=" .. targetLang
        .. "&q=" .. urlEncode(plain)

    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if not ok or type(res) ~= "string" or res == "" then return nil end

    local okDecode, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not okDecode or type(data) ~= "table" or type(data[1]) ~= "table" then
        return nil
    end

    local parts = {}
    for _, seg in ipairs(data[1]) do
        if type(seg) == "table" and type(seg[1]) == "string" then
            table.insert(parts, seg[1])
        end
    end
    if #parts == 0 then return nil end

    return table.concat(parts)
end

local function requestMyMemory(plain, targetLang)
    local url = "https://api.mymemory.translated.net/get"
        .. "?q=" .. urlEncode(plain)
        .. "&langpair=en|" .. targetLang

    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if not ok or type(res) ~= "string" or res == "" then return nil end

    local okDecode, data = pcall(function() return HttpService:JSONDecode(res) end)
    if okDecode and type(data) == "table"
        and type(data.responseData) == "table"
        and type(data.responseData.translatedText) == "string"
    then
        local escaped = data.responseData.translatedText:gsub('[\\"]', '\\%0')
        local okText, decoded = pcall(function()
            return HttpService:JSONDecode('"' .. escaped .. '"')
        end)
        if okText and type(decoded) == "string" and decoded ~= "" then
            return decoded
        end
    end

    return nil
end

local function translateText(plain, targetLang)
    if not plain or plain == "" then return nil end
    if #plain > CONFIG.MaxLength then
        plain = plain:sub(1, CONFIG.MaxLength)
    end

    local key = targetLang .. "|" .. plain
    if State.Cache[key] then
        return State.Cache[key]
    end

    if targetLang:find("^zh") then
        local dictHit = DICT[string.lower(plain)]
        if dictHit then
            State.Cache[key] = dictHit
            return dictHit
        end
    end

    for attempt = 1, CONFIG.RetryTimes do
        local result = requestGoogle(plain, targetLang)
        if not result then
            result = requestMyMemory(plain, targetLang)
        end

        if result then
            State.Cache[key] = result
            return result
        end

        task.wait(0.2 * attempt)
    end

    return nil
end

local function enqueue(plain, inst, taggedValue)
    if not shouldTranslate(plain) then return end

    local entry = State.pending[plain]
    if not entry then
        local count = 0
        for _ in pairs(State.pending) do
            count = count + 1
            if count > CONFIG.MaxPending then break end
        end
        if count > CONFIG.MaxPending then return end

        entry = {
            insts  = setmetatable({}, { __mode = "k" }),
            tagged = setmetatable({}, { __mode = "k" }),
        }
        State.pending[plain] = entry
    end

    if inst then
        entry.insts[inst] = true
        if taggedValue and taggedValue ~= plain then
            entry.tagged[inst] = taggedValue
        end
    end
end

local function applyToInstances(plain, translated)
    State.RestorGuard = true

    local entry = State.pending[plain]
    if entry then
        for inst in pairs(entry.insts) do
            local okAlive, parent = pcall(function() return inst.Parent end)
            if okAlive and parent then
                local okText, current = pcall(function() return inst.Text end)
                if okText and shouldTranslate(current) then
                    local openTag, closeTag
                    local taggedValue = entry.tagged[inst]
                    if taggedValue then
                        openTag, closeTag = splitRich(taggedValue)
                    else
                        openTag, closeTag = splitRich(current)
                    end

                    pcall(function()
                        State.Original[inst] = State.Original[inst] or current
                        inst.Text = wrapRich(openTag, closeTag, translated)
                    end)
                end
            end
        end
    end

    State.RestorGuard = false
end

local function batchable(plain)
    return #plain <= 60
        and not string.find(plain, "\n", 1, true)
        and not string.find(plain, "<", 1, true)
        and string.find(plain, "%d") == nil
end

local function requestBatch(list, targetLang)
    if #list < 2 then return nil end
    local joined = table.concat(list, "\n")
    if #joined > CONFIG.BatchCharLimit then return nil end

    local result = requestGoogle(joined, targetLang)
    if not result then return nil end

    local parts = {}
    for line in result:gmatch("[^\n]+") do
        if #line > 0 then table.insert(parts, line) end
    end

    if #parts ~= #list then return nil end
    return parts
end

local function trimCache()
    local n = 0
    for _ in pairs(State.Cache) do
        n = n + 1
        if n > CONFIG.MaxCache then break end
    end
    if n > CONFIG.MaxCache then
        State.Cache = {}
    end
end

local function queueWorker()
    local backoff, rounds = 1, 0
    while State.Running do
        rounds = rounds + 1
        if rounds % 40 == 0 then
            pcall(trimCache)
        end
        task.wait(CONFIG.RequestDelay * backoff)

        local cand = {}
        for plain in pairs(State.pending) do
            table.insert(cand, plain)
            if #cand >= CONFIG.BatchSize + CONFIG.MaxConcurrent then break end
        end

        if #cand == 0 then
            task.wait(0.2)
        else
            local short, others = {}, {}
            for _, plain in ipairs(cand) do
                local key = CONFIG.TargetLang .. "|" .. plain
                if State.Cache[key] then
                    others[#others + 1] = plain
                elseif batchable(plain) then
                    short[#short + 1] = plain
                else
                    others[#others + 1] = plain
                end
            end

            local done, doneCount = {}, 0

            if #short >= 2 then
                local merged = {}
                for i = 1, math.min(#short, CONFIG.BatchSize) do
                    merged[#merged + 1] = short[i]
                end
                local parts = requestBatch(merged, CONFIG.TargetLang)
                if parts then
                    for i, plain in ipairs(merged) do
                        local key = CONFIG.TargetLang .. "|" .. plain
                        if parts[i] and parts[i] ~= "" then
                            State.Cache[key] = parts[i]
                            done[plain] = parts[i]
                            doneCount = doneCount + 1
                        end
                    end
                    State.batched = State.batched + doneCount
                end
            end

            local rest = {}
            for _, plain in ipairs(cand) do
                if not done[plain] then rest[#rest + 1] = plain end
            end

            if #rest > 0 then
                local results, finished, launched = {}, 0, math.min(#rest, CONFIG.MaxConcurrent)
                for i = 1, launched do
                    local plain = rest[i]
                    task.spawn(function()
                        local okRun, val = pcall(translateText, plain, CONFIG.TargetLang)
                        results[plain] = okRun and val or nil
                        finished = finished + 1
                    end)
                end

                local waited = 0
                while finished < launched and waited < 20 do
                    task.wait(0.1)
                    waited = waited + 0.1
                end

                for i = 1, launched do
                    local plain = rest[i]
                    if results[plain] then
                        done[plain] = results[plain]
                        doneCount = doneCount + 1
                    end
                end
            end

            for plain, translated in pairs(done) do
                pcall(function()
                    State.success = State.success + 1
                    applyToInstances(plain, translated)
                end)
                State.pending[plain] = nil
            end

            for _, plain in ipairs(cand) do
                if not done[plain] and State.pending[plain] then
                    State.failures = State.failures + 1
                end
            end
            if doneCount == 0 then
                backoff = math.min(backoff * 1.6, 6)
            else
                backoff = 1
            end
        end
    end
end

local originalNewIndex

local classCache = setmetatable({}, { __mode = "k" })

local function isTextInstance(obj)
    local cached = classCache[obj]
    if cached ~= nil then
        return cached
    end

    local ok, result = pcall(function()
        return obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")
    end)

    local value = ok and result or false
    classCache[obj] = value
    return value
end

local function hookHandler(self, key, value)
    if key == "Text"
        and type(value) == "string"
        and not State.RestorGuard
        and not State.Paused
    then
        local openTag, closeTag, plain = splitRich(value)
        if plain ~= "" then
            local cached = State.Cache[CONFIG.TargetLang .. "|" .. plain]
            if cached then
                return originalNewIndex(self, key, wrapRich(openTag, closeTag, cached))
            end

            if isTextInstance(self) and shouldTranslate(plain) and not shouldSkip(self) then
                enqueue(plain, self, value)
            end
        end
    end

    return originalNewIndex(self, key, value)
end

local function installHook()
    local hookMeta = hookmetamethod

    if type(hookMeta) ~= "function" then
        State.Hooked = false
        return false
    end

    local ok = pcall(function()
        originalNewIndex = hookMeta(game, "__newindex", hookHandler)
    end)

    State.Hooked = ok
    return ok
end

local function uninstallHook()
    if State.Hooked and originalNewIndex then
        pcall(function()
            hookmetamethod(game, "__newindex", originalNewIndex)
        end)
        State.Hooked = false
    end
end

local function hookAlive()
    if not State.Hooked then return false end
    if type(getmetamethod) ~= "function" then return true end
    local ok, current = pcall(getmetamethod, game, "__newindex")
    if not ok then return true end
    return current == hookHandler
end

local function scanAll()
    local hit = 0

    for _, root in ipairs(getRoots()) do
        for _, inst in ipairs(collectTextObjects(root)) do
            if not shouldSkip(inst) then
                local okText, text = pcall(function() return inst.Text end)
                if okText and type(text) == "string" then
                    local openTag, closeTag, plain = splitRich(text)
                    if plain ~= "" and shouldTranslate(plain) then
                        local cached = State.Cache[CONFIG.TargetLang .. "|" .. plain]
                        if cached then
                            pcall(function()
                                State.Original[inst] = State.Original[inst] or text
                                inst.Text = wrapRich(openTag, closeTag, cached)
                            end)
                        else
                            enqueue(plain, inst, text)
                        end
                        hit = hit + 1
                    end
                end
            end
        end
    end

    State.scanned = hit
    return hit
end

local function restoreOriginal()
    State.RestorGuard = true
    State.Paused = true
    local count = 0

    for inst, original in pairs(State.Original) do
        local okAlive, parent = pcall(function() return inst.Parent end)
        if okAlive and parent then
            pcall(function() inst.Text = original end)
            count = count + 1
        end
    end

    State.Original = setmetatable({}, { __mode = "k" })
    State.RestorGuard = false
    return count
end

local LANGUAGES = {
    { Name = "简体中文", Code = "zh-CN" },
    { Name = "繁體中文", Code = "zh-TW" },
    { Name = "English",  Code = "en" },
    { Name = "日本語",    Code = "ja" },
    { Name = "한국어",    Code = "ko" },
}

local API = {}
local alive, opened, reduced = true, true, false
local links, tweens = {}, {}
local accent = Color3.fromRGB(255, 255, 255)
local white = Color3.fromRGB(245, 245, 245)
local muted = Color3.fromRGB(158, 158, 158)
local glassColor = Color3.fromRGB(24, 24, 24)
local M = {}
local activePage, transition = 1, 0
local scaleValue = 1
local drag, sliding
local layout, setOpen, selectPage
local function bind(signal, callback)
    local c = signal:Connect(callback)
    links[#links + 1] = c
    return c
end
local function make(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end
local function round(o, r)
    make("UICorner", { CornerRadius = UDim.new(0, r or 16) }, o)
end
local function tween(o, props, duration, style)
    if not alive or not o.Parent then return end
    local channels = tweens[o]
    if not channels then channels = {}; tweens[o] = channels end
    for k in pairs(props) do if channels[k] then channels[k]:Cancel() end end
    local t = TweenService:Create(o, TweenInfo.new(reduced and 0 or (duration or 0.3), style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    for k in pairs(props) do channels[k] = t end
    t:Play()
    t.Completed:Once(function()
        for k in pairs(props) do if channels[k] == t then channels[k] = nil end end
        if next(channels) == nil and tweens[o] == channels then tweens[o] = nil end
    end)
    return t
end
local function frame(parent, pos, size, color, transparency, radius)
    local o = make("Frame", { Position = pos, Size = size, BorderSizePixel = 0,
        BackgroundColor3 = color or white, BackgroundTransparency = transparency or 0 }, parent)
    if radius then round(o, radius) end
    return o
end
local function text(parent, value, pos, size, fontSize, color, bold)
    return make("TextLabel", { BackgroundTransparency = 1, Position = pos, Size = size,
        Text = value, TextSize = fontSize or 13, TextColor3 = color or white,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, parent)
end
local glassSurfaces = setmetatable({}, { __mode = "k" })
local function glass(parent, pos, size, radius, class)
    local o = make(class or "Frame", { Position = pos, Size = size, BorderSizePixel = 0,
        BackgroundColor3 = glassColor, BackgroundTransparency = 0.16 }, parent)
    round(o, radius or 22)
    local stroke = make("UIStroke", { Color = white, Thickness = 1, Transparency = 0.72, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
    make("UIGradient", { Rotation = 65, Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(146, 146, 146)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 225, 225)),
    }), Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.5, 0.75), NumberSequenceKeypoint.new(1, 0.35) }) }, stroke)
    make("UIGradient", { Rotation = 115, Color = ColorSequence.new(Color3.fromRGB(240, 240, 240), Color3.fromRGB(130, 130, 130)) }, o)
    local gleam = frame(o, UDim2.new(0, 18, 0, 1), UDim2.new(1, -36, 0, 1), white, 0.5, 1)
    gleam.Name = "RimLight"
    make("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.15), NumberSequenceKeypoint.new(1, 1) }) }, gleam)
    glassSurfaces[o] = true
    return o
end
local function button(parent, value, pos, size, highlighted)
    local o = glass(parent, pos, size, 12, "TextButton")
    o.Text, o.TextSize, o.Font = value, 12, Enum.Font.GothamMedium
    o.TextColor3, o.AutoButtonColor = highlighted and Color3.fromRGB(18, 18, 18) or white, false
    local base = highlighted and accent or glassColor
    o.BackgroundColor3 = base
    o.BackgroundTransparency = highlighted and 0.05 or 0.32
    local s = make("UIScale", { Scale = 1 }, o)
    bind(o.MouseEnter, function() tween(o, { BackgroundColor3 = base:Lerp(white, 0.13) }, 0.16) end)
    bind(o.MouseLeave, function() tween(o, { BackgroundColor3 = base }, 0.2); tween(s, { Scale = 1 }, 0.22) end)
    bind(o.InputBegan, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then tween(s, { Scale = 0.95 }, 0.12) end
    end)
    bind(o.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then tween(s, { Scale = 1 }, 0.35, Enum.EasingStyle.Back) end
    end)
    return o
end
local function line(parent, x, y, a, b, color, width)
    local v = Vector2.new(a - x, b - y)
    local o = frame(parent, UDim2.fromOffset((x + a) / 2, (y + b) / 2), UDim2.fromOffset(v.Magnitude, width or 1.7), color or white, 0, 1)
    o.AnchorPoint, o.Rotation = Vector2.new(0.5, 0.5), math.deg(math.atan2(v.Y, v.X))
    return o
end
local function icon(parent, kind, pos, color)
    color = color or white
    local h = frame(parent, pos, UDim2.fromOffset(24, 24), white, 1)
    local function l(x, y, a, b) return line(h, x, y, a, b, color) end
    local function f(x, y, w, ht, r) return frame(h, UDim2.fromOffset(x, y), UDim2.fromOffset(w, ht), color, 0, r) end
    if kind == "home" then
        l(4, 11, 12, 4); l(12, 4, 20, 11); l(6, 10, 6, 20); l(18, 10, 18, 20); l(6, 20, 18, 20); l(11, 20, 11, 15)
    elseif kind == "grid" then
        for i = 0, 3 do f(4 + i % 2 * 10, 4 + math.floor(i / 2) * 10, 6, 6, 2) end
    elseif kind == "settings" then
        for i = 0, 2 do local x = 6 + i * 6; l(x, 4, x, 20); f(x - 2, i == 1 and 13 or 7, 4, 4, 2) end
    elseif kind == "music" then
        l(10, 6, 10, 18); l(10, 6, 20, 4); l(20, 4, 20, 16); f(5, 16, 6, 5, 3); f(15, 14, 6, 5, 3)
    elseif kind == "close" then l(7, 7, 17, 17); l(17, 7, 7, 17)
    elseif kind == "minus" then l(6, 12, 18, 12)
    elseif kind == "play" then l(9, 5, 19, 12); l(19, 12, 9, 19); l(9, 19, 9, 5)
    elseif kind == "pause" then f(7, 5, 3, 14, 1); f(15, 5, 3, 14, 1)
    elseif kind == "next" then l(6, 6, 14, 12); l(14, 12, 6, 18); l(18, 6, 18, 18)
    elseif kind == "back" then l(18, 6, 10, 12); l(10, 12, 18, 18); l(6, 6, 6, 18)
    elseif kind == "bell" then l(7, 16, 7, 10); l(7, 10, 12, 5); l(12, 5, 17, 10); l(17, 10, 17, 16); l(5, 17, 19, 17); l(10, 20, 14, 20)
    elseif kind == "grip" then
        for i = 0, 5 do f(8 + i % 2 * 6, 5 + math.floor(i / 2) * 6, 2, 2, 1) end
    else
        local ring = f(3, 6, 18, 12, 12); ring.BackgroundTransparency = 1; ring.Rotation = -35
        make("UIStroke", { Color = color, Thickness = 1.5 }, ring); f(10, 10, 4, 4, 3)
    end
    return h
end
local function box(parent, placeholder, pos, size)
    local o = make("TextBox", { Position = pos, Size = size, BackgroundColor3 = Color3.fromRGB(12, 12, 12), BackgroundTransparency = 0.35,
        BorderSizePixel = 0, Text = "", PlaceholderText = placeholder, PlaceholderColor3 = muted, TextColor3 = white,
        Font = Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left }, parent)
    round(o, 10)
    make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, o)
    return o
end

local gui = make("ScreenGui", { Name = "LumaGlass", ResetOnSpawn = false, IgnoreGuiInset = true,
    DisplayOrder = 160, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, playerGui)
local shutdown = make("BindableEvent", { Name = "Shutdown" }, gui)
local screen = frame(gui, UDim2.new(), UDim2.fromScale(1, 1), white, 1)
local stage = frame(screen, UDim2.new(), UDim2.fromOffset(1030, 620), white, 1)
local fit = make("UIScale", { Scale = 1 }, stage)
local components = {}
local function component(name, x, y, w, h, radius)
    local host = frame(stage, UDim2.fromOffset(x, y), UDim2.fromOffset(w, h), white, 1)
    host.Name = name .. "Anchor"
    local surface = glass(host, UDim2.new(), UDim2.fromOffset(w, h), radius, "CanvasGroup")
    surface.Name = name
    local anim = make("UIScale", { Scale = 1 }, surface)
    local item = { host = host, surface = surface, anim = anim, fit = make("UIScale", { Scale = 1 }, host),
        w = w, h = h, x = x, y = y, scale = 1, startX = x, startY = y }
    components[#components + 1] = item
    return item
end
local nav = component("DetachedSidebar", 20, 80, 76, 398, 24)
local main = component("MainWindow", 112, 80, 580, 398, 24)
local music = component("DetachedPlayer", 708, 80, 292, 510, 24)
local dock = component("FloatingToolbar", 244, 550, 316, 62, 28)
local D = { buttons = {}, selected = 1 }
D.select = function() end
local I = { expanded = false, hasTrack = false, bars = {}, idleBars = {}, holdSerial = 0, pulseUntil = 0 }
I.width = make("NumberValue", { Value = 164 }, gui)
I.height = make("NumberValue", { Value = 28 }, gui)
local islandHost = frame(screen, UDim2.new(0.5, 0, 0, 10), UDim2.fromOffset(0, 0), white, 1)
islandHost.ZIndex = 30
I.scale = make("UIScale", { Scale = 1 }, islandHost)
local island = make("TextButton", { Name = "DynamicIsland", AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.fromOffset(164, 28),
    BackgroundColor3 = Color3.fromRGB(3, 3, 3), BackgroundTransparency = 0.02, BorderSizePixel = 0,
    Text = "", AutoButtonColor = false, ClipsDescendants = true }, islandHost)
I.corner = make("UICorner", { CornerRadius = UDim.new(0, 14) }, island)
make("UIStroke", { Color = white, Thickness = 1, Transparency = 0.78 }, island)
I.idle = frame(island, UDim2.new(), UDim2.fromOffset(164, 28), white, 1)
local islandDot = frame(I.idle, UDim2.fromOffset(11, 11), UDim2.fromOffset(6, 6), accent, 0, 8)
text(I.idle, "LUMA", UDim2.fromOffset(26, 3), UDim2.fromOffset(60, 22), 10, white, true)
I.status = text(I.idle, "收起", UDim2.fromOffset(121, 3), UDim2.fromOffset(32, 22), 10, white, true)
for i = 1, 4 do
    local b = frame(I.idle, UDim2.fromOffset(88 + i * 4, 14), UDim2.fromOffset(2, 8), white, 0.15, 2)
    b.AnchorPoint = Vector2.new(0.5, 0.5)
    I.idleBars[i] = b
end
I.compact = frame(island, UDim2.new(), UDim2.fromOffset(220, 34), white, 1)
I.compact.Visible = false
I.miniCover = make("ImageLabel", { Position = UDim2.fromOffset(7, 5), Size = UDim2.fromOffset(24, 24), BackgroundColor3 = Color3.fromRGB(38, 38, 38), BorderSizePixel = 0, Image = "", ScaleType = Enum.ScaleType.Crop }, I.compact)
round(I.miniCover, 7)
I.miniFallback = text(I.miniCover, "L", UDim2.new(), UDim2.fromScale(1, 1), 14, white, true)
I.miniFallback.TextXAlignment = Enum.TextXAlignment.Center
I.miniTitle = text(I.compact, "", UDim2.fromOffset(40, 3), UDim2.fromOffset(142, 15), 10, white, true)
I.miniArtist = text(I.compact, "", UDim2.fromOffset(40, 18), UDim2.fromOffset(142, 13), 8, muted)
for i = 1, 5 do
    local b = frame(I.compact, UDim2.fromOffset(188 + i * 4, 17), UDim2.fromOffset(2, 5), white, 0.1, 2)
    b.AnchorPoint = Vector2.new(0.5, 0.5); I.bars[i] = b
end
I.detail = make("CanvasGroup", { Size = UDim2.fromOffset(360, 170), BackgroundTransparency = 1, GroupTransparency = 1, Visible = false }, island)
make("UIScale", { Scale = 0.85 }, I.detail)
I.cover = make("ImageLabel", { Position = UDim2.fromOffset(18, 18), Size = UDim2.fromOffset(56, 56), BackgroundColor3 = Color3.fromRGB(32, 32, 32), BorderSizePixel = 0, Image = "", ScaleType = Enum.ScaleType.Crop }, I.detail)
round(I.cover, 13)
I.fallback = text(I.cover, "L", UDim2.new(), UDim2.fromScale(1, 1), 24, white, true)
I.fallback.TextXAlignment = Enum.TextXAlignment.Center
I.title = text(I.detail, "", UDim2.fromOffset(88, 21), UDim2.fromOffset(252, 25), 16, white, true)
I.artist = text(I.detail, "", UDim2.fromOffset(88, 48), UDim2.fromOffset(252, 20), 11, muted)
I.seek = make("TextButton", { Position = UDim2.fromOffset(18, 81), Size = UDim2.fromOffset(324, 22), Text = "", BackgroundTransparency = 1 }, I.detail)
frame(I.seek, UDim2.fromOffset(0, 10), UDim2.fromOffset(324, 3), white, 0.8, 2)
I.seekFill = frame(I.seek, UDim2.fromOffset(0, 10), UDim2.fromOffset(0, 3), white, 0, 2)
I.time = text(I.detail, "0:00", UDim2.fromOffset(18, 103), UDim2.fromOffset(72, 15), 9, muted)
I.duration = text(I.detail, "0:00", UDim2.fromOffset(270, 103), UDim2.fromOffset(72, 15), 9, muted)
I.duration.TextXAlignment = Enum.TextXAlignment.Right
I.back = button(I.detail, "", UDim2.fromOffset(105, 122), UDim2.fromOffset(36, 32))
icon(I.back, "back", UDim2.fromOffset(6, 4), white)
I.play = button(I.detail, "", UDim2.fromOffset(158, 120), UDim2.fromOffset(44, 36), true)
I.next = button(I.detail, "", UDim2.fromOffset(219, 122), UDim2.fromOffset(36, 32))
icon(I.next, "next", UDim2.fromOffset(6, 4), white)
I.window = button(I.detail, "窗口", UDim2.fromOffset(282, 126), UDim2.fromOffset(58, 28))
I.refresh = function() end

local function beginDrag(item, i)
    if drag or sliding then return end
    if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
    local channels = tweens[item.host]
    if channels and channels.Position then channels.Position:Cancel() end
    drag = { item = item, input = i, start = Vector2.new(i.Position.X, i.Position.Y), origin = Vector2.new(item.x, item.y), moved = false }
end
local suppressUntil = 0
local function handle(item, parent, pos, size)
    local h = make("TextButton", { Name = "DragHandle", Position = pos, Size = size, Text = "", BackgroundTransparency = 1, Active = true }, parent)
    bind(h.InputBegan, function(i) beginDrag(item, i) end)
    return h
end
handle(main, main.surface, UDim2.new(), UDim2.new(1, -88, 0, 72))
local navGrip = handle(nav, nav.surface, UDim2.fromOffset(6, 6), UDim2.fromOffset(64, 66))
icon(navGrip, "orbit", UDim2.fromOffset(20, 20), accent)
local musicGrip = handle(music, music.surface, UDim2.new(), UDim2.new(1, 0, 0, 52))
handle(dock, dock.surface, UDim2.new(), UDim2.fromOffset(38, 62))
icon(dock.surface, "grip", UDim2.fromOffset(8, 19), muted)

local heading = text(main.surface, "概览", UDim2.fromOffset(24, 22), UDim2.fromOffset(300, 24), 21, white, true)
text(main.surface, "你的空间，轻盈有序。", UDim2.fromOffset(24, 49), UDim2.fromOffset(350, 18), 11, muted)
local minimize = button(main.surface, "", UDim2.fromOffset(492, 22), UDim2.fromOffset(28, 28))
icon(minimize, "minus", UDim2.fromOffset(2, 2), muted)
local close = button(main.surface, "", UDim2.fromOffset(528, 22), UDim2.fromOffset(28, 28))
icon(close, "close", UDim2.fromOffset(2, 2), muted)
frame(main.surface, UDim2.fromOffset(24, 83), UDim2.fromOffset(532, 1), white, 0.93)
local pages, navButtons = {}, {}
for i = 1, 5 do
    local p = make("CanvasGroup", { Size = UDim2.fromOffset(532, 260), Position = UDim2.fromOffset(24, 101), BackgroundTransparency = 1,
        GroupTransparency = i == 1 and 0 or 1, Visible = i == 1 }, main.surface)
    pages[i] = p
end
local navMarker = frame(nav.surface, UDim2.fromOffset(7, 91), UDim2.fromOffset(3, 28), accent, 0, 2)
local names, kinds = { "概览", "功能", "外观", "翻译", "关于" }, { "home", "grid", "settings", "music", "orbit" }
for i = 1, 5 do
    local b = button(nav.surface, "", UDim2.fromOffset(16, 84 + (i - 1) * 52), UDim2.fromOffset(44, 44))
    icon(b, kinds[i], UDim2.fromOffset(10, 10), i == 1 and accent or muted)
    b.BackgroundTransparency = i == 1 and 0.12 or 0.88
    navButtons[i] = b
    bind(b.Activated, function() selectPage(i) end)
end
text(nav.surface, "01", UDim2.fromOffset(25, 356), UDim2.fromOffset(28, 18), 10, muted)
text(main.surface, "LUMA  /  CLIENT INTERFACE", UDim2.fromOffset(24, 372), UDim2.fromOffset(360, 14), 9, muted)
local fpsText = text(main.surface, "60 FPS", UDim2.fromOffset(475, 370), UDim2.fromOffset(80, 18), 10, accent)
fpsText.TextXAlignment = Enum.TextXAlignment.Right

local hero = glass(pages[1], UDim2.new(), UDim2.fromOffset(532, 124), 17)
text(hero, "A LITTLE SPACE. A LOT OF POSSIBILITY.", UDim2.fromOffset(18, 14), UDim2.fromOffset(480, 16), 9, accent, true)
text(hero, "让每一次操作，都更轻盈。", UDim2.fromOffset(18, 37), UDim2.fromOffset(490, 31), 23, white, true)
text(hero, "分离布局  /  细腻动效  /  自由拖动", UDim2.fromOffset(18, 82), UDim2.fromOffset(490, 20), 12, muted)
local statValues = { "04", "自由", "READY" }
local statLabels = { "独立工作区域", "鼠标 / 触屏拖动", "界面已就绪" }
for i = 1, 3 do
    local card = glass(pages[1], UDim2.fromOffset((i - 1) * 182, 138), UDim2.fromOffset(168, 76), 14)
    text(card, statValues[i], UDim2.fromOffset(14, 10), UDim2.fromOffset(140, 28), 22, i == 3 and accent or white, true)
    text(card, statLabels[i], UDim2.fromOffset(14, 44), UDim2.fromOffset(140, 18), 10, muted)
end
local showToast = button(pages[1], "体验通知", UDim2.fromOffset(0, 230), UDim2.fromOffset(124, 30), true)
local resetButton = button(pages[1], "重置布局", UDim2.fromOffset(136, 230), UDim2.fromOffset(124, 30))
text(pages[1], "拖动面板顶部，摆放你的工作区", UDim2.fromOffset(280, 230), UDim2.fromOffset(252, 30), 10, muted)

local function toggle(parent, title, subtitle, y, initial, callback)
    local row = glass(parent, UDim2.fromOffset(0, y), UDim2.fromOffset(532, 70), 14)
    text(row, title, UDim2.fromOffset(15, 10), UDim2.fromOffset(425, 24), 13, white, true)
    text(row, subtitle, UDim2.fromOffset(15, 36), UDim2.fromOffset(425, 18), 10, muted)
    local b = button(row, "", UDim2.fromOffset(466, 23), UDim2.fromOffset(46, 25))
    round(b, 13)
    local knob = frame(b, UDim2.fromOffset(initial and 25 or 4, 4), UDim2.fromOffset(17, 17), initial and accent or muted, 0, 9)
    local value = initial
    bind(b.Activated, function()
        value = not value
        tween(knob, { Position = UDim2.fromOffset(value and 25 or 4, 4), BackgroundColor3 = value and accent or muted }, 0.25)
        callback(value)
    end)
    return row
end
local notifyEnabled, playerEnabled, dockEnabled = true, true, true
local notify
toggle(pages[2], "分离式播放器", "显示右侧音乐播放器，顶部可独立拖动", 0, true, function(v)
    playerEnabled = v
    music.surface.Visible = v and opened
    if v then
        tween(music.surface, { GroupTransparency = 0, Position = UDim2.new() }, 0.3)
        tween(music.anim, { Scale = 1 }, 0.3)
    end
end)
toggle(pages[2], "悬浮功能栏", "快捷切页、通知与收起，拖动左侧六点把手", 82, true, function(v)
    dockEnabled = v; dock.surface.Visible = v and opened
    if v then
        tween(dock.surface, { GroupTransparency = 0, Position = UDim2.new() }, 0.3)
        tween(dock.anim, { Scale = 1 }, 0.3)
    end
end)
toggle(pages[2], "操作通知", "右下角依次弹出，超量消息自动排队", 164, true, function(v)
    notifyEnabled = v
    if v then notify("通知已开启", "消息会自动排列，不会相互覆盖。") end
end)

toggle(pages[3], "柔和动态", "缩短过渡时间，保留清晰的状态反馈", 0, false, function(v) reduced = v end)
toggle(pages[3], "轻透玻璃", "调整背景透明度，适应明亮和深色场景", 82, false, function(v)
    for surface in pairs(glassSurfaces) do
        if surface.Parent and not surface:IsA("TextButton") and surface ~= island then
            tween(surface, { BackgroundTransparency = v and 0.4 or 0.16 }, 0.25)
        end
    end
end)
local restore = button(pages[3], "恢复面板初始位置", UDim2.fromOffset(0, 180), UDim2.fromOffset(532, 44))
text(pages[3], "快捷键  /  Right Shift 展开或收起", UDim2.fromOffset(0, 238), UDim2.fromOffset(532, 20), 11, muted)
local about = glass(pages[5], UDim2.new(), UDim2.fromOffset(532, 260), 18)
icon(about, "orbit", UDim2.fromOffset(22, 24), accent)
text(about, Config.Title .. "  /  GLASS EDITION", UDim2.fromOffset(59, 24), UDim2.fromOffset(440, 25), 18, white, true)
text(about, "为你的 Roblox 工作区设计", UDim2.fromOffset(22, 70), UDim2.fromOffset(488, 25), 16, white, true)
local info = text(about, "点击灵动岛展开或收起。拖动窗口顶部、侧栏标志、播放器标题或功能栏把手，可分别调整位置。\n\n音乐支持网易云歌曲搜索和链接，播放状态同步到灵动岛；点按播放态灵动岛可展开音乐控制。", UDim2.fromOffset(22, 108), UDim2.fromOffset(488, 108), 12, muted)
info.TextWrapped, info.TextYAlignment = true, Enum.TextYAlignment.Top
text(about, "作者  /  " .. Config.Author .. "  ·  QQ  " .. Config.AuthorQQ, UDim2.fromOffset(22, 214), UDim2.fromOffset(488, 16), 10, white)
text(about, "VERSION 1.0   /   NATIVE ROBLOX UI", UDim2.fromOffset(22, 230), UDim2.fromOffset(488, 16), 9, accent)

local tp = pages[4]
local tpCard = glass(tp, UDim2.new(), UDim2.fromOffset(532, 64), 14)
text(tpCard, "TRANSLATION ENGINE  /  ROBLOX", UDim2.fromOffset(14, 7), UDim2.fromOffset(320, 14), 9, accent, true)
local tpDot = frame(tpCard, UDim2.fromOffset(506, 9), UDim2.fromOffset(9, 9), Color3.fromRGB(120, 200, 130), 0, 5)
local tpStats = {}
local tpStatLabels = { "扫描", "成功", "失败", "队列" }
for i = 1, 4 do
    tpStats[i] = text(tpCard, tpStatLabels[i] .. "  0", UDim2.fromOffset(14 + (i - 1) * 126, 25), UDim2.fromOffset(120, 25), 16, white, true)
end
frame(tpCard, UDim2.fromOffset(14, 54), UDim2.fromOffset(504, 3), white, 0.82, 2)
local tpBar = frame(tpCard, UDim2.fromOffset(14, 54), UDim2.fromOffset(0, 3), accent, 0, 2)

local tpTranslate = button(tp, "立即翻译", UDim2.fromOffset(0, 72), UDim2.fromOffset(168, 34), true)
local tpRestore = button(tp, "还原原文", UDim2.fromOffset(182, 72), UDim2.fromOffset(168, 34))
local tpHook = button(tp, "重新挂钩", UDim2.fromOffset(364, 72), UDim2.fromOffset(168, 34))

local tpLangButtons = {}
local langShort = { "简中", "繁中", "EN", "日本語", "한국어" }
for i = 1, #LANGUAGES do
    local b = button(tp, langShort[i] or LANGUAGES[i].Name, UDim2.fromOffset((i - 1) * 108, 112), UDim2.fromOffset(100, 28))
    local ul = frame(b, UDim2.new(0, 0, 1, -3), UDim2.new(1, 0, 0, 2), accent, 0, 1)
    tpLangButtons[i] = { button = b, underline = ul }
    bind(b.Activated, function()
        CONFIG.TargetLang = LANGUAGES[i].Code
        State.Paused = false
        task.spawn(scanAll)
    end)
end
local function tpRefreshLang()
    for i, entry in ipairs(tpLangButtons) do
        local on = LANGUAGES[i].Code == CONFIG.TargetLang
        entry.underline.Visible = on
        entry.button.TextColor3 = on and accent or muted
    end
end
tpRefreshLang()

text(tp, "只翻译指定 GUI（留空 = 全屏翻译）", UDim2.fromOffset(0, 148), UDim2.fromOffset(300, 14), 10, muted)
local tpBox = box(tp, "例：FluxUI", UDim2.fromOffset(0, 164), UDim2.fromOffset(532, 30))
bind(tpBox.FocusLost, function()
    State.OnlyGuiName = tpBox.Text
    task.spawn(scanAll)
end)

local function miniToggle(parent, x, y, w, h, label, initial, callback)
    local row = glass(parent, UDim2.fromOffset(x, y), UDim2.fromOffset(w, h), 12)
    text(row, label, UDim2.fromOffset(14, 0), UDim2.fromOffset(w - 64, h), 12, white, true)
    local track = button(row, "", UDim2.fromOffset(w - 48, (h - 22) / 2), UDim2.fromOffset(34, 22))
    round(track, 11)
    local knob = frame(track, UDim2.fromOffset(initial and 15 or 3, 3), UDim2.fromOffset(16, 16), initial and accent or muted, 0, 8)
    local value = initial
    bind(track.Activated, function()
        value = not value
        tween(knob, { Position = UDim2.fromOffset(value and 15 or 3, 3), BackgroundColor3 = value and accent or muted }, 0.22)
        if callback then callback(value) end
    end)
    return row
end

miniToggle(tp, 0, 200, 260, 36, "自动翻译", true, function(v)
    State.Auto = v
    if v then State.Paused = false end
end)
local tpTip = text(tp, "Right Shift 展开 / 收起", UDim2.fromOffset(272, 200), UDim2.fromOffset(260, 36), 10, muted)
tpTip.TextXAlignment = Enum.TextXAlignment.Right

bind(tpTranslate.Activated, function()
    State.Paused = false
    task.spawn(function()
        local n = scanAll()
        notify("开始扫描", string.format("发现 %d 条待翻译文本。", n))
    end)
end)
bind(tpRestore.Activated, function()
    local n = restoreOriginal()
    notify("已还原", string.format("恢复 %d 条原文。", n))
end)
bind(tpHook.Activated, function()
    uninstallHook()
    if installHook() then notify("挂钩已重装", "新的界面文本会被实时替换。") else notify("挂钩失败", "执行器不支持 hookmetamethod，已启用轮询兜底。") end
end)

task.spawn(function()
    while alive do
        task.wait(0.4)
        local pendingCount = 0
        for _ in pairs(State.pending) do pendingCount = pendingCount + 1 end
        pcall(function()
            tpStats[1].Text = "扫描  " .. State.scanned
            tpStats[2].Text = "成功  " .. State.success
            tpStats[3].Text = "失败  " .. State.failures
            tpStats[4].Text = "队列  " .. pendingCount
            if not State.Hooked then
                tpDot.BackgroundColor3 = Color3.fromRGB(220, 90, 90)
            elseif pendingCount > 0 then
                tpDot.BackgroundColor3 = Color3.fromRGB(230, 190, 80)
            else
                tpDot.BackgroundColor3 = Color3.fromRGB(120, 200, 130)
            end
            local total = State.success + State.failures + pendingCount
            local ratio = total > 0 and (State.success / total) or 0
            if pendingCount == 0 and State.success > 0 then ratio = 1 end
            tpBar.Size = UDim2.fromOffset(504 * ratio, 3)
            if State.skipped > 0 then
                tpTip.Text = string.format("已拦截敏感 %d 条 · 批量 %d 条", State.skipped, State.batched)
            elseif State.rehook > 0 then
                tpTip.Text = string.format("钩子已自愈 %d 次", State.rehook)
            else
                tpTip.Text = "Right Shift 展开 / 收起"
            end
            tpRefreshLang()
        end)
    end
end)

local pageVersion = 0
selectPage = function(index)
    D.select(index <= 2 and index or 0)
    if index == activePage then return end
    pageVersion = pageVersion + 1
    local version = pageVersion
    local previous = pages[activePage]
    activePage = index
    heading.Text = names[index]
    tween(navMarker, { Position = UDim2.fromOffset(7, 92 + (index - 1) * 52) }, 0.38)
    for i, b in ipairs(navButtons) do tween(b, { BackgroundTransparency = i == index and 0.12 or 0.88 }, 0.25) end
    tween(previous, { GroupTransparency = 1, Position = UDim2.fromOffset(16, 101) }, 0.14)
    local nextPage = pages[index]
    nextPage.Visible, nextPage.GroupTransparency, nextPage.Position = true, 1, UDim2.fromOffset(36, 101)
    tween(nextPage, { GroupTransparency = 0, Position = UDim2.fromOffset(24, 101) }, 0.32)
    task.delay(reduced and 0 or 0.15, function()
        if not alive or version ~= pageVersion then return end
        for i, p in ipairs(pages) do if i ~= index then p.Visible = false end end
    end)
end

local toastLayer = frame(screen, UDim2.new(), UDim2.fromScale(1, 1), white, 1)
toastLayer.ZIndex = 50
local toastScale = make("UIScale", { Scale = 1 }, toastLayer)
local pending, visibleToasts = {}, {}
local toastCapacity, toastWidth = 3, 294
local pump, arrange, removeToast
arrange = function()
    local sw, sh = screen.AbsoluteSize.X / toastScale.Scale, screen.AbsoluteSize.Y / toastScale.Scale
    for i, entry in ipairs(visibleToasts) do
        local y = sh - 16 - (i - 1) * 96
        tween(entry.host, { Position = UDim2.fromOffset(sw - 16, y) }, 0.35)
    end
end
removeToast = function(entry)
    if entry.leaving or not alive then return end
    entry.leaving = true
    tween(entry.surface, { GroupTransparency = 1 }, 0.19)
    tween(entry.host, { Position = entry.host.Position + UDim2.fromOffset(26, 0) }, 0.19)
    task.delay(reduced and 0 or 0.2, function()
        if not alive then return end
        for i, item in ipairs(visibleToasts) do if item == entry then table.remove(visibleToasts, i); break end end
        entry.host:Destroy()
        arrange(); pump()
    end)
end
pump = function()
    if not alive then return end
    while #pending > 0 and #visibleToasts < toastCapacity do
        local data = table.remove(pending, 1)
        local host = frame(toastLayer, UDim2.fromOffset(screen.AbsoluteSize.X / toastScale.Scale + toastWidth, screen.AbsoluteSize.Y / toastScale.Scale - 16 - #visibleToasts * 96), UDim2.fromOffset(toastWidth, 84), white, 1)
        host.AnchorPoint = Vector2.new(1, 1)
        local surface = glass(host, UDim2.new(), UDim2.fromOffset(toastWidth, 84), 17, "CanvasGroup")
        surface.GroupTransparency = 1
        icon(surface, "bell", UDim2.fromOffset(12, 15), accent)
        text(surface, data.title, UDim2.fromOffset(45, 11), UDim2.fromOffset(toastWidth - 77, 23), 12, white, true)
        local body = text(surface, data.message, UDim2.fromOffset(45, 36), UDim2.fromOffset(toastWidth - 59, 32), 10, muted)
        body.TextWrapped, body.TextYAlignment, body.TextTruncate = true, Enum.TextYAlignment.Top, Enum.TextTruncate.None
        local dismiss = make("TextButton", { Position = UDim2.new(1, -28, 0, 8), Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, Text = "", AutoButtonColor = false }, surface)
        icon(dismiss, "close", UDim2.fromOffset(-1, -1), muted)
        local progress = frame(surface, UDim2.fromOffset(16, 78), UDim2.fromOffset(toastWidth - 32, 2), accent, 0.15, 1)
        local entry = { host = host, surface = surface }
        visibleToasts[#visibleToasts + 1] = entry
        dismiss.Activated:Connect(function() removeToast(entry) end)
        tween(surface, { GroupTransparency = 0 }, 0.3)
        local progressTween = TweenService:Create(progress, TweenInfo.new(data.duration, Enum.EasingStyle.Linear), { Size = UDim2.fromOffset(0, 2) })
        progressTween:Play()
        task.delay(data.duration, function() if alive then removeToast(entry) end end)
    end
    arrange()
end
notify = function(title, message, duration)
    if not alive or not notifyEnabled then return end
    if #pending >= 24 then table.remove(pending, 1) end
    I.pulseUntil = os.clock() + 0.7
    pending[#pending + 1] = { title = tostring(title), message = tostring(message), duration = math.clamp(tonumber(duration) or 4, 2, 12) }
    pump()
end

M.env = shared
pcall(function() M.env = getgenv() end)
if type(M.env) ~= "table" then M.env = shared end
M.request = M.env.request or M.env.http_request or request or http_request
if not M.request and type(M.env.syn) == "table" then M.request = M.env.syn.request end
if not M.request and type(syn) == "table" then M.request = syn.request end
M.write = M.env.writefile or writefile
M.mkdir = M.env.makefolder or makefolder
M.isdir = M.env.isfolder or isfolder
M.asset = M.env.getcustomasset or M.env.getsynasset or getcustomasset or getsynasset
M.version, M.searchVersion, M.loading, M.playing = 0, 0, false, false
M.queue, M.index, M.coverVersion = {}, 0, 0
M.duration, M.position, M.name, M.artist = 0, 0, "", ""
M.sound = make("Sound", { Name = "LumaLocalMusic", Volume = Config.Volume }, SoundService)
M.assetCache = {}
M.http = function(url, binary, method, body)
    if not alive then error("界面已关闭", 0) end
    if type(M.request) == "function" then
        local options = { Url = url, Method = method or "GET", Headers = {
            ["Referer"] = "https://music.163.com/", ["Accept"] = binary and "*/*" or "application/json, text/plain, */*",
            ["User-Agent"] = "Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 Chrome/120.0.0.0 Mobile Safari/537.36",
        } }
        if body then options.Body = body; options.Headers["Content-Type"] = "application/x-www-form-urlencoded" end
        local ok, response = pcall(M.request, options)
        local status = ok and type(response) == "table" and tonumber(response.StatusCode or response.Status)
        local content = ok and type(response) == "table" and (response.Body or response.body)
        if (not status or status >= 200 and status < 300) and type(content) == "string" and #content > 0 then return content end
        if not method or method == "GET" then
            local fallbackOK, fallbackBody = pcall(function() return game:HttpGet(url) end)
            if fallbackOK and type(fallbackBody) == "string" and #fallbackBody > 0 then return fallbackBody end
        end
        error(status and ("HTTP " .. status) or (ok and "HTTP 返回格式异常" or tostring(response)), 0)
    end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and #body > 0 then return body end
    error(binary and "当前环境未提供音频下载能力" or "当前环境未提供 HTTP 请求能力", 0)
end
M.json = function(path, method, payload)
    local url = path:match("^https://") and path or (Config.MusicApi:gsub("/$", "") .. path)
    local body = M.http(url, false, method, payload)
    local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok or type(data) ~= "table" then error("网易云返回了非 JSON 内容", 0) end
    if data.code and tonumber(data.code) ~= 200 then error("网易云接口状态 " .. tostring(data.code) .. (data.message and (" · " .. tostring(data.message)) or ""), 0) end
    return data
end
M.prepareFolder = function()
    if M.folder then return end
    if type(M.write) ~= "function" or type(M.asset) ~= "function" then error("当前注入器需要支持 writefile 与 getcustomasset 才能播放网易云音频", 0) end
    if type(M.isdir) == "function" and M.isdir(Config.CacheFolder) then M.folder = Config.CacheFolder; return end
    if type(M.mkdir) == "function" then
        local ok = pcall(M.mkdir, Config.CacheFolder)
        if ok or (type(M.isdir) == "function" and M.isdir(Config.CacheFolder)) then M.folder = Config.CacheFolder; return end
    end
    M.folder = ""
end
M.save = function(name, body)
    M.prepareFolder()
    local path = (M.folder ~= "" and M.folder .. "/" or "LumaMusic-") .. name
    M.write(path, body)
    return M.asset(path)
end
M.normalize = function(song)
    local artists = {}
    for _, artist in ipairs(song.artists or song.ar or {}) do artists[#artists + 1] = artist.name or "" end
    local album = song.album or song.al or {}
    return { id = tostring(song.id), name = song.name or "未命名歌曲", artist = table.concat(artists, " / "),
        cover = album.picUrl or album.blurPicUrl, duration = (song.duration or song.dt or 0) / 1000 }
end
M.time = function(seconds)
    seconds = math.max(0, math.floor(seconds or 0))
    return string.format("%d:%02d", math.floor(seconds / 60), seconds % 60)
end
text(music.surface, "NETEASE MUSIC", UDim2.fromOffset(20, 18), UDim2.fromOffset(220, 22), 10, muted, true)
icon(music.surface, "music", UDim2.fromOffset(247, 17), accent)
M.art = glass(music.surface, UDim2.fromOffset(20, 54), UDim2.fromOffset(252, 126), 16)
M.art.ClipsDescendants = true
M.coverImage = make("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = "", ScaleType = Enum.ScaleType.Crop, ImageTransparency = 0.18 }, M.art)
round(M.coverImage, 16)
M.fallback = text(M.art, "LUMA / MUSIC", UDim2.fromOffset(20, 34), UDim2.fromOffset(212, 44), 23, white, true)
M.fallback.TextXAlignment = Enum.TextXAlignment.Center
M.wave = {}
for i = 1, 10 do
    local b = frame(M.art, UDim2.fromOffset(24 + (i - 1) * 23, 112), UDim2.fromOffset(3, 5), white, 0.2, 2)
    b.AnchorPoint = Vector2.new(0.5, 1); M.wave[i] = b
end
M.title = text(music.surface, "你的网易云音乐", UDim2.fromOffset(20, 193), UDim2.fromOffset(252, 26), 18, white, true)
M.subtitle = text(music.surface, "搜索歌名、歌手或粘贴歌曲链接", UDim2.fromOffset(20, 222), UDim2.fromOffset(252, 20), 11, muted)
M.input = box(music.surface, "歌名 / 歌手 / 网易云链接", UDim2.fromOffset(20, 258), UDim2.fromOffset(185, 35))
M.searchButton = button(music.surface, "搜索", UDim2.fromOffset(213, 258), UDim2.fromOffset(59, 35), true)
M.status = text(music.surface, "网易云音乐 / 等待选择歌曲", UDim2.fromOffset(20, 304), UDim2.fromOffset(252, 22), 10, muted)
M.seek = make("TextButton", { Position = UDim2.fromOffset(20, 335), Size = UDim2.fromOffset(252, 22), BackgroundTransparency = 1, Text = "", AutoButtonColor = false }, music.surface)
frame(M.seek, UDim2.fromOffset(0, 10), UDim2.fromOffset(252, 3), white, 0.8, 2)
M.seekFill = frame(M.seek, UDim2.fromOffset(0, 10), UDim2.fromOffset(0, 3), white, 0, 2)
M.currentTime = text(music.surface, "0:00", UDim2.fromOffset(20, 362), UDim2.fromOffset(100, 18), 10, muted)
M.totalTime = text(music.surface, "0:00", UDim2.fromOffset(182, 362), UDim2.fromOffset(90, 18), 10, muted)
M.totalTime.TextXAlignment = Enum.TextXAlignment.Right
M.back = button(music.surface, "", UDim2.fromOffset(55, 394), UDim2.fromOffset(38, 40))
icon(M.back, "back", UDim2.fromOffset(7, 8), muted)
M.play = button(music.surface, "", UDim2.fromOffset(119, 390), UDim2.fromOffset(54, 48), true)
M.next = button(music.surface, "", UDim2.fromOffset(199, 394), UDim2.fromOffset(38, 40))
icon(M.next, "next", UDim2.fromOffset(7, 8), muted)
M.looping = false
M.loop = button(music.surface, "单曲循环 · 关", UDim2.fromOffset(83, 442), UDim2.fromOffset(126, 24))
M.loop.Name = "RepeatTrack"
M.loop.TextSize = 10
bind(M.loop.Activated, function()
    M.looping = not M.looping
    M.sound.Looped = M.looping
    M.loop.Text = M.looping and "单曲循环 · 开" or "单曲循环 · 关"
    tween(M.loop, { BackgroundColor3 = M.looping and white or glassColor,
        TextColor3 = M.looping and Color3.fromRGB(18, 18, 18) or white,
        BackgroundTransparency = M.looping and 0.05 or 0.32 }, 0.22)
end)
M.volumeText = text(music.surface, "VOL  " .. math.floor(Config.Volume * 100) .. "%", UDim2.fromOffset(20, 470), UDim2.fromOffset(70, 18), 10, muted)
M.volume = make("TextButton", { Position = UDim2.fromOffset(96, 464), Size = UDim2.fromOffset(176, 28), Text = "", BackgroundTransparency = 1, AutoButtonColor = false }, music.surface)
frame(M.volume, UDim2.fromOffset(0, 12), UDim2.fromOffset(176, 3), white, 0.8, 2)
M.volumeFill = frame(M.volume, UDim2.fromOffset(0, 12), UDim2.fromOffset(176 * Config.Volume, 3), white, 0.15, 2)
M.results = glass(music.surface, UDim2.fromOffset(12, 50), UDim2.fromOffset(268, 402), 18)
M.results.BackgroundTransparency, M.results.Visible, M.results.ZIndex = 0.01, false, 5
text(M.results, "搜索结果", UDim2.fromOffset(12, 10), UDim2.fromOffset(192, 24), 14, white, true)
M.dismissResults = button(M.results, "关闭", UDim2.fromOffset(208, 9), UDim2.fromOffset(48, 26))
M.resultList = make("ScrollingFrame", { Position = UDim2.fromOffset(8, 46), Size = UDim2.fromOffset(252, 345), BackgroundTransparency = 1,
    BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = white, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y }, M.results)
make("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, M.resultList)
bind(M.dismissResults.Activated, function() M.results.Visible = false end)
I.refresh = function()
    local target = I.expanded and I.hasTrack and Vector2.new(306, 145) or (I.hasTrack and Vector2.new(220, 34) or Vector2.new(164, 28))
    tween(I.width, { Value = target.X }, 0.46, Enum.EasingStyle.Quint)
    tween(I.height, { Value = target.Y }, 0.46, Enum.EasingStyle.Quint)
    tween(I.corner, { CornerRadius = UDim.new(0, I.expanded and 23 or (I.hasTrack and 17 or 14)) }, 0.38)
    I.idle.Visible = not I.hasTrack
    I.compact.Visible = I.hasTrack and not I.expanded
    I.detail.Visible = I.hasTrack and I.expanded
    tween(I.detail, { GroupTransparency = I.expanded and 0 or 1 }, 0.24)
end
M.update = function()
    M.playing = M.sound.IsPlaying
    if M.playIcon then M.playIcon:Destroy() end
    if I.playIcon then I.playIcon:Destroy() end
    M.playIcon = icon(M.play, M.playing and "pause" or "play", UDim2.fromOffset(15, 12), Color3.fromRGB(18, 18, 18))
    I.playIcon = icon(I.play, M.playing and "pause" or "play", UDim2.fromOffset(10, 6), Color3.fromRGB(18, 18, 18))
    I.hasTrack = M.loaded == true
    I.miniTitle.Text, I.title.Text = M.name, M.name
    I.miniArtist.Text = M.loading and "载入中" or (M.playing and M.artist or "已暂停 · " .. M.artist)
    I.artist.Text = M.artist
    I.refresh()
end
M.cover = function(url, version)
    if not url or type(M.write) ~= "function" or type(M.asset) ~= "function" then return end
    task.spawn(function()
        local ok, asset = pcall(function()
            local bytes = M.http(url:gsub("^http:", "https:") .. (url:find("?", 1, true) and "&" or "?") .. "param=256y256", true)
            local extension = bytes:sub(1, 8) == "\137PNG\13\10\26\10" and "png" or "jpg"
            if bytes:sub(1, 2) ~= "\255\216" and extension ~= "png" then error("封面格式无效", 0) end
            if not alive or version ~= M.version then return nil end
            return M.save("cover-" .. tostring(version) .. "." .. extension, bytes)
        end)
        if alive and version == M.version and ok and asset then
            M.coverImage.Image, I.miniCover.Image, I.cover.Image = asset, asset, asset
            M.fallback.Visible, I.miniFallback.Visible, I.fallback.Visible = false, false, false
        end
    end)
end
M.playSong = function(song, index)
    M.version = M.version + 1
    local version = M.version
    if index then M.index = index end
    M.loading, M.loaded, M.wants, M.ended = true, false, true, false
    I.expanded = false
    M.sound:Stop()
    M.name, M.artist, M.duration = song.name or "网易云歌曲", song.artist or "", song.duration or 0
    M.title.Text, M.subtitle.Text, M.status.Text = M.name, M.artist, "正在获取歌曲信息…"
    M.coverImage.Image, I.miniCover.Image, I.cover.Image = "", "", ""
    M.fallback.Visible, I.miniFallback.Visible, I.fallback.Visible = true, true, true
    M.results.Visible = false
    M.update()
    task.spawn(function()
        local ok, err = pcall(function()
            M.prepareFolder()
            local detail = M.json("/api/song/detail/?id=" .. song.id .. "&ids=%5B" .. song.id .. "%5D")
            if not alive or version ~= M.version then return end
            if detail.songs and detail.songs[1] then song = M.normalize(detail.songs[1]) end
            M.name, M.artist, M.duration = song.name, song.artist, song.duration
            M.title.Text, M.subtitle.Text = M.name, M.artist
            M.cover(song.cover, version)
            M.status.Text = "正在获取可播放音源…"
            local data = M.json("/api/song/enhance/player/url?ids=%5B" .. song.id .. "%5D&br=128000")
            if not alive or version ~= M.version then return end
            local entry = data.data and data.data[1]
            if not entry or not entry.url or entry.url == "" then error("该歌曲暂未提供可播放音源", 0) end
            M.status.Text = "正在下载音频…"
            local asset = M.assetCache[song.id]
            if not asset then
                local bytes = M.http(entry.url:gsub("^http:", "https:"), true)
                if not alive or version ~= M.version then return end
                local first, second = bytes:byte(1, 2)
                if #bytes < 1024 or not (bytes:sub(1, 3) == "ID3" or (first == 255 and second and second >= 224)) then error("音源未返回有效 MP3", 0) end
                asset = M.save("song-" .. song.id .. ".mp3", bytes)
                M.assetCache[song.id] = asset
            end
            if not alive or version ~= M.version then return end
            M.sound.SoundId = asset
            M.status.Text = "正在准备本地播放…"
            local waited = 0
            while alive and version == M.version and not M.sound.IsLoaded and waited < 15 do waited = waited + task.wait(0.1) end
            if not alive or version ~= M.version then return end
            if not M.sound.IsLoaded then error("本地音频载入超时，请确认注入器支持 MP3 资源", 0) end
            M.loading, M.loaded = false, true
            M.sound:Play()
            if not M.wants then M.sound:Pause() end
            M.status.Text = M.wants and "网易云音乐 · 正在播放" or "已暂停"
            M.update()
        end)
        if not ok and alive and version == M.version then
            M.loading, M.loaded, M.wants = false, false, false
            M.status.Text = tostring(err)
            notify("音乐暂未播放", tostring(err), 6)
            M.update()
        end
    end)
end
M.renderResults = function(songs)
    for _, child in ipairs(M.resultList:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
    M.queue = songs
    M.index = 0
    for i, song in ipairs(songs) do
        local row = button(M.resultList, "", UDim2.new(), UDim2.fromOffset(244, 56))
        row.LayoutOrder = i
        text(row, song.name, UDim2.fromOffset(10, 6), UDim2.fromOffset(222, 23), 12, white, true)
        text(row, song.artist, UDim2.fromOffset(10, 31), UDim2.fromOffset(222, 18), 10, muted)
        row.Activated:Connect(function() M.playSong(song, i) end)
    end
    M.results.Visible = true
end
M.load = function(value)
    local query = tostring(value):match("^%s*(.-)%s*$")
    if query == "" then notify("搜索音乐", "请输入歌名、歌手、歌曲 ID 或网易云歌曲链接。"); return end
    M.searchVersion = M.searchVersion + 1
    local version = M.searchVersion
    local id = query:match("^%d+$") or query:match("[?&]id=(%d+)") or query:match("/song/(%d+)")
    if id then
        M.searchButton.Text = "搜索"
        M.queue = { { id = id, name = "网易云 / " .. id, artist = "" } }
        M.playSong(M.queue[1], 1)
        return
    end
    M.searchButton.Text, M.status.Text = "搜索中", "正在搜索网易云…"
    task.spawn(function()
        local ok, result = pcall(function()
            local params = "s=" .. HttpService:UrlEncode(query) .. "&type=1&offset=0&limit=15&total=true"
            local candidates = {
                { "/api/search/get?" .. params },
                { "/api/cloudsearch/pc?" .. params },
                { "/api/search/get/web?" .. params },
                { "/api/search/get", "POST", params },
            }
            local lastError
            for attempt, candidate in ipairs(candidates) do
                if not alive or version ~= M.searchVersion then return {} end
                M.status.Text = attempt == 1 and "正在搜索网易云…" or ("正在重试搜索 " .. attempt .. "/" .. #candidates)
                local success, data = pcall(M.json, candidate[1], candidate[2], candidate[3])
                if success then
                    local source = data.result and data.result.songs
                    if type(source) == "table" then
                        local songs = {}
                        for _, song in ipairs(source) do songs[#songs + 1] = M.normalize(song) end
                        return songs
                    end
                    if data.result and tonumber(data.result.songCount) == 0 then return {} end
                    lastError = "搜索接口未返回歌曲列表"
                else lastError = tostring(data) end
                if attempt < #candidates then task.wait(0.25) end
            end
            error("搜索请求未成功：" .. tostring(lastError), 0)
        end)
        if not alive or version ~= M.searchVersion then return end
        M.searchButton.Text = "搜索"
        if ok and #result > 0 then M.renderResults(result); M.status.Text = "找到 " .. #result .. " 首歌曲，点击播放"
        elseif ok then M.status.Text = "没有找到歌曲，请换个关键词"
        else M.status.Text = "搜索失败"; notify("网易云搜索失败", tostring(result), 5) end
    end)
end
M.toggle = function()
    if M.loading then
        M.wants = not M.wants
        M.status.Text = M.wants and "载入完成后播放" or "载入完成后暂停"
        return
    end
    if not M.loaded then M.load(M.input.Text); return end
    if M.sound.IsPlaying then M.sound:Pause(); M.wants = false; M.status.Text = "已暂停"
    else
        if M.sound.TimePosition >= math.max(0, M.sound.TimeLength - 0.1) then M.sound.TimePosition = 0 end
        if M.ended then M.sound:Play(); M.ended = false else M.sound:Resume() end
        M.wants = true; M.status.Text = "网易云音乐 · 正在播放"
    end
    M.update()
end
M.step = function(delta)
    if #M.queue == 0 then notify("播放列表为空", "先搜索并选择一首歌。"); return end
    local index = ((math.max(1, M.index) - 1 + delta) % #M.queue) + 1
    M.playSong(M.queue[index], index)
end
bind(M.searchButton.Activated, function() M.load(M.input.Text) end)
bind(M.input.FocusLost, function(enter) if enter then M.load(M.input.Text) end end)
bind(M.play.Activated, M.toggle)
bind(I.play.Activated, M.toggle)
bind(M.back.Activated, function() M.step(-1) end)
bind(I.back.Activated, function() M.step(-1) end)
bind(M.next.Activated, function() M.step(1) end)
bind(I.next.Activated, function() M.step(1) end)
bind(M.sound.Ended, function()
    if not M.loaded then return end
    if M.looping then
        M.sound.TimePosition = 0
        M.sound:Play()
        M.wants, M.ended = true, false
        M.status.Text = "网易云音乐 · 单曲循环"
        M.update()
    elseif #M.queue > 1 then M.step(1)
    else M.wants, M.ended = false, true; M.status.Text = "播放结束"; M.update() end
end)
local function sliderUpdate(input)
    if not sliding then return end
    local bar = sliding.bar
    local ratio = math.clamp((input.Position.X - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
    if bar == M.volume then
        M.sound.Volume = ratio
        M.volumeFill.Size = UDim2.fromOffset(176 * ratio, 3)
        M.volumeText.Text = "VOL  " .. math.floor(ratio * 100 + 0.5) .. "%"
    elseif M.loaded and M.sound.TimeLength > 0 then
        M.sound.TimePosition = ratio * math.max(0, M.sound.TimeLength - 0.05)
    end
end
for _, bar in ipairs({ M.seek, M.volume, I.seek }) do
    bind(bar.InputBegan, function(input)
        if drag then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = { bar = bar, input = input }; sliderUpdate(input)
        end
    end)
end
M.tick = function(dt, phase)
    if not M.loaded then M.position = 0 else M.position = M.sound.TimePosition end
    local duration = M.loaded and M.sound.TimeLength > 0 and M.sound.TimeLength or M.duration
    local ratio = duration > 0 and math.clamp(M.position / duration, 0, 1) or 0
    M.seekFill.Size, I.seekFill.Size = UDim2.fromOffset(252 * ratio, 3), UDim2.fromOffset(324 * ratio, 3)
    M.currentTime.Text, I.time.Text = M.time(M.position), M.time(M.position)
    M.totalTime.Text, I.duration.Text = M.time(duration), M.time(duration)
    for i, b in ipairs(I.bars) do
        local h = M.playing and (5 + (math.sin(phase * 4 + i * 1.7) + 1) * 5 + math.min(M.sound.PlaybackLoudness / 180, 5)) or 4
        b.Size = UDim2.fromOffset(2, reduced and 7 or h)
    end
    if music.surface.Visible then
        for i, b in ipairs(M.wave) do
            local h = M.playing and (7 + (math.sin(phase * 3 + i * 1.8) + 1) * 10 + math.min(M.sound.PlaybackLoudness / 80, 12)) or 4
            b.Size = UDim2.fromOffset(3, reduced and 6 or h)
        end
    end
end
M.destroy = function()
    M.version, M.searchVersion = M.version + 1, M.searchVersion + 1
    M.sound:Destroy()
end
M.update()

dock.surface.BackgroundTransparency = 0.1
D.marker = glass(dock.surface, UDim2.fromOffset(42, 9), UDim2.fromOffset(46, 44), 17)
D.marker.Name = "SlidingDockSelection"
D.marker.BackgroundColor3, D.marker.BackgroundTransparency = Color3.fromRGB(4, 4, 4), 0.05
D.marker.ZIndex = 1
D.select = function(index)
    D.selected = index
    tween(D.marker, { BackgroundTransparency = index > 0 and 0.05 or 1 }, 0.2)
    local border = D.marker:FindFirstChildOfClass("UIStroke")
    if border then tween(border, { Transparency = index > 0 and 0.55 or 1 }, 0.2) end
    if index > 0 then tween(D.marker, { Position = UDim2.fromOffset(42 + (index - 1) * 51, 9) }, 0.36) end
    for i, entry in ipairs(D.buttons) do
        tween(entry.scale, { Scale = i == index and 1.06 or 1 }, 0.3)
        for _, shape in ipairs(entry.icon:GetDescendants()) do
            if shape:IsA("Frame") then tween(shape, { BackgroundColor3 = i == index and white or muted }, 0.25) end
        end
    end
end
local quickKinds = { "home", "grid", "music", "bell", "minus" }
for i = 1, 5 do
    local b = make("TextButton", { Name = "DockItem" .. i, Text = "", AutoButtonColor = false,
        BackgroundTransparency = 1, Position = UDim2.fromOffset(42 + (i - 1) * 51, 9),
        Size = UDim2.fromOffset(46, 44), ZIndex = 2 }, dock.surface)
    local glyph = icon(b, quickKinds[i], UDim2.fromOffset(11, 10), i == 1 and white or muted)
    local glyphScale = make("UIScale", { Scale = 1 }, glyph)
    D.buttons[i] = { icon = glyph, scale = glyphScale }
    bind(b.MouseEnter, function() tween(glyphScale, { Scale = 1.1 }, 0.18) end)
    bind(b.MouseLeave, function() tween(glyphScale, { Scale = D.selected == i and 1.06 or 1 }, 0.22) end)
    bind(b.Activated, function()
        D.select(i)
        if i == 1 then selectPage(1)
        elseif i == 2 then selectPage(2)
        elseif i == 3 then
            playerEnabled = true; music.surface.Visible = opened
            tween(music.surface, { GroupTransparency = 0, Position = UDim2.new() }, 0.25)
            tween(music.anim, { Scale = 1 }, 0.25)
        elseif i == 4 then notify("轻轻一触，即刻回应", "分离式工作区，始终保持你的节奏。")
        else setOpen(false) end
    end)
end

setOpen = function(value)
    if not alive then return end
    opened = value
    transition = transition + 1
    local version = transition
    drag, sliding = nil, nil
    for _, item in ipairs(components) do
        local enabled = item ~= music or playerEnabled
        if item == dock then enabled = dockEnabled end
        if value and enabled then item.surface.Visible = true end
        tween(item.surface, { GroupTransparency = value and 0 or 1, Position = UDim2.fromOffset(0, value and 0 or 12) }, 0.3)
        tween(item.anim, { Scale = value and 1 or 0.94 }, 0.35)
    end
    I.status.Text = value and "收起" or "展开"
    I.pulseUntil = os.clock() + 0.7
    I.refresh()
    task.delay(reduced and 0 or 0.36, function()
        if not alive or version ~= transition then return end
        for _, item in ipairs(components) do
            item.surface.Visible = opened and (item ~= music or playerEnabled) and (item ~= dock or dockEnabled)
        end
    end)
end
bind(minimize.Activated, function() setOpen(false) end)
bind(close.Activated, function() setOpen(false) end)
bind(island.Activated, function()
    if os.clock() <= suppressUntil then return end
    if I.hasTrack then I.expanded = not I.expanded; I.refresh() else setOpen(not opened) end
end)
bind(island.InputBegan, function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    I.holdSerial = I.holdSerial + 1
    local serial = I.holdSerial
    task.delay(0.45, function()
        if alive and serial == I.holdSerial and I.hasTrack then
            suppressUntil = os.clock() + 0.5
            I.expanded = true; I.refresh()
        end
    end)
end)
bind(island.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then I.holdSerial = I.holdSerial + 1 end
end)
bind(I.window.Activated, function() setOpen(not opened); I.expanded = false; I.refresh() end)
bind(showToast.Activated, function()
    notify("一切就绪", "欢迎来到 LUMA，你的轻盈工作区。")
    notify("自由摆放", "拖动各面板顶部，组合喜欢的布局。")
    notify("通知自动排列", "更多消息会排队等待，依次显示。")
    notify("排队消息", "每条消息都有自己的显示位置。")
end)
local function clampItem(item, x, y)
    local w, h = screen.AbsoluteSize.X, screen.AbsoluteSize.Y
    return math.clamp(x, 6, math.max(6, w - item.w * item.scale - 6)), math.clamp(y, 40, math.max(40, h - item.h * item.scale - 6))
end
local function resetLayout()
    layout(true)
end
bind(resetButton.Activated, function() resetLayout(); notify("布局已恢复", "所有面板已回到初始位置。") end)
bind(restore.Activated, function() resetLayout(); notify("布局已恢复", "所有面板已回到初始位置。") end)
layout = function(first)
    local size = screen.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then return end
    scaleValue, fit.Scale = 1, 1
    stage.Position, stage.Size = UDim2.new(), UDim2.fromScale(1, 1)
    local portrait = size.Y > size.X
    local mainScale = math.max(0.1, math.min(Config.DefaultScale, (size.X - 24) / (portrait and 680 or 950), (size.Y - 92) / 398) * Config.WindowScale)
    local musicScale = math.max(0.1, math.min(mainScale, (size.Y - 72) / 510))
    if portrait then musicScale = math.min(mainScale, math.max(0.25, (size.Y - 110 - 398 * mainScale) / 510)) end
    main.scale, nav.scale, music.scale, dock.scale = mainScale, mainScale, musicScale, mainScale
    local totalWidth = 76 * mainScale + 12 + 580 * mainScale + 12 + 292 * musicScale
    local left = portrait and 8 or math.max(8, (size.X - totalWidth) / 2)
    local top = 52 + math.max(0, (size.Y - 92 - 398 * mainScale) / 2)
    if portrait then top = 62 end
    local positions = {
        [nav] = Vector2.new(left, top),
        [main] = Vector2.new(left + 76 * mainScale + 12, top),
        [music] = portrait and Vector2.new(size.X - 292 * musicScale - 10, top + 398 * mainScale + 14)
            or Vector2.new(left + 656 * mainScale + 24, math.max(48, (size.Y - 510 * musicScale) / 2)),
        [dock] = Vector2.new(left + 76 * mainScale + 12 + 132 * mainScale, size.Y - 62 * mainScale - 6),
    }
    for _, item in ipairs(components) do
        item.fit.Scale = item.scale
        if first then item.x, item.y = positions[item].X, positions[item].Y end
        item.x, item.y = clampItem(item, item.x, item.y)
        item.host.Position = UDim2.fromOffset(item.x, item.y)
    end
    I.scale.Scale = math.min(1, (size.X - 20) / 306)
    toastScale.Scale = math.min(1, math.max(0.45, (size.X - 20) / 310))
    local newCapacity = math.clamp(math.floor((size.Y / toastScale.Scale - 20) / 96), 1, 3)
    toastCapacity = newCapacity
    while #visibleToasts > toastCapacity do
        local entry = table.remove(visibleToasts)
        entry.leaving = true
        entry.host:Destroy()
    end
    arrange(); pump()
end
bind(screen:GetPropertyChangedSignal("AbsoluteSize"), function() layout(false) end)
bind(Input.InputChanged, function(i)
    if drag and (i == drag.input or (drag.input.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseMovement)) then
        local delta = Vector2.new(i.Position.X, i.Position.Y) - drag.start
        if delta.Magnitude > 6 then drag.moved = true; suppressUntil = os.clock() + 0.25 end
        if drag.moved then
            local item = drag.item
            drag.goal = drag.origin + delta / scaleValue
            item.x, item.y = clampItem(item, drag.goal.X, drag.goal.Y)
            drag.goal = Vector2.new(item.x, item.y)
        end
    end
    if sliding and (i == sliding.input or (sliding.input.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseMovement)) then sliderUpdate(i) end
end)
bind(Input.InputEnded, function(i)
    if drag and i == drag.input then
        if drag.moved then suppressUntil = os.clock() + 0.25 end
        if drag.goal then drag.item.host.Position = UDim2.fromOffset(drag.item.x, drag.item.y) end
        drag = nil
    end
    if sliding and i == sliding.input then sliding = nil end
end)
bind(Input.WindowFocusReleased, function() drag, sliding = nil, nil end)
bind(Input.InputBegan, function(i, processed)
    if not processed and not Input:GetFocusedTextBox() and i.KeyCode == Config.ToggleKey then setOpen(not opened) end
end)
local elapsed, frames, audioTick, phase = 0, 0, 0, 0
bind(RunService.RenderStepped, function(dt)
    local pulse = math.max(0, I.pulseUntil - os.clock())
    local breath = reduced and 0 or (math.sin(os.clock() * 1.8) + 1) * 1.2
    island.Size = UDim2.fromOffset(I.width.Value + (I.hasTrack and 0 or breath) + pulse * 12, I.height.Value)
    for i, bar in ipairs(I.idleBars) do
        local height = reduced and 7 or (5 + (math.sin(os.clock() * 3.2 + i * 1.3) + 1) * 3)
        bar.Size = UDim2.fromOffset(2, height)
    end
    if drag and drag.goal then
        local item = drag.item
        local target = UDim2.fromOffset(drag.goal.X, drag.goal.Y)
        item.host.Position = item.host.Position:Lerp(target, reduced and 1 or (1 - math.exp(-32 * dt)))
    end
    elapsed, frames, audioTick = elapsed + dt, frames + 1, audioTick + dt
    if elapsed >= 0.75 then fpsText.Text = tostring(math.floor(frames / elapsed + 0.5)) .. " FPS"; elapsed, frames = 0, 0 end
    if audioTick >= 0.08 then
        audioTick = 0
        phase = phase + 0.16
        M.tick(dt, phase)
        islandDot.BackgroundTransparency = 0.12 + (math.sin(phase * 2) + 1) * 0.15
    end
end)
function API:Notify(title, message, duration) notify(title, message, duration) end
function API:SetOpen(value) setOpen(value == true) end
function API:SelectPage(index) if pages[index] then selectPage(index) end end
function API:PlayAudio(id) M.load(id) end
function API:ResetLayout() resetLayout() end
function API:Destroy()
    if not alive then return end
    alive = false
    State.Running = false
    uninstallHook()
    for _, c in ipairs(links) do c:Disconnect() end
    for _, channels in pairs(tweens) do for _, t in pairs(channels) do t:Cancel() end end
    tweens, pending, visibleToasts = {}, {}, {}
    M.destroy()
    gui:Destroy()
    if shared.LumaGlass == API then shared.LumaGlass = nil end
end
bind(shutdown.Event, function() API:Destroy() end)
bind(gui.Destroying, function() if alive then API:Destroy() end end)
shared.LumaGlass = API
layout(true)
for _, item in ipairs(components) do item.surface.GroupTransparency = 1; item.anim.Scale = 0.94 end
setOpen(true)
notify("LUMA / 黑白音乐版", "播放网易云歌曲后，灵动岛自动切换音乐状态。", 5)
installHook()
task.spawn(function() task.wait(0.9); scanAll() end)
task.spawn(queueWorker)

task.spawn(function()
    while alive and State.Running do
        task.wait(12)
        local ok, isAlive = pcall(hookAlive)
        if not ok or not isAlive then
            uninstallHook()
            pcall(installHook)
            State.rehook = State.rehook + 1
        end
    end
end)

task.spawn(function()
    while alive and State.Running do
        task.wait(3)
        if State.Auto and not State.Paused then
            pcall(scanAll)
        end
    end
end)

if Player then
    pcall(function()
        Player.CharacterAdded:Connect(function()
            task.wait(2)
            if alive and State.Running then pcall(scanAll) end
        end)
    end)
end

function API:Translate() return scanAll() end
function API:RestoreOriginal() return restoreOriginal() end
function API:SetTranslateLang(code) CONFIG.TargetLang = tostring(code); return scanAll() end
function API:TranslateStats()
    local pending = 0
    for _ in pairs(State.pending) do pending = pending + 1 end
    return {
        scanned = State.scanned, success = State.success, failures = State.failures,
        pending = pending, skipped = State.skipped, batched = State.batched,
        hooked = State.Hooked, rehook = State.rehook, lang = CONFIG.TargetLang,
    }
end

return API
