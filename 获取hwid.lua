local function tryGetRealHWID()
    -- 常见的执行器 HWID 接口名
    local candidates = {"gethwid", "get_hwid", "GetHWID", "syn", "fluxus"}
    
    for _, name in ipairs(candidates) do
        local ok, fn = pcall(function() return getgenv()[name] end)
        if ok then
            if type(fn) == "function" then
                local s, res = pcall(fn)
                if s and type(res) == "string" and res ~= "" then
                    return res, name
                end
            elseif type(fn) == "table" and fn.get_hwid then -- 兼容 syn.get_hwid
                local s, res = pcall(fn.get_hwid)
                if s and type(res) == "string" and res ~= "" then
                    return res, "syn.get_hwid"
                end
            end
        end
    end
    return nil
end

local hwid, src = tryGetRealHWID()
if hwid then
    print("✅ 成功获取到真实硬件 HWID:", hwid, "(通过 " .. src .. ")")
else
    warn("❌ 当前 Delta 版本/定制包未暴露获取硬件 HWID 的 API")
    print("（注：这很正常。如需 HWID，请直接看第三方工具界面，或用 ClientID 做软绑定）")
end
