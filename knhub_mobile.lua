-- KnHub (Mobile-friendly) - compatible with Delta Mobile executors
-- ESP via BillboardGui, PlayerGui parent, Aimbot with team check, minimizable UI
-- Use responsibly; this is an exploit and can lead to bans.

-- CONFIG
local HUB_NAME = "KnHub"
local THEME = {
    bg = Color3.fromRGB(20,20,22),
    panel = Color3.fromRGB(32,32,34),
    accent = Color3.fromRGB(120,86,255),
    text = Color3.fromRGB(235,235,240),
    on = Color3.fromRGB(220,60,60),
    off = Color3.fromRGB(60,160,80)
}
local DEFAULTS = {
    aimSmooth = 60, -- 0-100
    aimFovPx = 220,
    espRange = 1200,
    povRadius = 150
}

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    warn("KnHub: LocalPlayer not found (script must run as LocalScript).")
    return
end

-- SAFE PARENT (PlayerGui)
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- STATE
local STATE = {
    aimbotEnabled = false,
    aimbotMode = "Inimigos Apenas", -- "Todos"
    aimSmooth = DEFAULTS.aimSmooth,
    aimFovPx = DEFAULTS.aimFovPx,
    espEnabled = false,
    espMode = "Inimigos Apenas", -- "Aliados e Inimigos"
    espRange = DEFAULTS.espRange,
    povEnabled = false,
    povRadius = DEFAULTS.povRadius
}

-- UTIL
local function clamp(n,a,b) if n<a then return a end if n>b then return b end return n end
local function isAlive(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end
local function isEnemy(localP, other)
    if not localP or not other then return false end
    if not localP.Team or not other.Team then
        return localP.TeamColor ~= other.TeamColor
    end
    return localP.Team ~= other.Team
end

-- GUI CREATE
local screenGui = Instance.new("ScreenGui")
screenGui.Name = HUB_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "HubFrame"
frame.Size = UDim2.new(0, 340, 0, 480)
frame.Position = UDim2.new(0, 12, 0, 12)
frame.BackgroundColor3 = THEME.bg
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true

local title = Instance.new("Frame")
title.Size = UDim2.new(1,0,0,48)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundColor3 = THEME.panel
title.BorderSizePixel = 0
title.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,-120,1,0)
titleLabel.Position = UDim2.new(0,12,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = HUB_NAME
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = THEME.text
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = title

local function makeTitleBtn(txt, xOffset)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,36,0,28)
    b.Position = UDim2.new(1,xOffset,0,10)
    b.BackgroundColor3 = THEME.panel
    b.BorderSizePixel = 0
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.TextColor3 = THEME.text
    b.Parent = title
    return b
end

local minimizeMainBtn = makeTitleBtn("_", -84)
local closeBtn = makeTitleBtn("X", -40)

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-12,1, -64)
content.Position = UDim2.new(0,6,0,56)
content.BackgroundTransparency = 1
content.Parent = frame

-- Section factory (mobile friendly)
local function createSection(titleText, y)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,0,110)
    container.Position = UDim2.new(0,0,0,y)
    container.BackgroundColor3 = THEME.panel
    container.BorderSizePixel = 0
    container.Parent = content

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1,0,0,36)
    header.Position = UDim2.new(0,0,0,0)
    header.BackgroundTransparency = 1
    header.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-70,1,0)
    label.Position = UDim2.new(0,12,0,0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextColor3 = THEME.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = header

    local collapse = Instance.new("TextButton")
    collapse.Size = UDim2.new(0,28,0,28)
    collapse.Position = UDim2.new(1,-44,0,4)
    collapse.BackgroundColor3 = THEME.panel
    collapse.BorderSizePixel = 0
    collapse.Text = "▾"
    collapse.Font = Enum.Font.Gotham
    collapse.TextSize = 14
    collapse.TextColor3 = THEME.text
    collapse.Parent = header

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1,-16,0,70)
    holder.Position = UDim2.new(0,8,0,36)
    holder.BackgroundTransparency = 1
    holder.Parent = container

    local collapsed = false
    collapse.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        if collapsed then
            holder.Visible = false
            container.Size = UDim2.new(1,0,0,36)
            collapse.Text = "▸"
        else
            holder.Visible = true
            container.Size = UDim2.new(1,0,0,110)
            collapse.Text = "▾"
        end
    end)

    return {Container = container, Holder = holder, Collapse = collapse}
end

local secA = createSection("Aimbot", 0)
local secE = createSection("ESP", 120)
local secF = createSection("FOV", 240)
local secP = createSection("POV", 360)

-- UI helpers
local function makeToggle(parent, text, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.55,-6,0,28)
    lbl.Position = UDim2.new(0,6,0,y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = THEME.text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4,0,0,28)
    btn.Position = UDim2.new(0.58,0,0,y)
    btn.BackgroundColor3 = THEME.off
    btn.BorderSizePixel = 0
    btn.Text = "Ativar"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = THEME.text
    btn.Parent = parent

    return lbl, btn
end

local function makeInput(parent, text, y, default)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.45,-6,0,28)
    lbl.Position = UDim2.new(0,6,0,y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = THEME.text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.5,0,0,28)
    box.Position = UDim2.new(0.5,12,0,y)
    box.BackgroundColor3 = Color3.fromRGB(245,245,247)
    box.BorderSizePixel = 0
    box.Text = tostring(default or "")
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextColor3 = Color3.fromRGB(20,20,20)
    box.Parent = parent

    return lbl, box
end

-- Aimbot UI
local _, aimbtn = makeToggle(secA.Holder, "Aimbot", 6)
local aimModeBtn = Instance.new("TextButton")
aimModeBtn.Size = UDim2.new(0.45,0,0,24)
aimModeBtn.Position = UDim2.new(0.52,6,0,40)
aimModeBtn.BackgroundColor3 = THEME.panel
aimModeBtn.BorderSizePixel = 0
aimModeBtn.Text = "Inimigos Apenas"
aimModeBtn.Font = Enum.Font.Gotham
aimModeBtn.TextSize = 12
aimModeBtn.TextColor3 = THEME.text
aimModeBtn.Parent = secA.Holder

local _, pullBox = makeInput(secA.Holder, "Smooth (0-100):", 68, DEFAULTS.aimSmooth)
local _, aimFovBox = makeInput(secA.Holder, "Aim FOV px:", 68, DEFAULTS.aimFovPx)
pullBox.Size = UDim2.new(0.28,0,0,24); pullBox.Position = UDim2.new(0.52,6,0,68)
aimFovBox.Size = UDim2.new(0.28,0,0,24); aimFovBox.Position = UDim2.new(0.82,-12,0,68)

-- ESP UI
local _, espbtn = makeToggle(secE.Holder, "ESP (Billboard)", 6)
local espModeBtn = Instance.new("TextButton")
espModeBtn.Size = UDim2.new(0.45,0,0,24)
espModeBtn.Position = UDim2.new(0.52,6,0,40)
espModeBtn.BackgroundColor3 = THEME.panel
espModeBtn.BorderSizePixel = 0
espModeBtn.Text = "Inimigos Apenas"
espModeBtn.Font = Enum.Font.Gotham
espModeBtn.TextSize = 12
espModeBtn.TextColor3 = THEME.text
espModeBtn.Parent = secE.Holder

local _, espRangeBox = makeInput(secE.Holder, "ESP Range studs:", 68, DEFAULTS.espRange)
espRangeBox.Size = UDim2.new(0.28,0,0,24); espRangeBox.Position = UDim2.new(0.52,6,0,68)

-- FOV UI
local fovLbl, fovBox = makeInput(secF.Holder, "Camera FOV:", 6, tostring(math.floor(workspace.CurrentCamera.FieldOfView or 70)))
fovBox.Size = UDim2.new(0.45,0,0,28); fovBox.Position = UDim2.new(0.5,12,0,6)

-- POV UI
local _, povbtn = makeToggle(secP.Holder, "Mostrar POV Circle (visual)", 6)
local _, povRadiusBox = makeInput(secP.Holder, "Radius px:", 40, DEFAULTS.povRadius)
povRadiusBox.Size = UDim2.new(0.28,0,0,24); povRadiusBox.Position = UDim2.new(0.52,6,0,40)

-- Bind UI interactions
local function bindToggle(btn, stateKey)
    btn.MouseButton1Click:Connect(function()
        STATE[stateKey] = not STATE[stateKey]
        btn.BackgroundColor3 = STATE[stateKey] and THEME.on or THEME.off
        btn.Text = STATE[stateKey] and "Desativar" or "Ativar"
    end)
end
bindToggle(aimbtn, "aimbotEnabled")
bindToggle(espbtn, "espEnabled")
bindToggle(povbtn, "povEnabled")

aimModeBtn.MouseButton1Click:Connect(function()
    if STATE.aimbotMode == "Inimigos Apenas" then STATE.aimbotMode = "Todos" else STATE.aimbotMode = "Inimigos Apenas" end
    aimModeBtn.Text = STATE.aimbotMode
end)
espModeBtn.MouseButton1Click:Connect(function()
    if STATE.espMode == "Inimigos Apenas" then STATE.espMode = "Aliados e Inimigos" else STATE.espMode = "Inimigos Apenas" end
    espModeBtn.Text = STATE.espMode
end)

pullBox.FocusLost:Connect(function()
    local n = tonumber(pullBox.Text)
    if n then STATE.aimSmooth = clamp(math.floor(n), 0, 100) end
    pullBox.Text = tostring(STATE.aimSmooth)
end)
aimFovBox.FocusLost:Connect(function()
    local n = tonumber(aimFovBox.Text)
    if n then STATE.aimFovPx = clamp(math.floor(n), 10, 2000) end
    aimFovBox.Text = tostring(STATE.aimFovPx)
end)
espRangeBox.FocusLost:Connect(function()
    local n = tonumber(espRangeBox.Text)
    if n then STATE.espRange = clamp(math.floor(n), 10, 10000) end
    espRangeBox.Text = tostring(STATE.espRange)
end)
fovBox.FocusLost:Connect(function()
    local n = tonumber(fovBox.Text)
    if n then workspace.CurrentCamera.FieldOfView = clamp(n, 1, 120) end
    fovBox.Text = tostring(workspace.CurrentCamera.FieldOfView)
end)
povRadiusBox.FocusLost:Connect(function()
    local n = tonumber(povRadiusBox.Text)
    if n then STATE.povRadius = clamp(math.floor(n), 10, 2000) end
    povRadiusBox.Text = tostring(STATE.povRadius)
end)

-- Minimize and close behavior
minimizeMainBtn.MouseButton1Click:Connect(function()
    if frame.Size.Y.Offset > 48 then
        frame.Size = UDim2.new(0,340,0,48)
    else
        frame.Size = UDim2.new(0,340,0,480)
    end
end)
closeBtn.MouseButton1Click:Connect(function()
    pcall(function() screenGui:Destroy() end)
end)

-- Dragging (touch friendly)
local function makeDraggable(dragTarget)
    local dragging, dragInput, dragStart, startPos
    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragTarget.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
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

-- ESP Implementation (BillboardGui per player)
local ESP = {} -- map player -> { billboard, nameLabel, hpBar, hpBack }

local function createBillboardForPlayer(plr)
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if ESP[plr] then return ESP[plr] end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "KnHub_ESP"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.6, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = playerGui -- billboards can be parented to PlayerGui or CoreGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,18)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = THEME.text
    nameLabel.TextStrokeTransparency = 0.7
    nameLabel.Parent = billboard

    local hpBack = Instance.new("Frame")
    hpBack.Size = UDim2.new(1, -20, 0, 8)
    hpBack.Position = UDim2.new(0,10,0,22)
    hpBack.BackgroundColor3 = Color3.fromRGB(50,50,50)
    hpBack.BorderSizePixel = 0
    hpBack.AnchorPoint = Vector2.new(0.5,0)
    hpBack.Parent = billboard

    local hpBar = Instance.new("Frame")
    hpBar.Size = UDim2.new(1,0,1,0)
    hpBar.Position = UDim2.new(0,0,0,0)
    hpBar.BackgroundColor3 = Color3.fromRGB(0,220,0)
    hpBar.BorderSizePixel = 0
    hpBar.Parent = hpBack

    ESP[plr] = {
        billboard = billboard,
        nameLabel = nameLabel,
        hpBack = hpBack,
        hpBar = hpBar
    }
    return ESP[plr]
end

local function removeESP(plr)
    local rec = ESP[plr]
    if rec then
        pcall(function()
            if rec.billboard then rec.billboard:Destroy() end
        end)
        ESP[plr] = nil
    end
end

Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)

-- Target selection for aimbot
local function findTarget()
    local cam = workspace.CurrentCamera
    if not cam or not LocalPlayer.Character then return nil end
    local best, bestDist = nil, math.huge
    for _,pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and isAlive(pl) then
            if STATE.aimbotMode == "Inimigos Apenas" and not isEnemy(LocalPlayer, pl) then goto cont end
            local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then goto cont end
            local pos = cam:WorldToViewportPoint(hrp.Position)
            if pos.Z > 0 then
                local dx = pos.X - cam.ViewportSize.X/2
                local dy = pos.Y - cam.ViewportSize.Y/2
                local dist = math.sqrt(dx*dx + dy*dy)
                if dist < bestDist and dist <= (STATE.aimFovPx or DEFAULTS.aimFovPx) then
                    best = hrp
                    bestDist = dist
                end
            end
        end
        ::cont::
    end
    return best
end

-- Aim function (safe)
local function aimAtTarget(target)
    if not target then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local ok, err = pcall(function()
        local desired = CFrame.new(cam.CFrame.Position, target.Position)
        local t = clamp((STATE.aimSmooth or 60)/100, 0, 1)
        cam.CFrame = cam.CFrame:Lerp(desired, t)
    end)
    if not ok then
        -- executor may block camera manipulation; ignore silently
    end
end

-- MAIN loop: update ESP + aimbot
RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam or not LocalPlayer then return end

    -- Aimbot
    if STATE.aimbotEnabled then
        local tgt = findTarget()
        if tgt then
            aimAtTarget(tgt)
        end
    end

    -- ESP
    if STATE.espEnabled then
        for _,pl in pairs(Players:GetPlayers()) do
            if pl == LocalPlayer then
                removeESP(pl)
            else
                if STATE.espMode == "Inimigos Apenas" and not isEnemy(LocalPlayer, pl) then
                    removeESP(pl)
                else
                    if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                        local rec = createBillboardForPlayer(pl)
                        if rec then
                            rec.nameLabel.Text = pl.Name
                            local color = isEnemy(LocalPlayer, pl) and Color3.fromRGB(220,60,60) or Color3.fromRGB(60,130,220)
                            rec.nameLabel.TextColor3 = color

                            local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                            if hum then
                                local maxH = hum.MaxHealth > 0 and hum.MaxHealth or 100
                                local cur = clamp(hum.Health, 0, maxH)
                                local pct = cur / maxH
                                rec.hpBar.Size = UDim2.new(pct,0,1,0)
                            end

                            rec.billboard.AlwaysOnTop = true
                            rec.billboard.Enabled = true
                        end
                    else
                        removeESP(pl)
                    end
                end
            end
        end
    else
        for pl,rec in pairs(ESP) do
            if rec and rec.billboard then
                rec.billboard.Enabled = false
            end
        end
    end
end)

-- hide by default visuals
aimbtn.BackgroundColor3 = STATE.aimbotEnabled and THEME.on or THEME.off
espbtn.BackgroundColor3 = STATE.espEnabled and THEME.on or THEME.off
povbtn.BackgroundColor3 = STATE.povEnabled and THEME.on or THEME.off
aimbtn.Text = STATE.aimbotEnabled and "Desativar" or "Ativar"
espbtn.Text = STATE.espEnabled and "Desativar" or "Ativar"
povbtn.Text = STATE.povEnabled and "Desativar" or "Ativar"

print("KnHub (mobile) initialized. Aimbot:", STATE.aimbotEnabled, "ESP:", STATE.espEnabled)

-- End of script
