
--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--// CONFIG
local KEYS_GIST_ID = "aad696ea538fb10d84f323e6ed436992"
local ACTIVATION_SERVER = "https://ymenu-bot.onrender.com" -- ЗАМЕНИ после деплоя на Render!

do
    local isAllowed = false
    local onlineCheckDone = false
    
    -- Check whitelist via raw.githubusercontent.com (works for public repos, no token needed)
    pcall(function()
        local raw = game:HttpGet("https://raw.githubusercontent.com/Ygariqi/YMenu/main/YMenu_Whitelist.txt?t=" .. tick() .. math.random(100000,999999))
        if raw and #raw > 0 and not raw:find("<!DOCTYPE") then
            onlineCheckDone = true
            for line in raw:gmatch("[^\r\n]+") do
                local t = line:match("^%s*(.-)%s*$")
                if t and t == player.Name then isAllowed = true; break end
            end
        end
    end)
    
    -- Fallback: local cache ONLY if online check failed (network error)
    if not isAllowed and not onlineCheckDone then
        pcall(function()
            if readfile and isfile then
                if isfile("YMenu_WL_" .. player.Name .. ".txt") then
                    local cached = readfile("YMenu_WL_" .. player.Name .. ".txt")
                    if cached == "ACTIVATED" then isAllowed = true end
                end
            end
        end)
    end
    
    -- Update local cache
    if isAllowed then
        pcall(function()
            if writefile then writefile("YMenu_WL_" .. player.Name .. ".txt", "ACTIVATED") end
        end)
    elseif onlineCheckDone then
        pcall(function()
            if delfile and isfile and isfile("YMenu_WL_" .. player.Name .. ".txt") then
                delfile("YMenu_WL_" .. player.Name .. ".txt")
            end
        end)
    end
    
    if not isAllowed then
        -- Show styled Access Denied window with key input
        local sg = Instance.new("ScreenGui"); sg.Name = "YMenu_AccessDenied"; sg.ResetOnSpawn = false; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() sg.Parent = game:GetService("CoreGui") end)
        if not sg.Parent then sg.Parent = player:WaitForChild("PlayerGui") end
        
        local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.new(0,0,0); bg.BackgroundTransparency = 0.4; bg.BorderSizePixel = 0; bg.Parent = sg
        
        local panel = Instance.new("Frame"); panel.Size = UDim2.new(0,480,0,370); panel.Position = UDim2.new(0.5,-240,0.5,-185)
        panel.BackgroundColor3 = Color3.fromRGB(18,15,35); panel.BorderSizePixel = 0; panel.Parent = sg
        local panelCorner = Instance.new("UICorner"); panelCorner.CornerRadius = UDim.new(0,14); panelCorner.Parent = panel
        local panelStroke = Instance.new("UIStroke"); panelStroke.Color = Color3.fromRGB(130,80,255); panelStroke.Thickness = 2; panelStroke.Transparency = 0.3; panelStroke.Parent = panel
        
        local strokeGrad = Instance.new("UIGradient"); strokeGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(130,80,255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100,50,200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(130,80,255))
        }); strokeGrad.Parent = panelStroke
        
        local icon = Instance.new("TextLabel"); icon.Size = UDim2.new(0,50,0,50); icon.Position = UDim2.new(0.5,-25,0,12)
        icon.BackgroundTransparency = 1; icon.Text = "🔑"; icon.TextSize = 36; icon.Font = Enum.Font.GothamBold; icon.Parent = panel
        
        local title = Instance.new("TextLabel"); title.Size = UDim2.new(1,-40,0,30); title.Position = UDim2.new(0,20,0,65)
        title.BackgroundTransparency = 1; title.Text = "ACTIVATE YMENU"; title.TextColor3 = Color3.fromRGB(200,170,255)
        title.TextSize = 22; title.Font = Enum.Font.GothamBold; title.Parent = panel
        
        local msg = Instance.new("TextLabel"); msg.Size = UDim2.new(1,-40,0,35); msg.Position = UDim2.new(0,20,0,100)
        msg.BackgroundTransparency = 1; msg.Text = "Enter your activation key to get access"
        msg.TextColor3 = Color3.fromRGB(140,140,170); msg.TextSize = 13; msg.Font = Enum.Font.Gotham; msg.TextWrapped = true; msg.Parent = panel
        
        local userLbl = Instance.new("TextLabel"); userLbl.Size = UDim2.new(1,-40,0,18); userLbl.Position = UDim2.new(0,20,0,138)
        userLbl.BackgroundTransparency = 1; userLbl.Text = "Username: " .. player.Name
        userLbl.TextColor3 = Color3.fromRGB(100,100,130); userLbl.TextSize = 11; userLbl.Font = Enum.Font.Gotham; userLbl.Parent = panel
        
        local keyInput = Instance.new("TextBox"); keyInput.Size = UDim2.new(1,-40,0,40); keyInput.Position = UDim2.new(0,20,0,165)
        keyInput.BackgroundColor3 = Color3.fromRGB(30,25,55); keyInput.Text = ""; keyInput.PlaceholderText = "YMENU-XXXXX-XXXXX-XXXXX"
        keyInput.TextColor3 = Color3.new(1,1,1); keyInput.PlaceholderColor3 = Color3.fromRGB(80,75,110)
        keyInput.TextSize = 14; keyInput.Font = Enum.Font.GothamBold; keyInput.BorderSizePixel = 0; keyInput.ClearTextOnFocus = false; keyInput.Parent = panel
        local inputCorner = Instance.new("UICorner"); inputCorner.CornerRadius = UDim.new(0,8); inputCorner.Parent = keyInput
        local inputStroke = Instance.new("UIStroke"); inputStroke.Color = Color3.fromRGB(60,50,100); inputStroke.Thickness = 1; inputStroke.Parent = keyInput
        
        local statusLbl = Instance.new("TextLabel"); statusLbl.Size = UDim2.new(1,-40,0,18); statusLbl.Position = UDim2.new(0,20,0,212)
        statusLbl.BackgroundTransparency = 1; statusLbl.Text = ""; statusLbl.TextColor3 = Color3.fromRGB(255,80,80)
        statusLbl.TextSize = 11; statusLbl.Font = Enum.Font.Gotham; statusLbl.Parent = panel
        
        local activateBtn = Instance.new("TextButton"); activateBtn.Size = UDim2.new(1,-40,0,38); activateBtn.Position = UDim2.new(0,20,0,240)
        activateBtn.BackgroundColor3 = Color3.fromRGB(100,60,200); activateBtn.Text = "⚡ ACTIVATE KEY"; activateBtn.TextColor3 = Color3.new(1,1,1)
        activateBtn.TextSize = 15; activateBtn.Font = Enum.Font.GothamBold; activateBtn.BorderSizePixel = 0; activateBtn.Parent = panel
        local actCorner = Instance.new("UICorner"); actCorner.CornerRadius = UDim.new(0,8); actCorner.Parent = activateBtn
        
        local closeBtn = Instance.new("TextButton"); closeBtn.Size = UDim2.new(1,-40,0,32); closeBtn.Position = UDim2.new(0,20,0,292)
        closeBtn.BackgroundColor3 = Color3.fromRGB(40,35,60); closeBtn.Text = "CLOSE"; closeBtn.TextColor3 = Color3.fromRGB(140,130,170)
        closeBtn.TextSize = 12; closeBtn.Font = Enum.Font.GothamBold; closeBtn.BorderSizePixel = 0; closeBtn.Parent = panel
        local clsCorner = Instance.new("UICorner"); clsCorner.CornerRadius = UDim.new(0,8); clsCorner.Parent = closeBtn
        closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
        
        -- KEY ACTIVATION LOGIC
        local activating = false
        activateBtn.MouseButton1Click:Connect(function()
            if activating then return end
            
            local key = keyInput.Text:match("^%s*(.-)%s*$")
            if not key or key == "" then
                statusLbl.Text = "⚠️ Please enter a key"; statusLbl.TextColor3 = Color3.fromRGB(255,100,100)
                return
            end
            
            activating = true
            activateBtn.Text = "⏳ Verifying..."; activateBtn.BackgroundColor3 = Color3.fromRGB(60,50,100)
            statusLbl.Text = "Checking key..."; statusLbl.TextColor3 = Color3.fromRGB(130,80,255)
            
            task.spawn(function()
                local ok, err = pcall(function()
                    -- 1. Read keys via game:HttpGet (reliable in executors)
                    local keysContent = game:HttpGet("https://gist.githubusercontent.com/Ygariqi/" .. KEYS_GIST_ID .. "/raw/YMenu_Keys.txt?t=" .. math.random(100000,999999))
                    
                    local validKeys = {}
                    local keyFound = false
                    for line in keysContent:gmatch("[^\r\n]+") do
                        local trimmed = line:match("^%s*(.-)%s*$")
                        if trimmed and trimmed ~= "" then
                            if trimmed == key then keyFound = true else table.insert(validKeys, trimmed) end
                        end
                    end
                    if not keyFound then error("INVALID_KEY") end
                    
                    statusLbl.Text = "Key valid! Processing..."
                    
                    -- 2. Send activation to server (Render or localhost fallback)
                    local activationUrl = ACTIVATION_SERVER .. "/activate?key=" .. HttpService:UrlEncode(key) .. "&user=" .. HttpService:UrlEncode(player.Name)
                    local serverOk = pcall(function()
                        local resp = game:HttpGet(activationUrl)
                        if resp and resp:find('"status"') and resp:find('"ok"') then
                            statusLbl.Text = "Activation processed!"
                        end
                    end)
                    -- Fallback: try localhost if Render failed
                    if not serverOk then
                        serverOk = pcall(function()
                            local resp = game:HttpGet("http://localhost:8765/activate?key=" .. HttpService:UrlEncode(key) .. "&user=" .. HttpService:UrlEncode(player.Name))
                            if resp and resp:find('"status"') and resp:find('"ok"') then
                                statusLbl.Text = "Activation processed!"
                            end
                        end)
                    end
                    
                    -- 3. If bot unavailable, show manual activation message
                    if not serverOk then
                        statusLbl.Text = "⚠️ Bot offline. Contact admin for manual activation."
                        statusLbl.TextColor3 = Color3.fromRGB(255,200,80)
                        error("BOT_OFFLINE")
                    end
                end)
                
                if ok then
                    statusLbl.Text = "✅ Activated! Loading menu..."; statusLbl.TextColor3 = Color3.fromRGB(50,200,100)
                    activateBtn.Text = "✅ SUCCESS"; activateBtn.BackgroundColor3 = Color3.fromRGB(30,150,70)
                    -- Save local cache so re-run won't ask again
                    pcall(function()
                        if writefile then
                            writefile("YMenu_WL_" .. player.Name .. ".txt", "ACTIVATED")
                        end
                    end)
                    task.wait(2)
                    sg:Destroy()
                    isAllowed = true
                else
                    activating = false
                    if err and tostring(err):find("INVALID_KEY") then
                        statusLbl.Text = "❌ Invalid key! Check and try again"; statusLbl.TextColor3 = Color3.fromRGB(255,80,80)
                    elseif err and tostring(err):find("BOT_OFFLINE") then
                        statusLbl.Text = "⚠️ Key valid but bot offline. Contact admin."; statusLbl.TextColor3 = Color3.fromRGB(255,200,80)
                    else
                        statusLbl.Text = "❌ Error: " .. tostring(err):sub(1,60); statusLbl.TextColor3 = Color3.fromRGB(255,80,80)
                    end
                    activateBtn.Text = "⚡ ACTIVATE KEY"; activateBtn.BackgroundColor3 = Color3.fromRGB(100,60,200)
                end
            end)
        end)
        -- Wait until user activates or closes the window
        repeat task.wait(0.5) until isAllowed or not sg.Parent
        if not isAllowed then return end
    end
end

--// V64: LOCALIZATION SYSTEM (INJECTED)
local currentLang = "ENG" -- Default
local LOCALES = {
    ["RU"] = {
        ["TITLE"] = "YMenu V1",
        ["SIDEBAR_CREDITS"] = "BIZZARE LINEAGE\nULTIMATE SCRIPT\nBY YGAR1",
        ["RAID_INFO"] = "ИНФОРМАЦИЯ О РЕЙДАХ:\n- Убедитесь, что у вас достаточно ОЗ.\n- Авто-рестарт работает после победы.\n\nВНИМАНИЕ: Авто-атака паузится, когда курсор над меню!",
        ["TAB_STAND"] = "Стенд",
        ["TAB_FARM"] = "Фарм",
        ["TAB_RAIDS"] = "Рейды",
        ["TAB_STATS"] = "Статы",
        ["TAB_ESP"] = "ESP",
        ["TAB_SETTINGS"] = "Настройки",
        ["AUTO_ARROW"] = "Авто использование стрел",
        ["STOP_WORTH"] = "Стоп если достойность 0",
        ["DESIRED_STAND"] = "Желаемый стенд:",
        ["PLACEHOLDER_STAND"] = "Введите стенд...",
        ["CURR_STAND"] = "Стенд: ",
        ["CURR_WORTH"] = "Достойность: ",
        ["SUB_ARROWS"] = "Стрелы",
        ["FARM_ARROWS"] = "Авто фарм стрел",
        ["SUB_QUESTS"] = "Квесты",
        ["AUTO_QUEST"] = "Авто квест",
        ["SELECT_BOSS"] = "Выбор босса",
        ["AUTO_RAID"] = "Авто рейд",
        ["AUTO_RESTART"] = "Авто рестарт",
        ["ADD_AMOUNT"] = "Добавить кол-во:",
        ["AUTO_STATS"] = "Авто добавление статов",
        ["TARGET_ATTR"] = "Целевые атрибуты:",
        ["LEVEL_TEXT"] = "Уровень: ",
        ["CONJ_TEXT"] = "Коньюрация: ",
        ["SP_TEXT"] = "Очки статов: ",
        ["TARGET_CAT"] = "Категории целей",
        ["ESP_ITEMS"] = "ESP Предметы",
        ["ESP_PEOPLE"] = "ESP Игроки",
        ["ESP_NPC"] = "ESP NPC",
        ["ESP_SETTINGS"] = "Настройки ESP",
        ["LANG_SWITCH"] = "Смена языка RU/ENG",
        ["AUTO_USE_KEYS"] = "Auto Use Keys",
        ["STAT_STR"] = "Сила",
        ["STAT_HP"] = "Здоровье",
        ["STAT_POW"] = "Энергия",
        ["STAT_WEP"] = "Оружие",
        ["STAT_DP"] = "Разрушительная сила",
        ["STAT_DE"] = "Разрушительная энергия",
        ["SUB_PRESTIGE"] = "Престиж",
        ["AUTO_PRESTIGE"] = "Авто престиж",
        ["PRESTIGE_TEXT"] = "Престиж: ",
        ["SUB_LVL_FARM"] = "Фарм Уровня",
        ["SELECT_LVL_FARM"] = "Выбор режима",
        ["AUTO_LVL_FARM"] = "Авто фарм уровня"
    },
    ["ENG"] = {
        ["TITLE"] = "YMenu V1",
        ["SIDEBAR_CREDITS"] = "BIZZARE LINEAGE\nULTIMATE SCRIPT\nBY YGAR1",
        ["RAID_INFO"] = "RAID INFORMATION:\n- Ensure your character has enough HP.\n- Auto-Restart works after boss defeat.\n\nWARNING: Auto-attack pauses while your cursor is over the menu to ensure UI responsiveness!",
        ["TAB_STAND"] = "Stand",
        ["TAB_FARM"] = "Farm",
        ["TAB_RAIDS"] = "Raids",
        ["TAB_STATS"] = "Stats",
        ["TAB_ESP"] = "ESP",
        ["TAB_SETTINGS"] = "Settings",
        ["AUTO_ARROW"] = "Auto use Arrows",
        ["STOP_WORTH"] = "Stop if Worthiness 0",
        ["DESIRED_STAND"] = "Desired Stand:",
        ["PLACEHOLDER_STAND"] = "Enter Stand...",
        ["CURR_STAND"] = "Stand: ",
        ["CURR_WORTH"] = "Worthiness: ",
        ["SUB_ARROWS"] = "Arrows",
        ["FARM_ARROWS"] = "Auto Farm Arrows",
        ["SUB_QUESTS"] = "Quests",
        ["AUTO_QUEST"] = "Auto Quest",
        ["SELECT_BOSS"] = "Select Raid Boss",
        ["AUTO_RAID"] = "Auto Raid",
        ["AUTO_RESTART"] = "Auto Restart",
        ["ADD_AMOUNT"] = "Add Amount:",
        ["AUTO_STATS"] = "Auto Add Stats",
        ["TARGET_ATTR"] = "Target Attributes:",
        ["LEVEL_TEXT"] = "Level: ",
        ["CONJ_TEXT"] = "Conjuration: ",
        ["SP_TEXT"] = "Stat Points: ",
        ["TARGET_CAT"] = "Target Categories",
        ["ESP_ITEMS"] = "ESP Items",
        ["ESP_PEOPLE"] = "ESP People",
        ["ESP_NPC"] = "ESP NPC",
        ["ESP_SETTINGS"] = "ESP Settings",
        ["LANG_SWITCH"] = "Change Language RU/ENG",
        ["AUTO_USE_KEYS"] = "Auto Use Keys",
        ["STAT_STR"] = "Strength",
        ["STAT_HP"] = "Health",
        ["STAT_POW"] = "Power",
        ["STAT_WEP"] = "Weapon",
        ["STAT_DP"] = "Destructive Power",
        ["STAT_DE"] = "Destructive Energy",
        ["SUB_PRESTIGE"] = "Prestige",
        ["AUTO_PRESTIGE"] = "Auto Prestige",
        ["PRESTIGE_TEXT"] = "Prestige: ",
        ["SUB_LVL_FARM"] = "Lvl Farm",
        ["SELECT_LVL_FARM"] = "Select Mode",
        ["AUTO_LVL_FARM"] = "Auto Lvl Farm"
    }
}

local function getLoc(key)
    local langData = LOCALES[currentLang]
    if langData and langData[key] then return langData[key] end
    return key
end

--// STATES
local autoArrow = false
local stopWorth0 = false
local autoFarm = false
local autoQuest = false
local autoRaid = false
local autoRestart = false
local autoAddStats = false
local autoPrestige = false
local autoLvlFarm = false
local selectedLvlFarm = "None"

-- ESP CATEGORIES
local espItems = false
local espPeople = false
local espNPC = false

-- ESP SETTINGS (V63)
local espHighlight = true
local espBox = false
local espName = false
local espHealth = false
local espDist = false

-- V64: AUTO-SKILL STATES
local autoSkills = {
    ["E"] = false, ["R"] = false, ["Z"] = false, ["X"] = false, ["C"] = false, ["V"] = false,
    ["1"] = false, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false,
    ["7"] = false, ["8"] = false, ["9"] = false
}

local spAmount = 1
local desiredStand = ""
local selectedRaidBoss = "None"
local isMinimized = false
local currentTarget = nil 
local targetCFrame = nil 
local isHoveringMenu = false 

-- Stat Targets
local statTargets = {
    ["Strength"] = 0,
    ["Health"] = 0,
    ["Power"] = 0,
    ["Weapon"] = 0,
    ["Destructive Power"] = 0,
    ["Destructive Energy"] = 0
}

-- MAPPING
local STAT_NAME_MAP = {
    ["Strength"] = "StrengthStat",
    ["Health"] = "DefenseStat",
    ["Power"] = "PowerStat",
    ["Weapon"] = "WeaponStat",
    ["Destructive Power"] = "DestructivePowerStat",
    ["Destructive Energy"] = "DestructiveEnergyStat"
}

-- BOSS MAPPING
local RAID_BOSSES = {
    ["Avdol"] = {TalkName = "Muhammad Avdol", BossName = "Muhammad Avdol"},
    ["Kira"] = {TalkName = "Yoshikage Kira", BossName = "Yoshikage Kira"},
    ["Jotaro"] = {TalkName = "Chumbo", BossName = "Jotaro Kujo"},
    ["Dio"] = {TalkName = "???", BossName = "DIO", TwoPhase = true}
}

--// GUI (RESTORED TO FULL VERBOSE STYLE)
local gui = Instance.new("ScreenGui")
gui.Name = "YMenu_V1_Premium"
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,550,0,450)
frame.Position = UDim2.new(0.5,-275,0.5,-225)
frame.BackgroundColor3 = Color3.fromRGB(14,16,24)
frame.Active = true
frame.ClipsDescendants = true
frame.ZIndex = 110
frame.Parent = gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0,14)
uiCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(60,40,120)
frameStroke.Thickness = 1.5
frameStroke.Transparency = 0.5
frameStroke.Parent = frame

-- SMART CLICKER HOVER DETECTION
frame.MouseEnter:Connect(function() 
    isHoveringMenu = true 
end)
frame.MouseLeave:Connect(function() 
    isHoveringMenu = false 
end)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,40)
topBar.BackgroundColor3 = Color3.fromRGB(18,20,30)
topBar.Active = true
topBar.ZIndex = 115
topBar.Parent = frame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0,14)
topBarCorner.Parent = topBar

-- ACCENT STRIPE (gradient line under topbar)
local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(1,0,0,2)
accentLine.Position = UDim2.new(0,0,1,-2)
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 116
accentLine.Parent = topBar
local accentGrad = Instance.new("UIGradient")
accentGrad.Color = ColorSequence.new(Color3.fromRGB(120,80,220), Color3.fromRGB(60,120,255))
accentGrad.Parent = accentLine

local topTitle = Instance.new("TextLabel")
topTitle.Size = UDim2.new(0,150,1,0)
topTitle.Position = UDim2.new(0,15,0,0)
topTitle.Text = getLoc("TITLE")
topTitle.TextSize = 18
topTitle.Font = Enum.Font.GothamBold
topTitle.BackgroundTransparency = 1
topTitle.TextColor3 = Color3.new(1,1,1)
topTitle.TextXAlignment = Enum.TextXAlignment.Left
topTitle.ZIndex = 120
topTitle.Parent = topBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-75,0,5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(45,47,55)
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.ZIndex = 125
minBtn.Parent = topBar

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0,6)
minBtnCorner.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.ZIndex = 125
closeBtn.Parent = topBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0,6)
closeBtnCorner.Parent = closeBtn

local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(1,0,1,-40)
mainContainer.Position = UDim2.new(0,0,0,40)
mainContainer.BackgroundTransparency = 1
mainContainer.ZIndex = 110
mainContainer.Parent = frame

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,140,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(10,12,20)
sidebar.ZIndex = 115
sidebar.Parent = mainContainer

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0,14)
sidebarCorner.Parent = sidebar

local sideGrad = Instance.new("UIGradient")
sideGrad.Color = ColorSequence.new(Color3.fromRGB(14,16,26), Color3.fromRGB(24,26,38))
sideGrad.Rotation = 90
sideGrad.Parent = sidebar

local sideCredits = Instance.new("TextLabel")
sideCredits.Size = UDim2.new(1,-10,0,60)
sideCredits.Position = UDim2.new(0,5,0,10)
sideCredits.BackgroundTransparency = 1
sideCredits.Text = getLoc("SIDEBAR_CREDITS")
sideCredits.TextColor3 = Color3.fromRGB(150,200,255)
sideCredits.TextSize = 13
sideCredits.Font = Enum.Font.GothamBold
sideCredits.ZIndex = 130
sideCredits.Parent = sidebar

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-140,1,0)
content.Position = UDim2.new(0,140,0,0)
content.BackgroundTransparency = 1
content.ZIndex = 112
content.Parent = mainContainer

-- TABS
local function createTab(name)
    local t = Instance.new("ScrollingFrame")
    t.Size = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.Visible = false
    t.CanvasSize = UDim2.new(0,0,0,1400) -- High for settings
    t.ScrollBarThickness = 0
    t.ZIndex = 115
    t.Parent = content
    return t
end

local standTab = createTab("Stand")
standTab.Visible = true

local farmTab = createTab("Farm")
local raidsTab = createTab("Raids")
local statsTab = createTab("Stats")
local espTab = createTab("ESP")
local settingsTab = createTab("Settings")

-- DRAG LOGIC
local dragging, dragInput, dragStart, startPos
local function updatePos(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false 
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then 
        dragInput = input 
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        dragging = false 
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then 
        updatePos(dragInput) 
    end
end)

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainContainer.Visible = not isMinimized
    frame:TweenSize(UDim2.new(0,550,0, isMinimized and 40 or 450), "Out", "Quad", 0.3, true)
    minBtn.Text = isMinimized and "+" or "-"
end)

closeBtn.MouseButton1Click:Connect(function() 
    gui:Destroy() 
end)

--// UI BINDING LIST
local updatableItems = {}

-- NAV BUTTONS
local activeNavBtn = nil
local function createNav(key, pos, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,38)
    b.Position = UDim2.new(0,10,0,pos)
    b.Text = getLoc(key)
    b.TextSize = 15
    b.BackgroundColor3 = Color3.fromRGB(58,60,82)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamSemibold
    b.ZIndex = 150
    b.AutoButtonColor = false
    b.Parent = sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = b

    -- Gradient overlay for active state
    local navGrad = Instance.new("UIGradient")
    navGrad.Color = ColorSequence.new(Color3.fromRGB(58,60,82), Color3.fromRGB(58,60,82))
    navGrad.Rotation = 0
    navGrad.Parent = b

    -- Left accent bar (thin, rounded, gradient-colored)
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0,3,0.5,0)
    accentBar.Position = UDim2.new(0,1,0.25,0)
    accentBar.BackgroundColor3 = Color3.fromRGB(130,80,255)
    accentBar.BorderSizePixel = 0
    accentBar.Visible = false
    accentBar.ZIndex = 155
    accentBar.Parent = b
    Instance.new("UICorner",accentBar).CornerRadius = UDim.new(1,0)
    local accentBarGrad = Instance.new("UIGradient")
    accentBarGrad.Color = ColorSequence.new(Color3.fromRGB(130,80,255), Color3.fromRGB(80,140,255))
    accentBarGrad.Rotation = 90
    accentBarGrad.Parent = accentBar

    -- Hover effect
    b.MouseEnter:Connect(function()
        if activeNavBtn ~= b then
            b.BackgroundColor3 = Color3.fromRGB(70,72,95)
        end
    end)
    b.MouseLeave:Connect(function()
        if activeNavBtn ~= b then
            b.BackgroundColor3 = Color3.fromRGB(58,60,82)
        end
    end)

    b.MouseButton1Click:Connect(function()
        -- Deactivate previous
        if activeNavBtn then 
            activeNavBtn.BackgroundColor3 = Color3.fromRGB(50,52,72)
            activeNavBtn.TextColor3 = Color3.fromRGB(255,255,255)
            local prevAcc = activeNavBtn:FindFirstChild("Frame")
            if prevAcc then prevAcc.Visible = false end
            local prevStroke = activeNavBtn:FindFirstChildOfClass("UIStroke")
            if prevStroke then prevStroke:Destroy() end
        end
        -- Activate current
        b.BackgroundColor3 = Color3.fromRGB(30,25,55)
        b.TextColor3 = Color3.new(1,1,1)
        accentBar.Visible = true
        -- Add subtle glow stroke
        local glowStroke = Instance.new("UIStroke")
        glowStroke.Color = Color3.fromRGB(100,70,200)
        glowStroke.Thickness = 1
        glowStroke.Transparency = 0.6
        glowStroke.Parent = b
        activeNavBtn = b
        callback()
    end)
    table.insert(updatableItems, {Obj = b, Key = key, Type = "Text"})
    return b
end

local function showTab(name)
    standTab.Visible = (name == "Stand")
    farmTab.Visible = (name == "Farm")
    raidsTab.Visible = (name == "Raids")
    statsTab.Visible = (name == "Stats")
    espTab.Visible = (name == "ESP")
    settingsTab.Visible = (name == "Settings")
end

createNav("TAB_STAND", 80, function() showTab("Stand") end)
createNav("TAB_FARM", 125, function() showTab("Farm") end)
createNav("TAB_RAIDS", 170, function() showTab("Raids") end)
createNav("TAB_STATS", 215, function() showTab("Stats") end)
createNav("TAB_ESP", 260, function() showTab("ESP") end)
createNav("TAB_SETTINGS", 305, function() showTab("Settings") end)

-- UI HELPERS (VERBOSE)
local function createSubTitle(key, pos, parent)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-40,0,25)
    l.Position = UDim2.new(0,20,0,pos)
    l.BackgroundTransparency = 1
    l.Text = getLoc(key)
    l.TextSize = 14
    l.Font = Enum.Font.GothamBold
    l.TextColor3 = Color3.new(0.8,0.8,0.8)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 120
    l.Parent = parent
    table.insert(updatableItems, {Obj = l, Key = key, Type = "Text"})
    return l
end

local function createToggle(key, pos, parent)
    local container = Instance.new("TextButton")
    container.Size = UDim2.new(1,-40,0,50)
    container.Position = UDim2.new(0,20,0,pos)
    container.BackgroundColor3 = Color3.fromRGB(20,22,32)
    container.Text = getLoc(key)
    container.TextSize = 14
    container.Font = Enum.Font.GothamSemibold
    container.TextColor3 = Color3.fromRGB(210,210,220)
    container.TextXAlignment = Enum.TextXAlignment.Left
    container.AutoButtonColor = false
    container.ZIndex = 120
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = container

    -- Subtle border stroke
    local borderStroke = Instance.new("UIStroke")
    borderStroke.Color = Color3.fromRGB(40,42,60)
    borderStroke.Thickness = 1
    borderStroke.Transparency = 0.5
    borderStroke.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = container

    -- Pill-shaped toggle switch track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0,52,0,26)
    track.Position = UDim2.new(1,-67,0.5,-13)
    track.BackgroundColor3 = Color3.fromRGB(55,35,35)
    track.ZIndex = 125
    track.Parent = container
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1,0)
    trackCorner.Parent = track

    -- Pill knob (circle)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,20,0,20)
    knob.Position = UDim2.new(0,3,0.5,-10)
    knob.BackgroundColor3 = Color3.fromRGB(180,60,60)
    knob.ZIndex = 130
    knob.Parent = track
    Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

    -- Hover
    container.MouseEnter:Connect(function()
        container.BackgroundColor3 = Color3.fromRGB(25,27,40)
    end)
    container.MouseLeave:Connect(function()
        container.BackgroundColor3 = Color3.fromRGB(20,22,32)
    end)

    table.insert(updatableItems, {Obj = container, Key = key, Type = "Text"})
    local function update(state)
        if state then
            track.BackgroundColor3 = Color3.fromRGB(30,55,40)
            knob.Position = UDim2.new(1,-23,0.5,-10)
            knob.BackgroundColor3 = Color3.fromRGB(60,210,100)
            borderStroke.Color = Color3.fromRGB(50,120,70)
            borderStroke.Transparency = 0.4
            -- Knob glow
            local glowStroke = knob:FindFirstChildOfClass("UIStroke")
            if not glowStroke then
                glowStroke = Instance.new("UIStroke")
                glowStroke.Parent = knob
            end
            glowStroke.Color = Color3.fromRGB(80,255,120)
            glowStroke.Thickness = 2
            glowStroke.Transparency = 0.3
        else
            track.BackgroundColor3 = Color3.fromRGB(55,35,35)
            knob.Position = UDim2.new(0,3,0.5,-10)
            knob.BackgroundColor3 = Color3.fromRGB(180,60,60)
            borderStroke.Color = Color3.fromRGB(40,42,60)
            borderStroke.Transparency = 0.5
            local glowStroke = knob:FindFirstChildOfClass("UIStroke")
            if glowStroke then glowStroke:Destroy() end
        end
    end
    return container, update
end

local function createLabel(key, pos, parent, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-40,0,45)
    l.Position = UDim2.new(0,20,0,pos)
    l.BackgroundColor3 = Color3.fromRGB(35,37,45)
    l.Text = getLoc(key)
    l.TextSize = 14
    l.Font = Enum.Font.GothamSemibold
    l.TextColor3 = color
    l.ZIndex = 115
    l.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = l
    
    table.insert(updatableItems, {Obj = l, Key = key, Type = "Text"})
    return l
end

local function createDropdown(titleKey, options, pos, parent, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-40,0,46)
    container.Position = UDim2.new(0,20,0,pos)
    container.BackgroundColor3 = Color3.fromRGB(20,22,32)
    container.ZIndex = 150
    container.Parent = parent
    Instance.new("UICorner",container).CornerRadius = UDim.new(0,10)

    -- Border stroke
    local ddStroke = Instance.new("UIStroke")
    ddStroke.Color = Color3.fromRGB(50,45,80)
    ddStroke.Thickness = 1
    ddStroke.Transparency = 0.4
    ddStroke.Parent = container

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-30,1,0)
    btn.Position = UDim2.new(0,12,0,0)
    btn.BackgroundTransparency = 1
    btn.Text = getLoc(titleKey)..": None"
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = Color3.fromRGB(210,210,225)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 155
    btn.Parent = container

    -- Chevron arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0,20,0,20)
    arrow.Position = UDim2.new(1,-25,0.5,-10)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextSize = 10
    arrow.Font = Enum.Font.GothamBold
    arrow.TextColor3 = Color3.fromRGB(130,100,220)
    arrow.ZIndex = 156
    arrow.Parent = container

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1,0,0,#options * 38)
    list.Position = UDim2.new(0,0,1,4)
    list.BackgroundColor3 = Color3.fromRGB(18,20,30)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 1000
    list.ClipsDescendants = true
    list.Parent = container
    Instance.new("UICorner",list).CornerRadius = UDim.new(0,10)
    local listStroke = Instance.new("UIStroke")
    listStroke.Color = Color3.fromRGB(60,50,100)
    listStroke.Thickness = 1
    listStroke.Transparency = 0.4
    listStroke.Parent = list

    btn.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
        container.ZIndex = list.Visible and 200 or 150
        arrow.Text = list.Visible and "▲" or "▼"
    end)

    for i, name in pairs(options) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1,-10,0,38)
        opt.Position = UDim2.new(0,5,0,(i-1)*38)
        opt.BackgroundColor3 = Color3.fromRGB(18,20,30)
        opt.AutoButtonColor = false
        opt.Text = name
        opt.TextSize = 13
        opt.Font = Enum.Font.GothamSemibold
        opt.TextColor3 = Color3.fromRGB(190,190,210)
        opt.ZIndex = 1001
        opt.Parent = list
        Instance.new("UICorner",opt).CornerRadius = UDim.new(0,8)
        
        -- Hover effect on options
        opt.MouseEnter:Connect(function()
            opt.BackgroundColor3 = Color3.fromRGB(35,30,60)
            opt.TextColor3 = Color3.new(1,1,1)
        end)
        opt.MouseLeave:Connect(function()
            opt.BackgroundColor3 = Color3.fromRGB(18,20,30)
            opt.TextColor3 = Color3.fromRGB(190,190,210)
        end)
        
        opt.MouseButton1Click:Connect(function()
            btn.Text = getLoc(titleKey)..": "..name
            list.Visible = false
            container.ZIndex = 150
            arrow.Text = "▼"
            callback(name)
        end)
    end
    table.insert(updatableItems, {Obj = btn, Key = titleKey, Type = "Dropdown", Val = "None"})
end

local function createStatRow(titleKey, pos, parent, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-40,0,55); container.Position = UDim2.new(0,20,0,pos); container.BackgroundColor3 = Color3.fromRGB(30,32,40); container.ZIndex = 120; container.Parent = parent
    Instance.new("UICorner",container).CornerRadius = UDim.new(0,10)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.5,0,0.5,0); l.BackgroundTransparency = 1; l.Text = getLoc(titleKey); l.TextSize = 14; l.Font = Enum.Font.GothamSemibold; l.TextColor3 = Color3.new(1,1,1); l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 125; l.Parent = container
    Instance.new("UIPadding",l).PaddingLeft = UDim.new(0,12)

    local currentLbl = Instance.new("TextLabel")
    currentLbl.Size = UDim2.new(0.5,0,0.4,0); currentLbl.Position = UDim2.new(0,0,0.5,0); currentLbl.BackgroundTransparency = 1; currentLbl.Text = "Current: 0"; currentLbl.TextSize = 12; currentLbl.Font = Enum.Font.Gotham; currentLbl.TextColor3 = Color3.new(0.6,0.8,1); currentLbl.TextXAlignment = Enum.TextXAlignment.Left; currentLbl.ZIndex = 125; currentLbl.Parent = container
    Instance.new("UIPadding",currentLbl).PaddingLeft = UDim.new(0,12)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0,70,0,30); box.Position = UDim2.new(1,-10,0.5,0); box.AnchorPoint = Vector2.new(1,0.5); box.BackgroundColor3 = Color3.fromRGB(45,47,55); box.Text = "0"; box.TextColor3 = Color3.new(1,1,1); box.TextSize = 14; box.Font = Enum.Font.GothamSemibold; box.ZIndex = 130; box.Parent = container
    Instance.new("UICorner",box).CornerRadius = UDim.new(0,6)
    box.FocusLost:Connect(function() callback(tonumber(box.Text) or 0) end)

    table.insert(updatableItems, {Obj = l, Key = titleKey, Type = "Text"})
    return currentLbl
end

-- V64: SETUP STAND TAB
local autoArrowBtn, updateArrow = createToggle("AUTO_ARROW", 20, standTab)
local worthBtn, updateWorth = createToggle("STOP_WORTH", 85, standTab)
createSubTitle("DESIRED_STAND", 155, standTab)

local standBox = Instance.new("TextBox")
standBox.Size = UDim2.new(1,-40,0,45); standBox.Position = UDim2.new(0,20,0,185); standBox.PlaceholderText = getLoc("PLACEHOLDER_STAND"); standBox.TextSize = 16; standBox.BackgroundColor3 = Color3.fromRGB(35,37,45); standBox.TextColor3 = Color3.new(1,1,1); standBox.ZIndex = 120; standBox.Parent = standTab
Instance.new("UICorner",standBox).CornerRadius = UDim.new(0,10)
standBox.FocusLost:Connect(function() desiredStand = standBox.Text end)
table.insert(updatableItems, {Obj = standBox, Key = "PLACEHOLDER_STAND", Type = "Placeholder"})

local standLabel = createLabel("CURR_STAND", 250, standTab, Color3.fromRGB(255,200,80))
local worthLabel = createLabel("CURR_WORTH", 305, standTab, Color3.fromRGB(120,200,255))

-- V64: SETUP FARM TAB
createSubTitle("SUB_ARROWS", 20, farmTab)
local farmBtn, updateFarm = createToggle("FARM_ARROWS", 50, farmTab)
createSubTitle("SUB_QUESTS", 120, farmTab)
local questBtn, updateQuest = createToggle("AUTO_QUEST", 150, farmTab)
createSubTitle("SUB_PRESTIGE", 220, farmTab)
local prestigeBtn, updatePrestige = createToggle("AUTO_PRESTIGE", 250, farmTab)
createSubTitle("SUB_LVL_FARM", 320, farmTab)
createDropdown("SELECT_LVL_FARM", {"PVE Mission Boards", "Boss Farm"}, 350, farmTab, function(val) selectedLvlFarm = val end)
local lvlFarmBtn, updateLvlFarm = createToggle("AUTO_LVL_FARM", 415, farmTab)

-- V64: SETUP RAIDS TAB
createSubTitle("SELECT_BOSS", 20, raidsTab)
createDropdown("SELECT_BOSS", {"Avdol", "Kira", "Jotaro", "Dio"}, 50, raidsTab, function(val) selectedRaidBoss = val end)
local raidToggleBtn, updateRaid = createToggle("AUTO_RAID", 115, raidsTab)
local restartToggleBtn, updateRestart = createToggle("AUTO_RESTART", 180, raidsTab)

local infoBox = Instance.new("TextLabel")
infoBox.Size = UDim2.new(1,-40,0,100); infoBox.Position = UDim2.new(0,20,0,250); infoBox.BackgroundColor3 = Color3.fromRGB(25,25,35); infoBox.Text = getLoc("RAID_INFO"); infoBox.TextColor3 = Color3.fromRGB(200,200,200); infoBox.TextSize = 12; infoBox.Font = Enum.Font.GothamSemibold; infoBox.TextWrapped = true; infoBox.ZIndex = 120; infoBox.Parent = raidsTab
Instance.new("UICorner",infoBox).CornerRadius = UDim.new(0,10)
table.insert(updatableItems, {Obj = infoBox, Key = "RAID_INFO", Type = "Text"})

-- V64: SETUP STATS TAB
local row1 = Instance.new("Frame")
row1.Size = UDim2.new(1,-40,0,50); row1.Position = UDim2.new(0,20,0,20); row1.BackgroundColor3 = Color3.fromRGB(30,35,45); row1.ZIndex = 120; row1.Parent = statsTab
Instance.new("UICorner",row1).CornerRadius = UDim.new(0,10)

local row1L = Instance.new("TextLabel")
row1L.Size = UDim2.new(0.4,0,1,0); row1L.BackgroundTransparency = 1; row1L.Text = getLoc("ADD_AMOUNT"); row1L.TextColor3 = Color3.new(0.9,0.9,0.9); row1L.Font = Enum.Font.GothamBold; row1L.TextSize = 14; row1L.ZIndex = 125; row1L.Parent = row1
Instance.new("UIPadding",row1L).PaddingLeft = UDim.new(0,12)
table.insert(updatableItems, {Obj = row1L, Key = "ADD_AMOUNT", Type = "Text"})

local row1Box = Instance.new("TextBox")
row1Box.Size = UDim2.new(0,70,0,30); row1Box.Position = UDim2.new(1,-10,0.5,0); row1Box.AnchorPoint = Vector2.new(1,0.5); row1Box.BackgroundColor3 = Color3.fromRGB(45,47,55); row1Box.Text = "1"; row1Box.TextColor3 = Color3.new(1,1,1); row1Box.TextSize = 14; row1Box.Font = Enum.Font.GothamBold; row1Box.ZIndex = 130; row1Box.Parent = row1
Instance.new("UICorner",row1Box).CornerRadius = UDim.new(0,6)
row1Box.FocusLost:Connect(function() spAmount = tonumber(row1Box.Text) or 1 end)

local autoStatsBtn, updateAutoStats = createToggle("AUTO_STATS", 80, statsTab)

local row3 = Instance.new("Frame")
row3.Size = UDim2.new(1,-40,0,45); row3.Position = UDim2.new(0,20,0,145); row3.BackgroundColor3 = Color3.fromRGB(15,20,30); row3.ZIndex = 120; row3.Parent = statsTab
Instance.new("UICorner",row3).CornerRadius = UDim.new(0,10)

local lvlLbl = Instance.new("TextLabel")
lvlLbl.Size = UDim2.new(0.33,0,1,0); lvlLbl.BackgroundTransparency = 1; lvlLbl.Text = "Level: 0"; lvlLbl.TextColor3 = Color3.new(1,1,1); lvlLbl.Font = Enum.Font.GothamBold; lvlLbl.TextSize = 14; lvlLbl.ZIndex = 125; lvlLbl.Parent = row3

local conjLbl = Instance.new("TextLabel")
conjLbl.Size = UDim2.new(0.33,0,1,0); conjLbl.Position = UDim2.new(0.33,0,0,0); conjLbl.BackgroundTransparency = 1; conjLbl.Text = "Conjuration: 0"; conjLbl.TextColor3 = Color3.fromRGB(100,255,100); conjLbl.Font = Enum.Font.GothamBold; conjLbl.TextSize = 13; conjLbl.ZIndex = 125; conjLbl.Parent = row3

local prestigeLbl = Instance.new("TextLabel")
prestigeLbl.Size = UDim2.new(0.33,0,1,0); prestigeLbl.Position = UDim2.new(0.66,0,0,0); prestigeLbl.BackgroundTransparency = 1; prestigeLbl.Text = "Prestige: 0"; prestigeLbl.TextColor3 = Color3.fromRGB(200,100,255); prestigeLbl.Font = Enum.Font.GothamBold; prestigeLbl.TextSize = 13; prestigeLbl.ZIndex = 125; prestigeLbl.Parent = row3

local spLabel = Instance.new("TextLabel")
spLabel.Size = UDim2.new(1,-40,0,20); spLabel.Position = UDim2.new(0,20,0,200); spLabel.BackgroundTransparency = 1; spLabel.Text = "Stat Points: 0"; spLabel.TextColor3 = Color3.fromRGB(255,255,100); spLabel.Font = Enum.Font.GothamBold; spLabel.TextSize = 15; spLabel.TextXAlignment = Enum.TextXAlignment.Left; spLabel.ZIndex = 125; spLabel.Parent = statsTab

createSubTitle("TARGET_ATTR", 225, statsTab)
local sL = createStatRow("STAT_STR", 255, statsTab, function(v) statTargets["Strength"] = v end)
local hL = createStatRow("STAT_HP", 315, statsTab, function(v) statTargets["Health"] = v end)
local pL = createStatRow("STAT_POW", 375, statsTab, function(v) statTargets["Power"] = v end)
local wL = createStatRow("STAT_WEP", 435, statsTab, function(v) statTargets["Weapon"] = v end)
local dpL = createStatRow("STAT_DP", 495, statsTab, function(v) statTargets["Destructive Power"] = v end)
local deL = createStatRow("STAT_DE", 555, statsTab, function(v) statTargets["Destructive Energy"] = v end)

--// V64: SETUP ESP TAB
createSubTitle("TARGET_CAT", 20, espTab)
local espItemsBtn, updateEspItems = createToggle("ESP_ITEMS", 55, espTab)
local espPeopleBtn, updateEspPeople = createToggle("ESP_PEOPLE", 120, espTab)
local espNpcBtn, updateEspNpc = createToggle("ESP_NPC", 185, espTab)

createSubTitle("ESP_SETTINGS", 260, espTab)
local hLEspBtn, updateHL = createToggle("Highlight ESP", 295, espTab); updateHL(true)
local boxEspBtn, updateBox = createToggle("Box ESP", 360, espTab)
local nameEspBtn, updateName = createToggle("Name ESP", 425, espTab)
local healthEspBtn, updateHHealth = createToggle("Health ESP", 490, espTab)
local distEspBtn, updateDist = createToggle("Distance ESP", 555, espTab)

--// V64: SETUP SETTINGS TAB (LOCALE + DUAL COLUMN KEYBINDS)
createSubTitle("LANG_SWITCH", 20, settingsTab)

local ruBtn = Instance.new("TextButton")
ruBtn.Size = UDim2.new(0,100,0,40); ruBtn.Position = UDim2.new(0,20,0,50); ruBtn.BackgroundColor3 = Color3.fromRGB(60,40,40); ruBtn.Text = "РУССКИЙ"; ruBtn.TextColor3 = Color3.new(1,1,1); ruBtn.Font = Enum.Font.GothamBold; ruBtn.ZIndex = 150; ruBtn.Parent = settingsTab
Instance.new("UICorner",ruBtn).CornerRadius = UDim.new(0,8)

local enBtn = Instance.new("TextButton")
enBtn.Size = UDim2.new(0,100,0,40); enBtn.Position = UDim2.new(0,130,0,50); enBtn.BackgroundColor3 = Color3.fromRGB(40,40,60); enBtn.Text = "ENGLISH"; enBtn.TextColor3 = Color3.new(1,1,1); enBtn.Font = Enum.Font.GothamBold; enBtn.ZIndex = 150; enBtn.Parent = settingsTab
Instance.new("UICorner",enBtn).CornerRadius = UDim.new(0,8)

createSubTitle("AUTO_USE_KEYS", 110, settingsTab)

local keysFrame = Instance.new("Frame")
keysFrame.Size = UDim2.new(1,-40,0,320); keysFrame.Position = UDim2.new(0,20,0,140); keysFrame.BackgroundTransparency = 1; keysFrame.ZIndex = 150; keysFrame.Parent = settingsTab

local colLetters = Instance.new("Frame")
colLetters.Size = UDim2.new(0.48,0,1,0); colLetters.BackgroundTransparency = 1; colLetters.Parent = keysFrame
local gl = Instance.new("UIGridLayout"); gl.CellSize = UDim2.new(1,0,0,35); gl.CellPadding = UDim2.new(0,0,0,5); gl.Parent = colLetters

local colNumbers = Instance.new("Frame")
colNumbers.Size = UDim2.new(0.48,0,1,0); colNumbers.Position = UDim2.new(0.52,0,0,0); colNumbers.BackgroundTransparency = 1; colNumbers.Parent = keysFrame
local gn = Instance.new("UIGridLayout"); gn.CellSize = UDim2.new(1,0,0,35); gn.CellPadding = UDim2.new(0,0,0,5); gn.Parent = colNumbers

local function createKeyToggle(key, parent)
    local kb = Instance.new("TextButton")
    kb.BackgroundColor3 = Color3.fromRGB(35,37,45); kb.Text = key.." [OFF]"; kb.TextColor3 = Color3.new(0.6,0.6,0.6); kb.Font = Enum.Font.GothamBold; kb.TextSize = 13; kb.ZIndex = 160; kb.Parent = parent
    Instance.new("UICorner",kb).CornerRadius = UDim.new(0,6)
    kb.MouseButton1Click:Connect(function()
        autoSkills[key] = not autoSkills[key]; kb.Text = key..(autoSkills[key] and " [ON]" or " [OFF]")
        kb.BackgroundColor3 = autoSkills[key] and Color3.fromRGB(60,160,80) or Color3.fromRGB(35,37,45)
        kb.TextColor3 = autoSkills[key] and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6)
    end)
end

local alphabet = {"E","R","Z","X","C","V"}
local digits = {"1","2","3","4","5","6","7","8","9"}
for _, k in pairs(alphabet) do createKeyToggle(k, colLetters) end
for _, k in pairs(digits) do createKeyToggle(k, colNumbers) end

--// LOCALIZATION UPDATER
local function updateLocale(lang)
    currentLang = lang; topTitle.Text = getLoc("TITLE"); sideCredits.Text = getLoc("SIDEBAR_CREDITS")
    for _, item in pairs(updatableItems) do
        if item.Type == "Text" then item.Obj.Text = getLoc(item.Key)
        elseif item.Type == "Placeholder" then item.Obj.PlaceholderText = getLoc(item.Key)
        elseif item.Type == "Dropdown" then item.Obj.Text = getLoc(item.Key)..": ".. (item.Val or "None") end
    end
end
ruBtn.MouseButton1Click:Connect(function() updateLocale("RU") end)
enBtn.MouseButton1Click:Connect(function() updateLocale("ENG") end)

--// ROBUST DATA HELPERS (DIRECT V63 CLONE)
function getStand()
    local sd = player.PlayerData:FindFirstChild("SlotData"); if not sd or not sd:FindFirstChild("Stand") then return "None" end
    local val = sd.Stand.Value; local ok,data = pcall(function() return HttpService:JSONDecode(val) end)
    return (ok and data) and data.Name or "None"
end
local function toNum(v) local s = tostring(v); local clean = string.gsub(string.upper(s), "I", "1"); clean = string.gsub(clean, "[^0-9]", ""); return tonumber(clean) or 0 end
local function getConj()
    local cVal = player.PlayerData:FindFirstChild("Conjuration"); if not cVal then return 0 end
    local ok, data = pcall(function() return HttpService:JSONDecode(cVal.Value) end)
    if ok and data then local stand = getStand(); if data[stand] then return data[stand].Conjuration or 0 end end
    return 0
end
local function getQuestData()
    local slotData = player.PlayerData:FindFirstChild("SlotData"); if not slotData then return nil end
    local obj = slotData:FindFirstChild("CurrentQuests") or slotData:FindFirstChild("TrackedQuest"); if not obj then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(obj.Value) end)
    if ok and data then return data[1] or data end; return nil
end
local function findNPC(name)
    if not name or name == "" then return nil end
    -- Priority 1: exact match in known NPC containers
    local paths = {workspace:FindFirstChild("Npcs"), workspace:FindFirstChild("NPCs"), ReplicatedStorage:FindFirstChild("assets") and ReplicatedStorage.assets:FindFirstChild("npc_cache")}
    for _, f in pairs(paths) do if f and f:FindFirstChild(name) then return f[name] end end
    -- Priority 2: exact match in Live (but NOT other players)
    local live = workspace:FindFirstChild("Live")
    if live then
        local exact = live:FindFirstChild(name)
        if exact and exact:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(exact) then return exact end
    end
    -- Priority 3: partial match in NPC containers (quest data names may differ from actual NPC names)
    for _, f in pairs(paths) do
        if f then
            for _, npc in pairs(f:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and string.find(npc.Name, name, 1, true) then
                    return npc
                end
            end
        end
    end
    -- Priority 4: partial match in Live (non-players only)
    if live then
        for _, v in pairs(live:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(v) and string.find(v.Name, name, 1, true) then
                return v
            end
        end
    end
    return nil
end
local function isStandActive()
    local effects = workspace:FindFirstChild("Effects")
    if effects then local stand = effects:FindFirstChild("." .. player.Name .. "'s Stand") or effects:FindFirstChild(player.Name .. "'s Stand")
    if stand and stand:FindFirstChild("HumanoidRootPart") then return true end end; return false
end
local lastSummon = 0
local function summonStand()
    if tick() - lastSummon < 4 then return end 
    if not isStandActive() then VIM:SendKeyEvent(true, Enum.KeyCode.Tab, false, game); task.wait(0.1); VIM:SendKeyEvent(false, Enum.KeyCode.Tab, false, game); lastSummon = tick() end
end

--// V63: ADVANCED ESP LOGIC
local function applyESP(obj, color, nameText)
    local hl = obj:FindFirstChild("V63_HL")
    if hl then hl.Enabled = espHighlight; hl.FillColor = color else
        hl = Instance.new("Highlight"); hl.Name = "V63_HL"; hl.FillColor = color; hl.FillTransparency = 0.5; hl.OutlineColor = Color3.new(1,1,1); hl.OutlineTransparency = 0; hl.Enabled = espHighlight; hl.Adornee = obj; hl.Parent = obj
    end
    local box = obj:FindFirstChild("V63_BOX")
    if box then box.Visible = espBox; box.Color3 = color else
        box = Instance.new("SelectionBox"); box.Name = "V63_BOX"; box.Color3 = color; box.LineThickness = 0.05; box.Visible = espBox; box.Adornee = obj; box.Parent = obj
    end
    local bb = obj:FindFirstChild("V63_BB")
    if not bb then
        bb = Instance.new("BillboardGui"); bb.Name = "V63_BB"; bb.Size = UDim2.new(0,200,0,50); bb.AlwaysOnTop = true; bb.ExtentsOffset = Vector3.new(0,3,0); bb.Parent = obj
        local label = Instance.new("TextLabel"); label.Name = "Info"; label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.TextColor3 = color; label.TextStrokeTransparency = 0; label.TextSize = 14; label.Font = Enum.Font.GothamBold; label.Parent = bb
    end
    local finalStr = ""
    if espName then finalStr = nameText .. "\n" end
    if espDist then local char = player.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then local d = math.floor((hrp.Position - obj:GetPivot().Position).Magnitude); finalStr = finalStr .. "[" .. d .. "m] " end end
    if espHealth and obj:FindFirstChild("Humanoid") then finalStr = finalStr .. "(" .. math.floor(obj.Humanoid.Health) .. " HP)" end
    bb.Enabled = (espName or espHealth or espDist); bb.Info.Text = finalStr; bb.Info.TextColor3 = color
end

local function removeESP(obj)
    if obj:FindFirstChild("V63_HL") then obj.V63_HL:Destroy() end
    if obj:FindFirstChild("V63_BOX") then obj.V63_BOX:Destroy() end
    if obj:FindFirstChild("V63_BB") then obj.V63_BB:Destroy() end
end
-- ESP: Instant item detection via ChildAdded (no lag)
local espTrackedItems = {}
workspace.ChildAdded:Connect(function(o)
    task.wait(0.1)
    if espItems then
        local itemName = o.Name
        if itemName == "Model" then for _, c in pairs(o:GetChildren()) do if c:IsA("Tool") or c.Name == "Stand Arrow" then itemName = c.Name; break end end end
        if (o.Name == "Stand Arrow" or o:FindFirstChild("Stand Arrow") or o:IsA("Tool")) then
            local isEffect = string.find(string.lower(itemName), "effect") or string.find(string.lower(itemName), "hit")
            local pos = Vector3.new(0, 50, 0)
            pcall(function() pos = o:GetPivot().Position end)
            if not isEffect and pos.Y > -50 then
                applyESP(o, Color3.fromRGB(230,190,0), itemName)
                espTrackedItems[o] = true
            end
        end
    end
end)
workspace.DescendantRemoving:Connect(function(o)
    if espTrackedItems[o] then
        removeESP(o)
        espTrackedItems[o] = nil
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            -- Validate existing tracked items first
            if espItems then
                for o, _ in pairs(espTrackedItems) do
                    local isValid = false
                    if o and o.Parent == workspace then
                        if o.Name == "Stand Arrow" or o:FindFirstChild("Stand Arrow") or o:IsA("Tool") then
                            isValid = true
                        end
                    end
                    
                    if not isValid then
                        pcall(function()
                            if o:FindFirstChild("V63_HL") then o.V63_HL:Destroy() end
                            if o:FindFirstChild("V63_BOX") then o.V63_BOX:Destroy() end
                            if o:FindFirstChild("V63_BB") then o.V63_BB:Destroy() end
                        end)
                        espTrackedItems[o] = nil
                    end
                end
                
                for _, o in pairs(workspace:GetChildren()) do
                    if (o.Name == "Stand Arrow" or o:FindFirstChild("Stand Arrow") or o:IsA("Tool")) then
                        local itemName = o.Name
                        if itemName == "Model" then for _, c in pairs(o:GetChildren()) do if c:IsA("Tool") or c.Name == "Stand Arrow" then itemName = c.Name; break end end end
                        local isEffect = string.find(string.lower(itemName), "effect") or string.find(string.lower(itemName), "hit")
                        local pos = Vector3.new(0, 50, 0)
                        pcall(function() pos = o:GetPivot().Position end)
                        if not isEffect and pos.Y > -50 then
                            applyESP(o, Color3.fromRGB(230,190,0), itemName)
                            espTrackedItems[o] = true
                        end
                    end
                end
            else
                -- Clean up item ESP when disabled
                for obj, _ in pairs(espTrackedItems) do
                    if obj and obj.Parent then removeESP(obj) end
                end
                espTrackedItems = {}
            end
            
            -- People & NPC ESP (only scan Live folder)
            local live = workspace:FindFirstChild("Live")
            if live then 
                local myChar = live:FindFirstChild(player.Name)
                for _, v in pairs(live:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= myChar then
                        local isP = Players:GetPlayerFromCharacter(v)
                        if isP and espPeople then 
                            applyESP(v, Color3.fromRGB(0,180,255), v.Name)
                        elseif not isP and espNPC then 
                            applyESP(v, Color3.fromRGB(50,220,50), v.Name)
                        elseif v:FindFirstChild("V63_HL") then 
                            removeESP(v) 
                        end
                    end 
                end 
                -- Clean up NPC/People ESP when both disabled
                if not espPeople and not espNPC then
                    for _, v in pairs(live:GetChildren()) do
                        if v:FindFirstChild("V63_HL") and not Players:GetPlayerFromCharacter(v) then removeESP(v) end
                    end
                end
            end
        end)
    end
end)

--// SKILLS LOGIC (FIXED)
function getNil(name,class) for _,v in pairs(getnilinstances())do if v.ClassName==class and v.Name==name then return v;end end end
local function fireSkill(skillKey, state)
    local char = workspace.Live:FindFirstChild(player.Name); local controller = char and char:FindFirstChild("client_character_controller")
    if controller and controller:FindFirstChild("Skill") then controller.Skill:FireServer(skillKey, state) end
end

task.spawn(function()
    while task.wait(0.1) do -- Faster check
        if (autoQuest or autoRaid or autoLvlFarm) and currentTarget and not isHoveringMenu then
            for key, enabled in pairs(autoSkills) do 
                if enabled then 
                    if key == "E" then 
                        fireSkill(key, true); task.wait(0.6); fireSkill(key, false); task.wait(0.1)
                    else 
                        fireSkill(key, true); task.wait(0.05); fireSkill(key, false); task.wait(0.05)
                    end
                end 
            end
        end
    end
end)

--// LOOPS
RunService.Heartbeat:Connect(function()
    if targetCFrame then local char = workspace.Live:FindFirstChild(player.Name); local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = targetCFrame; hrp.AssemblyLinearVelocity = Vector3.new(0,0,0); hrp.AssemblyAngularVelocity = Vector3.new(0,0,0) end end
end)

-- CLICKER
task.spawn(function()
    while true do
        if (autoQuest or autoRaid or autoLvlFarm) and currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 and not isHoveringMenu and not dragging then
            VIM:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.12); VIM:SendMouseButtonEvent(0,0,0,false,game,0); task.wait(0.08)
        else task.wait(0.5) end
    end
end)

-- BINDINGS
autoArrowBtn.MouseButton1Click:Connect(function() autoArrow = not autoArrow; updateArrow(autoArrow) end)
worthBtn.MouseButton1Click:Connect(function() stopWorth0 = not stopWorth0; updateWorth(stopWorth0) end)
farmBtn.MouseButton1Click:Connect(function() autoFarm = not autoFarm; updateFarm(autoFarm) end)
questBtn.MouseButton1Click:Connect(function() autoQuest = not autoQuest; updateQuest(autoQuest); if not autoQuest then currentTarget = nil; targetCFrame = nil end end)
raidToggleBtn.MouseButton1Click:Connect(function() autoRaid = not autoRaid; updateRaid(autoRaid); if not autoRaid then currentTarget = nil; targetCFrame = nil end end)
restartToggleBtn.MouseButton1Click:Connect(function() autoRestart = not autoRestart; updateRestart(autoRestart) end)
autoStatsBtn.MouseButton1Click:Connect(function() autoAddStats = not autoAddStats; updateAutoStats(autoAddStats) end)
prestigeBtn.MouseButton1Click:Connect(function() autoPrestige = not autoPrestige; updatePrestige(autoPrestige); if autoPrestige then currentTarget = nil; targetCFrame = nil end end)
lvlFarmBtn.MouseButton1Click:Connect(function() autoLvlFarm = not autoLvlFarm; updateLvlFarm(autoLvlFarm); if not autoLvlFarm then currentTarget = nil; targetCFrame = nil end end)

espItemsBtn.MouseButton1Click:Connect(function() espItems = not espItems; updateEspItems(espItems) end)
espPeopleBtn.MouseButton1Click:Connect(function() espPeople = not espPeople; updateEspPeople(espPeople) end)
espNpcBtn.MouseButton1Click:Connect(function() espNPC = not espNPC; updateEspNpc(espNPC) end)
hLEspBtn.MouseButton1Click:Connect(function() espHighlight = not espHighlight; updateHL(espHighlight) end)
boxEspBtn.MouseButton1Click:Connect(function() espBox = not espBox; updateBox(espBox) end)
nameEspBtn.MouseButton1Click:Connect(function() espName = not espName; updateName(espName) end)
healthEspBtn.MouseButton1Click:Connect(function() espHealth = not espHealth; updateHHealth(espHealth) end)
distEspBtn.MouseButton1Click:Connect(function() espDist = not espDist; updateDist(espDist) end)

-- UI SYNC
task.spawn(function()
    while task.wait(0.5) do pcall(function()
        local sd = player.PlayerData.SlotData; standLabel.Text = getLoc("CURR_STAND") .. getStand(); worthLabel.Text = getLoc("CURR_WORTH") .. sd.Worthiness.Value
        lvlLbl.Text = getLoc("LEVEL_TEXT") .. toNum(sd.Level.Value); conjLbl.Text = getLoc("CONJ_TEXT") .. getConj(); prestigeLbl.Text = getLoc("PRESTIGE_TEXT") .. toNum(sd.Prestige.Value); spLabel.Text = getLoc("SP_TEXT") .. toNum(sd.StatPoints.Value)
        sL.Text = "Current: " .. toNum(sd.StrengthStat.Value); hL.Text = "Current: " .. toNum(sd.DefenseStat.Value); pL.Text = "Current: " .. toNum(sd.PowerStat.Value)
        wL.Text = "Current: " .. toNum(sd.WeaponStat.Value); dpL.Text = "Current: " .. toNum(sd.DestructivePowerStat.Value); deL.Text = "Current: " .. toNum(sd.DestructiveEnergyStat.Value)
    end) end
end)

-- AUTOMATION
task.spawn(function()
    while task.wait(1) do if autoArrow then local stand = getStand()
    if desiredStand ~= "" and string.lower(stand) == string.lower(desiredStand) then autoArrow = false; updateArrow(false)
    elseif stopWorth0 and player.PlayerData.SlotData.Worthiness.Value == 0 then autoArrow = false; updateArrow(false)
    else ReplicatedStorage.requests.character.use_item:FireServer("Stand Arrow") end end end
end)

task.spawn(function()
    while task.wait(0.5) do if autoFarm then local char = workspace.Live:FindFirstChild(player.Name)
    if char and char:FindFirstChild("HumanoidRootPart") then for _, o in pairs(workspace:GetChildren()) do if not autoFarm then break end
    if o.Name == "Stand Arrow" or o:FindFirstChild("Stand Arrow") then char.HumanoidRootPart.CFrame = o:GetPivot(); task.wait(0.2); VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(1.0); VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game); task.wait(1.0); break end end end end end
end)

task.spawn(function()
    while task.wait(0.5) do if autoAddStats then local sd = player.PlayerData.SlotData; local points = toNum(sd.StatPoints.Value)
    if points > 0 then for display, target in pairs(statTargets) do if not autoAddStats then break end; local exact = STAT_NAME_MAP[display]
    if target > 0 and toNum(sd[exact].Value) < target then ReplicatedStorage.requests.character.increase_stat:FireServer(exact, spAmount); task.wait(0.3); break end end end end end
end)

local function getKiraTarget()
    local map = workspace:FindFirstChild("Map"); local kiraMap = map and map:FindFirstChild("Yoshikage Kira Bites the Dust")
    if not kiraMap then return nil end; local rooms = kiraMap:FindFirstChild("Gamemode Rooms"); if not rooms then return nil end
    local char = workspace.Live:FindFirstChild(player.Name); local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    for i = 1, 4 do local room = rooms:FindFirstChild("Room " .. i); local spawns = room and room:FindFirstChild("Mob Spawns")
    if spawns then for _, live in pairs(workspace.Live:GetChildren()) do if live:FindFirstChild("Humanoid") and live.Humanoid.Health > 0 and live ~= char and not string.find(string.lower(live.Name), "hostage") then
    for _, s in pairs(spawns:GetChildren()) do if (live.HumanoidRootPart.Position - s.Position).Magnitude < 100 then return live end end end end end end
    
    -- Only target Kira boss if we are actually in the raid map (kiraMap exists)
    for _, v in pairs(workspace.Live:GetChildren()) do if string.find(v.Name, "Yoshikage Kira") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then return v end end; return nil
end

-- DIO 2-PHASE TARGETING
local function getDioTarget()
    local map = workspace:FindFirstChild("Map"); local dioMap = map and map:FindFirstChild("DIO")
    if not dioMap then return nil end; local rooms = dioMap:FindFirstChild("Gamemode Rooms"); if not rooms then return nil end
    local char = workspace.Live:FindFirstChild(player.Name); local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    for i = 1, 2 do local room = rooms:FindFirstChild("Room " .. i); local spawns = room and room:FindFirstChild("Mob Spawns")
    if spawns then for _, live in pairs(workspace.Live:GetChildren()) do if live:FindFirstChild("Humanoid") and live.Humanoid.Health > 0 and live ~= char and not string.find(string.lower(live.Name), "hostage") then
    for _, s in pairs(spawns:GetChildren()) do if (live.HumanoidRootPart.Position - s.Position).Magnitude < 100 then return live end end end end end end
    for _, v in pairs(workspace.Live:GetChildren()) do if v.Name == "DIO" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then return v end end; return nil
end

task.spawn(function()
    while task.wait(0.1) do -- Extreme Speed
        if autoRaid and RAID_BOSSES[selectedRaidBoss] then
            local char = workspace.Live:FindFirstChild(player.Name); local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then local bossData = RAID_BOSSES[selectedRaidBoss]; local found = nil
            -- Special targeting per boss
            if selectedRaidBoss == "Kira" then 
                found = getKiraTarget()
            elseif selectedRaidBoss == "Dio" then
                found = getDioTarget()
            else
                -- For other bosses: search by exact boss name in Live
                for _, v in pairs(workspace.Live:GetChildren()) do if string.find(v.Name, bossData.BossName) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then found = v; break end end
            end
            -- DIO Phase 1: kill mobs if DIO exists or raid started
            if not found and selectedRaidBoss == "Dio" then found = getDioTarget() end
            
            if found then 
                currentTarget = found; summonStand(); targetCFrame = found.HumanoidRootPart.CFrame * CFrame.new(0, 9, 0) * CFrame.Angles(-math.pi/2, 0, 0) -- H=9
            else 
                targetCFrame = nil; currentTarget = nil
                local npc = nil
                if selectedRaidBoss == "Dio" then
                    if workspace:FindFirstChild("Npcs") and workspace.Npcs:FindFirstChild("???") then npc = workspace.Npcs["???"]
                    elseif ReplicatedStorage:FindFirstChild("assets") and ReplicatedStorage.assets:FindFirstChild("npc_cache") and ReplicatedStorage.assets.npc_cache:FindFirstChild("???") then npc = ReplicatedStorage.assets.npc_cache["???"] end
                else
                    npc = findNPC(bossData.TalkName)
                end
                
                if npc and npc:FindFirstChild("HumanoidRootPart") then 
                    local tp = npc.HumanoidRootPart.CFrame
                    hrp.CFrame = tp * CFrame.new(0,0,-3.5)
                    task.wait(0.5)
                    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.6)
                    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    task.wait(0.5)
                    if selectedRaidBoss == "Dio" then
                        VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game)
                        task.wait(0.2)
                        VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game)
                        task.wait(10) -- 10 seconds wait per user instruction
                    else
                        for i=1,2 do 
                            VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game)
                            task.wait(0.2)
                            VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game)
                            task.wait(0.4) 
                        end
                        -- Push player into the red ring to trigger the raid for Kira/Avdol
                        hrp.CFrame = tp * CFrame.new(0, 0, -16) 
                        task.wait(10)
                    end
                end 
            end 
            end -- Added missing end for 'if hrp then'
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do -- Extreme Speed
        if autoQuest then
            local data = getQuestData(); local char = workspace.Live:FindFirstChild(player.Name); local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if data and hrp then if data.Talk then targetCFrame = nil; currentTarget = nil
            -- Try ALL un-talked NPCs (pairs order is random, so try each one until we find a valid NPC)
            local npcObj = nil
            for npcName, talked in pairs(data.Talk) do
                if talked == false then
                    npcObj = findNPC(npcName)
                    if npcObj and npcObj:FindFirstChild("HumanoidRootPart") then break end
                    npcObj = nil -- reset if not found or no HumanoidRootPart
                end
            end
            if npcObj then hrp.CFrame = npcObj:GetPivot() * CFrame.new(0,0,-3.5); task.wait(0.6); VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(0.5); VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game); task.wait(0.4)
            for i=1,7 do if not autoQuest then break end; VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game); task.wait(0.2); VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game); task.wait(0.3) end end
            elseif data.Defeat or data.Kills then local tbl = data.Defeat or data.Kills; local targetStr = nil
            -- Find an incomplete kill target
            for n, p in pairs(tbl) do
                if type(p) == "table" then
                    if (p.Current or 0) < (p.Target or 999) then targetStr = n; break end
                elseif type(p) == "number" and p < 999 then targetStr = n; break
                elseif type(p) ~= "number" then targetStr = n; break end
            end
            local enemy = nil; for _, v in pairs(workspace.Live:GetChildren()) do
                if targetStr and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(v) then
                    if v.Name == targetStr or string.find(v.Name, targetStr, 1, true) then enemy = v; break end
                end
            end
            if enemy then currentTarget = enemy; summonStand(); targetCFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 9, 0) * CFrame.Angles(-math.pi/2, 0, 0)
            else targetCFrame = nil; currentTarget = nil end end end
        end
    end
end)

task.spawn(function()
    while task.wait(1.5) do if autoRestart then local pGui = player:FindFirstChild("PlayerGui")
    if pGui then for _, v in pairs(pGui:GetDescendants()) do if v:IsA("TextButton") and string.find(string.lower(v.Text), "play again") and v.Visible then
    local pos = v.AbsolutePosition + (v.AbsoluteSize / 2); VIM:SendMouseButtonEvent(pos.X, pos.Y + 58, 0, true, game, 0); task.wait(0.1); VIM:SendMouseButtonEvent(pos.X, pos.Y + 58, 0, false, game, 0); break end end end end end
end)

task.spawn(function()
    while task.wait(2) do
        if autoPrestige then
            local sd = player.PlayerData.SlotData; local lvl = toNum(sd.Level.Value); local money = toNum(sd.Money.Value)
            if lvl >= 50 and money >= 10000 then
                local mage = workspace.Npcs:FindFirstChild("Arch Mage")
                local char = workspace.Live:FindFirstChild(player.Name); local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if mage and hrp then
                    targetCFrame = nil; currentTarget = nil
                    hrp.CFrame = mage.HumanoidRootPart.CFrame * CFrame.new(0,0,-3.5)
                    task.wait(0.5); VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(0.8); VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game); task.wait(0.5)
                    for i=1,3 do VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game); task.wait(0.2); VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game); task.wait(0.5) end
                end
            end
        end
    end
end)

-- PVE MISSION BOARD AUTO FARM
task.spawn(function()
    while task.wait(0.5) do
        if autoLvlFarm and selectedLvlFarm == "PVE Mission Boards" then
            pcall(function()
                local char = workspace.Live:FindFirstChild(player.Name)
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                -- PRIORITY 1: DELIVERY QUEST - search workspace.Effects for Quest Markers with "Delivery"
                local deliveryMarker = nil
                
                local effects = workspace:FindFirstChild("Effects")
                if effects then
                    for _, obj in pairs(effects:GetChildren()) do
                        pcall(function()
                            local qm = obj:FindFirstChild("Quest Marker")
                            if qm then
                                local img = qm:FindFirstChild("Image")
                                if img then
                                    local title = img:FindFirstChild("Title")
                                    if title and string.find(title.Text or "", "Delivery") then
                                        deliveryMarker = obj
                                    end
                                end
                            end
                        end)
                        if deliveryMarker then break end
                    end
                end
                
                if deliveryMarker then
                    -- Teleport to the delivery marker and hold E
                    local markerPos = nil
                    pcall(function() markerPos = deliveryMarker:GetPivot() end)
                    if markerPos then
                        targetCFrame = nil; currentTarget = nil
                        hrp.CFrame = markerPos * CFrame.new(0, 0, -3)
                        task.wait(0.3)
                        -- Hold E to interact
                        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(1.5)
                        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        task.wait(0.5)
                        -- Press 1 a few times to progress dialogue
                        for i = 1, 3 do
                            VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game)
                            task.wait(0.2)
                            VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game)
                            task.wait(0.3)
                        end
                    end
                    return
                end
                
                -- PRIORITY 2: KILL QUEST - find NPCs with red Highlight (OutlineColor = 255,0,25)
                local enemy = nil
                for _, v in pairs(workspace.Live:GetChildren()) do
                    if v ~= char and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(v) then
                        for _, hl in pairs(v:GetChildren()) do
                            if hl:IsA("Highlight") and hl.Name ~= "V63_HL" then
                                -- Check if OutlineColor is red (quest target marker)
                                local c = hl.OutlineColor
                                if c.R > 0.9 and c.G < 0.1 and c.B < 0.2 then
                                    enemy = v; break
                                end
                            end
                        end
                    end
                    if enemy then break end
                end
                
                if enemy then
                    currentTarget = enemy
                    summonStand()
                    targetCFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 9, 0) * CFrame.Angles(-math.pi/2, 0, 0)
                    return
                end
                
                -- NO QUEST DETECTED - Go to the nearest Mission Board to accept one
                targetCFrame = nil; currentTarget = nil
                
                local map = workspace:FindFirstChild("Map")
                local boards = map and map:FindFirstChild("Mission Boards")
                local pve = boards and boards:FindFirstChild("PvE")
                if not pve then return end
                
                local children = pve:GetChildren()
                if #children == 0 then return end
                
                -- Find the nearest board
                local nearest = nil
                local nearestDist = math.huge
                for _, board in pairs(children) do
                    local boardPos = nil
                    pcall(function() boardPos = board:GetPivot().Position end)
                    if boardPos then
                        local dist = (hrp.Position - boardPos).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearest = board
                        end
                    end
                end
                
                if nearest then
                    -- Position player in front of the board, facing it
                    local boardCFrame = nearest:GetPivot()
                    local frontCFrame = boardCFrame * CFrame.new(0, 0, 5)
                    hrp.CFrame = CFrame.new(frontCFrame.Position, boardCFrame.Position)
                    task.wait(0.1)
                    -- Align camera behind player facing board
                    pcall(function()
                        local cam = workspace.CurrentCamera
                        cam.CameraType = Enum.CameraType.Scriptable
                        cam.CFrame = CFrame.new(frontCFrame.Position + Vector3.new(0, 2, 3), boardCFrame.Position)
                        task.wait(0.1)
                        cam.CameraType = Enum.CameraType.Custom
                    end)
                    task.wait(0.3)
                    
                    -- Hold E to interact with board
                    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(1.5)
                    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    task.wait(0.5)
                    
                    -- Press 1 to accept mission
                    VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game)
                    task.wait(0.2)
                    VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game)
                    task.wait(1)
                end
            end)
        end
    end
end)

-- BOSS FARM AUTO FARM
local bossNames = {"Akira Otoishi", "Yoshikage Kira", "Okuyasu Nijimura PRIME", "Miyamoto Musashi"}
local currentBossIndex = 1

task.spawn(function()
    while task.wait(0.5) do
        if autoLvlFarm and selectedLvlFarm == "Boss Farm" then
            pcall(function()
                local char = workspace.Live:FindFirstChild(player.Name)
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                -- Try to find the current boss in workspace.Live
                local bossTarget = nil
                local bossName = bossNames[currentBossIndex]
                
                for _, v in pairs(workspace.Live:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        if string.find(v.Name, bossName) then
                            bossTarget = v; break
                        end
                    end
                end
                
                if bossTarget then
                    currentTarget = bossTarget
                    summonStand()
                    targetCFrame = bossTarget.HumanoidRootPart.CFrame * CFrame.new(0, 9, 0) * CFrame.Angles(-math.pi/2, 0, 0)
                else
                    -- Boss not found or dead - move to next boss
                    targetCFrame = nil; currentTarget = nil
                    currentBossIndex = currentBossIndex + 1
                    if currentBossIndex > #bossNames then
                        currentBossIndex = 1
                    end
                end
            end)
        end
    end
end)

updateLocale("ENG")

-- Set Stand tab as active on startup
if activeNavBtn == nil then
    -- Trigger the first nav button click to set active state
    for _, child in pairs(sidebar:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = Color3.fromRGB(30,25,55)
            child.TextColor3 = Color3.new(1,1,1)
            local acc = child:FindFirstChild("Frame")
            if acc then acc.Visible = true end
            local glowStroke = Instance.new("UIStroke")
            glowStroke.Color = Color3.fromRGB(100,70,200)
            glowStroke.Thickness = 1
            glowStroke.Transparency = 0.6
            glowStroke.Parent = child
            activeNavBtn = child
            break
        end
    end
end
