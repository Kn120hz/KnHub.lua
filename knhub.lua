-- Kn Script Hub (versão moderna, com sections minimizáveis, ESP com health+name e team check, aimbot team check)
-- Aviso: parentar no CoreGui normalmente exige exploit; use com cautela.

--[[ -------------------------
    CONFIG / APARÊNCIA
----------------------------]]
local HUB_NAME = "Kn Script Hub"
local HUB_WIDTH, HUB_HEIGHT = 340, 520
local THEME = {
    bg = Color3.fromRGB(18,18,20),
    panel = Color3.fromRGB(28,28,30),
    accent = Color3.fromRGB(120, 86, 255), -- roxo moderno
    text = Color3.fromRGB(240,240,245),
    button_on = Color3.fromRGB(220,60,60),
    button_off = Color3.fromRGB(40,150,80)
}

--[[ -------------------------
    UTILS
----------------------------]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function clamp(val, a, b)
    if val < a then return a end
    if val > b then return b end
    return val
end

local function isAlive(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function isEnemy(localP, other)
    -- Team check using Team + TeamColor fallback
    if not localP or not other then return false end
    if not localP.Team or not other.Team then
        return localP.TeamColor ~= other.TeamColor
    end
    return localP.Team ~= other.Team
end

-- safe Drawing availability check
local DrawingAvailable = pcall(function() return Drawing end)

--[[ -------------------------
    GUI CREATION
----------------------------]]
local hub = Instance.new("ScreenGui")
hub.Name = HUB_NAME
hub.ResetOnSpawn = false
hub.Parent = game:GetService("CoreGui") -- cuidado: normalmente exploit

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, HUB_WIDTH, 0, HUB_HEIGHT)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = THEME.bg
frame.BorderSizePixel = 0
frame.Parent = hub
frame.Active = true

-- Title bar
local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 48)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = THEME.panel
title.BorderSizePixel = 0
title.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = HUB_NAME
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = THEME.text
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = title

-- Close & minimize buttons
local function makeTitleButton(text, posX)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 36, 0, 28)
    b.Position = UDim2.new(1, posX, 0, 10)
    b.BackgroundColor3 = THEME.panel
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.TextColor3 = THEME.text
    b.Parent = title
    return b
end

local minimizeMainBtn = makeTitleButton("_", -46)
local closeBtn = makeTitleButton("X", -8)

-- Content holder
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 1, -64)
content.Position = UDim2.new(0, 6, 0, 56)
content.BackgroundTransparency = 1
content.Parent = frame

-- Simple section factory (with collapse)
local function createSection(name, y)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 110)
    container.Position = UDim2.new(0, 0, 0, y)
    container.BackgroundColor3 = THEME.panel
    container.BorderSizePixel = 0
    container.Parent = content

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundTransparency = 1
    header.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 15
    label.TextColor3 = THEME.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = header

    local collapseBtn = Instance.new("TextButton")
    collapseBtn.Size = UDim2.new(0, 28, 0, 28)
    collapseBtn.Position = UDim2.new(1, -44, 0, 4)
    collapseBtn.BackgroundColor3 = THEME.panel
    collapseBtn.BorderSizePixel = 0
    collapseBtn.Text = "▾"
    collapseBtn.Font = Enum.Font.Gotham
    collapseBtn.TextSize = 14
    collapseBtn.TextColor3 = THEME.text
    collapseBtn.Parent = header

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -16, 0, 70)
    holder.Position = UDim2.new(0, 8, 0, 36)
    holder.BackgroundTransparency = 1
    holder.Parent = container

    -- collapse state
    local collapsed = false
    collapseBtn.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        if collapsed then
            holder.Visible = false
            container.Size = UDim2.new(1, 0, 0, 36)
            collapseBtn.Text = "▸"
        else
            holder.Visible = true
            container.Size = UDim2.new(1, 0, 0, 110)
            collapseBtn.Text = "▾"
        end
    end)

    return {
        Container = container,
        Header = header,
        Holder = holder,
        CollapseBtn = collapseBtn
    }
end

-- Create sections: Aimbot, ESP, FOV, POV
local secAimbot = createSection("Aimbot", 0)
local secESP = createSection("ESP", 120)
local secFOV = createSection("FOV", 240)
local secPOV = createSection("POV", 360)

-- Minor helper to create labelled toggle
local function makeToggle(parent, text, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.55, -6, 0, 28)
    lbl.Position = UDim2.new(0, 6, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = THEME.text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4, 0, 0, 28)
    btn.Position = UDim2.new(0.58, 0, 0, y)
    btn.BackgroundColor3 = THEME.button_off
    btn.BorderSizePixel = 0
    btn.Text = "Ativar"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = THEME.text
    btn.Parent = parent

    return lbl, btn
end

-- Helper to create input boxes
local function makeInput(parent, text, y, default)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.45, -6, 0, 28)
    lbl.Position = UDim2.new(0, 6, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = THEME.text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.5, 0, 0, 28)
    box.Position = UDim2.new(0.5, 12, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(245,245,247)
    box.BorderSizePixel = 0
    box.Text = tostring(default or "")
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.TextColor3 = Color3.fromRGB(20,20,20)
    box.Parent = parent

    return lbl, box
end

-- Aimbot UI
local aimLabel, aimToggleBtn = makeToggle(secAimbot.Holder, "Aimbot", 6)
local aimTeamLabel = Instance.new("TextLabel")
aimTeamLabel.Size = UDim2.new(0.5, -6, 0, 24)
aimTeamLabel.Position = UDim2.new(0, 6, 0, 40)
aimTeamLabel.BackgroundTransparency = 1
aimTeamLabel.Text = "Team Check:"
aimTeamLabel.Font = Enum.Font.Gotham
aimTeamLabel.TextSize = 13
aimTeamLabel.TextColor3 = THEME.text
aimTeamLabel.TextXAlignment = Enum.TextXAlignment.Left
aimTeamLabel.Parent = secAimbot.Holder

local aimTeamDropdown = Instance.new("TextButton")
aimTeamDropdown.Size = UDim2.new(0.45, 0, 0, 24)
aimTeamDropdown.Position = UDim2.new(0.52, 6, 0, 40)
aimTeamDropdown.BackgroundColor3 = THEME.panel
aimTeamDropdown.BorderSizePixel = 0
aimTeamDropdown.Text = "Inimigos Apenas"
aimTeamDropdown.Font = Enum.Font.Gotham
aimTeamDropdown.TextSize = 13
aimTeamDropdown.TextColor3 = THEME.text
aimTeamDropdown.Parent = secAimbot.Holder

-- Aim pull + fov inputs in aimbot
local _, pullBox = makeInput(secAimbot.Holder, "Smooth (0-100):", 68, 60)
local _, aimFovBox = makeInput(secAimbot.Holder, "Aim FOV px:", 68, 200)
pullBox.Size = UDim2.new(0.28, 0, 0, 24)
pullBox.Position = UDim2.new(0.52, 6, 0, 68)
aimFovBox.Size = UDim2.new(0.28, 0, 0, 24)
aimFovBox.Position = UDim2.new(0.82, -12, 0, 68)

-- ESP UI
local espLabel, espToggleBtn = makeToggle(secESP.Holder, "ESP", 6)
local espTeamLabel = Instance.new("TextLabel")
espTeamLabel.Size = UDim2.new(0.5, -6, 0, 24)
espTeamLabel.Position = UDim2.new(0, 6, 0, 40)
espTeamLabel.BackgroundTransparency = 1
espTeamLabel.Text = "Mostrar:"
espTeamLabel.Font = Enum.Font.Gotham
espTeamLabel.TextSize = 13
espTeamLabel.TextColor3 = THEME.text
espTeamLabel.TextXAlignment = Enum.TextXAlignment.Left
espTeamLabel.Parent = secESP.Holder

local espTeamDropdown = Instance.new("TextButton")
espTeamDropdown.Size = UDim2.new(0.45, 0, 0, 24)
espTeamDropdown.Position = UDim2.new(0.52, 6, 0, 40)
espTeamDropdown.BackgroundColor3 = THEME.panel
espTeamDropdown.BorderSizePixel = 0
espTeamDropdown.Text = "Inimigos Apenas"
espTeamDropdown.Font = Enum.Font.Gotham
espTeamDropdown.TextSize = 13
espTeamDropdown.TextColor3 = THEME.text
espTeamDropdown.Parent = secESP.Holder

local _, espRangeBox = makeInput(secESP.Holder, "ESP Range px:", 68, 100)
espRangeBox.Size = UDim2.new(0.28, 0, 0, 24)
espRangeBox.Position = UDim2.new(0.52, 6, 0, 68)

-- FOV UI (only visual slider input)
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.5, -6, 0, 28)
fovLabel.Position = UDim2.new(0, 6, 0, 6)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "Camera FOV:"
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 14
fovLabel.TextColor3 = THEME.text
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = secFOV.Holder

local fovBox = Instance.new("TextBox")
fovBox.Size = UDim2.new(0.45, 0, 0, 28)
fovBox.Position = UDim2.new(0.5, 12, 0, 6)
fovBox.BackgroundColor3 = Color3.fromRGB(245,245,247)
fovBox.BorderSizePixel = 0
fovBox.Text = "70"
fovBox.Font = Enum.Font.Gotham
fovBox.TextSize = 14
fovBox.TextColor3 = Color3.fromRGB(20,20,20)
fovBox.Parent = secFOV.Holder

-- POV UI
local povLabel = Instance.new("TextLabel")
povLabel.Size = UDim2.new(0.5, -6, 0, 28)
povLabel.Position = UDim2.new(0, 6, 0, 6)
povLabel.BackgroundTransparency = 1
povLabel.Text = "Mostrar POV Circle:"
povLabel.Font = Enum.Font.Gotham
povLabel.TextSize = 14
povLabel.TextColor3 = THEME.text
povLabel.TextXAlignment = Enum.TextXAlignment.Left
povLabel.Parent = secPOV.Holder

local povToggle = Instance.new("TextButton")
povToggle.Size = UDim2.new(0.45, 0, 0, 28)
povToggle.Position = UDim2.new(0.5, 12, 0, 6)
povToggle.BackgroundColor3 = THEME.button_off
povToggle.BorderSizePixel = 0
povToggle.Text = "Ativar"
povToggle.Font = Enum.Font.GothamBold
povToggle.TextSize = 13
povToggle.TextColor3 = THEME.text
povToggle.Parent = secPOV.Holder

local _, povRadiusBox = makeInput(secPOV.Holder, "Radius px:", 40, 150)
povRadiusBox.Size = UDim2.new(0.28, 0, 0, 24)
povRadiusBox.Position = UDim2.new(0.52, 6, 0, 40)

-- MAIN state
local STATE = {
    aimbotEnabled = false,
    aimbotMode = "Inimigos Apenas", -- or "Todos"
    aimbotPull = 60,
    aimbotAimFov = 200, -- px radius for target pick
    espEnabled = false,
    espMode = "Inimigos Apenas", -- or "Aliados e Inimigos"
    espRange = 100,
    povEnabled = false,
    povRadius = 150
}

-- Dropdown toggles (simple cycle)
aimTeamDropdown.MouseButton1Click:Connect(function()
    if STATE.aimbotMode == "Inimigos Apenas" then
        STATE.aimbotMode = "Todos"
    else
        STATE.aimbotMode = "Inimigos Apenas"
    end
    aimTeamDropdown.Text = STATE.aimbotMode
end)

espTeamDropdown.MouseButton1Click:Connect(function()
    if STATE.espMode == "Inimigos Apenas" then
        STATE.espMode = "Aliados e Inimigos"
    else
        STATE.espMode = "Inimigos Apenas"
    end
    espTeamDropdown.Text = STATE.espMode
end)

-- Toggle buttons logic
local function bindToggleButton(btn, stateKey)
    btn.MouseButton1Click:Connect(function()
        STATE[stateKey] = not STATE[stateKey]
        if STATE[stateKey] then
            btn.BackgroundColor3 = THEME.button_on
            btn.Text = "Desativar"
        else
            btn.BackgroundColor3 = THEME.button_off
            btn.Text = "Ativar"
        end
    end)
end

bindToggleButton(aimToggleBtn, "aimbotEnabled")
bindToggleButton(espToggleBtn, "espEnabled")
bindToggleButton(povToggle, "povEnabled")

-- Inputs validation
pullBox.FocusLost:Connect(function()
    local n = tonumber(pullBox.Text)
    if n then STATE.aimbotPull = clamp(math.floor(n), 0, 100) end
    pullBox.Text = tostring(STATE.aimbotPull)
end)
aimFovBox.FocusLost:Connect(function()
    local n = tonumber(aimFovBox.Text)
    if n then STATE.aimbotAimFov = clamp(math.floor(n), 10, 1000) end
    aimFovBox.Text = tostring(STATE.aimbotAimFov)
end)
espRangeBox.FocusLost:Connect(function()
    local n = tonumber(espRangeBox.Text)
    if n then STATE.espRange = clamp(math.floor(n), 10, 2000) end
    espRangeBox.Text = tostring(STATE.espRange)
end)
fovBox.FocusLost:Connect(function()
    local n = tonumber(fovBox.Text)
    if n then
        workspace.CurrentCamera.FieldOfView = clamp(n, 1, 120)
    end
    fovBox.Text = tostring(workspace.CurrentCamera.FieldOfView)
end)
povRadiusBox.FocusLost:Connect(function()
    local n = tonumber(povRadiusBox.Text)
    if n then STATE.povRadius = clamp(math.floor(n), 10, 1000) end
    povRadiusBox.Text = tostring(STATE.povRadius)
end)

-- Title drag
local function makeDraggable(dragGui)
    local dragging, dragInput, dragStart, startPos
    dragGui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    dragGui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging and dragStart and startPos then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(title)

-- Main minimize / close
minimizeMainBtn.MouseButton1Click:Connect(function()
    if frame.Size.Y.Offset > 48 then
        frame.Size = UDim2.new(0, HUB_WIDTH, 0, 48)
    else
        frame.Size = UDim2.new(0, HUB_WIDTH, 0, HUB_HEIGHT)
    end
end)
closeBtn.MouseButton1Click:Connect(function()
    frame.Enabled = false
    hub:Destroy()
end)

--[[ -------------------------
    DRAWING / ESP IMPLEMENTATION
----------------------------]]
-- Reuse objects per player
local ESP_TABLE = {} -- { [player] = { box = Drawing, name = Drawing, hpBar = Drawing, hpBack = Drawing } }

local function createESPForPlayer(plr)
    if not DrawingAvailable then return end
    if ESP_TABLE[plr] then return ESP_TABLE[plr] end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Visible = false
    name.Outline = true

    local hpBack = Drawing.new("Square")
    hpBack.Filled = true
    hpBack.Thickness = 0
    hpBack.Visible = false
    hpBack.Color = Color3.fromRGB(40,40,40)

    local hpBar = Drawing.new("Square")
    hpBar.Filled = true
    hpBar.Thickness = 0
    hpBar.Visible = false
    hpBar.Color = Color3.fromRGB(0, 220, 0) -- verde

    ESP_TABLE[plr] = {
        box = box,
        name = name,
        hpBack = hpBack,
        hpBar = hpBar
    }
    return ESP_TABLE[plr]
end

-- Cleanup on player removing
Players.PlayerRemoving:Connect(function(plr)
    local rec = ESP_TABLE[plr]
    if rec then
        if rec.box then pcall(function() rec.box:Remove() end) end
        if rec.name then pcall(function() rec.name:Remove() end) end
        if rec.hpBack then pcall(function() rec.hpBack:Remove() end) end
        if rec.hpBar then pcall(function() rec.hpBar:Remove() end) end
        ESP_TABLE[plr] = nil
    end
end)

-- Simple target finder (within pixel radius) with team check
local function findTarget()
    if not LocalPlayer then return nil end
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local best, bestDist = nil, math.huge
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and isAlive(pl) then
            -- Team check according to STATE.aimbotMode
            if STATE.aimbotMode == "Inimigos Apenas" then
                if not isEnemy(LocalPlayer, pl) then goto cont end
            end
            local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
            local hum = pl.Character and pl.Character:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then goto cont end
            local screenPos = cam:WorldToViewportPoint(hrp.Position)
            local onScreen = screenPos.Z > 0
            if onScreen then
                local dx = screenPos.X - cam.ViewportSize.X/2
                local dy = screenPos.Y - cam.ViewportSize.Y/2
                local dist = math.sqrt(dx*dx + dy*dy)
                if dist < bestDist and dist <= (STATE.aimbotAimFov or 200) then
                    best = hrp
                    bestDist = dist
                end
            end
        end
        ::cont::
    end
    return best
end

-- Aim at target using lerp for smoothing
local function aimAt(target)
    if not target then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local desired = CFrame.new(cam.CFrame.Position, target.Position)
    local t = clamp((STATE.aimbotPull or 60)/100, 0, 1)
    cam.CFrame = cam.CFrame:Lerp(desired, t)
end

-- ESP update function
local function updateESPForPlayer(plr)
    if not DrawingAvailable then return end
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
        local rec = ESP_TABLE[plr]
        if rec then
            rec.box.Visible = false
            rec.name.Visible = false
            rec.hpBar.Visible = false
            rec.hpBack.Visible = false
        end
        return
    end
    -- team filter
    if STATE.espMode == "Inimigos Apenas" and not isEnemy(LocalPlayer, plr) then
        local rec = ESP_TABLE[plr]
        if rec then
            rec.box.Visible = false
            rec.name.Visible = false
            rec.hpBar.Visible = false
            rec.hpBack.Visible = false
        end
        return
    end

    local rec = createESPForPlayer(plr)
    local cam = workspace.CurrentCamera
    local hrp = plr.Character.HumanoidRootPart
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not cam or not hrp or not hum then return end

    local screenPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
    if not onScreen or screenPos.Z <= 0 then
        rec.box.Visible = false
        rec.name.Visible = false
        rec.hpBar.Visible = false
        rec.hpBack.Visible = false
        return
    end

    -- Determine color based on team (enemy red, ally blue)
    local color = isEnemy(LocalPlayer, plr) and Color3.fromRGB(220,60,60) or Color3.fromRGB(60,130,220)
    rec.box.Color = color
    rec.name.Color = THEME.text
    rec.name.Text = plr.Name

    -- compute box size (simple vertical box)
    local h = 90
    local w = 36
    local x = screenPos.X - w/2
    local y = screenPos.Y - h/2

    rec.box.Size = Vector2.new(w, h)
    rec.box.Position = Vector2.new(x, y)
    rec.box.Visible = STATE.espEnabled

    -- Name above
    rec.name.Position = Vector2.new(screenPos.X, y - 10)
    rec.name.Size = 16
    rec.name.Center = true
    rec.name.Visible = STATE.espEnabled

    -- Health bar (left side of the box)
    local maxHp = hum.MaxHealth > 0 and hum.MaxHealth or 100
    local curHp = clamp(hum.Health, 0, maxHp)
    local hpPerc = curHp / maxHp

    local barW = 4
    local barH = h * hpPerc
    -- background bar (full height)
    rec.hpBack.Size = Vector2.new(barW, h)
    rec.hpBack.Position = Vector2.new(x - 8, y)
    rec.hpBack.Visible = STATE.espEnabled
    rec.hpBack.Color = Color3.fromRGB(40,40,40)

    -- hp bar (bottom aligned)
    rec.hpBar.Size = Vector2.new(barW, barH)
    rec.hpBar.Position = Vector2.new(x - 8, y + (h - barH))
    rec.hpBar.Visible = STATE.espEnabled
    rec.hpBar.Color = Color3.fromRGB(0, 220, 0)
end

--[[ -------------------------
    MAIN LOOP
----------------------------]]
-- POV circle (single)
local povCircle = nil
if DrawingAvailable then
    povCircle = Drawing.new("Circle")
    povCircle.Radius = STATE.povRadius or 150
    povCircle.Filled = false
    povCircle.Thickness = 2
    povCircle.Color = THEME.accent
    povCircle.Visible = false
end

RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam or not LocalPlayer then return end

    -- Update POV
    if povCircle then
        povCircle.Visible = STATE.povEnabled
        if STATE.povEnabled then
            povCircle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
            povCircle.Radius = STATE.povRadius or povCircle.Radius
        end
    end

    -- Aimbot
    if STATE.aimbotEnabled then
        -- find target and aim
        local tgt = findTarget()
        if tgt then
            aimAt(tgt)
        end
    end

    -- ESP update
    if STATE.espEnabled then
        for _, pl in pairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer then
                updateESPForPlayer(pl)
            end
        end
    else
        -- ensure all hidden when disabled
        for pl, rec in pairs(ESP_TABLE) do
            if rec then
                rec.box.Visible = false
                rec.name.Visible = false
                rec.hpBar.Visible = false
                rec.hpBack.Visible = false
            end
        end
    end
end)

-- initial camera fov set
pcall(function() workspace.CurrentCamera.FieldOfView = tonumber(fovBox.Text) or workspace.CurrentCamera.FieldOfView end)

-- Finish: small polish - set defaults visible states
aimToggleBtn.BackgroundColor3 = STATE.aimbotEnabled and THEME.button_on or THEME.button_off
espToggleBtn.BackgroundColor3 = STATE.espEnabled and THEME.button_on or THEME.button_off
povToggle.BackgroundColor3 = STATE.povEnabled and THEME.button_on or THEME.button_off
aimToggleBtn.Text = STATE.aimbotEnabled and "Desativar" or "Ativar"
espToggleBtn.Text = STATE.espEnabled and "Desativar" or "Ativar"
povToggle.Text = STATE.povEnabled and "Desativar" or "Ativar"

-- End of script
