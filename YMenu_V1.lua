
--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

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
        ["PRESTIGE_TEXT"] = "Престиж: "
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
        ["PRESTIGE_TEXT"] = "Prestige: "
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
    ["Jotaro"] = {TalkName = "Chumbo", BossName = "Jotaro Kujo"}
}

--// GUI (RESTORED TO FULL VERBOSE STYLE)
local gui = Instance.new("ScreenGui")
gui.Name = "StandFarmUltimateV64_MAX_VERBOSE"
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,550,0,450)
frame.Position = UDim2.new(0.5,-275,0.5,-225)
frame.BackgroundColor3 = Color3.fromRGB(20,22,30)
frame.Active = true
frame.ClipsDescendants = true
frame.ZIndex = 110
frame.Parent = gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0,12)
uiCorner.Parent = frame

-- SMART CLICKER HOVER DETECTION
frame.MouseEnter:Connect(function() 
    isHoveringMenu = true 
end)
frame.MouseLeave:Connect(function() 
    isHoveringMenu = false 
end)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,40)
topBar.BackgroundColor3 = Color3.fromRGB(25,27,35)
topBar.Active = true
topBar.ZIndex = 115
topBar.Parent = frame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0,12)
topBarCorner.Parent = topBar

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
sidebar.BackgroundColor3 = Color3.fromRGB(15,17,25)
sidebar.ZIndex = 115
sidebar.Parent = mainContainer

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0,12)
sidebarCorner.Parent = sidebar

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
local function createNav(key, pos, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,38)
    b.Position = UDim2.new(0,10,0,pos)
    b.Text = getLoc(key)
    b.TextSize = 15
    b.BackgroundColor3 = Color3.fromRGB(30,32,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.ZIndex = 150
    b.Parent = sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = b
    
    b.MouseButton1Click:Connect(callback)
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
    container.Size = UDim2.new(1,-40,0,55)
    container.Position = UDim2.new(0,20,0,pos)
    container.BackgroundColor3 = Color3.fromRGB(30,32,40)
    container.Text = getLoc(key)
    container.TextSize = 15
    container.Font = Enum.Font.GothamSemibold
    container.TextColor3 = Color3.new(1,1,1)
    container.TextXAlignment = Enum.TextXAlignment.Left
    container.ZIndex = 120
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = container

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0,100,0,35)
    accent.Position = UDim2.new(1,-110,0.5,-17.5)
    accent.BackgroundColor3 = Color3.fromRGB(200,50,50)
    accent.ZIndex = 125
    accent.Parent = container
    
    local aCorner = Instance.new("UICorner")
    aCorner.CornerRadius = UDim.new(0,10)
    aCorner.Parent = accent

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1,0,1,0)
    status.BackgroundTransparency = 1
    status.Text = "OFF"
    status.TextSize = 16
    status.Font = Enum.Font.GothamBold
    status.TextColor3 = Color3.new(1,1,1)
    status.ZIndex = 130
    status.Parent = accent
    
    table.insert(updatableItems, {Obj = container, Key = key, Type = "Text"})
    local function update(state)
        accent.BackgroundColor3 = state and Color3.fromRGB(60,170,80) or Color3.fromRGB(200,50,50)
        status.Text = state and "ON" or "OFF"
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
    container.Size = UDim2.new(1,-40,0,50); container.Position = UDim2.new(0,20,0,pos); container.BackgroundColor3 = Color3.fromRGB(30,32,40); container.ZIndex = 150; container.Parent = parent
    Instance.new("UICorner",container).CornerRadius = UDim.new(0,10)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = getLoc(titleKey)..": None"; btn.TextSize = 13; btn.Font = Enum.Font.GothamSemibold; btn.TextColor3 = Color3.new(1,1,1); btn.ZIndex = 155; btn.Parent = container

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1,0,0,#options * 40); list.Position = UDim2.new(0,0,1,5); list.BackgroundColor3 = Color3.fromRGB(25,27,33); list.BorderSizePixel = 0; list.Visible = false; list.ZIndex = 1000; list.Parent = container
    Instance.new("UICorner",list).CornerRadius = UDim.new(0,8)

    btn.MouseButton1Click:Connect(function() list.Visible = not list.Visible; container.ZIndex = list.Visible and 200 or 150 end)

    for i, name in pairs(options) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1,0,0,40); opt.Position = UDim2.new(0,0,0,(i-1)*40); opt.BackgroundTransparency = 1; opt.Text = name; opt.TextSize = 14; opt.Font = Enum.Font.Gotham; opt.TextColor3 = Color3.new(0.8,0.8,0.8); opt.ZIndex = 1001; opt.Parent = list
        opt.MouseButton1Click:Connect(function() btn.Text = getLoc(titleKey)..": "..name; list.Visible = false; container.ZIndex = 150; callback(name) end)
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

-- V64: SETUP RAIDS TAB
createSubTitle("SELECT_BOSS", 20, raidsTab)
createDropdown("SELECT_BOSS", {"Avdol", "Kira", "Jotaro"}, 50, raidsTab, function(val) selectedRaidBoss = val end)
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
    local paths = {workspace:FindFirstChild("Npcs"), workspace:FindFirstChild("NPCs"), ReplicatedStorage:FindFirstChild("assets") and ReplicatedStorage.assets:FindFirstChild("npc_cache")}
    for _, f in pairs(paths) do if f and f:FindFirstChild(name) then return f[name] end end
    local live = workspace:FindFirstChild("Live"); if live and live:FindFirstChild(name) then return live[name] end
    for _, v in pairs(workspace:GetDescendants()) do if v.Name == name and v:IsA("Model") then return v end end; return nil
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

task.spawn(function()
    while task.wait(0.3) do
        -- Items ESP
        for _, o in pairs(workspace:GetChildren()) do
            local isArrow = (o.Name == "Stand Arrow" or o:FindFirstChild("Stand Arrow"))
            if espItems and isArrow then 
                applyESP(o, Color3.fromRGB(230,190,0), "Stand Arrow") 
            elseif o:FindFirstChild("V63_HL") then 
                -- Only remove if it was an ESP item before or categories changed
                if not isArrow or not espItems then removeESP(o) end
            end
        end
        
        -- People & NPC ESP
        local live = workspace:FindFirstChild("Live")
        if live then 
            for _, v in pairs(live:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= live:FindFirstChild(player.Name) then
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
        end
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
        if (autoQuest or autoRaid) and currentTarget and not isHoveringMenu then
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
        if (autoQuest or autoRaid) and currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 and not isHoveringMenu and not dragging then
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
    for _, v in pairs(workspace.Live:GetChildren()) do if string.find(v.Name, "Yoshikage Kira") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then return v end end; return nil
end

task.spawn(function()
    while task.wait(0.1) do -- Extreme Speed
        if autoRaid and RAID_BOSSES[selectedRaidBoss] then
            local char = workspace.Live:FindFirstChild(player.Name); local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then local bossData = RAID_BOSSES[selectedRaidBoss]; local found = (selectedRaidBoss == "Kira") and getKiraTarget() or nil
            if not found then for _, v in pairs(workspace.Live:GetChildren()) do if string.find(v.Name, bossData.BossName) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then found = v; break end end end
            if found then currentTarget = found; summonStand(); targetCFrame = found.HumanoidRootPart.CFrame * CFrame.new(0, 9, 0) * CFrame.Angles(-math.pi/2, 0, 0) -- H=9
            else targetCFrame = nil; local npc = findNPC(bossData.TalkName)
            if npc then local tp = npc:GetPivot(); hrp.CFrame = tp * CFrame.new(0,0,-3.5); task.wait(0.5); VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(0.6); VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game); task.wait(0.5)
            for i=1,2 do VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game); task.wait(0.2); VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game); task.wait(0.4) end
            task.wait(1); hrp.CFrame = tp * CFrame.new(0,0,-15); task.wait(0.5); VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game); task.wait(0.2); VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game) end end end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do -- Extreme Speed
        if autoQuest then
            local data = getQuestData(); local char = workspace.Live:FindFirstChild(player.Name); local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if data and hrp then if data.Talk then targetCFrame = nil; currentTarget = nil
            local nextNPC = nil; for npcName, talked in pairs(data.Talk) do if talked == false then nextNPC = npcName; break end end
            local npcObj = findNPC(nextNPC); if npcObj then hrp.CFrame = npcObj:GetPivot() * CFrame.new(0,0,-3.5); task.wait(0.6); VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(0.5); VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game); task.wait(0.4)
            for i=1,7 do if not autoQuest then break end; VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game); task.wait(0.2); VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game); task.wait(0.3) end end
            elseif data.Defeat or data.Kills then local tbl = data.Defeat or data.Kills; local targetStr = nil
            for n, p in pairs(tbl) do if type(p) == "number" and p < 999 then targetStr = n; break elseif type(p) ~= "number" then targetStr = n; break end end
            local enemy = nil; for _, v in pairs(workspace.Live:GetChildren()) do if targetStr and string.find(v.Name, targetStr) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then enemy = v; break end end
            if enemy then currentTarget = enemy; summonStand(); targetCFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 9, 0) * CFrame.Angles(-math.pi/2, 0, 0) -- H=9
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

updateLocale("ENG")
