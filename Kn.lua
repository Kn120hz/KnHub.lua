local LPH_JIT_MAX      = function(f) return f end
local LPH_NO_VIRTUALIZE = function(f) return f end

getgenv().__tomboyhook_loaded = nil

task.spawn(function()
if getgenv().__tomboyhook_loaded then return end
getgenv().__tomboyhook_loaded = true
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)

local Library = (function()
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Library do 
	Library = {
        Theme =  { },
        espfont = nil,

        MenuKeybind = tostring(Enum.KeyCode.RightShift),

        Flags = { },

        Tween = {
            Time = 0.25,
            Style = Enum.EasingStyle.Quart,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,
        _activeSlider = nil,
        _activeColorpicker = nil,

        Folders = {
            Directory = "tomboy.hook",
            Configs = "tomboy.hook/Configs",
            Assets = "tomboy.hook/Assets",
			Sounds = "tomboy.hook/Sounds",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        KeyList = nil,

        Font = nil,
        CopiedColor = nil,
		Fonts = { },
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages
    getgenv().__tbhook_lib = Library
end


gethui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local FromRGB = Color3.fromRGB
local FromHSV = Color3.fromHSV
local FromHex = Color3.fromHex

local RGBSequence = ColorSequence.new
local RGBSequenceKeypoint = ColorSequenceKeypoint.new
local NumSequence = NumberSequence.new
local NumSequenceKeypoint = NumberSequenceKeypoint.new

local UDim2New = UDim2.new
local UDimNew = UDim.new
local UDim2FromOffset = UDim2.fromOffset
local Vector2New = Vector2.new
local Vector3New = Vector3.new

local MathClamp = math.clamp
local MathFloor = math.floor
local MathAbs = math.abs
local MathSin = math.sin

local TableInsert = table.insert
local TableFind = table.find
local TableRemove = table.remove
local TableConcat = table.concat
local TableClone = table.clone
local TableUnpack = table.unpack

local StringFormat = string.format
local StringFind = string.find
local StringGSub = string.gsub
local StringLower = string.lower
local StringLen = string.len

local InstanceNew = Instance.new

local RectNew = Rect.new

local Keys = {
    ["Unknown"]           = "Unknown",
    ["Backspace"]         = "Back",
    ["Tab"]               = "Tab",
    ["Clear"]             = "Clear",
    ["Return"]            = "Return",
    ["Pause"]             = "Pause",
    ["Escape"]            = "Escape",
    ["Space"]             = "Space",
    ["QuotedDouble"]      = '"',
    ["Hash"]              = "#",
    ["Dollar"]            = "$",
    ["Percent"]           = "%",
    ["Ampersand"]         = "&",
    ["Quote"]             = "'",
    ["LeftParenthesis"]   = "(",
    ["RightParenthesis"]  = " )",
    ["Asterisk"]          = "*",
    ["Plus"]              = "+",
    ["Comma"]             = ",",
    ["Minus"]             = "-",
    ["Period"]            = ".",
    ["Slash"]             = "`",
    ["Three"]             = "3",
    ["Seven"]             = "7",
    ["Eight"]             = "8",
    ["Colon"]             = ":",
    ["Semicolon"]         = ";",
    ["LessThan"]          = "<",
    ["GreaterThan"]       = ">",
    ["Question"]          = "?",
    ["Equals"]            = "=",
    ["At"]                = "@",
    ["LeftBracket"]       = "LeftBracket",
    ["RightBracket"]      = "RightBracked",
    ["BackSlash"]         = "BackSlash",
    ["Caret"]             = "^",
    ["Underscore"]        = "_",
    ["Backquote"]         = "`",
    ["LeftCurly"]         = "{",
    ["Pipe"]              = "|",
    ["RightCurly"]        = "}",
    ["Tilde"]             = "~",
    ["Delete"]            = "Delete",
    ["End"]               = "End",
    ["KeypadZero"]        = "Keypad0",
    ["KeypadOne"]         = "Keypad1",
    ["KeypadTwo"]         = "Keypad2",
    ["KeypadThree"]       = "Keypad3",
    ["KeypadFour"]        = "Keypad4",
    ["KeypadFive"]        = "Keypad5",
    ["KeypadSix"]         = "Keypad6",
    ["KeypadSeven"]       = "Keypad7",
    ["KeypadEight"]       = "Keypad8",
    ["KeypadNine"]        = "Keypad9",
    ["KeypadPeriod"]      = "KeypadP",
    ["KeypadDivide"]      = "KeypadD",
    ["KeypadMultiply"]    = "KeypadM",
    ["KeypadMinus"]       = "KeypadM",
    ["KeypadPlus"]        = "KeypadP",
    ["KeypadEnter"]       = "KeypadE",
    ["KeypadEquals"]      = "KeypadE",
    ["Insert"]            = "Insert",
    ["Home"]              = "Home",
    ["PageUp"]            = "PageUp",
    ["PageDown"]          = "PageDown",
    ["RightShift"]        = "RightShift",
    ["LeftShift"]         = "LeftShift",
    ["RightControl"]      = "RightControl",
    ["LeftControl"]       = "LeftControl",
    ["LeftAlt"]           = "LeftAlt",
    ["RightAlt"]          = "RightAlt"
}

local Themes = {
    ["Preset"] = {
        ["Window Outline"] = FromRGB(0, 0, 0),
        ["Accent"] = FromRGB(179, 5, 76),
        ["Background 1"] = FromRGB(20,20,20),
        ["Text"] = FromRGB(255, 255, 255),
        ["Inline"] = FromHex('#161616'),
        ["Element"] = FromHex('#1c1c1c'),
        ["Inactive Text"] = FromRGB(185, 185, 185),
        ["Border"] =  FromHex('#323232'),
        ["Background 2"] = FromRGB(24,24,24)
    }
}

Library.Theme = TableClone(Themes["Preset"])

-- Folders
for Index, Value in Library.Folders do 
    if not isfolder(Value) then
        makefolder(Value)
    end
end

-- Tweening
local Tween = { } do
    Tween.__index = Tween

    Tween.Create = function(self, Item, Info, Goal, IsRawItem)
        Item = IsRawItem and Item or Item.Instance
        Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

        local NewTween = {
            Tween = TweenService:Create(Item, Info, Goal),
            Info = Info,
            Goal = Goal,
            Item = Item
        }

        NewTween.Tween:Play()

        setmetatable(NewTween, Tween)

        return NewTween
    end

    Tween.GetProperty = function(self, Item)
        Item = Item or self.Item 

        if Item:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Item:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Item:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
        local Item = Item or self.Item 

        local OldTransparency = Item[Property]
        Item[Property] = Visibility and 1 or OldTransparency

        local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
            [Property] = Visibility and OldTransparency or 1
        }, true)

        Library:Connect(NewTween.Tween.Completed, function()
            if not Visibility then 
                task.wait()
                Item[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Tween.Get = function(self)
        if not self.Tween then 
            return
        end

        return self.Tween, self.Info, self.Goal
    end

    Tween.Pause = function(self)
        if not self.Tween then 
            return
        end

        self.Tween:Pause()
    end

    Tween.Play = function(self)
        if not self.Tween then 
            return
        end

        self.Tween:Play()
    end

    Tween.Clean = function(self)
        if not self.Tween then 
            return
        end

        Tween:Pause()
        self = nil
    end
end

-- Instances
Instances = { } do
    Instances.__index = Instances

    Instances.Create = function(self, Class, Properties)
        local NewItem = {
            Instance = InstanceNew(Class),
            Properties = Properties,
            Class = Class
        }

        setmetatable(NewItem, Instances)

        for Property, Value in NewItem.Properties do
            NewItem.Instance[Property] = Value
        end

        -- Every text control created by the library follows the selected global font.
        -- This intentionally runs after the supplied properties so hard-coded fonts
        -- in older sections cannot override the Config > Global Font choice.
        if Library and Library.Font and (Class == "TextLabel" or Class == "TextButton" or Class == "TextBox") then
            pcall(function() NewItem.Instance.FontFace = Library.Font end)
        end

        return NewItem
    end

    Instances.FadeItem = function(self, Visibility, Speed)
        local Item = self.Instance

        if Visibility == true then 
            Item.Visible = true
        end

        local Descendants = Item:GetDescendants()
        TableInsert(Descendants, Item)

        local NewTween

        for Index, Value in Descendants do 
            local TransparencyProperty = Tween:GetProperty(Value)

            if not TransparencyProperty then 
                continue
            end

            if type(TransparencyProperty) == "table" then 
                for _, Property in TransparencyProperty do 
                    NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                end
            else
                NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
            end
        end
    end

    Instances.AddToTheme = function(self, Properties)
        if not self.Instance then 
            return
        end

        Library:AddToTheme(self, Properties)
    end

    Instances.ChangeItemTheme = function(self, Properties)
        if not self.Instance then 
            return
        end

        Library:ChangeItemTheme(self, Properties)
    end

    Instances.Connect = function(self, Event, Callback, Name)
        if not self.Instance then 
            return
        end

        if not self.Instance[Event] then 
            return
        end

        return Library:Connect(self.Instance[Event], Callback, Name)
    end

    Instances.Tween = function(self, Info, Goal)
        if not self.Instance then return end
        if not Info then
            for prop, val in pairs(Goal) do
                self.Instance[prop] = val
            end
            return
        end
        return Tween:Create(self, Info, Goal)
    end

    Instances.Disconnect = function(self, Name)
        if not self.Instance then 
            return
        end

        return Library:Disconnect(Name)
    end

    Instances.Clean = function(self)
        if not self.Instance then 
            return
        end

        self.Instance:Destroy()
        self = nil
    end

    Instances.MakeDraggable = function(self, DragHandle)
        if not self.Instance then return end

        local Gui = self.Instance
        local Handle = (DragHandle and DragHandle.Instance) or Gui
        local Dragging = false
        local ActiveInput = nil
        local StartPos = nil
        local StartInputPos = nil

        local function getInputPosition(Input)
            return Vector2New(Input.Position.X, Input.Position.Y)
        end

        local function beginDrag(Input)
            if Input.UserInputType ~= Enum.UserInputType.MouseButton1
                and Input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            Dragging = true
            ActiveInput = Input
            StartPos = Gui.Position
            StartInputPos = getInputPosition(Input)

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End
                    or Input.UserInputState == Enum.UserInputState.Cancel then
                    Dragging = false
                    ActiveInput = nil
                end
            end)
        end

        Handle.InputBegan:Connect(beginDrag)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if not Dragging then return end

            local validMouse = Input.UserInputType == Enum.UserInputType.MouseMovement
            local validTouch = Input.UserInputType == Enum.UserInputType.Touch

            if not validMouse and not validTouch then return end
            if validTouch and ActiveInput and Input ~= ActiveInput then return end

            local currentPos = getInputPosition(Input)
            local delta = currentPos - StartInputPos

            local parentS = Gui.Parent.AbsoluteSize
            local guiS = Gui.AbsoluteSize

            local minX = -StartPos.X.Scale * parentS.X
            local maxX = parentS.X - guiS.X - StartPos.X.Scale * parentS.X
            local minY = -StartPos.Y.Scale * parentS.Y
            local maxY = parentS.Y - guiS.Y - StartPos.Y.Scale * parentS.Y

            local newOffX = MathClamp(StartPos.X.Offset + delta.X, minX, math.max(minX, maxX))
            local newOffY = MathClamp(StartPos.Y.Offset + delta.Y, minY, math.max(minY, maxY))

            Gui.Position = UDim2.new(StartPos.X.Scale, newOffX, StartPos.Y.Scale, newOffY)
        end)
    end

    Instances.MakeResizeable = function(self, Minimum, Maximum)
        if not self.Instance then
            return
        end

        local Gui = self.Instance
        local Resizing = false
        local CurrentSide = nil
        local ActiveInput = nil
        local StartInput = nil
        local StartPosition = nil
        local StartSize = nil
        local EdgeThickness = 3
        local CornerSize = 20

        local function makeEdge(Name, Position, Size, Side, z)
            local Button = Instances:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = FromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = z or 99999,
                Active = true,
            })
            Button:AddToTheme({BackgroundColor3 = "Accent"})
            return {Button = Button, Side = Side}
        end

        local Edges = {
            makeEdge("Left", UDim2New(0, 0, 0, 0), UDim2New(0, EdgeThickness, 1, 0), "L"),
            makeEdge("Right", UDim2New(1, -EdgeThickness, 0, 0), UDim2New(0, EdgeThickness, 1, 0), "R"),
            makeEdge("Top", UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, EdgeThickness), "T"),
            makeEdge("Bottom", UDim2New(0, 0, 1, -EdgeThickness), UDim2New(1, 0, 0, EdgeThickness), "B"),
            -- Dedicated upper-right grip for easy mobile resizing.
            makeEdge("TopRight", UDim2New(1, -CornerSize, 0, 0), UDim2New(0, CornerSize, 0, CornerSize), "TR", 100000),
        }

        local function inputPos(Input)
            return Vector2New(Input.Position.X, Input.Position.Y)
        end

        local function beginResize(Side, Input)
            local kind = Input.UserInputType
            if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then
                return
            end

            Resizing = true
            CurrentSide = Side
            ActiveInput = Input
            StartInput = inputPos(Input)
            StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)

            for _, value in ipairs(Edges) do
                value.Button.Instance.BackgroundTransparency = (value.Side == Side) and 0.35 or 1
            end

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End
                    or Input.UserInputState == Enum.UserInputState.Cancel then
                    Resizing = false
                    CurrentSide = nil
                    ActiveInput = nil
                    for _, value in ipairs(Edges) do
                        value.Button.Instance.BackgroundTransparency = 1
                    end
                end
            end)
        end

        for _, value in ipairs(Edges) do
            value.Button:Connect("InputBegan", function(Input)
                beginResize(value.Side, Input)
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if ActiveInput == Input or
                (Input.UserInputType == Enum.UserInputType.MouseButton1 and ActiveInput ~= nil) then
                Resizing = false
                CurrentSide = nil
                ActiveInput = nil
                for _, value in ipairs(Edges) do
                    value.Button.Instance.BackgroundTransparency = 1
                end
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if not Resizing or not CurrentSide or not ActiveInput then
                return
            end

            local validMouse = Input.UserInputType == Enum.UserInputType.MouseMovement
            local validTouch = Input.UserInputType == Enum.UserInputType.Touch
            if not validMouse and not validTouch then
                return
            end

            -- A touch resize follows only the touch that started the resize.
            if validTouch and ActiveInput.UserInputType == Enum.UserInputType.Touch then
                -- Roblox emits the active TouchInput through InputChanged.
                if Input ~= ActiveInput then
                    return
                end
            end

            local CurrentInput = inputPos(Input)
            local dx = CurrentInput.X - StartInput.X
            local dy = CurrentInput.Y - StartInput.Y

            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            elseif CurrentSide == "TR" then
                w = StartSize.X + dx
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            end

            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                elseif CurrentSide == "TR" then
                    w = Minimum.X
                end
                w = Minimum.X
            end

            if h < Minimum.Y then
                if CurrentSide == "T" or CurrentSide == "TR" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end

            if Maximum then
                w = math.min(w, Maximum.X)
                h = math.min(h, Maximum.Y)
            end

            Gui.Position = UDim2FromOffset(x, y)
            Gui.Size = UDim2FromOffset(w, h)
        end)
    end


    Instances.OnHover = function(self, Function)
        if not self.Instance then 
            return
        end
        
        return Library:Connect(self.Instance.MouseEnter, Function)
    end

    Instances.OnHoverLeave = function(self, Function)
        if not self.Instance then 
            return
        end
        
        return Library:Connect(self.Instance.MouseLeave, Function)
    end
end

-- Custom font
local CustomFont = { } do
    function CustomFont:New(Name, Weight, Style, Data)
        if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
            return  -- already cached, Get() handles loading
        end
        -- download and build font cache in background — never blocks inject
        task.spawn(function()
            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then
                local ok, data = pcall(game.HttpGet, game, Data.Url)
                if not ok then return end
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", data)
            end
            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }
            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
        end)
    end

    function CustomFont:Get(Name)
        if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end
    end

    CustomFont:New("Verdana", 400, "Regular", {
        Id = "Verdana",
        Url = "https://github.com/Syqx906/UWU-ttfs/raw/refs/heads/main/verdana.ttf"
    })

    -- Smallest Pixel is bundled from the font ZIP supplied with this build.
    -- The first run writes the TTF into the script's asset folder, then builds
    -- the Roblox FontFace JSON so the font is available without a web download.
    local function decode_base64(data)
        local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        data = data:gsub("[^" .. alphabet .. "=]", "")
        local out = {}
        local buffer, bits = 0, 0
        for i = 1, #data do
            local c = data:sub(i, i)
            if c == "=" then break end
            local v = alphabet:find(c, 1, true)
            if v then
                buffer = buffer * 64 + (v - 1)
                bits = bits + 6
                if bits >= 8 then
                    bits = bits - 8
                    out[#out + 1] = string.char(math.floor(buffer / (2 ^ bits)) % 256)
                    buffer = buffer % (2 ^ bits)
                end
            end
        end
        return table.concat(out)
    end

    local smallest_pixel_b64 = [[
AAEAAAAMAIAAAwBAT1MvMmSz/H0AAAFIAAAAYFZETVhoYG/3AAAGmAAABeBjbWFwel+AIwAADHgAAAUwZ2FzcP//AAEAAGP4AAAACGdseWa90hIhAAARqAAA
        RRRoZWFk/hqSzwAAAMwAAAA2aGhlYQegBbsAAAEEAAAAJGhtdHhmdgAAAAABqAAABPBsb2Nh73HeDAAAVrwAAAJ6bWF4cAFBADMAAAEoAAAAIG5hbWX/R4pV
        AABZOAAABC1wb3N0fPqooAAAXWgAAAaOAAEAAAABAAArGZw2Xw889QAJA+gAAAAAzSamLgAAAADNJqljAAD/OASwAyAAAAAJAAIAAAAAAAAAAQAAAu7/BgAA
        BRQAAABkBLAAAQAAAAAAAAAAAAAAAAAAATwAAQAAATwAMgAEAAAAAAABAAAAAAAAAAAAAAAAAAAAAAADAfMBkAAFAAACvAKKAAD/nAK8AooAAAD6ADIA+gAA
        AgAAAAAAAAAAAIAAAi8AAAAKAAAAAAAAAABQWVJTAEAAICEiAu7/BgAAAyAAyAAAAAUAAAAAAPoB9AAAACAAAAH0AAAAAAAAAfQAAAH0AAACWAAAAlgAAAJY
        AAAAyAAAAS0AAAEtAAABkAAAAZAAAAEsAAABkAAAAMgAAAJYAAAB9AAAAZAAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAMgAAAEsAAABkAAA
        AZAAAAGQAAAB9AAAAfQAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAZAAAAH0AAAB9AAAAfQAAAJYAAAB9AAAAfQAAAH0AAAB9AAAAfQAAAH0
        AAABkAAAAfQAAAGQAAACWAAAAfQAAAGQAAAB9AAAASwAAAJYAAABLAAAAlgAAAH0AAABLAAAAfQAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAfQAAAH0AAABkAAA
        AfQAAAH0AAAB9AAAAlgAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAfQAAAGQAAAB9AAAAZAAAAJYAAAB9AAAAZAAAAH0AAABkAAAAMgAAAGQAAAB9AAAAlgAAAH0
        AAABLAAAAfQAAAJYAAACWAAAAZAAAAGQAAACWAAAAyAAAAJYAAABkAAAAlgAAAH0AAACWAAAAZAAAAJYAAABLAAAASwAAAJYAAACWAAAASwAAAGQAAAB9AAA
        A4QAAAJYAAABkAAAAlgAAAH0AAACWAAAAZAAAAGQAAABkAAAAfQAAAH0AAAB9AAAAMgAAAH0AAAB9AAAAyAAAAH0AAACvAAAAfQAAAEsAAADIAAAAZAAAAGQ
        AAABkAAAAZAAAAGQAAAB9AAAAlgAAAJYAAAAyAAAAfQAAAK8AAAB9AAAArwAAAH0AAAB9AAAAfQAAAGQAAAB9AAAAfQAAAH0AAAB9AAAAlgAAAH0AAACWAAA
        AfQAAAH0AAAB9AAAAfQAAAH0AAACWAAAAfQAAAH0AAAB9AAAAfQAAAH0AAABkAAAAfQAAAJYAAAB9AAAAlgAAAH0AAACWAAAArwAAAJYAAACvAAAAfQAAAH0
        AAACWAAAAfQAAAH0AAAB9AAAAfQAAAH0AAACWAAAAfQAAAJYAAAB9AAAAfQAAAH0AAAB9AAAAfQAAAJYAAAB9AAAAfQAAAH0AAAB9AAAAfQAAAGQAAAB9AAA
        AlgAAAH0AAACWAAAAfQAAAJYAAACvAAAAlgAAAK8AAAB9AAAAfQAAAJYAAAB9AAAAfQAAAH0AAAAyAAAAlgAAAH0AAABkAAAAZAAAAH0AAAB9AAAAfQAAAEs
        AAABkAAAAZAAAAH0AAAFFAAABRQAAAUUAAAB9AAAAfQAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAlgAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAZAAAAGQAAABkAAA
        AZAAAAJYAAAB9AAAAfQAAAH0AAAB9AAAAfQAAAH0AAABkAAAAlgAAAH0AAAB9AAAAfQAAAH0AAABkAAAAfQAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAfQAAAH0
        AAACWAAAAfQAAAH0AAAB9AAAAfQAAAH0AAABkAAAAZAAAAGQAAABkAAAAlgAAAH0AAAB9AAAAfQAAAH0AAAB9AAAAfQAAAGQAAACWAAAAfQAAAH0AAAB9AAA
        AfQAAAGQAAAB9AAAAZAAAAJYAAACWAAAAfQAAAH0AAABkAAAAfQAAAH0AAAB9AAAAZAAAAH0AAACWAAAAMgAAAGQAAAAAAABAAEBAQEBAAwA+Aj/AAgAB//+
        AAkACP/+AAoACP/+AAsACf/9AAwACv/9AA0AC//9AA4ADP/9AA8ADP/9ABAADf/8ABEADv/8ABIAD//8ABMAEP/8ABQAEP/8ABUAEf/7ABYAEv/7ABcAE//7
        ABgAFP/7ABkAFP/7ABoAFf/6ABsAFv/6ABwAF//6AB0AGP/6AB4AGP/6AB8AGf/5ACAAGv/5ACEAG//5ACIAHP/5ACMAHP/5ACQAHf/4ACUAHv/4ACYAH//4
        ACcAIP/4ACgAIP/4ACkAIf/3ACoAIv/3ACsAI//3ACwAJP/3AC0AJP/3AC4AJf/2AC8AJv/2ADAAJ//2ADEAKP/2ADIAKP/2ADMAKf/1ADQAKv/1ADUAK//1
        ADYALP/1ADcALP/1ADgALf/0ADkALv/0ADoAL//0ADsAMP/0ADwAMP/0AD0AMf/zAD4AMv/zAD8AM//zAEAANP/zAEEANP/zAEIANf/yAEMANv/yAEQAN//y
        AEUAOP/yAEYAOP/yAEcAOf/xAEgAOv/xAEkAO//xAEoAPP/xAEsAPP/xAEwAPf/wAE0APv/wAE4AP//wAE8AQP/wAFAAQP/wAFEAQf/vAFIAQv/vAFMAQ//v
        AFQARP/vAFUARP/vAFYARf/uAFcARv/uAFgAR//uAFkASP/uAFoASP/uAFsASf/tAFwASv/tAF0AS//tAF4ATP/tAF8ATP/tAGAATf/sAGEATv/sAGIAT//s
        AGMAUP/sAGQAUP/sAGUAUf/rAGYAUv/rAGcAU//rAGgAVP/rAGkAVP/rAGoAVf/qAGsAVv/qAGwAV//qAG0AWP/qAG4AWP/qAG8AWf/pAHAAWv/pAHEAW//p
        AHIAXP/pAHMAXP/pAHQAXf/oAHUAXv/oAHYAX//oAHcAYP/oAHgAYP/oAHkAYf/nAHoAYv/nAHsAY//nAHwAZP/nAH0AZP/nAH4AZf/mAH8AZv/mAIAAZ//m
        AIEAaP/mAIIAaP/mAIMAaf/lAIQAav/lAIUAa//lAIYAbP/lAIcAbP/lAIgAbf/kAIkAbv/kAIoAb//kAIsAcP/kAIwAcP/kAI0Acf/jAI4Acv/jAI8Ac//j
        AJAAdP/jAJEAdP/jAJIAdf/iAJMAdv/iAJQAd//iAJUAeP/iAJYAeP/iAJcAef/hAJgAev/hAJkAe//hAJoAfP/hAJsAfP/hAJwAff/gAJ0Afv/gAJ4Af//g
        AJ8AgP/gAKAAgP/gAKEAgf/fAKIAgv/fAKMAg//fAKQAhP/fAKUAhP/fAKYAhf/eAKcAhv/eAKgAh//eAKkAiP/eAKoAiP/eAKsAif/dAKwAiv/dAK0Ai//d
        AK4AjP/dAK8AjP/dALAAjf/cALEAjv/cALIAj//cALMAkP/cALQAkP/cALUAkf/bALYAkv/bALcAk//bALgAlP/bALkAlP/bALoAlf/aALsAlv/aALwAl//a
        AL0AmP/aAL4AmP/aAL8Amf/ZAMAAmv/ZAMEAm//ZAMIAnP/ZAMMAnP/ZAMQAnf/YAMUAnv/YAMYAn//YAMcAoP/YAMgAoP/YAMkAof/XAMoAov/XAMsAo//X
        AMwApP/XAM0ApP/XAM4Apf/WAM8Apv/WANAAp//WANEAqP/WANIAqP/WANMAqf/VANQAqv/VANUAq//VANYArP/VANcArP/VANgArf/UANkArv/UANoAr//U
        ANsAsP/UANwAsP/UAN0Asf/TAN4Asv/TAN8As//TAOAAtP/TAOEAtP/TAOIAtf/SAOMAtv/SAOQAt//SAOUAuP/SAOYAuP/SAOcAuf/RAOgAuv/RAOkAu//R
        AOoAvP/RAOsAvP/RAOwAvf/QAO0Avv/QAO4Av//QAO8AwP/QAPAAwP/QAPEAwf/PAPIAwv/PAPMAw//PAPQAxP/PAPUAxP/PAPYAxf/OAPcAxv/OAPgAx//O
        APkAyP/OAPoAyP/OAPsAyf/NAPwAyv/NAP0Ay//NAP4AzP/NAP8AzP/NAAAAAwAAAAMAAAOoAAEAAAAAABwAAwABAAACIAAGAgQAAAAAAP0AAQAAAAAAAAAA
        AAAAAAAAAAEAAgAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAMBOgE7ATkABAAFAAYABwAIAAkACgALAAwADQAOAA8AEAAR
        ABIAEwAUABUAFgAXABgAGQAaABsAHAAdAB4AHwAgACEAIgAjACQAJQAmACcAKAApACoAKwAsAC0ALgAvADAAMQAyADMANAA1ADYANwA4ADkAOgA7ADwAPQA+
        AD8AQABBAEIAQwBEAEUARgBHAEgASQBKAEsATABNAE4ATwBQAFEAUgBTAFQAVQBWAFcAWABZAFoAWwBcAF0AXgAAAPMA9AD2APgBAAEFAQsBEAEPAREBEwES
        ARQBFgEYARcBGQEaARwBGwEdAR4BIAEiASEBIwElASQBKQEoASoBKwBlAI0A4ADhAIQAdACTAQ4AiwCGAHcA5wDjAAAA9QEHAAAAjgAAAAAA4gCSAAAAAAAA
        AAAAAADkAOoAAAEVAScA7gDfAIkAAAE2AAAAAACIAJgAZAADAO8A8gEEAS8BMAB1AHYAcgBzAHAAcQEmAAABLgEzAAAAZwBqAHkAAAAAAGYAlABhAGMAaADx
        APkA8AD6APcA/AD9AP4A+wECAQMAAAEBAQkBCgEIAAABNwE4AAAAAAAAAAAA6AAEAYgAAAA8ACAABAAcACMAfgCqAK4AuwD/AVMBYQF4AX4BkgLGAtwEDAQP
        BE8EXARfBJEgFCAaIB4gIiAmIDAgOiCsIRYhIv//AAAAIAAkAKAAqwCwALwBUgFgAXgBfQGSAsYC3AQBBA4EEARRBF4EkCATIBggHCAgICYgMCA5IKwhFiEi
        //8AAP/gAAD/3QAAAC//3f/R/7v/t/+k/nH+XAAAAAD8jQAAAAAAAOBiAAAAAAAA4D7gOAAA37vfgN9VAAEAPAAAAEAAAABSAAAAAAAAAAAAAAAAAAAAAABY
        AG4AAABuAIQAhgAAAIYAigCOAAAAAACOAAAAAAAAAAAAAwE6ATsBOQADAN8A4ADhAIEA4gCDAIQA4wCGAOQAjQCOAOUA5gDnAJIAkwCUAOgA6QDqAJgAhQBf
        AGAAhwCaAI8AjACAAGkAawBtAGwAfgBuAJUAbwBiAJcAmwCQAJwAmQB4AHoAfAB7AH8AfQCCAJEAcABxAGEAcgBzAGMAZQBmAHQAagB5AAQBiAAAADwAIAAE
        ABwAIwB+AKoArgC7AP8BUwFhAXgBfgGSAsYC3AQMBA8ETwRcBF8EkSAUIBogHiAiICYgMCA6IKwhFiEi//8AAAAgACQAoACrALAAvAFSAWABeAF9AZICxgLc
        BAEEDgQQBFEEXgSQIBMgGCAcICAgJiAwIDkgrCEWISL//wAA/+AAAP/dAAAAL//d/9H/u/+3/6T+cf5cAAAAAPyNAAAAAAAA4GIAAAAAAADgPuA4AADfu9+A
        31UAAQA8AAAAQAAAAFIAAAAAAAAAAAAAAAAAAAAAAFgAbgAAAG4AhACGAAAAhgCKAI4AAAAAAI4AAAAAAAAAAAADAToBOwE5AAMA3wDgAOEAgQDiAIMAhADj
        AIYA5ACNAI4A5QDmAOcAkgCTAJQA6ADpAOoAmACFAF8AYACHAJoAjwCMAIAAaQBrAG0AbAB+AG4AlQBvAGIAlwCbAJAAnACZAHgAegB8AHsAfwB9AIIAkQBw
        AHEAYQByAHMAYwBlAGYAdABqAHkAAwAA/5wB9AJYABsAHwAjAAARMzUzNTMVMxUjFTMVMxUjFSMVIzUjNTM1IzUjBTM1IyczNSNkZGTIyGRkZGRkyMhkZAEs
        ZGTIZGQBkGRkZGRkZGRkZGRkZGTIZGRkAAAAAwAAAAAB9AH0ABMAFwAbAAA1MzUzNTM1MzUzFSMVIxUjFSMVIxEzFSMBMxUjZGRkZGRkZGRkZGRkAZBkZGRk
        ZGRkZGRkZGQB9GT+1GQAAAAEAAAAAAH0AfQAFwAbAB8AIwAAETM1MxUzFTMVIxUzFSM1IxUjNSM1MzUjFzM1IzUVMzUVMzUjZMhkZGRkZGTIZGRkZMjIyGRk
        AZBkZGRkZGRkZGRkZMhkyGRjx2QAAAABAAABLABkAfQAAwAAETMVI2RkAfTIAAABAAAAAADIAfQACwAAETM1MxUjETMVIzUjZGRkZGRkAZBkZP7UZGQAAQAA
        AAAAyAH0AAsAABEzFTMRIxUjNTMRI2RkZGRkZAH0ZP7UZGQBLAAAAAABAAAAZAEsAZAAEwAAETMVMzUzFSMVMxUjNSMVIzUzNSNkZGRkZGRkZGRkAZBkZGRk
        ZGRkZGQAAAEAAABkASwBkAALAAARMzUzFTMVIxUjNSNkZGRkZGQBLGRkZGRkAAABAAD/nADIAGQABwAANTMVMxUjNSNkZGRkZGRkZAAAAAEAAADIASwBLAAD
        AAARIRUhASz+1AEsZAAAAAABAAAAAABkAGQAAwAANTMVI2RkZGQAAAABAAAAAAH0AfQAEwAANTM1MzUzNTM1MxUjFSMVIxUjFSNkZGRkZGRkZGRkZGRkZGRk
        ZGRkZAAAAAIAAAAAAZAB9AALAA8AABEzNTMVMxEjFSM1IzsBESNkyGRkyGRkyMgBkGRk/tRkZAEsAAABAAAAAAEsAfQACwAAETM1MxEzFSE1MzUjZGRk/tRk
        ZAGQZP5wZGTIAAAAAAEAAAAAAZAB9AARAAARIRUzFSMVIxUhFSE1MzUzNSEBLGRkyAEs/nBkyP7UAfRkZGRkZMhkZAAAAQAAAAABkAH0ABMAABMzNSE1IRUz
        FSMVMxUjFSE1ITUjZMj+1AEsZGRkZP7UASzIASxkZGRkZGRkZGQAAQAAAAABkAH0AAkAABEzFTM1MxEjNSFkyGRk/tQB9MjI/gzIAAAAAAEAAAAAAZAB9AAP
        AAARIRUhFTMVMxUjFSE1ITUhAZD+1MhkZP7UASz+1AH0ZGRkZGRkZAACAAAAAAGQAfQADwATAAARMzUzFSMVMxUzFSMVIzUjOwE1I2TIyMhkZMhkZMjIAZBk
        ZGRkZGRkZAAAAAABAAAAAAGQAfQADQAAESEVIxUjFSM1MzUzNSEBkGRkZGRk/tQB9MhkyMhkZAAAAAADAAAAAAGQAfQAEwAXABsAABEzNTMVMxUjFTMVIxUj
        NSM1MzUjFzM1IzUzNSNkyGRkZGTIZGRkZMjIyMgBkGRkZGRkZGRkZMhkZGQAAgAAAAABkAH0AA8AEwAAETM1MxUzESMVIzUzNSM1IzsBNSNkyGRkyMjIZGTI
        yAGQZGT+1GRkZGRkAAAAAgAAAGQAZAGQAAMABwAAETMVIxUzFSNkZGRkAZBkZGQAAAAAAgAA/5wAyAGQAAcACwAANTMVMxUjNSMRMxUjZGRkZGRkZGRkZAGQ
        ZAAAAAABAAAAAAEsAfQAEwAAETM1MzUzFSMVIxUzFTMVIzUjNSNkZGRkZGRkZGRkASxkZGRkZGRkZGQAAAIAAABkASwBkAADAAcAABEhFSEVIRUhASz+1AEs
        /tQBkGRkZAAAAAABAAAAAAEsAfQAEwAAETMVMxUzFSMVIxUjNTM1MzUjNSNkZGRkZGRkZGRkAfRkZGRkZGRkZGQAAAIAAAAAAZAB9AALAA8AABMzNSE1IRUz
        FSMVIxUzFSNkyP7UASxkZMhkZAEsZGRkZGRkZAABAAAAAAGQAfQAEQAAETM1MxUzFSM1MzUjESEVITUjZMhkyGTIASz+1GQBkGRkyGRk/tRkZAAAAAIAAAAA
        AZAB9AALAA8AABEzNTMVMxEjNSMVIxMzNSNkyGRkyGRkyMgBkGRk/nDIyAEsZAADAAAAAAGQAfQACwAPABMAABEhFTMVIxUzFSMVIRMVMzUDMzUjASxkZGRk
        /tRkyMjIyAH0ZGRkZGQBkGRj/tVkAAAAAAEAAAAAAZAB9AALAAARMzUhFSERIRUhNSNkASz+1AEs/tRkAZBkZP7UZGQAAgAAAAABkAH0AAcACwAAESEVMxEj
        FSE3MxEjASxkZP7UZMjIAfRk/tRkZAEsAAAAAQAAAAABkAH0AAsAABEhFSEVMxUjFSEVIQGQ/tTIyAEs/nAB9GRkZGRkAAABAAAAAAGQAfQACQAAESEVIRUz
        FSMVIwGQ/tTIyGQB9GRkZMgAAAAAAQAAAAABkAH0AA8AABEzNSEVIREzNSM1MxEhNSNkASz+1MhkyP7UZAGQZGT+1GRk/tRkAAEAAAAAAZAB9AALAAARMxUz
        NTMRIzUjFSNkyGRkyGQB9MjI/gzIyAABAAAAAAEsAfQACwAAESEVIxEzFSE1MxEjASxkZP7UZGQB9GT+1GRkASwAAAEAAAAAAZAB9AANAAARIREjFSM1IzUz
        FTMRIQGQZMhkZMj+1AH0/nBkZGRkASwAAAEAAAAAAZAB9AAXAAARMxUzNTM1MxUjFSMVMxUzFSM1IzUjFSNkZGRkZGRkZGRkZGQB9MhkZGRkZGRkZGTIAAAB
        AAAAAAGQAfQABQAAETMRIRUhZAEs/nAB9P5wZAAAAAEAAAAAAfQB9AATAAARMxUzFTM1MzUzESMRIxUjNSMRI2RkZGRkZGRkZGQB9GRkZGT+DAEsZGT+1AAA
        AAEAAAAAAZAB9AAPAAARMxUzFTM1MxEjNSM1IxEjZGRkZGRkZGQB9GRkyP4MyGT+1AAAAAACAAAAAAGQAfQACwAPAAARMzUzFTMRIxUjNSM7AREjZMhkZMhk
        ZMjIAZBkZP7UZGQBLAAAAgAAAAABkAH0AAkADQAAESEVMxUjFSMVIxMzNSMBLGRkyGRkyMgB9GRkZMgBLGQAAgAA/5wBkAH0AA8AEwAAETM1MxUzESMVMxUj
        NSM1IwEjETNkyGRkZGTIZAEsyMgBkGRk/tRkZGRkASz+1AAAAAIAAAAAAZAB9AAPABMAABEhFTMVIxUzFSM1IzUjFSMTMzUjASxkZGRkZGRkZMjIAfRkZMhk
        ZGTIASxkAAEAAAAAAZAB9AATAAARMzUhFSEVMxUzFSMVITUhNSM1I2QBLP7UyGRk/tQBLMhkAZBkZGRkZGRkZGQAAAEAAAAAASwB9AAHAAARIRUjESMRIwEs
        ZGRkAfRk/nABkAAAAAEAAAAAAZAB9AALAAARMxEzETMRIxUjNSNkyGRkyGQB9P5wAZD+cGRkAAAAAQAAAAABLAH0AAsAABEzETMRMxEjFSM1I2RkZGRkZAH0
        /nABkP5wZGQAAAABAAAAAAH0AfQAEwAAETMRMxEzETMRMxEjFSM1IxUjNSNkZGRkZGRkZGRkAfT+cAEs/tQBkP5wZGRkZAABAAAAAAGQAfQAEwAAETMVMzUz
        FSMVMxUjNSMVIzUzNSNkyGRkZGTIZGRkAfTIyMhkyMjIyGQAAAEAAAAAASwB9AALAAARMxUzNTMVIxEjESNkZGRkZGQB9MjIyP7UASwAAAAAAQAAAAABkAH0
        AA8AABEhFSMVIxUhFSE1MzUzNSEBkGTIASz+cGTI/tQB9MhkZGTIZGQAAAEAAAAAAMgB9AAHAAARMxUjETMVI8hkZMgB9GT+1GQAAQAAAAAB9AH0ABMAABEz
        FTMVMxUzFTMVIzUjNSM1IzUjZGRkZGRkZGRkZAH0ZGRkZGRkZGRkAAABAAAAAADIAfQABwAAETMRIzUzESPIyGRkAfT+DGQBLAAAAAABAAAAyAH0AfQAEwAA
        ETM1MzUzFTMVMxUjNSM1IxUjFSNkZGRkZGRkZGRkASxkZGRkZGRkZGQAAAEAAAAAAZAAZAADAAA1IRUhAZD+cGRkAAEAAAEsAMgB9AAHAAARMxUzFSM1I2Rk
        ZGQB9GRkZAAAAgAAAAABkAH0AAsADwAAETM1MxUzESM1IxUjEzM1I2TIZGTIZGTIyAGQZGT+cMjIASxkAAMAAAAAAZAB9AALAA8AEwAAESEVMxUjFTMVIxUh
        ExUzNQMzNSMBLGRkZGT+1GTIyMjIAfRkZGRkZAGQZGP+1WQAAAAAAQAAAAABkAH0AAsAABEzNSEVIREhFSE1I2QBLP7UASz+1GQBkGRk/tRkZAACAAAAAAGQ
        AfQABwALAAARIRUzESMVITczESMBLGRk/tRkyMgB9GT+1GRkASwAAAABAAAAAAGQAfQACwAAESEVIRUzFSMVIRUhAZD+1MjIASz+cAH0ZGRkZGQAAAEAAAAA
        AZAB9AAJAAARIRUhFTMVIxUjAZD+1MjIZAH0ZGRkyAAAAAABAAAAAAGQAfQADwAAETM1IRUhETM1IzUzESE1I2QBLP7UyGTI/tRkAZBkZP7UZGT+1GQAAQAA
        AAABkAH0AAsAABEzFTM1MxEjNSMVI2TIZGTIZAH0yMj+DMjIAAEAAAAAASwB9AALAAARIRUjETMVITUzESMBLGRk/tRkZAH0ZP7UZGQBLAAAAQAAAAABkAH0
        AA0AABEhESMVIzUjNTMVMxEhAZBkyGRkyP7UAfT+cGRkZGQBLAAAAQAAAAABkAH0ABcAABEzFTM1MzUzFSMVIxUzFTMVIzUjNSMVI2RkZGRkZGRkZGRkZAH0
        yGRkZGRkZGRkZMgAAAEAAAAAAZAB9AAFAAARMxEhFSFkASz+cAH0/nBkAAAAAQAAAAAB9AH0ABMAABEzFTMVMzUzNTMRIxEjFSM1IxEjZGRkZGRkZGRkZAH0
        ZGRkZP4MASxkZP7UAAAAAQAAAAABkAH0AA8AABEzFTMVMzUzESM1IzUjESNkZGRkZGRkZAH0ZGTI/gzIZP7UAAAAAAIAAAAAAZAB9AALAA8AABEzNTMVMxEj
        FSM1IzsBESNkyGRkyGRkyMgBkGRk/tRkZAEsAAACAAAAAAGQAfQACQANAAARIRUzFSMVIxUjEzM1IwEsZGTIZGTIyAH0ZGRkyAEsZAACAAD/nAGQAfQADwAT
        AAARMzUzFTMRIxUzFSM1IzUjASMRM2TIZGRkZMhkASzIyAGQZGT+1GRkZGQBLP7UAAAAAgAAAAABkAH0AA8AEwAAESEVMxUjFTMVIzUjNSMVIxMzNSMBLGRk
        ZGRkZGRkyMgB9GRkyGRkZMgBLGQAAQAAAAABkAH0ABMAABEzNSEVIRUzFTMVIxUhNSE1IzUjZAEs/tTIZGT+1AEsyGQBkGRkZGRkZGRkZAAAAQAAAAABLAH0
        AAcAABEhFSMRIxEjASxkZGQB9GT+cAGQAAAAAQAAAAABkAH0AAsAABEzETMRMxEjFSM1I2TIZGTIZAH0/nABkP5wZGQAAAABAAAAAAEsAfQACwAAETMRMxEz
        ESMVIzUjZGRkZGRkAfT+cAGQ/nBkZAAAAAEAAAAAAfQB9AATAAARMxEzETMRMxEzESMVIzUjFSM1I2RkZGRkZGRkZGQB9P5wASz+1AGQ/nBkZGRkAAEAAAAA
        AZAB9AATAAARMxUzNTMVIxUzFSM1IxUjNTM1I2TIZGRkZMhkZGQB9MjIyGTIyMjIZAAAAQAAAAABLAH0AAsAABEzFTM1MxUjESMRI2RkZGRkZAH0yMjI/tQB
        LAAAAAABAAAAAAGQAfQADwAAESEVIxUjFSEVITUzNTM1IQGQZMgBLP5wZMj+1AH0yGRkZMhkZAAAAQAAAAABLAH0AAsAABEzNTMVIxEzFSM1I2TIZGTIZAEs
        yGT+1GTIAAEAAAAAAGQB9AADAAARMxEjZGQB9P4MAAEAAAAAASwB9AALAAARMxUzFSMVIzUzESPIZGTIZGQB9MhkyGQBLAABAAAAyAGQAZAADwAAETM1MxUz
        NTMVIxUjNSMVI2RkZGRkZGRkASxkZGRkZGRkAAABAAAAAAH0AfQAEwAAESEVIxUzFTMVIxUjNTM1IxUjESMBLGTIZGRkZMhkZAH0ZGRkZGRkZMgBkAAAAAAC
        AAAAAAGQAyAABQANAAARIRUhESMTMzUzFSMVIwGQ/tRkyGRkZGQB9GT+cAK8ZGRkAAAAAQAA/5wAyABkAAcAADUzFTMVIzUjZGRkZGRkZGQAAAACAAAAAAGQ
        AyAABQANAAARIRUhESMTMzUzFSMVIwGQ/tRkyGRkZGQB9GT+cAK8ZGRkAAAAAgAA/5wB9ABkAAcADwAANTMVMxUjNSMlMxUzFSM1I2RkZGQBLGRkZGRkZGRk
        ZGRkZAAAAAMAAAAAAfQAZAADAAcACwAANTMVIyUzFSMnMxUjZGQBkGRkyGRkZGRkZGRkAAAAAAEAAAAAASwB9AALAAARMzUzFTMVIxEjESNkZGRkZGQBkGRk
        ZP7UASwAAAAAAQAAAAABLAH0ABMAABEzNTMVMxUjFTMVIxUjNSM1MzUjZGRkZGRkZGRkZAGQZGRkZGRkZGRkAAABAAD/nAH0AlgAGwAAETM1MzUhFSEVMxUj
        FTMVIxUhFSE1IzUjNTM1I2RkASz+1MjIyMgBLP7UZGRkZAGQZGRkZGRkZGRkZGRkZAAABAAAAAACvAH0ABMAFwAbAB8AADUzNTM1MzUzNTMVIxUjFSMVIxUj
        JTMVIzczFSMBMxUjZGRkZGRkZGRkZAGQZGTIZGT9qGRkZGRkZGRkZGRkZMjIyMgB9MgAAAACAAAAAAH0AfQADwATAAARMzUzFTMVMxUjFSMRIxEjJTM1I2TI
        ZGRkyGRkASxkZAGQZMhkZGQBkP5wZGQAAAAAAQAAAAABLAH0ABMAABEzNTM1MxUjFSMVMxUzFSM1IzUjZGRkZGRkZGRkZAEsZGRkZGRkZGRkAAACAAAAAAH0
        AfQAEQAVAAARMxUzNTMVMxUzFSMVIzUjFSMlMzUjZGRkZGRkyGRkASxkZAH0yMjIZGRkyMhkZAAAAgAAAAABkAMgABcAHwAAETMVMzUzNTMVIxUjFTMVMxUj
        NSM1IxUjEzM1MxUjFSNkZGRkZGRkZGRkZGTIZGRkZAH0yGRkZGRkZGRkZMgCvGRkZAAAAQAAAAAB9AH0AA8AABEhFSMVMxUzFSM1IxUjESMBLGTIZGTIZGQB
        9GRkZMjIyAGQAAAAAAEAAP+cASwB9AALAAARMxEzETMRIxUjNSNkZGRkZGQB9P5wAZD+DGRkAAAAAQAAAAAB9AH0ABMAABEhFSMVMxUzFSMVIzUzNSMVIxEj
        ASxkyGRkZGTIZGQB9GRkZGRkZGTIAZAAAAAAAQAAAZAAyAJYAAcAABEzNTMVIxUjZGRkZAH0ZGRkAAABAAABLADIAfQABwAAETMVMxUjNSNkZGRkAfRkZGQA
        AAIAAAGQAfQCWAAHAA8AABEzFTMVIzUjJTMVMxUjNSNkZGRkASxkZGRkAlhkZGRkZGRkAAACAAABLAH0AfQABwAPAAARMxUzFSM1IyUzFTMVIzUjZGRkZAEs
        ZGRkZAH0ZGRkZGRkZAAAAQAAAMgAyAGQAAMAABEzFSPIyAGQyAAAAQAAAMgBLAEsAAMAABEhFSEBLP7UASxkAAAAAAEAAADIAZABLAADAAARIRUhAZD+cAEs
        ZAAAAAABAAAAZAMgAfQAGQAAESEVMxUzNTM1MxEjNSMVIzUjFSMRIxEjESMBkGRkZGRkZGRkZGRkZAH0ZGRkZP5wyGRkyAEs/tQBLAACAAAAAAH0AfQADwAT
        AAARMzUzFTMVMxUjFSMRIxEjJTM1I2TIZGRkyGRkASxkZAGQZMhkZGQBkP5wZGQAAAAAAQAAAAABLAH0ABMAABEzFTMVMxUjFSMVIzUzNTM1IzUjZGRkZGRk
        ZGRkZAH0ZGRkZGRkZGRkAAACAAAAAAH0AfQAEQAVAAARMxUzNTMVMxUzFSMVIzUjFSMlMzUjZGRkZGRkyGRkASxkZAH0yMjIZGRkyMhkZAAAAgAAAAABkAMg
        ABcAHwAAETMVMzUzNTMVIxUjFTMVMxUjNSM1IxUjEzM1MxUjFSNkZGRkZGRkZGRkZGTIZGRkZAH0yGRkZGRkZGRkZMgCvGRkZAAAAQAAAAAB9AH0AA8AABEh
        FSMVMxUzFSM1IxUjESMBLGTIZGTIZGQB9GRkZMjIyAGQAAAAAAEAAP+cASwB9AALAAARMxEzETMRIxUjNSNkZGRkZGQB9P5wAZD+DGRkAAAAAgAAAAABLAMg
        AAsAFwAAETMVMzUzFSMRIxEjETMVMzUzFSMVIzUjZGRkZGRkZGRkZGRkAfTIyMj+1AEsAfRkZGRkZAACAAAAAAEsAyAACwAXAAARMxUzNTMVIxEjESMRMxUz
        NTMVIxUjNSNkZGRkZGRkZGRkZGQB9MjIyP7UASwB9GRkZGRkAAEAAAAAAZAB9AANAAARIREjFSM1IzUzFTMRIQGQZMhkZMj+1AH0/nBkZGRkASwAAAEAAABk
        AZAB9AATAAARMxUzNTMVIxUzFSM1IxUjNTM1I2TIZGRkZMhkZGQB9GRkZMhkZGRkyAAAAQAAAAABkAJYAAcAABEhNTMVIREjASxk/tRkAfRkyP5wAAAAAgAA
        AAAAZAH0AAMABwAAETMVIxUzFSNkZGRkAfTIZMgAAAAAAgAA/5wBkAJYABMAFwAAETM1IRUhFTMVMxEjFSE1ITUjNSM7ATUjZAEs/tTIZGT+1AEsyGRkyMgB
        9GRkZGT+1GRkZGRkAAAAAwAAAAABkAK8AAsADwATAAARIRUhFTMVIxUhFSERMxUjJTMVIwGQ/tTIyAEs/nBkZAEsZGQB9GRkZGRkArxkZGQAAAADAAD/OAK8
        AlgACwAPABcAABEzNSEVMxEjFSE1IzMhESEXIRUjFTMVIWQB9GRk/gxkZAH0/gxkASzIyP7UAfRkZP2oZGQCWGRkyGQAAQAAAAABkAH0AA8AABEzNSEVIRUz
        FSMVIRUhNSNkASz+1MjIASz+1GQBkGRkZGRkZGQAAAIAAAAAAlgB9AATACcAABEzNTM1MxUjFSMVMxUzFSM1IzUjJTM1MzUzFSMVIxUzFTMVIzUjNSNkZGRk
        ZGRkZGRkASxkZGRkZGRkZGRkASxkZGRkZGRkZGRkZGRkZGRkZGRkAAABAAABLAGQAfQABQAAESEVIzUhAZBk/tQB9MhkAAAAAAEAAADIAMgBLAADAAARMxUj
        yMgBLGQAAAQAAP84ArwCWAALAA8AHQAhAAARMzUhFTMRIxUhNSMzIREhFzMVMxUjFTMVIzUjFSM3MzUjZAH0ZGT+DGRkAfT+DGTIZGRkZGRkZGRkAfRkZP2o
        ZGQCWGRkZGRkZGTIZAAAAAADAAAAAAEsArwACwAPABMAABEhFSMRMxUhNTMRIxEzFSM3MxUjASxkZP7UZGRkZMhkZAH0ZP7UZGQBLAEsZGRkAAAAAAIAAADI
        ASwB9AALAA8AABEzNTMVMxUjFSM1IzsBNSNkZGRkZGRkZGQBkGRkZGRkZAAAAAACAAAAAAEsAfQACwAPAAARMzUzFTMVIxUjNSMVIRUhZGRkZGRkASz+1AGQ
        ZGRkZGTIZAAAAQAAAAABLAH0AAsAABEhFSMRMxUhNTMRIwEsZGT+1GRkAfRk/tRkZAEsAAABAAAAAAEsAfQACwAAESEVIxEzFSE1MxEjASxkZP7UZGQB9GT+
        1GRkASwAAAEAAAAAAZACWAAHAAARITUzFSERIwEsZP7UZAH0ZMj+cAAAAAEAAP+cAfQB9AATAAARMxEzFTM1MxEzESM1IxUjNSMVI2RkZGRkZGRkZGQB9P7U
        ZGQBLP4MZGRkyAAAAAEAAAAAAfQB9AALAAARIRUjESMRIxEjESMB9GRkZGRkAfRk/nABkP5wASwAAQAAAMgAZAEsAAMAABEzFSNkZAEsZAAAAwAAAAABkAK8
        AAsADwATAAARIRUhFTMVIxUhFSERMxUjJTMVIwGQ/tTIyAEs/nBkZAEsZGQB9GRkZGRkArxkZGQAAAACAAAAAAJYAfQAEQAVAAARMxUzFTM1IRUjESM1IzUj
        ESMBMxUjZGRkASzIZGRkZAH0ZGQB9GRkyGT+cMhk/tQBLGQAAAEAAAAAAZAB9AAPAAARMzUhFSEVMxUjFSEVITUjZAEs/tTIyAEs/tRkAZBkZGRkZGRkAAAC
        AAAAAAJYAfQAEwAnAAARMxUzFTMVIxUjFSM1MzUzNSM1IyUzFTMVMxUjFSMVIzUzNTM1IzUjZGRkZGRkZGRkZAEsZGRkZGRkZGRkZAH0ZGRkZGRkZGRkZGRk
        ZGRkZGRkZAAAAQAAAAABkAH0AA0AABEhESMVIzUjNTMVMxEhAZBkyGRkyP7UAfT+cGRkZGQBLAAAAQAAAAABkAH0ABMAABEzNSEVIRUzFTMVIxUhNSE1IzUj
        ZAEs/tTIZGT+1AEsyGQBkGRkZGRkZGRkZAAAAQAAAAABkAH0ABMAABEzNSEVIRUzFTMVIxUhNSE1IzUjZAEs/tTIZGT+1AEsyGQBkGRkZGRkZGRkZAAAAwAA
        AAABLAK8AAsADwATAAARIRUjETMVITUzESMRMxUjNzMVIwEsZGT+1GRkZGTIZGQB9GT+1GRkASwBLGRkZAAAAAACAAAAAAGQAfQACwAPAAARMzUzFTMRIzUj
        FSMTMzUjZMhkZMhkZMjIAZBkZP5wyMgBLGQAAgAAAAABkAH0AAsADwAAESEVIRUzFTMVIxUhNzM1IwGQ/tTIZGT+1GTIyAH0ZGRkZGRkZAAAAAADAAAAAAGQ
        AfQACwAPABMAABEhFTMVIxUzFSMVIRMVMzUDMzUjASxkZGRk/tRkyMjIyAH0ZGRkZGQBkGRj/tVkAAAAAAEAAAAAAZAB9AAFAAARIRUhESMBkP7UZAH0ZP5w
        AAAAAgAA/5wB9AH0AA0AEQAANTMRMzUzETMVIzUhFSMBIxEzZGTIZGT+1GQBLGRkZAEsZP5wyGRkAfT+1AAAAQAAAAABkAH0AAsAABEhFSEVMxUjFSEVIQGQ
        /tTIyAEs/nAB9GRkZGRkAAABAAAAAAH0AfQAGwAAETMVMzUzFTM1MxUjFTMVIzUjFSM1IxUjNTM1I2RkZGRkZGRkZGRkZGRkAfTIyMjIyGTIyMjIyMhkAAAB
        AAAAAAGQAfQAEwAAEzM1ITUhFTMVIxUzFSMVITUhNSNkyP7UASxkZGRk/tQBLMgBLGRkZGRkZGRkZAABAAAAAAGQAfQADwAAETMRMzUzNTMRIzUjFSMVI2Rk
        ZGRkZGRkAfT+1GTI/gzIZGQAAAAAAgAAAAABkAK8AA8AEwAAETMRMzUzNTMRIzUjFSMVIxMzFSNkZGRkZGRkZGTIyAH0/tRkyP4MyGRkArxkAAAAAAEAAAAA
        AZAB9AAXAAARMxUzNTM1MxUjFSMVMxUzFSM1IzUjFSNkZGRkZGRkZGRkZGQB9MhkZGRkZGRkZGTIAAABAAAAAAGQAfQACQAAETM1IREjESMRI2QBLGTIZAGQ
        ZP4MAZD+cAAAAQAAAAAB9AH0ABMAABEzFTMVMzUzNTMRIxEjFSM1IxEjZGRkZGRkZGRkZAH0ZGRkZP4MASxkZP7UAAAAAQAAAAABkAH0AAsAABEzFTM1MxEj
        NSMVI2TIZGTIZAH0yMj+DMjIAAIAAAAAAZAB9AALAA8AABEzNTMVMxEjFSM1IzsBESNkyGRkyGRkyMgBkGRk/tRkZAEsAAABAAAAAAGQAfQABwAAESERIxEj
        ESMBkGTIZAH0/gwBkP5wAAACAAAAAAGQAfQACQANAAARIRUzFSMVIxUjEzM1IwEsZGTIZGTIyAH0ZGRkyAEsZAABAAAAAAGQAfQACwAAETM1IRUhESEVITUj
        ZAEs/tQBLP7UZAGQZGT+1GRkAAEAAAAAASwB9AAHAAARIRUjESMRIwEsZGRkAfRk/nABkAAAAAEAAAAAAZAB9AAPAAARMxUzNTMRIxUjNTM1IzUjZMhkZMjI
        yGQB9MjI/nBkZGRkAAMAAAAAAfQB9AAPABMAFwAAETM1IRUzFSMVIxUjNSM1IzsBNSMhIxUzZAEsZGRkZGRkZGRkASxkZAGQZGTIZGRkZMjIAAAAAAEAAAAA
        AZAB9AATAAARMxUzNTMVIxUzFSM1IxUjNTM1I2TIZGRkZMhkZGQB9MjIyGTIyMjIZAAAAQAA/5wB9AH0AAsAABEzETMRMxEzFSM1IWTIZGRk/nAB9P5wAZD+
        cMhkAAABAAAAAAGQAfQACwAAETMVMzUzESM1IzUjZMhkZMhkAfTIyP4MyGQAAQAAAAAB9AH0AAsAABEzETMRMxEzETMRIWRkZGRk/gwB9P5wAZD+cAGQ/gwA
        AAAAAQAA/5wCWAH0AA8AABEzETMRMxEzETMRMxUjNSFkZGRkZGRk/gwB9P5wAZD+cAGQ/nDIZAAAAAACAAAAAAH0AfQACwAPAAARMxUzFTMVIxUhESMXFTM1
        yMhkZP7UZMjIAfTIZGRkAZDIZGMAAwAAAAACWAH0AAkADQARAAARMxUzFTMVIxUhATMRIyUzNSNkyGRk/tQB9GRk/nDIyAH0yGRkZAH0/gxkZAAAAAIAAAAA
        AZAB9AAJAA0AABEzFTMVMxUjFSE3MzUjZMhkZP7UZMjIAfTIZGRkZGQAAAEAAAAAAZAB9AAPAAATMzUhNSEVMxEjFSE1ITUjZMj+1AEsZGT+1AEsyAEsZGRk
        /tRkZGQAAAAAAgAAAAAB9AH0ABMAFwAAETMVMzUzNTMVMxEjFSM1IzUjFSMBIxEzZGRkZGRkZGRkZAGQZGQB9MhkZGT+1GRkZMgBkP7UAAAAAgAAAAABkAH0
        AA8AEwAAETM1IREjNSMVIxUjNTM1IzcVMzVkASxkZGRkZGRkyAGQZP4MyGRkZMhkZGQAAgAAAAABkAH0AAsADwAAETM1MxUzESM1IxUjEzM1I2TIZGTIZGTI
        yAGQZGT+cMjIASxkAAIAAAAAAZAB9AALAA8AABEhFSEVMxUzFSMVITczNSMBkP7UyGRk/tRkyMgB9GRkZGRkZGQAAAAAAwAAAAABkAH0AAsADwATAAARIRUz
        FSMVMxUjFSETFTM1AzM1IwEsZGRkZP7UZMjIyMgB9GRkZGRkAZBkY/7VZAAAAAABAAAAAAGQAfQABQAAESEVIREjAZD+1GQB9GT+cAAAAAIAAP+cAfQB9AAN
        ABEAADUzETM1MxEzFSM1IRUjASMRM2RkyGRk/tRkASxkZGQBLGT+cMhkZAH0/tQAAAEAAAAAAZAB9AALAAARIRUhFTMVIxUhFSEBkP7UyMgBLP5wAfRkZGRk
        ZAAAAQAAAAAB9AH0ABsAABEzFTM1MxUzNTMVIxUzFSM1IxUjNSMVIzUzNSNkZGRkZGRkZGRkZGRkZAH0yMjIyMhkyMjIyMjIZAAAAQAAAAABkAH0ABMAABMz
        NSE1IRUzFSMVMxUjFSE1ITUjZMj+1AEsZGRkZP7UASzIASxkZGRkZGRkZGQAAQAAAAABkAH0AA8AABEzETM1MzUzESM1IxUjFSNkZGRkZGRkZAH0/tRkyP4M
        yGRkAAAAAAIAAAAAAZACvAAPABMAABEzETM1MzUzESM1IxUjFSMTMxUjZGRkZGRkZGRkyMgB9P7UZMj+DMhkZAK8ZAAAAAABAAAAAAGQAfQAFwAAETMVMzUz
        NTMVIxUjFTMVMxUjNSM1IxUjZGRkZGRkZGRkZGRkAfTIZGRkZGRkZGRkyAAAAQAAAAABkAH0AAkAABEzNSERIxEjESNkASxkyGQBkGT+DAGQ/nAAAAEAAAAA
        AfQB9AATAAARMxUzFTM1MzUzESMRIxUjNSMRI2RkZGRkZGRkZGQB9GRkZGT+DAEsZGT+1AAAAAEAAAAAAZAB9AALAAARMxUzNTMRIzUjFSNkyGRkyGQB9MjI
        /gzIyAACAAAAAAGQAfQACwAPAAARMzUzFTMRIxUjNSM7AREjZMhkZMhkZMjIAZBkZP7UZGQBLAAAAQAAAAABkAH0AAcAABEhESMRIxEjAZBkyGQB9P4MAZD+
        cAAAAgAAAAABkAH0AAkADQAAESEVMxUjFSMVIxMzNSMBLGRkyGRkyMgB9GRkZMgBLGQAAQAAAAABkAH0AAsAABEzNSEVIREhFSE1I2QBLP7UASz+1GQBkGRk
        /tRkZAABAAAAAAEsAfQABwAAESEVIxEjESMBLGRkZAH0ZP5wAZAAAAABAAAAAAGQAfQADwAAETMVMzUzESMVIzUzNSM1I2TIZGTIyMhkAfTIyP5wZGRkZAAD
        AAAAAAH0AfQADwATABcAABEzNSEVMxUjFSMVIzUjNSM7ATUjISMVM2QBLGRkZGRkZGRkZAEsZGQBkGRkyGRkZGTIyAAAAAABAAAAAAGQAfQAEwAAETMVMzUz
        FSMVMxUjNSMVIzUzNSNkyGRkZGTIZGRkAfTIyMhkyMjIyGQAAAEAAP+cAfQB9AALAAARMxEzETMRMxUjNSFkyGRkZP5wAfT+cAGQ/nDIZAAAAQAAAAABkAH0
        AAsAABEzFTM1MxEjNSM1I2TIZGTIZAH0yMj+DMhkAAEAAAAAAfQB9AALAAARMxEzETMRMxEzESFkZGRkZP4MAfT+cAGQ/nABkP4MAAAAAAEAAP+cAlgB9AAP
        AAARMxEzETMRMxEzETMVIzUhZGRkZGRkZP4MAfT+cAGQ/nABkP5wyGQAAAAAAgAAAAAB9AH0AAsADwAAETMVMxUzFSMVIREjFxUzNcjIZGT+1GTIyAH0yGRk
        ZAGQyGRjAAMAAAAAAlgB9AAJAA0AEQAAETMVMxUzFSMVIQEzESMlMzUjZMhkZP7UAfRkZP5wyMgB9MhkZGQB9P4MZGQAAAACAAAAAAGQAfQACQANAAARMxUz
        FTMVIxUhNzM1I2TIZGT+1GTIyAH0yGRkZGRkAAABAAAAAAGQAfQADwAAEzM1ITUhFTMRIxUhNSE1I2TI/tQBLGRk/tQBLMgBLGRkZP7UZGRkAAAAAAIAAAAA
        AfQB9AATABcAABEzFTM1MzUzFTMRIxUjNSM1IxUjASMRM2RkZGRkZGRkZGQBkGRkAfTIZGRk/tRkZGTIAZD+1AAAAAIAAAAAAZAB9AAPABMAABEzNSERIzUj
        FSMVIzUzNSM3FTM1ZAEsZGRkZGRkZMgBkGT+DMhkZGTIZGRkAAIAAAAAAGQB9AADAAcAABEzESMRMxUjZGRkZAEs/tQB9GQAAAIAAP+cAfQCWAATABcAABEz
        NTM1MxUzFSMRMxUjFSM1IzUjOwERI2RkZMjIyMhkZGRkZGQBkGRkZGT+1GRkZGQBLAAAAQAAAAABkAH0ABMAABEzNTM1MxUjFTMVIxUzFSE1MzUjZGTIyGRk
        yP5wZGQBLGRkZGRkZGRkZAABAAAAAAEsAlgAFwAAETMVMzUzFSMVMxUjFTMVITUzNSM1MzUjZGRkZGRkZP7UZGRkZAJYyMjIZGRkZGRkZGQAAgAAAZABLAH0
        AAMABwAAETMVIzczFSNkZMhkZAH0ZGRkAAAAAgAAAAABkAH0AA0AEQAAEzMVMxEhNSM1MzUzNSMRMzUjZMhk/tRkZMjIyMgB9GT+cGRkZGT+1GQAAAAAAQAA
        AMgBkAK8ABEAABEhFTMVIxUjFSEVITUzNTM1IQEsZGTIASz+cGTI/tQCvGRkZGRkyGRkAAABAAAAyAGQArwAEwAAEzM1ITUhFTMVIxUzFSMVITUhNSNkyP7U
        ASxkZGRk/tQBLMgB9GRkZGRkZGRkZAABAAABLADIAfQABwAAETM1MxUjFSNkZGRkAZBkZGQAAAEAAP84ASwAAAAHAAAVMzUzFSMVI8hkZMhkZGRkAAAAAQAA
        AMgBLAK8AAsAABEzNTMRMxUhNTM1I2RkZP7UZGQCWGT+cGRkyAAAAAACAAAAyAGQArwACwAPAAARMzUzFTMRIxUjNSM7AREjZMhkZMhkZMjIAlhkZP7UZGQB
        LAAAAwAA/zgEsAK8AAkAEwAnAAABMxUzNTMRIzUhATMRMxUhNTMRIwEzNTM1MzUzNTMVIxUjFSMVIxUjAyBkyGRk/tT84Mhk/tRkZAEsZGRkZGRkZGRkZAEs
        yMj+DMgCvP5wZGQBLP4MZGRkZGRkZGRkAAMAAP84BLACvAARABsALwAAITM1MzUhNSEVMxUjFSMVIRUhATMRMxUhNTMRIwEzNTM1MzUzNTMVIxUjFSMVIxUj
        AyBkyP7UASxkZMgBLP5w/ODIZP7UZGQBLGRkZGRkZGRkZGRkZGRkZGRkZAOE/nBkZAEs/gxkZGRkZGRkZGQAAwAA/zgEsAK8ABMAHQAxAAATMzUhNSEVMxUj
        FTMVIxUhNSE1IwUzFTM1MxEjNSElMzUzNTM1MzUzFSMVIxUjFSMVI2TI/tQBLGRkZGT+1AEsyAK8ZMhkZP7U/gxkZGRkZGRkZGRkAfRkZGRkZGRkZGRkyMj+
        DMhkZGRkZGRkZGRkAAAAAgAAAAABkAH0AAsADwAANTM1MxUjFSEVITUjEzMVI2TIyAEs/tRkyGRkyGRkZGRkAZBkAAMAAAAAAZADIAAHABMAFwAAETMVMxUj
        NSMRMzUzFTMRIzUjFSMTMzUjZGRkZGTIZGTIZGTIyAMgZGRk/tRkZP5wyMgBLGQAAAMAAAAAAZADIAAHABMAFwAAEzM1MxUjFSMHMzUzFTMRIzUjFSMTMzUj
        yGRkZGTIZMhkZMhkZMjIArxkZGTIZGT+cMjIASxkAAMAAAAAAZADIAALABcAGwAAETM1MxUzFSM1IxUjFTM1MxUzESM1IxUjEzM1I2TIZGTIZGTIZGTIZGTI
        yAK8ZGRkZGTIZGT+cMjIASxkAAAAAwAAAAABkAMgAA8AGwAfAAARMzUzFTM1MxUjFSM1IxUjFTM1MxUzESM1IxUjEzM1I2RkZGRkZGRkZMhkZMhkZMjIArxk
        ZGRkZGRkyGRk/nDIyAEsZAAAAAQAAAAAAZACvAADAAcAEwAXAAARMxUjJTMVIwUzNTMVMxEjNSMVIxMzNSNkZAEsZGT+1GTIZGTIZGTIyAK8ZGRkyGRk/nDI
        yAEsZAADAAAAAAGQArwAEwAXABsAABEzNTMVMxUjFTMRIzUjFSMRMzUjOwE1Ix0BMzVkyGRkZGTIZGRkZMjIyAJYZGRkZP5wyMgBkGRkyGRjAAAAAAIAAAAA
        AfQB9AARABUAABEzNSEVIxUzFSMVMxUhNSMVIxMzNSNkAZDIZGTI/tRkZGRkZAGQZGRkZGRkyMgBLGQAAAAAAQAA/zgBkAH0ABMAABEzNSEVIREhFSMVIxUj
        NTM1IzUjZAEs/tQBLGRkyMhkZAGQZGT+1GRkZGRkZAAAAgAAAAABkAMgAAsAEwAAESEVIRUzFSMVIRUhETMVMxUjNSMBkP7UyMgBLP5wZGRkZAH0ZGRkZGQD
        IGRkZAAAAAIAAAAAAZADIAALABMAABEhFSEVMxUjFSEVIRMzNTMVIxUjAZD+1MjIASz+cMhkZGRkAfRkZGRkZAK8ZGRkAAACAAAAAAGQAyAACwAXAAARIRUh
        FTMVIxUhFSERMzUzFTMVIzUjFSMBkP7UyMgBLP5wZMhkZMhkAfRkZGRkZAK8ZGRkZGQAAAADAAAAAAGQArwACwAPABMAABEhFSEVMxUjFSEVIREzFSMlMxUj
        AZD+1MjIASz+cGRkASxkZAH0ZGRkZGQCvGRkZAAAAAIAAAAAASwDIAALABMAABEhFSMRMxUhNTMRIxEzFTMVIzUjASxkZP7UZGRkZGRkAfRk/tRkZAEsAZBk
        ZGQAAAACAAAAAAEsAyAACwATAAARIRUjETMVITUzESMTMzUzFSMVIwEsZGT+1GRkZGRkZGQB9GT+1GRkASwBLGRkZAAAAgAAAAABLAMgAAsAFwAAESEVIxEz
        FSE1MxEjETM1MxUzFSM1IxUjASxkZP7UZGRkZGRkZGQB9GT+1GRkASwBLGRkZGRkAAAAAwAAAAABLAK8AAsADwATAAARIRUjETMVITUzESMRMxUjNzMVIwEs
        ZGT+1GRkZGTIZGQB9GT+1GRkASwBLGRkZAAAAAACAAAAAAH0AfQACwATAAARMzUhFTMRIxUhNSM3MxUjFTMRI2QBLGRk/tRkyGRkyMgBLMhk/tRkyGRkZAEs
        AAAAAgAAAAABkAMgAA8AHwAAETMVMxUzNTMRIzUjNSMRIxEzNTMVMzUzFSMVIzUjFSNkZGRkZGRkZGRkZGRkZGRkAfRkZMj+DMhk/tQCvGRkZGRkZGQAAwAA
        AAABkAMgAAsADwAXAAARMzUzFTMRIxUjNSM7AREjAzMVMxUjNSNkyGRkyGRkyMhkZGRkZAGQZGT+1GRkASwBkGRkZAAAAwAAAAABkAMgAAsADwAXAAARMzUz
        FTMRIxUjNSM7AREjEzM1MxUjFSNkyGRkyGRkyMhkZGRkZAGQZGT+1GRkASwBLGRkZAAAAwAAAAABkAMgAAsADwAbAAARMzUzFTMRIxUjNSM7AREjAzM1MxUz
        FSM1IxUjZMhkZMhkZMjIZGTIZGTIZAGQZGT+1GRkASwBLGRkZGRkAAADAAAAAAGQAyAACwAPAB8AABEzNTMVMxEjFSM1IzsBESMDMzUzFTM1MxUjFSM1IxUj
        ZMhkZMhkZMjIZGRkZGRkZGRkAZBkZP7UZGQBLAEsZGRkZGRkZAAABAAAAAABkAK8AAsADwATABcAABEzNTMVMxEjFSM1IzsBESMTMxUjJTMVI2TIZGTIZGTI
        yMhkZP7UZGQBkGRk/tRkZAEsASxkZGQAAAEAAABkASwBkAATAAARMxUzNTMVIxUzFSM1IxUjNTM1I2RkZGRkZGRkZGQBkGRkZGRkZGRkZAAAAwAAAAAB9AH0
        AAsAEQAXAAARMzUhFTMRIxUhNSM3MzUzNSMXFTM1IxVkASxkZP7UZGRkZMhkyGQBkGRk/tRkZGRkZMhkyGQAAgAAAAABkAMgAAsAEwAAETMRMxEzESMVIzUj
        ETMVMxUjNSNkyGRkyGRkZGRkAfT+cAGQ/nBkZAK8ZGRkAAAAAAIAAAAAAZADIAALABMAABEzETMRMxEjFSM1IxMzNTMVIxUjZMhkZMhkyGRkZGQB9P5wAZD+
        cGRkAlhkZGQAAAACAAAAAAGQAyAACwAXAAARMxEzETMRIxUjNSMRMzUzFTMVIzUjFSNkyGRkyGRkyGRkyGQB9P5wAZD+cGRkAlhkZGRkZAAAAAADAAAAAAGQ
        ArwACwAPABMAABEzETMRMxEjFSM1IxEzFSMlMxUjZMhkZMhkZGQBLGRkAfT+cAGQ/nBkZAJYZGRkAAAAAAIAAAAAASwDIAALABMAABEzFTM1MxUjESMRIxMz
        NTMVIxUjZGRkZGRkZGRkZGQB9MjIyP7UASwBkGRkZAAAAAACAAAAAAGQAfQACwAPAAARMxUzFTMVIxUjFSMTFTM1ZMhkZMhkZMgB9GRkZGRkASxkYwAAAgAA
        AAABkAH0ABMAFwAAETM1MxUzFSMVMxUjFSM1MzUjFSMTMzUjZMhkZGRkZGTIZGTIyAGQZGRkZGRkZGTIASxkAAADAAAAAAGQAyAABwATABcAABEzFTMVIzUj
        ETM1MxUzESM1IxUjEzM1I2RkZGRkyGRkyGRkyMgDIGRkZP7UZGT+cMjIASxkAAADAAAAAAGQAyAABwATABcAABMzNTMVIxUjBzM1MxUzESM1IxUjEzM1I8hk
        ZGRkyGTIZGTIZGTIyAK8ZGRkyGRk/nDIyAEsZAADAAAAAAGQAyAACwAXABsAABEzNTMVMxUjNSMVIxUzNTMVMxEjNSMVIxMzNSNkyGRkyGRkyGRkyGRkyMgC
        vGRkZGRkyGRk/nDIyAEsZAAAAAMAAAAAAZADIAAPABsAHwAAETM1MxUzNTMVIxUjNSMVIxUzNTMVMxEjNSMVIxMzNSNkZGRkZGRkZGTIZGTIZGTIyAK8ZGRk
        ZGRkZMhkZP5wyMgBLGQAAAAEAAAAAAGQArwAAwAHABMAFwAAETMVIyUzFSMFMzUzFTMRIzUjFSMTMzUjZGQBLGRk/tRkyGRkyGRkyMgCvGRkZMhkZP5wyMgB
        LGQAAwAAAAABkAK8ABMAFwAbAAARMzUzFTMVIxUzESM1IxUjETM1IzsBNSMdATM1ZMhkZGRkyGRkZGTIyMgCWGRkZGT+cMjIAZBkZMhkYwAAAAACAAAAAAH0
        AfQAEQAVAAARMzUhFSMVMxUjFTMVITUjFSMTMzUjZAGQyGRkyP7UZGRkZGQBkGRkZGRkZMjIASxkAAAAAAEAAP84AZAB9AATAAARMzUhFSERIRUjFSMVIzUz
        NSM1I2QBLP7UASxkZMjIZGQBkGRk/tRkZGRkZGQAAAIAAAAAAZADIAALABMAABEhFSEVMxUjFSEVIREzFTMVIzUjAZD+1MjIASz+cGRkZGQB9GRkZGRkAyBk
        ZGQAAAACAAAAAAGQAyAACwATAAARIRUhFTMVIxUhFSETMzUzFSMVIwGQ/tTIyAEs/nDIZGRkZAH0ZGRkZGQCvGRkZAAAAgAAAAABkAMgAAsAFwAAESEVIRUz
        FSMVIRUhETM1MxUzFSM1IxUjAZD+1MjIASz+cGTIZGTIZAH0ZGRkZGQCvGRkZGRkAAAAAwAAAAABkAK8AAsADwATAAARIRUhFTMVIxUhFSERMxUjJTMVIwGQ
        /tTIyAEs/nBkZAEsZGQB9GRkZGRkArxkZGQAAAACAAAAAAEsAyAACwATAAARIRUjETMVITUzESMRMxUzFSM1IwEsZGT+1GRkZGRkZAH0ZP7UZGQBLAGQZGRk
        AAAAAgAAAAABLAMgAAsAEwAAESEVIxEzFSE1MxEjEzM1MxUjFSMBLGRk/tRkZGRkZGRkAfRk/tRkZAEsASxkZGQAAAIAAAAAASwDIAALABcAABEhFSMRMxUh
        NTMRIxEzNTMVMxUjNSMVIwEsZGT+1GRkZGRkZGRkAfRk/tRkZAEsASxkZGRkZAAAAAMAAAAAASwCvAALAA8AEwAAESEVIxEzFSE1MxEjETMVIzczFSMBLGRk
        /tRkZGRkyGRkAfRk/tRkZAEsASxkZGQAAAAAAgAAAAAB9AH0AAsAEwAAETM1IRUzESMVITUjNzMVIxUzESNkASxkZP7UZMhkZMjIASzIZP7UZMhkZGQBLAAA
        AAIAAAAAAZADIAAPAB8AABEzFTMVMzUzESM1IzUjESMRMzUzFTM1MxUjFSM1IxUjZGRkZGRkZGRkZGRkZGRkZAH0ZGTI/gzIZP7UArxkZGRkZGRkAAMAAAAA
        AZADIAALAA8AFwAAETM1MxUzESMVIzUjOwERIwMzFTMVIzUjZMhkZMhkZMjIZGRkZGQBkGRk/tRkZAEsAZBkZGQAAAMAAAAAAZADIAALAA8AFwAAETM1MxUz
        ESMVIzUjOwERIxMzNTMVIxUjZMhkZMhkZMjIZGRkZGQBkGRk/tRkZAEsASxkZGQAAAMAAAAAAZADIAALAA8AGwAAETM1MxUzESMVIzUjOwERIwMzNTMVMxUj
        NSMVI2TIZGTIZGTIyGRkyGRkyGQBkGRk/tRkZAEsASxkZGRkZAAAAwAAAAABkAMgAAsADwAfAAARMzUzFTMRIxUjNSM7AREjAzM1MxUzNTMVIxUjNSMVI2TI
        ZGTIZGTIyGRkZGRkZGRkZAGQZGT+1GRkASwBLGRkZGRkZGQAAAQAAAAAAZACvAALAA8AEwAXAAARMzUzFTMRIxUjNSM7AREjEzMVIyUzFSNkyGRkyGRkyMjI
        ZGT+1GRkAZBkZP7UZGQBLAEsZGRkAAADAAAAAAEsAfQAAwAHAAsAABEhFSEXMxUjETMVIwEs/tRkZGRkZAEsZGRkAfRkAAADAAAAAAH0AfQACwARABcAABEz
        NSEVMxEjFSE1IzczNTM1IxcVMzUjFWQBLGRk/tRkZGRkyGTIZAGQZGT+1GRkZGRkyGTIZAACAAAAAAGQAyAACwATAAARMxEzETMRIxUjNSMRMxUzFSM1I2TI
        ZGTIZGRkZGQB9P5wAZD+cGRkArxkZGQAAAAAAgAAAAABkAMgAAsAEwAAETMRMxEzESMVIzUjEzM1MxUjFSNkyGRkyGTIZGRkZAH0/nABkP5wZGQCWGRkZAAA
        AAIAAAAAAZADIAALABcAABEzETMRMxEjFSM1IxEzNTMVMxUjNSMVI2TIZGTIZGTIZGTIZAH0/nABkP5wZGQCWGRkZGRkAAAAAAMAAAAAAZACvAALAA8AEwAA
        ETMRMxEzESMVIzUjETMVIyUzFSNkyGRkyGRkZAEsZGQB9P5wAZD+cGRkAlhkZGQAAAAAAgAAAAABLAMgAAsAEwAAETMVMzUzFSMRIxEjEzM1MxUjFSNkZGRk
        ZGRkZGRkZAH0yMjI/tQBLAGQZGRkAAAAAAIAAAAAAZAB9AALAA8AABEzFTMVMxUjFSMVIxMVMzVkyGRkyGRkyAH0ZGRkZGQBLGRjAAADAAAAAAEsArwACwAP
        ABMAABEzFTM1MxUjESMRIxEzFSM3MxUjZGRkZGRkZGTIZGQB9MjIyP7UASwBkGRkZAAAAgAAAAAB9AH0AA8AEwAAETM1IRUjFTMVIxUzFSE1IzsBESNkAZDI
        ZGTI/nBkZGRkAZBkZGRkZGRkASwAAgAAAAAB9AH0AA8AEwAAETM1IRUjFTMVIxUzFSE1IzsBESNkAZDIZGTI/nBkZGRkAZBkZGRkZGRkASwAAgAAAAABkAMg
        ABMAHwAAETM1IRUhFTMVMxUjFSE1ITUjNSMTMxUzNTMVIxUjNSNkASz+1MhkZP7UASzIZGRkZGRkZGQBkGRkZGRkZGRkZAH0ZGRkZGQAAAIAAAAAAZADIAAT
        AB8AABEzNSEVIRUzFTMVIxUhNSE1IzUjEzMVMzUzFSMVIzUjZAEs/tTIZGT+1AEsyGRkZGRkZGRkAZBkZGRkZGRkZGQB9GRkZGRkAAADAAAAAAEsArwACwAP
        ABMAABEzFTM1MxUjESMRIxEzFSM3MxUjZGRkZGRkZGTIZGQB9MjIyP7UASwBkGRkZAAAAgAAAAABkAMgAA8AGwAAESEVIxUjFSEVITUzNTM1IRMzFTM1MxUj
        FSM1IwGQZMgBLP5wZMj+1GRkZGRkZGQB9MhkZGTIZGQBkGRkZGRkAAACAAAAAAGQAyAADwAbAAARIRUjFSMVIRUhNTM1MzUhEzMVMzUzFSMVIzUjAZBkyAEs
        /nBkyP7UZGRkZGRkZAH0yGRkZMhkZAGQZGRkZGQAAAEAAP84AZAB9AATAAARMzUzNTMVIxUzFSMRIxUjNTMRI2RkyMhkZGRkZGQBLGRkZGRk/tRkZAEsAAAA
        AAEAAAEsASwB9AALAAARMzUzFTMVIzUjFSNkZGRkZGQBkGRkZGRkAAABAAABLAGQAfQADwAAETM1MxUzNTMVIxUjNSMVI2RkZGRkZGRkAZBkZGRkZGRkAAAC
        AAAAAAH0AfQAGwAfAAARMzUzFTM1MxUzFSMVMxUjFSM1IxUjNSM1MzUjFzM1I2RkZGRkZGRkZGRkZGRkyGRkAZBkZGRkZGRkZGRkZGRkZGQAAAACAAAAAABk
        AfQAAwAHAAARMxEjFTMVI2RkZGQB9P7UZGQAAAACAAABLAEsAfQAAwAHAAARMxUjNzMVI2RkyGRkAfTIyMgAAAAAAAAAAAAAAAAAMABYAIgAlACoAL4A2gDu
        AP4BDAEYATQBTgFkAYABngGyAcwB6gICAigCRgJYAm4CigKeAroC1ALwAwoDLANCA1oDcAOEA54DsgPIA+AEAAQQBC4ESARiBHoEmgS4BNYE6AT+BRQFMgVO
        BWQFfgWOBaoFvAXYBeQF9AYOBjAGRgZeBnQGiAaiBrYGzAbkBwQHFAcyB0wHZgd+B54HvAfaB+wIAggYCDYIUghoCIIIlgiiCLYIzgjsCQYJFgkwCUoJYgl4
        CZQJugnoCggKJApECm4KiAqeCrwKzArcCvYLEAscCyoLOAtcC3wLmAu4C+IL/AwSDDQMVgxuDIoMnAyuDNIM9A0aDTQNZg12DYINtA3WDfAOCg4gDjYOSA5m
        DnwOiA6qDswO5g8YDzAPTg9sD44PqA/ED+YP9hAUECoQThBsEIYQphDGENoQ+BEMESYROBFQEWYReBGQEbQR0BHmEfoSEhIuEkgSaBKAEpwSwBLeEvgTFBM2
        E0YTZBN6E54TvBPWE/YUFhQqFEgUXBR2FIgUoBS2FMgU4BUEFSAVNhVKFWIVfhWYFbgV0BXsFhAWLhYuFi4WQBZiFn4WnhawFs4W6hcIFxgXKBc+F1gXkBfQ
        GBIYLBhQGHQYnBjIGO4ZFhk4GVYZdhmWGboZ3Bn8GhwaQBpiGoIarBrQGvQbHBtIG24bihuuG84b7hwSHDQcVBxuHJActBzYHQAdLB1SHXodnB26Hdod+h4e
        HkAeYB6AHqQexh7mHxAfNB9YH4AfrB/SH+ogDiAuIE4gciCUILQgziDuIQwhKiFWIYIhoiHKIfIiECIkIjwiZiJ4IooAAAAAABcBGgABAAAAAAAAAE0AAAAB
        AAAAAAABABAATQABAAAAAAACAAcAXQABAAAAAAADAB8AZAABAAAAAAAEABAAgwABAAAAAAAFAA0AkwABAAAAAAAGAA8AoAABAAAAAAAIAAcArwABAAAAAAAJ
        ABEAtgABAAAAAAAMABkAxwABAAAAAAANACEA4AABAAAAAAASABABAQADAAEECQAAAJoBEQADAAEECQABACABqwADAAEECQACAA4BywADAAEECQADAD4B2QAD
        AAEECQAEACACFwADAAEECQAFABoCNwADAAEECQAGAB4CUQADAAEECQAIAA4CbwADAAEECQAJACICfQADAAEECQAMADICnwADAAEECQANAEIC0UNvcHlyaWdo
        dCAoYykgMjAxMyBieSBTdHlsZS03LiBBbGwgcmlnaHRzIHJlc2VydmVkLiBodHRwOi8vd3d3LnN0eWxlc2V2ZW4uY29tU21hbGxlc3QgUGl4ZWwtN1JlZ3Vs
        YXJTdHlsZS03OiBTbWFsbGVzdCBQaXhlbC03OiAyMDEzU21hbGxlc3QgUGl4ZWwtN1ZlcnNpb24gMS4wMDBTbWFsbGVzdFBpeGVsLTdTdHlsZS03U2l6ZW5r
        byBBbGV4YW5kZXJodHRwOi8vd3d3LnN0eWxlc2V2ZW4uY29tRnJlZXdhcmUgZm9yIHBlcnNvbmFsIHVzaW5nIG9ubHkuU21hbGxlc3QgUGl4ZWwtNwBDAG8A
        cAB5AHIAaQBnAGgAdAAgACgAYwApACAAMgAwADEAMwAgAGIAeQAgAFMAdAB5AGwAZQAtADcALgAgAEEAbABsACAAcgBpAGcAaAB0AHMAIAByAGUAcwBlAHIA
        dgBlAGQALgAgAGgAdAB0AHAAOgAvAC8AdwB3AHcALgBzAHQAeQBsAGUAcwBlAHYAZQBuAC4AYwBvAG0AUwBtAGEAbABsAGUAcwB0ACAAUABpAHgAZQBsAC0A
        NwBSAGUAZwB1AGwAYQByAFMAdAB5AGwAZQAtADcAOgAgAFMAbQBhAGwAbABlAHMAdAAgAFAAaQB4AGUAbAAtADcAOgAgADIAMAAxADMAUwBtAGEAbABsAGUA
        cwB0ACAAUABpAHgAZQBsAC0ANwBWAGUAcgBzAGkAbwBuACAAMQAuADAAMAAwAFMAbQBhAGwAbABlAHMAdABQAGkAeABlAGwALQA3AFMAdAB5AGwAZQAtADcA
        UwBpAHoAZQBuAGsAbwAgAEEAbABlAHgAYQBuAGQAZQByAGgAdAB0AHAAOgAvAC8AdwB3AHcALgBzAHQAeQBsAGUAcwBlAHYAZQBuAC4AYwBvAG0ARgByAGUA
        ZQB3AGEAcgBlACAAZgBvAHIAIABwAGUAcgBzAG8AbgBhAGwAIAB1AHMAaQBuAGcAIABvAG4AbAB5AC4AAAAAAgAAAAAAAP+1ADIAAAAAAAAAAAAAAAAAAAAA
        AAAAAAE8AAABAgACAAMABwAIAAkACgALAAwADQAOAA8AEAARABIAEwAUABUAFgAXABgAGQAaABsAHAAdAB4AHwAgACEAIgAjACQAJQAmACcAKAApACoAKwAs
        AC0ALgAvADAAMQAyADMANAA1ADYANwA4ADkAOgA7ADwAPQA+AD8AQABBAEIAQwBEAEUARgBHAEgASQBKAEsATABNAE4ATwBQAFEAUgBTAFQAVQBWAFcAWABZ
        AFoAWwBcAF0AXgBfAGAAYQEDAQQAxAEFAMUAqwCCAMIBBgDGAQcAvgEIAQkBCgELAQwAtgC3ALQAtQCHALIAswCMAQ0AvwEOAQ8BEAERARIBEwEUAL0BFQDo
        AIYBFgCLARcAqQCkARgAigEZAIMAkwEaARsBHACXAIgBHQEeAR8BIACqASEBIgEjASQBJQEmAScBKAEpASoBKwEsAS0BLgEvATABMQEyATMBNAE1ATYBNwE4
        ATkBOgE7ATwBPQE+AT8BQAFBAUIBQwFEAUUBRgFHAUgBSQFKAUsBTAFNAU4BTwFQAVEBUgFTAVQBVQFWAVcBWAFZAVoBWwFcAV0BXgFfAWABYQFiAWMBZAFl
        AWYAowCEAIUAlgCOAJ0A8gDzAI0A3gDxAJ4A9QD0APYAogCtAMkAxwCuAGIAYwCQAGQAywBlAMgAygDPAMwAzQDOAOkAZgDTANAA0QCvAGcA8ACRANYA1ADV
        AGgA6wDtAIkAagBpAGsAbQBsAG4AoABvAHEAcAByAHMAdQB0AHYAdwDqAHgAegB5AHsAfQB8ALgAoQB/AH4AgACBAOwA7gC6ALAAsQDkAOUAuwDmAOcApgDY
        ANkABgAEAAUFLm51bGwJYWZpaTEwMDUxCWFmaWkxMDA1MglhZmlpMTAxMDAERXVybwlhZmlpMTAwNTgJYWZpaTEwMDU5CWFmaWkxMDA2MQlhZmlpMTAwNjAJ
        YWZpaTEwMTQ1CWFmaWkxMDA5OQlhZmlpMTAxMDYJYWZpaTEwMTA3CWFmaWkxMDEwOQlhZmlpMTAxMDgJYWZpaTEwMTkzCWFmaWkxMDA2MglhZmlpMTAxMTAJ
        YWZpaTEwMDU3CWFmaWkxMDA1MAlhZmlpMTAwMjMJYWZpaTEwMDUzB3VuaTAwQUQJYWZpaTEwMDU2CWFmaWkxMDA1NQlhZmlpMTAxMDMJYWZpaTEwMDk4DnBl
        cmlvZGNlbnRlcmVkCWFmaWkxMDA3MQlhZmlpNjEzNTIJYWZpaTEwMTAxCWFmaWkxMDEwNQlhZmlpMTAwNTQJYWZpaTEwMTAyCWFmaWkxMDEwNAlhZmlpMTAw
        MTcJYWZpaTEwMDE4CWFmaWkxMDAxOQlhZmlpMTAwMjAJYWZpaTEwMDIxCWFmaWkxMDAyMglhZmlpMTAwMjQJYWZpaTEwMDI1CWFmaWkxMDAyNglhZmlpMTAw
        MjcJYWZpaTEwMDI4CWFmaWkxMDAyOQlhZmlpMTAwMzAJYWZpaTEwMDMxCWFmaWkxMDAzMglhZmlpMTAwMzMJYWZpaTEwMDM0CWFmaWkxMDAzNQlhZmlpMTAw
        MzYJYWZpaTEwMDM3CWFmaWkxMDAzOAlhZmlpMTAwMzkJYWZpaTEwMDQwCWFmaWkxMDA0MQlhZmlpMTAwNDIJYWZpaTEwMDQzCWFmaWkxMDA0NAlhZmlpMTAw
        NDUJYWZpaTEwMDQ2CWFmaWkxMDA0NwlhZmlpMTAwNDgJYWZpaTEwMDQ5CWFmaWkxMDA2NQlhZmlpMTAwNjYJYWZpaTEwMDY3CWFmaWkxMDA2OAlhZmlpMTAw
        NjkJYWZpaTEwMDcwCWFmaWkxMDA3MglhZmlpMTAwNzMJYWZpaTEwMDc0CWFmaWkxMDA3NQlhZmlpMTAwNzYJYWZpaTEwMDc3CWFmaWkxMDA3OAlhZmlpMTAw
        NzkJYWZpaTEwMDgwCWFmaWkxMDA4MQlhZmlpMTAwODIJYWZpaTEwMDgzCWFmaWkxMDA4NAlhZmlpMTAwODUJYWZpaTEwMDg2CWFmaWkxMDA4NwlhZmlpMTAw
        ODgJYWZpaTEwMDg5CWFmaWkxMDA5MAlhZmlpMTAwOTEJYWZpaTEwMDkyCWFmaWkxMDA5MwlhZmlpMTAwOTQJYWZpaTEwMDk1CWFmaWkxMDA5NglhZmlpMTAw
        OTcNYWZpaTEwMDQ1LjAwMQ1hZmlpMTAwNDcuMDAxAAAAAAAB//8AAA==
]]

    pcall(function()
        local ttfPath = Library.Folders.Assets .. "/SmallestPixel.ttf"
        local jsonPath = Library.Folders.Assets .. "/SmallestPixel.json"
        if not isfile(ttfPath) then
            writefile(ttfPath, decode_base64(smallest_pixel_b64))
        end
        local assetId = getcustomasset(ttfPath)
        writefile(jsonPath, HttpService:JSONEncode({
            name = "SmallestPixel",
            faces = {{
                name = "Regular",
                weight = 400,
                style = "Regular",
                assetId = assetId
            }}
        }))
    end)

    CustomFont:New("SmallestPixel", 400, "Regular", {Url = "https://github.com/Syqx906/UWU-ttfs/raw/refs/heads/main/smallest_pixel-7.ttf"})
    CustomFont:New("ProggyClean", 400, "Regular", {Url = "https://github.com/Syqx906/UWU-ttfs/raw/refs/heads/main/proggy-clean.ttf"})
    CustomFont:New("TahomaXP", 400, "Regular", {Url = "https://github.com/Syqx906/UWU-ttfs/raw/refs/heads/main/windows-xp-tahoma.ttf"})
    CustomFont:New("MinecraftiaRegular", 400, "Regular", {Url = "https://github.com/Syqx906/UWU-ttfs/raw/refs/heads/main/minecraftia-regular.ttf"})
    CustomFont:New("Monaco", 400, "Regular", {Url = "https://github.com/Syqx906/UWU-ttfs/raw/refs/heads/main/Monaco.ttf"})
    CustomFont:New("Verdana", 400, "Regular", {Url = "https://github.com/Syqx906/UWU-ttfs/raw/refs/heads/main/verdana.ttf"})
    CustomFont:New("TeachersPet", 400, "Regular", {Url = "https://github.com/Syqx906/UWU-ttfs/raw/refs/heads/main/teachers-pet.ttf"})
--     CustomFont:New("FSTahoma", 400, "Regular", {Url = "https://github.com/sametexe001/beta/raw/refs/heads/main/fs-tahoma-8px.ttf"})

    Library.Fonts["Smallest Pixel"] = CustomFont:Get("SmallestPixel")
    if not Library.Fonts["Smallest Pixel"] then
        pcall(function()
            local ttfPath = Library.Folders.Assets .. "/SmallestPixel.ttf"
            local jsonPath = Library.Folders.Assets .. "/SmallestPixel.json"
            if isfile(ttfPath) then
                writefile(jsonPath, HttpService:JSONEncode({
                    name = "SmallestPixel",
                    faces = {{name="Regular", weight=400, style="Regular", assetId=getcustomasset(ttfPath)}}
                }))
                Library.Fonts["Smallest Pixel"] = CustomFont:Get("SmallestPixel")
            end
        end)
    end
    Library.Fonts["Proggy Clean"] = CustomFont:Get("ProggyClean")
    Library.Fonts["Tahoma XP"] = CustomFont:Get("TahomaXP")
    Library.Fonts["Minecraftia"] = CustomFont:Get("MinecraftiaRegular")
    Library.Fonts["Monaco"] = CustomFont:Get("Monaco")
    Library.Fonts["Verdana"] = CustomFont:Get("Verdana")
    Library.Fonts["Teachers Pet"] = CustomFont:Get("TeachersPet")
--     Library.Fonts['FSTahoma'] = CustomFont:Get("FSTahoma")
    Library.Fonts['Gotham SSm'] = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.ExtraBold)

    -- Global font defaults to Smallest Pixel. If the bundled TTF is not ready yet,
    -- use a safe UI fallback temporarily; SetGlobalFont will switch to Smallest Pixel
    -- as soon as the FontFace becomes available.
    local SmallestPixelFont = Library.Fonts["Smallest Pixel"]
    Library.Font = SmallestPixelFont or Library.Fonts["Verdana"] or Font.new("rbxasset://fonts/families/GothamSSm.json")
    Library.espfont = SmallestPixelFont or Library.Fonts["Verdana"] or Font.new("rbxasset://fonts/families/GothamSSm.json")

    -- Global font support. Roblox UI objects can use the real custom FontFace.
    -- Drawing APIs generally expose only their built-in font enum, so custom TTF
    -- names are mapped to the closest available Drawing font for ESP.
    Library.FontName = "Smallest Pixel"
    Library.DrawingFont = Drawing.Fonts.Monospace
    Library.FontDrawingMap = {
        ["UI"] = Drawing.Fonts.UI,
        ["System"] = Drawing.Fonts.System,
        ["Plex"] = Drawing.Fonts.Plex,
        ["Monospace"] = Drawing.Fonts.Monospace,
        ["Smallest Pixel"] = Drawing.Fonts.Monospace,
        ["Proggy Clean"] = Drawing.Fonts.Monospace,
        ["Tahoma XP"] = Drawing.Fonts.Monospace,
        ["Minecraftia"] = Drawing.Fonts.Monospace,
        ["Monaco"] = Drawing.Fonts.Monospace,
        ["Verdana"] = Drawing.Fonts.Monospace,
        ["Teachers Pet"] = Drawing.Fonts.Monospace,
        ["Gotham SSm"] = Drawing.Fonts.Plex,
    }

    function Library:GetGlobalFontOptions()
        local options = {
            "UI", "System", "Plex", "Monospace",
            "Smallest Pixel", "Proggy Clean", "Tahoma XP", "Minecraftia",
            "Monaco", "Verdana", "Teachers Pet", "Gotham SSm"
        }
        for name, font in pairs(self.Fonts) do
            if font and not table.find(options, name) then
                table.insert(options, name)
            end
        end
        table.sort(options)
        return options
    end

    function Library:SetGlobalFont(name)
        name = tostring(name or "Verdana")
        local font = self.Fonts[name]
        if not font then
            -- Custom font files are downloaded asynchronously. If the user selects
            -- one before the download finishes, wait briefly and apply it as soon
            -- as the FontFace becomes available.
            task.spawn(function()
                for _ = 1, 30 do
                    task.wait(0.15)
                    local loaded = self.Fonts[name] or (CustomFont and CustomFont.Get and CustomFont:Get(name:gsub(" ", "")))
                    if loaded then
                        self.Fonts[name] = loaded
                        self:SetGlobalFont(name)
                        break
                    end
                end
            end)
            if name == "UI" or name == "System" or name == "Plex" or name == "Monospace" then
                font = self.Font
            else
                return false
            end
        end

        self.FontName = name
        self.Font = font
        self.espfont = font
        self.DrawingFont = self.FontDrawingMap[name] or Drawing.Fonts.Monospace

        -- Update every existing Roblox UI text object created by the library.
        pcall(function()
            local holder = self.Holder and self.Holder.Instance
            local unused = self.UnusedHolder and self.UnusedHolder.Instance
            local function apply(root)
                if not root then return end
                for _, obj in ipairs(root:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        obj.FontFace = font
                    end
                end
            end
            apply(holder)
            apply(unused)
        end)

        -- Update all Drawing text objects already registered by the script.
        pcall(function()
            for obj in pairs(cheat and cheat.drawings or {}) do
                pcall(function()
                    if obj and obj.Text ~= nil then
                        obj.Font = self.DrawingFont
                    end
                end)
            end
        end)

        -- Keep the ESP library in sync.
        pcall(function()
            if cheat and cheat.EspLibrary and cheat.EspLibrary.main_settings then
                cheat.EspLibrary.main_settings.textFont = self.DrawingFont
            end
            if cheat and cheat.EspLibrary and cheat.EspLibrary.icaca then
                cheat.EspLibrary.icaca()
            end
        end)
        return true
    end

    -- Apply the selected default after startup and retry while the bundled TTF
    -- finishes loading. This updates existing UI + Drawing ESP objects as well.
    task.spawn(function()
        for _ = 1, 80 do
            if Library.Fonts["Smallest Pixel"] then
                Library:SetGlobalFont("Smallest Pixel")
                break
            end
            task.wait(0.15)
        end
    end)
end

task.wait()

Library.Holder = Instances:Create("ScreenGui", {
    Parent = gethui(),
    Name = "\0",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    DisplayOrder = 2,
    IgnoreGuiInset = true,
    ResetOnSpawn = false
})

Library.UnusedHolder = Instances:Create("ScreenGui", {
    Parent = gethui(),
    Name = "\0",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    Enabled = false,
    ResetOnSpawn = false
})

Library.NotifHolder = Instances:Create("Frame", {
    Parent = Library.Holder.Instance,
    Name = "\0",
    BorderColor3 = FromRGB(0, 0, 0),
    AnchorPoint = Vector2New(1, 0),
    BackgroundTransparency = 1,
    Position = UDim2New(1, 0, 0, 0),
    Size = UDim2New(0, 0, 1, 0),
    BorderSizePixel = 0,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = FromRGB(255, 255, 255)
})

Instances:Create("UIListLayout", {
    Parent = Library.NotifHolder.Instance,
    Name = "\0",
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDimNew(0, 8)
})

Instances:Create("UIPadding", {
    Parent = Library.NotifHolder.Instance,
    Name = "\0",
    PaddingTop = UDimNew(0, 15),
    PaddingBottom = UDimNew(0, 15),
    PaddingRight = UDimNew(0, 15),
    PaddingLeft = UDimNew(0, 15)
})

task.wait()

Library.Unload = function(self)
    for Index, Value in self.Connections do 
        Value.Connection:Disconnect()
    end

    for Index, Value in self.Threads do 
        coroutine.close(Value)
    end

    if self.Holder then 
        self.Holder:Clean()
    end

    Library = nil 
    getgenv().Library = nil
end

Library.GetImage = function(self, Image)
    local ImageData = self.Images[Image]

    if not ImageData then 
        return
    end

    return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
end

Library.Round = function(self, Number, Float)
    local Multiplier = 1 / (Float or 1)
    return MathFloor(Number * Multiplier) / Multiplier
end

Library.Thread = function(self, Function)
    local NewThread = coroutine.create(Function)
    
    coroutine.wrap(function()
        coroutine.resume(NewThread)
    end)()

    TableInsert(self.Threads, NewThread)
    return NewThread
end

Library.SafeCall = function(self, Function, ...)
    local Arguements = { ... }
    local Success, Result = pcall(Function, TableUnpack(Arguements))

    if not Success then
        LocalPlayer:Kick("Tomboy.Hook Callback Error: " .. tostring(Result))
        return false
    end

    return Success
end

Library.Connect = function(self, Event, Callback, Name)
    self.UnnamedConnections = self.UnnamedConnections + 1
    Name = Name or StringFormat("connection_%d", self.UnnamedConnections)

    local NewConnection = {
        Event = Event,
        Callback = Callback,
        Name = Name,
        Connection = Event:Connect(Callback)
    }

    TableInsert(self.Connections, NewConnection)
    return NewConnection
end

-- Single shared dispatcher: replaces one InputChanged connection per slider and per colorpicker
UserInputService.InputChanged:Connect(function(Input)
    local inputType = Input.UserInputType
    if inputType ~= Enum.UserInputType.MouseMovement and inputType ~= Enum.UserInputType.Touch then return end
    pcall(function()
        if not Library then return end
        local as = Library._activeSlider
        if as and as.Sliding then
            local frame = as.SliderFrame
            local SizeX = (Input.Position.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X
            as:Set(((as.Max - as.Min) * SizeX) + as.Min)
        end
        local ac = Library._activeColorpicker
        if ac then
            if ac.SlidingPalette then ac:SlidePalette(Input)
            elseif ac.SlidingHue then ac:SlideHue(Input)
            elseif ac.SlidingAlpha then ac:SlideAlpha(Input)
            end
        end
    end)
end)

Library.Disconnect = function(self, Name)
    for _, Connection in self.Connections do 
        if Connection.Name == Name then
            Connection.Connection:Disconnect()
            break
        end
    end
end

Library.EscapePattern = function(self, String)
    local ShouldEscape = false 

    if string.match(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]") then
        ShouldEscape = true
    end

    if ShouldEscape then
        return StringGSub(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
    end

    return String
end

Library.NextFlag = function(self)
    local FlagNumber = self.UnnamedFlags + 1
    return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
end

Library.AddToTheme = function(self, Item, Properties)
    Item = Item.Instance or Item 

    local ThemeData = {
        Item = Item,
        Properties = Properties,
    }

    for Property, Value in ThemeData.Properties do
        if type(Value) == "string" then
            Item[Property] = self.Theme[Value]
        else
            Item[Property] = Value()
        end
    end

    TableInsert(self.ThemeItems, ThemeData)
    self.ThemeMap[Item] = ThemeData
end

Library.GetConfig = function(self)
    local Config = { } 

    local Success, Result = Library:SafeCall(function()
        for Index, Value in Library.Flags do 
            if type(Value) == "table" and Value.Key then
                Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode, Toggled = Value.Toggled}
            elseif type(Value) == "table" and Value.Color then
                Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
            else
                Config[Index] = Value
            end
        end
    end)

    return HttpService:JSONEncode(Config)
end

Library.LoadConfig = function(self, Config)
    local Decoded = HttpService:JSONDecode(Config)

    local Success, Result = Library:SafeCall(function()
        for Index, Value in Decoded do 
            local SetFunction = Library.SetFlags[Index]

            if not SetFunction then
                continue
            end

            if type(Value) == "table" and Value.Key then 
                SetFunction(Value)
            elseif type(Value) == "table" and Value.Color then
                SetFunction(Value.Color, Value.Alpha)
            else
                SetFunction(Value)
            end
        end
    end)

    return Success, Result
end

Library.DeleteConfig = function(self, Config)
    if isfile(Library.Folders.Configs .. "/" .. Config) then 
        delfile(Library.Folders.Configs .. "/" .. Config)
    end
end

Library.RefreshConfigsList = function(self, Element)
    local List = { }
    local ReturnList = { }

    List = listfiles(Library.Folders.Configs)

    for Index = 1, #List do 
        local File = List[Index]

        if File:sub(-5) == ".json" then
            local Position = File:find(".json", 1, true)
            local StartPosition = Position

            local Character = File:sub(Position, Position)
            while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                Position = Position - 1
                Character = File:sub(Position, Position)
            end

            if Character == "/" or Character == "\\" then
                TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
            end
        end
    end

    Element:Refresh(ReturnList)
end

-- Auto-load config support
Library.AutoLoadConfigFile = Library.Folders.Configs .. "/.autoload.txt"

Library.GetAutoLoadConfig = function(self)
    if isfile(self.AutoLoadConfigFile) then
        local ok, name = pcall(readfile, self.AutoLoadConfigFile)
        if ok and type(name) == "string" then
            name = name:gsub("^%s+", ""):gsub("%s+$", "")
            if name ~= "" and isfile(self.Folders.Configs .. "/" .. name .. ".json") then
                return name
            end
        end
    end
    return nil
end

Library.SetAutoLoadConfig = function(self, Name)
    if type(Name) ~= "string" or Name == "" then return false end
    local path = self.Folders.Configs .. "/" .. Name .. ".json"
    if not isfile(path) then return false end
    writefile(self.AutoLoadConfigFile, Name)
    return true
end

Library.ClearAutoLoadConfig = function(self)
    if isfile(self.AutoLoadConfigFile) then
        delfile(self.AutoLoadConfigFile)
    end
end

Library.ChangeItemTheme = function(self, Item, Properties)
    Item = Item.Instance or Item

    if not self.ThemeMap[Item] then 
        return
    end

    self.ThemeMap[Item].Properties = Properties
    self.ThemeMap[Item] = self.ThemeMap[Item]
end

Library.ChangeTheme = function(self, Theme, Color)
    self.Theme[Theme] = Color

    for _, Item in self.ThemeItems do
        for Property, Value in Item.Properties do
            if type(Value) == "string" and Value == Theme then
                Item.Item[Property] = Color
            elseif type(Value) == "function" then
                Item.Item[Property] = Value()
            end
        end
    end
end

Library.IsPointOverFrame = function(self, Frame, Position)
    Frame = Frame and Frame.Instance or Frame
    if not Frame or not Position then return false end

    local p = Vector2New(Position.X, Position.Y)
    local pos = Frame.AbsolutePosition
    local size = Frame.AbsoluteSize

    return p.X >= pos.X and p.X <= pos.X + size.X
        and p.Y >= pos.Y and p.Y <= pos.Y + size.Y
end

Library.IsMouseOverFrame = function(self, Frame)
    local MousePosition = UserInputService:GetMouseLocation()
    return self:IsPointOverFrame(Frame, MousePosition)
end

Library.GetLighterColor = function(self, Color, Increment)
    local Hue, Saturation, Value = Color:ToHSV()
    return FromHSV(Hue, Saturation, Value * Increment)
end

do 
    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            IsOpen = false,
            IsOpen2 = false,

            Color = FromRGB(0, 0, 0),
            HexValue = "000000",

            Flag = Data.Flag
        }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(0, 15, 0, 15),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(152, 152, 152))}
            })                

            Items["ColorpickerWindow"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                Position = UDim2New(0, 1032, 0, 123),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 232, 0, 250),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(17, 21, 27)
            })

            Items["ColorTitle"] = Instances:Create("TextLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                Text = "COLOR",
                TextColor3 = FromRGB(220, 220, 220),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2New(0, 9, 0, 5),
                Size = UDim2New(1, -18, 0, 16),
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })

            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.699999988079071,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "http://www.roblox.com/asset/?id=18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = -1,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                Color = FromRGB(94, 213, 213),
                LineJoinMode = Enum.LineJoinMode.Miter
            }):AddToTheme({Color = "Accent"})
            
            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Active = true,
                AnchorPoint = Vector2New(0, 1),
                BorderSizePixel = 0,
                Position = UDim2New(0, 8, 1, -35),
                Size = UDim2New(1, -16, 0, 10),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                TileSize = UDim2New(0, 6, 0, 6),
                Image = "http://www.roblox.com/asset/?id=18274452449",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
            })
            
            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                Size = UDim2New(0, 2, 1, 0),
                Position = UDim2New(0, 8, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Hue"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Active = true,
                AnchorPoint = Vector2New(1, 0),
                BorderSizePixel = 0,
                Position = UDim2New(1, -7, 0, 28),
                Size = UDim2New(0, 10, 1, -79),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["HueInline"] = Instances:Create("TextButton", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Active = true,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["HueInline"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = -0.009999999776482582,
                Position = UDim2New(0, 0, 0, 8),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Active = true,
                BorderSizePixel = 0,
                Position = UDim2New(0, 8, 0, 28),
                Size = UDim2New(1, -31, 1, -79),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Saturation"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Items["Value"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(0, 0, 0)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(0, 2, 0, 2),
                Position = UDim2New(0, 8, 0, 8),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["HexInput"] = Instances:Create("TextBox", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                ClearTextOnFocus = false,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AnchorPoint = Vector2New(0, 1),
                Size = UDim2New(1, -16, 0, 20),
                PlaceholderColor3 = FromRGB(255, 255, 255),
                Position = UDim2New(0, 8, 1, -7),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["HexInput"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["HexInput"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})            
            
            Items["ColorpickerWindow2"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 50, 0, 20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(32, 38, 48),
                AutomaticSize = Enum.AutomaticSize.Y
            })  Items["ColorpickerWindow2"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIListLayout", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        local AddButton = function(Name, Callback)
            local NewButton = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  NewButton:AddToTheme({TextColor3 = "Text"})

            NewButton:Connect("MouseButton1Down", function()
                Callback()
                Colorpicker:SetOpen2(false)
            end)

            return NewButton
        end

        AddButton("Copy", function()
            local Red = MathFloor(Colorpicker.Color.R * 255)
            local Green = MathFloor(Colorpicker.Color.G * 255)
            local Blue = MathFloor(Colorpicker.Color.B * 255)

            setclipboard(Red .. ", " .. Green .. ", " .. Blue)
            Library.CopiedColor = Red .. ", " .. Green .. ", " .. Blue
        end)
        AddButton("Paste", function()
            if Library.CopiedColor then 
                local Red, Green, Blue = Library.CopiedColor:match("(%d+),%s*(%d+),%s*(%d+)")
                Red, Green, Blue = tonumber(Red), tonumber(Green), tonumber(Blue)

                Colorpicker:Set({Red, Green, Blue}, Colorpicker.Alpha)
            end
        end)

        Colorpicker.SlidingPalette = false
        Colorpicker.SlidingHue = false
        Colorpicker.SlidingAlpha = false

        local Debounce = false
        local RenderStepped  

        local RenderStepped2

        function Colorpicker:Get()
            return Colorpicker.Color, Colorpicker.Alpha
        end

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Colorpicker.IsOpen then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 6)
                end)

                for Index, Value in Library.OpenFrames do 
                    if Value ~= Colorpicker then 
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Colorpicker] = Colorpicker 
            else
                if Library.OpenFrames[Colorpicker] then 
                    Library.OpenFrames[Colorpicker] = nil
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if not Value.ClassName:find("UI") then
                    Value.ZIndex = Colorpicker.IsOpen and 104 or 1
                    Items["Glow"].Instance.ZIndex = Colorpicker.IsOpen and 103 or 1
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                task.wait(0.2)
                Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Colorpicker:SetOpen2(Bool)
            Colorpicker.IsOpen2 = Bool
            if Bool then
                Items["ColorpickerWindow2"].Instance.Visible = true 
                Items["ColorpickerWindow2"].Instance.Parent = Library.Holder.Instance

                RenderStepped2 = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow2"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X + Items["ColorpickerButton"].Instance.AbsoluteSize.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 6)
                end)
            else
                if RenderStepped2 then 
                    RenderStepped2:Disconnect()
                    RenderStepped2 = nil
                end

                Items["ColorpickerWindow2"].Instance.Visible = false
                Items["ColorpickerWindow2"].Instance.Parent = Library.UnusedHolder.Instance
            end
        end

        function Colorpicker:SlidePalette(Input)
            if not Input or not Colorpicker.SlidingPalette then
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Saturation = ValueX
            Colorpicker.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.99)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.99)

            Items["PaletteDragger"].Instance.Position = UDim2New(SlideX, 0, SlideY, 0)
            Colorpicker:Update()
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not Colorpicker.SlidingHue then
                return
            end

            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Hue = ValueY

            local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.99)

            Items["HueDragger"].Instance.Position = UDim2New(0, 0, SlideY, 0)
            Colorpicker:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not Colorpicker.SlidingAlpha then
                return
            end

            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

            Colorpicker.Alpha = ValueX

            local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.99)

            Items["AlphaDragger"].Instance.Position = UDim2New(SlideX, 0, 0, 0)
            Colorpicker:Update(true)
        end

        function Colorpicker:Update(IsFromAlpha)
            local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
            Colorpicker.Color = FromHSV(Hue, Saturation, Value)
            Colorpicker.HexValue = Colorpicker.Color:ToHex()

            Library.Flags[Colorpicker.Flag] = {
                Alpha = Colorpicker.Alpha,
                Color = Colorpicker.Color,
                HexValue = Colorpicker.HexValue,
                Transparency = 1 - Colorpicker.Alpha
            }

            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})
            Items["HexInput"].Instance.Text = "#"..Colorpicker.HexValue

            if not IsFromAlpha then 
                Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
            end
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then
                Color = FromRGB(Color[1], Color[2], Color[3])
            elseif type(Color) == "string" then
                Color = FromHex(Color)
            end 

            Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
            Colorpicker.Alpha = Alpha or 0  

            local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.99)
            local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.99)

            local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.99)
                
            local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.99)

            Items["PaletteDragger"].Instance.Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)
            Items["HueDragger"].Instance.Position = UDim2New(0, 0, HuePositionY, 0)
            Items["AlphaDragger"].Instance.Position = UDim2New(AlphaPositionX, 0, 0, 0)
            Colorpicker:Update(false)
        end

        -- Color areas must be explicitly active; this avoids child UI objects
        -- consuming the first touch/click before the picker sees it.
        Items["Palette"].Instance.Active = true
        Items["Saturation"].Instance.Active = false
        Items["Value"].Instance.Active = false
        Items["PaletteDragger"].Instance.Active = false
        Items["Hue"].Instance.Active = true
        Items["HueInline"].Instance.Active = true
        Items["HueDragger"].Instance.Active = false
        Items["Alpha"].Instance.Active = true
        Items["AlphaDragger"].Instance.Active = false

        Items["Palette"]:Connect("InputBegan", function(Input)
            local kind = Input.UserInputType
            if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
                Colorpicker.SlidingPalette = true
                Colorpicker.SlidingHue = false
                Colorpicker.SlidingAlpha = false
                Library._activeColorpicker = Colorpicker
                Colorpicker:SlidePalette(Input)
            end
        end)

        Items["HueInline"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Colorpicker.SlidingPalette = false
                Colorpicker.SlidingHue = true
                Colorpicker.SlidingAlpha = false
                Library._activeColorpicker = Colorpicker
                Colorpicker:SlideHue(Input)
            end
        end)

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Colorpicker.SlidingPalette = false
                Colorpicker.SlidingHue = false
                Colorpicker.SlidingAlpha = true
                Library._activeColorpicker = Colorpicker
                Colorpicker:SlideAlpha(Input)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Colorpicker.SlidingPalette or Colorpicker.SlidingHue or Colorpicker.SlidingAlpha then
                    Colorpicker.SlidingPalette = false
                    Colorpicker.SlidingHue = false
                    Colorpicker.SlidingAlpha = false
                    if Library._activeColorpicker == Colorpicker then Library._activeColorpicker = nil end
                end
            end
        end)
        
        Items["HexInput"]:Connect("FocusLost", function()
            Colorpicker:Set(tostring(Items["HexInput"].Instance.Text), Colorpicker.Alpha)
        end)

        local CompareVectors = function(PointA, PointB)
            return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
        end

        local IsClipped = function(Object, Column)
            local Parent = Column
            
            local BoundryTop = Parent.AbsolutePosition
            local BoundryBottom = BoundryTop + Parent.AbsoluteSize

            local Top = Object.AbsolutePosition
            local Bottom = Top + Object.AbsoluteSize 

            return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
        end

        Items["ColorpickerButton"]:Connect("Changed", function(Property)
            if Property == "AbsolutePosition" and Colorpicker.IsOpen then
                Colorpicker.IsOpen = not IsClipped(Items["ColorpickerWindow"].Instance, Data.Section.Items["Section"].Instance.Parent)
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if not Colorpicker.IsOpen then
                    return
                end

                local inputPosition = Input.Position
                if Library:IsPointOverFrame(Items["ColorpickerWindow"], inputPosition)
                    or Library:IsPointOverFrame(Items["ColorpickerWindow2"], inputPosition)
                    or Library:IsPointOverFrame(Items["ColorpickerButton"], inputPosition) then
                    return
                end

                Colorpicker:SetOpen(false)
                Colorpicker:SetOpen2(false)
            end
        end)

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)
        Items["ColorpickerButton"]:Connect("Activated", function()
            -- Activated covers touchscreen taps and also works with mouse.
            if not Colorpicker.IsOpen then
                Colorpicker:SetOpen(true)
            end
        end)

        Items["ColorpickerButton"]:Connect("MouseButton2Down", function()
            Colorpicker:SetOpen2(not Colorpicker.IsOpen2)
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
            Colorpicker:Set(Color, Alpha)
        end

        return Colorpicker, Items 
    end
    
    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            IsOpen = false,

            Key = "",
            Toggled = false,
            Mode = Data.Mode or "Toggle",

            Flag = Data.Flag,

            Picking = false,
            Value = ""
        }

        local KeyListItem 
        if Library.KeyList then 
            KeyListItem = Library.KeyList:Add("", "")
        end

        local Items = { } do 
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = "Unbound",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["KeyButton"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element"})
            
            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["KeybindWindow"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                Position = UDim2New(0, 114, 0, 35),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                Size = UDim2New(0, 78, 0, 66),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["KeybindWindow"]:AddToTheme({BackgroundColor3 = "Element"})

            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Position = UDim2New(0, 2, 0, 2),
                Size = UDim2New(1, -4, 0, 20),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Toggle"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIGradient", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })

            Items["ToggleStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["ToggleStroke"]:AddToTheme({Color = "Border"})

            Items["ToggleLiner"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Size = UDim2New(0, 1, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["ToggleLiner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["ToggleText"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutomaticSize = Enum.AutomaticSize.X,
                AnchorPoint = Vector2New(0, 0.5),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["ToggleText"]:AddToTheme({TextColor3 = "Text"})

            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 2, 0, 22),
                Size = UDim2New(1, -4, 0, 20),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Hold"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIGradient", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })

            Items["HoldStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Transparency = 1,
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter
            })  Items["HoldStroke"]:AddToTheme({Color = "Border"})

            Items["HoldLiner"] = Instances:Create("Frame", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 1, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["HoldLiner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["HoldText"] = Instances:Create("TextLabel", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = "Hold",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["HoldText"]:AddToTheme({TextColor3 = "Text"})

            Items["AlwaysOn"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 2, 0, 44),
                Size = UDim2New(1, -4, 0, 20),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })

            Instances:Create("UIGradient", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })

            Items["AlwaysOnStroke"] = Instances:Create("UIStroke", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Transparency = 1,
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter
            })  Items["AlwaysOnStroke"]:AddToTheme({Color = "Border"})

            Items["AlwaysOnLiner"] = Instances:Create("Frame", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 1, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["AlwaysOnLiner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["AlwaysOnText"] = Instances:Create("TextLabel", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = "Always On",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["AlwaysOnText"]:AddToTheme({TextColor3 = "Text"})

            Items["KeyButton"]:OnHover(function()
                Items["KeyButton"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)

            Items["KeyButton"]:OnHoverLeave(function()
                Items["KeyButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        local Update = function()
            if KeyListItem then
                KeyListItem:SetText(Data.Name, Keybind.Value)
                KeyListItem:SetStatus(Keybind.Toggled)
            end
        end

        local Modes = {
            ["Toggle"] = {Items["Toggle"], Items["ToggleText"], Items["ToggleStroke"], Items["ToggleLiner"]},
            ["Hold"] = {Items["Hold"], Items["HoldText"], Items["HoldStroke"], Items["HoldLiner"]},
            ["Always On"] = {Items["AlwaysOn"], Items["AlwaysOnText"], Items["AlwaysOnStroke"], Items["AlwaysOnLiner"]}
        }

        function Keybind:Get()
            return Keybind.Mode, Keybind.Key, Keybind.Toggled
        end

        local Debounce = false
        local RenderStepped  

        function Keybind:SetOpen(Bool)
            if Debounce then 
                return
            end

            Keybind.IsOpen = Bool

            Debounce = true 

            if Keybind.IsOpen then 
                Items["KeybindWindow"].Instance.Visible = true
                Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["KeybindWindow"].Instance.Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 65)
                end)

                if not Debounce then 
                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Keybind then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                end
            else
                if not Debounce then 
                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["KeybindWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                task.wait(0.2)
                Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = TextToDisplay

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled,
                    active = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            elseif type(Key) == "table" then
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = TextToDisplay

                if Key.Toggled then 
                    Keybind:Press(Key.Toggled, true)
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                Keybind.Mode = Key
                Keybind:SetMode(Keybind.Mode)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            elseif type(Key) == "boolean" then  
                Keybind:Press(Key)
            end

            Keybind.Picking = false
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then
                Keybind.Toggled = true
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled,
                active = Keybind.Toggled
            }

            if Data.Callback then
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do 
                if Index == Mode then
                    Value[1]:Tween(nil, {BackgroundTransparency = 0})
                    Value[4]:Tween(nil, {BackgroundTransparency = 0})
                    Value[2]:Tween(nil, {TextTransparency = 0})
                    Value[3]:Tween(nil, {Transparency = 0})
                else
                    Value[1]:Tween(nil, {BackgroundTransparency = 1})
                    Value[4]:Tween(nil, {BackgroundTransparency = 1})
                    Value[2]:Tween(nil, {TextTransparency = 0.4})
                    Value[3]:Tween(nil, {Transparency = 1})
                end
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled,
                active = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        local CompareVectors = function(PointA, PointB)
            return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
        end

        local IsClipped = function(Object, Column)
            local Parent = Column
            
            local BoundryTop = Parent.AbsolutePosition
            local BoundryBottom = BoundryTop + Parent.AbsoluteSize

            local Top = Object.AbsolutePosition
            local Bottom = Top + Object.AbsoluteSize 

            return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
        end

        Items["KeyButton"]:Connect("Changed", function(Property)
            if Property == "AbsolutePosition" and Keybind.IsOpen then
                Keybind.IsOpen = not IsClipped(Items["KeybindWindow"].Instance, Data.Section.Items["Section"].Instance.Parent)
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
            end
        end)

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            Keybind.Picking = true 

            Items["KeyButton"].Instance.Text = "."
            Library:Thread(function()
                local Count = 1

                while true do 
                    if not Keybind.Picking then 
                        break
                    end

                    if Count == 4 then
                        Count = 1
                    end

                    Items["KeyButton"].Instance.Text = Count == 1 and "." or Count == 2 and ".." or Count == 3 and "..."
                    Count += 1
                    task.wait(0.4)
                end
            end)

            local InputBegan
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then 
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Keybind.Value == "None" then return end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Toggle" then
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Keybind.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Keybind.Value == "None" then return end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        Items["AlwaysOn"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always On")
        end)

        if Data.Default then
            Keybind:Set({Key = Data.Default, Mode = Data.Mode or "Toggle", Toggled = Data.Toggled})
        end

        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind, Items 
    end

    Library.Watermark = function(self, Name)
        local Watermark = { }
        
        local Items = { } do 
            Items["Watermark"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0),
                Position = UDim2New(0.5, 0, 0, 25),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 180, 0, 30),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(17, 21, 27),
                ZIndex = 5,
            })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background 1"})
            
            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                Color = FromRGB(94, 213, 213),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["UIStroke"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.696, 0.2749999761581421), NumSequenceKeypoint(0.84, 0.574999988079071), NumSequenceKeypoint(1, 1)}
            })
            
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.5,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = 4,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                AnchorPoint = Vector2New(0.5, 0.5),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 5,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
        end

        function Watermark:SetText(Text)
            Text = tostring(Text)
            Items["Text"].Instance.Text = Text
            Items["Watermark"]:Tween(nil, {Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 20, 0, 30)})
        end

        function Watermark:SetVisibility(Bool)
            Items["Watermark"].Instance.Visible = Bool
        end

        Watermark:SetText(Name)
        Watermark.Frame = Items["Watermark"].Instance
        Items["Watermark"]:MakeDraggable()

        return Watermark
    end

    Library.KeybindList = function(self)
        local KeybindList = { }
        self.KeyList = KeybindList
        Library.KeyList = KeybindList

        local Items = { } do
            Items["KeybindList"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 20, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(24, 28, 36)
            })  Items["KeybindList"]:AddToTheme({BackgroundColor3 = "Background 2"})

            Instances:Create("UICorner", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 4)
            })

            Instances:Create("UIPadding", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 9),
                PaddingBottom = UDimNew(0, 9),
                PaddingRight = UDimNew(0, 9),
                PaddingLeft = UDimNew(0, 9)
            })
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Keybinds",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(0, 75, 0, 15),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Liner2"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 21),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(46, 52, 61)  
            })  Items["Liner2"]:AddToTheme({BackgroundColor3 = "Border"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 28),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
    
            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Position = UDim2New(0, -9, 0, -9),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 18, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["Liner"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.5,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(94, 213, 213),
                Size = UDim2New(0, 100, 1, 8),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})

            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })

            Instances:Create("UIStroke", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
        end

        function KeybindList:SetVisibility(Bool)
            Items["KeybindList"].Instance.Visible = Bool
        end

        function KeybindList:Add(Name, Key)
            local NewKey = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = Name .. " [".. Key .."]",
                Visible = (Key ~= "" and Key ~= "None" and Key ~= "Unbound"),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  NewKey:AddToTheme({TextColor3 = "Text"})

            function NewKey:SetText(Name, Key)
                NewKey.Instance.Text = Name .. " [".. Key .."]"
                NewKey.Instance.Visible = (Key ~= "" and Key ~= "None" and Key ~= "Unbound")
            end

            function NewKey:SetStatus(Bool)
                if NewKey.Instance.Text:find("Menu Keybind") then NewKey.Instance.Visible = false return end
                NewKey.Instance.TextTransparency = Bool and 0.1 or 0.4
            end

            return NewKey
        end

        KeybindList.Frame = Items["KeybindList"].Instance
        Items["KeybindList"]:MakeDraggable()

        return KeybindList
    end

    Library.ModeratorList = function(self)
        local ModList = { }
        local Moderators = { }

        local Items = { } do
            Items["ModList"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(1, -220, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2New(0, 200, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(24, 28, 36)
            })  Items["ModList"]:AddToTheme({BackgroundColor3 = "Background 2"})

            Items["ModList"]:MakeDraggable()

            Instances:Create("UIPadding", {
                Parent = Items["ModList"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 9),
                PaddingBottom = UDimNew(0, 9),
                PaddingRight = UDimNew(0, 9),
                PaddingLeft = UDimNew(0, 9)
            })

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["ModList"].Instance,
                Name = "\0",
                Position = UDim2New(0, -9, 0, -9),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 18, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["Liner"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.5,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(94, 213, 213),
                Size = UDim2New(0, 113, 1, 8),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})

            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["ModList"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Moderators",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(0, 150, 0, 15),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Items["Liner2"] = Instances:Create("Frame", {
                Parent = Items["ModList"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 21),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(46, 52, 61)
            })  Items["Liner2"]:AddToTheme({BackgroundColor3 = "Border"})

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["ModList"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 28),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Instances:Create("UIStroke", {
                Parent = Items["ModList"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
        end

        function ModList:SetVisibility(Bool)
            Items["ModList"].Instance.Visible = Bool
        end

        function ModList:add_mod(Username, Role)
            if Moderators[Username] then
                ModList:remove_mod(Username)
            end

            Role = Role or 'Moderator'

            local ModFrame = Instances:Create('Frame', {
                Parent = Items['Content'].Instance,
                Name = '\0',
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            local Line = Instances:Create('TextLabel', {
                Parent = ModFrame.Instance,
                Name = '\0',
                FontFace = Library.Font,
                RichText = true,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                TextSize = 14,
                Size = UDim2New(1, 0, 0, 15),
                Text = ''
            })  Line:AddToTheme({TextColor3 = 'Text'})

            local function esc(s)
                s = tostring(s or '')
                s = s:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;'):gsub('"', '&quot;'):gsub("'", '&#39;')
                return s
            end

            local function rebuild()
                local u = esc(Username)
                local r = esc(Role)
                Line.Text = string.format('%s  <font color="#B9B9B9">%s</font>', u, r)
            end

            rebuild()

            local ModData = {
                Frame = ModFrame,
                Username = Username,
                Role = Role,
                Label = Line,
                SetRole = function(self, NewRole)
                    self.Role = NewRole or self.Role
                    Role = self.Role
                    rebuild()
                end
            }

            Moderators[Username] = ModData
            return ModData
        end

        function ModList:remove_mod(Username)
            local ModData = Moderators[Username]
            if ModData then
                ModData.Frame:Clean()
                Moderators[Username] = nil
            end
        end

        function ModList:Get()
            local ModTable = { }
            for Username, Data in Moderators do
                TableInsert(ModTable, {username = Username, role = Data.Role})
            end
            return ModTable
        end

        return ModList
    end

    Library.ArmorViewer = function(self)
        local Viewer = {
            Items = { }
        }

        local Items = { }
        local Layout

        local MinWidth = 180
        local MaxWidth = 9999
        local BarHeight = 120
        local ItemSize = 82
        local Gap = 8
        local PadL, PadR = 8, 8
        local PadT, PadB = 6, 10
        local HeaderH = 32

        local function Clamp(x, a, b)
            if (x < a) then return a end
            if (x > b) then return b end
            return x
        end

        local function CountItems()
            local n = 0
            for _, c in ipairs(Items["RealHolder"].Instance:GetChildren()) do
                if (c:IsA("Frame")) then
                    n += 1
                end
            end
            return n
        end

        local function UpdateBarSize()
            if (not Items["ArmorViewer"]) then
                return
            end

            local n = CountItems()
            local contentW

            if (n <= 0) then
                contentW = PadL + PadR
            else
                contentW = PadL + PadR + (n * ItemSize) + ((n - 1) * Gap)
            end

            local outerW = contentW + 16
            local w = Clamp(outerW, MinWidth, MaxWidth)

            Items["ArmorViewer"].Instance.Size = UDim2New(0, w, 0, BarHeight)
            Items["Holder"].Instance.Size = UDim2New(1, -16, 1, -(HeaderH + 8))
            Items["RealHolder"].Instance.Size = UDim2New(1, 0, 1, 0)
            Items["RealHolder"].Instance.CanvasSize = UDim2New(0, math.max(0, contentW), 0, 0)
        end

        do
            Items["ArmorViewer"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, MinWidth, 0, BarHeight),
                BorderSizePixel = 0,
                ZIndex = 8,
                BackgroundColor3 = FromRGB(24, 28, 36),
                AnchorPoint = Vector2New(0, 0.5)
            })  Items["ArmorViewer"]:AddToTheme({BackgroundColor3 = "Background 2"})

            Items["ArmorViewer"]:MakeDraggable()

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["ArmorViewer"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                ZIndex = 8,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["Liner"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.5,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(94, 213, 213),
                Size = UDim2New(1, 8, 1, 8),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = 8,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})

            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["ArmorViewer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "sametexe009's inventory",
                Size = UDim2New(1, -16, 0, 15),
                Position = UDim2New(0, 8, 0, 8),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 8,
                AutomaticSize = Enum.AutomaticSize.None,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Items["Holder"] = Instances:Create("Frame", {
                Parent = Items["ArmorViewer"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 8, 0, HeaderH),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -16, 1, -(HeaderH + 8)),
                BorderSizePixel = 0,
                ZIndex = 8,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["RealHolder"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.None,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(46, 52, 61),
                MidImage = "rbxassetid://93024691806056",
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 3,
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                ZIndex = 8,
                BottomImage = "rbxassetid://93024691806056",
                TopImage = "rbxassetid://93024691806056",
                BackgroundColor3 = FromRGB(255, 255, 255),
                ScrollingDirection = Enum.ScrollingDirection.X
            })  Items["RealHolder"]:AddToTheme({ScrollBarImageColor3 = "Border"})

            Layout = Instances:Create("UIListLayout", {
                Parent = Items["RealHolder"].Instance,
                Name = "\0",
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDimNew(0, Gap)
            })

            Instances:Create("UIPadding", {
                Parent = Items["RealHolder"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, PadT),
                PaddingBottom = UDimNew(0, PadB),
                PaddingRight = UDimNew(0, PadR),
                PaddingLeft = UDimNew(0, PadL)
            })

            Items["RealHolder"].Instance.ChildAdded:Connect(function()
                UpdateBarSize()
            end)

            Items["RealHolder"].Instance.ChildRemoved:Connect(function()
                UpdateBarSize()
            end)

            UpdateBarSize()
        end

        function Viewer:Add(Name, Icon)
            local NewItemTable = { }

            local NewItem = Instances:Create("Frame", {
                Parent = Items["RealHolder"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 8,
                Size = UDim2New(0, ItemSize, 0, ItemSize),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = NewItem.Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("ImageLabel", {
                Parent = NewItem.Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0.5, 0.5),
                ZIndex = 8,
                Image = Icon,
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                Size = UDim2New(0, 50, 0, 50),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            function NewItemTable:Remove()
                NewItem:Clean()
                Viewer.Items[Name] = nil
                UpdateBarSize()
            end

            Viewer.Items[Name] = NewItemTable
            UpdateBarSize()
            return NewItemTable
        end

        function Viewer:ClearAllItems()
            for _, Value in Viewer.Items do
                if (not Value or not Value.Remove) then
                    continue
                end
                Value:Remove()
            end
            UpdateBarSize()
        end

        function Viewer:SetVisibility(Bool)
            Items["ArmorViewer"].Instance.Visible = Bool
        end

        function Viewer:SetTitle(Name)
            Items["Title"].Instance.Text = Name
        end

        function Viewer:SetPosition(Position)
            Items["ArmorViewer"].Instance.Position = Position
        end

        function Viewer:SetSizeLimits(Min, Max)
            MinWidth = Min or MinWidth
            MaxWidth = Max or MaxWidth
            UpdateBarSize()
        end

        function Viewer:SetBarHeight(H)
            BarHeight = H or BarHeight
            Items["ArmorViewer"].Instance.Size = UDim2New(0, Items["ArmorViewer"].Instance.Size.X.Offset, 0, BarHeight)
            UpdateBarSize()
        end

        return Viewer
    end

    Library.Notification = function(self, Name, Duration)
        local Items = { } do
            Items["Notification"] = Instances:Create("Frame", {
                Parent = self.NotifHolder.Instance,
                Name = "\0",
                Size = UDim2New(0, 20, 0, 20),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(24, 28, 36)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Inline"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 7),
                PaddingBottom = UDimNew(0, 7),
                PaddingRight = UDimNew(0, 7),
                PaddingLeft = UDimNew(0, 7)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
        end

        local Size = Items["Notification"].Instance.AbsoluteSize

        for Index, Value in Items do 
            if Value.Instance:IsA("Frame") then
                Value.Instance.BackgroundTransparency = 1
            elseif Value.Instance:IsA("TextLabel") then 
                Value.Instance.TextTransparency = 1
            end
        end 

        Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None

        Library:Thread(function()
            for Index, Value in Items do 
                if Value.Instance:IsA("Frame") then
                    Value:Tween(nil, {BackgroundTransparency = 0})
                elseif Value.Instance:IsA("TextLabel") then 
                    Value:Tween(nil, {TextTransparency = 0})
                end
            end

            Items["Notification"]:Tween(nil, {Size = UDim2New(0, Size.X, 0, Size.Y)})

            task.delay(Duration + 0.1, function()
                for Index, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value:Tween(nil, {BackgroundTransparency = 1})
                    elseif Value.Instance:IsA("TextLabel") then 
                        Value:Tween(nil, {TextTransparency = 1})
                    end
                end

                Items["Notification"]:Tween(nil, {Size = UDim2New(0, 0, 0, 0)})
                
                task.wait(0.5)
                Items["Notification"]:Clean()
            end)
        end)
    end

    Library.TargetHud = function(self)
        local TargetHud = { }

        local Items = { } do 
            Items["TargetHud"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Size = UDim2New(0, 295, 0, 21),
                Position = UDim2New(0, 0, 0.8, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 6,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(17, 21, 27)
            })  Items["TargetHud"]:AddToTheme({BackgroundColor3 = "Background 1"})

            Items["TargetHud"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Target Hud",
                Size = UDim2New(0, 0, 0, 15),
                Position = UDim2New(0, 8, 0, 8),
                BackgroundTransparency = 1,
                ZIndex = 6,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 6,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["Liner"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.5,
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 6,
                BackgroundColor3 = FromRGB(94, 213, 213),
                Size = UDim2New(1, 8, 1, 8),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = 6,
                Position = UDim2New(0, 8, 0, 32),
                Size = UDim2New(1, -16, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Avatar"] = Instances:Create("ImageLabel", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                BackgroundTransparency = 1,
                ZIndex = 6,
                Size = UDim2New(0, 70, 0, 70),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })           
            
            Items["Username"] = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "-- (@--)",
                Size = UDim2New(1, -77, 0, 15),
                ZIndex = 6,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 77, 0, 0),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Username"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIPadding", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                PaddingBottom = UDimNew(0, 8)
            })
            
            Instances:Create("UIPadding", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 9),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 9),
                PaddingLeft = UDimNew(0, 9)
            })

            Items["Bars"] = Instances:Create("Frame", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 77, 1, 0),
                Size = UDim2New(1, -77, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 6,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Bars"].Instance,
                Name = "\0",
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        function TargetHud:AddBar(Color)
            local NewBar = { }

            local NewBarBackground = Instances:Create("Frame", {
                Parent = Items["Bars"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                ZIndex = 6,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 77, 1, 0),
                Size = UDim2New(1, 0, 0, 12),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = NewBarBackground.Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            local BarAccent = Instances:Create("Frame", {
                Parent = NewBarBackground.Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0.8999999761581421, 0, 1, 0),
                ZIndex = 6,
                BorderSizePixel = 0,
                BackgroundColor3 = Color
            })
            
            Instances:Create("UIGradient", {
                Parent = BarAccent.Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(153, 153, 153))}
            })
            
            local BarValue = Instances:Create("TextLabel", {
                Parent = NewBarBackground.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                ZIndex = 6,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "90",
                Size = UDim2New(0, 0, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, -1),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  BarValue:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = BarValue.Instance,
                Name = "\0"
            })

            function NewBar:SetPercentage(Percentage)
                local RealPercentage = 1 / 100 * Percentage
    
                if BarAccent and NewBarBackground then 
                    BarAccent:Tween(TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2New(RealPercentage, 0, 1, 0)})
                    BarValue.Instance.Text = math.floor(Percentage)
                end
            end

            function NewBar:Remove()
                NewBarBackground:Clean()
                NewBar = nil
            end

            return NewBar
        end
        
        function TargetHud:SetPlayer(Player)
            local AvatarContent = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            Items["Avatar"].Instance.Image = AvatarContent
            Items["Username"].Instance.Text = Player.DisplayName .. " (@"..Player.Name..")"
        end

        function TargetHud:SetVisibility(Bool)
            Items["TargetHud"].Instance.Visible = Bool
        end

        function TargetHud:SetPosition(Position)
            Items["TargetHud"].Instance.Position = Position
        end

        return TargetHud 
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = {
            Name = Data.Name or Data.name or "Window",
            Logo = Data.Logo or Data.logo or "rbxassetid://90363697817722",
            
            Pages = { },
            Items = { },
            IsOpen = false
        }

        local Items = { } do
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                Position = UDim2New(0.5, 0, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 621, 0, 542),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(17, 21, 27)
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background 1"})

            -- Mobile-friendly scaling: keeps the full window usable on small screens.
            Items["MainScale"] = Instances:Create("UIScale", {
                Parent = Items["MainFrame"].Instance,
                Name = "MobileScale",
                Scale = 1
            })

            -- Independent animation scale so mobile scaling remains intact.
            Items["OpenScale"] = Instances:Create("UIScale", {
                Parent = Items["MainFrame"].Instance,
                Name = "OpenAnimationScale",
                Scale = 0.94
            })

            local function UpdateMobileScale()
                local viewport = Camera and Camera.ViewportSize or Vector2New(720, 1600)
                local shortest = math.min(viewport.X, viewport.Y)
                local scale = MathClamp(shortest / 720, 0.62, 1)
                Items["MainScale"].Instance.Scale = scale
            end

            UpdateMobileScale()
            Library:Connect(RunService.RenderStepped, function()
                if Camera then
                    local viewport = Camera.ViewportSize
                    local shortest = math.min(viewport.X, viewport.Y)
                    local scale = MathClamp(shortest / 720, 0.62, 1)
                    if math.abs(Items["MainScale"].Instance.Scale - scale) > 0.01 then
                        Items["MainScale"].Instance.Scale = scale
                    end
                end
            end)

            -- Transparent title-bar handle: avoids stealing input from the controls below.
            Items["DragHandle"] = Instances:Create("TextButton", {
                Parent = Items["MainFrame"].Instance,
                Name = "MobileDragHandle",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 0, 0, 0),
                Size = UDim2New(1, 0, 0, 38),
                ZIndex = 20
            })

            Items["MainFrame"]:MakeDraggable(Items["DragHandle"])
            Items["MainFrame"]:MakeResizeable(Vector2New(621, 542), Vector2New(9999, 9999))
            
            Items["UIStroke"] = Instances:Create("UIStroke", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Color = FromRGB(94, 213, 213),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke"]:AddToTheme({Color = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["UIStroke"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.696, 0.2749999761581421), NumSequenceKeypoint(0.84, 0.574999988079071), NumSequenceKeypoint(1, 1)}
            })
            
            Items["Inline"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -2, 1, -2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                Color = FromRGB(0, 0, 0),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Window Outline"})
            
            local _hasLogo = Window.Logo and Window.Logo ~= ""
            if _hasLogo then
                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 6, 0, 8),
                    Size = UDim2New(0, 22, 0, 22),
                    BorderSizePixel = 0,
                    ScaleType = Enum.ScaleType.Fit,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
            end

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Window.Name,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, _hasLogo and 32 or 8, 0, 10),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 39),
                ClipsDescendants = true,
                Size = UDim2New(1, -14, 1, -46),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Pages"] = Instances:Create("Frame", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 30),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                Name = "\0",
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDimNew(0, 1),
                SortOrder = Enum.SortOrder.LayoutOrder
            })                

            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.5,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = -1,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })                
            
            Window.Items = Items
        end

        local Debounce = false

        function Window:SetCenter()
            local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
            task.wait()
            Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)

            Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
        end

        function Window:SetOpen(Bool)
            for Index, Value in Library.OpenFrames do
                Value:SetOpen(false)
            end

            if Debounce then 
                return
            end

            Window.IsOpen = Bool

            if Items["ExternalToggleIcon"] and Items["ExternalToggleIcon"].Instance then
                local icon = Items["ExternalToggleIcon"].Instance
                icon.Text = Window.IsOpen and "×" or "≡"
                TweenService:Create(icon, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Rotation = Window.IsOpen and 90 or 0}):Play()
            end

            Debounce = true 

            if Window.IsOpen then 
                Items["MainFrame"].Instance.Visible = true 
                Items["OpenScale"].Instance.Scale = 0.94
                TweenService:Create(Items["OpenScale"].Instance, TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = 1}):Play()
            else
                TweenService:Create(Items["OpenScale"].Instance, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = 0.94}):Play()
            end

            local Descendants = Items["MainFrame"].Instance:GetDescendants()
            TableInsert(Descendants, Items["MainFrame"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["MainFrame"].Instance.Visible = Window.IsOpen
            end)
        end

        -- External mobile button: remains visible while the main menu is closed.
        Items["ExternalToggle"] = Instances:Create("TextButton", {
            Parent = Library.Holder.Instance,
            Name = "MobileMenuToggle",
            AnchorPoint = Vector2New(1, 1),
            Position = UDim2New(1, -18, 1, -72),
            Size = UDim2New(0, 56, 0, 56),
            BackgroundColor3 = FromRGB(20, 20, 20),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 10000
        })
        Items["ExternalToggle"]:AddToTheme({
            BackgroundColor3 = "Element",
            TextColor3 = "Text"
        })

        Items["ExternalToggleScale"] = Instances:Create("UIScale", {
            Parent = Items["ExternalToggle"].Instance,
            Name = "PressScale",
            Scale = 1
        })

        Items["ExternalToggleGlow"] = Instances:Create("ImageLabel", {
            Parent = Items["ExternalToggle"].Instance,
            Name = "Glow",
            AnchorPoint = Vector2New(0.5, 0.5),
            Position = UDim2New(0.5, 0, 0.5, 0),
            Size = UDim2New(1, 18, 1, 18),
            BackgroundTransparency = 1,
            Image = "rbxassetid://18245826428",
            ImageTransparency = 0.65,
            ZIndex = 9999,
            SliceCenter = RectNew(Vector2New(21,21), Vector2New(79,79))
        })
        Items["ExternalToggleGlow"]:AddToTheme({ImageColor3 = "Accent"})

        Items["ExternalToggleIcon"] = Instances:Create("TextLabel", {
            Parent = Items["ExternalToggle"].Instance,
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2New(1, 0, 1, 0),
            Position = UDim2New(0, 0, 0, 0),
            Text = "≡",
            TextSize = 27,
            FontFace = Library.Font,
            TextColor3 = FromRGB(255,255,255),
            ZIndex = 10001
        })
        Items["ExternalToggleIcon"]:AddToTheme({TextColor3 = "Text"})

        Instances:Create("UICorner", {
            Parent = Items["ExternalToggle"].Instance,
            CornerRadius = UDimNew(1, 0)
        })

        Items["ExternalToggleStroke"] = Instances:Create("UIStroke", {
            Parent = Items["ExternalToggle"].Instance,
            Thickness = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
        Items["ExternalToggleStroke"]:AddToTheme({Color = "Accent"})

        -- External button: draggable on mouse/touch, while a short click still toggles the menu.
        do
            local DraggingExternal = false
            local ExternalInput = nil
            local ExternalStart = nil
            local ExternalStartInput = nil
            local ExternalMoved = false

            local function externalInputPos(Input)
                return Vector2New(Input.Position.X, Input.Position.Y)
            end

            Items["ExternalToggle"]:Connect("InputBegan", function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1
                    and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                DraggingExternal = true
                ExternalInput = Input
                ExternalStart = Items["ExternalToggle"].Instance.Position
                ExternalStartInput = externalInputPos(Input)
                ExternalMoved = false

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End
                        or Input.UserInputState == Enum.UserInputState.Cancel then
                        if DraggingExternal and not ExternalMoved then
                            Window:SetOpen(not Window.IsOpen)
                        end
                        DraggingExternal = false
                        ExternalInput = nil
                    end
                end)
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if not DraggingExternal then return end

                local validMouse = Input.UserInputType == Enum.UserInputType.MouseMovement
                local validTouch = Input.UserInputType == Enum.UserInputType.Touch
                if not validMouse and not validTouch then return end
                if validTouch and ExternalInput and Input ~= ExternalInput then return end

                local delta = externalInputPos(Input) - ExternalStartInput
                if delta.Magnitude > 3 then
                    ExternalMoved = true
                end
                if not ExternalMoved then return end

                local Gui = Items["ExternalToggle"].Instance
                local parentS = Gui.Parent.AbsoluteSize
                local guiS = Gui.AbsoluteSize
                local anchor = Gui.AnchorPoint

                local minX = -anchor.X * guiS.X - ExternalStart.X.Scale * parentS.X
                local maxX = parentS.X - (1 - anchor.X) * guiS.X - ExternalStart.X.Scale * parentS.X
                local minY = -anchor.Y * guiS.Y - ExternalStart.Y.Scale * parentS.Y
                local maxY = parentS.Y - (1 - anchor.Y) * guiS.Y - ExternalStart.Y.Scale * parentS.Y

                local newX = MathClamp(ExternalStart.X.Offset + delta.X, minX, math.max(minX, maxX))
                local newY = MathClamp(ExternalStart.Y.Offset + delta.Y, minY, math.max(minY, maxY))

                Gui.Position = UDim2New(ExternalStart.X.Scale, newX, ExternalStart.Y.Scale, newY)
            end)
        end

        -- Improved mobile button feedback: soft scale, glow and rotation.
        Items["ExternalToggle"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1
                or Input.UserInputType == Enum.UserInputType.Touch then
                TweenService:Create(Items["ExternalToggleScale"].Instance, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.90}):Play()
                TweenService:Create(Items["ExternalToggleGlow"].Instance, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.35}):Play()
            end
        end)

        Items["ExternalToggle"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1
                or Input.UserInputType == Enum.UserInputType.Touch then
                TweenService:Create(Items["ExternalToggleScale"].Instance, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
                TweenService:Create(Items["ExternalToggleGlow"].Instance, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.65}):Play()
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        Window:SetCenter()
        task.wait()
        Window:SetOpen(true)
        return setmetatable(Window, Library)
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Name = Data.Name or Data.name or "Page",
            Columns = Data.Columns or Data.columns or 2,

            Items = { },
            ColumnsData = { },
            Active = false
        }

        local Items = { } do
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = Page.Window.Items["Pages"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["Liner"].Instance,
                Name = "\0",
                Visible = false,
                ImageTransparency = 0.5,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ImageColor3 = FromRGB(94, 213, 213),
                Size = UDim2New(1, 8, 1, 8),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Inactive"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = Page.Name,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0.5, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
                
            Items["TextGlow"] = Instances:Create("ImageLabel", {
                Parent = Items["Text"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 8, 1, 8),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 3),
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["TextGlow"]:AddToTheme({ImageColor3 = "Text"})
            
            Instances:Create("UIGradient", {
                Parent = Items["TextGlow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 1, 1),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(17, 21, 27)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background 1"})

            Items["Page"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 80),
                BorderColor3 = FromRGB(0, 0, 0),
                Visible = false,
                Size = UDim2New(1, 0, 1, -35),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Page"].Instance,
                Name = "\0",
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalFlex = Enum.UIFlexAlignment.Fill
            })
            
            for Index = 1, Page.Columns do 
                local NewColumn = Instances:Create("ScrollingFrame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = FromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 100, 0, 100),
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIPadding", {
                    Parent = NewColumn.Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 5),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = NewColumn.Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Page.ColumnsData[Index] = NewColumn
            end                                    

            Page.Items = Items
        end

        local Debounce = false

        function Page:Turn(Bool)
            if Debounce then 
                return 
            end

            Page.Active = Bool 
            
            Debounce = true
            Items["Page"].Instance.Visible = Bool 
            Items["Page"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance

            if Page.Active then
                Items["Liner"]:Tween(TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2New(1, 0, 0, 1)})
                Items["TextGlow"]:Tween(nil, {ImageTransparency = 0.7})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
                Items["Hide"]:Tween(nil, {BackgroundTransparency = 0})

                Items["Page"]:Tween(TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, 0, 35)})
            else
                Items["Liner"]:Tween(TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2New(0, 0, 0, 1)})
                Items["TextGlow"]:Tween(nil, {ImageTransparency = 1})
                Items["Text"]:Tween(nil, {TextTransparency = 0.4})
                Items["Hide"]:Tween(nil, {BackgroundTransparency = 1})

                Items["Page"]:Tween(TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, 0, 80)})
            end

            Debounce = false
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in Page.Window.Pages do 
                if Value == Page and Page.Active then
                    return
                end

                Value:Turn(Value == Page)
            end
        end)

        if #Page.Window.Pages == 0 then 
            Page:Turn(true)
        end

        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,

            Items = { }
        }

        local Items = { } do
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 40),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(19, 25, 31)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                PaddingBottom = UDimNew(0, 8)
            })
            
            Items["Topbar"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 25),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(19, 25, 31)
            })  Items["Topbar"]:AddToTheme({BackgroundColor3 = "Inline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Topbar"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(165, 165, 165))}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Topbar"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["Topbar"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Liner"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(171, 171, 171))}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Topbar"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                AnchorPoint = Vector2New(0, 0.5),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 8, 0.5, -1),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 8, 0, 35),
                Size = UDim2New(1, -16, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            Section.Items = Items
        end

        return setmetatable(Section, Library.Sections)
    end

    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end,

            Value = false
        }

        local Items = { } do 
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Items["Content"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 15),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["IndicatorOutline"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 0, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 12, 0, 12),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["IndicatorOutline"]:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["IndicatorOutline"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["IndicatorInline"] = Instances:Create("Frame", {
                Parent = Items["IndicatorOutline"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5 ,0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, -2, 0, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["IndicatorInline"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = Toggle.Name,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 20, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["SubElements"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(1, 0, 0, 0),
                Size = UDim2New(0, 0, 1, 0),
                ZIndex = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["SubElements"].Instance,
                Name = "\0",
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Toggle"]:OnHover(function()
                -- if Toggle.Value then return end 
                Items["IndicatorOutline"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)
            
            Items["Toggle"]:OnHoverLeave(function()
                -- if Toggle.Value then return end 
                Items["IndicatorOutline"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        function Toggle:Get()
            return Toggle.Value 
        end

        function Toggle:Set(Value)
            Toggle.Value = Value 
            Library.Flags[Toggle.Flag] = Value 

            if Toggle.Value then 
                Items["IndicatorInline"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2New(1, -2, 1, -2)})
            else
                Items["IndicatorInline"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Size = UDim2New(0, -2, 0, -2)})
            end

            if Toggle.Callback then 
                Library:SafeCall(Toggle.Callback, Toggle.Value)
            end
        end

        function Toggle:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = Toggle.Window,
                Page = Toggle.Page,
                Section = Toggle.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Alpha = Data.Alpha or Data.alpha or 0,
                Callback = Data.Callback or Data.callback or function() end
            }

            local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                Parent = Items["SubElements"],
                Page = Colorpicker.Page,
                Flag = Colorpicker.Flag,
                Section = Colorpicker.Section,
                Default = Colorpicker.Default,
                Alpha = Colorpicker.Alpha,
                Callback = Colorpicker.Callback,
            })

            return NewColorpicker
        end

        function Toggle:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = Toggle.Window,
                Page = Toggle.Page,
                Section = Toggle.Section,

                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,
                Mode = Data.Mode or Data.mode or "Toggle"
            }

            local NewKeybind, Items = Library:CreateKeybind({
                Name = Toggle.Name,
                Parent = Items["SubElements"],
                Flag = Keybind.Flag,
                Section = Keybind.Section,
                Default = Keybind.Default,
                Mode = Keybind.Mode,
                Callback = Keybind.Callback
            })

            return NewKeybind
        end

        function Toggle:SetVisibility(Bool)
            Items["Toggle"].Instance.Visible = Bool 
        end

        Items["Toggle"]:Connect("Activated", function()
            Toggle:Set(not Toggle.Value)
        end)

        Toggle:Set(Toggle.Default)

        Library.SetFlags[Toggle.Flag] = function(Value)
            Toggle:Set(Value)
        end

        return Toggle 
    end

    Library.Sections.Button = function(self, Data)
        Data = Data or { }

        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Button",
            Callback = Data.Callback or Data.callback or function() end
        }

        local Items = { } do
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Button.Section.Items["Content"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Button.Name,
                AutoButtonColor = false,
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Button"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(199, 199, 199))}
            })                

            Items["Button"]:OnHover(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)
            
            Items["Button"]:OnHoverLeave(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        function Button:SetVisibility(Bool)
            Items["Button"].Instance.Visible = Bool
        end

        function Button:SetText(Text)
            Button.Name = tostring(Text or "")
            Items["Button"].Instance.Text = Button.Name
        end

        function Button:Press()
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
            Library:SafeCall(Button.Callback)
            task.wait(0.1)
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end

        Items["Button"]:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        return Button
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }
        
        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Decimals = Data.Decimals or Data.decimals or 1,
            Suffix = Data.Suffix or Data.suffix or "",
            Max = Data.Max or Data.max or 100,
            Default = Data.Default or Data.Default or 0,
            Callback = Data.Callback or Data.callback or function() end,

            Value = 0,
            Sliding = false
        }

        local Items = { } do 
            Items["Slider"] = Instances:Create("Frame", {
                Parent = Slider.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 35),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Slider.Name,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["RealSlider"] = Instances:Create("TextButton", {
                Parent = Items["Slider"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 12),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealSlider"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Accent"] = Instances:Create("Frame", {
                Parent = Items["RealSlider"].Instance,
                Name = "\0",
                Position = UDim2New(0, 1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0.5, 0, 1, -2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Items["Value"] = Instances:Create("TextBox", {
                Parent = Items["Slider"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                Active = false,
                TextTransparency = 0.5,
                AnchorPoint = Vector2New(1, 0),
                TextSize = 14,
                Size = UDim2New(0, 0, 0, 15),
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "50s",
                Selectable = false,
                BackgroundTransparency = 1,
                Position = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})      

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)
            
            Items["RealSlider"]:OnHoverLeave(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        function Slider:Get()
            return Slider.Value
        end

        function Slider:Set(Value)
            Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)
            Library.Flags[Slider.Flag] = Slider.Value

            Items["Accent"].Instance.Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), -2, 1, -2)
            Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

            if Slider.Value <= Slider.Min then 
                Items["Accent"].Instance.Visible = false
            else
                Items["Accent"].Instance.Visible = true
            end

            if Slider.Callback then 
                Library:SafeCall(Slider.Callback, Slider.Value)
            end
        end

        Slider.SliderFrame = Items["RealSlider"].Instance

        Items["RealSlider"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = true
                Library._activeSlider = Slider

                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                Slider:Set(Value)
            end
        end)

        Items["RealSlider"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = false
                if Library._activeSlider == Slider then Library._activeSlider = nil end
            end
        end)

        if Slider.Default then
            Slider:Set(Slider.Default)
        end

        Library.SetFlags[Slider.Flag] = function(Value)
            Slider:Set(Value)
        end

        return Slider
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or Data.Options or Data.options or { "One", "Two", "Three" },
            Default = Data.Default or Data.default or nil,
            MaxSize = Data.MaxSize or Data.maxsize or 75,
            Callback = Data.Callback or Data.callback or function() end,
            Multi = Data.Multi or Data.multi or false,
            Locked = Data.Locked or Data.locked or {},

            Options = { },
            Value = { },
            IsOpen = false
        }

        local Items = { } do
            Items["Dropdown"] = Instances:Create("Frame", {
                Parent = Dropdown.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 45),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Dropdown"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Dropdown.Name,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["RealDropdown"] = Instances:Create("TextButton", {
                Parent = Items["Dropdown"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealDropdown"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealDropdown"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "-",
                AnchorPoint = Vector2New(0, 0.5),
                Size = UDim2New(1, -16, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 4, 0.5, 0),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
            
            Items["OptionHolder"] = Instances:Create("TextButton", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                FontFace = Library.Font,
                Visible = false,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 130),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["OptionHolder"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Search"] = Instances:Create("TextBox", {
                Parent = Items["OptionHolder"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = "",
                Size = UDim2New(1, -8, 0, 15),
                Position = UDim2New(0, 4, 0, 4),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                PlaceholderColor3 = FromRGB(255, 255, 255),
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = "Search..",
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Search"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Holder"] = Instances:Create("ScrollingFrame", {
                Parent = Items["OptionHolder"].Instance,
                Name = "\0",
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(46, 52, 61),
                MidImage = "rbxassetid://93024691806056",
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 4,
                Size = UDim2New(1, -4, 1, -26),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 22),
                BottomImage = "rbxassetid://93024691806056",
                TopImage = "rbxassetid://93024691806056",
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Holder"]:AddToTheme({ScrollBarImageColor3 = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 6),
                PaddingBottom = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 10),
                PaddingLeft = UDimNew(0, 6)
            })                

            Instances:Create("UIListLayout", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)
            
            Items["RealDropdown"]:OnHoverLeave(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        function Dropdown:Set(Option)
            if Data.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Dropdown.Value = Option
                Library.Flags[Dropdown.Flag] = Option

                for Index, Value in Option do
                    local OptionData = Dropdown.Options[Value]
                    
                    if not OptionData or OptionData.Locked then
                        continue
                    end

                    OptionData.Selected = true 
                    OptionData:Toggle("Active")
                end

                Items["Value"].Instance.Text = TableConcat(Option, ", ")
            else
                if not Dropdown.Options[Option] then
                    return
                end

                local OptionData = Dropdown.Options[Option]

                Dropdown.Value = Option
                Library.Flags[Dropdown.Flag] = Option

                for Index, Value in Dropdown.Options do
                    if Value ~= OptionData then
                        Value.Selected = false 
                        Value:Toggle("Inactive")
                    else
                        Value.Selected = true 
                        Value:Toggle("Active")
                    end
                end

                Items["Value"].Instance.Text = Option
            end

            if Dropdown.Callback then   
                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end
        end

        local CompareVectors = function(PointA, PointB)
            return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
        end

        local IsClipped = function(Object, Column)
            local Parent = Column
            
            local BoundryTop = Parent.AbsolutePosition
            local BoundryBottom = BoundryTop + Parent.AbsoluteSize

            local Top = Object.AbsolutePosition
            local Bottom = Top + Object.AbsoluteSize 

            return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
        end

        Items["RealDropdown"]:Connect("Changed", function(Property)
            if Property == "AbsolutePosition" and Dropdown.IsOpen then
                Dropdown.IsOpen = not IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
                Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
            end
        end)

        local Debounce = false 
        local RenderStepped 

        function Dropdown:SetOpen(Bool)
            if Debounce then 
                return
            end 

            Dropdown.IsOpen = Bool
            Debounce = true

            if Bool then 
                Items["OptionHolder"].Instance.Visible = true
                Items["OptionHolder"].Instance.Parent = Library.Holder.Instance

                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["OptionHolder"].Instance.Position = UDim2New(
                        0, 
                        Items["RealDropdown"].Instance.AbsolutePosition.X, 
                        0, 
                        Items["RealDropdown"].Instance.AbsolutePosition.Y + Items["RealDropdown"].Instance.AbsoluteSize.Y + 65
                    )

                    Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, Dropdown.MaxSize)
                end)

                for Index, Value in Library.OpenFrames do 
                    if Value ~= Dropdown then 
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Dropdown] = Dropdown
            else
                if RenderStepped then
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end

                if Library.OpenFrames[Dropdown] then 
                    Library.OpenFrames[Dropdown] = nil
                end
            end

            local AllInstances = Items["OptionHolder"].Instance:GetDescendants()
            TableInsert(AllInstances, Items["OptionHolder"].Instance)
            
            local NewTween

            for Index, Value in AllInstances do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if not Value.ClassName:find("UI") then
                    Value.ZIndex = Dropdown.IsOpen and 10 or 1
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, 0.2)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, 0.2)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                task.wait(0.2)
                Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Dropdown:Add(Option)
            local IsFirstOption = #Dropdown.Options == 0
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  OptionButton:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIGradient", {
                Parent = OptionButton.Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })
            
            local OptionStroke = Instances:Create("UIStroke", {
                Parent = OptionButton.Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Transparency = 1,
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter
            })  OptionStroke:AddToTheme({Color = "Border"})
            
            local OptionLiner = Instances:Create("Frame", {
                Parent = OptionButton.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  OptionLiner:AddToTheme({BackgroundColor3 = "Accent"})
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = Option,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  OptionText:AddToTheme({TextColor3 = "Text"})

            local OptionData = {
                Button = OptionButton,
                Selected = false,
                Name = Option,
                Text = OptionText,
                IsFirstOption = IsFirstOption,
                Liner = OptionLiner,
                Stroke = OptionStroke,
                Locked = Dropdown.Locked[Option] == true
            }

            if OptionData.Locked then
                OptionData.Text.Instance.Text = OptionData.Name .. "  [NATIVE]"
                OptionData.Text.Instance.TextTransparency = 0.2
            end

            function OptionData:Toggle(Status)
                if Status == "Active" then 
                    OptionData.Liner:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                    OptionData.Text:Tween(nil, {TextTransparency = 0})
                    OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
                    OptionData.Stroke:Tween(nil, {Transparency = 0})
                else
                    OptionData.Liner:Tween(nil, {BackgroundTransparency = 1})
                    OptionData.Text:Tween(nil, {TextTransparency = 0.4})
                    OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
                    OptionData.Stroke:Tween(nil, {Transparency = 1})
                end
            end

            function OptionData:Set()
                -- Locked options are display-only. This is used by native whitelist entries.
                if OptionData.Locked then
                    return
                end

                OptionData.Selected = not OptionData.Selected

                if Data.Multi then 
                    local Index = TableFind(Dropdown.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Dropdown.Value, Index)
                    else
                        TableInsert(Dropdown.Value, OptionData.Name)
                    end

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    Library.Flags[Dropdown.Flag] = Dropdown.Value

                    local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"
                    Items["Value"].Instance.Text = TextFormat
                else
                    if OptionData.Selected then 
                        Dropdown.Value = OptionData.Name
                        Library.Flags[Dropdown.Flag] = OptionData.Name

                        OptionData.Selected = true
                        OptionData:Toggle("Active")

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then
                                Value.Selected = false 
                                Value:Toggle("Inactive")
                            end
                        end

                        Items["Value"].Instance.Text = OptionData.Name
                    else
                        Dropdown.Value = nil
                        Library.Flags[Dropdown.Flag] = nil

                        OptionData.Selected = false
                        OptionData:Toggle("Inactive")

                        Items["Value"].Instance.Text = "-"
                    end
                end

                if Dropdown.Callback then
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            OptionData.Button:Connect("Activated", function()
                OptionData:Set()
            end)

            Dropdown.Options[OptionData.Name] = OptionData
            return OptionData
        end

        function Dropdown:Remove(Option)
            local OptionData = Dropdown.Options[Option]
            if OptionData then
                OptionData.Button:Clean()
                Dropdown.Options[Option] = nil
            end
        end

        function Dropdown:Refresh(List)
            for Index, Value in Dropdown.Options do 
                Dropdown:Remove(Value.Name)
            end

            for Index, Value in List do 
                Dropdown:Add(Value)
            end
        end

        for Index, Value in Dropdown.Items do 
            Dropdown:Add(Value)
        end

        Items["RealDropdown"]:Connect("MouseButton1Down", function()
            Dropdown:SetOpen(not Dropdown.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Dropdown.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                    return
                end

                Dropdown:SetOpen(false)
            end
        end)

        local SearchStepped 
        
        Items["Search"]:Connect("Focused", function()
            SearchStepped = RunService.RenderStepped:Connect(function()
                for Index, Value in Dropdown.Options do
                    if Items["Search"].Instance.Text ~= "" then
                        if StringFind(StringLower(Value.Name), Library:EscapePattern(StringLower(Items["Search"].Instance.Text))) then
                            Value.Button.Instance.Visible = true
                        else
                            Value.Button.Instance.Visible = false
                        end
                    else
                        Value.Button.Instance.Visible = true
                    end
                end
            end)
        end)

        Items["Search"]:Connect("FocusLost", function()
            if SearchStepped then
                SearchStepped:Disconnect()
                SearchStepped = nil
            end
        end)

        Library.SetFlags[Dropdown.Flag] = function(Value)
            Dropdown:Set(Value)
        end

        if Dropdown.Default then 
            Dropdown:Set(Dropdown.Default)
        else
            for Index, Value in Dropdown.Options do 
                if Value.IsFirstOption then
                    Dropdown:Set(Index)
                end
            end
        end

        return Dropdown 
    end

    Library.Sections.Label = function(self, Name)
        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Name or "Label"
        }

        local Items = { } do
            Items["Label"] = Instances:Create("Frame", {
                Parent = Label.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 15),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Label.Name,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["SubElements"] = Instances:Create("Frame", {
                Parent = Items["Label"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(1, 0, 0, 0),
                Size = UDim2New(0, 0, 1, 0),
                ZIndex = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["SubElements"].Instance,
                Name = "\0",
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })                
        end

        function Label:SetText(Text)
            Text = tostring(Text)
            Items["Text"].Instance.Text = Text
        end

        function Label:SetVisibility(Bool)
            Items["Label"].Instance.Visible = Bool
        end

        function Label:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = Label.Window,
                Page = Label.Page,
                Section = Label.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Alpha = Data.Alpha or Data.alpha or 0,
                Callback = Data.Callback or Data.callback or function() end
            }

            local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                Parent = Items["SubElements"],
                Page = Colorpicker.Page,
                Flag = Colorpicker.Flag,
                Section = Colorpicker.Section,
                Default = Colorpicker.Default,
                Alpha = Colorpicker.Alpha,
                Callback = Colorpicker.Callback,
            })

            return NewColorpicker
        end

        function Label:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = Label.Window,
                Page = Label.Page,
                Section = Label.Section,

                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,
                Mode = Data.Mode or Data.mode or "Toggle"
            }

            local NewKeybind, Items = Library:CreateKeybind({
                Name = Keybind.Name,
                Parent = Items["SubElements"],
                Flag = Keybind.Flag,
                Section = Keybind.Section,
                Default = Keybind.Default,
                Mode = Keybind.Mode,
                Callback = Keybind.Callback
            })

            return NewKeybind
        end

        return Label 
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or "",
            Callback = Data.Callback or Data.callback or function() end,
            Placeholder = Data.Placeholder or Data.placeholder or "...",
            Finished = Data.Finished or Data.finished or false,
            Numeric = Data.Numeric or Data.numeric or false,

            Value = ""
        }

        local Items = { } do 
            Items["Textbox"] = Instances:Create("Frame", {
                Parent = Textbox.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["Input"] = Instances:Create("TextBox", {
                Parent = Items["Textbox"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                CursorPosition = -1,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Size = UDim2New(0.6000000238418579, 0, 1, 0),
                BorderSizePixel = 0,
                PlaceholderColor3 = FromRGB(185, 185, 185),
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = Textbox.Placeholder,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Inactive Text", BackgroundColor3 = "Element"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Input"].Instance,
                Name = "\0",
                PaddingLeft = UDimNew(0, 6)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Textbox"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Textbox.Name,
                AnchorPoint = Vector2New(1, 0),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Input"]:OnHover(function()
                Items["Input"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)

            Items["Input"]:OnHoverLeave(function()
                Items["Input"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        function Textbox:Get()
            return Textbox.Value
        end

        function Textbox:SetVisibility(Bool)
            Items["Textbox"].Instance.Visible = Bool
        end

        function Textbox:Set(Value)
            if Textbox.Numeric then
                if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                    Value = Textbox.Value
                end
            end

            Textbox.Value = Value
            Items["Input"].Instance.Text = Value
            Library.Flags[Textbox.Flag] = Value

            if Textbox.Callback then
                Library:SafeCall(Textbox.Callback, Textbox.Value)
            end
        end
        
        if Textbox.Finished then 
            Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                if PressedEnterQuestionMark then
                    Textbox:Set(Items["Input"].Instance.Text)
                end
            end)
        else
            Items["Input"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                Textbox:Set(Items["Input"].Instance.Text)
            end)
        end

        if Textbox.Default then
            Textbox:Set(Textbox.Default)
        end

        Library.SetFlags[Textbox.Flag] = function(Value)
            Textbox:Set(Value)
        end

        return Textbox
    end

    Library.CreateSettingsPage = function(self, Window, KeybindList, Watermark, ModeratorList)
        local SettingsPage = Window:Page({Name = "Settings", Columns = 2})
        local SettingsSection = SettingsPage:Section({Name = "Settings", Side = 1}) do
            SettingsSection:Button({ Name="Rejoin", Callback=function()
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end })

            SettingsSection:Button({
                Name = "Unload",
                Callback = function()
                    Library:Unload()
                end
            })

            SettingsSection:Toggle({
                Name = "Watermark",
                Flag = "Watermark",
                Default = false,
                Callback = function(Value)
                    Watermark:SetVisibility(Value)
                end
            })

            SettingsSection:Toggle({
                Name = "Keybind List",
                Flag = "Keybind list",
                Default = false,
                Callback = function(Value)
                    KeybindList:SetVisibility(Value)
                end
            })

            SettingsSection:Toggle({
                Name = "Moderator List",
                Flag = "Moderator list",
                Default = true,
                Callback = function(Value)
                    if ModeratorList then
                        ModeratorList:SetVisibility(Value)
                    end
                end
            })
            
            SettingsSection:Label("Menu Keybind"):Keybind({
                Name = "Menu Keybind",
                Flag = "MenuKeybind",
                Default = Library.MenuKeybind,
                Mode = "Toggle",
                Callback = function()
                    Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                end
            })

        end

        
-- Language preference
local Language = "Portuguese"
local LanguageFile = "tomboy.hook/Language.json"

local function LoadLanguagePreference()
    if isfile and isfile(LanguageFile) then
        local ok, data = pcall(readfile, LanguageFile)
        if ok and data then
            local ok2, cfg = pcall(function()
                return HttpService:JSONDecode(data)
            end)
            if ok2 and type(cfg) == "table" then
                if cfg.Language == "Portuguese" or cfg.Language == "English" then
                    Language = cfg.Language
                end
            end
        end
    end
end


local LanguageMap = {
    ["English"] = {},
    ["Portuguese"] = {
        ["Settings"]="Configurações", ["Rejoin"]="Reconectar", ["Unload"]="Descarregar",
        ["Watermark"]="Marca d'água", ["Keybind List"]="Lista de teclas", ["Moderator List"]="Lista de moderadores",
        ["Menu Keybind"]="Tecla do menu", ["Configs"]="Configurações", ["Profiles list"]="Lista de perfis",
        ["Auto Load Config"]="Carregar config automaticamente", ["Clear Auto Config"]="Limpar Auto Load",
        ["Config name"]="Nome da config", ["Create"]="Criar", ["Delete"]="Excluir", ["Load"]="Carregar",
        ["Overwrite"]="Sobrescrever", ["Save"]="Salvar", ["Refresh"]="Atualizar", ["Theming"]="Tema",
        ["Combat"]="Combate", ["Visuals"]="Visuais", ["Misc"]="Diversos", ["Silent Aim"]="Mira silenciosa",
        ["Options"]="Opções", ["Aim Part"]="Parte da mira", ["Randomize Hit Part"]="Randomizar parte atingida",
        ["Instant Hit"]="Acerto instantâneo", ["Wallbang"]="Atravessar paredes", ["Manipulation"]="Manipulação",
        ["Manipulation Distance"]="Distância de manipulação", ["Crosshair Status"]="Status da mira",
        ["Target AI"]="Alvo IA", ["Target Heli"]="Alvo helicóptero", ["Use FOV"]="Usar FOV",
        ["Show FOV Circle"]="Mostrar círculo do FOV", ["Target Line"]="Linha do alvo",
        ["Visible Targets Only"]="Apenas alvos visíveis", ["FOV Outline Glow"]="Brilho do contorno do FOV",
        ["FOV Size"]="Tamanho do FOV", ["FOV Glow Intensity"]="Intensidade do brilho do FOV",
        ["Whitelist Players"]="Jogadores na whitelist", ["Whitelist Mode"]="Modo whitelist",
        ["Bullet Tracer"]="Traçador de balas", ["Tracer Style"]="Estilo do traçador",
        ["Tracer Thickness"]="Espessura do traçador", ["Tracer Lifetime"]="Duração do traçador",
        ["Instant Equip"]="Equipamento instantâneo", ["Auto Shoot Packet"]="Disparo automático por pacote",
        ["Packet Prediction"]="Previsão de pacote", ["Hitscan"]="Hitscan", ["Hitscan Walls"]="Hitscan através de paredes",
        ["Shoot Speed Mult"]="Multiplicador de velocidade de tiro", ["Target Info"]="Informações do alvo",
        ["Target Info Size"]="Tamanho das informações", ["Target Info Fixed"]="Fixar informações do alvo",
        ["Triggerbot"]="Triggerbot", ["Enabled"]="Ativado", ["Shoot On Manipulated"]="Atirar em manipulado",
        ["Gun Mods"]="Modificações de armas", ["No Spread"]="Sem dispersão", ["No Gun Bob"]="Sem balanço da arma",
        ["Instant Aim"]="Mira instantânea", ["Force Auto"]="Forçar automático", ["Rapid Fire"]="Tiro rápido",
        ["Rapid Fire Delay"]="Atraso do tiro rápido", ["Instant Mosin (R7)"]="Mosin instantâneo (R7)",
        ["No Recoil"]="Sem recuo", ["Instant Mag Refill"]="Recarregar carregador instantaneamente",
        ["Anti Aim"]="Anti-mira", ["Mode"]="Modo", ["Yaw Offset"]="Deslocamento Yaw", ["Pitch Tilt"]="Inclinação Pitch",
        ["Fake Lag"]="Lag falso", ["Fake Lag Interval"]="Intervalo do lag falso", ["Resolve Desync"]="Resolver desync",
        ["Visualize Server Pos"]="Visualizar posição do servidor", ["Visualize Transparency"]="Transparência da visualização",
        ["Custom Offset"]="Deslocamento personalizado", ["Offset Radius"]="Raio do deslocamento",
        ["Floor Clip"]="Atravessar chão", ["Floor Clip Depth"]="Profundidade do chão",
        ["UG Resolver (Hold X)"]="Resolver UG (segure X)", ["UG Resolver Depth"]="Profundidade do UG",
        ["TP Kill"]="TP Kill", ["Show Charge Bar"]="Mostrar barra de carga", ["Height Offset"]="Deslocamento de altura",
        ["Auto Look At Target"]="Olhar automaticamente para o alvo", ["Auto Triggerbot"]="Triggerbot automático",
        ["Player ESP"]="ESP de jogadores", ["Font"]="Fonte", ["Font Size"]="Tamanho da fonte",
["Infinite Range"]="Alcance infinito",
        ["Enable ESP"]="Ativar ESP", ["Visible Check"]="Verificação de visibilidade", ["Box ESP"]="ESP de caixa",
        ["Box Fill"]="Preenchimento da caixa", ["Name ESP"]="ESP de nome", ["Health Bar"]="Barra de vida",
        ["Distance"]="Distância", ["Text Outline"]="Contorno do texto", ["Weapon ESP"]="ESP de arma",
        ["Skeleton"]="Esqueleto", ["Chams"]="Chams", ["Chams Outline"]="Contorno dos Chams",
        ["Chams Visible Only"]="Chams apenas visíveis", ["Chams Material"]="Material dos Chams",
        ["Rainbow Chams"]="Chams arco-íris", ["Pulse Chams"]="Chams pulsantes",
        ["Visible Split Chams"]="Chams divididos por visibilidade", ["Health Color Chams"]="Chams por vida",
        ["Outline Pulse Chams"]="Pulso do contorno dos Chams", ["Strobe Chams"]="Chams estroboscópicos",
        ["Team Color Chams"]="Chams da cor do time", ["Health Bar Thickness"]="Espessura da barra de vida",
        ["Health Glow Size"]="Tamanho do brilho da vida", ["Corpse ESP"]="ESP de cadáveres",
        ["Show Name"]="Mostrar nome", ["Show Distance"]="Mostrar distância", ["Outline"]="Contorno",
        ["Crosshair"]="Mira", ["Speed"]="Velocidade", ["Radius"]="Raio", ["Thickness"]="Espessura", ["Gap"]="Espaço",
        ["Inventory"]="Inventário", ["Item Finder"]="Localizador de itens", ["Inventory Checker"]="Verificador de inventário",
        ["Show Full Inventory"]="Mostrar inventário completo", ["Show Value"]="Mostrar valor",
        ["Check Corpse"]="Verificar cadáver", ["Enable Dragging"]="Permitir arrastar", ["Size"]="Tamanho",
        ["Items To Find"]="Itens para encontrar", ["Enable Item Finder"]="Ativar localizador de itens",
        ["Glow Size"]="Tamanho do brilho", ["Lighting"]="Iluminação", ["Time Changer"]="Alterar horário",
        ["Time"]="Horário", ["Ambient"]="Ambiente", ["No Fog"]="Sem neblina", ["No Grass"]="Sem grama",
        ["No Clouds"]="Sem nuvens", ["Custom Skybox"]="Céu personalizado", ["No Shadows"]="Sem sombras",
        ["No Leafs"]="Sem folhas", ["Extreme Potato Mode"]="Modo batata extremo", ["Objects"]="Objetos",
        ["Show Extractions"]="Mostrar extrações", ["Show Cars"]="Mostrar carros",
        ["Camera/Effects"]="Câmera/Efeitos", ["Hit Logs"]="Registros de acertos", ["FOV Override"]="Substituir FOV",
        ["Zoom"]="Zoom", ["Zoom Size"]="Tamanho do zoom", ["No Screen Effects"]="Sem efeitos de tela",
        ["Remove Muzzle Flash"]="Remover clarão do disparo", ["Hit/Kill Effect"]="Efeito de acerto/abate",
        ["Hit Effect Stars"]="Estrelas do efeito de acerto", ["Text Size"]="Tamanho do texto", ["Y Position"]="Posição Y",
        ["Viewmodel"]="Modelo da arma", ["X Offset"]="Deslocamento X", ["Y Offset"]="Deslocamento Y",
        ["Z Offset"]="Deslocamento Z", ["Arm Chams"]="Chams dos braços", ["Arm Material"]="Material dos braços",
        ["Gun Chams"]="Chams da arma", ["Gun Material"]="Material da arma", ["Unlock All Skins"]="Desbloquear todas as skins",
        ["Skins"]="Skins", ["Freecam"]="Câmera livre", ["Character"]="Personagem", ["Speedhack"]="Hack de velocidade",
        ["Third Person"]="Terceira pessoa", ["3P Distance"]="Distância da 3ª pessoa", ["No Fall Damage"]="Sem dano de queda",
        ["Run On Water"]="Correr na água", ["Remove Mines"]="Remover minas", ["Fly Hack"]="Hack de voo",
        ["Y Speed"]="Velocidade Y", ["Custom Sounds"]="Sons personalizados", ["Custom Hit Sound"]="Som de acerto personalizado",
        ["Hit Sound"]="Som de acerto", ["Hit Volume"]="Volume do acerto", ["Test Hit Sound"]="Testar som de acerto",
        ["Custom Gun Sound"]="Som de arma personalizado", ["Gun Sound"]="Som da arma", ["Gun Volume"]="Volume da arma",
        ["Test Gun Sound"]="Testar som da arma", ["Detection"]="Detecção", ["Mod Detector"]="Detector de moderadores",
        ["Cheater Detector"]="Detector de trapaceiros", ["Quest Objectives"]="Objetivos de missões",
        ["Quest Objective ESP"]="ESP de objetivos", ["Active Quest Info"]="Informações da missão ativa",
        ["Language / Idioma"]="Idioma",
        ["English"]="Inglês", ["Portuguese"]="Português", ["No target"]="Nenhum alvo", ["TARGET INFO"]="INFORMAÇÕES DO ALVO", ["DIST  --   VIS  --\nAIM   --   K/D  --/--"]="DIST  --   VIS  --\nMIRA   --   K/D  --/--", ["Copy"]="Copiar", ["Paste"]="Colar", ["Clear"]="Limpar", ["Apply"]="Aplicar", ["Cancel"]="Cancelar", ["Close"]="Fechar", ["On"]="Ligado", ["Off"]="Desligado"
    }
}

local PortugueseExtra = {
    ["Test Tools"] = "Ferramentas de teste",
    ["Performance Monitor"] = "Monitor de desempenho",
    ["Auto-save Test Config"] = "Salvamento automático de teste",
    ["Performance: measuring..."] = "Desempenho: medindo...",
    ["Performance monitor: Off"] = "Monitor de desempenho: Desligado",
    ['Global Font'] = 'Fonte global',
    ['Profiles list'] = 'Lista de perfis',
    ['Set AutoLoad: None'] = 'Definir carregamento automático: Nenhum',
    ['Player ESP'] = 'ESP de jogadores',
    ['Options'] = 'Opções',
    ['Font'] = 'Fonte',
    ['Font Size'] = 'Tamanho da fonte',
    ['Infinite Range'] = 'Alcance infinito',
    ['Enable ESP'] = 'Ativar ESP',
    ['Visible Check'] = 'Verificação de visibilidade',
    ['ESP Outline'] = 'Contorno do ESP',
    ['Outline Visible Check'] = 'Verificação de visibilidade do contorno',
    ['Box ESP'] = 'ESP de caixa',
    ['Box Fill'] = 'Preenchimento da caixa',
    ['Name ESP'] = 'ESP de nome',
    ['Health Bar'] = 'Barra de vida',
    ['Distance'] = 'Distância',
    ['Text Outline'] = 'Contorno do texto',
    ['Weapon ESP'] = 'ESP de arma',
    ['Skeleton'] = 'Esqueleto',
    ['Chams'] = 'Chams',
    ['Chams Outline'] = 'Contorno dos Chams',
    ['Chams Visible Only'] = 'Chams apenas visíveis',
    ['Chams Material'] = 'Material dos Chams',
    ['Rainbow Chams'] = 'Chams arco-íris',
    ['Pulse Chams'] = 'Chams pulsantes',
    ['Visible Split Chams'] = 'Chams divididos por visibilidade',
    ['Health Color Chams'] = 'Chams por vida',
    ['Outline Pulse Chams'] = 'Pulso do contorno dos Chams',
    ['Strobe Chams'] = 'Chams estroboscópicos',
    ['Health Bar Thickness'] = 'Espessura da barra de vida',
    ['Health Glow Size'] = 'Tamanho do brilho da vida',
    ['Corpse ESP'] = 'ESP de cadáveres',
    ['Show Name'] = 'Mostrar nome',
    ['Show Distance'] = 'Mostrar distância',
    ['Outline'] = 'Contorno',
    ['Enable'] = 'Ativar',
    ['Lighting'] = 'Iluminação',
    ['Objects'] = 'Objetos',
    ['Camera/Effects'] = 'Câmera/Efeitos',
    ['Viewmodel'] = 'Modelo da arma',
    ['Character'] = 'Personagem',
    ['Detection'] = 'Detecção',
    ['Quest Objectives'] = 'Objetivos de missões',
    ['Quest Objective ESP'] = 'ESP de objetivos',
    ['Active Quest Info'] = 'Informações da missão ativa',
    ['Boss Checklist'] = 'Lista de chefes',
    ['Death'] = 'Morto',
    ['Alive'] = 'Vivo',
    ['Team'] = 'Time',
    ['Create'] = 'Criar',
    ['Delete'] = 'Excluir',
    ['Load'] = 'Carregar',
    ['Overwrite'] = 'Sobrescrever',
    ['Refresh'] = 'Atualizar',
    ['Cancel'] = 'Cancelar',
    ['Close'] = 'Fechar',
    ['Apply'] = 'Aplicar',
    ['Clear'] = 'Limpar',
    ['Copy'] = 'Copiar',
    ['Paste'] = 'Colar',
    ['Rejoin'] = 'Reconectar',
    ['Unload'] = 'Descarregar',
    ['Settings'] = 'Configurações',
    ['My Profile'] = 'Meu perfil',
    ['Watermark'] = "Marca d'água",
    ['Keybind List'] = 'Lista de teclas',
    ['Moderator List'] = 'Lista de moderadores',
    ['Language / Idioma'] = 'Idioma',
    ['English'] = 'Inglês',
    ['Portuguese'] = 'Português',
    ['Config name'] = 'Nome da configuração',
    ['Auto Load Config'] = 'Carregar configuração automaticamente',
    ['Clear Auto Config'] = 'Limpar carregamento automático',
    ['Theming'] = 'Tema',
    ['Silent Aim'] = 'Mira silenciosa',
    ['Aim Part'] = 'Parte da mira',
    ['Randomize Hit Part'] = 'Randomizar parte atingida',
    ['Instant Hit'] = 'Acerto instantâneo',
    ['Wallbang'] = 'Atravessar paredes',
    ['Manipulation'] = 'Manipulação',
    ['Manipulation Distance'] = 'Distância de manipulação',
    ['Crosshair Status'] = 'Status da mira',
    ['Target AI'] = 'Alvo IA',
    ['Target Heli'] = 'Alvo helicóptero',
    ['Use FOV'] = 'Usar FOV',
    ['Show FOV Circle'] = 'Mostrar círculo do FOV',
    ['Target Line'] = 'Linha do alvo',
    ['Visible Targets Only'] = 'Apenas alvos visíveis',
    ['FOV Outline Glow'] = 'Brilho do contorno do FOV',
    ['FOV Size'] = 'Tamanho do FOV',
    ['FOV Glow Intensity'] = 'Intensidade do brilho do FOV',
    ['Whitelist Players'] = 'Jogadores na whitelist',
    ['Whitelist Mode'] = 'Modo whitelist',
    ['Bullet Tracer'] = 'Traçador de balas',
    ['Tracer Style'] = 'Estilo do traçador',
    ['Tracer Thickness'] = 'Espessura do traçador',
    ['Tracer Lifetime'] = 'Duração do traçador',
    ['Triggerbot'] = 'Triggerbot',
    ['Enabled'] = 'Ativado',
    ['Gun Mods'] = 'Modificações de armas',
    ['No Spread'] = 'Sem dispersão',
    ['No Gun Bob'] = 'Sem balanço da arma',
    ['Instant Aim'] = 'Mira instantânea',
    ['Force Auto'] = 'Forçar automático',
    ['Rapid Fire'] = 'Tiro rápido',
    ['Rapid Fire Delay'] = 'Atraso do tiro rápido',
    ['No Recoil'] = 'Sem recuo',
    ['Instant Mag Refill'] = 'Recarregar carregador instantaneamente',
    ['Anti Aim'] = 'Anti-mira',
    ['Mode'] = 'Modo',
    ['Yaw Offset'] = 'Deslocamento Yaw',
    ['Pitch Tilt'] = 'Inclinação Pitch',
    ['Fake Lag'] = 'Lag falso',
    ['Fake Lag Interval'] = 'Intervalo do lag falso',
    ['Resolve Desync'] = 'Resolver desync',
    ['Visualize Server Pos'] = 'Visualizar posição do servidor',
    ['Visualize Transparency'] = 'Transparência da visualização',
    ['Custom Offset'] = 'Deslocamento personalizado',
    ['Offset Radius'] = 'Raio do deslocamento',
    ['Floor Clip'] = 'Atravessar chão',
    ['Floor Clip Depth'] = 'Profundidade do chão',
    ['UG Resolver (Hold X)'] = 'Resolver UG (segure X)',
    ['UG Resolver Depth'] = 'Profundidade do UG',
    ['TP Kill'] = 'TP Kill',
    ['Show Charge Bar'] = 'Mostrar barra de carga',
    ['Height Offset'] = 'Deslocamento de altura',
    ['Auto Look At Target'] = 'Olhar automaticamente para o alvo',
    ['Auto Triggerbot'] = 'Triggerbot automático',
    ['Instant Equip'] = 'Equipamento instantâneo',
    ['Auto Shoot Packet'] = 'Disparo automático por pacote',
    ['Packet Prediction'] = 'Previsão de pacote',
    ['Hitscan'] = 'Hitscan',
    ['Hitscan Walls'] = 'Hitscan através de paredes',
    ['Shoot Speed Mult'] = 'Multiplicador de velocidade de tiro',
    ['Target Info'] = 'Informações do alvo',
    ['Target Info Size'] = 'Tamanho das informações',
    ['Target Info Fixed'] = 'Fixar informações do alvo',
    ['Shoot On Manipulated'] = 'Atirar em manipulado',
    ['Instant Mosin (R7)'] = 'Mosin instantâneo (R7)',
    ['Custom Gun Sound'] = 'Som de arma personalizado',
    ['Custom Hit Sound'] = 'Som de acerto personalizado',
    ['Custom Sounds'] = 'Sons personalizados',
    ['Gun Sound'] = 'Som da arma',
    ['Gun Volume'] = 'Volume da arma',
    ['Hit Sound'] = 'Som de acerto',
    ['Hit Volume'] = 'Volume do acerto',
    ['Test Gun Sound'] = 'Testar som de arma',
    ['Test Hit Sound'] = 'Testar som de acerto',
    ['Hit/Kill Effect'] = 'Efeito de acerto/abate',
    ['Hit Effect Stars'] = 'Estrelas do efeito de acerto',
    ['No Screen Effects'] = 'Sem efeitos de tela',
    ['Remove Muzzle Flash'] = 'Remover clarão do disparo',
    ['FOV Override'] = 'Substituir FOV',
    ['Zoom'] = 'Zoom',
    ['Zoom Size'] = 'Tamanho do zoom',
    ['Freecam'] = 'Câmera livre',
    ['Speedhack'] = 'Hack de velocidade',
    ['Third Person'] = 'Terceira pessoa',
    ['3P Distance'] = 'Distância da 3ª pessoa',
    ['No Fall Damage'] = 'Sem dano de queda',
    ['Run On Water'] = 'Correr na água',
    ['Remove Mines'] = 'Remover minas',
    ['Fly Hack'] = 'Hack de voo',
    ['Y Speed'] = 'Velocidade Y',
    ['Unlock All Skins'] = 'Desbloquear todas as skins',
    ['Skins'] = 'Skins',
    ['Arm Chams'] = 'Chams dos braços',
    ['Arm Material'] = 'Material dos braços',
    ['Gun Chams'] = 'Chams da arma',
    ['Gun Material'] = 'Material da arma',
    ['X Offset'] = 'Deslocamento X',
    ['Y Offset'] = 'Deslocamento Y',
    ['Z Offset'] = 'Deslocamento Z',
    ['Inventory'] = 'Inventário',
    ['Item Finder'] = 'Localizador de itens',
    ['Inventory Checker'] = 'Verificador de inventário',
    ['Show Full Inventory'] = 'Mostrar inventário completo',
    ['Show Value'] = 'Mostrar valor',
    ['Check Corpse'] = 'Verificar cadáver',
    ['Enable Dragging'] = 'Permitir arrastar',
    ['Size'] = 'Tamanho',
    ['Items To Find'] = 'Itens para encontrar',
    ['Enable Item Finder'] = 'Ativar localizador de itens',
    ['Glow Size'] = 'Tamanho do brilho',
    ['Time Changer'] = 'Alterar horário',
    ['Time'] = 'Horário',
    ['Ambient'] = 'Ambiente',
    ['No Fog'] = 'Sem neblina',
    ['No Grass'] = 'Sem grama',
    ['No Clouds'] = 'Sem nuvens',
    ['Custom Skybox'] = 'Céu personalizado',
    ['No Shadows'] = 'Sem sombras',
    ['No Leafs'] = 'Sem folhas',
    ['Extreme Potato Mode'] = 'Modo batata extremo',
    ['Show Extractions'] = 'Mostrar extrações',
    ['Show Cars'] = 'Mostrar carros',
    ['Hit Logs'] = 'Registros de acertos',
    ['Speed'] = 'Velocidade',
    ['Radius'] = 'Raio',
    ['Thickness'] = 'Espessura',
    ['Gap'] = 'Espaço',
    ['Crosshair'] = 'Mira',
    ['MainScale'] = 'Escala principal',
    ['Finder X Position'] = 'Posição X do localizador',
    ['Finder Y Position'] = 'Posição Y do localizador',
    ['Text Size'] = 'Tamanho do texto',
    ['Y Position'] = 'Posição Y',
}

local function ApplyLanguage()
    local root = Library.Holder and Library.Holder.Instance
    if not root then return end

    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            local original = obj:GetAttribute("KnOriginalText")
            if original == nil then
                original = obj.Text
                pcall(function() obj:SetAttribute("KnOriginalText", original) end)
            end
            local translated = LanguageMap[Language][original] or (Language == "Portuguese" and PortugueseExtra[original])
            if translated then
                obj.Text = translated
            else
                obj.Text = original
            end
        end
    end
end

local function SaveLanguagePreference(value)
    Language = value
    pcall(function()
        if makefolder and not isfolder("tomboy.hook") then
            makefolder("tomboy.hook")
        end
    end)
    pcall(function()
        writefile(LanguageFile, HttpService:JSONEncode({Language = value}))
    end)
end

LoadLanguagePreference()

local ConfigsSection = SettingsPage:Section({Name = "Configs", Side = 2}) do
            local ConfigName
            local ConfigSelected
            local AutoLoadSelected

            ConfigsSection:Dropdown({
                Name = "Language / Idioma",
                Flag = "Language",
                Multi = false,
                Items = {"English", "Portuguese"},
                Default = Language,
                Callback = function(Value)
                    if Value == "English" or Value == "Portuguese" then
                        SaveLanguagePreference(Value)
                        if Library.ApplyLanguage then Library.ApplyLanguage() else ApplyLanguage() end
                        Library:Notification(
                            Value == "Portuguese"
                                and "Idioma salvo. Execute novamente para aplicar as traduções."
                                or "Language saved. Re-execute to apply translations.",
                            5
                        )
                    end
                end
            })

            ConfigsSection:Dropdown({
                Name = "Global Font",
                Flag = "global_font",
                Options = Library:GetGlobalFontOptions(),
                Default = Library.FontName,
                Callback = function(Value)
                    Library:SetGlobalFont(Value)
                end
            })

            local ConfigsSearchbox = ConfigsSection:Dropdown({
                Name = "Profiles list",
                Flag = "Profiles list",
                Multi = false,
                Items = { },
                Callback = function(Value)
                    ConfigSelected = Value
                end
            })

            local AutoLoadStatus = ConfigsSection:Label("Set AutoLoad: None")

            local function update_autoload_status()
                local current = Library:GetAutoLoadConfig()
                AutoLoadSelected = current
                AutoLoadStatus:SetText("Set AutoLoad: " .. (current and (current .. ".json") or "None"))
            end

            local AutoLoadDropdown = ConfigsSection:Dropdown({
                Name = "Auto Load Config",
                Flag = "AutoLoadConfig",
                Multi = false,
                Items = { },
                Callback = function(Value)
                    AutoLoadSelected = Value
                    if Value and Value ~= "" then
                        if Library:SetAutoLoadConfig(Value) then
                            update_autoload_status()
                            Library:Notification("Auto Load set to " .. Value .. ".json", 4)
                        end
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Clear Auto Config",
                Callback = function()
                    Library:ClearAutoLoadConfig()
                    AutoLoadSelected = nil
                    update_autoload_status()
                    Library:Notification("Auto Load config cleared", 4)
                end
            })

            ConfigsSection:Textbox({
                Name = "Config name",
                Default = "",
                Flag = "ConfigName",
                Placeholder = "...",
                Callback = function(Value)
                    ConfigName = Value
                end
            })

            ConfigsSection:Button({
                Name = "Create",
                Callback = function()
                    if ConfigName ~= "" then
                        local path = Library.Folders.Configs .. "/" .. ConfigName .. ".json"
                        if not isfile(path) then
                            writefile(path, Library:GetConfig())
                            Library:RefreshConfigsList(ConfigsSearchbox)
                            Library:Notification("Created config " .. ConfigName .. ".json", 5)
                        else
                            Library:Notification("Config already exists. Use Overwrite.", 5)
                        end
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Delete",
                Callback = function()
                    if ConfigSelected ~= nil then
                        local deleting = ConfigSelected
                        delfile(Library.Folders.Configs .. "/" .. deleting .. ".json")
                        if Library:GetAutoLoadConfig() == deleting then
                            Library:ClearAutoLoadConfig()
                            AutoLoadSelected = nil
                            update_autoload_status()
                        end
                        Library:RefreshConfigsList(ConfigsSearchbox)
                        local names = {}
                        for _, file in ipairs(listfiles(Library.Folders.Configs)) do
                            if file:sub(-5) == ".json" then
                                local pos = file:find(".json", 1, true)
                                local p2 = pos
                                local ch = file:sub(p2, p2)
                                while ch ~= "/" and ch ~= "\\" and ch ~= "" do
                                    p2 = p2 - 1
                                    ch = file:sub(p2, p2)
                                end
                                if ch == "/" or ch == "\\" then
                                    table.insert(names, file:sub(p2 + 1, pos - 1))
                                end
                            end
                        end
                        AutoLoadDropdown:Refresh(names)
                        Library:Notification("Deleted config " .. deleting .. ".json", 5, FromRGB(255, 0, 0))
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Load",
                Callback = function()
                    if ConfigSelected ~= nil then
                        local Success, Result = Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json"))
                        if Success then
                            Library:Notification("Loaded config " .. ConfigSelected .. ".json", 5)
                        else
                            Library:Notification("Failed to load config " .. ConfigSelected .. ".json", 5)
                        end
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Overwrite",
                Callback = function()
                    if ConfigSelected ~= nil then
                        writefile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json", Library:GetConfig())
                        Library:Notification("Overwrote config " .. ConfigSelected .. ".json", 5)
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Refresh",
                Callback = function()
                    Library:RefreshConfigsList(ConfigsSearchbox)

                    local names = {}
                    for _, file in ipairs(listfiles(Library.Folders.Configs)) do
                        if file:sub(-5) == ".json" then
                            local pos = file:find(".json", 1, true)
                            local p2 = pos
                            local ch = file:sub(p2, p2)
                            while ch ~= "/" and ch ~= "\\" and ch ~= "" do
                                p2 = p2 - 1
                                ch = file:sub(p2, p2)
                            end
                            if ch == "/" or ch == "\\" then
                                table.insert(names, file:sub(p2 + 1, pos - 1))
                            end
                        end
                    end
                    AutoLoadDropdown:Refresh(names)

                    update_autoload_status()
                end
            })

            -- Populate both config selectors from the same saved .json files.
            local function refresh_config_dropdowns()
                Library:RefreshConfigsList(ConfigsSearchbox)

                local names = {}
                for _, file in ipairs(listfiles(Library.Folders.Configs)) do
                    if file:sub(-5) == ".json" then
                        local pos = file:find(".json", 1, true)
                        local p2 = pos
                        local ch = file:sub(p2, p2)
                        while ch ~= "/" and ch ~= "\\" and ch ~= "" do
                            p2 = p2 - 1
                            ch = file:sub(p2, p2)
                        end
                        if ch == "/" or ch == "\\" then
                            table.insert(names, file:sub(p2 + 1, pos - 1))
                        end
                    end
                end
                AutoLoadDropdown:Refresh(names)
            end

            refresh_config_dropdowns()
            update_autoload_status()
        end

        local ThemingSection = SettingsPage:Section({Name = "Theming", Side = 2}) do
            for Index, Value in Library.Theme do 
                ThemingSection:Label(Index):Colorpicker({
                    Flag = Index,
                    Default = Value,
                    Callback = function(Value)
                        Library.Theme[Index] = Value
                        Library:ChangeTheme(Index, Value)
                    end
                })
            end
        end
        ApplyLanguage()
        Library.ApplyLanguage = ApplyLanguage
        return SettingsPage
    end
end
return Library
end)()
Library = getgenv().__tbhook_lib
getgenv().__tbhook_lib = nil
if Library == nil then
    warn("[tomboy.hook] Library init failed")
    return
end


task.wait(0.1)

local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService        = cloneref(game:GetService("RunService"))
local Lighting          = cloneref(game:GetService("Lighting"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local GuiInset = cloneref(game:GetService("GuiService")):GetGuiInset()
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local _CFramenew = CFrame.new
local _Vector2new = Vector2.new
local _Vector3new = Vector3.new
local _IsDescendantOf = game.IsDescendantOf
local _FindFirstChild = game.FindFirstChild
local _FindFirstChildOfClass = game.FindFirstChildOfClass
local _Raycast = workspace.Raycast
local _IsKeyDown = UserInputService.IsKeyDown
local _WorldToViewportPoint = Camera.WorldToViewportPoint
local _Vector3zeromin = Vector3.zero.Min
local _Vector2zeromin = Vector2.zero.Min
local _Vector3zeromax = Vector3.zero.Max
local _Vector2zeromax = Vector2.zero.Max
local _IsA = game.IsA
local tablecreate = table.create
local mathfloor = math.floor
local mathround = math.round
local tostring = tostring
local unpack = unpack
local getupvalues = debug.getupvalues
local getupvalue = debug.getupvalue
local setupvalue = debug.setupvalue
local getconstants = debug.getconstants
local getconstant = debug.getconstant
local setconstant = debug.setconstant
local getstack = debug.getstack
local setstack = debug.setstack
local getinfo = debug.getinfo
local rawget = rawget
local cheat = {
    connections = {
        heartbeats = {},
        renderstepped = {}
    },
    drawings = {},
    hooks = {},
}
cheat.utility = {} do
    cheat.utility.new_heartbeat = function(func)
        local obj = {}
        cheat.connections.heartbeats[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.heartbeats[func] = nil
                func = nil
            end
        end
        return obj
    end
    cheat.utility.new_renderstepped = function(func)
        local obj = {}
        cheat.connections.renderstepped[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.renderstepped[func] = nil
                func = nil
            end
        end
        return obj
    end
    
    local vischeck_params = RaycastParams.new()
    vischeck_params.FilterType = Enum.RaycastFilterType.Exclude
    vischeck_params.CollisionGroup = "WeaponRay"
    vischeck_params.IgnoreWater = true

    cheat.utility.is_visible = function(cframe, target, target_part)
        if not (target and target_part and cframe) then return false end
        local char = LocalPlayer.Character
        if char ~= cheat.utility._last_vis_char then
            cheat.utility._last_vis_char = char
            vischeck_params.FilterDescendantsInstances = { Workspace.NoCollision, Camera, char }
        end
        local castresults = Workspace:Raycast(cframe.p, target_part.Position - cframe.p, vischeck_params)
        if not castresults then return true end
        if castresults and castresults.Instance then
            if target_part and castresults.Instance == target_part then return true end
            return castresults.Instance:IsDescendantOf(target)
        end
        return false
    end
    
    cheat.utility.spawn_kill_effect = function(pos)
        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 1
        part.Position = pos
        part.Parent = workspace.Terrain
        
        local emit = Instance.new("ParticleEmitter")
        emit.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        emit.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 0)})
        emit.Color = ColorSequence.new(Color3.new(1, 1, 1))
        emit.LightEmission = 1
        emit.LightInfluence = 0
        emit.ZOffset = 1
        emit.Lifetime = NumberRange.new(1, 2)
        emit.Rate = 0
        emit.Speed = NumberRange.new(15, 40)
        emit.SpreadAngle = Vector2.new(360, 360)
        emit.Drag = 2
        emit.Parent = part
        
        local amount = Library.Flags.killeffect_amount or 100
        emit:Emit(amount)
        
        game:GetService("Debris"):AddItem(part, 3)
    end
    
    cheat.utility.world_to_screen = function(world)
        local screen, inBounds = Camera:WorldToViewportPoint(world)
        return Vector2.new(screen.X, screen.Y), inBounds, screen.Z
    end
    cheat.utility.new_drawing = function(drawobj, args)
        local obj = Drawing.new(drawobj)
        for i, v in pairs(args) do
            obj[i] = v
        end
        if drawobj == "Text" and Library.DrawingFont then
            obj.Font = Library.DrawingFont
        end
        cheat.drawings[obj] = obj
        return obj
    end
    cheat.utility.new_hook = function(f, newf, usecclosure) LPH_NO_VIRTUALIZE(function()
        if usecclosure then
            local old; old = hookfunction(f, newcclosure(function(...)
                return newf(old, ...)
            end))
            cheat.hooks[f] = old
            return old
        else
            local old; old = hookfunction(f, function(...)
                return newf(old, ...)
            end)
            cheat.hooks[f] = old
            return old
        end
    end)() end
    local connection; connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.heartbeats) do
            pcall(func, delta)
        end
    end))
    local connection1; connection1 = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.renderstepped) do
            func(delta)
        end
    end))
    cheat.utility.unload = function()
        connection:Disconnect()
        connection1:Disconnect()
        for key, _ in pairs(cheat.connections.heartbeats) do
            cheat.connections.heartbeats[key] = nil
        end
        for key, _ in pairs(cheat.connections.renderstepped) do
            cheat.connections.renderstepped[key] = nil
        end
        local to_remove = {}
        for k in pairs(cheat.drawings) do to_remove[#to_remove+1] = k end
        for _, k in ipairs(to_remove) do cheat.drawings[k]:Remove(); cheat.drawings[k] = nil end
        for hooked, original in pairs(cheat.hooks) do
            if type(original) == "function" then
                hookfunction(hooked, clonefunction(original))
            else
                hookmetamethod(original["instance"], original["metamethod"], clonefunction(original["func"]))
            end
        end
    end
end
task.wait()
cheat.EspLibrary = {} LPH_NO_VIRTUALIZE(function()
    local esp_table = {}
    local workspace = cloneref(Workspace)
    local plrs = cloneref(Players)
    local lplr = plrs.LocalPlayer
    local success, coregui = pcall(game.GetService, game, "CoreGui")
    local container = Instance.new("Folder", (success and coregui:FindFirstChild("RobloxGui")) or lplr:WaitForChild("PlayerGui", 2) or lplr)
    esp_table = {
        __loaded = false,
        main_settings = {
            textSize = 14,
            textFont = Drawing.Fonts.Monospace,
            distancelimit = true,
            maxdistance = 1200,
            fadetime = 1,
            infiniterange = false
        },
        main_object_settings = {
            textSize = 15,
            textFont = Drawing.Fonts.Monospace,
            distancelimit = false,
            maxdistance = 200,
            useteamcolor = false,
            teamcheck = false,
            sleepcheck = false,
            allowed = {}
        },
        settings = {
            enemy = {
                enabled = false,
                box = false,
                box_fill = false,
                realname = false,
                health = false,
                dist = false,
                weapon = false,
                skeleton = false,
                health_outline = false,
                dist_outline = false,
                visible_check = true,
                outline = false,
                outline_visible_check = true,
                outline_color = { Color3.fromRGB(255, 255, 255), 1 },
                box_color = { Color3.new(1, 1, 1), 1 },
                box_fill_color = { Color3.new(1, 0, 0), 0.5 },
                realname_color = { Color3.new(1, 1, 1), 1 },
                health_color = { Color3.new(1, 1, 1), 1 },
                dist_color = { Color3.new(1, 1, 1), 1 },
                weapon_color = { Color3.new(1, 1, 1), 1 },
                skeleton_color = { Color3.new(1, 1, 1), 1 },
                health_color_top = Color3.new(0, 1, 0),
                health_color_bottom = Color3.new(1, 0, 0),
                health_thickness = 2,
                health_glow_size = 5,
                dist_outline_color = Color3.new(),
                chams = false,
                chams_visible_only = false,
                chams_fill_color        = { Color3.fromRGB(255, 255, 255), 0.7 },
                chamsoutline_color      = { Color3.fromRGB(255, 255, 255), 0 },
                chams_outline           = false,
                chams_material          = "Neon",
                chams_rainbow           = false,
                chams_pulse             = false,
                chams_health_reactive   = false,
                chams_visible_split     = false,
                chams_occluded_color    = { Color3.fromRGB(255, 50, 50), 0.5 },
                chams_outline_pulse     = false,
                chams_strobe            = false,
                chams_intensity         = 0.5,   -- 0=max opacity, 0.5=natural alpha, 1=invisible
                chams_saturation        = 1.0
            },
            corpse = {
                enabled = false,
                name = true,
                distance = false,
                color = Color3.fromRGB(190, 85, 0),
                outline = false,
                outline_color = Color3.new()
            }
        }
    }
    local loaded_plrs = {}
    local camera = workspace.CurrentCamera
    local viewportsize = camera.ViewportSize
    local VERTICES = {
        _Vector3new(-1, -1, -1),
        _Vector3new(-1, 1, -1),
        _Vector3new(-1, 1, 1),
        _Vector3new(-1, -1, 1),
        _Vector3new(1, -1, -1),
        _Vector3new(1, 1, -1),
        _Vector3new(1, 1, 1),
        _Vector3new(1, -1, 1)
    }
    local skeleton_order = {
        ["LeftFoot"] = "LeftLowerLeg",
        ["LeftLowerLeg"] = "LeftUpperLeg",
        ["LeftUpperLeg"] = "LowerTorso",
        ["RightFoot"] = "RightLowerLeg",
        ["RightLowerLeg"] = "RightUpperLeg",
        ["RightUpperLeg"] = "LowerTorso",
        ["LeftHand"] = "LeftLowerArm",
        ["LeftLowerArm"] = "LeftUpperArm",
        ["LeftUpperArm"] = "UpperTorso",
        ["RightHand"] = "RightLowerArm",
        ["RightLowerArm"] = "RightUpperArm",
        ["RightUpperArm"] = "UpperTorso",
        ["LowerTorso"] = "UpperTorso",
        ["UpperTorso"] = "Head"
    }
    local esp = {}
    esp.create_obj = function(type, args)
        local obj = Drawing.new(type)
        for i, v in args do
            obj[i] = v
        end
        return obj
    end
    local function isBodyPart(name)
        return name == "Head" or name:find("Torso") or name:find("Leg") or name:find("Arm") or name:find("Mi24") or name:find("Prop_") or name:find("Hull") or name:find("BTR") or name:find("Pilot")
    end
    local function getBoundingBox(parts)
        local min, max
        for i = 1, #parts do
            local part = parts[i]
            local cframe, size = part.CFrame, part.Size
            min = _Vector3zeromin(min or cframe.Position, (cframe - size * 0.5).Position)
            max = _Vector3zeromax(max or cframe.Position, (cframe + size * 0.5).Position)
        end
        local center = (min + max) * 0.5
        local front = _Vector3new(center.X, center.Y, max.Z)
        return _CFramenew(center, front), max - min
    end
    local function worldToScreen(world)
        local screen, inBounds = _WorldToViewportPoint(camera, world)
        return _Vector2new(screen.X, screen.Y), inBounds, screen.Z
    end
    local function calculateCorners(cframe, size)
        local corners = table.create(#VERTICES)
        for i = 1, #VERTICES do
            corners[i] = worldToScreen((cframe + size * 0.5 * VERTICES[i]).Position)
        end
        local min = _Vector2zeromin(camera.ViewportSize, unpack(corners))
        local max = _Vector2zeromax(Vector2.zero, unpack(corners))
        return {
            corners = corners,
            topLeft = _Vector2new(mathfloor(min.X), mathfloor(min.Y)),
            topRight = _Vector2new(mathfloor(max.X), mathfloor(min.Y)),
            bottomLeft = _Vector2new(mathfloor(min.X), mathfloor(max.Y)),
            bottomRight = _Vector2new(mathfloor(max.X), mathfloor(max.Y))
        }
    end
    local get_mainpart = function(model, modelname)
        if modelname == "corpse" then
            return _FindFirstChild(model, "UpperTorso")
        end
    end

    local esp_vis_params = RaycastParams.new()
    esp_vis_params.FilterType = Enum.RaycastFilterType.Exclude
    local function esp_is_visible(character)
        if not character or not camera then return false end
        local origin = camera.CFrame.Position
        local filter = {character, lplr.Character, camera}
        local nc = workspace:FindFirstChild("NoCollision")
        if nc then filter[#filter + 1] = nc end
        esp_vis_params.FilterDescendantsInstances = filter
        local candidates = {
            _FindFirstChild(character, "Head"),
            _FindFirstChild(character, "UpperTorso"),
            _FindFirstChild(character, "HumanoidRootPart")
        }
        for _, part in ipairs(candidates) do
            if part and part:IsA("BasePart") then
                local result = workspace:Raycast(origin, part.Position - origin, esp_vis_params)
                if not result or (result.Instance and result.Instance:IsDescendantOf(character)) then
                    return true
                end
            end
        end
        return false
    end
    local identify_model = function(model, modelname)
        if not model then return false, false end
        if modelname == "corpse" and _FindFirstChildOfClass(model, "Humanoid") then
            return model.Name.."'s corpse"
        end
        return false, false
    end
    local function create_esp(player, isnpc)
        if not player then return end
        if player.ClassName == "Model" then isnpc = true end
        loaded_plrs[player] = {
            obj = {
                box_fill = esp.create_obj("Square", { Filled = true, Visible = false }),
                box = esp.create_obj("Square", { Filled = false, Thickness = 1, Visible = false }),
                realname = esp.create_obj("Text", { Center = true, Visible = false, Text = player.Name }),
                healthtext = esp.create_obj("Text", { Center = false, Visible = false }),
                health_bar_cap_top = esp.create_obj("Circle", { Visible = false, Filled = true, ZIndex = 2 }),
                health_bar_cap_bottom = esp.create_obj("Circle", { Visible = false, Filled = true, ZIndex = 2 }),
                dist = esp.create_obj("Text", { Center = true, Visible = false }),
                weapon = esp.create_obj("Text", { Center = true, Visible = false }),
            },
            chams_object = Instance.new("Highlight", container),
            outline_object = Instance.new("Highlight", container),
            chams_active = false,
            chams_original = {},
            last_chams_update = 0,
            plr_instance = player
        }
        for required, _ in next, skeleton_order do
            loaded_plrs[player].obj["skeleton_" .. required] = esp.create_obj("Line", { Visible = false })
        end
        for i = 1, 10 do
            loaded_plrs[player].obj["health_bar_" .. i] = esp.create_obj("Line", { Visible = false, Thickness = 2, ZIndex = 2 })
        end
        for i = 1, 6 do
            loaded_plrs[player].obj["health_bar_glow_" .. i] = esp.create_obj("Line", { Visible = false, ZIndex = 1 })
            loaded_plrs[player].obj["health_bar_glow_cap_top_" .. i] = esp.create_obj("Circle", { Visible = false, Filled = true, ZIndex = 1 })
            loaded_plrs[player].obj["health_bar_glow_cap_bottom_" .. i] = esp.create_obj("Circle", { Visible = false, Filled = true, ZIndex = 1 })
        end
        local plr = loaded_plrs[player]
        local obj = plr.obj
        local esp = plr.esp
        local box = obj.box
        local box_fill = obj.box_fill
        local healthtext = obj.healthtext
        local realname = obj.realname
        local dist = obj.dist
        local weapon = obj.weapon
        local cham = plr.chams_object
        local outline = plr.outline_object
        local cham_original = plr.chams_original
        local settings = esp_table.settings.enemy
        local main_settings = esp_table.main_settings
        local character = isnpc and player or not isnpc and player.Character
        local head = character and _FindFirstChild(character, "Head")
        local humanoid = character and _FindFirstChildOfClass(character, "Humanoid")
        local setvis_cache = false
        local fadetime = main_settings.fadetime
        local fadethread
        function plr:update_visible_state()
            -- Recalculate line-of-sight continuously so Visible Check never becomes stale.
            plr._esp_visible = settings.visible_check and esp_is_visible(character) or false
            local _esp_green = Color3.fromRGB(0, 255, 0)
            local _team_blue = Color3.fromRGB(60, 150, 255)
            local _is_team = (not isnpc) and silent_aim and silent_aim.native_whitelist and silent_aim.native_whitelist[player.Name] or false
            if not _is_team and (not isnpc) and silent_aim and silent_aim.whitelist_mode and silent_aim.whitelist then
                _is_team = silent_aim.whitelist[player.Name] == true
            end
            local _esp_color = _is_team and _team_blue or (plr._esp_visible and _esp_green or nil)
            box.Color = _esp_color or settings.box_color[1]
            box_fill.Color = _esp_color or settings.box_fill_color[1]
            realname.Color = _esp_color or settings.realname_color[1]
            dist.Color = _esp_color or settings.dist_color[1]
            weapon.Color = _esp_color or settings.weapon_color[1]
            outline.OutlineColor = _esp_color or settings.outline_color[1]
            for required, _ in next, skeleton_order do
                local skeletonobj = obj["skeleton_" .. required]
                if skeletonobj then
                    skeletonobj.Color = _esp_color or settings.skeleton_color[1]
                end
            end
        end

        function plr:forceupdate()
            fadetime = main_settings.fadetime
            local isWireframe = settings.chams_material == "Wireframe"
            local _esp_green = Color3.fromRGB(0, 255, 0)
            plr:update_visible_state()
            cham.DepthMode = settings.chams_visible_only and 1 or 0
            cham.FillColor = settings.chams_fill_color[1]
            cham.FillTransparency = isWireframe and 1 or settings.chams_fill_color[2]
            cham.OutlineColor = settings.chamsoutline_color[1]
            cham.OutlineTransparency = settings.chams_outline and settings.chamsoutline_color[2] or 1
            outline.Adornee = character
            outline.FillTransparency = 1
            outline.OutlineTransparency = settings.outline and settings.outline_color[2] or 1
            outline.DepthMode = settings.outline_visible_check and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
            realname.Size = main_settings.textSize
            realname.Font = main_settings.textFont
            realname.Outline = settings.dist_outline
            realname.OutlineColor = settings.dist_outline_color
            dist.Size = main_settings.textSize
            dist.Font = main_settings.textFont
            dist.Outline = settings.dist_outline
            dist.OutlineColor = settings.dist_outline_color
            weapon.Size = main_settings.textSize
            weapon.Font = main_settings.textFont
            weapon.Outline = settings.dist_outline
            weapon.OutlineColor = settings.dist_outline_color
            box.Transparency = settings.box_color[2]
            box_fill.Transparency = settings.box_fill_color[2]
            realname.Transparency = settings.realname_color[2]
            dist.Transparency = settings.dist_color[2]
            weapon.Transparency = settings.weapon_color[2]
            for required, _ in next, skeleton_order do
                obj["skeleton_" .. required].Transparency = settings.skeleton_color[2]
            end

            for i = 1, 10 do
                if obj["health_bar_"..i] then
                    obj["health_bar_"..i].Thickness = settings.health_thickness
                end
            end
            if setvis_cache then
                cham.Enabled = settings.chams
                outline.Enabled = settings.outline
                box.Visible = settings.box
                box_fill.Visible = settings.box_fill
                realname.Visible = settings.realname
                obj.health_bar_cap_top.Visible = settings.health
                obj.health_bar_cap_bottom.Visible = settings.health
                for i = 1, 6 do
                    if obj["health_bar_glow_"..i] then
                        obj["health_bar_glow_"..i].Visible = settings.health
                        obj["health_bar_glow_cap_top_"..i].Visible = settings.health
                        obj["health_bar_glow_cap_bottom_"..i].Visible = settings.health
                    end
                end
                for i = 1, 10 do
                    if obj["health_bar_"..i] then
                        obj["health_bar_"..i].Visible = settings.health
                    end
                end
                dist.Visible = settings.dist
                weapon.Visible = settings.weapon
                for required, _ in next, skeleton_order do
                    local skeletonobj = obj["skeleton_" .. required]
                    if (skeletonobj) then
                        skeletonobj.Visible = settings.skeleton
                    end
                end
            end
        end
        function plr:togglevis(bool, fade)
            if setvis_cache ~= bool then
                setvis_cache = bool
                if not bool then
                        for _, v in obj do v.Visible = false end
                        cham.Enabled = false
                        outline.Enabled = false
                else
                    cham.Enabled = settings.chams
                    outline.Enabled = settings.outline
                    box.Visible = settings.box
                    box_fill.Visible = settings.box_fill
                    realname.Visible = settings.realname
                    healthtext.Visible = settings.health
                    obj.health_bar_cap_top.Visible = settings.health
                    obj.health_bar_cap_bottom.Visible = settings.health
                    for i = 1, 6 do
                        if obj["health_bar_glow_"..i] then 
                            obj["health_bar_glow_"..i].Visible = settings.health
                            obj["health_bar_glow_cap_top_"..i].Visible = settings.health
                            obj["health_bar_glow_cap_bottom_"..i].Visible = settings.health
                        end
                    end
                    for i = 1, 10 do
                        obj["health_bar_"..i].Visible = settings.health
                    end
                    dist.Visible = settings.dist
                    weapon.Visible = settings.weapon
                    for required, _ in next, skeleton_order do
                        local skeletonobj = obj["skeleton_" .. required]
                        if (skeletonobj) then
                            skeletonobj.Visible = settings.skeleton
                        end
                    end
                end
            end
        end
        plr.connection = cheat.utility.new_renderstepped(function(delta)
            local plr = loaded_plrs[player]
            if not settings.enabled then
                return plr:togglevis(false)
            end
            character = isnpc and player or not isnpc and player.Character
            humanoid = character and _FindFirstChildOfClass(character, "Humanoid")
            head = character and _FindFirstChild(character, "Head")


            -- Visible Check is a live state: refresh it every RenderStepped.
            if character and character.Parent then
                plr:update_visible_state()
            else
                plr._esp_visible = false
            end
            
            local is_heli = isnpc and (character.Name == "MI24V" or character.Name == "BTR80")
            if is_heli then
                local pilots = _FindFirstChild(character, "Pilots")
                head = character:FindFirstChild("CollisionPilot", true) or character:FindFirstChild("Mi24_Prop_M", true)
                humanoid = humanoid or { Health = character:GetAttribute("Health") or 1000, MaxHealth = 1000, Parent = character }
            end
            
            if not (character and head and humanoid and character.Parent and (head.Parent or is_heli) and (humanoid.Parent or is_heli)) then
                if main_settings.infiniterange and not isnpc then
                    local res = (function()
                        local rp_plr = _FindFirstChild(ReplicatedStorage.Players, player.Name)
                        local plrstatus = rp_plr and _FindFirstChild(rp_plr, "Status")
                        local worldpos = plrstatus and _FindFirstChild(plrstatus, "UAC") and _FindFirstChild(plrstatus, "UAC"):GetAttribute("LastVerifiedPos")
                        local screenpos, onscreen = typeof(worldpos) == "Vector3" and worldToScreen(worldpos)
                        if not (onscreen) then return false end
                        realname.Position = screenpos
                        realname.Text = player.Name .. " ["..mathround((worldpos - camera.CFrame.p).Magnitude / 3).."]"
                        return true
                    end)();
                    plr:togglevis(false)
                    realname.Visible = res
                    return
                else
                    realname.Visible = false
                    return plr:togglevis(false)
                end
            end
            local _, onScreen = _WorldToViewportPoint(camera, head.Position)
            if not onScreen then
                return plr:togglevis(false)
            end
            local humanoid_distance = (camera.CFrame.p - head.Position).Magnitude
            if main_settings.distancelimit and not main_settings.infiniterange and humanoid_distance > main_settings.maxdistance then
                return plr:togglevis(false)
            end
            local humanoid_health = humanoid.Health
            
            if plr.last_health and humanoid_health < plr.last_health then
                local hitmarker_recent = cheat.utility.last_hitmarker_tick and (tick() - cheat.utility.last_hitmarker_tick < 0.25)
                if hitmarker_recent and Library.Flags.killeffect then
                    cheat.utility.spawn_kill_effect(head.Position)
                end
            end
            plr.last_health = humanoid_health
            
            if humanoid_health <= 0 then
                if not plr.was_dead then
                    plr.was_dead = true
                end
                return plr:togglevis(false)
            else
                plr.was_dead = false
            end
            local humanoid_max_health = humanoid.MaxHealth
            local corners do
                if plr.last_character ~= character then
                    plr.last_character = character
                    plr.body_parts = {}
                    plr._skel_parts = nil
                    local check_descendants = isnpc and (character.Name == "MI24V" or character.Name == "BTR80")
                    local parts_to_check = check_descendants and character:GetDescendants() or character:GetChildren()
                    for _, part in parts_to_check do
                        if _IsA(part, "BasePart") and isBodyPart(part.Name) then
                            plr.body_parts[#plr.body_parts + 1] = part
                        end
                    end
                end
                local cache = plr.body_parts
                if not cache or #cache <= 0 then return plr:togglevis(false) end
                corners = calculateCorners(getBoundingBox(cache))
            end
            plr:togglevis(true)
            cham.Adornee = character
            
            
            do
                local pos = corners.topLeft
                local size = corners.bottomRight - corners.topLeft
                box.Position = pos
                box.Size = size
                box_fill.Position = pos
                box_fill.Size = size
            end
            do
                local min_healthbar_height = 5
                local healthbar_top_y = corners.topLeft.Y
                if (corners.bottomLeft.Y - corners.topLeft.Y) < min_healthbar_height then
                    healthbar_top_y = corners.bottomLeft.Y - min_healthbar_height
                end
                local top_text_y = math.min(corners.topLeft.Y, healthbar_top_y)
                
                local pos = _Vector2new((corners.topLeft.X + corners.topRight.X) * 0.5, top_text_y) - Vector2.yAxis
                realname.Position = pos - (Vector2.yAxis * realname.TextBounds.Y) - _Vector2new(0, 2)
                local _team_mark = (not isnpc) and silent_aim and ((silent_aim.native_whitelist and silent_aim.native_whitelist[player.Name]) or (silent_aim.whitelist_mode and silent_aim.whitelist and silent_aim.whitelist[player.Name]))
                realname.Text = isnpc and ("BOT | " .. player.Name) or (player.Name .. (_team_mark and " [TEAM]" or ""))
                realname.OutlineColor = settings.dist_outline_color
            end
            do
                local pos = (corners.bottomLeft + corners.bottomRight) * 0.5
                dist.Text = mathround(humanoid_distance / 3) .. "m"
                -- Put distance slightly below the bottom of the character/box.
                dist.Position = pos + _Vector2new(0, 8)
                local _cl = os.clock()
                if not plr._gun_cache_time or (_cl - plr._gun_cache_time) > 0.5 then
                    plr._gun_cache_time = _cl
                    plr._gun_cache_text = isnpc and "" or esp_table.get_gun(player)
                end
                weapon.Text = plr._gun_cache_text or ""
                weapon.Position = pos + Vector2.yAxis * (dist.TextBounds.Y + 10)
                
                dist.OutlineColor = settings.dist_outline_color
                weapon.OutlineColor = settings.dist_outline_color
            end
            -- Neon Gradient Health Bar + numeric health text
            local h_percent = math.clamp(humanoid_health / humanoid_max_health, 0, 1)
            local bar_start = corners.bottomLeft - _Vector2new(6, 0)
            local bar_end = corners.topLeft - _Vector2new(6, 0)

            healthtext.Visible = settings.health
            healthtext.Text = math.floor(math.max(0, humanoid_health)) .. "/" .. math.floor(math.max(1, humanoid_max_health))

            -- Keep the health number visually tied to the projected health-bar
            -- size: close targets get larger text, distant targets get smaller text.
            local projected_bar_height = math.max(5, math.abs(bar_start.Y - bar_end.Y))
            healthtext.Size = math.clamp(projected_bar_height * 0.12, 8, 24)
            healthtext.Position = bar_start - _Vector2new(healthtext.TextBounds.X + 5, healthtext.TextBounds.Y * 0.5)
            healthtext.Color = plr._esp_visible and _esp_green or settings.health_color_top:Lerp(settings.health_color_bottom, 1 - h_percent)
            healthtext.OutlineColor = settings.dist_outline_color
            
            local min_healthbar_height = 5
            if (bar_start.Y - bar_end.Y) < min_healthbar_height then
                bar_end = bar_start - _Vector2new(0, min_healthbar_height)
            end
            
            local glow_color = settings.health_color_top:Lerp(settings.health_color_bottom, 0.5)
            
            for i = 1, 6 do
                local glow = obj["health_bar_glow_"..i]
                local cap_top = obj["health_bar_glow_cap_top_"..i]
                local cap_bottom = obj["health_bar_glow_cap_bottom_"..i]
                
                if settings.health and h_percent > 0 then
                    local th = (i / 6) * settings.health_glow_size
                    local tr = 0.3 - (i * 0.04)
                    
                    glow.Visible = true
                    glow.From = bar_start
                    glow.To = bar_start:Lerp(bar_end, h_percent)
                    glow.Color = plr._esp_visible and _esp_green or glow_color
                    glow.Thickness = th
                    glow.Transparency = tr
                    
                    cap_top.Visible = true
                    cap_top.Position = bar_start:Lerp(bar_end, h_percent)
                    cap_top.Color = plr._esp_visible and _esp_green or glow_color
                    cap_top.Radius = th / 2
                    cap_top.Transparency = tr
                    
                    cap_bottom.Visible = true
                    cap_bottom.Position = bar_start
                    cap_bottom.Color = plr._esp_visible and _esp_green or glow_color
                    cap_bottom.Radius = th / 2
                    cap_bottom.Transparency = tr
                else
                    glow.Visible = false
                    cap_top.Visible = false
                    cap_bottom.Visible = false
                end
            end
            
            if settings.health and h_percent > 0 then
                obj.health_bar_cap_top.Visible = true
                obj.health_bar_cap_top.Position = bar_start:Lerp(bar_end, h_percent)
                obj.health_bar_cap_top.Color = plr._esp_visible and _esp_green or settings.health_color_top:Lerp(settings.health_color_bottom, 1 - h_percent)
                obj.health_bar_cap_top.Radius = settings.health_thickness / 2

                obj.health_bar_cap_bottom.Visible = true
                obj.health_bar_cap_bottom.Position = bar_start
                obj.health_bar_cap_bottom.Color = plr._esp_visible and _esp_green or settings.health_color_bottom
                obj.health_bar_cap_bottom.Radius = settings.health_thickness / 2
            else
                obj.health_bar_cap_top.Visible = false
                obj.health_bar_cap_bottom.Visible = false
            end
            
            for i = 1, 10 do
                local seg_line = obj["health_bar_"..i]
                if settings.health and i <= math.ceil(h_percent * 10) then
                    seg_line.Visible = true
                    local seg_start = bar_start:Lerp(bar_end, (i - 1) / 10)
                    local seg_end = bar_start:Lerp(bar_end, i / 10)
                    if i == math.ceil(h_percent * 10) then
                        seg_end = bar_start:Lerp(bar_end, h_percent)
                    end
                    seg_line.From = seg_start
                    seg_line.To = seg_end
                    local col_percent = 1 - (i / 10)
                    seg_line.Color = plr._esp_visible and _esp_green or settings.health_color_top:Lerp(settings.health_color_bottom, col_percent)
                else
                    seg_line.Visible = false
                end
            end
            if settings.skeleton then
                if not plr._skel_parts then
                    plr._skel_parts = {}
                    for _, part in next, character:GetChildren() do
                        local parent_name = skeleton_order[part.Name]
                        if parent_name then
                            local parent_instance = _FindFirstChild(character, parent_name)
                            local line = obj["skeleton_" .. part.Name]
                            if parent_instance and line then
                                plr._skel_parts[#plr._skel_parts + 1] = { part = part, parent = parent_instance, line = line }
                            end
                        end
                    end
                end
                for i = 1, #plr._skel_parts do
                    local entry = plr._skel_parts[i]
                    if entry.part.Parent and entry.parent.Parent then
                        local part_position = _WorldToViewportPoint(camera, entry.part.Position)
                        local parent_part_position = _WorldToViewportPoint(camera, entry.parent.Position)
                        entry.line.From = _Vector2new(part_position.X, part_position.Y)
                        entry.line.To = _Vector2new(parent_part_position.X, parent_part_position.Y)
                    end
                end
            end
            cham.Adornee = character
            cham.Enabled = settings.chams
            if settings.chams then
                -- Depth mode: split overrides visible-only
                if settings.chams_visible_split then
                    cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                else
                    cham.DepthMode = settings.chams_visible_only
                        and Enum.HighlightDepthMode.Occluded
                        or  Enum.HighlightDepthMode.AlwaysOnTop
                end

                -- intensity 0-1: 0=fully opaque, 0.5=natural configured alpha, 1=invisible
                local _int_off = (math.clamp(settings.chams_intensity or 0.5, 0, 1) - 0.5) * 2

                -- Fill color priority: health-reactive -> visible-split -> team-color -> standard
                -- (rainbow + pulse are handled per-frame in CrazyChamsRS)
                if settings.chams_health_reactive and not settings.chams_rainbow then
                    local hp_pct = math.clamp(humanoid_health / math.max(humanoid_max_health, 1), 0, 1)
                    local sat = math.clamp(settings.chams_saturation or 1, 0, 1)
                    cham.FillColor        = Color3.fromHSV(hp_pct * (1/3), sat, 1)
                    cham.FillTransparency = math.clamp(settings.chams_fill_color[2] + _int_off, 0, 0.99)
                elseif settings.chams_visible_split then
                    local is_vis = silent_aim and silent_aim.isvisible or false
                    if is_vis then
                        cham.FillColor        = settings.chams_fill_color[1]
                        cham.FillTransparency = math.clamp(settings.chams_fill_color[2] + _int_off, 0, 0.99)
                    else
                        cham.FillColor        = settings.chams_occluded_color[1]
                        cham.FillTransparency = math.clamp(settings.chams_occluded_color[2] + _int_off, 0, 0.99)
                    end
                elseif not settings.chams_rainbow and not settings.chams_pulse then
                    cham.FillColor        = settings.chams_fill_color[1]
                    cham.FillTransparency = math.clamp(settings.chams_fill_color[2] + _int_off, 0, 0.99)
                end

                -- Outline (CrazyChamsRS handles outline_pulse; set base values here)
                cham.OutlineColor        = settings.chamsoutline_color[1]
                cham.OutlineTransparency = settings.chams_outline
                    and math.clamp(settings.chamsoutline_color[2] + _int_off, 0, 0.99)
                    or 1

                -- Material pass (throttled 0.5s)
                if tick() - plr.last_chams_update >= 0.5 then
                    plr.chams_active = true
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if not cham_original[part] then
                                cham_original[part] = { Material = part.Material, Color = part.Color, Transparency = part.Transparency }
                            end
                            if settings.chams_material == "Wireframe" then
                                part.Transparency = 0.99
                            elseif settings.chams_material == "Neon" then
                                part.Material    = Enum.Material.SmoothPlastic
                                part.Color       = settings.chams_fill_color[1]
                                part.Transparency = 0.5
                            else
                                part.Material    = Enum.Material[settings.chams_material or "Neon"]
                                part.Color       = settings.chams_fill_color[1]
                                part.Transparency = 0
                            end
                            local sa = part:FindFirstChildOfClass("SurfaceAppearance")
                            if sa then sa:Destroy() end
                        end
                    end
                    plr.last_chams_update = tick()
                end
            elseif plr.chams_active then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and cham_original[part] then
                        part.Material    = cham_original[part].Material
                        part.Color       = cham_original[part].Color
                        part.Transparency= cham_original[part].Transparency
                        cham_original[part] = nil
                    end
                end
                plr.chams_active      = false
                plr.last_chams_update = 0
            end
        end)
        plr:forceupdate()
    end
    local function create_object_esp(model, modelname)
        if not model then return end
        local espname = identify_model(model, modelname)
        if not (espname) then return end
        loaded_plrs[model] = {
            obj = {
                name = esp.create_obj("Text", { Center = true, Visible = false, Text = espname }),
            }
        }
        local plr = loaded_plrs[model]
        local obj = plr.obj
        local realname = obj.name
        
        local main_settings = esp_table.main_settings
        local enemy_settings = esp_table.settings.enemy
        local corpse_settings = esp_table.settings.corpse
        
        local setvis_cache = false
        function plr:forceupdate()
            realname.Size = main_settings.textSize
            realname.Font = main_settings.textFont
            realname.Color = corpse_settings.color
            realname.Outline = corpse_settings.outline
            realname.OutlineColor = corpse_settings.outline_color
            realname.Transparency = 1
        end
        function plr:togglevis(bool)
            if setvis_cache ~= bool then
                for _, v in obj do v.Visible = bool end
                setvis_cache = bool
            end
        end
        plr.connection = cheat.utility.new_heartbeat(function(delta)
            local plr = loaded_plrs[model]
            if not corpse_settings.enabled then
                return plr:togglevis(false)
            end
            
            local mainpart = get_mainpart(model, modelname)
            local worldPos = mainpart and mainpart.Position or model:GetPivot().Position
            local position, onscreen = worldToScreen(worldPos)
            if not onscreen then
                return plr:togglevis(false)
            end
            
            local str = ""
            if corpse_settings.name then str = espname end
            if corpse_settings.distance then
                local dist = math.floor((Camera.CFrame.p - worldPos).Magnitude / 4)
                if str ~= "" then str = str .. " [" .. dist .. "m]" else str = "[" .. dist .. "m]" end
            end
            
            if str == "" then
                return plr:togglevis(false)
            end
            
            realname.Text = str
            realname.Position = position
            plr:togglevis(true)
        end)
        plr:forceupdate()
    end
    local function destroy_esp(player)
        if not loaded_plrs[player] then return end
        loaded_plrs[player].connection:Disconnect()
        for i,v in loaded_plrs[player].obj do
            v:Remove()
        end
        if loaded_plrs[player].chams_object then
            loaded_plrs[player].chams_object:Destroy()
        end
        loaded_plrs[player] = nil
    end
    function esp_table.load()
        assert(not esp_table.__loaded, "[ESP] already loaded");
        local shortcut = function(is_obj, remove, name)
            return function(model)(remove and destroy_esp or (is_obj and create_object_esp or create_esp))(model, is_obj and name or nil) end;
        end
        for i, v in next, plrs:GetPlayers() do
            if v ~= lplr then create_esp(v) end
        end
        for _, folder in next, workspace.AiZones:GetChildren() do
            for _, npc in next, folder:GetChildren() do
                create_esp(npc, true)
            end
        end
        for _, item in next, workspace.DroppedItems:GetChildren() do
            create_object_esp(item, "corpse")
        end
        esp_table.objectAdded = {
            plrs.PlayerAdded:Connect(shortcut(false, false)),
            workspace.DroppedItems.ChildAdded:Connect(shortcut(true, false, "corpse"))
        };
        esp_table.objectRemoving = {
            plrs.PlayerRemoving:Connect(shortcut(false, true)),
            workspace.DroppedItems.ChildRemoved:Connect(shortcut(true, true, "corpse"))
        };
        for _, __no in pairs(workspace.AiZones:GetChildren()) do
            esp_table.objectAdded[#esp_table.objectAdded + 1] = __no.ChildAdded:Connect(shortcut(false, false))
            esp_table.objectRemoving[#esp_table.objectRemoving + 1] = __no.ChildRemoved:Connect(shortcut(false, true))
        end
        esp_table.__loaded = true;
    end
    function esp_table.unload()
        assert(esp_table.__loaded, "[ESP] not loaded yet");
        for player, _ in next, loaded_plrs do
            destroy_esp(player)
        end
        for _, connection in next, esp_table.objectAdded do
            connection:Disconnect()
        end
        for _, connection in next, esp_table.objectRemoving do
            connection:Disconnect()
        end
        esp_table.__loaded = false;
    end
    function esp_table.get_gun(player)
        local Player = _FindFirstChild(ReplicatedStorage.Players, player.Name);
        if Player and _FindFirstChild(Player, "Status") and _FindFirstChild(Player.Status, "GameplayVariables") and _FindFirstChild(Player.Status.GameplayVariables, "EquippedTool") and Player.Status.GameplayVariables.EquippedTool.Value then
            local Equipped = Player.Status.GameplayVariables.EquippedTool.Value;
            return tostring(Equipped);
        end;
        return "None";
    end
    function esp_table.icaca()
        for _, v in loaded_plrs do
            v.last_chams_update = 0
            task.spawn(function() v:forceupdate() end)
        end
    end
    do
        local _chams_hue    = 0
        local _outline_hue  = 0
        local _strobe_phase = 0
        RunService:BindToRenderStep("CrazyChamsRS", Enum.RenderPriority.Last.Value + 2, function(delta)
            local settings = esp_table.settings and esp_table.settings.enemy
            if not settings then return end
            local anyActive = settings.chams_rainbow
                or settings.chams_pulse
                or settings.chams_outline_pulse
                or settings.chams_strobe
            if not anyActive then return end

            _chams_hue    = (_chams_hue    + delta * 0.3) % 1
            _outline_hue  = (_outline_hue  + delta * 0.5) % 1
            _strobe_phase = (_strobe_phase + delta * 12)  % (2 * math.pi)

            local sat            = math.clamp(settings.chams_saturation or 1, 0, 1)
            local rainbowColor   = Color3.fromHSV(_chams_hue,  sat, 1)
            local outlineColor   = Color3.fromHSV(_outline_hue, sat, 1)
            local pulseAlpha     = (math.sin(tick() * 3) + 1) / 2
            local strobeAlpha    = (math.sin(_strobe_phase) > 0) and 0.0 or 0.99
            local isWireframe    = settings.chams_material == "Wireframe"
            -- bidirectional: 0=max opaque, 0.5=no change to base alpha, 1=invisible
            local int_offset     = (math.clamp(settings.chams_intensity or 0.5, 0, 1) - 0.5) * 2

            for _, plrdata in next, loaded_plrs do
                local cham = plrdata.chams_object
                if not (cham and cham.Enabled) then continue end

                if settings.chams_strobe then
                    if not isWireframe then
                        cham.FillTransparency = strobeAlpha
                    end
                    if settings.chams_outline then
                        cham.OutlineTransparency = strobeAlpha
                    end
                    if settings.chams_rainbow then
                        cham.FillColor = rainbowColor
                        if settings.chams_outline then cham.OutlineColor = rainbowColor end
                    end
                    continue
                end

                if settings.chams_rainbow and not settings.chams_health_reactive then
                    cham.FillColor = rainbowColor
                end

                if settings.chams_outline_pulse and settings.chams_outline then
                    local pulse_out = (math.sin(tick() * 5) + 1) / 2
                    cham.OutlineColor        = outlineColor
                    cham.OutlineTransparency = math.clamp(pulse_out + int_offset, 0, 0.99)
                elseif settings.chams_rainbow and settings.chams_outline then
                    cham.OutlineColor = rainbowColor
                end

                if settings.chams_pulse
                    and not isWireframe
                    and not settings.chams_health_reactive
                    and not settings.chams_visible_split then
                    cham.FillTransparency = math.clamp(pulseAlpha + int_offset, 0, 0.99)
                end

                if settings.visible_check and plrdata._esp_visible then
                    cham.FillColor = Color3.fromRGB(0, 255, 0)
                    if settings.chams_outline then
                        cham.OutlineColor = Color3.fromRGB(0, 255, 0)
                    end
                end
            end
        end)
    end
    cheat.EspLibrary = esp_table
end)()

-- These are declared upfront so the UI callbacks and GC loop share them
local norecoil         = false
local nobob            = false
local instantaim       = false
local forceauto        = false
local packetautoshoot  = false
local packetpred       = false
local packetscan       = false
local packetthruscan   = false
local shootspeed       = 1
local instant_equip    = false
local rapid_fire       = false
local rapid_fire_delay = 0.05
local original_recoils = {}
local instant_mag_refill = false

-- Resolve desync
local resolve_desync   = false

-- Anti-aim
local aa_enabled              = false
local aa_mode                 = "Reverse"
local aa_yaw_offset           = 0
local aa_pitch_value          = 0
local fake_lag_enabled        = false
local fake_lag_interval       = 0.4
local visualize_server_pos    = false
local visualize_color         = Color3.fromRGB(255,50,50)
local visualize_transparency  = 0
local aa_custom_offset        = false
local aa_custom_offset_radius = 0.5
local aa_floor_clip           = false
local aa_floor_clip_depth     = 3
local _aa_up_v3               = Vector3.new(0,0.2,0)
local _aa_floor_v3            = Vector3.new(0,-3,0)
local _aa_custom_rp           = RaycastParams.new()
local _aa_custom_filter       = {nil, nil}
_aa_custom_rp.FilterType      = Enum.RaycastFilterType.Exclude
_aa_custom_rp.IgnoreWater     = true
_aa_custom_filter[2]          = Camera
local ug_resolver_enabled     = false
local ug_resolver_holding     = false
local ug_resolver_depth       = 30
local ug_resolver_entry_cf    = nil  -- real above-ground CFrame when X was pressed

-- TP Kill state
local tpkill_enabled      = false
local tpkill_height       = 200
local _tpkill_h_v3        = Vector3.new(0,200,0)
local _tpkill_plat_v3     = Vector3.new(0,-3.5,0)
local tpkill_start_time   = 0
local tpkill_last_used    = 0
local tpkill_original_cf  = nil
local current_tp_target   = nil
local fake_platform       = nil
local tpkill_show_bar     = false
local tpkill_autolook     = false
local tpkill_autotbot     = false

-- Hit logs
cheat.hitlogs_enabled     = false
cheat.hitlogs_valid_color = Color3.fromRGB(0,200,100)
cheat.hitlogs_invalid_color=Color3.fromRGB(200,80,80)
cheat.hitlogs_font        = 2
cheat.hitlogs_size        = 14
cheat.hitlogs_y           = 400
cheat.hitlogs_list        = {}
cheat.hitlogs             = { pending = {}, active = {} }

-- Volume accessors used in __namecall
cheat._gun_sounds_volume = function()
    return Library and Library.Flags.snd_gs_vol or 100
end
cheat._hitmarker_sounds_volume = function()
    pcall(function() if Library.ApplyLanguage then Library.ApplyLanguage() end end)
return Library and Library.Flags.snd_hs_vol or 100
end

-- World globals (shared with __newindex hook)
local globals = {
    EnableTime    = false,
    Time          = 12,
    noshadows     = false,
    gradientenabled = false,
    fov_enabled   = false,
    zoom_enabled  = false,
}

-- Flying/TP state tracker
cheat.is_dead_or_respawning = false
cheat.last_fly_or_tp_time   = 0
cheat.real_CFrame           = nil
cheat.is_flying_or_tp = function()
    local tp_active  = Library.Flags.tpkill_on
    local fly_active = Library.Flags.fly_on
    if tp_active or fly_active then
        cheat.last_fly_or_tp_time = tick()
        cheat.real_CFrame = nil
        return true
    elseif cheat.last_fly_or_tp_time > 0 and (tick()-cheat.last_fly_or_tp_time < 1.2) then
        cheat.real_CFrame = nil
        return true
    end
    return false
end


-- UG Resolver — position is driven by the AA heartbeat via ug_resolver_holding flag
local function UGRESOLVER() end

local vischeck_params = RaycastParams.new()
vischeck_params.FilterType = Enum.RaycastFilterType.Exclude

local function is_pos_visible(posfrom, posto, target)
    local target_part = silent_aim and silent_aim.target_part
    if not (target and target_part) then return false end
    local char = LocalPlayer.Character
    local nc   = workspace:FindFirstChild("NoCollision")
    vischeck_params.FilterDescendantsInstances = { nc, Camera, char }
    local castresults = workspace:Raycast(posfrom, posto-posfrom, vischeck_params)
    return (
        castresults and castresults.Instance and castresults.Instance:IsDescendantOf(target) or
        not (castresults and castresults.Instance)
    )
end

local function predict_velocity(Origin, Destination, DestinationVelocity, ProjectileSpeed)
    local Distance  = (Destination-Origin).Magnitude
    local TimeToHit = Distance/ProjectileSpeed
    local Predicted = Destination + DestinationVelocity*TimeToHit
    local Delta     = (Predicted-Origin).Magnitude/ProjectileSpeed
    TimeToHit       = TimeToHit + Delta/ProjectileSpeed
    local Actual    = Destination + DestinationVelocity*TimeToHit
    return Actual
end

local function predict_drop(Origin, Destination, ProjectileSpeed, ProjectileDrop)
    if ProjectileDrop==0 then return 0 end
    local Distance  = (Destination-Origin).Magnitude
    local TimeToHit = Distance/ProjectileSpeed
    local DropTime  = ProjectileDrop * TimeToHit^2
    if DropTime ~= DropTime or Distance<=100 then return 0 end
    return DropTime
end

local silent_aim = {
    enabled          = false,
    triggerbot       = false,
    target_ai        = false,
    target_npc       = false,
    target_heli      = false,
    testwallbang     = false,
    part             = "Head",
    random_part      = false,
    fov              = false,
    fov_show         = false,
    fov_color        = Color3.new(1,1,1),
    fov_outline      = false,
    fov_size         = 100,
    fov_glow_intensity= 1,
    indicator        = false,
    indicator_text   = "",
    nospread         = false,
    instant          = false,
    corner_shoot     = false,
    corner_shoot_dist= 5,
    crosshair_status = false,
    manipulated             = false,
    manipulated_origin      = nil,

    target_part             = nil,
    is_npc           = false,
    isvisible        = false,
    tracer           = false,
    tracer_style     = "Tracer 1",
    tracer_color     = Color3.new(1,1,1),
    tracer_color2    = Color3.new(0,0.5,1),
    tracer_thickness = 0.5,
    tracer_lifetime  = 1,
    -- Native whitelist: this player is ALWAYS ignored and cannot be removed.
    native_whitelist = { ["Kaene_zy"] = true },
    whitelist_mode   = false,
    whitelist        = {},
    tipanel_x        = 20,
    tipanel_y        = 350,
    target_line      = false,
    target_info      = false,
    target_info_size = 0.75,
    target_info_locked = false,
    visible_only     = true,
    triggerbot_manipulation = false,
}

-- reusable raycast params/filter for is_triggerable — avoids a RaycastParams +
-- filter-table allocation on every triggerbot candidate
local _gct_trig_rp = RaycastParams.new()
_gct_trig_rp.FilterType = Enum.RaycastFilterType.Exclude
local _gct_trig_filter = {nil, nil, nil}

local function silent_aim_is_whitelisted(plr)
    if not plr then return false end
    -- Kaene_zy is a native, non-configurable whitelist entry.
    if silent_aim.native_whitelist[plr.Name] then
        return true
    end
    if silent_aim.whitelist_mode and silent_aim.whitelist[plr.Name] then
        return true
    end
    return false
end

-- Single source of truth for the rendered/selection FOV radius.
local function get_silent_fov_radius()
    return math.max(0, tonumber(silent_aim.fov_size) or 100)
end

local function get_closest_target(usefov, fov_size, aimpart, npc, target_heli, require_triggerable, allow_manip, manip_origin)
    local is_visible_fn = cheat.utility.is_visible
    aimpart   = aimpart or silent_aim.part or "Head"
    usefov    = usefov ~= nil and usefov or silent_aim.fov
    fov_size  = tonumber(fov_size) or get_silent_fov_radius()
    npc       = npc ~= nil and npc or silent_aim.target_npc
    local heli = target_heli ~= nil and target_heli or silent_aim.target_heli
    allow_manip  = allow_manip ~= nil and allow_manip or silent_aim.corner_shoot
    manip_origin = manip_origin ~= nil and manip_origin or silent_aim.manipulated_origin

    local ermm_part, isnpc = nil, false
    -- Silent Aim target selection is always bounded by the same FOV radius
    -- used by the rendered circle. The FOV toggle controls visualization, not
    -- the actual safety boundary of target selection.
    local maximum_distance = fov_size
    -- Silent Aim target point: fixed at the center of the screen.
    -- Touch/mouse movement no longer changes the target point.
    local viewport = Camera.ViewportSize
    local mousepos = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)

    -- Use exactly the same center/radius math as the rendered FOV circle.
    local function is_inside_fov(screen_position, on_screen)
        if not on_screen or screen_position.Z <= 0 then return false end
        local screen_pos = Vector2.new(screen_position.X, screen_position.Y)
        return (screen_pos - mousepos).Magnitude <= fov_size
    end

    local function is_triggerable(parent, part)
        if is_visible_fn(Camera.CFrame, parent, part) then return true end
        if allow_manip and manip_origin then
            _gct_trig_filter[1] = LocalPlayer.Character
            _gct_trig_filter[2] = Camera
            _gct_trig_filter[3] = workspace:FindFirstChild("NoCollision")
            _gct_trig_rp.FilterDescendantsInstances = _gct_trig_filter
            local res = workspace:Raycast(manip_origin, part.Position-manip_origin, _gct_trig_rp)
            if not res or (res.Instance and res.Instance:IsDescendantOf(parent)) then return true end
        end
        return false
    end

    LPH_NO_VIRTUALIZE(function()
        if npc then
            local aiZones = workspace:FindFirstChild("AiZones")
            if aiZones then
                for _, zone in pairs(aiZones:GetChildren()) do
                    for _, npcs in pairs(zone:GetChildren()) do
                        local part = npcs:FindFirstChild(aimpart)
                        local is_heli = false
                        if heli and (npcs.Name=="MI24V" or npcs.Name=="BTR80") then
                            is_heli = true
                            part = npcs:FindFirstChild("CollisionPilot",true) or npcs:FindFirstChild("Mi24_Prop_M",true)
                        end
                        if not is_heli and (npcs.Name=="MI24V" or npcs.Name=="BTR80") then continue end
                        local humanoid = npcs:FindFirstChildOfClass("Humanoid")
                        if part and (is_heli or (humanoid and humanoid.Health>0)) then
                            if (Camera.CFrame.p-part.Position).Magnitude < 2500 then
                                local position, onscreen = Camera:WorldToViewportPoint(part.Position)
                                local distance = (Vector2.new(position.X,position.Y)-mousepos).Magnitude
                                local world_distance = (Camera.CFrame.Position-part.Position).Magnitude
                                if is_inside_fov(position, onscreen) and distance <= maximum_distance then
                                    if silent_aim.visible_only then
                                        if is_visible_fn(Camera.CFrame, npcs, part) then
                                            ermm_part = part; maximum_distance = distance; best_world_distance = world_distance; isnpc = true
                                        end
                                    elseif require_triggerable then
                                        if is_triggerable(npcs, part) then
                                            ermm_part = part; maximum_distance = distance; best_world_distance = world_distance; isnpc = true
                                        end
                                    else
                                        ermm_part = part; maximum_distance = distance; best_world_distance = world_distance; isnpc = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        local best_world_distance = math.huge
        for _, plr in Players:GetPlayers() do
            local character = plr.Character
            if plr~=LocalPlayer and character and not silent_aim_is_whitelisted(plr) then
                local part = character:FindFirstChild(aimpart)
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head") or part
                if part and humanoid and humanoid.Health>0 and root then
                    local position, onscreen = Camera:WorldToViewportPoint(part.Position)
                    local screen_distance = (Vector2.new(position.X,position.Y)-mousepos).Magnitude
                    local world_distance = (Camera.CFrame.Position-root.Position).Magnitude
                    if is_inside_fov(position, onscreen) then
                        local can_use = true
                        if silent_aim.visible_only then
                            -- Visible Only means a real line-of-sight check; manipulation
                            -- must not make an occluded target eligible.
                            can_use = is_visible_fn(Camera.CFrame, character, part)
                        elseif require_triggerable then
                            can_use = is_triggerable(character, part)
                        end
                        if can_use then
                            -- With Visible Only enabled, choose the closest visible target in the FOV.
                            -- With it disabled, choose the nearest target in 3D distance.
                            if world_distance < best_world_distance then
                                best_world_distance = world_distance
                                ermm_part=part; isnpc=false
                            end
                        end
                    end
                end
            end
        end
    end)()
    return ermm_part, isnpc
end

local function make_beam(Origin, Position, Color, Thickness)
    local part1 = Instance.new("Part", workspace.NoCollision)
    local part2 = Instance.new("Part", workspace.NoCollision)
    part1.Position=Origin;   part2.Position=Position
    part1.Transparency=1;    part2.Transparency=1
    part1.CanCollide=false;  part2.CanCollide=false
    part1.Size=Vector3.zero; part2.Size=Vector3.zero
    part1.Anchored=true;     part2.Anchored=true
    local oa = Instance.new("Attachment",part1)
    local pa = Instance.new("Attachment",part2)
    local Beam = Instance.new("Beam", workspace.NoCollision)
    Beam.Name="Beam"
    Beam.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color),ColorSequenceKeypoint.new(1,Color)}
    Beam.LightEmission=1; Beam.LightInfluence=1
    Beam.TextureMode=Enum.TextureMode.Static; Beam.TextureSpeed=0
    Beam.Texture="http://www.roblox.com/asset/?id=446111271"
    Beam.Transparency=NumberSequence.new(0)
    Beam.Attachment0=oa; Beam.Attachment1=pa
    Beam.FaceCamera=true; Beam.Segments=1
    Beam.Width0=Thickness or 0.25; Beam.Width1=Thickness or 0.25
    return Beam, part1, part2
end

local function create_advanced_tracer(Origin, Position, Color1, Color2, Thickness)
    local part1 = Instance.new("Part", workspace.NoCollision)
    local part2 = Instance.new("Part", workspace.NoCollision)
    part1.Position=Origin;   part2.Position=Position
    part1.Transparency=1;    part2.Transparency=1
    part1.CanCollide=false;  part2.CanCollide=false
    part1.Size=Vector3.zero; part2.Size=Vector3.zero
    part1.Anchored=true;     part2.Anchored=true
    local oa = Instance.new("Attachment",part1)
    local pa = Instance.new("Attachment",part2)
    local colorSeq = ColorSequence.new{ColorSequenceKeypoint.new(0,Color1),ColorSequenceKeypoint.new(0.3,Color2),ColorSequenceKeypoint.new(1,Color2)}
    local CoreBeam = Instance.new("Beam", workspace.NoCollision)
    CoreBeam.Name="CoreBeam"; CoreBeam.Color=colorSeq; CoreBeam.Width0=Thickness; CoreBeam.Width1=Thickness
    CoreBeam.Texture=""; CoreBeam.TextureSpeed=0; CoreBeam.LightEmission=1; CoreBeam.LightInfluence=0
    CoreBeam.TextureMode=Enum.TextureMode.Stretch; CoreBeam.Attachment0=oa; CoreBeam.Attachment1=pa
    CoreBeam.FaceCamera=true; CoreBeam.Segments=1; CoreBeam.Transparency=NumberSequence.new(0)
    local PulseBeam = Instance.new("Beam", workspace.NoCollision)
    PulseBeam.Name="PulseBeam"; PulseBeam.Color=colorSeq
    PulseBeam.Width0=Thickness*0.5; PulseBeam.Width1=Thickness*0.5
    PulseBeam.Texture="rbxassetid://446111271"; PulseBeam.TextureSpeed=0; PulseBeam.LightEmission=1; PulseBeam.LightInfluence=0
    PulseBeam.TextureMode=Enum.TextureMode.Stretch; PulseBeam.Attachment0=oa; PulseBeam.Attachment1=pa
    PulseBeam.FaceCamera=true; PulseBeam.Segments=1; PulseBeam.Transparency=NumberSequence.new(0)
    return {CoreBeam, PulseBeam}, part1, part2
end


task.spawn(function() pcall(function()
do
    task.wait()
    local ignorelist = require(ReplicatedStorage.Modules.UniversalTables).ReturnTable("GlobalIgnoreListProjectile")
    local function get_local_weapon()
        local Player = ReplicatedStorage.Players:FindFirstChild(LocalPlayer.Name)
        if Player and Player:FindFirstChild("Status") and Player.Status:FindFirstChild("GameplayVariables")
            and Player.Status.GameplayVariables:FindFirstChild("EquippedTool")
            and Player.Status.GameplayVariables.EquippedTool.Value then
            return tostring(Player.Status.GameplayVariables.EquippedTool.Value.Name)
        end
        return "None"
    end
    local shoot_debounce = tick()
    local rpplrs         = ReplicatedStorage.Players
    task.wait()
    local bulletmodule   = require(ReplicatedStorage.Modules.FPS.Bullet)
    local CreateBullet   = bulletmodule.CreateBullet
    local ProjectileInflict = ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("ProjectileInflict", 10)
    local FireProjectile    = ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("FireProjectile", 10)

    function cheat.shoot_weapon(speedmult)
        speedmult = speedmult or shootspeed
        local weapon    = get_local_weapon()
        local rpinv     = rpplrs[LocalPlayer.Name] and rpplrs[LocalPlayer.Name].Inventory
        local aimpart   = Camera and Camera:FindFirstChild("ViewModel") and Camera.ViewModel:FindFirstChild("AimPart")
        local inv_weapon= rpinv and rpinv:FindFirstChild(weapon)
        local charweapon= LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(weapon)
        local magazine  = inv_weapon and inv_weapon:FindFirstChild("Attachments") and inv_weapon.Attachments:FindFirstChild("Magazine") and inv_weapon.Attachments.Magazine:FindFirstChildOfClass("StringValue")
        local loadedammo= magazine and magazine.ItemProperties:FindFirstChild("LoadedAmmo") and magazine.ItemProperties.LoadedAmmo:FindFirstChildOfClass("Folder")
        if weapon~="None" and rpinv and aimpart and inv_weapon and inv_weapon:FindFirstChild("SettingsModule") and charweapon and loadedammo then
            local weapon_settings = require(inv_weapon:FindFirstChild("SettingsModule"))
            if rawget(weapon_settings,"FireRate") and shoot_debounce<=tick() then
                local bullet_type = loadedammo:GetAttribute("AmmoType")
                CreateBullet(bulletmodule, inv_weapon, LocalPlayer.Character:FindFirstChild(weapon),
                    Camera:FindFirstChild("ViewModel"), "Idle", bullet_type, 0, 1,
                    Camera.ViewModel:FindFirstChild("AimPart"))
                shoot_debounce = tick() + (rawget(weapon_settings,"FireRate") * speedmult)
            end
        end
    end

    function cheat.shoot_weapon_packet(isvis, speedmult, prediction, hitscan, hitscanwalls)
        speedmult = speedmult or shootspeed
        local weapon    = get_local_weapon()
        local rpinv     = rpplrs:FindFirstChild(LocalPlayer.Name) and rpplrs[LocalPlayer.Name].Inventory
        local inv_weapon= rpinv and weapon and rpinv:FindFirstChild(weapon)
        local aimpart   = Camera and Camera:FindFirstChild("ViewModel") and Camera.ViewModel:FindFirstChild("AimPart")
        if inv_weapon and inv_weapon:FindFirstChild("SettingsModule") then
            local weapon_settings = require(inv_weapon:FindFirstChild("SettingsModule"))
            if rawget(weapon_settings,"FireRate") and shoot_debounce<=tick() then
                local real_orig = Camera.CFrame.p
                if silent_aim.corner_shoot and silent_aim.manipulated_origin then
                    real_orig = silent_aim.manipulated_origin
                elseif cheat.freecam_enabled then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Head") then real_orig=char.Head.Position end
                end
                local _fire_part = silent_aim.target_part
                local _fire_pos  = _fire_part and _fire_part.Position or nil
                local dist = _fire_pos and (_fire_pos-real_orig).Magnitude or 0
                local autoshootdelay = tick() - (dist/1000)
                local rnd = math.random(-10000,10000)
                if silent_aim then silent_aim._exact_fire_tick=tick() end
                local as_dir = _fire_pos and (_fire_pos-real_orig).Unit or Vector3.new(0,1,0)
                if FireProjectile:InvokeServer(as_dir, rnd, autoshootdelay) then
                    ProjectileInflict:FireServer(
                        _fire_part,
                        _fire_part.CFrame:ToObjectSpace(CFrame.new(0,0.0001,0)),
                        rnd, tick()
                    )
                    if silent_aim.tracer then
                        local t_orig = real_orig
                        if not (silent_aim.corner_shoot and silent_aim.manipulated_origin) and not cheat.freecam_enabled then
                            t_orig = aimpart and aimpart.Position or Camera.CFrame.p
                        end
                        local drawing,dm1,dm2 = make_beam(t_orig, (_fire_pos or _fire_part and _fire_part.Position or Vector3.zero), silent_aim.tracer_color, silent_aim.tracer_thickness)
                        local wtf=-1
                        local conn; conn=cheat.utility.new_renderstepped(function(delta)
                            wtf=wtf+delta
                            drawing.Transparency=NumberSequence.new(math.clamp(wtf,0,1))
                            if wtf>=1 then drawing:Destroy();dm1:Destroy();dm2:Destroy();conn:Disconnect() end
                        end)
                    end
                end
                shoot_debounce = tick() + (rawget(weapon_settings,"FireRate") * speedmult)
            end
        end
    end

    -- GC hook loop: norecoil, nobob, CreateBullet, updateClient
    local got_that = false
    task.spawn(function() repeat LPH_JIT_MAX(function()
        local gc_list = getgc(true)
        for i = 1, #gc_list do
            local gc = gc_list[i]
            if type(gc)=="table" then
                if rawget(gc,"shove") and rawget(gc,"update") then
                    local shove,update = gc.shove, gc.update
                    cheat.utility.new_hook(shove, function(old,...) return norecoil or old(...) end, true)
                    cheat.utility.new_hook(update, function(old,...) return nobob and Vector3.zero or old(...) end, true)
                end
                if type(rawget(gc,"create"))=="function" and debug.getinfo(gc.create).short_src=="ReplicatedStorage.Modules.SpringV2" then
                    local old_create = gc.create
                    cheat.utility.new_hook(old_create, function(old,...)
                        local returns = old(...)
                        local shove,update = returns.shove, returns.update
                        if shove then
                            returns.shove = function(...)
                                if norecoil then return end
                                pcall(shove, ...)
                            end
                        end
                        if update then
                            returns.update = function(...)
                                if nobob then return Vector3.zero end
                                local ok, res = pcall(update, ...)
                                return ok and res or Vector3.zero
                            end
                        end
                        return returns
                    end, true)
                end
                if rawget(gc,"CreateBullet") then
                    local old_bullet = gc.CreateBullet
                    cheat.utility.new_hook(old_bullet, LPH_JIT_MAX(function(old, self, ...)
                        local args      = {...}
                        local argCount  = select("#",...)
                        if silent_aim.enabled then
                            local loadedammo, aimpart_index
                            for i,v in args do
                                if typeof(v)=="Instance" and v.Name=="AimPart" then aimpart_index=i end
                                if type(v)=="string" then
                                    local tmp = ReplicatedStorage.AmmoTypes:FindFirstChild(v)
                                    if tmp then loadedammo=tmp end
                                end
                            end
                            if not (loadedammo and aimpart_index) then return old(self, unpack(args,1,argCount)) end
                            -- Tracer
                            if silent_aim.tracer then
                                if silent_aim.tracer_style=="Tracer 2" then
                                    local t_orig = silent_aim.manipulated_origin or args[aimpart_index].Position
                                    local beams,d1,d2 = create_advanced_tracer(t_orig, silent_aim.target_part and silent_aim.target_part.Position or args[aimpart_index].CFrame.LookVector*10000, silent_aim.tracer_color, silent_aim.tracer_color2, silent_aim.tracer_thickness)
                                    local lifetime = silent_aim.tracer_lifetime; local t=0
                                    local conn; conn=cheat.utility.new_renderstepped(function(delta)
                                        t=t+delta
                                        local trans=math.clamp((t/lifetime)^2,0,1)
                                        local pulse=(math.sin(t*20)+1)/2
                                        for _,b in pairs(beams) do
                                            b.Transparency=NumberSequence.new(trans)
                                            if b.Name=="PulseBeam" then b.Width0=silent_aim.tracer_thickness*(0.5+pulse); b.Width1=silent_aim.tracer_thickness*(0.5+pulse) end
                                        end
                                        if t>=lifetime then for _,b in pairs(beams) do b:Destroy() end; d1:Destroy();d2:Destroy();conn:Disconnect() end
                                    end)
                                else
                                    local real_orig = Camera.CFrame.p
                                    if silent_aim.corner_shoot and silent_aim.manipulated_origin then real_orig=silent_aim.manipulated_origin
                                    elseif cheat.freecam_enabled then local char=LocalPlayer.Character; if char and char:FindFirstChild("Head") then real_orig=char.Head.Position end end
                                    local t_orig = (silent_aim.corner_shoot and silent_aim.manipulated_origin) and real_orig or args[aimpart_index].Position
                                    local drawing,dm1,dm2 = make_beam(t_orig, silent_aim.target_part and silent_aim.target_part.Position or args[aimpart_index].CFrame.LookVector*10000, silent_aim.tracer_color, silent_aim.tracer_thickness)
                                    local wtf=-1
                                    local conn; conn=cheat.utility.new_renderstepped(function(delta)
                                        wtf=wtf+delta; drawing.Transparency=NumberSequence.new(math.clamp(wtf,0,1))
                                        if wtf>=1 then drawing:Destroy();dm1:Destroy();dm2:Destroy();conn:Disconnect() end
                                    end)
                                end
                            end
                            if silent_aim.instant then return old(self, unpack(args,1,argCount)) end
                            if not silent_aim.target_part then return old(self, unpack(args,1,argCount)) end
                            local real_aimpart = args[aimpart_index]
                            local old_cf       = real_aimpart.CFrame
                            -- derive fire origin: corner_shoot uses manipulated origin, freecam uses head
                            local fire_origin
                            if silent_aim.corner_shoot and silent_aim.manipulated_origin then
                                fire_origin = silent_aim.manipulated_origin
                            elseif cheat.freecam_enabled then
                                local char = LocalPlayer.Character
                                fire_origin = char and char:FindFirstChild("Head") and char.Head.Position or real_aimpart.Position
                            else
                                fire_origin = real_aimpart.Position
                            end
                            -- point AimPart toward target from the actual fire origin so direction is correct
                            local target_pos = silent_aim.target_part.Position
                            local aim_dir    = (target_pos - fire_origin).Unit
                            real_aimpart.CFrame = CFrame.new(real_aimpart.Position, real_aimpart.Position + aim_dir)
                            local ret = old(self, unpack(args,1,argCount))
                            real_aimpart.CFrame = old_cf
                            return ret
                        end
                        return old(self, unpack(args,1,argCount))
                    end), true)
                end
                if rawget(gc,"updateClient") then
                    local old_update = gc.updateClient
                    cheat.utility.new_hook(old_update, LPH_JIT_MAX(function(old,...)
                        local args = {...}; local argCount = select("#",...)
                        if instantaim then args[1].AimInSpeed=0; args[1].AimOutSpeed=0 end
                        if forceauto  then args[1].FireMode="Auto" end
                        if rapid_fire then args[1].FireRate=rapid_fire_delay end
                        return old(unpack(args,1,argCount))
                    end), true)
                    got_that=true
                end
            end
            if i % 300 == 0 then task.wait() end
        end
    end)() if not got_that then task.wait(1) end until got_that end)

    -- Resolve desync renderstepped
    local rep_players = ReplicatedStorage:WaitForChild("Players", 10)
    cheat.utility.new_renderstepped(function()
        if resolve_desync then
            for _,player in ipairs(Players:GetPlayers()) do
                if player~=LocalPlayer then
                    local character = player.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local p_folder = rep_players:FindFirstChild(player.Name)
                        local status   = p_folder and p_folder:FindFirstChild("Status")
                        local uac      = status and status:FindFirstChild("UAC")
                        if uac then
                            local lastpos = uac:GetAttribute("LastVerifiedPos")
                            if lastpos then root.CFrame = (root.CFrame-root.Position)+lastpos end
                        end
                    end
                end
            end
        end
    end)
end
end) end) -- end pcall for game-specific bullet hook

do
    local game_TweenService = game:GetService("TweenService")
    local get_local_weapon_mm = function()
        local Player = ReplicatedStorage.Players:FindFirstChild(LocalPlayer.Name)
        if Player and Player:FindFirstChild("Status") and Player.Status:FindFirstChild("GameplayVariables")
            and Player.Status.GameplayVariables:FindFirstChild("EquippedTool")
            and Player.Status.GameplayVariables.EquippedTool.Value then
            return tostring(Player.Status.GameplayVariables.EquippedTool.Value.Name)
        end
        return "None"
    end

    local __index; __index = hookmetamethod(game, "__index", newcclosure(LPH_NO_VIRTUALIZE(function(self,k)
        if checkcaller() then return __index(self,k) end
        if k~="Trail" and k~="Handle" and k~="CFrame" and k~="Position" then return __index(self,k) end
        if k=="Trail" and typeof(self)=="Instance" and self.Name=="VisualTracer" then
            local rt = self:FindFirstChild("Trail"); return rt or Instance.new("Trail")
        end
        if k=="Handle" and typeof(self)=="Instance" and self:IsA("Accessory") then
            local handle = self:FindFirstChild("Handle")
            if handle then return handle end
            local dummy=Instance.new("Part"); dummy.Name="Handle"; dummy.Transparency=1; return dummy
        end
        if (k=="CFrame" or k=="Position") and cheat.real_CFrame and not cheat.is_dead_or_respawning and not cheat.is_flying_or_tp() then
            local char = LocalPlayer.Character
            if char and typeof(self)=="Instance" and self==char:FindFirstChild("HumanoidRootPart") then
                if k=="CFrame"   then return cheat.real_CFrame end
                if k=="Position" then return cheat.real_CFrame.Position end
            end
        end
        return __index(self,k)
    end)))

    local __newindex; __newindex = hookmetamethod(game, "__newindex", newcclosure(LPH_NO_VIRTUALIZE(function(self,k,v)
        if checkcaller() then return __newindex(self,k,v) end
        if self~=Lighting and self~=Camera then return __newindex(self,k,v) end
        if self==Lighting then
            if k=="ClockTime"     and globals.EnableTime       then return end
            if k=="GlobalShadows" and globals.noshadows        then return end
            if k=="Ambient"       and globals.gradientenabled  then return end
            if k=="OutdoorAmbient"and globals.gradientenabled  then return end
            if k=="ExposureCompensation" or k=="Brightness"   then return end
        end
        if self==Camera then
            if k=="FieldOfView" and (globals.fov_enabled or globals.zoom_enabled) then return end
        end
        return __newindex(self,k,v)
    end)))

    local __namecall; __namecall = hookmetamethod(game, "__namecall", newcclosure(LPH_NO_VIRTUALIZE(function(self,...)
        if checkcaller() then return __namecall(self,...) end
        local method   = getnamecallmethod()
        local methodstr= tostring(method)
        -- fast path: avoid {…} table alloc for the vast majority of calls we never touch
        if methodstr~="InvokeServer" and methodstr~="invokeServer"
           and methodstr~="FireServer" and methodstr~="fireServer"
           and methodstr~="Create" and methodstr~="Play"
           and methodstr~="GetAttribute" and methodstr~="Raycast" then
            return __namecall(self,...)
        end
        local args     = {...}
        local argCount = select("#",...)

        if methodstr=="InvokeServer" or methodstr=="invokeServer" or methodstr=="FireServer" or methodstr=="fireServer" then
            local success,rname = pcall(function() return self.Name end)
            if success and rname=="ChangeSkin" then
                local weaponObj=args[1]; local skinName=args[2]
                if weaponObj then
                    if tostring(skinName)=="Default" then pcall(function() weaponObj:SetAttribute("SpoofedSkin","") end)
                    else pcall(function() weaponObj:SetAttribute("SpoofedSkin",tostring(skinName)) end) end
                    return true
                end
            end
            if success and rname=="ProjectileInflict" then
                if cheat.hitlogs_enabled and args[1] and typeof(args[1])=="Instance" then
                    local target_part = args[1]
                    local target_char = target_part.Parent
                    local target_name = target_char and target_char.Name or "Unknown"
                    local hum = target_char and target_char:FindFirstChild("Humanoid")
                    if target_name ~= "Unknown" and hum and Camera then
                        local dist = math.floor((target_part.Position - Camera.CFrame.p).Magnitude / 2.8)
                        table.insert(cheat.hitlogs.pending, {
                            name = target_name,
                            part = target_part.Name,
                            dist = dist,
                            tick = os.clock(),
                            hum = hum,
                            start_hp = target_char:GetAttribute("Health") or hum.Health
                        })
                    end
                end
            end
        end
        if self==game_TweenService and method=="Create" and args[1]==Camera and rawget(args[3],"FieldOfView") and (globals.fov_enabled or globals.zoom_enabled) then
            args[3]={}; setnamecallmethod(methodstr); return __namecall(self, unpack(args,1,argCount))
        end
        if method=="Play" and typeof(self)=="Instance" and self.ClassName=="Sound" then
            local sname = self.Name
            local is_gun = sname=="FireSound" or sname=="FireFarSound" or sname=="FireSoundSupressed"
            local is_local_sound = is_gun and (self:IsDescendantOf(Camera) or (Players.LocalPlayer.Character and self:IsDescendantOf(Players.LocalPlayer.Character)))
            if is_local_sound then
                local cgs_on = cheat._custom_gs_enabled
                if cgs_on then
                    self.SoundId = cheat._custom_gs_id or self.SoundId
                    self.Volume  = cheat._custom_gs_vol or self.Volume
                else
                    local gun_vol = cheat._gun_sounds_volume and cheat._gun_sounds_volume() or 100
                    if gun_vol<100 then
                        if gun_vol==0 then return end
                        if not self:GetAttribute("OriginalVolume") then self:SetAttribute("OriginalVolume",self.Volume) end
                        self.Volume = self:GetAttribute("OriginalVolume") * (gun_vol/100)
                    end
                end
            elseif is_gun then
                -- not our sound, skip custom gs but still allow volume scaling
                local gun_vol = cheat._gun_sounds_volume and cheat._gun_sounds_volume() or 100
                if gun_vol<100 then
                    if gun_vol==0 then return end
                    if not self:GetAttribute("OriginalVolume") then self:SetAttribute("OriginalVolume",self.Volume) end
                    self.Volume = self:GetAttribute("OriginalVolume") * (gun_vol/100)
                end
            end
            local hit_vol = cheat._hitmarker_sounds_volume and cheat._hitmarker_sounds_volume() or 100
            if hit_vol<100 then
                if sname=="Helmet" or sname=="BodyArmor" or sname=="Bodyshot" or sname=="Headshot" or sname=="Kill" or sname=="BarbedWire" or sname=="Vehicle" or sname=="Burn" or self.SoundId=="rbxassetid://4581728529" then
                    if hit_vol==0 then return end
                    if not self:GetAttribute("OriginalVolume") then self:SetAttribute("OriginalVolume",self.Volume) end
                    self.Volume = self:GetAttribute("OriginalVolume") * (hit_vol/100)
                end
            end
        end
        if method=="GetAttribute" then
            local attribute = args[1]
            if silent_aim.nospread and attribute=="AccuracyDeviation" then return 0 end
            if silent_aim.enabled then
                if attribute=="ProjectileDrop" then return 0 end
                if attribute=="Drag"           then return 0 end
            end
        end
        if method=="InvokeServer" and self.Name=="FireProjectile" then
            if silent_aim then silent_aim._exact_fire_tick=tick() end
            local is_empty   = false
            local weapon_name= get_local_weapon_mm()
            if weapon_name~="None" then
                local rpplrs_mm = ReplicatedStorage:FindFirstChild("Players")
                local rpinv_mm  = rpplrs_mm and rpplrs_mm:FindFirstChild(LocalPlayer.Name) and rpplrs_mm[LocalPlayer.Name]:FindFirstChild("Inventory")
                local inv_weapon= rpinv_mm and rpinv_mm:FindFirstChild(weapon_name)
                if inv_weapon and inv_weapon:FindFirstChild("SettingsModule") then
                    local magazine  = inv_weapon:FindFirstChild("Attachments") and inv_weapon.Attachments:FindFirstChild("Magazine") and inv_weapon.Attachments.Magazine:FindFirstChildOfClass("StringValue")
                    local loadedammo= magazine and magazine:FindFirstChild("ItemProperties") and magazine.ItemProperties:FindFirstChild("LoadedAmmo")
                    local ammo_count= 0
                    if loadedammo then
                        if loadedammo:IsA("Folder") then ammo_count=#loadedammo:GetChildren()
                        else ammo_count=loadedammo:GetAttribute("LoadedAmmo") or loadedammo:GetAttribute("Ammo") or 0 end
                    end
                    if not magazine or ammo_count<=0 then is_empty=true end
                end
            end
            if is_empty then return end
            local real_orig     = Camera.CFrame.p
            local origin_spoofed= false
            if silent_aim.corner_shoot and silent_aim.manipulated_origin then
                real_orig=silent_aim.manipulated_origin; origin_spoofed=true
            elseif cheat.freecam_enabled then
                local char=LocalPlayer.Character; if char and char:FindFirstChild("Head") then real_orig=char.Head.Position; origin_spoofed=true end
            end
            if origin_spoofed and silent_aim.enabled and silent_aim.target_part then
                local _aim_part = silent_aim.target_part
                args[1] = (_aim_part.Position - real_orig).Unit
            elseif origin_spoofed and cheat.freecam_enabled then
                local hit_pos = Mouse.Hit.Position
                args[1] = (hit_pos - real_orig).Unit
            end
            if silent_aim.enabled and silent_aim.instant and silent_aim.target_part then
                local dist=(silent_aim.target_part.Position-real_orig).Magnitude
                args[3]=tick()-(dist/1000)
            end
            setnamecallmethod(methodstr); return __namecall(self, unpack(args,1,argCount))
        end
        if method=="Raycast" then
            local origin=args[1]
            if typeof(origin)=="Vector3" then
                if cheat.freecam_enabled then
                    local char=LocalPlayer.Character; if char and char:FindFirstChild("Head") then origin=char.Head.Position; args[1]=origin end
                end
                if silent_aim.enabled and silent_aim.target_part then
                    local hitpart = silent_aim.target_part
                    if hitpart and hitpart.Parent then
                        -- Do not redirect short/interactive raycasts. Interaction rays
                        -- (objects, prompts, NPCs, etc.) keep their original target.
                        local original_direction = args[2]
                        local is_combat_ray = typeof(original_direction) == "Vector3"
                            and original_direction.Magnitude >= 100
                        if is_combat_ray then
                            if silent_aim.corner_shoot and silent_aim.manipulated_origin then origin=silent_aim.manipulated_origin; args[1]=origin end
                            local direction=hitpart.Position-origin; args[2]=direction
                            return { Instance=hitpart, Position=hitpart.Position, Normal=direction.Unit*-1, Material=hitpart.Material, Distance=direction.Magnitude }
                        end
                    end
                end
            end
        end
        setnamecallmethod(methodstr); return __namecall(self, unpack(args,1,argCount))
    end)))
end

do
    local current_jitter_offset= Vector3.zero
    local fake_lag_CFrame       = nil
    local last_fake_lag_time    = 0

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        and LocalPlayer.Character.Humanoid.Health<=0 then
        cheat.is_dead_or_respawning = true
    end
    LocalPlayer.CharacterAdded:Connect(function()
        cheat.is_dead_or_respawning=true
        task.delay(0.5, function() cheat.is_dead_or_respawning=false end)
    end)

    task.wait()
    RunService:BindToRenderStep("AADesyncRestore", 0, function()
        if (not aa_enabled and not fake_lag_enabled and not silent_aim.corner_shoot) or cheat.is_dead_or_respawning then return end
        if cheat.is_flying_or_tp() then return end
        local char=LocalPlayer.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if hrp and cheat.real_CFrame then
            local lv=hrp.AssemblyLinearVelocity; local av=hrp.AssemblyAngularVelocity
            hrp.CFrame=cheat.real_CFrame; hrp.AssemblyLinearVelocity=lv; hrp.AssemblyAngularVelocity=av
        end
    end)

    cheat.utility.new_heartbeat(function()
        if (not aa_enabled and not fake_lag_enabled and not silent_aim.corner_shoot) or cheat.is_dead_or_respawning then return end
        if cheat.is_flying_or_tp() then return end
        local char=LocalPlayer.Character; if not char then return end
        local hum=char:FindFirstChild("Humanoid"); local hrp=char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if hum.Health<=0 then cheat.is_dead_or_respawning=true; fake_lag_CFrame=nil; return end
        pcall(function()
            if aa_enabled then
                hum.AutoRotate=false
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
            cheat.real_CFrame = hrp.CFrame
            if fake_lag_enabled then
                local _now_fl = tick()
                if _now_fl-last_fake_lag_time >= fake_lag_interval then
                    last_fake_lag_time = _now_fl
                    fake_lag_CFrame    = hrp.CFrame
                    if visualize_server_pos then
                        task.spawn(function()
                            local oldA=char.Archivable; char.Archivable=true; local ghost=char:Clone(); char.Archivable=oldA
                            if ghost then
                                ghost.Name="FakeLagGhost_ESP_IGNORE"
                                for _,v in pairs(ghost:GetDescendants()) do
                                    if v:IsA("BasePart") then v.Material=Enum.Material.ForceField;v.Color=visualize_color;v.CanCollide=false;v.CanTouch=false;v.CanQuery=false;v.Massless=true;v.Anchored=true;v.Transparency=visualize_transparency
                                    elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("Clothing") or v:IsA("Accessory") or v:IsA("Script") or v:IsA("LocalScript") or v:IsA("SurfaceAppearance") then v:Destroy() end
                                end
                                local gHrp=ghost:FindFirstChild("HumanoidRootPart"); local gHum=ghost:FindFirstChildOfClass("Humanoid"); if gHum then gHum:Destroy() end
                                ghost.Parent=workspace.Terrain; if gHrp then ghost:PivotTo(fake_lag_CFrame) end
                                local fade=0.5; local TweenService=game:GetService("TweenService"); local tweenInfo=TweenInfo.new(fade, Enum.EasingStyle.Linear)
                                for _,v in pairs(ghost:GetDescendants()) do if v:IsA("BasePart") then TweenService:Create(v,tweenInfo,{Transparency=1}):Play() end end
                                task.delay(fade, function() if ghost then ghost:Destroy() end end)
                            end
                        end)
                    end
                end
            else
                fake_lag_CFrame=nil
            end
            local Angle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(-90)
            if aa_mode=="Random"     then Angle=-math.atan2(Camera.CFrame.LookVector.Z,Camera.CFrame.LookVector.X)+math.rad(90)+math.rad(math.random(-120,120))
            elseif aa_mode=="FlatRandom" then Angle=math.rad(math.random(0,360))
            elseif aa_mode=="Spin"   then Angle=-math.atan2(Camera.CFrame.LookVector.Z,Camera.CFrame.LookVector.X)+tick()*100%360
            elseif aa_mode=="Reverse"then Angle=-math.atan2(Camera.CFrame.LookVector.Z,Camera.CFrame.LookVector.X)+math.rad(90) end
            local Offset  = math.rad(aa_yaw_offset)
            local Angled  = CFrame.new(hrp.Position) * CFrame.Angles(0, Angle+Offset, 0)
            if (aa_mode=="Reverse" or aa_mode=="Random") and silent_aim and silent_aim.target_part then
                local ao=aa_mode=="Random" and math.rad(math.random(-120,120)) or 0
                Angled=CFrame.new(hrp.Position, silent_aim.target_part.Position)*CFrame.Angles(0,math.rad(180)+Offset+ao,0)
            end
            local pos_offset = aa_floor_clip and _aa_floor_v3 or _aa_up_v3
            do
            if aa_custom_offset then
                local rx,ry,rz=math.random()-0.5,math.random()-0.5,math.random()-0.5
                local rand_dir=Vector3.new(rx,ry,rz)
                if rand_dir.Magnitude>0 then
                    _aa_custom_filter[1]=char
                    _aa_custom_rp.FilterDescendantsInstances=_aa_custom_filter
                    local dist_v=math.random()*aa_custom_offset_radius
                    local rayResult=workspace:Raycast(hrp.Position, rand_dir.Unit*dist_v, _aa_custom_rp)
                    if rayResult then pos_offset=pos_offset+(rand_dir.Unit*math.max(0,(rayResult.Position-hrp.Position).Magnitude-0.5))
                    else pos_offset=pos_offset+(rand_dir.Unit*dist_v) end
                end
            end
            local recently_shot = silent_aim and silent_aim._exact_fire_tick and (tick()-silent_aim._exact_fire_tick<0.05)
            local spoof_pos
            if recently_shot and silent_aim and silent_aim.manipulated_origin then
                spoof_pos=hrp.Position+(silent_aim.manipulated_origin-Camera.CFrame.Position)
            elseif fake_lag_enabled and fake_lag_CFrame then
                spoof_pos=fake_lag_CFrame.Position+pos_offset
            else spoof_pos=hrp.Position+pos_offset end
            if recently_shot and silent_aim and silent_aim.manipulated_origin then
                hrp.CFrame=CFrame.new(spoof_pos)*CFrame.Angles(0,select(2,hrp.CFrame:ToOrientation()),0)
            elseif aa_enabled then
                local _X,Y,_Z=Angled:ToOrientation()
                if aa_mode=="FlatRandom" then hrp.CFrame=CFrame.new(spoof_pos)*CFrame.Angles(0,Y,0)*CFrame.Angles(math.rad(90),0,0)
                else hrp.CFrame=CFrame.new(spoof_pos)*CFrame.Angles(0,Y,0) end
            elseif fake_lag_enabled and fake_lag_CFrame then
                hrp.CFrame=fake_lag_CFrame
            elseif fake_lag_enabled then
                hrp.CFrame=CFrame.new(spoof_pos)*CFrame.Angles(0,select(2,hrp.CFrame:ToOrientation()),0)
            end
            local pitch_to_send=aa_pitch_value
            if aa_mode=="FlatRandom" then pitch_to_send=250 end
            ReplicatedStorage.Remotes.UpdateTilt:FireServer(pitch_to_send)
            end -- do
        end)
    end)
end

local function Notify(txt, duration, color)
    Library:Notification(txt, duration or 3, color or Color3.fromRGB(63, 201, 176))
end



task.wait(0.2)
Library.Holder.Instance.Enabled = false
local logoAsset = isfile("tomboy.hook/Assets/logo.png") and getcustomasset("tomboy.hook/Assets/logo.png") or nil
local Window     = Library:Window({ Name = "Kn v1.0.0 PREMIUM", Logo = logoAsset or "" })
local Watermark  = Window:Watermark("Kn v1.0.0 PREMIUM")
local KeybindList= Window:KeybindList()

local CombatPage  = Window:Page({ Name = "Combat"  })
local VisualsPage = Window:Page({ Name = "Visuals" })
local MiscPage    = Window:Page({ Name = "Misc"    })

local AimbotCat  = CombatPage
local TrigBotCat = CombatPage
local GunModCat  = CombatPage
local AntiAimCat = CombatPage
local TPKillCat  = CombatPage
local PlrESPCat  = VisualsPage
local CrpESPCat  = VisualsPage
local CrossCat   = MiscPage
local WorldCat      = MiscPage
local OtherCat      = VisualsPage
local CamEffectCat  = MiscPage
local ViewMdCat  = MiscPage
local FreecamCat = MiscPage

local InvCat     = MiscPage
local MoveCat    = MiscPage
local FlyCat     = MiscPage
local SoundCat   = MiscPage
local DetectCat  = MiscPage
local ConfigCat  = MiscPage
local HitLogCat  = MiscPage

local SettingsPage = Library:CreateSettingsPage(Window, KeybindList, Watermark)

-- ================================================================
-- TEST BUILD 2
-- Favorites, quick access, ESP presets, performance monitor and autosave.
-- ================================================================
do
    local TestTools = SettingsPage:Section({Name = "Test Build 2", Side = 1})

    local function safe_flag(flag, value)
        pcall(function()
            if Library.SetFlags and Library.SetFlags[flag] then
                Library.SetFlags[flag](value)
            else
                Library.Flags[flag] = value
            end
        end)
    end

    -- Performance monitor
    local PerfLabel = TestTools:Label("FPS: --  |  Ping: --  |  Players: --")
    local perf_enabled = true
    local perf_last = os.clock()
    local perf_frames = 0

    TestTools:Toggle({
        Name = "Performance Monitor",
        Flag = "test2_performance_monitor",
        Default = true,
        Callback = function(Value)
            perf_enabled = Value
            if not Value then
                PerfLabel:SetText("Performance Monitor: Off")
            end
        end
    })

    Library:Connect(RunService.RenderStepped, function()
        if not perf_enabled then return end
        perf_frames = perf_frames + 1
        local now = os.clock()
        if now - perf_last >= 1 then
            local fps = math.floor((perf_frames / (now - perf_last)) + 0.5)
            perf_frames = 0
            perf_last = now
            local ping = "--"
            pcall(function()
                local stats = game:GetService("Stats")
                local network = stats:FindFirstChild("Network")
                local server = network and network:FindFirstChild("ServerStatsItem")
                local item = server and server:FindFirstChild("Data Ping")
                if item then ping = tostring(math.floor(item:GetValue() + 0.5)) .. " ms" end
            end)
            PerfLabel:SetText(string.format("FPS: %d  |  Ping: %s  |  Players: %d", fps, ping, #Players:GetPlayers()))
        end
    end, "test2_performance")

    -- Favorite features. These are shortcuts to the existing pages, not new feature implementations.
    local FavoriteNames = {
        "Silent Aim", "Player ESP", "Chams", "Crosshair", "Freecam", "Boss Checklist"
    }
    local FavoritePages = {
        ["Silent Aim"] = CombatPage,
        ["Player ESP"] = VisualsPage,
        ["Chams"] = VisualsPage,
        ["Crosshair"] = MiscPage,
        ["Freecam"] = MiscPage,
        ["Boss Checklist"] = MiscPage,
    }
    local Favorites = {}
    local FavoriteSlots = {}

    TestTools:Dropdown({
        Name = "Favorites",
        Flag = "test2_favorites",
        Multi = true,
        Items = FavoriteNames,
        Default = {},
        Callback = function(Value)
            Favorites = type(Value) == "table" and Value or {}
            for i = 1, 4 do
                local slot = FavoriteSlots[i]
                if slot then
                    local name = nil
                    local count = 0
                    for _, candidate in ipairs(FavoriteNames) do
                        if Favorites[candidate] then
                            count = count + 1
                            if count == i then name = candidate break end
                        end
                    end
                    slot:SetText(name and ("★ " .. name) or ("Favorite " .. i .. ": empty"))
                    slot._favorite_name = name
                end
            end
        end
    })

    for i = 1, 4 do
        local button = TestTools:Button({
            Name = "Favorite " .. i .. ": empty",
            Callback = function()
                local name = button._favorite_name
                local page = name and FavoritePages[name]
                if page then
                    Window:SetOpen(true)
                    page:Turn(true)
                end
            end
        })
        FavoriteSlots[i] = button
    end

    -- Quick access to the most-used pages.
    local Quick = SettingsPage:Section({Name = "Quick Access", Side = 1})
    local function quick_button(label, page)
        Quick:Button({
            Name = label,
            Callback = function()
                Window:SetOpen(true)
                page:Turn(true)
            end
        })
    end
    quick_button("Combat", CombatPage)
    quick_button("Visuals", VisualsPage)
    quick_button("Misc", MiscPage)

    -- ESP presets. Existing controls are changed through their normal callbacks.
    local Presets = SettingsPage:Section({Name = "ESP Presets", Side = 2})
    local function set_esp_flags(values)
        for flag, value in pairs(values) do safe_flag(flag, value) end
        pcall(function() cheat.EspLibrary.icaca() end)
    end

    Presets:Button({Name = "Minimal", Callback = function()
        set_esp_flags({
            esp_on=true, esp_box=true, esp_boxfill=false, esp_name=true, esp_health=false,
            esp_dist=true, esp_weapon=false, esp_skeleton=false, esp_chams=false, esp_outline=false
        })
    end})
    Presets:Button({Name = "Competitive", Callback = function()
        set_esp_flags({
            esp_on=true, esp_box=true, esp_boxfill=false, esp_name=true, esp_health=true,
            esp_dist=true, esp_weapon=true, esp_skeleton=true, esp_chams=false, esp_outline=true
        })
    end})
    Presets:Button({Name = "Full", Callback = function()
        set_esp_flags({
            esp_on=true, esp_box=true, esp_boxfill=true, esp_name=true, esp_health=true,
            esp_dist=true, esp_weapon=true, esp_skeleton=true, esp_chams=true, esp_chams_outline=true,
            esp_outline=true
        })
    end})
    Presets:Button({Name = "Performance", Callback = function()
        set_esp_flags({
            esp_on=true, esp_box=true, esp_boxfill=false, esp_name=true, esp_health=false,
            esp_dist=true, esp_weapon=false, esp_skeleton=false, esp_chams=false, esp_outline=false
        })
    end})

    -- Auto-save the current configuration every 10 seconds.
    local autosave_enabled = false
    local autosave_path = nil
    pcall(function()
        if makefolder and not isfolder("tomboy.hook") then makefolder("tomboy.hook") end
        if makefolder and not isfolder("tomboy.hook/Configs") then makefolder("tomboy.hook/Configs") end
        autosave_path = (Library.Folders and Library.Folders.Configs or "tomboy.hook/Configs") .. "/test2_autosave.json"
    end)

    TestTools:Toggle({
        Name = "Auto-save",
        Flag = "test2_autosave",
        Default = false,
        Callback = function(Value)
            autosave_enabled = Value
            if Value then Library:Notification("Auto-save enabled", 3) end
        end
    })

    Library:Thread(function()
        while true do
            task.wait(10)
            if autosave_enabled and autosave_path and writefile then
                pcall(function()
                    local config = Library:GetConfig()
                    if type(config) == "string" and #config > 0 then
                        writefile(autosave_path, config)
                    end
                end)
            end
        end
    end)
end


do
    local AimL = AimbotCat:Section({ Name = "Silent Aim", Side = 1 })
    local AimR = AimbotCat:Section({ Name = "Options",    Side = 2 })

    AimL:Toggle({ Name="Silent Aim",           Flag="sa_enabled",        Callback=function(v) silent_aim.enabled=v end })
    AimL:Dropdown({ Name="Aim Part",           Flag="sa_hitreg",          Default="Head", Options={"Head","FaceHitBox","HeadTopHitbox","UpperTorso","LowerTorso","HumanoidRootPart","LeftFoot","LeftLowerLeg","LeftUpperLeg","LeftHand","LeftLowerArm","LeftUpperArm","RightFoot","RightLowerLeg","RightUpperLeg","RightHand","RightLowerArm","RightUpperArm"}, Callback=function(v) silent_aim.part=v end })
    AimL:Toggle({ Name="Randomize Hit Part",   Flag="sa_random_part",     Callback=function(v) silent_aim.random_part=v end })
    AimL:Toggle({ Name="Instant Hit",          Flag="sa_instant",         Callback=function(v) silent_aim.instant=v end })
    AimL:Toggle({ Name="Wallbang",             Flag="sa_wallbang",        Callback=function(v) silent_aim.testwallbang=v end })
    AimL:Toggle({ Name="Manipulation",         Flag="sa_corner",          Callback=function(v) silent_aim.corner_shoot=v end })
    AimL:Slider({ Name="Manipulation Distance",Flag="sa_corner_dist",     Min=5,Max=50,Increment=1, Callback=function(v) silent_aim.corner_shoot_dist=v end })
    AimL:Toggle({ Name="Crosshair Status",     Flag="sa_crosshairstat",   Callback=function(v) silent_aim.crosshair_status=v end })
    AimL:Toggle({ Name="Target AI",            Flag="sa_npcaim",          Callback=function(v) silent_aim.target_npc=v end })
    AimL:Toggle({ Name="Target Heli",          Flag="sa_heliaim",         Callback=function(v) silent_aim.target_heli=v end })
    AimL:Toggle({ Name="Use FOV",              Flag="sa_fov",             Callback=function(v) silent_aim.fov=v end })
    AimL:Toggle({ Name="Show FOV Circle",      Flag="sa_fov_show",        Callback=function(v) silent_aim.fov_show=v end }):Colorpicker({ Flag="sa_fov_color",       Default=Color3.new(1,1,1), Alpha=0, Callback=function(v) silent_aim.fov_color=v end })
    AimL:Toggle({ Name="Target Line",          Flag="sa_target_line",     Default=false, Callback=function(v) silent_aim.target_line=v end })
    AimL:Toggle({ Name="Visible Targets Only",  Flag="sa_visible_only",     Default=true, Callback=function(v) silent_aim.visible_only=v end })
    AimL:Toggle({ Name="FOV Outline Glow",     Flag="sa_fov_outline",     Callback=function(v) silent_aim.fov_outline=v end })
    AimL:Slider({ Name="FOV Size",             Flag="sa_fov_size",        Min=10,Max=1000,Increment=1, Callback=function(v) silent_aim.fov_size=v end })
    AimL:Slider({ Name="FOV Glow Intensity",   Flag="sa_fov_glow",        Min=1,Max=100,Increment=1, Callback=function(v) silent_aim.fov_glow_intensity=v/10 end })

    -- Player whitelist. Kaene_zy is always present as a locked/native entry.
    local sa_whitelist_dropdown
    do
        local initial_players = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            table.insert(initial_players, plr.Name)
        end
        table.sort(initial_players, function(a,b) return string.lower(a) < string.lower(b) end)

        sa_whitelist_dropdown = AimL:Dropdown({
            Name = "Whitelist Players",
            Flag = "sa_whitelist_players",
            Options = initial_players,
            Multi = true,
            Default = {},
            Locked = { ["Kaene_zy"] = true },
            Callback = function(values)
                silent_aim.whitelist = {}
                if type(values) == "table" then
                    for _, name in ipairs(values) do
                        if name ~= "Kaene_zy" then
                            silent_aim.whitelist[name] = true
                        end
                    end
                end
            end
        })
    end

    AimL:Toggle({
        Name = "Whitelist Mode",
        Flag = "sa_whitelist_mode",
        Default = false,
        Callback = function(v)
            silent_aim.whitelist_mode = v
        end
    })

    local function refresh_silent_aim_whitelist()
        if not sa_whitelist_dropdown then return end

        local selected = {}
        for name in pairs(silent_aim.whitelist) do
            selected[name] = true
        end

        local names = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            table.insert(names, plr.Name)
        end
        table.sort(names, function(a,b) return string.lower(a) < string.lower(b) end)

        local has_native = false
        for _, name in ipairs(names) do
            if name == "Kaene_zy" then
                has_native = true
                break
            end
        end
        if not has_native then
            table.insert(names, "Kaene_zy")
            table.sort(names, function(a,b) return string.lower(a) < string.lower(b) end)
        end

        sa_whitelist_dropdown:Refresh(names)

        local restored = {}
        for _, name in ipairs(names) do
            if name ~= "Kaene_zy" and selected[name] then
                table.insert(restored, name)
            end
        end

        if #restored > 0 then
            sa_whitelist_dropdown:Set(restored)
        else
            sa_whitelist_dropdown:Set({})
            silent_aim.whitelist = {}
        end
    end

    Library:Connect(Players.PlayerAdded, refresh_silent_aim_whitelist)
    Library:Connect(Players.PlayerRemoving, function(plr)
        silent_aim.whitelist[plr.Name] = nil
        refresh_silent_aim_whitelist()
    end)

    AimR:Toggle({ Name="Bullet Tracer",        Flag="sa_tracer",          Callback=function(v) silent_aim.tracer=v end }):Colorpicker({ Flag="sa_tracer_color",    Default=Color3.new(1,1,1), Alpha=0, Callback=function(v) silent_aim.tracer_color=v end })
    AimR:Label("Tracer Pulse"):Colorpicker({ Flag="sa_tracer_color2",   Default=Color3.fromRGB(0,128,255), Alpha=0, Callback=function(v) silent_aim.tracer_color2=v end })
    AimR:Dropdown({ Name="Tracer Style",       Flag="sa_tracer_style",    Options={"Tracer 1","Tracer 2"}, Callback=function(v) silent_aim.tracer_style=v end })
    AimR:Slider({ Name="Tracer Thickness",     Flag="sa_tracer_thick",    Min=1,Max=100,Increment=1, Callback=function(v) silent_aim.tracer_thickness=v/10 end })
    AimR:Slider({ Name="Tracer Lifetime",      Flag="sa_tracer_life",     Min=1,Max=50,Increment=1, Callback=function(v) silent_aim.tracer_lifetime=v/10 end })
    AimR:Toggle({ Name="Instant Equip",        Flag="instant_equip",      Callback=function(v) instant_equip=v end })
    Library:Connect(Camera.ChildAdded, function(child)
        if not instant_equip then return end
        if child.Name == Players.LocalPlayer.Name then return end
        if not child:IsA("Model") then return end
        task.spawn(function()
            local iters = 0
            while child.Parent and iters < 500 do
                iters += 1
                local hum = child:FindFirstChildOfClass("Humanoid")
                if hum and hum.Animator then
                    for _, track in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
                        if track.Animation.Name == "Equip" then
                            pcall(function()
                                track:AdjustSpeed(15)
                                track.TimePosition = track.Length - 0.01
                            end)
                            return
                        end
                    end
                end
                task.wait(0.001)
            end
        end)
    end)
    AimR:Toggle({ Name="Auto Shoot Packet",    Flag="autoshoot_packet",   Callback=function(v) packetautoshoot=v end })
    AimR:Toggle({ Name="Packet Prediction",    Flag="packetpred_tog",     Callback=function(v) packetpred=v end })
    AimR:Toggle({ Name="Hitscan",              Flag="packetscan_tog",     Callback=function(v) packetscan=v end })
    AimR:Toggle({ Name="Hitscan Walls",        Flag="packetthruscan_tog", Callback=function(v) packetthruscan=v end })
    AimR:Slider({ Name="Shoot Speed Mult",     Flag="shootspeed_slider",  Min=1,Max=30,Increment=1, Default=10, Callback=function(v) shootspeed=v/10 end })

    -- Target Info: compact, professional, draggable target panel.
    local TargetInfoGui = Instance.new("ScreenGui")
    TargetInfoGui.Name = "TomboyTargetInfo"
    TargetInfoGui.ResetOnSpawn = false
    TargetInfoGui.IgnoreGuiInset = true
    TargetInfoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TargetInfoGui.Parent = gethui()

    local TargetInfo = Instance.new("Frame")
    TargetInfo.Size = UDim2.new(0, 270, 0, 124)
    TargetInfo.Position = UDim2.new(0.5, -135, 0.78, 0)
    TargetInfo.BackgroundColor3 = Color3.fromRGB(13,16,22)
    TargetInfo.BackgroundTransparency = 0.03
    TargetInfo.BorderSizePixel = 0
    TargetInfo.Active = true
    TargetInfo.Visible = false
    TargetInfo.Parent = TargetInfoGui

    local TargetScale = Instance.new("UIScale")
    TargetScale.Scale = silent_aim.target_info_size
    TargetScale.Parent = TargetInfo

    local TargetCorner = Instance.new("UICorner")
    TargetCorner.CornerRadius = UDim.new(0, 7)
    TargetCorner.Parent = TargetInfo

    local TargetStroke = Instance.new("UIStroke")
    TargetStroke.Color = Color3.fromRGB(58,72,92)
    TargetStroke.Thickness = 1
    TargetStroke.Transparency = 0.15
    TargetStroke.Parent = TargetInfo

    local TargetHeader = Instance.new("Frame")
    TargetHeader.Size = UDim2.new(1,0,0,25)
    TargetHeader.BackgroundColor3 = Color3.fromRGB(19,23,31)
    TargetHeader.BorderSizePixel = 0
    TargetHeader.Active = true
    TargetHeader.Parent = TargetInfo
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0,7)
    HeaderCorner.Parent = TargetHeader

    local HeaderMask = Instance.new("Frame")
    HeaderMask.Size = UDim2.new(1,0,0,8)
    HeaderMask.Position = UDim2.new(0,0,1,-8)
    HeaderMask.BackgroundColor3 = TargetHeader.BackgroundColor3
    HeaderMask.BorderSizePixel = 0
    HeaderMask.Parent = TargetHeader

    local HeaderAccent = Instance.new("Frame")
    HeaderAccent.Size = UDim2.new(0,3,1,0)
    HeaderAccent.BackgroundColor3 = Color3.fromRGB(80,180,255)
    HeaderAccent.BorderSizePixel = 0
    HeaderAccent.Parent = TargetHeader

    local TargetTitle = Instance.new("TextLabel")
    TargetTitle.Size = UDim2.new(1,-14,1,0)
    TargetTitle.Position = UDim2.new(0,10,0,0)
    TargetTitle.BackgroundTransparency = 1
    TargetTitle.Font = Enum.Font.GothamSemibold
    TargetTitle.TextSize = 12
    TargetTitle.TextXAlignment = Enum.TextXAlignment.Left
    TargetTitle.TextColor3 = Color3.fromRGB(225,232,242)
    TargetTitle.Text = "TARGET INFO"
    TargetTitle.Parent = TargetHeader

    local TargetAvatar = Instance.new("ImageLabel")
    TargetAvatar.Size = UDim2.new(0,54,0,54)
    TargetAvatar.Position = UDim2.new(0,8,0,33)
    TargetAvatar.BackgroundColor3 = Color3.fromRGB(25,30,39)
    TargetAvatar.BorderSizePixel = 0
    TargetAvatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    TargetAvatar.Parent = TargetInfo
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0,6)
    AvatarCorner.Parent = TargetAvatar
    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = Color3.fromRGB(55,66,82)
    AvatarStroke.Thickness = 1
    AvatarStroke.Parent = TargetAvatar

    local TargetName = Instance.new("TextLabel")
    TargetName.Size = UDim2.new(1,-72,0,18)
    TargetName.Position = UDim2.new(0,70,0,31)
    TargetName.BackgroundTransparency = 1
    TargetName.Font = Enum.Font.GothamSemibold
    TargetName.TextSize = 12
    TargetName.TextXAlignment = Enum.TextXAlignment.Left
    TargetName.TextColor3 = Color3.fromRGB(92,190,255)
    TargetName.TextTruncate = Enum.TextTruncate.AtEnd
    TargetName.Text = "No target"
    TargetName.Parent = TargetInfo

    local TargetStats = Instance.new("TextLabel")
    TargetStats.Size = UDim2.new(1,-72,0,56)
    TargetStats.Position = UDim2.new(0,70,0,50)
    TargetStats.BackgroundTransparency = 1
    TargetStats.Font = Enum.Font.Gotham
    TargetStats.TextSize = 10
    TargetStats.TextXAlignment = Enum.TextXAlignment.Left
    TargetStats.TextYAlignment = Enum.TextYAlignment.Top
    TargetStats.TextColor3 = Color3.fromRGB(184,193,207)
    TargetStats.Text = "DIST  --   VIS  --\nAIM   --   K/D  --/--\nREPORTS --\nMOD/CHEAT --"
    TargetStats.Parent = TargetInfo

    local TargetHealthBack = Instance.new("Frame")
    TargetHealthBack.Size = UDim2.new(1,-72,0,5)
    TargetHealthBack.Position = UDim2.new(0,8,1,-11)
    TargetHealthBack.BackgroundColor3 = Color3.fromRGB(34,40,49)
    TargetHealthBack.BorderSizePixel = 0
    TargetHealthBack.Parent = TargetInfo
    local HealthCorner = Instance.new("UICorner")
    HealthCorner.CornerRadius = UDim.new(1,0)
    HealthCorner.Parent = TargetHealthBack

    local TargetHealthFill = Instance.new("Frame")
    TargetHealthFill.Size = UDim2.new(1,0,1,0)
    TargetHealthFill.BackgroundColor3 = Color3.fromRGB(65,205,120)
    TargetHealthFill.BorderSizePixel = 0
    TargetHealthFill.Parent = TargetHealthBack
    local HealthFillCorner = Instance.new("UICorner")
    HealthFillCorner.CornerRadius = UDim.new(1,0)
    HealthFillCorner.Parent = TargetHealthFill

    local TargetHealthText = Instance.new("TextLabel")
    TargetHealthText.Size = UDim2.new(0,58,0,12)
    TargetHealthText.Position = UDim2.new(1,-64,1,-15)
    TargetHealthText.BackgroundTransparency = 1
    TargetHealthText.Font = Enum.Font.GothamMedium
    TargetHealthText.TextSize = 9
    TargetHealthText.TextXAlignment = Enum.TextXAlignment.Right
    TargetHealthText.TextColor3 = Color3.fromRGB(140,150,165)
    TargetHealthText.Text = "100/100"
    TargetHealthText.Parent = TargetInfo

    -- Mobile-friendly dragging; disabled while Fixed is enabled.
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragInput = nil
    TargetHeader.InputBegan:Connect(function(input)
        if silent_aim.target_info_locked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = TargetInfo.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging or silent_aim.target_info_locked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            TargetInfo.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    AimL:Toggle({ Name="Target Info", Flag="sa_target_info", Default=false, Callback=function(v)
        silent_aim.target_info = v
        if not v then TargetInfo.Visible = false end
    end })
    AimL:Slider({ Name="Target Info Size", Flag="sa_target_info_size", Min=50, Max=125, Increment=1, Default=75, Callback=function(v)
        silent_aim.target_info_size = v/100
        TargetScale.Scale = silent_aim.target_info_size
    end })
    AimL:Toggle({ Name="Target Info Fixed", Flag="sa_target_info_fixed", Default=false, Callback=function(v)
        silent_aim.target_info_locked = v
    end })

    local target_info_last_player = nil
    local target_info_avatar_token = 0
    local target_info_last_scan = 0
    local target_info_reports = nil
    local target_info_detection = "NONE"
    local function target_info_player_from_character(character)
        if not character then return nil end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character == character then return plr end
        end
        return nil
    end

    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
        if not silent_aim.target_info then TargetInfo.Visible = false; return end
        local part = silent_aim.target_part
        local character = part and part.Parent
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not part or not character or not humanoid or humanoid.Health <= 0 then TargetInfo.Visible = false; return end

        local plr = target_info_player_from_character(character)
        local is_bot = (plr == nil)
        if plr then
            for _, attr_name in ipairs({"IsBot", "Bot", "IsNPC", "NPC"}) do
                if plr:GetAttribute(attr_name) == true then
                    is_bot = true
                    break
                end
            end
        end
        local display = plr and (plr.DisplayName .. "  @" .. plr.Name) or character.Name
        if is_bot then
            display = "BOT  |  " .. character.Name
        end
        TargetName.Text = display
        if plr ~= target_info_last_player then
            target_info_last_player = plr
            target_info_avatar_token += 1
            local token = target_info_avatar_token
            if plr then task.spawn(function()
                local ok, img = pcall(function()
                    return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                end)
                if ok and token == target_info_avatar_token then TargetAvatar.Image = img end
            end) end
        end

        -- Use the exact same distance basis as the Player ESP: Camera -> Head, then / 3.
        local dist = math.floor(((Camera.CFrame.Position - part.Position).Magnitude / 3) + 0.5)

        local kills, deaths = 0, 0
        local reports = target_info_reports
        local mod_or_cheat = target_info_detection
        if plr and not is_bot then
            local rsp = ReplicatedStorage:FindFirstChild("Players")
            local pdata = rsp and rsp:FindFirstChild(plr.Name)
            local status = pdata and pdata:FindFirstChild("Status")
            local journey = status and status:FindFirstChild("Journey")
            local wipe = journey and journey:FindFirstChild("WipeStatistics")
            if wipe then
                kills = wipe:GetAttribute("Kills") or 0
                deaths = wipe:GetAttribute("Deaths") or 0
            end

            if tick() - target_info_last_scan >= 0.5 then
                target_info_last_scan = tick()
                target_info_reports = nil
                target_info_detection = "NONE"

                -- Reuse the detector's current rules for the Target Info display.
                if is_bot then
                    target_info_detection = "BOT"
                else
                    local gameplay = status and status:FindFirstChild("GameplayVariables")
                    local premium = gameplay and gameplay:GetAttribute("PremiumLevel")
                    if premium and premium >= 4 then
                        target_info_detection = "MOD"
                    else
                        local d = math.max(1, deaths)
                        local kdr = kills / d
                        if kills >= 15 and kdr >= 5 then
                            target_info_detection = "CHEAT"
                        end
                    end
                end

                -- Reports: keep a numeric value. A missing exposed counter means 0.
                local report_names = {
                    Reports=true, Report=true, ReportCount=true, ReportsCount=true,
                    TotalReports=true, TotalReport=true,
                    ReceivedReports=true, ReceivedReportCount=true,
                    ReportedCount=true, ReportsReceived=true
                }

                local function read_report_number(value)
                    if type(value) == "number" then
                        return math.max(0, math.floor(value))
                    end
                    local n = tonumber(value)
                    if n then return math.max(0, math.floor(n)) end
                    return nil
                end

                local function find_report_count(root)
                    if not root then return nil end

                    for name in pairs(report_names) do
                        local n = read_report_number(root:GetAttribute(name))
                        if n ~= nil then return n end
                    end

                    for _, obj in ipairs(root:GetDescendants()) do
                        for name in pairs(report_names) do
                            local n = read_report_number(obj:GetAttribute(name))
                            if n ~= nil then return n end
                        end
                        if report_names[obj.Name] then
                            local ok, value = pcall(function() return obj.Value end)
                            if ok then
                                local n = read_report_number(value)
                                if n ~= nil then return n end
                            end
                        end
                    end
                    return nil
                end

                -- Check both the Player instance and its replicated data.
                target_info_reports = find_report_count(plr)
                    or find_report_count(pdata)
                    or 0
            end
            reports = target_info_reports
            mod_or_cheat = target_info_detection
        else
            target_info_reports = nil
            target_info_detection = is_bot and "BOT" or "NONE"
        end

        local vis = silent_aim.isvisible and "YES" or (silent_aim.manipulated and "MANIP" or "NO")
        TargetStats.Text = string.format(
            "DIST  %dm   VIS  %s\nAIM   %s   K/D  %d/%d\nREPORTS %s\nMOD/CHEAT %s",
            dist, vis, tostring(silent_aim.part), kills, deaths,
            tostring(reports or 0),
            mod_or_cheat
        )
        local hp = math.max(0, humanoid.Health)
        local maxhp = math.max(1, humanoid.MaxHealth)
        TargetHealthFill.Size = UDim2.new(math.clamp(hp/maxhp,0,1),0,1,0)
        TargetHealthFill.BackgroundColor3 = hp/maxhp > 0.5 and Color3.fromRGB(65,205,120) or (hp/maxhp > 0.25 and Color3.fromRGB(245,190,65) or Color3.fromRGB(235,75,85))
        TargetHealthText.Text = string.format("%d/%d", math.floor(hp), math.floor(maxhp))
        TargetInfo.Visible = true
    end))

    -- FOV circle drawings
    local CircleInline  = cheat.utility.new_drawing("Circle", {Transparency=1, Thickness=1, ZIndex=2})
    local CSText        = cheat.utility.new_drawing("Text",   {Center=true, Outline=true, Size=16, ZIndex=3, Visible=false})
    local TargetLine    = cheat.utility.new_drawing("Line",   {Thickness=1.5, ZIndex=4, Visible=false})
    local TargetLineDot = cheat.utility.new_drawing("Circle",  {Radius=2.5, Thickness=1, ZIndex=5, Filled=true, Visible=false})
    local fov_glow      = {}
    for i=1,20 do fov_glow[i]=cheat.utility.new_drawing("Circle",{Thickness=1,ZIndex=1,Visible=false}) end
    local _fov_glow_was_visible = false
    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
        local viewport = Camera.ViewportSize
        local pos = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
        local fov_active = (silent_aim.fov and silent_aim.fov_show) == true
        CircleInline.Position = pos
        CircleInline.Radius   = get_silent_fov_radius()
        TargetLineDot.Position = pos
        TargetLineDot.Color = silent_aim.target_part and (silent_aim.isvisible and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,255,255)) or Color3.fromRGB(255,255,255)
        TargetLineDot.Visible = silent_aim.target_line and silent_aim.target_part ~= nil

        if silent_aim.target_line and silent_aim.target_part then
            local target_screen, target_on_screen = Camera:WorldToViewportPoint(silent_aim.target_part.Position)
            if target_on_screen and target_screen.Z > 0 then
                local target_pos = Vector2.new(target_screen.X, target_screen.Y)
                local delta = target_pos - pos
                local magnitude = delta.Magnitude

                -- If Use FOV is active, the line is allowed only for a target
                -- inside that exact same FOV circle.
                local inside_fov = (not silent_aim.fov) or magnitude <= get_silent_fov_radius()
                if inside_fov then
                    if magnitude > 0.001 then
                        -- Start exactly at the center. Since the target is now
                        -- guaranteed to be inside the FOV, this cannot overshoot
                        -- or appear to originate outside the circle.
                        TargetLine.From = pos
                    else
                        TargetLine.From = pos
                    end
                    TargetLine.To = target_pos
                    TargetLine.Color = silent_aim.isvisible and Color3.fromRGB(0,255,0)
                        or (silent_aim.manipulated and Color3.fromRGB(255,255,0) or Color3.fromRGB(255,70,70))
                    TargetLine.Visible = true
                else
                    TargetLine.Visible = false
                end
            else
                TargetLine.Visible = false
            end
        else
            TargetLine.Visible = false
        end
        CircleInline.Color    = silent_aim.fov_color
        CircleInline.Visible  = fov_active
        local gv = fov_active and silent_aim.fov_outline == true
        if gv then
            local intensity = silent_aim.fov_glow_intensity
            local th = 1 + (intensity * 0.5)
            for i = 1, 10 do
                local oc = fov_glow[i]
                oc.Position    = pos
                oc.Radius      = get_silent_fov_radius() + (i * (intensity * 0.5))
                oc.Color       = silent_aim.fov_color
                oc.Transparency= 0.2 - (i * 0.02)
                oc.Thickness   = th
                oc.Visible     = true
                local ic = fov_glow[i + 10]
                ic.Position    = pos
                ic.Radius      = math.max(0, get_silent_fov_radius() - (i * (intensity * 0.5)))
                ic.Color       = silent_aim.fov_color
                ic.Transparency= 0.2 - (i * 0.02)
                ic.Thickness   = th
                ic.Visible     = true
            end
            _fov_glow_was_visible = true
        elseif _fov_glow_was_visible then
            for i = 1, 20 do fov_glow[i].Visible = false end
            _fov_glow_was_visible = false
        end
        if silent_aim.crosshair_status and silent_aim.target_part then
            CSText.Visible  = true
            CSText.Position = pos + Vector2.new(0, (silent_aim.fov and silent_aim.fov_show) and (get_silent_fov_radius() + 5) or 20)
            if silent_aim.isvisible then
                CSText.Text = "visible"; CSText.Color = Color3.new(0,1,0)
            elseif silent_aim.manipulated then
                CSText.Text = "manipulated"; CSText.Color = Color3.new(1,1,0)
            else
                CSText.Text = "hidden"; CSText.Color = Color3.new(1,0,0)
            end
        else
            CSText.Visible = false
        end
    end))
end

do
    local TrigL = TrigBotCat:Section({ Name = "Triggerbot", Side = 1 })
    TrigL:Toggle({ Name="Enabled",              Flag="triggerbot_on",    Callback=function(v) silent_aim.triggerbot=v end }):Keybind({ Flag="triggerbot_key", Mode="Toggle", Callback=function(v) if Library.SetFlags["triggerbot_on"] then Library.SetFlags["triggerbot_on"](v) end end })
    TrigL:Toggle({ Name="Shoot On Manipulated",  Flag="triggerbot_manip", Callback=function(v) silent_aim.triggerbot_manipulation=v end })
end

do
    local GML = GunModCat:Section({ Name = "Gun Mods", Side = 1 })

    GML:Toggle({ Name="No Spread",         Flag="gm_nospread",        Callback=function(v) silent_aim.nospread=v end })
    GML:Toggle({ Name="No Gun Bob",        Flag="gm_nobob",           Callback=function(v) nobob=v end })
    GML:Toggle({ Name="Instant Aim",       Flag="gm_instantaim",      Callback=function(v) instantaim=v end })
    GML:Toggle({ Name="Force Auto",        Flag="gm_forceauto",       Callback=function(v) forceauto=v end })
    GML:Toggle({ Name="Rapid Fire",        Flag="gm_rapidfire",       Callback=function(v) rapid_fire=v end })
    GML:Slider({ Name="Rapid Fire Delay",  Flag="gm_rapidfire_delay", Min=1,Max=50,Increment=1, Callback=function(v) rapid_fire_delay=v/100 end })
    GML:Toggle({ Name="Instant Mosin (R7)",Flag="gm_rapidr7",         Callback=function(v)
        if v then
            for _,a in pairs(ReplicatedStorage.AmmoTypes:GetChildren()) do
                if not original_recoils[a] then original_recoils[a]=a:GetAttribute("RecoilStrength") end
                a:SetAttribute("RecoilStrength",1)
            end
        else
            for _,a in pairs(ReplicatedStorage.AmmoTypes:GetChildren()) do
                if original_recoils[a] then a:SetAttribute("RecoilStrength",original_recoils[a]) end
            end
        end
    end })
    GML:Toggle({ Name="No Recoil",         Flag="gm_norecoil",        Callback=function(v) norecoil=v end })

    -- Instant Mag Refill
    -- Reuses the game's InventoryMove remote to refill partially loaded magazines
    -- from compatible ammo found inside clothing inventories.
    GML:Toggle({ Name="Instant Mag Refill", Flag="gm_instant_mag_refill", Callback=function(v)
        instant_mag_refill = v
    end })
end

-- Instant Mag Refill worker (single persistent loop so toggling does not create duplicate threads)
task.spawn(function()
    while task.wait(0.5) do
        if instant_mag_refill then
            pcall(function()
                local player = Players.LocalPlayer
                local playersFolder = ReplicatedStorage:FindFirstChild("Players")
                local playerData = playersFolder and playersFolder:FindFirstChild(player.Name)
                local inv = playerData and playerData:FindFirstChild("Inventory")
                local itemsList = ReplicatedStorage:FindFirstChild("ItemsList")
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local remote = remotes and remotes:FindFirstChild("InventoryMove")
                if not (inv and itemsList and remote) then return end

                local function getType(item, kind)
                    local itemRef = itemsList:FindFirstChild(item.Name)
                    local props = itemRef and itemRef:FindFirstChild("ItemProperties")
                    if not props then return nil end

                    if kind == "mag" then
                        return props:GetAttribute("AmmoType")
                    elseif kind == "ammo" and props:GetAttribute("ItemType") == "Ammo" then
                        return props:GetAttribute("SlotType")
                    end
                    return nil
                end

                local function getMaxAmmo(item)
                    local itemRef = itemsList:FindFirstChild(item.Name)
                    local props = itemRef and itemRef:FindFirstChild("ItemProperties")
                    return props and props:GetAttribute("MaxLoadedAmmo") or 0
                end

                local mags, ammos = {}, {}

                for _, slot in ipairs(inv:GetChildren()) do
                    local slotAttr = slot:GetAttribute("Slot")
                    if slotAttr and string.find(string.lower(slotAttr), "clothing") then
                        local clothingInv = slot:FindFirstChild("Inventory")
                        if clothingInv then
                            for _, item in ipairs(clothingInv:GetChildren()) do
                                local loadedAmmo = item:GetAttribute("LoadedAmmo")
                                if loadedAmmo ~= nil then
                                    local ammoType = getType(item, "mag")
                                    local maxAmmo = getMaxAmmo(item)
                                    if ammoType and loadedAmmo < maxAmmo then
                                        table.insert(mags, {
                                            slot = item:GetAttribute("Slot"),
                                            ammoType = ammoType,
                                            parent = clothingInv
                                        })
                                    end
                                else
                                    local slotType = getType(item, "ammo")
                                    if slotType then
                                        table.insert(ammos, {
                                            slot = item:GetAttribute("Slot"),
                                            slotType = slotType,
                                            parent = clothingInv
                                        })
                                    end
                                end
                            end
                        end
                    end
                end

                local refilled = 0
                for _, mag in ipairs(mags) do
                    for _, ammo in ipairs(ammos) do
                        if mag.ammoType == ammo.slotType then
                            remote:FireServer(ammo.slot, mag.slot, ammo.parent, mag.parent)
                            refilled += 1
                            task.wait()
                            break
                        end
                    end
                end
                if refilled > 0 then
                    Library:Notification("Instant Mag Refill: " .. tostring(refilled) .. " mag(s) refilled.", 3)
                end
            end)
        end
    end
end)


do
    local AAL = AntiAimCat:Section({ Name = "Anti Aim", Side = 1 })
    local AAR = AntiAimCat:Section({ Name = "Options",  Side = 2 })

    AAL:Toggle({ Name="Enabled",  Flag="aa_enabled",  Callback=function(v)
        aa_enabled = v
        if not v then
            local c=Players.LocalPlayer.Character
            if c and c:FindFirstChildOfClass("Humanoid") then
                c.Humanoid.AutoRotate=true
            end
        end
    end })
    AAL:Dropdown({ Name="Mode",      Flag="aa_mode",      Options={"Reverse","Spin","Random","FlatRandom","None"}, Callback=function(v) aa_mode=v end })
    AAL:Slider({ Name="Yaw Offset",  Flag="aa_yaw",       Min=-360,Max=360,Increment=1, Callback=function(v) aa_yaw_offset=v end })
    AAL:Slider({ Name="Pitch Tilt",  Flag="aa_pitch",     Min=-250,Max=250,Increment=1, Callback=function(v) aa_pitch_value=v end })
    AAL:Toggle({ Name="Fake Lag",    Flag="fakelag_on",   Callback=function(v) fake_lag_enabled=v end }):Keybind({ Flag="fakelag_key", Mode="Toggle", Callback=function(v) if Library.SetFlags["fakelag_on"] then Library.SetFlags["fakelag_on"](v) end end })
    AAL:Slider({ Name="Fake Lag Interval",Flag="fakelag_int",Min=1,Max=7,Increment=1, Callback=function(v) fake_lag_interval=v/10 end })
    AAL:Toggle({ Name="Resolve Desync",   Flag="resolve_desync_tog", Callback=function(v) resolve_desync=v end }):Keybind({ Flag="resolve_desync_key", Mode="Toggle", Callback=function(v) if Library.SetFlags["resolve_desync_tog"] then Library.SetFlags["resolve_desync_tog"](v) end end })

    AAR:Toggle({ Name="Visualize Server Pos",   Flag="vis_server_pos",   Callback=function(v) visualize_server_pos=v end }):Colorpicker({ Flag="vis_server_color", Default=Color3.fromRGB(255,50,50), Alpha=0, Callback=function(v) visualize_color=v end })
    AAR:Slider({ Name="Visualize Transparency", Flag="vis_server_trans", Min=0,Max=100,Increment=1, Callback=function(v) visualize_transparency=v/100 end })
    AAR:Toggle({ Name="Custom Offset",          Flag="aa_cust_offset",   Callback=function(v) aa_custom_offset=v end })
    AAR:Slider({ Name="Offset Radius",          Flag="aa_cust_rad",      Min=1,Max=50,Increment=1, Callback=function(v) aa_custom_offset_radius=v/10 end })
    AAR:Toggle({ Name="Floor Clip",             Flag="aa_floor_clip",    Callback=function(v) aa_floor_clip=v end })
    AAR:Slider({ Name="Floor Clip Depth",       Flag="aa_floor_depth",   Min=0,Max=50,Increment=1, Callback=function(v) aa_floor_clip_depth=v/10; _aa_floor_v3=Vector3.new(0,-aa_floor_clip_depth,0) end })
    AAR:Toggle({ Name="UG Resolver (Hold X)",   Flag="ug_resolver_tog",  Callback=function(v) ug_resolver_enabled=v; if not v then ug_resolver_holding=false end end })
    AAR:Slider({ Name="UG Resolver Depth",      Flag="ug_resolver_d",    Min=5,Max=100,Increment=1, Callback=function(v) ug_resolver_depth=v end })
end

do
    local TPL = TPKillCat:Section({ Name = "TP Kill", Side = 1 })
    local TPR = TPKillCat:Section({ Name = "Options", Side = 2 })

    TPL:Toggle({ Name="TP Kill",       Flag="tpkill_on",       Callback=function(v)
        tpkill_enabled = v
        local char=Players.LocalPlayer.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if v then
            if tick()-tpkill_last_used < 5 then
                Library.SetFlags["tpkill_on"](false)
                Notify("TP Kill on cooldown!")
                return
            end
            local tp = silent_aim and silent_aim.target_part
            if tp then
                current_tp_target   = tp
                tpkill_original_cf  = hrp.CFrame
                tpkill_start_time   = tick()
                fake_platform       = Instance.new("Part")
                fake_platform.Size           = Vector3.new(10,1,10)
                fake_platform.Anchored       = true
                fake_platform.CanCollide     = true
                fake_platform.Transparency   = 1
                fake_platform.Name           = "TPKillPlatform"
                fake_platform.Parent         = workspace
                hrp.CFrame = CFrame.new(current_tp_target.Position + _tpkill_h_v3) * hrp.CFrame.Rotation
                Notify("TP Kill: Teleported!")
            else
                current_tp_target = nil
                Library.SetFlags["tpkill_on"](false)
                Notify("TP Kill: No target")
            end
        else
            if tpkill_original_cf then tpkill_last_used = tick() end
            if tpkill_original_cf and hrp then
                hrp.CFrame = tpkill_original_cf + Vector3.new(0,2,0)
                if cheat.real_CFrame then cheat.real_CFrame = hrp.CFrame end
                hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Landed) end
                tpkill_original_cf = nil
                current_tp_target  = nil
                Notify("TP Kill: Returned")
                if fake_platform then fake_platform:Destroy(); fake_platform=nil end
            end
        end
    end }):Keybind({ Flag="tpkill_key", Mode="Toggle", Callback=function(v) if Library.SetFlags["tpkill_on"] then Library.SetFlags["tpkill_on"](v) end end })
    TPL:Toggle({ Name="Show Charge Bar",   Flag="tpkill_bar",       Default=false, Callback=function(v) tpkill_show_bar=v end })
    TPR:Slider({ Name="Height Offset",     Flag="tpkill_h",         Min=5,Max=300,Increment=1, Callback=function(v)
        tpkill_height=v; _tpkill_h_v3=Vector3.new(0,v,0)
        if tpkill_enabled then
            local char=Players.LocalPlayer.Character
            local hrp=char and char:FindFirstChild("HumanoidRootPart")
            if hrp and current_tp_target and current_tp_target.Parent then
                hrp.CFrame=CFrame.new(current_tp_target.Position+_tpkill_h_v3)*hrp.CFrame.Rotation
            end
        end
    end })
    TPR:Toggle({ Name="Auto Look At Target",Flag="tpkill_autolook", Callback=function(v) tpkill_autolook=v end })
    TPR:Toggle({ Name="Auto Triggerbot",   Flag="tpkill_autotbot",  Callback=function(v) tpkill_autotbot=v end })

    -- TP Kill charge bar
    local _tpbar_ready    = Color3.fromRGB(80,210,80)
    local _tpbar_cooldown = Color3.fromRGB(120,120,120)

    local tpk_gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    tpk_gui.Name = "TPKillBarGUI"; tpk_gui.DisplayOrder=1000; tpk_gui.IgnoreGuiInset=true

    -- two-layer glow: inner tight, outer soft falloff
    local tpk_glow = Instance.new("Frame", tpk_gui)
    tpk_glow.BackgroundTransparency=0.87; tpk_glow.BorderSizePixel=0; tpk_glow.ZIndex=0; tpk_glow.Visible=false
    Instance.new("UICorner", tpk_glow).CornerRadius=UDim.new(0,7)
    local tpk_glow2 = Instance.new("Frame", tpk_gui)
    tpk_glow2.BackgroundTransparency=0.94; tpk_glow2.BorderSizePixel=0; tpk_glow2.ZIndex=0; tpk_glow2.Visible=false
    Instance.new("UICorner", tpk_glow2).CornerRadius=UDim.new(0,11)

    -- main bar: grey background, accent stroke
    local tpk_outer = Instance.new("Frame", tpk_gui)
    tpk_outer.BorderSizePixel=0; tpk_outer.Visible=false; tpk_outer.ZIndex=1
    Instance.new("UICorner", tpk_outer).CornerRadius=UDim.new(0,4)
    local _os = Instance.new("UIStroke", tpk_outer); _os.Thickness=1; _os.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

    local tpk_label = Instance.new("TextLabel", tpk_gui)
    tpk_label.BackgroundTransparency=1; tpk_label.ZIndex=2
    tpk_label.Font=Enum.Font.GothamBold; tpk_label.TextSize=10; tpk_label.TextXAlignment=Enum.TextXAlignment.Center
    tpk_label.TextStrokeTransparency=0.35; tpk_label.TextStrokeColor3=Color3.new(0,0,0)
    tpk_label.Size=UDim2.new(0,140,0,14)

    local _bar_cached_accent, _bar_cached_bg
    cheat.utility.new_heartbeat(function()
        local now        = tick()
        local is_active  = tpkill_enabled
        local time_since = now - tpkill_last_used
        local progress
        if is_active then
            progress = math.clamp(1-((now-tpkill_start_time)/5),0,1)
        else
            progress = math.clamp(time_since/5,0,1)
        end
        local accent = Library.Theme["Accent"]
        local bg     = Library.Theme["Background 1"]
        if accent ~= _bar_cached_accent or bg ~= _bar_cached_bg then
            _bar_cached_accent = accent
            _bar_cached_bg     = bg
            tpk_outer.BackgroundColor3 = bg
            _os.Color                  = accent
            tpk_glow.BackgroundColor3  = accent
            tpk_glow2.BackgroundColor3 = accent
        end
        if tpkill_show_bar then
            local vp     = Camera.ViewportSize
            local bw, bh = 140, 5
            local bx     = vp.X/2 - bw/2
            local by     = vp.Y/2 + 22
            tpk_outer.Visible  = true
            tpk_outer.Size     = UDim2.new(0,bw,0,bh)
            tpk_outer.Position = UDim2.new(0,bx,0,by)
            tpk_label.Position = UDim2.new(0,bx,0,by+bh+4)

            local text_col, label_txt
            if is_active then
                text_col  = accent
                label_txt = "ACTIVE  "..math.ceil(5*(1-progress)).."s"
            elseif progress >= 1 then
                text_col  = _tpbar_ready
                label_txt = "READY"
            else
                text_col  = _tpbar_cooldown
                label_txt = "COOLDOWN  "..math.ceil(5*(1-progress)).."s"
            end
            tpk_label.Text       = label_txt
            tpk_label.TextColor3 = text_col

            tpk_glow.Visible           = true
            tpk_glow.Size              = UDim2.new(0, bw+6,  0, bh+6)
            tpk_glow.Position          = UDim2.new(0, bx-3,  0, by-3)
            tpk_glow2.Visible          = true
            tpk_glow2.Size             = UDim2.new(0, bw+14, 0, bh+14)
            tpk_glow2.Position         = UDim2.new(0, bx-7,  0, by-7)
        else
            tpk_outer.Visible  = false
            tpk_glow.Visible   = false
            tpk_glow2.Visible  = false
            tpk_label.Text     = ""
        end
        if not tpkill_enabled then return end
        if now - tpkill_start_time >= 5 then Library.SetFlags["tpkill_on"](false); return end
        local char = Players.LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and current_tp_target and current_tp_target.Parent then
            local frozen = current_tp_target.Position + _tpkill_h_v3
            hrp.CFrame   = CFrame.new(frozen) * hrp.CFrame.Rotation
            if fake_platform then fake_platform.CFrame = CFrame.new(frozen + _tpkill_plat_v3) end
        end
    end)

    RunService:BindToRenderStep("TPKillAutoLook",201,function()
        if tpkill_enabled and tpkill_autolook and current_tp_target and current_tp_target.Parent then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, current_tp_target.Position)
        end
    end)

    Players.LocalPlayer.CharacterRemoving:Connect(function()
        if fake_platform then fake_platform:Destroy(); fake_platform = nil end
        if tpkill_enabled and Library.SetFlags["tpkill_on"] then
            Library.SetFlags["tpkill_on"](false)
        end
        current_tp_target  = nil
        tpkill_original_cf = nil
    end)
end

do
    local es    = cheat.EspLibrary.settings.enemy
    local ESPL  = PlrESPCat:Section({ Name = "Player ESP", Side = 1 })
    local ESPR  = PlrESPCat:Section({ Name = "Options",    Side = 2 })

    ESPL:Dropdown({ Name="Font",            Flag="esp_font",         Options=Library:GetGlobalFontOptions(), Callback=function(v)
        cheat.EspLibrary.main_settings.textFont = Library.FontDrawingMap[v] or Drawing.Fonts.Monospace
        cheat.EspLibrary.icaca()
    end })
    ESPL:Slider({ Name="Font Size",         Flag="esp_fontsize",     Min=1,Max=30,Increment=1,Default=14, Callback=function(v) cheat.EspLibrary.main_settings.textSize=v; cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Infinite Range", Flag="esp_infinite", Callback=function(v)
        cheat.EspLibrary.main_settings.infiniterange = v
        if v then
            -- Infinite Range uses a large internal distance while keeping the UI slider capped at 1000m.
            cheat.EspLibrary.main_settings.maxdistance = 30000 * 3
            cheat.EspLibrary.main_settings.distancelimit = true
        else
            local slider_value = tonumber(Library.Flags.esp_distance) or 400
            cheat.EspLibrary.main_settings.maxdistance = slider_value * 3
            cheat.EspLibrary.main_settings.distancelimit = true
        end
        cheat.EspLibrary.icaca()
    end })
    ESPL:Slider({ Name="ESP Distance", Flag="esp_distance", Min=50, Max=1000, Increment=10, Default=400, Callback=function(v)
        if not cheat.EspLibrary.main_settings.infiniterange then
            cheat.EspLibrary.main_settings.maxdistance = v * 3
        end
        cheat.EspLibrary.main_settings.distancelimit = true
        cheat.EspLibrary.icaca()
    end })
    ESPL:Toggle({ Name="Enable ESP",        Flag="esp_on",           Callback=function(v) es.enabled=v; cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Visible Check",     Flag="esp_visible_check", Default=true, Callback=function(v) es.visible_check=v; cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="ESP Outline",        Flag="esp_outline", Default=false, Callback=function(v) es.outline=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_outline_col", Default=Color3.fromRGB(255,255,255), Alpha=1, Callback=function(v) local f=Library.Flags.esp_outline_col; es.outline_color[1]=v; es.outline_color[2]=(f and f.Alpha or 1); cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Outline Visible Check", Flag="esp_outline_visible", Default=true, Callback=function(v) es.outline_visible_check=v; cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Box ESP",              Flag="esp_box",          Callback=function(v) es.box=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_boxcol",         Default=Color3.new(1,1,1), Alpha=1,   Callback=function(v) local f=Library.Flags.esp_boxcol;         es.box_color[1]=v;             es.box_color[2]=(f and f.Alpha or 1);             cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Box Fill",             Flag="esp_boxfill",      Callback=function(v) es.box_fill=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_boxfillcol",     Default=Color3.new(1,1,1), Alpha=0.5, Callback=function(v) local f=Library.Flags.esp_boxfillcol;     es.box_fill_color[1]=v;        es.box_fill_color[2]=(f and f.Alpha or 0.5);       cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Name ESP",             Flag="esp_name",         Callback=function(v) es.realname=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_namecol",        Default=Color3.new(1,1,1), Alpha=1,   Callback=function(v) local f=Library.Flags.esp_namecol;        es.realname_color[1]=v;        es.realname_color[2]=(f and f.Alpha or 1);         cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Health Bar",           Flag="esp_health",       Callback=function(v) es.health=v; cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Distance",             Flag="esp_dist",         Callback=function(v) es.dist=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_distcol",        Default=Color3.new(1,1,1), Alpha=1,   Callback=function(v) local f=Library.Flags.esp_distcol;        es.dist_color[1]=v;            es.dist_color[2]=(f and f.Alpha or 1);             cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Text Outline",         Flag="esp_dist_outline", Callback=function(v) es.dist_outline=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_dist_outcol",   Default=Color3.new(0,0,0), Alpha=1,   Callback=function(v) es.dist_outline_color=v;     cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Weapon ESP",           Flag="esp_weapon",       Callback=function(v) es.weapon=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_wpcol",         Default=Color3.new(1,1,1), Alpha=1,   Callback=function(v) local f=Library.Flags.esp_wpcol;         es.weapon_color[1]=v;          es.weapon_color[2]=(f and f.Alpha or 1);           cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Skeleton",             Flag="esp_skeleton",     Callback=function(v) es.skeleton=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_skelcol",       Default=Color3.new(1,1,1), Alpha=1,   Callback=function(v) local f=Library.Flags.esp_skelcol;       es.skeleton_color[1]=v;        es.skeleton_color[2]=(f and f.Alpha or 1);         cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Chams",                Flag="esp_chams",        Callback=function(v) es.chams=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_chamscol",    Default=Color3.fromRGB(255,255,255), Alpha=0.7, Callback=function(v) local f=Library.Flags.esp_chamscol;    es.chams_fill_color[1]=v;   es.chams_fill_color[2]=(f and f.Alpha or 0.7); cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Chams Outline",        Flag="esp_chams_outline", Callback=function(v) es.chams_outline=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_chamsoutcol", Default=Color3.fromRGB(255,255,255), Alpha=0, Callback=function(v) local f=Library.Flags.esp_chamsoutcol; es.chamsoutline_color[1]=v; es.chamsoutline_color[2]=(f and f.Alpha or 0); cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Chams Visible Only",   Flag="esp_chams_vis",    Callback=function(v) es.chams_visible_only=v; cheat.EspLibrary.icaca() end })
    ESPL:Dropdown({ Name="Chams Material",     Flag="esp_chams_mat",    Options={"Neon","ForceField","Glass","SmoothPlastic","Wireframe"}, Callback=function(v) es.chams_material=v; cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Rainbow Chams",        Flag="esp_chams_rainbow", Callback=function(v) es.chams_rainbow=v end })
    ESPL:Toggle({ Name="Pulse Chams",          Flag="esp_chams_pulse",   Callback=function(v) es.chams_pulse=v end })
    ESPL:Toggle({ Name="Visible Split Chams",  Flag="esp_chams_split",   Callback=function(v) es.chams_visible_split=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="esp_chams_occ_col", Default=Color3.fromRGB(255,50,50), Alpha=0.5, Callback=function(v) local f=Library.Flags.esp_chams_occ_col; es.chams_occluded_color[1]=v; es.chams_occluded_color[2]=(f and f.Alpha or 0.5); cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Health Color Chams",   Flag="esp_chams_health",  Callback=function(v) es.chams_health_reactive=v; cheat.EspLibrary.icaca() end })
    ESPL:Toggle({ Name="Outline Pulse Chams",  Flag="esp_chams_outpulse",Callback=function(v) es.chams_outline_pulse=v end })
    ESPL:Toggle({ Name="Strobe Chams",         Flag="esp_chams_strobe",  Callback=function(v) es.chams_strobe=v end })
    ESPL:Slider({ Name="Chams Intensity (0=solid, 0.5=default, 1=fade)", Flag="esp_chams_intensity", Min=0, Max=1, Increment=0.01, Default=0.5, Callback=function(v) es.chams_intensity=v; cheat.EspLibrary.icaca() end })
    ESPL:Slider({ Name="Chams Saturation",     Flag="esp_chams_sat",      Min=0,Max=1,Increment=0.01,Default=1, Callback=function(v) es.chams_saturation=v end })

    ESPR:Label("Health Top"):Colorpicker({ Flag="esp_htop",    Default=Color3.new(0,1,0), Alpha=1, Callback=function(v) es.health_color_top=v;    cheat.EspLibrary.icaca() end })
    ESPR:Label("Health Bottom"):Colorpicker({ Flag="esp_hbottom", Default=Color3.new(1,0,0), Alpha=1, Callback=function(v) es.health_color_bottom=v; cheat.EspLibrary.icaca() end })
    ESPR:Slider({ Name="Health Bar Thickness", Flag="esp_hthick",    Min=1,Max=10,Increment=1, Default=2, Callback=function(v) es.health_thickness=v;   cheat.EspLibrary.icaca() end })
    ESPR:Slider({ Name="Health Glow Size",     Flag="esp_hglowsize", Min=1,Max=20,Increment=1, Default=5, Callback=function(v) es.health_glow_size=v;   cheat.EspLibrary.icaca() end })
end


-- Boss Checklist: small floating panel with a 20-second full-map scan.
do
    local BossNames = {"Dozer", "Anton", "mi24", "whispers"}
    local BossDisplay = {Dozer="Dozer", Anton="Anton", mi24="MI24", whispers="Whispers"}
    local boss_panel_gui, boss_panel, boss_rows = nil, nil, {}
    local boss_enabled = false
    local boss_scan_token = 0

    local function getBossGuiParent()
        local parent
        pcall(function()
            parent = (gethui and gethui()) or game:GetService("CoreGui")
        end)
        return parent or Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local function ensureBossPanel()
        if boss_panel_gui and boss_panel_gui.Parent then return end
        boss_panel_gui = Instance.new("ScreenGui")
        boss_panel_gui.Name = "KnBossChecklist"
        boss_panel_gui.ResetOnSpawn = false
        boss_panel_gui.IgnoreGuiInset = true
        boss_panel_gui.Parent = getBossGuiParent()

        boss_panel = Instance.new("Frame")
        boss_panel.Name = "Panel"
        boss_panel.Size = UDim2.fromOffset(170, 125)
        boss_panel.Position = UDim2.fromOffset(20, 260)
        boss_panel.BackgroundColor3 = Color3.fromRGB(20,20,20)
        boss_panel.BorderSizePixel = 0
        boss_panel.Visible = false
        boss_panel.Parent = boss_panel_gui

        local corner = Instance.new("UICorner", boss_panel)
        corner.CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke", boss_panel)
        stroke.Color = Color3.fromRGB(55,55,55)

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1,-12,0,24)
        title.Position = UDim2.fromOffset(6,3)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextColor3 = Color3.new(1,1,1)
        title.Text = Language == "Portuguese" and "Lista de chefes" or "Boss Checklist"
        title.Parent = boss_panel

        local list = Instance.new("Frame")
        list.Name = "List"
        list.BackgroundTransparency = 1
        list.Position = UDim2.fromOffset(8,28)
        list.Size = UDim2.new(1,-16,1,-34)
        list.Parent = boss_panel
        local layout = Instance.new("UIListLayout", list)
        layout.Padding = UDim.new(0,2)

        for _, name in ipairs(BossNames) do
            local row = Instance.new("TextLabel")
            row.Name = name
            row.BackgroundTransparency = 1
            row.Size = UDim2.new(1,0,0,19)
            row.Font = Enum.Font.Gotham
            row.TextSize = 12
            row.TextXAlignment = Enum.TextXAlignment.Left
            row.TextColor3 = Color3.fromRGB(100,100,100)
            row.Text = (BossDisplay[name] or name) .. "  [Death]"
            row.Parent = list
            boss_rows[name] = row
        end

        local drag = Instance.new("TextButton")
        drag.BackgroundTransparency = 1
        drag.Text = ""
        drag.Size = UDim2.new(1,0,0,26)
        drag.Parent = boss_panel
        drag.ZIndex = 5
        local dragging, dragStart, startPos
        drag.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = boss_panel.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        drag.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                boss_panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    local function findBoss(name)
        local found = false
        local displayName = BossDisplay[name] or name
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and string.lower(obj.Name) == string.lower(name) then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hp = hum and hum.Health or obj:GetAttribute("Health")
                if hp == nil or tonumber(hp) > 0 then
                    found = true
                    break
                end
            end
        end
        return found
    end

    local function scanBosses()
        ensureBossPanel()
        for _, name in ipairs(BossNames) do
            local alive = false
            pcall(function() alive = findBoss(name) end)
            local row = boss_rows[name]
            if row then
                if alive then
                    row.Text = (BossDisplay[name] or name) .. "  [" .. (Language == "Portuguese" and "Vivo" or "Alive") .. "]"
                    row.TextColor3 = Color3.fromRGB(255,165,0)
                else
                    row.Text = (BossDisplay[name] or name) .. "  [" .. (Language == "Portuguese" and "Morto" or "Death") .. "]"
                    row.TextColor3 = Color3.fromRGB(85,85,85)
                end
            end
        end
    end

    local function setBossChecklist(v)
        boss_enabled = v
        ensureBossPanel()
        boss_panel.Visible = v
        boss_scan_token += 1
        local token = boss_scan_token
        if v then
            scanBosses()
            task.spawn(function()
                while boss_enabled and token == boss_scan_token do
                    task.wait(20)
                    if boss_enabled and token == boss_scan_token then scanBosses() end
                end
            end)
        end
    end

    -- A 400 HP NPC is also treated as a boss by the scanner's health rule.
    local oldFindBoss = findBoss
    findBoss = function(name)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hp = hum and hum.Health or tonumber(obj:GetAttribute("Health"))
                if string.lower(obj.Name) == string.lower(name) or (hp and math.floor(hp + 0.5) == 400) then
                    if hp == nil or hp > 0 then return true end
                end
            end
        end
        return false
    end

    local BossCat = MiscPage:Section({Name="Bosses", Side=2})
    BossCat:Toggle({Name="Boss Checklist", Flag="boss_checklist", Default=false, Callback=setBossChecklist})

    -- Keep the panel text synchronized with the language dropdown.
    local oldApplyLanguage = Library.ApplyLanguage
    Library.ApplyLanguage = function(...)
        local result = oldApplyLanguage and oldApplyLanguage(...) or nil
        if boss_panel_gui and boss_panel then
            local title = boss_panel:FindFirstChild("Title")
            if title then title.Text = Language == "Portuguese" and "Lista de chefes" or "Boss Checklist" end
            if boss_enabled then scanBosses() end
        end
        return result
    end
end

do
    local es  = cheat.EspLibrary.settings.corpse
    local CrpL= CrpESPCat:Section({ Name = "Corpse ESP", Side = 1 })
    CrpL:Toggle({ Name="Enable",          Flag="cesp_on",       Callback=function(v) es.enabled=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="cesp_col",      Default=Color3.fromRGB(190,85,0), Alpha=0, Callback=function(v) es.color=v; cheat.EspLibrary.icaca() end })
    CrpL:Toggle({ Name="Show Name",       Flag="cesp_name",     Default=true, Callback=function(v) es.name=v; cheat.EspLibrary.icaca() end })
    CrpL:Toggle({ Name="Show Distance",   Flag="cesp_dist",     Callback=function(v) es.distance=v; cheat.EspLibrary.icaca() end })
    CrpL:Toggle({ Name="Outline",         Flag="cesp_outline",  Callback=function(v) es.outline=v; cheat.EspLibrary.icaca() end }):Colorpicker({ Flag="cesp_outcol", Default=Color3.new(0,0,0), Alpha=0, Callback=function(v) es.outline_color=v; cheat.EspLibrary.icaca() end })
end

do
    local cursor = {
        Enabled=false, Speed=0.5, Radius=25, Color=Color3.fromRGB(180,50,255),
        Thickness=1.7, Outline=false, Resize=false, Dot=false, Gap=10, TheGap=false,
        Font=Drawing.Fonts.Monospace, rainbow=false, sussy=false,
        Text = {
            Logo=false, LogoColor=Color3.new(1,1,1),
            Name=false,  NameColor=Color3.new(1,1,1),
            LogoFadingOffset=0,
        }
    }
    local CrL = CrossCat:Section({ Name = "Crosshair", Side = 1 })
    CrL:Toggle({ Name="Enable",    Flag="ch_on",      Callback=function(v) cursor.Enabled=v end }):Colorpicker({ Flag="ch_col",     Default=Color3.new(1,1,1), Alpha=0, Callback=function(v) cursor.Color=v end })
    CrL:Slider({ Name="Speed",     Flag="ch_speed",   Min=1,Max=150,Increment=1, Default=30, Callback=function(v) cursor.Speed=v/100 end })
    CrL:Slider({ Name="Radius",    Flag="ch_radius",  Min=1,Max=100,Increment=1, Callback=function(v) cursor.Radius=v end })
    CrL:Slider({ Name="Thickness", Flag="ch_thick",   Min=1,Max=100,Increment=1, Default=15, Callback=function(v) cursor.Thickness=v/10 end })
    CrL:Slider({ Name="Gap",       Flag="ch_gap",     Min=0,Max=50,Increment=1,  Callback=function(v) cursor.Gap=v end })

    local lines = {}
    local outline    = cheat.utility.new_drawing("Square",{Visible=true,Size=Vector2.new(4,4),Color=Color3.fromRGB(0,0,0),Filled=true,ZIndex=1,Transparency=1})
    local dot        = cheat.utility.new_drawing("Square",{Visible=true,Size=Vector2.new(2,2),Color=cursor.Color,Filled=true,ZIndex=2,Transparency=1})
    local logotext   = cheat.utility.new_drawing("Text",{Visible=false,Font=Drawing.Fonts.Plex,Size=13,Color=Color3.fromRGB(138,128,255),ZIndex=3,Transparency=1,Text="Kn v8 PREMIUM",Center=true,Outline=true})
    local nametext   = cheat.utility.new_drawing("Text",{Visible=false,Font=Drawing.Fonts.Plex,Size=13,Color=Color3.new(1,1,1),ZIndex=3,Transparency=1,Text=Players.LocalPlayer.Name,Center=true,Outline=true})
    for i=1,4 do
        lines[i] = {
            cheat.utility.new_drawing("Line",{Visible=true,From=Vector2.new(0,0),To=Vector2.new(0,0),Color=cursor.Color,Thickness=cursor.Thickness,ZIndex=2,Transparency=1}),
            cheat.utility.new_drawing("Line",{Visible=true,From=Vector2.new(0,0),To=Vector2.new(0,0),Color=Color3.new(0,0,0),Thickness=cursor.Thickness+2.5,ZIndex=1,Transparency=1}),
        }
    end
    local _rb,_rot = 0,0
    local _transp,_reverse = 0,false
    local _cgi     = cloneref(game:GetService("GuiService")):GetGuiInset()
    local _cmc     = Players.LocalPlayer:GetMouse()
    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
        if not cursor.Enabled then
            for i=1,4 do lines[i][1].Visible=false; lines[i][2].Visible=false end
            dot.Visible=false; logotext.Visible=false; nametext.Visible=false; return
        end
        local pos = Vector2.new(_cmc.X, _cmc.Y + _cgi.Y)
        local col = cursor.Color
        if cursor.rainbow then _rb=(_rb+delta*0.3)%1; col=Color3.fromHSV(_rb,1,1) end
        local gap = cursor.TheGap and cursor.Radius/(cursor.Gap==0 and 1 or cursor.Gap) or cursor.Gap
        local r,th= cursor.Radius, cursor.Thickness
        if cursor.sussy then _rot=(_rot+delta*90)%360 end
        local rad = math.rad(_rot)
        -- Fading text logic
        local logoOffset = cursor.Text.LogoFadingOffset or 0
        if not _reverse then
            _transp = _transp + (cursor.Speed * 10) * delta
            if _transp >= 1.5 + logoOffset then _reverse = true end
        else
            _transp = _transp - (cursor.Speed * 10) * delta
            if _transp <= 0 - logoOffset then _reverse = false end
        end
        local logoPos = Vector2.new(pos.X, pos.Y + r + 5)
        logotext.Position = logoPos
        logotext.Transparency = math.clamp(_transp, 0, 1)
        logotext.Visible = cursor.Text.Logo
        logotext.Color = cursor.Text.LogoColor
        logotext.Font = cursor.Font
        nametext.Position = Vector2.new(pos.X, pos.Y - r - 15)
        nametext.Visible = cursor.Text.Name
        nametext.Color = cursor.Text.NameColor
        nametext.Font = cursor.Font
        local rg, rg8 = r+gap, r+gap+8
        local a1,b1, a2,b2, a3,b3, a4,b4
        if cursor.sussy then
            local cr,sr = math.cos(rad), math.sin(rad)
            a1=Vector2.new( cr*rg, sr*rg);  b1=Vector2.new( cr*rg8, sr*rg8)
            a2=Vector2.new(-cr*rg,-sr*rg);  b2=Vector2.new(-cr*rg8,-sr*rg8)
            a3=Vector2.new(-sr*rg, cr*rg);  b3=Vector2.new(-sr*rg8, cr*rg8)
            a4=Vector2.new( sr*rg,-cr*rg);  b4=Vector2.new( sr*rg8,-cr*rg8)
        else
            a1=Vector2.new(0,-rg);  b1=Vector2.new(0,-rg8)
            a2=Vector2.new(0, rg);  b2=Vector2.new(0, rg8)
            a3=Vector2.new(-rg,0);  b3=Vector2.new(-rg8,0)
            a4=Vector2.new( rg,0);  b4=Vector2.new( rg8,0)
        end
        lines[1][1].From=pos+a1; lines[1][1].To=pos+b1; lines[1][1].Color=col; lines[1][1].Thickness=th; lines[1][1].Visible=true
        lines[2][1].From=pos+a2; lines[2][1].To=pos+b2; lines[2][1].Color=col; lines[2][1].Thickness=th; lines[2][1].Visible=true
        lines[3][1].From=pos+a3; lines[3][1].To=pos+b3; lines[3][1].Color=col; lines[3][1].Thickness=th; lines[3][1].Visible=true
        lines[4][1].From=pos+a4; lines[4][1].To=pos+b4; lines[4][1].Color=col; lines[4][1].Thickness=th; lines[4][1].Visible=true
        local outline_on = cursor.Outline
        lines[1][2].From=pos+a1; lines[1][2].To=pos+b1; lines[1][2].Thickness=th+2; lines[1][2].Visible=outline_on
        lines[2][2].From=pos+a2; lines[2][2].To=pos+b2; lines[2][2].Thickness=th+2; lines[2][2].Visible=outline_on
        lines[3][2].From=pos+a3; lines[3][2].To=pos+b3; lines[3][2].Thickness=th+2; lines[3][2].Visible=outline_on
        lines[4][2].From=pos+a4; lines[4][2].To=pos+b4; lines[4][2].Thickness=th+2; lines[4][2].Visible=outline_on
        if cursor.Dot then
            dot.Color=col; dot.Position=pos-Vector2.new(1,1); dot.Visible=true
            outline.Position=pos-Vector2.new(2,2); outline.Visible=true
        else dot.Visible=false; outline.Visible=false end
    end))
end

do
    local InvL = InvCat:Section({ Name = "Inventory",   Side = 1 })
    local InvR = InvCat:Section({ Name = "Item Finder", Side = 2 })

    InvL:Toggle({ Name="Inventory Checker",    Flag="inv_on",       Callback=function() end })
    InvL:Toggle({ Name="Show Full Inventory",  Flag="inv_full",     Callback=function() end })
    InvL:Toggle({ Name="Show Value",           Flag="inv_value",    Callback=function() end })
    InvL:Toggle({ Name="Check Corpse",         Flag="inv_corpse",   Callback=function() end })
    InvL:Toggle({ Name="Enable Dragging",      Flag="inv_drag",     Default=true, Callback=function() end })
    InvL:Slider({ Name="Size",                 Flag="inv_scale",    Min=25,Max=150,Increment=1,Default=100, Callback=function() end })

    local item_list = {}
    pcall(function()
        local il = ReplicatedStorage:FindFirstChild("ItemsList")
        if il then
            for _,it in pairs(il:GetChildren()) do
                local p = it:FindFirstChild("ItemProperties")
                if it.Name ~= "Lighter" and not (p and p:GetAttribute("ItemType")=="Melee") then
                    table.insert(item_list, it.Name)
                end
            end
        end
    end)
    table.sort(item_list, function(a,b) return string.lower(a)<string.lower(b) end)
    local inv_finder_glow_size = 5
    local inv_finder_glow_color = Color3.fromRGB(120,110,180)
    InvR:Dropdown({ Name="Items To Find",      Flag="inv_finder_item", Options=item_list, Callback=function() end })
    InvR:Toggle({ Name="Enable Item Finder",   Flag="inv_finder_on",   Callback=function() end }):Colorpicker({ Flag="inv_finder_col",  Default=Color3.fromRGB(120,110,180), Alpha=0, Callback=function(v) inv_finder_glow_color=v end })
    InvR:Slider({ Name="Glow Size",            Flag="inv_finder_glow", Min=1,Max=15,Increment=1,Default=5, Callback=function(v) inv_finder_glow_size=v end })
    InvR:Slider({ Name="Finder X Position",    Flag="inv_finder_x",    Min=0,Max=3000,Increment=1, Default=math.floor(workspace.CurrentCamera.ViewportSize.X-250), Callback=function() end })
    InvR:Slider({ Name="Finder Y Position",    Flag="inv_finder_y",    Min=0,Max=3000,Increment=1, Default=50, Callback=function() end })

    -- Item finder panel drawings
    local inv_finder_panel = {}
    inv_finder_panel.pos = Vector2.new(Library.Flags.inv_finder_x or workspace.CurrentCamera.ViewportSize.X-250, Library.Flags.inv_finder_y or 50)
    inv_finder_panel.width = 200
    inv_finder_panel.dragging = false
    inv_finder_panel.dragoffset = Vector2.new(0,0)
    inv_finder_panel.bg     = cheat.utility.new_drawing("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(20,20,20),ZIndex=100})
    inv_finder_panel.border = cheat.utility.new_drawing("Square",{Visible=false,Filled=false,Color=Color3.fromRGB(45,45,45),Thickness=1,ZIndex=101})
    inv_finder_panel.title  = cheat.utility.new_drawing("Text",  {Visible=false,Text="Item Finder",Size=16,Center=true,Color=Color3.new(1,1,1),Outline=true,ZIndex=102})
    inv_finder_panel.glow = {}
    for i=1,6 do inv_finder_panel.glow[i]=cheat.utility.new_drawing("Square",{Visible=false,Filled=false,Thickness=1,ZIndex=99}) end
    inv_finder_panel.labels = {}
    for i=1,30 do inv_finder_panel.labels[i]=cheat.utility.new_drawing("Text",{Visible=false,Text="",Size=14,Center=true,Color=Color3.fromRGB(200,200,200),Outline=true,ZIndex=102}) end

    local last_inv_finder_scan = 0
    local inv_finder_cache = {}
    local _inv_finder_shown = false
    cheat.utility.new_heartbeat(LPH_NO_VIRTUALIZE(function()
        local enabled = Library.Flags.inv_finder_on
        if not enabled then
            -- only pay the ~37 Drawing writes on the frame it turns off, not every idle frame
            if _inv_finder_shown then
                inv_finder_panel.bg.Visible=false; inv_finder_panel.border.Visible=false; inv_finder_panel.title.Visible=false
                for i=1,6 do inv_finder_panel.glow[i].Visible=false end
                for i=1,30 do inv_finder_panel.labels[i].Visible=false end
                _inv_finder_shown = false
            end
            return
        end
        _inv_finder_shown = true
        local found_players
        local now3 = tick()
        if now3 - last_inv_finder_scan < 1 then
            found_players = inv_finder_cache
        else
            last_inv_finder_scan = now3
            local selected_items = Library.Flags.inv_finder_item or {}
            found_players = {}
            for _,player in ipairs(Players:GetPlayers()) do
                if player~=LocalPlayer then
                    local p_inv = ReplicatedStorage:FindFirstChild("Players") and ReplicatedStorage.Players:FindFirstChild(player.Name) and ReplicatedStorage.Players[player.Name]:FindFirstChild("Inventory")
                    if p_inv then
                        local found_for_player = {}
                        local function check_item(item)
                            if selected_items[item.Name] and not found_for_player[item.Name] then
                                found_for_player[item.Name]=true
                                table.insert(found_players, player.Name.." ("..item.Name..")")
                            end
                            local sub_inv=item:FindFirstChild("Inventory")
                            if sub_inv then for _,si in ipairs(sub_inv:GetChildren()) do check_item(si) end end
                            local atts=item:FindFirstChild("Attachments")
                            if atts then for _,at in ipairs(atts:GetChildren()) do check_item(at) end end
                        end
                        for _,item in ipairs(p_inv:GetChildren()) do check_item(item) end
                    end
                end
            end
            inv_finder_cache = found_players
        end
        if #found_players>0 then
            inv_finder_panel.bg.Visible=true; inv_finder_panel.border.Visible=true; inv_finder_panel.title.Visible=true
            local max_display=math.min(#found_players,30)
            local h=45+(max_display*16)
            local p=inv_finder_panel.pos
            local size=Vector2.new(inv_finder_panel.width,h)
            local mousepos=Vector2.new(Mouse.X,Mouse.Y+GuiInset.Y)
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local in_bounds=mousepos.X>=p.X and mousepos.X<=p.X+size.X and mousepos.Y>=p.Y and mousepos.Y<=p.Y+size.Y
                if in_bounds or inv_finder_panel.dragging then
                    if not inv_finder_panel.dragging then inv_finder_panel.dragging=true; inv_finder_panel.dragoffset=p-mousepos end
                    inv_finder_panel.pos=mousepos+inv_finder_panel.dragoffset; p=inv_finder_panel.pos
                end
            else inv_finder_panel.dragging=false end
            inv_finder_panel.bg.Position=p; inv_finder_panel.bg.Size=size
            inv_finder_panel.border.Position=p; inv_finder_panel.border.Size=size
            inv_finder_panel.title.Position=p+Vector2.new(inv_finder_panel.width/2,5)
            local g_color=inv_finder_glow_color; local g_size=inv_finder_glow_size
            for i=1,6 do
                local th=(i/6)*g_size
                inv_finder_panel.glow[i].Visible=true; inv_finder_panel.glow[i].Color=g_color
                inv_finder_panel.glow[i].Thickness=math.max(1,th); inv_finder_panel.glow[i].Transparency=0.3-(i*0.04)
                inv_finder_panel.glow[i].Size=size+Vector2.new(th*2,th*2); inv_finder_panel.glow[i].Position=p-Vector2.new(th,th)
            end
            for i=1,30 do
                if i<=max_display then inv_finder_panel.labels[i].Visible=true; inv_finder_panel.labels[i].Text=found_players[i]; inv_finder_panel.labels[i].Position=p+Vector2.new(inv_finder_panel.width/2,25+(i*15))
                else inv_finder_panel.labels[i].Visible=false end
            end
        else
            inv_finder_panel.bg.Visible=false; inv_finder_panel.border.Visible=false; inv_finder_panel.title.Visible=false
            for i=1,6 do inv_finder_panel.glow[i].Visible=false end
            for i=1,30 do inv_finder_panel.labels[i].Visible=false end
        end
    end))

    -- Inventory ScreenGui
    local r52_0 = Instance.new("ScreenGui", game:GetService("CoreGui"))
    r52_0.Name = "EliteInventory"; r52_0.Enabled = false; r52_0.DisplayOrder = 999
    cheat.inv_gui = r52_0

    local MainFrame = Instance.new("Frame", r52_0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20); MainFrame.BorderSizePixel=0
    MainFrame.Size=UDim2.new(0,410,0,800); MainFrame.Position=UDim2.new(0,200,0,200)
    local _mfstroke = Instance.new("UIStroke", MainFrame)
    _mfstroke.Color=Color3.fromRGB(50,50,50); _mfstroke.Thickness=1; _mfstroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local MainScale = Instance.new("UIScale", MainFrame); MainScale.Name="MainScale"
    local AccentBar = Instance.new("Frame", MainFrame)
    AccentBar.BackgroundColor3=Library.Theme.Accent; AccentBar.BorderSizePixel=0
    AccentBar.Size=UDim2.new(1,0,0,2); AccentBar.Position=UDim2.new(0,0,0,0); AccentBar.ZIndex=3
    local InvGlow = Instance.new("ImageLabel", AccentBar)
    InvGlow.ImageColor3=Library.Theme.Accent; InvGlow.ScaleType=Enum.ScaleType.Slice
    InvGlow.ImageTransparency=0.5; InvGlow.BackgroundTransparency=1
    InvGlow.Size=UDim2.new(1,0,1,8); InvGlow.AnchorPoint=Vector2.new(0.5,0.5)
    InvGlow.Position=UDim2.new(0.5,0,0.5,0); InvGlow.Image="rbxassetid://18245826428"
    InvGlow.ZIndex=4; InvGlow.SliceCenter=Rect.new(Vector2.new(21,21),Vector2.new(79,79))
    local _invg = Instance.new("UIGradient", InvGlow)
    _invg.Rotation=90; _invg.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}
    -- header area
    local HeaderBg = Instance.new("Frame", MainFrame)
    HeaderBg.BackgroundColor3=Color3.fromRGB(22,22,22); HeaderBg.BorderSizePixel=0
    HeaderBg.Size=UDim2.new(1,0,0,68); HeaderBg.Position=UDim2.new(0,0,0,2)
    local TopHeader=Instance.new("TextLabel", HeaderBg); TopHeader.BackgroundTransparency=1
    TopHeader.Position=UDim2.new(0,12,0,10); TopHeader.Size=UDim2.new(1,-24,0,18)
    TopHeader.Font=Enum.Font.GothamMedium; TopHeader.TextSize=14; TopHeader.TextColor3=Color3.fromRGB(255,255,255)
    TopHeader.TextXAlignment=Enum.TextXAlignment.Left; TopHeader.Text="Inventory Viewer"
    local TargetNameHeader=Instance.new("TextLabel", HeaderBg); TargetNameHeader.BackgroundTransparency=1
    TargetNameHeader.Position=UDim2.new(0,12,0,32); TargetNameHeader.Size=UDim2.new(1,-24,0,16)
    TargetNameHeader.Font=Enum.Font.Gotham; TargetNameHeader.TextSize=13; TargetNameHeader.TextColor3=Color3.fromRGB(185,185,185)
    TargetNameHeader.TextXAlignment=Enum.TextXAlignment.Left; TargetNameHeader.Text=""
    local Divider=Instance.new("Frame", MainFrame); Divider.BackgroundColor3=Color3.fromRGB(50,50,50)
    Divider.BorderSizePixel=0; Divider.Position=UDim2.new(0,0,0,70); Divider.Size=UDim2.new(1,0,0,1)
    local SubHeader=Instance.new("TextLabel", MainFrame); SubHeader.BackgroundTransparency=1
    SubHeader.Position=UDim2.new(0,12,0,78); SubHeader.Size=UDim2.new(1,-24,0,16)
    SubHeader.Font=Enum.Font.GothamMedium; SubHeader.TextSize=13; SubHeader.TextColor3=Color3.fromRGB(185,185,185)
    SubHeader.TextXAlignment=Enum.TextXAlignment.Left; SubHeader.Text="Items"
    local GridContainer=Instance.new("ScrollingFrame", MainFrame); GridContainer.BackgroundTransparency=1
    GridContainer.Position=UDim2.new(0,12,0,100); GridContainer.Size=UDim2.new(1,-24,1,-108)
    GridContainer.CanvasSize=UDim2.new(0,0,0,0); GridContainer.ScrollBarThickness=3
    GridContainer.ScrollBarImageColor3=Color3.fromRGB(50,50,50); GridContainer.BorderSizePixel=0
    local GridLayout=Instance.new("UIGridLayout", GridContainer)
    GridLayout.CellSize=UDim2.new(0,88,0,88); GridLayout.CellPadding=UDim2.new(0,8,0,8); GridLayout.SortOrder=Enum.SortOrder.LayoutOrder
    local inv_Dragging = false; local inv_StartPos, inv_StartMouse
    HeaderBg.InputBegan:Connect(function(input)
        if not Library.Flags.inv_drag then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            inv_Dragging = true
            inv_StartPos = MainFrame.Position
            inv_StartMouse = UserInputService:GetMouseLocation()
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then inv_Dragging = false end
            end)
        end
    end)
    Library:Connect(UserInputService.InputChanged, function(input)
        if not inv_Dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = UserInputService:GetMouseLocation() - inv_StartMouse
        local parentS = r52_0.AbsoluteSize
        local guiS = MainFrame.AbsoluteSize
        local newOffX = math.clamp(inv_StartPos.X.Offset + delta.X, -inv_StartPos.X.Scale * parentS.X, parentS.X - guiS.X - inv_StartPos.X.Scale * parentS.X)
        local newOffY = math.clamp(inv_StartPos.Y.Offset + delta.Y, -inv_StartPos.Y.Scale * parentS.Y, parentS.Y - guiS.Y - inv_StartPos.Y.Scale * parentS.Y)
        MainFrame.Position = UDim2.new(inv_StartPos.X.Scale, newOffX, inv_StartPos.Y.Scale, newOffY)
        Library.Flags.inv_x = newOffX; Library.Flags.inv_y = newOffY
    end)

    local inventory = {}
    function inventory:refresh() end
    local LastTargetInventory = nil
    local function formatMoney(amount)
        local formatted=tostring(amount)
        while true do formatted,k=string.gsub(formatted,"^(-?%d+)(%d%d%d)",'%1,%2'); if k==0 then break end end
        return formatted
    end
    local _inv_last_accent = nil
    function inventory:update(__obj)
        if not __obj then r52_0.Enabled=false; return end
        r52_0.Enabled=Library.Flags.inv_on
        local _cur_accent = Library.Theme.Accent
        if _cur_accent ~= _inv_last_accent then
            _inv_last_accent = _cur_accent
            AccentBar.BackgroundColor3=_cur_accent; InvGlow.ImageColor3=_cur_accent
        end
        local ix=Library.Flags.inv_x or 200; local iy=Library.Flags.inv_y or 200
        if not inv_Dragging then MainFrame.Position=UDim2.new(0,ix,0,iy) end
        local inv=__obj:FindFirstChild("Inventory")
        if not inv then
            local rp=ReplicatedStorage:FindFirstChild("Players"); local rpp=rp and rp:FindFirstChild(__obj.Name)
            inv=rpp and rpp:FindFirstChild("Inventory")
        end
        if inv or not (LastTargetInventory==__obj) then
            local existing_cards={}
            for _,child in pairs(GridContainer:GetChildren()) do if child:IsA("Frame") then child.Visible=false; table.insert(existing_cards,child) end end
            local ItemsList=ReplicatedStorage:FindFirstChild("ItemsList")
            local itemCount=0; local val=0
            if inv and ItemsList then
                local function process_item(item_folder,hidden)
                    local n=string.lower(item_folder.Name)
                    if n:find("dagr") or n:find("keychain") or n:find("map") or n:find("lighter") or n:find("radio") or n:find("compass") or n:find("pathfinder") or n:find("dv%-2") or n:find("dv2") then return end
                    local item_ref=ItemsList:FindFirstChild(item_folder.Name)
                    if item_ref and item_ref:FindFirstChild("ItemProperties") and item_ref.ItemProperties:FindFirstChild("ItemIcon") then
                        local itype=item_ref.ItemProperties:GetAttribute("ItemType")
                        if itype=="Melee" or itype=="MeleeWeapon" then return end
                        if item_folder.Name~="Rubles" then
                            local price=item_ref.ItemProperties:GetAttribute("Price") or 1
                            if price>=10 then
                                if itype=="Extra" then price=price*0.4
                                elseif itype=="Ammo" then price=price*(item_folder:GetAttribute("Amount") or 1)*0.7
                                elseif itype=="Clothing" then price=price*0.35
                                elseif itype=="Medical" then price=price*0.75
                                elseif itype=="Barter" then price=price*0.4 end
                            end
                            val=val+price
                        else val=val+(item_folder:GetAttribute("Amount") or 1) end
                        if hidden then return end
                        itemCount=itemCount+1
                        local card=existing_cards[itemCount]
                        if not card then
                            card=Instance.new("Frame",GridContainer); card.BackgroundColor3=Color3.fromRGB(28,28,28)
                            card.BorderSizePixel=0
                            local _cs=Instance.new("UIStroke",card); _cs.Color=Color3.fromRGB(50,50,50); _cs.Thickness=1; _cs.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
                            local icon=Instance.new("ImageLabel",card); icon.BackgroundTransparency=1
                            icon.Size=UDim2.new(0.8,0,0.8,0); icon.Position=UDim2.new(0.1,0,0.05,0); icon.ScaleType=Enum.ScaleType.Fit
                            local label=Instance.new("TextLabel",card); label.BackgroundTransparency=1
                            label.Position=UDim2.new(0,4,1,-15); label.Size=UDim2.new(1,-8,0,15)
                            label.Font=Enum.Font.Gotham; label.TextSize=11; label.TextColor3=Color3.fromRGB(185,185,185)
                            label.TextXAlignment=Enum.TextXAlignment.Center
                        end
                        card.LayoutOrder=itemCount; card.Visible=true
                        card:FindFirstChildOfClass("ImageLabel").Image=item_ref.ItemProperties.ItemIcon.Image
                        local itemName=item_folder.Name:upper(); if #itemName>12 then itemName=itemName:sub(1,10).."..." end
                        card:FindFirstChildOfClass("TextLabel").Text=itemName
                    end
                end
                for _,slot in pairs(inv:GetChildren()) do
                    process_item(slot,false)
                    local slot_attr=slot:GetAttribute("Slot")
                    if slot_attr and slot_attr:find("Clothing") and slot:FindFirstChild("Inventory") then
                        if Library.Flags.inv_full then for _,si in pairs(slot.Inventory:GetChildren()) do process_item(si,false) end end
                    elseif slot:FindFirstChild("Attachments") then
                        for _,att in pairs(slot.Attachments:GetChildren()) do process_item(att,true) end
                    end
                end
            end
            val=math.floor(val)
            TopHeader.Text="INVENTORY VIEWER - "..itemCount.." ITEMS"..(Library.Flags.inv_value and (", $"..formatMoney(val)) or "")
            TargetNameHeader.Text=__obj.Name:upper(); SubHeader.Text="ITEMS ("..itemCount..")"
            local rows=math.ceil(itemCount/4)
            GridContainer.CanvasSize=UDim2.new(0,0,0,rows*96)
            MainFrame.Size=UDim2.new(0,410,0,math.clamp(130+rows*96,300,900))
        end
        LastTargetInventory=__obj
    end

    local inv_FrameTimer = tick()
    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
        local _inv_sc = MainScale
        if _inv_sc then
            local _inv_target = (Library.Flags.inv_scale or 100) / 100
            _inv_sc.Scale = _inv_sc.Scale + (_inv_target - _inv_sc.Scale) * 0.15
        end
        if (tick()-inv_FrameTimer) >= math.max(0.05,(Library.Flags.inv_delay or 10)/100) then
            inv_FrameTimer=tick()
            if Library.Flags.inv_on then
                local target=nil; local dist=math.huge
                if silent_aim and silent_aim.target_part and silent_aim.target_part.Parent then
                    target=silent_aim.target_part.Parent
                end
                if not target then
                    local vp = Camera.ViewportSize
                    local vp_cx, vp_cy = vp.X/2, vp.Y/2
                    for _,p in ipairs(Players:GetPlayers()) do
                        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                            local sp,ov=Camera:WorldToViewportPoint(p.Character.Head.Position)
                            if ov then
                                local dx,dy=sp.X-vp_cx,sp.Y-vp_cy
                                local mag=math.sqrt(dx*dx+dy*dy)
                                if mag<dist then dist=mag; target=p.Character end
                            end
                        end
                    end
                    if Library.Flags.inv_corpse then
                        local dropped=workspace:FindFirstChild("DroppedItems")
                        if dropped then for _,item in ipairs(dropped:GetChildren()) do
                            if item:FindFirstChild("Humanoid") and item:FindFirstChild("Head") then
                                local sp,ov=Camera:WorldToViewportPoint(item.Head.Position)
                                if ov then
                                    local dx,dy=sp.X-vp_cx,sp.Y-vp_cy
                                    local mag=math.sqrt(dx*dx+dy*dy)
                                    if mag<dist then dist=mag; target=item end
                                end
                            end
                        end end
                    end
                end
                if target then inventory:update(target) else inventory:refresh(); inventory:update(nil) end
            else
                if r52_0.Enabled then r52_0.Enabled = false end
            end
        end
    end))
end

do
    local WL = WorldCat:Section({ Name = "Lighting", Side = 1 })
    local world_globals = { EnableTime=false, Time=12, noshadows=false, gradientenabled=false }
    local grad_col1, grad_col2 = Color3.fromRGB(90,90,90), Color3.fromRGB(150,150,150)
    local extreme_potato_mode = false
    local original_fog_end    = Lighting.FogEnd
    local SkyBoxes = {
        ["Default"] = {
            SkyboxLf = "rbxassetid://148943339", SkyboxBk = "rbxassetid://148943390",
            SkyboxDn = "rbxassetid://148943362", SkyboxFt = "rbxassetid://148943404",
            SkyboxRt = "rbxassetid://148943379", SkyboxUp = "rbxassetid://148943410"
        },
        ["Nebula"] = {
            SkyboxLf = "rbxassetid://159454286", SkyboxBk = "rbxassetid://159454299",
            SkyboxDn = "rbxassetid://159454296", SkyboxFt = "rbxassetid://159454293",
            SkyboxRt = "rbxassetid://159454300", SkyboxUp = "rbxassetid://159454288"
        },
        ["Blue Nebula"] = {
            SkyboxBk = "rbxassetid://79187608916257",  SkyboxDn = "rbxassetid://79187608916257",
            SkyboxFt = "rbxassetid://135345543970829", SkyboxLf = "rbxassetid://130684897818024",
            SkyboxRt = "rbxassetid://134117814265945", SkyboxUp = "rbxassetid://128019898265074"
        },
        ["Setting Hills"] = {
            SkyboxLf = "rbxassetid://264909758", SkyboxBk = "rbxassetid://264908339",
            SkyboxDn = "rbxassetid://264907909", SkyboxFt = "rbxassetid://264909420",
            SkyboxRt = "rbxassetid://264908886", SkyboxUp = "rbxassetid://264907379"
        },
        ["Blue Aurora"] = {
            SkyboxBk = "rbxassetid://12064107", SkyboxDn = "rbxassetid://12064152",
            SkyboxFt = "rbxassetid://12064121", SkyboxLf = "rbxassetid://12063984",
            SkyboxRt = "rbxassetid://12064115", SkyboxUp = "rbxassetid://12064131"
        },
        ["Red Aurora"] = {
            SkyboxBk = "rbxassetid://401664839", SkyboxDn = "rbxassetid://401664862",
            SkyboxFt = "rbxassetid://401664960", SkyboxLf = "rbxassetid://401664881",
            SkyboxRt = "rbxassetid://401664901", SkyboxUp = "rbxassetid://401664936"
        },
        ["Pink Vision"] = {
            SkyboxBk = "rbxassetid://6593929026", SkyboxDn = "rbxassetid://6593930140",
            SkyboxFt = "rbxassetid://6593931249", SkyboxLf = "rbxassetid://6593932587",
            SkyboxRt = "rbxassetid://6593933789", SkyboxUp = "rbxassetid://6593935319"
        },
        ["Twilight"] = {
            SkyboxBk = "rbxassetid://570557514", SkyboxDn = "rbxassetid://570557775",
            SkyboxFt = "rbxassetid://570557559", SkyboxLf = "rbxassetid://570557620",
            SkyboxRt = "rbxassetid://570557672", SkyboxUp = "rbxassetid://570557727"
        },
        ["Distopia"] = {
            SkyboxBk = "rbxassetid://2240134413", SkyboxDn = "rbxassetid://2240136039",
            SkyboxFt = "rbxassetid://2240130790", SkyboxLf = "rbxassetid://2240133550",
            SkyboxRt = "rbxassetid://2240132643", SkyboxUp = "rbxassetid://2240135222"
        },
        ["Peaceful"] = {
            SkyboxBk = "rbxassetid://73252679982122",  SkyboxDn = "rbxassetid://101074061181553",
            SkyboxFt = "rbxassetid://112572775732134", SkyboxLf = "rbxassetid://126931573973019",
            SkyboxRt = "rbxassetid://135908172504233", SkyboxUp = "rbxassetid://124514468649717"
        },
    }
    local function applySkybox(name)
        local assets = SkyBoxes[name]
        if not assets then return end
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if not sky then sky = Instance.new("Sky"); sky.Parent = Lighting end
        for prop, id in next, assets do
            pcall(function() sky[prop] = id end)
        end
    end
    local _last_skybox = nil
    local original_clock_time = Lighting.ClockTime
    local original_ambient    = Lighting.Ambient
    local original_outdoor    = Lighting.OutdoorAmbient

    WL:Toggle({ Name="Time Changer",  Flag="w_timeon",    Callback=function(v) world_globals.EnableTime=v; globals.EnableTime=v; if not v then Lighting.ClockTime=original_clock_time end end })
    WL:Slider({ Name="Time",          Flag="w_time",      Min=0,Max=240,Increment=1, Callback=function(v) world_globals.Time=v/10; globals.Time=v/10 end })
    WL:Toggle({ Name="Ambient",       Flag="w_ambient",   Callback=function(v) world_globals.gradientenabled=v; globals.gradientenabled=v; if not v then Lighting.Ambient=original_ambient; Lighting.OutdoorAmbient=original_outdoor end end }):Colorpicker({ Flag="w_ambcol1",   Default=Color3.new(1,1,1), Alpha=0, Callback=function(v) grad_col1=v; grad_col2=v end })
    WL:Toggle({ Name="No Fog",        Flag="w_nofog",     Callback=function(v) if not v then Lighting.FogEnd = original_fog_end end end })
    WL:Toggle({ Name="No Grass",      Flag="w_nograss",   Callback=function(v) pcall(function() sethiddenproperty(workspace:FindFirstChildOfClass("Terrain"),"Decoration",not v) end) end })
    local _noclouds_orig = nil
    WL:Toggle({ Name="No Clouds", Flag="w_noclouds", Callback=function(v)
        local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
        if not clouds then return end
        if v then
            if _noclouds_orig == nil then _noclouds_orig = clouds.Enabled end
            clouds.Enabled = false
        elseif _noclouds_orig ~= nil then
            clouds.Enabled = _noclouds_orig
            _noclouds_orig = nil
        end
    end })
    WL:Dropdown({ Name="Custom Skybox", Flag="w_skybox", Options={"None","Default","Nebula","Blue Nebula","Setting Hills","Blue Aurora","Red Aurora","Pink Vision","Twilight","Distopia","Peaceful"}, Callback=function(v) _last_skybox=nil end })
    WL:Toggle({ Name="No Shadows",    Flag="w_noshadow",  Callback=function(v) world_globals.noshadows=v; globals.noshadows=v end })
    WL:Toggle({ Name="No Leafs",      Flag="w_noleafs",   Callback=function(v)
        local function applyLeafs()
            local zones=workspace:FindFirstChild("SpawnerZones")
            local foliage=zones and zones:FindFirstChild("Foliage")
            if foliage then for _,f in pairs(foliage:GetDescendants()) do if f:FindFirstChildOfClass("SurfaceAppearance") then f.Transparency = v and 1 or 0 end end end
        end
        applyLeafs()
        if v then task.spawn(function() while Library.Flags.w_noleafs do task.wait(10); applyLeafs() end end) end
    end })
    WL:Toggle({ Name="Extreme Potato Mode",   Flag="ov_potato",    Callback=function(v)
        extreme_potato_mode = v
        if v then
            pcall(function()
                workspace.Terrain.Decoration=false
                workspace.Terrain.WaterWaveSize=0; workspace.Terrain.WaterWaveSpeed=0
                workspace.Terrain.WaterReflectance=0; workspace.Terrain.WaterTransparency=0
                Lighting.GlobalShadows=false; Lighting.FogEnd=9e9
                for _,o in pairs(Lighting:GetChildren()) do
                    if o:IsA("PostEffect") or o:IsA("Atmosphere") or o:IsA("Sky") or o:IsA("Clouds") then o.Enabled=false end
                end
            end)
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not (obj.Parent and obj.Parent:FindFirstChild("Humanoid")) then
                    obj.Material=Enum.Material.SmoothPlastic; obj.Reflectance=0; obj.CastShadow=false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency=1
                end
            end
        end
    end })
    workspace.DescendantAdded:Connect(function(obj)
        if extreme_potato_mode then
            if obj:IsA("BasePart") and not (obj.Parent and obj.Parent:FindFirstChild("Humanoid")) then
                obj.Material=Enum.Material.SmoothPlastic; obj.Reflectance=0; obj.CastShadow=false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency=1
            end
        end
    end)

    local _lg_amb, _lg_outamb, _lg_time
    cheat.utility.new_heartbeat(function()
        local _sky = Library.Flags.w_skybox
        if _sky and _sky ~= "None" and _sky ~= _last_skybox then _last_skybox = _sky; applySkybox(_sky) end
        if Library.Flags.w_nofog then if Lighting.FogEnd < 9e5 then Lighting.FogEnd = 9e9 end end
        if world_globals.noshadows and Lighting.GlobalShadows then Lighting.GlobalShadows=false elseif not world_globals.noshadows and not Lighting.GlobalShadows then Lighting.GlobalShadows=true end
        if world_globals.gradientenabled then
            if grad_col1 ~= _lg_amb then _lg_amb=grad_col1; Lighting.Ambient=grad_col1 end
            if grad_col2 ~= _lg_outamb then _lg_outamb=grad_col2; Lighting.OutdoorAmbient=grad_col2 end
        end
        if world_globals.EnableTime then
            if world_globals.Time ~= _lg_time then _lg_time=world_globals.Time; Lighting.ClockTime=world_globals.Time end
        end
    end)

    local WR = VisualsPage:Section({ Name = "Objects", Side = 2 })

    local extract_enabled = false
    local extract_highlights = {}
    local extract_labels     = {}
    local extract_watch_conn = nil

    local extract_color = Color3.fromRGB(255, 220, 0)

    local function get_extract_part(obj)
        if obj:IsA("BasePart") then return obj end
        if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart") end
        if obj:IsA("Folder") then return obj:FindFirstChildOfClass("BasePart") end
    end

    local function add_extraction(obj)
        if extract_highlights[obj] then return end
        local part = get_extract_part(obj)
        if not part then return end
        local hl = Instance.new("Highlight")
        hl.FillColor           = extract_color
        hl.OutlineColor        = extract_color
        hl.FillTransparency    = 0.45
        hl.OutlineTransparency = 0
        hl.Adornee = obj
        hl.Parent  = part
        extract_highlights[obj] = hl
        local name_draw = cheat.utility.new_drawing("Text", {
            Visible = false,
            Text    = "Extraction",
            Color   = extract_color,
            Size    = cheat.EspLibrary.main_settings.textSize,
            Font    = cheat.EspLibrary.main_settings.textFont,
            Center  = true,
            Outline = true,
            OutlineColor = Color3.new(0,0,0),
            ZIndex  = 5,
        })
        local dist_draw = cheat.utility.new_drawing("Text", {
            Visible = false,
            Text    = "",
            Color   = Color3.new(1,1,1),
            Size    = cheat.EspLibrary.main_settings.textSize,
            Font    = cheat.EspLibrary.main_settings.textFont,
            Center  = true,
            Outline = true,
            OutlineColor = Color3.new(0,0,0),
            ZIndex  = 5,
        })
        extract_labels[obj] = {part=part, name=name_draw, dist=dist_draw}
    end

    local function clear_extractions()
        for _, hl in pairs(extract_highlights) do pcall(function() hl:Destroy() end) end
        for _, t  in pairs(extract_labels) do
            pcall(function() t.name:Remove() end)
            pcall(function() t.dist:Remove() end)
        end
        extract_highlights = {}
        extract_labels     = {}
    end

    local function scan_extractions()
        local nc   = workspace:FindFirstChild("NoCollision")
        local exits = nc and nc:FindFirstChild("ExitLocations")
        if exits then
            for _, obj in ipairs(exits:GetChildren()) do pcall(add_extraction, obj) end
        end
        local az = workspace:FindFirstChild("AiZones")
        if az then
            for _, obj in ipairs(az:GetChildren()) do
                if obj.Name:lower():find("exit") then pcall(add_extraction, obj) end
            end
        end
    end

    cheat.utility.new_heartbeat(function()
        if not extract_enabled then return end
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local cam  = workspace.CurrentCamera
        if not hrp or not cam then return end
        local ms = cheat.EspLibrary.main_settings
        for _, t in pairs(extract_labels) do
            pcall(function()
                if not (t.part and t.part.Parent) then
                    t.name.Visible = false; t.dist.Visible = false; return
                end
                local top_pos = t.part.Position + Vector3.new(0, t.part.Size.Y / 2 + 0.3, 0)
                local screen, vis = cam:WorldToViewportPoint(top_pos)
                if not vis or screen.Z <= 0 then
                    t.name.Visible = false; t.dist.Visible = false; return
                end
                local sz = ms.textSize
                local fn = ms.textFont
                local sx, sy = screen.X, screen.Y
                t.name.Position    = Vector2.new(sx, sy)
                t.name.Size        = sz
                t.name.Font        = fn
                t.name.Visible     = true
                local dist = math.floor((t.part.Position - hrp.Position).Magnitude)
                t.dist.Text        = dist .. "m"
                t.dist.Position    = Vector2.new(sx, sy + sz + 1)
                t.dist.Size        = sz
                t.dist.Font        = fn
                t.dist.Visible     = true
            end)
        end
    end)

    WR:Toggle({ Name="Show Extractions", Flag="w_extractions", Callback=function(v)
        extract_enabled = v
        if v then
            scan_extractions()
        else
            if extract_watch_conn then extract_watch_conn:Disconnect(); extract_watch_conn=nil end
            clear_extractions()
        end
    end })

    -- Car ESP
    local car_esp_enabled = false
    local car_esp_color   = Color3.fromRGB(255, 165, 0)
    local car_esp_objs    = {}  -- [model] = {part, name, dist}

    local function car_esp_add(model)
        if car_esp_objs[model] then return end
        local part = model.PrimaryPart or model:FindFirstChildOfClass("BasePart")
        if not part then return end
        local nd = cheat.utility.new_drawing("Text", {
            Visible=false, Text="Car", Color=car_esp_color,
            Size=cheat.EspLibrary.main_settings.textSize,
            Font=cheat.EspLibrary.main_settings.textFont,
            Center=true, Outline=true, OutlineColor=Color3.new(0,0,0), ZIndex=5,
        })
        local dd = cheat.utility.new_drawing("Text", {
            Visible=false, Color=Color3.new(1,1,1),
            Size=cheat.EspLibrary.main_settings.textSize-2,
            Font=cheat.EspLibrary.main_settings.textFont,
            Center=true, Outline=true, OutlineColor=Color3.new(0,0,0), ZIndex=5,
        })
        car_esp_objs[model] = {part=part, name=nd, dist=dd}
    end

    local function car_esp_clear()
        for _, t in pairs(car_esp_objs) do
            pcall(function() t.name:Remove() end)
            pcall(function() t.dist:Remove() end)
        end
        car_esp_objs = {}
    end

    local function car_esp_scan()
        local veh = workspace:FindFirstChild("Vehicles")
        if not veh then return end
        for _, v in ipairs(veh:GetChildren()) do
            if v:IsA("Model") then pcall(car_esp_add, v) end
        end
    end

    local car_esp_watch = nil
    WR:Toggle({ Name="Show Cars", Flag="w_caresp", Callback=function(v)
        car_esp_enabled = v
        if v then
            car_esp_scan()
            local veh = workspace:FindFirstChild("Vehicles")
            if veh then
                car_esp_watch = veh.ChildAdded:Connect(function(c)
                    if c:IsA("Model") then pcall(car_esp_add, c) end
                end)
            end
        else
            if car_esp_watch then car_esp_watch:Disconnect(); car_esp_watch=nil end
            car_esp_clear()
        end
    end })

    cheat.utility.new_heartbeat(function()
        if not car_esp_enabled then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local lp_char = Players.LocalPlayer.Character
        local lp_hrp  = lp_char and lp_char:FindFirstChild("HumanoidRootPart")
        local lp_pos  = lp_hrp and lp_hrp.Position or cam.CFrame.Position
        local fs = cheat.EspLibrary.main_settings.textSize
        local fn = cheat.EspLibrary.main_settings.textFont
        for model, t in pairs(car_esp_objs) do
            pcall(function()
                if not model or not model.Parent then
                    t.name:Remove(); t.dist:Remove()
                    car_esp_objs[model] = nil
                    return
                end
                local part = t.part
                if not part or not part.Parent then return end
                local pos3 = part.Position
                local screen, vis = cam:WorldToViewportPoint(pos3)
                if not vis or screen.Z <= 0 then
                    t.name.Visible = false
                    t.dist.Visible = false
                    return
                end
                local d = math.floor((pos3 - lp_pos).Magnitude / 2.8)
                t.name.Position = Vector2.new(screen.X, screen.Y - 20)
                t.name.Text     = "Car"
                t.name.Size     = fs
                t.name.Font     = fn
                t.name.Visible  = true
                t.dist.Position = Vector2.new(screen.X, screen.Y - 6)
                t.dist.Text     = d .. "m"
                t.dist.Size     = fs - 2
                t.dist.Font     = fn
                t.dist.Visible  = true
            end)
        end
    end)
end

do
    local OL  = CamEffectCat:Section({ Name = "Camera/Effects", Side = 2 })
    local OHR = HitLogCat:Section({ Name = "Hit Logs",      Side = 1 })
    local zoom_size_ov=10; local fov_size_ov=70

    OL:Toggle({ Name="FOV Override",          Flag="ov_fov",       Callback=function(v) globals.fov_enabled=v end })
    OL:Slider({ Name="FOV Size",              Flag="ov_fovsize",   Min=10,Max=120,Increment=1,Default=70, Callback=function(v) fov_size_ov=v end })
    OL:Toggle({ Name="Zoom",                  Flag="ov_zoom",      Callback=function(v) globals.zoom_enabled=v end }):Keybind({ Flag="ov_zoomkey", Mode="Toggle", Callback=function(v) if Library.SetFlags["ov_zoom"] then Library.SetFlags["ov_zoom"](v) end end })
    OL:Slider({ Name="Zoom Size",             Flag="ov_zoomsize",  Min=1,Max=90,Increment=1,Default=10, Callback=function(v) zoom_size_ov=v end })
    OL:Toggle({ Name="No Screen Effects",     Flag="ov_noscreenfx",Callback=function() end })
    OL:Toggle({ Name="Remove Muzzle Flash",   Flag="ov_nomuzzle",  Callback=function() end })
    OL:Toggle({ Name="Hit/Kill Effect",       Flag="killeffect",        Callback=function() end })
    OL:Slider({ Name="Hit Effect Stars",      Flag="killeffect_amount", Min=50,Max=200,Increment=1,Default=100, Callback=function() end })
    local _last_fov
    cheat.utility.new_renderstepped(function()
        local zoom = Library.Flags.ov_zoom
        local fov  = Library.Flags.ov_fov
        local target_fov = zoom and zoom_size_ov or fov and fov_size_ov
        if target_fov then
            if target_fov ~= _last_fov then
                _last_fov = target_fov
                Camera.FieldOfView = target_fov
            end
        elseif _last_fov then
            _last_fov = nil
            Camera.FieldOfView = 70
        end
    end)
    local function remove_muzzle(v)
        if Library.Flags.ov_nomuzzle then
            if v:IsA("ParticleEmitter") or v:IsA("Light") or v:IsA("Beam") then
                local n,pn=v.Name:lower(),(v.Parent and v.Parent.Name:lower() or "")
                if n:find("flash") or n:find("muzzle") or pn:find("muzzle") or pn:find("aimpart") then
                    v.Enabled=false
                    if v:IsA("ParticleEmitter") then v:Clear(); v.Transparency=NumberSequence.new(1) end
                end
            end
        end
    end
    Camera.DescendantAdded:Connect(remove_muzzle)
    local last_nomuzzle_scan = 0
    local _se_cache = nil
    local function _find_se()
        local pg = Players.LocalPlayer.PlayerGui
        local ni = pg and pg:FindFirstChild("NoInsetGui")
        local mf = ni and ni:FindFirstChild("MainFrame")
        return mf and mf:FindFirstChild("ScreenEffects")
    end
    Players.LocalPlayer.PlayerGui.DescendantAdded:Connect(function(d)
        if d.Name == "ScreenEffects" then _se_cache = d end
    end)
    _se_cache = _find_se()
    cheat.utility.new_heartbeat(function()
        if Library.Flags.ov_nomuzzle then
            local now2 = tick()
            if now2 - last_nomuzzle_scan >= 0.1 then
                last_nomuzzle_scan = now2
                for _,v in Camera:GetDescendants() do remove_muzzle(v) end
            end
        end
        if not _se_cache or not _se_cache.Parent then _se_cache = _find_se() end
        if _se_cache then _se_cache.Visible = not(Library.Flags.ov_noscreenfx) end
    end)

    OHR:Toggle({ Name="Hit Logs",         Flag="hl_on",      Callback=function(v) cheat.hitlogs_enabled=v end }):Colorpicker({ Flag="hl_valcol",  Default=cheat.hitlogs_valid_color,   Callback=function(v) cheat.hitlogs_valid_color=v end })
    OHR:Label("Invalid Color"):Colorpicker({ Flag="hl_invcol", Default=cheat.hitlogs_invalid_color, Callback=function(v) cheat.hitlogs_invalid_color=v end })
    OHR:Dropdown({ Name="Font",           Flag="hl_font",    Options={"UI","System","Plex","Monospace"}, Callback=function(v) local fm={UI=0,System=1,Plex=2,Monospace=3}; cheat.hitlogs_font=fm[v] or 2 end })
    OHR:Slider({ Name="Text Size",        Flag="hl_size",    Min=10,Max=30,Increment=1, Callback=function(v) cheat.hitlogs_size=v end })
    OHR:Slider({ Name="Y Position",       Flag="hl_y",       Min=0,Max=1500,Increment=1, Callback=function(v) cheat.hitlogs_y=v end })
end

do
    local VML  = ViewMdCat:Section({ Name = "Viewmodel", Side = 1 })
    local VML2 = OtherCat:Section({ Name = "Chams",      Side = 2 })

    VML:Slider({ Name="X Offset",Flag="vm_x",Min=-50,Max=50,Increment=1,Callback=function() end })
    VML:Slider({ Name="Y Offset",Flag="vm_y",Min=-50,Max=50,Increment=1,Callback=function() end })
    VML:Slider({ Name="Z Offset",Flag="vm_z",Min=-50,Max=50,Increment=1,Callback=function() end })

    VML2:Toggle({ Name="Arm Chams",       Flag="vm_armchams",  Callback=function() end }):Colorpicker({ Flag="vm_armcol",    Default=Color3.new(1,1,1), Alpha=0, Callback=function() end })
    VML2:Dropdown({ Name="Arm Material",  Flag="vm_armmat",    Options={"SmoothPlastic","ForceField","Neon","Plastic","Glass"}, Callback=function() end })
    VML2:Toggle({ Name="Gun Chams",       Flag="vm_gunchams",  Callback=function() end }):Colorpicker({ Flag="vm_guncol",    Default=Color3.new(1,1,1), Alpha=0, Callback=function() end })
    VML2:Dropdown({ Name="Gun Material",  Flag="vm_gunmat",    Options={"SmoothPlastic","ForceField","Neon","Plastic","Glass"}, Callback=function() end })
    local unlock_all_skins_enabled = false
    VML2:Toggle({ Name="Unlock All Skins", Flag="vm_unlockskins", Callback=function(v)
        unlock_all_skins_enabled = v
    end })

    task.spawn(function()
        pcall(function()
            local fl = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FunctionLibraryExtension"))
            if fl and fl.IsItemAccessibleToPlayer then
                local old_IsItemAccessible = fl.IsItemAccessibleToPlayer
                fl.IsItemAccessibleToPlayer = function(self, ...)
                    if unlock_all_skins_enabled then return true end
                    return old_IsItemAccessible(self, ...)
                end
            end
            if fl and fl.UpdateSkin then
                local old_UpdateSkin = fl.UpdateSkin
                fl.UpdateSkin = function(self, p140, p141, p142)
                    if p140 and typeof(p140) == "Instance" and p140:IsA("ObjectValue") then
                        local rep = ReplicatedStorage
                        local p_inv = rep:FindFirstChild("Players") and rep.Players:FindFirstChild(LocalPlayer.Name) and rep.Players[LocalPlayer.Name]:FindFirstChild("Inventory")
                        if p_inv then
                            for _, item in ipairs(p_inv:GetChildren()) do
                                if item:IsA("ObjectValue") and item.Value == p140.Value then
                                    local forced = item:GetAttribute("Skin")
                                    if forced ~= nil then
                                        p142 = (forced == "" and nil or forced)
                                    end
                                    break
                                end
                            end
                        end
                    end
                    return old_UpdateSkin(self, p140, p141, p142)
                end

                if fl.FindDeepAncestor then
                    fl.FindDeepAncestor = function(self, p92, p93, p94)
                        local v95 = 0
                        if not p92 or typeof(p92) ~= "Instance" then return p92 end
                        while p92 and p92.Parent and p92.Parent.ClassName == p93 do
                            if p92.Parent.Parent and p92.Parent.Parent.Parent and p92.Parent.Parent.Parent.Name == "Attachments" then
                                p92 = p92.Parent.Parent.Parent
                            else
                                p92 = p92.Parent
                            end
                            v95 = v95 + 1
                            if p94 and typeof(p94) == "table" and p94.SearchForInteraction then
                                if p92:GetAttribute(p94.SearchForInteraction) then break end
                            end
                            if v95 > 10 or p92:FindFirstChild("DeepAncestorBreak") or p92:FindFirstChild("Moving") then
                                break
                            end
                        end
                        return p92
                    end
                end
            end
        end)
    end)

    task.spawn(function()
        local rep = ReplicatedStorage
        while task.wait(2) do
            if unlock_all_skins_enabled then
                pcall(function()
                    local p_purchases = rep:FindFirstChild("Players") and rep.Players:FindFirstChild(LocalPlayer.Name) and rep.Players[LocalPlayer.Name]:FindFirstChild("Status") and rep.Players[LocalPlayer.Name].Status:FindFirstChild("Purchases")
                    if p_purchases then
                        if not p_purchases:FindFirstChild("Skins") then
                            local s = Instance.new("Folder")
                            s.Name = "Skins"
                            s.Parent = p_purchases
                        end
                        local p_skins = p_purchases.Skins

                        local function unlock_from(folder_name)
                            local f = rep:FindFirstChild(folder_name)
                            if f then
                                for _, weapon_skins in pairs(f:GetChildren()) do
                                    local p_weapon = p_skins:FindFirstChild(weapon_skins.Name)
                                    if not p_weapon then
                                        p_weapon = Instance.new("Folder")
                                        p_weapon.Name = weapon_skins.Name
                                        p_weapon.Parent = p_skins
                                    end
                                    for _, skin in pairs(weapon_skins:GetChildren()) do
                                        if not p_weapon:FindFirstChild(skin.Name) then
                                            local mock = Instance.new("Folder")
                                            mock.Name = skin.Name
                                            mock.Parent = p_weapon
                                        end
                                    end
                                end
                            end
                        end
                        unlock_from("Skins")
                        unlock_from("SkinPacks")
                    end
                end)
            end
        end
    end)

    task.spawn(function()
        local rep = ReplicatedStorage
        local _fl_cache = nil
        while task.wait(0.1) do
            pcall(function()
                local p_inv = rep:FindFirstChild("Players") and rep.Players:FindFirstChild(LocalPlayer.Name) and rep.Players[LocalPlayer.Name]:FindFirstChild("Inventory")
                local p_holding = rep:FindFirstChild("Players") and rep.Players:FindFirstChild(LocalPlayer.Name) and rep.Players[LocalPlayer.Name]:FindFirstChild("Holding")
                if p_inv and p_holding and p_holding.Value and p_holding.Value:IsA("ObjectValue") then
                    local active_weapon = p_holding.Value
                    local weapon_name = active_weapon.Value and active_weapon.Value.Name
                    for _, item in ipairs(p_inv:GetChildren()) do
                        if item:IsA("ObjectValue") and item.Value == active_weapon.Value then
                            local forced_skin = item:GetAttribute("SpoofedSkin")
                            if forced_skin ~= nil then
                                local target_skin = (forced_skin == "" and nil or forced_skin)
                                if active_weapon:GetAttribute("Skin") ~= target_skin then
                                    active_weapon:SetAttribute("Skin", target_skin)
                                end

                                if target_skin and weapon_name then
                                    if not _fl_cache then _fl_cache = require(rep:WaitForChild("Modules"):WaitForChild("FunctionLibraryExtension")) end
                                    local fl = _fl_cache
                                    local function paint_model(parent)
                                        if not parent then return end
                                        local w_model = parent:FindFirstChild(weapon_name)
                                        if w_model and w_model:IsA("Model") and w_model:GetAttribute("SpoofSkinApplied") ~= target_skin then
                                            pcall(function()
                                                fl:UpdateSkin(nil, w_model, target_skin)
                                                w_model:SetAttribute("SpoofSkinApplied", target_skin)
                                            end)
                                        end
                                    end
                                    paint_model(LocalPlayer.Character)
                                    local cam = workspace.CurrentCamera
                                    if cam then
                                        for _, child in ipairs(cam:GetChildren()) do
                                            if child:GetAttribute("Temp") or child.Name == LocalPlayer.Name then
                                                paint_model(child)
                                            end
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end)
        end
    end)

    -- Viewmodel offset + chams
    local last_vm_item = nil
    local last_vm_update = 0
    local is_chamming = false
    local last_char_chams = 0
    local cached_vm = Camera:FindFirstChildOfClass("Model")

    local function vmpos(vm)
        if not vm then return end
        local hrp = vm:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local vm_x_v = Library.Flags.vm_x or 0
        local vm_y_v = Library.Flags.vm_y or 0
        local vm_z_v = Library.Flags.vm_z or 0
        local vec = Vector3.new(vm_x_v/10, vm_y_v/10, vm_z_v/10)
        local function apply_joint(name)
            local joint = hrp:FindFirstChild(name)
            if joint and joint:IsA("Motor6D") then
                local orig = joint:GetAttribute("OriginalC0")
                if not orig then orig = joint.C0; joint:SetAttribute("OriginalC0", orig) end
                joint.C0 = orig + vec
            end
        end
        apply_joint("LeftUpperArm"); apply_joint("RightUpperArm")
        apply_joint("ItemRoot");     apply_joint("Motor6D")
    end

    local function vmchams(force) LPH_JIT_MAX(function()
        if is_chamming then return end
        local vm = cached_vm
        if not vm then return end
        local ItemView = vm:FindFirstChild("Item")
        if not force and ItemView == last_vm_item and tick() - last_vm_update < 0.5 then return end
        last_vm_item = ItemView
        last_vm_update = tick()
        is_chamming = true
        task.spawn(function()
            if not vm.Parent then is_chamming = false; return end
            local gun_on  = Library.Flags.vm_gunchams
            local arm_on  = Library.Flags.vm_armchams
            local _guncf  = Library.Flags.vm_guncol
            local gun_col = (_guncf and _guncf.Color) or Color3.new(1,1,1)
            local gun_mat = Library.Flags.vm_gunmat or "SmoothPlastic"
            local _armcf  = Library.Flags.vm_armcol
            local arm_col = (_armcf and _armcf.Color) or Color3.new(1,1,1)
            local arm_mat = Library.Flags.vm_armmat or "SmoothPlastic"
            if ItemView and gun_on then
                for _, v in pairs(ItemView:GetDescendants()) do
                    if (v:IsA("MeshPart") or v:IsA("BasePart")) and v.Transparency < 1
                        and v.Name ~= "Muzzle" and v.Name ~= "SightMark" and v.Name ~= "AimPart"
                        and v.Name ~= "SmokePart" and v.Name ~= "FirePoint" and v.Name ~= "Flash" and v.Name ~= "Flame" then
                        v.Material = Enum.Material[gun_mat] or Enum.Material.SmoothPlastic
                        v.Color = gun_col
                        local sa = v:FindFirstChildOfClass("SurfaceAppearance"); if sa then sa:Destroy() end
                    end
                end
            end
            if arm_on then
                for _, vm_item in pairs(vm:GetChildren()) do
                    if vm_item:IsA("MeshPart") then
                        if vm_item.Name:find("Hand") or vm_item.Name:find("Arm") then
                            vm_item.Material = Enum.Material[arm_mat] or Enum.Material.SmoothPlastic
                            vm_item.Color = arm_col
                        end
                    elseif vm_item:IsA("Model") and (vm_item:FindFirstChild("LL") or vm_item:FindFirstChild("LH")) then
                        for _, shirt_item in pairs(vm_item:GetChildren()) do
                            local sa = shirt_item:FindFirstChildOfClass("SurfaceAppearance"); if sa then sa:Destroy() end
                            shirt_item.Material = Enum.Material[arm_mat] or Enum.Material.SmoothPlastic
                            shirt_item.Color = arm_col
                        end
                    end
                end
            end
            is_chamming = false
        end)
    end)() end

    Camera.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            cached_vm = child
            task.spawn(function()
                child:WaitForChild("HumanoidRootPart", 1)
                task.wait()
                vmpos(child)
            end)
            vmchams(true)
        end
    end)
    Camera.ChildRemoved:Connect(function(child)
        if child == cached_vm then cached_vm = Camera:FindFirstChildOfClass("Model") end
    end)
    local _vm_debounce = false
    Camera.DescendantAdded:Connect(function(d)
        if not cached_vm then return end
        local item = cached_vm:FindFirstChild("Item")
        if not item then return end
        if d ~= item and not d:IsDescendantOf(item) then return end
        if _vm_debounce then return end
        _vm_debounce = true
        task.delay(0.15, function()
            _vm_debounce = false
            vmchams(true)
        end)
    end)

    local function _strip_clothing(v)
        if v:IsA("Shirt") then v.ShirtTemplate = ""
        elseif v:IsA("Pants") then v.PantsTemplate = ""
        elseif v:IsA("ShirtGraphic") then v.Graphic = "" end
    end
    local function _connect_clothing_strip(char)
        for _, v in char:GetChildren() do _strip_clothing(v) end
        char.ChildAdded:Connect(_strip_clothing)
    end
    Players.LocalPlayer.CharacterAdded:Connect(_connect_clothing_strip)
    local _cc = Players.LocalPlayer.Character
    if _cc then _connect_clothing_strip(_cc) end

    cheat.utility.new_heartbeat(LPH_NO_VIRTUALIZE(function()
        if cached_vm then vmpos(cached_vm) end
        local now = tick()
        if now - last_char_chams < 0.5 then return end
        last_char_chams = now
        local char = Players.LocalPlayer.Character
        if char then
            local gun_on  = Library.Flags.vm_gunchams
            local arm_on  = Library.Flags.vm_armchams
            if gun_on or arm_on then
                local _guncf  = Library.Flags.vm_guncol
                local gun_col = (_guncf and _guncf.Color) or Color3.new(1,1,1)
                local gun_mat = Library.Flags.vm_gunmat or "SmoothPlastic"
                local _armcf  = Library.Flags.vm_armcol
                local arm_col = (_armcf and _armcf.Color) or Color3.new(1,1,1)
                local arm_mat = Library.Flags.vm_armmat or "SmoothPlastic"
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("MeshPart") then
                        local is_weapon = v:FindFirstAncestor("Item") or v:FindFirstAncestor("Weapon") or v.Name:find("Gun") or v.Name:find("Handle")
                        if gun_on and is_weapon then
                            if v.Color ~= gun_col or v.Material ~= (Enum.Material[gun_mat] or Enum.Material.SmoothPlastic) or (v:IsA("MeshPart") and v.TextureID ~= "") then
                                v.Material = Enum.Material[gun_mat] or Enum.Material.SmoothPlastic
                                v.Color = gun_col
                                if v:IsA("MeshPart") then v.TextureID = "" end
                                local sa = v:FindFirstChildOfClass("SurfaceAppearance"); if sa then sa:Destroy() end
                            end
                        elseif arm_on then
                            if v.Color ~= arm_col or v.Material ~= (Enum.Material[arm_mat] or Enum.Material.SmoothPlastic) or (v:IsA("MeshPart") and v.TextureID ~= "") then
                                v.Material = Enum.Material[arm_mat] or Enum.Material.SmoothPlastic
                                v.Color = arm_col
                                if v:IsA("MeshPart") then v.TextureID = "" end
                                local sa = v:FindFirstChildOfClass("SurfaceAppearance"); if sa then sa:Destroy() end
                            end
                        end
                    end
                end
            end
        end
        vmchams()
    end))
end

do
    local FCL  = FreecamCat:Section({ Name = "Freecam", Side = 1 })
    cheat.freecam_enabled = false

    local freecam_speed = 50
    local fc_pos, fc_pitch, fc_yaw = nil, 0, 0

    FCL:Toggle({ Name="Freecam", Flag="fc_on", Callback=function(v)
        cheat.freecam_enabled = v
        if v then
            Camera.CameraType = Enum.CameraType.Scriptable
            fc_pos = Camera.CFrame.Position
            fc_pitch, fc_yaw = Camera.CFrame:ToOrientation()
        else
            Camera.CameraType = Enum.CameraType.Custom
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            fc_pos = nil
            local char = Players.LocalPlayer.Character
            local hrp = char and _FindFirstChild(char, "HumanoidRootPart")
            if hrp then hrp.Anchored = false end
        end
    end }):Keybind({ Flag="fc_key", Mode="Toggle", Callback=function(v) if Library.SetFlags["fc_on"] then Library.SetFlags["fc_on"](v) end end })
    FCL:Slider({ Name="Speed", Flag="fc_speed", Min=10, Max=575, Increment=1, Default=50, Callback=function(v) freecam_speed=v end })

    task.spawn(function()
        while task.wait(1/5) do
            local closest, distance = nil, math.huge
            if cheat.freecam_enabled and fc_pos then
                LPH_NO_VIRTUALIZE(function()
                    for _, plr in ipairs(Players:GetPlayers()) do
                        local char = plr.Character
                        if not char then continue end
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if not hrp then continue end
                        local d = (fc_pos - hrp.Position).Magnitude
                        if d < distance then closest, distance = hrp, d end
                    end
                end)()
            end
            Players.LocalPlayer.ReplicationFocus = closest
        end
    end)

    RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(delta)
        local character = Players.LocalPlayer.Character
        local hrp = character and _FindFirstChild(character, "HumanoidRootPart")

        if not cheat.freecam_enabled then
            if hrp then hrp.Anchored = false end
            return
        end
        if not fc_pos then
            fc_pos = Camera.CFrame.Position
            fc_pitch, fc_yaw = Camera.CFrame:ToOrientation()
        end

        -- always lock and rotate with mouse
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        local md = UserInputService:GetMouseDelta()
        fc_pitch = math.clamp(fc_pitch - md.Y * 0.005, -math.pi/2 + 0.01, math.pi/2 - 0.01)
        fc_yaw   = fc_yaw - md.X * 0.005

        local rot      = CFrame.Angles(0, fc_yaw, 0) * CFrame.Angles(fc_pitch, 0, 0)
        local forward  = rot.LookVector
        local right    = rot.RightVector

        local direction = _Vector3new(0, 0, 0)
        direction = _IsKeyDown(UserInputService, Enum.KeyCode.W)           and direction + forward      or direction
        direction = _IsKeyDown(UserInputService, Enum.KeyCode.S)           and direction - forward      or direction
        direction = _IsKeyDown(UserInputService, Enum.KeyCode.D)           and direction + right        or direction
        direction = _IsKeyDown(UserInputService, Enum.KeyCode.A)           and direction - right        or direction
        direction = _IsKeyDown(UserInputService, Enum.KeyCode.Space)       and direction + Vector3.yAxis or direction
        direction = _IsKeyDown(UserInputService, Enum.KeyCode.LeftControl) and direction - Vector3.yAxis or direction

        if direction.Magnitude > 0 then direction = direction.Unit end
        local speed = _IsKeyDown(UserInputService, Enum.KeyCode.LeftShift) and freecam_speed / 10 or freecam_speed
        fc_pos = fc_pos + direction * delta * speed

        Camera.CFrame = CFrame.new(fc_pos) * rot
        if hrp then hrp.Anchored = true end
    end))
end


do
    local MovL  = MoveCat:Section({ Name = "Character", Side = 1 })
    local speed_enabled=false; local speed_mv=18.2
    local tp_enabled=false; local tp_dist_mv=10
    local no_fall=false

    MovL:Toggle({ Name="Speedhack",           Flag="mv_speed",      Callback=function(v) speed_enabled=v end })
    do
        local _red = Color3.fromRGB(255, 70, 70)
        for _, lbl in ipairs(MovL.Items["Content"].Instance:GetDescendants()) do
            if lbl:IsA("TextLabel") and lbl.Text == "Speedhack" then
                lbl.TextColor3 = _red
                if Library.ThemeMap and Library.ThemeMap[lbl] then
                    Library.ThemeMap[lbl].Properties.TextColor3 = function() return _red end
                end
                break
            end
        end
    end
    MovL:Slider({ Name="Speed",               Flag="mv_speedval",   Min=100,Max=220,Increment=1,Default=182, Callback=function(v) speed_mv=v/10 end })
    MovL:Toggle({ Name="Third Person",        Flag="mv_thirdperson",Callback=function(v) tp_enabled=v; if not v then Players.LocalPlayer.CameraMaxZoomDistance=0.5;Players.LocalPlayer.CameraMinZoomDistance=0.5;Players.LocalPlayer.CameraMode=Enum.CameraMode.LockFirstPerson end end }):Keybind({ Flag="mv_tp_key", Mode="Toggle", Callback=function(v) if Library.SetFlags["mv_thirdperson"] then Library.SetFlags["mv_thirdperson"](v) end end })
    MovL:Slider({ Name="3P Distance",         Flag="mv_tpdist",     Min=0,Max=50,Increment=1,Default=10, Callback=function(v) tp_dist_mv=v end })
    MovL:Toggle({ Name="No Fall Damage",      Flag="mv_nofall",     Callback=function(v) no_fall=v end })
    local run_on_water = false
    local water_platform = nil
    local water_ray_params = RaycastParams.new()
    water_ray_params.FilterType = Enum.RaycastFilterType.Exclude
    MovL:Toggle({ Name="Run On Water",        Flag="mv_water",      Callback=function(v)
        run_on_water = v
        if not v and water_platform and water_platform.Parent then
            water_platform:Destroy(); water_platform = nil
        end
    end })
    local mine_remover_conn = nil
    local function get_mine_folder()
        local az = workspace:FindFirstChild("AiZones")
        return az and az:FindFirstChild("OutpostLandmines")
    end
    local function remove_mines_in_workspace()
        local folder = get_mine_folder()
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do pcall(function() obj:Destroy() end) end
        end
    end
    MovL:Toggle({ Name="Remove Mines",        Flag="mv_removemines", Callback=function(v)
        if v then
            remove_mines_in_workspace()
            local folder = get_mine_folder()
            if folder then
                mine_remover_conn = folder.ChildAdded:Connect(function(obj)
                    pcall(function() obj:Destroy() end)
                end)
            end
        else
            if mine_remover_conn then mine_remover_conn:Disconnect(); mine_remover_conn=nil end
        end
    end })


    local _tp_vm_hidden = nil  -- tracks last vm we hid so we can unhide on toggle-off
    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
        local c   = Players.LocalPlayer.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hum then
            if speed_enabled then hum.WalkSpeed=speed_mv end
        end
        if tp_enabled then
            Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
            Players.LocalPlayer.CameraMaxZoomDistance = tp_dist_mv
            Players.LocalPlayer.CameraMinZoomDistance = tp_dist_mv
            if not Window.IsOpen then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                if hrp then
                    local look = Camera.CFrame.LookVector
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(look.X, 0, look.Z))
                end
            end
            if cached_vm and cached_vm ~= _tp_vm_hidden then
                for _, p in ipairs(cached_vm:GetDescendants()) do
                    if p:IsA("BasePart") then p.LocalTransparencyModifier = 1 end
                end
                _tp_vm_hidden = cached_vm
            end
        else
            if _tp_vm_hidden then
                for _, p in ipairs(_tp_vm_hidden:GetDescendants()) do
                    if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
                end
                _tp_vm_hidden = nil
            end
        end
    end))
    cheat.utility.new_heartbeat(function(delta)
        if not no_fall then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                if hrp.AssemblyLinearVelocity.Y < -12.5 then
                    hum:ChangeState(Enum.HumanoidStateType.Landed)
                end
            end
        end
    end)
    cheat.utility.new_heartbeat(function(delta)
        if not run_on_water then return end
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local filter = {char}
        if water_platform and water_platform.Parent then filter[2] = water_platform end
        water_ray_params.FilterDescendantsInstances = filter
        local result = workspace:Raycast(hrp.Position + Vector3.new(0, 2, 0), Vector3.new(0, -10, 0), water_ray_params)
        local over_water = result and result.Instance == workspace.Terrain and result.Material == Enum.Material.Water
        if over_water then
            if not water_platform or not water_platform.Parent then
                water_platform = Instance.new("Part")
                water_platform.Size = Vector3.new(14, 0.2, 14)
                water_platform.Anchored = true
                water_platform.CanCollide = true
                water_platform.Transparency = 1
                water_platform.CanTouch = false
                water_platform.Name = "_tbwaterplat"
                water_platform.Parent = workspace
            end
            water_platform.CFrame = CFrame.new(hrp.Position.X, result.Position.Y, hrp.Position.Z)
        else
            if water_platform and water_platform.Parent then
                water_platform:Destroy(); water_platform = nil
            end
        end
    end)
    -- UG Resolver RenderStep: runs last every frame, pins HRP underground while X held
    RunService:BindToRenderStep("UGResolverRS", Enum.RenderPriority.Last.Value + 1, function()
        if not ug_resolver_holding then return end
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local baseY = ug_resolver_entry_cf and ug_resolver_entry_cf.Position.Y or hrp.Position.Y
        -- allow XZ movement but lock Y underground
        local targetPos = Vector3.new(hrp.Position.X, baseY - ug_resolver_depth, hrp.Position.Z)
        pcall(function() hrp.CFrame = CFrame.new(targetPos) * CFrame.Angles(0, select(2, hrp.CFrame:ToOrientation()), 0) end)
    end)

    UserInputService.InputBegan:Connect(function(input,gp)
        if gp then return end
        if input.KeyCode==Enum.KeyCode.X and ug_resolver_enabled then
            local hrp2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            ug_resolver_entry_cf = hrp2 and hrp2.CFrame or nil
            ug_resolver_holding  = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode==Enum.KeyCode.X then
            ug_resolver_holding = false
            local hrp2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp2 and ug_resolver_entry_cf then
                -- restore Y back to original surface height, keep current XZ
                local restorePos = Vector3.new(hrp2.Position.X, ug_resolver_entry_cf.Position.Y, hrp2.Position.Z)
                pcall(function() hrp2.CFrame = CFrame.new(restorePos) * CFrame.Angles(0, select(2, hrp2.CFrame:ToOrientation()), 0) end)
            end
            ug_resolver_entry_cf = nil
        end
    end)
end

do
    local FlyL = FlyCat:Section({ Name = "Fly Hack", Side = 1 })
    local fly_enabled=false; local fly_speed_f=10; local fly_yspeed_f=10

    FlyL:Toggle({ Name="Fly Hack",  Flag="fly_on",     Callback=function(v) fly_enabled=v end }):Keybind({ Flag="fly_key", Mode="Toggle", Callback=function(v) if Library.SetFlags["fly_on"] then Library.SetFlags["fly_on"](v) end end })
    FlyL:Slider({ Name="Speed",     Flag="fly_speed",  Min=1,Max=50,Increment=1, Callback=function(v) fly_speed_f=v end })
    FlyL:Slider({ Name="Y Speed",   Flag="fly_yspeed", Min=1,Max=50,Increment=1, Callback=function(v) fly_yspeed_f=v end })

    local _fly_parts = {}
    local _fly_parts_char = nil
    local function _rebuild_fly_parts(char)
        _fly_parts = {}
        for _, p in char:GetDescendants() do
            if p:IsA("BasePart") then _fly_parts[#_fly_parts+1] = p end
        end
        _fly_parts_char = char
    end
    Players.LocalPlayer.CharacterAdded:Connect(function(char)
        _fly_parts = {}; _fly_parts_char = nil
        char.DescendantAdded:Connect(function(d) if d:IsA("BasePart") then _fly_parts[#_fly_parts+1]=d end end)
        char.DescendantRemoving:Connect(function(d)
            if d:IsA("BasePart") then
                for i=#_fly_parts,1,-1 do if _fly_parts[i]==d then table.remove(_fly_parts,i); break end end
            end
        end)
        _rebuild_fly_parts(char)
    end)
    local _init_char = Players.LocalPlayer.Character
    if _init_char then
        _init_char.DescendantAdded:Connect(function(d) if d:IsA("BasePart") then _fly_parts[#_fly_parts+1]=d end end)
        _init_char.DescendantRemoving:Connect(function(d)
            if d:IsA("BasePart") then
                for i=#_fly_parts,1,-1 do if _fly_parts[i]==d then table.remove(_fly_parts,i); break end end
            end
        end)
        _rebuild_fly_parts(_init_char)
    end

    cheat.utility.new_heartbeat(LPH_JIT_MAX(function(delta)
        local c   = Players.LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if fly_enabled and hrp then
            local cl  = Camera.CFrame.LookVector
            cl = Vector3.new(cl.X,0,cl.Z)
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cl end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cl end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Vector3.new(-cl.Z,0,cl.X) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir+Vector3.new(cl.Z,0,-cl.X) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then dir=dir+Vector3.yAxis end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.yAxis end
            if dir~=Vector3.zero then dir=dir.Unit end
            local ccf = cheat.real_CFrame or hrp.CFrame
            local ncf = ccf
                + Vector3.new(dir.X,0,dir.Z)*(fly_speed_f*delta)
                + Vector3.yAxis*(dir.Y*fly_yspeed_f*delta)
            hrp.CFrame = ncf
            if cheat.real_CFrame then cheat.real_CFrame=ncf end
            if c ~= _fly_parts_char then _rebuild_fly_parts(c) end
            for _i=1,#_fly_parts do _fly_parts[_i].AssemblyLinearVelocity=Vector3.zero end
        end
    end))
end

do
    local SndL = SoundCat:Section({ Name = "Custom Sounds", Side = 1 })
    local hitsound_options = {"never lose","rust","gamesense","fatalety","fahhhh","csgo kill","csgo headshot","minecraft bow","fortnite headshot","arsenal headshot","fallen headshot","mogged","moan","mommy asmr"}
    local hitsound_ids = {
        ["never lose"]        ="rbxassetid://6607204501",
        ["rust"]              ="rbxassetid://4764109000",
        ["gamesense"]         ="rbxassetid://4817809188",
        ["fatalety"]          ="rbxassetid://94204395881101",
        ["fahhhh"]            ="rbxassetid://134512042804789",
        ["csgo kill"]         ="rbxassetid://7269900245",
        ["csgo headshot"]     ="rbxassetid://6937353691",
        ["minecraft bow"]     ="rbxassetid://1053296915",
        ["fortnite headshot"] ="rbxassetid://2513174484",
        ["arsenal headshot"]  ="rbxassetid://8522515167",
        ["fallen headshot"]   ="rbxassetid://988593556",
        ["mogged"]            ="rbxassetid://130607335183129",
        ["moan"]              ="rbxassetid://7606020137",
        ["mommy asmr"]        ="rbxassetid://111500468013640",
    }
    local gunsound_options = {"minecraft bow","oof","fart","hee hee","this is sparta","godzilla","roger that"}
    local gunsound_ids = {
        ["minecraft bow"]  ="rbxassetid://3442683707",
        ["oof"]            ="rbxassetid://3060494212",
        ["fart"]           ="rbxassetid://3068648094",
        ["hee hee"]        ="rbxassetid://3048623108",
        ["this is sparta"] ="rbxassetid://130781067",
        ["godzilla"]       ="rbxassetid://130783046",
        ["roger that"]     ="rbxassetid://135308704",
    }
    local MOAN_ID = "rbxassetid://7606020137"
    local custom_hs_enabled=false; local custom_hs_id=hitsound_ids["never lose"]; local custom_hs_vol=1
    local custom_gs_enabled=false; local custom_gs_id=gunsound_ids["oof"];        local custom_gs_vol=1
    cheat._custom_gs_enabled=false; cheat._custom_gs_id=gunsound_ids["oof"]; cheat._custom_gs_vol=1

    SndL:Toggle({ Name="Custom Hit Sound",  Flag="snd_hs_on",   Callback=function(v) custom_hs_enabled=v end })
    SndL:Dropdown({ Name="Hit Sound",       Flag="snd_hs_pick", Options=hitsound_options, Callback=function(v) custom_hs_id=hitsound_ids[v] or custom_hs_id end })
    SndL:Slider({ Name="Hit Volume",        Flag="snd_hs_vol",  Min=1,Max=500,Increment=1, Callback=function(v) custom_hs_vol=v/100 end })
    SndL:Button({ Name="Test Hit Sound",    Flag="snd_hs_test", Callback=function() local s=Instance.new("Sound");s.SoundId=custom_hs_id;s.Volume=custom_hs_vol;if custom_hs_id==MOAN_ID then s.TimePosition=2 end;s.Parent=game:GetService("SoundService");s:Play();if custom_hs_id==MOAN_ID then task.delay(0.9,function() if s and s.Parent then s:Stop() end end) end;game:GetService("Debris"):AddItem(s,5) end })
    SndL:Toggle({ Name="Custom Gun Sound",  Flag="snd_gs_on",   Callback=function(v) custom_gs_enabled=v; cheat._custom_gs_enabled=v end })
    SndL:Dropdown({ Name="Gun Sound",       Flag="snd_gs_pick", Options=gunsound_options, Callback=function(v) custom_gs_id=gunsound_ids[v] or custom_gs_id; cheat._custom_gs_id=custom_gs_id end })
    SndL:Slider({ Name="Gun Volume",        Flag="snd_gs_vol",  Min=1,Max=500,Increment=1, Callback=function(v) custom_gs_vol=v/100; cheat._custom_gs_vol=custom_gs_vol end })
    SndL:Button({ Name="Test Gun Sound",    Flag="snd_gs_test", Callback=function() local s=Instance.new("Sound");s.SoundId=custom_gs_id;s.Volume=custom_gs_vol;s.Parent=game:GetService("SoundService");s:Play();game:GetService("Debris"):AddItem(s,5) end })

    local hitsound_detect = {["rbxassetid://4585382589"]=true,["rbxassetid://4585351098"]=true,["rbxassetid://4585382046"]=true,["rbxassetid://4585364605"]=true}
    local function apply_custom_hitsound(sound)
        if sound:IsA("Sound") and custom_hs_enabled and hitsound_detect[sound.SoundId] then
            sound.SoundId = custom_hs_id
            sound.Volume  = custom_hs_vol
            if custom_hs_id == MOAN_ID then
                sound.TimePosition = 2
                task.delay(0.9, function() if sound and sound.Parent then sound:Stop() end end)
            end
        end
    end
    local pg = Players.LocalPlayer:WaitForChild("PlayerGui", 10)
    pg.ChildAdded:Connect(function(child)
        if child.Name=="MainGui" then
            child.ChildAdded:Connect(apply_custom_hitsound)
        end
    end)
    local existing_maingui = pg:FindFirstChild("MainGui")
    if existing_maingui then
        existing_maingui.ChildAdded:Connect(apply_custom_hitsound)
    end

    local gun_sound_names_set = {FireSound=true, FireFarSound=true, FireSoundSupressed=true}
    local function apply_custom_gunsound(inst)
        if not (inst:IsA("Sound") and gun_sound_names_set[inst.Name] and custom_gs_enabled) then return end
        if not (inst:IsDescendantOf(Camera) or (Players.LocalPlayer.Character and inst:IsDescendantOf(Players.LocalPlayer.Character))) then return end
        inst.SoundId = custom_gs_id
        inst.Volume  = custom_gs_vol
    end
    Camera.DescendantAdded:Connect(apply_custom_gunsound)
    Players.LocalPlayer.CharacterAdded:Connect(function(char)
        char.DescendantAdded:Connect(apply_custom_gunsound)
    end)
    local char = Players.LocalPlayer.Character
    if char then
        char.DescendantAdded:Connect(apply_custom_gunsound)
        for _, d in ipairs(char:GetDescendants()) do apply_custom_gunsound(d) end
    end
    for _, d in ipairs(Camera:GetDescendants()) do apply_custom_gunsound(d) end
end

do
    local DetL = DetectCat:Section({ Name = "Detection", Side = 1 })
    local mod_detector=true; local cheat_detector=false; local mod_alerted={}; local cheater_alerted={}

    DetL:Toggle({ Name="Mod Detector",    Flag="det_mod", Default=true, Callback=function(v) mod_detector=v; if v then Notify("Mod Detector enabled",3) end end })
    DetL:Toggle({ Name="Cheater Detector",Flag="det_cheat", Callback=function(v) cheat_detector=v; if v then Notify("Cheater Detector enabled",3) end end })

    -- ================================================================
    -- My Profile: compact floating/draggable local-player statistics.
    -- ================================================================
    local profile_gui = Instance.new("ScreenGui")
    profile_gui.Name = "TomboyMyProfile"
    profile_gui.ResetOnSpawn = false
    profile_gui.IgnoreGuiInset = true
    profile_gui.Enabled = false
    profile_gui.Parent = gethui()

    local profile_frame = Instance.new("Frame")
    profile_frame.Size = UDim2.fromOffset(235, 150)
    profile_frame.Position = UDim2.new(1, -250, 0, 220)
    profile_frame.BackgroundColor3 = Color3.fromRGB(13,16,22)
    profile_frame.BorderSizePixel = 0
    profile_frame.Active = true
    profile_frame.Parent = profile_gui

    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0,9); pc.Parent = profile_frame
    local ps = Instance.new("UIStroke"); ps.Color = Color3.fromRGB(45,52,65); ps.Thickness = 1; ps.Parent = profile_frame

    local profile_avatar = Instance.new("ImageLabel")
    profile_avatar.Size = UDim2.fromOffset(42,42)
    profile_avatar.Position = UDim2.fromOffset(9,9)
    profile_avatar.BackgroundTransparency = 1
    profile_avatar.Parent = profile_frame
    local pac = Instance.new("UICorner"); pac.CornerRadius = UDim.new(1,0); pac.Parent = profile_avatar

    local profile_title = Instance.new("TextLabel")
    profile_title.Size = UDim2.new(1,-62,0,24)
    profile_title.Position = UDim2.fromOffset(59,7)
    profile_title.BackgroundTransparency = 1
    profile_title.Font = Enum.Font.GothamBold
    profile_title.TextSize = 13
    profile_title.TextXAlignment = Enum.TextXAlignment.Left
    profile_title.TextColor3 = Color3.fromRGB(235,240,248)
    profile_title.Text = LocalPlayer.DisplayName
    profile_title.Parent = profile_frame

    local profile_user = Instance.new("TextLabel")
    profile_user.Size = UDim2.new(1,-62,0,18)
    profile_user.Position = UDim2.fromOffset(59,29)
    profile_user.BackgroundTransparency = 1
    profile_user.Font = Enum.Font.Gotham
    profile_user.TextSize = 10
    profile_user.TextXAlignment = Enum.TextXAlignment.Left
    profile_user.TextColor3 = Color3.fromRGB(135,145,160)
    profile_user.Text = "@" .. LocalPlayer.Name
    profile_user.Parent = profile_frame

    local profile_stats = Instance.new("TextLabel")
    profile_stats.Size = UDim2.new(1,-18,0,78)
    profile_stats.Position = UDim2.fromOffset(9,61)
    profile_stats.BackgroundTransparency = 1
    profile_stats.Font = Enum.Font.GothamMedium
    profile_stats.TextSize = 11
    profile_stats.TextXAlignment = Enum.TextXAlignment.Left
    profile_stats.TextYAlignment = Enum.TextYAlignment.Top
    profile_stats.TextColor3 = Color3.fromRGB(184,193,207)
    profile_stats.Text = "KDR  --\nKILLS  --    DEATHS  --\nTEMPO  00:00:00\nREPORTS  --"
    profile_stats.Parent = profile_frame

    task.spawn(function()
        pcall(function()
            local img = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            profile_avatar.Image = img
        end)
    end)

    local profile_started = tick()
    local profile_open = false

    -- Cache the expensive report lookup. The old implementation traversed all
    -- descendants every 0.5s, which could produce periodic frame spikes.
    local profile_reports_cache = 0
    local profile_reports_last_scan = 0
    local PROFILE_REPORT_REFRESH = 5

    local function profile_report_count(force)
        local now = os.clock()
        if not force and (now - profile_reports_last_scan) < PROFILE_REPORT_REFRESH then
            return profile_reports_cache
        end

        profile_reports_last_scan = now

        local report_names = {
            Reports=true, Report=true, ReportCount=true, ReportsCount=true,
            TotalReports=true, TotalReport=true,
            ReceivedReports=true, ReceivedReportCount=true,
            ReportedCount=true, ReportsReceived=true
        }

        local function read_report_number(value)
            if type(value) == "number" then
                return math.max(0, math.floor(value))
            end
            local n = tonumber(value)
            if n then return math.max(0, math.floor(n)) end
            return nil
        end

        local function find_report_count(root)
            if not root then return nil end

            for name in pairs(report_names) do
                local n = read_report_number(root:GetAttribute(name))
                if n ~= nil then return n end
            end

            for _, obj in ipairs(root:GetDescendants()) do
                for name in pairs(report_names) do
                    local n = read_report_number(obj:GetAttribute(name))
                    if n ~= nil then return n end
                end
                if report_names[obj.Name] then
                    local ok, value = pcall(function() return obj.Value end)
                    if ok then
                        local n = read_report_number(value)
                        if n ~= nil then return n end
                    end
                end
            end
            return nil
        end

        local rsp = ReplicatedStorage:FindFirstChild("Players")
        local pdata = rsp and rsp:FindFirstChild(LocalPlayer.Name)

        profile_reports_cache = find_report_count(LocalPlayer)
            or find_report_count(pdata)
            or 0

        return profile_reports_cache
    end

    local function refresh_profile(force_report_scan)
        local rsp = ReplicatedStorage:FindFirstChild("Players")
        local pdata = rsp and rsp:FindFirstChild(LocalPlayer.Name)
        local status = pdata and pdata:FindFirstChild("Status")
        local journey = status and status:FindFirstChild("Journey")
        local wipe = journey and journey:FindFirstChild("WipeStatistics")

        local kills = wipe and tonumber(wipe:GetAttribute("Kills")) or 0
        local deaths = wipe and tonumber(wipe:GetAttribute("Deaths")) or 0
        local kdr = deaths > 0 and kills/deaths or kills

        local elapsed = math.max(0, math.floor(tick() - profile_started))
        local h = math.floor(elapsed/3600)
        local m = math.floor((elapsed%3600)/60)
        local sec = elapsed%60

        local reports = profile_report_count(force_report_scan)

        profile_stats.Text = string.format(
            "KDR  %.2f\nKILLS  %d    DEATHS  %d\nTEMPO  %02d:%02d:%02d\nREPORTS  %d",
            kdr, kills, deaths, h, m, sec, reports or 0
        )
    end

    do
        local dragging, drag_start, start_pos = false, nil, nil
        profile_frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; drag_start = input.Position; start_pos = profile_frame.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - drag_start
                profile_frame.Position = UDim2.new(start_pos.X.Scale,start_pos.X.Offset+d.X,start_pos.Y.Scale,start_pos.Y.Offset+d.Y)
            end
        end)
    end

    DetL:Toggle({ Name="My Profile", Flag="det_my_profile", Default=false, Callback=function(v)
        profile_open = v
        profile_gui.Enabled = v
        if v then refresh_profile(true) end
    end })

    task.spawn(function()
        while true do
            task.wait(1)
            if profile_open then
                -- Kills/deaths/time update every second; report lookup is cached.
                pcall(refresh_profile)
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(3)
            pcall(function()
                for _,plr in ipairs(Players:GetPlayers()) do
                    if plr~=Players.LocalPlayer then
                        if cheat_detector and not cheater_alerted[plr.Name] then
                            local rsp = ReplicatedStorage:FindFirstChild("Players") and ReplicatedStorage.Players:FindFirstChild(plr.Name)
                            if rsp then
                                local st=rsp:FindFirstChild("Status"); local j=st and st:FindFirstChild("Journey"); local w=j and j:FindFirstChild("WipeStatistics")
                                if w then
                                    local d=w:GetAttribute("Deaths") or 1; if d==0 then d=1 end
                                    local k=w:GetAttribute("Kills") or 0; local kdr=math.floor(k/d*10)/10
                                    if k>=15 and kdr>=5 then cheater_alerted[plr.Name]=true; Notify("Suspected cheater: "..plr.Name.." KDR:"..kdr,10,Color3.fromRGB(255,100,0)) end
                                end
                            end
                        end
                        if mod_detector and plr.Character and not mod_alerted[plr.Name] then
                            local rsp = ReplicatedStorage:FindFirstChild("Players") and ReplicatedStorage.Players:FindFirstChild(plr.Name)
                            if rsp then
                                local st=rsp:FindFirstChild("Status")
                                if st and st:FindFirstChild("GameplayVariables") then
                                    local pl=st.GameplayVariables:GetAttribute("PremiumLevel")
                                    if pl and pl>=4 then mod_alerted[plr.Name]=true; Notify("Mod detected: "..plr.Name,10,Color3.fromRGB(255,50,50)) end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end


local _hl_last_size, _hl_last_font
cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
    if not cheat.hitlogs_enabled then
        for _, log in ipairs(cheat.hitlogs.active) do
            if log.drawing then log.drawing:Remove() end
            if log.bg then log.bg:Remove() end
            if log.line then log.line:Remove() end
        end
        cheat.hitlogs.active = {}
        cheat.hitlogs.pending = {}
        return
    end

    local current_time = os.clock()
    for i = #cheat.hitlogs.pending, 1, -1 do
        local pending = cheat.hitlogs.pending[i]
        local is_valid = false
        local is_resolved = false

        local current_hp = 0
        if pending.hum and pending.hum.Parent then
            current_hp = pending.hum.Parent:GetAttribute("Health") or pending.hum.Health
        else
            is_valid = true
            is_resolved = true
        end

        if not is_resolved and current_hp < pending.start_hp then
            is_valid = true
            is_resolved = true
        end

        if not is_resolved and current_time - pending.tick > 0.4 then
            is_valid = false
            is_resolved = true
        end

        if is_resolved then
            local str = string.format("%s hit %s on %dm", pending.name, pending.part, pending.dist)
            local log_color = is_valid and cheat.hitlogs_valid_color or cheat.hitlogs_invalid_color

            local bg = cheat.utility.new_drawing("Square", {
                Size = _Vector2new(0, 0), Position = _Vector2new(-300, cheat.hitlogs_y),
                Color = Color3.fromRGB(20, 20, 20), Filled = true, Transparency = 1,
                Visible = true, ZIndex = 98
            })
            local line = cheat.utility.new_drawing("Square", {
                Size = _Vector2new(3, 0), Position = _Vector2new(-300, cheat.hitlogs_y),
                Color = log_color, Filled = true, Transparency = 1,
                Visible = true, ZIndex = 99
            })
            local text = cheat.utility.new_drawing("Text", {
                Text = str, Size = cheat.hitlogs_size, Font = cheat.hitlogs_font,
                Center = false, Outline = true, Color = Color3.new(1, 1, 1),
                Position = _Vector2new(-300, cheat.hitlogs_y), Visible = true, ZIndex = 100
            })
            table.insert(cheat.hitlogs.active, 1, {
                drawing = text, bg = bg, line = line, str = str, spawn_tick = current_time,
                target_y = cheat.hitlogs_y, current_x = -300
            })
            table.remove(cheat.hitlogs.pending, i)
        end
    end

    local base_y = cheat.hitlogs_y
    for i = #cheat.hitlogs.active, 1, -1 do
        local log = cheat.hitlogs.active[i]
        local age = current_time - log.spawn_tick
        if age > 5 then
            if log.drawing then log.drawing:Remove() end
            if log.bg then log.bg:Remove() end
            if log.line then log.line:Remove() end
            table.remove(cheat.hitlogs.active, i)
        else
            if log.current_x < 20 then
                log.current_x = log.current_x + (20 - log.current_x) * 0.15
            end

            local text_bounds = log.drawing.TextBounds
            local box_height = text_bounds.Y + 8
            local box_width = text_bounds.X + 16

            log.target_y = base_y + ((i - 1) * (box_height + 4))
            local current_y = log.drawing.Position.Y
            local new_y = current_y + (log.target_y - current_y) * 0.2
            local alpha = 1
            if age > 4 then alpha = 1 - (age - 4) end

            log.drawing.Position = _Vector2new(log.current_x + 8, new_y + 4)
            log.drawing.Transparency = alpha
            if cheat.hitlogs_size ~= _hl_last_size then _hl_last_size=cheat.hitlogs_size; log.drawing.Size=cheat.hitlogs_size end
            if cheat.hitlogs_font ~= _hl_last_font then _hl_last_font=cheat.hitlogs_font; log.drawing.Font=cheat.hitlogs_font end

            log.bg.Position = _Vector2new(log.current_x, new_y)
            log.bg.Size = _Vector2new(box_width, box_height)
            log.bg.Transparency = alpha

            log.line.Position = _Vector2new(log.current_x, new_y)
            log.line.Size = _Vector2new(3, box_height)
            log.line.Transparency = alpha
        end
    end
end))

local random_part_timer = tick()
local available_random_parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperLeg", "RightUpperLeg", "LeftLowerArm", "RightLowerArm"}
local corner_shoot_params = RaycastParams.new()
corner_shoot_params.FilterType = Enum.RaycastFilterType.Exclude
local corner_shoot_filter = {nil, nil, nil}
local _manip_frame    = 0
local _cached_dirs    = nil
local _cached_dir_cf  = nil
local _cached_nocollision = workspace:FindFirstChild("NoCollision")

cheat.utility.new_heartbeat(LPH_JIT_MAX(function(delta)
    if silent_aim.random_part and tick() - random_part_timer > (1 / 50) then
        random_part_timer = tick()
        silent_aim.part = available_random_parts[math.random(1, #available_random_parts)]
    end

    -- Only scan for a target when something actually consumes one. When idle
    -- (aim/triggerbot/tpkill/packet-shoot/inv-viewer/crosshair-status all off and
    -- AA isn't facing a target) this skips a full per-frame players+NPC scan with a
    -- WorldToViewportPoint per candidate — the biggest idle-CPU cost in the loop.
    local need_target = silent_aim.enabled
        or silent_aim.triggerbot
        or silent_aim.corner_shoot
        or packetautoshoot
        or tpkill_enabled
        or silent_aim.crosshair_status
        or Library.Flags.inv_on
        or (aa_enabled and (aa_mode == "Reverse" or aa_mode == "Random"))
    if not need_target then
        silent_aim.target_part      = nil
        silent_aim.is_npc           = false
        silent_aim.isvisible        = false
        silent_aim.manipulated      = false
        silent_aim.manipulated_origin = nil
        return
    end

    local indtxt = ""
    silent_aim.target_part, silent_aim.is_npc = get_closest_target(silent_aim.fov, get_silent_fov_radius(), silent_aim.part, silent_aim.target_npc, silent_aim.target_heli)

    -- Final consistency guard: every Silent Aim target must remain inside the
    -- exact same center/radius used by the FOV drawing.
    if silent_aim.target_part then
        local vp = Camera.ViewportSize
        local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
        local screen, onScreen = Camera:WorldToViewportPoint(silent_aim.target_part.Position)
        local screenPos = Vector2.new(screen.X, screen.Y)
        local same_fov = onScreen and screen.Z > 0 and (screenPos - center).Magnitude <= get_silent_fov_radius()
        if not same_fov then
            silent_aim.target_part = nil
            silent_aim.is_npc = false
        end
    end

    silent_aim.manipulated = false
    local old_origin = silent_aim.manipulated_origin
    silent_aim.manipulated_origin = nil
    if silent_aim.target_part then
        local tp_active = tpkill_enabled
        if silent_aim.corner_shoot and not tp_active then
            local hitpart = silent_aim.target_part
            local camera = workspace.CurrentCamera
            if camera then
                local base_pos = camera.CFrame.Position
                local target_pos = hitpart.Position
                corner_shoot_filter[1] = LocalPlayer.Character
                corner_shoot_filter[2] = camera
                corner_shoot_filter[3] = _cached_nocollision
                corner_shoot_params.FilterDescendantsInstances = corner_shoot_filter
                local res = workspace:Raycast(base_pos, target_pos - base_pos, corner_shoot_params)
                if not res or (res.Instance and res.Instance:IsDescendantOf(hitpart.Parent)) then
                    silent_aim.isvisible = true
                else
                    silent_aim.isvisible = false
                    -- throttle: skip full scan on frames 1 and 2, run on frame 0
                    _manip_frame = (_manip_frame + 1) % 3
                    if _manip_frame ~= 0 and old_origin then
                        silent_aim.manipulated_origin = old_origin
                        silent_aim.manipulated = true
                    else
                    local found_origin = nil
                    local max_dist = silent_aim.corner_shoot_dist

                    -- cache sorted directions; only rebuild if camera rotated >5 degrees
                    local cam_cf = camera.CFrame
                    local to_target_dir = (target_pos - base_pos).Unit
                    if not _cached_dirs or not _cached_dir_cf
                        or math.abs(_cached_dir_cf.RightVector:Dot(cam_cf.RightVector)) < 0.996 then
                        local right = cam_cf.RightVector
                        local up    = cam_cf.UpVector
                        _cached_dirs = {
                            right, -right, up, -up,
                            (right + up).Unit,  (-right + up).Unit,
                            (right - up).Unit,  (-right - up).Unit,
                            (right + to_target_dir).Unit, (-right + to_target_dir).Unit,
                        }
                        table.sort(_cached_dirs, function(a, b)
                            return a:Dot(to_target_dir) > b:Dot(to_target_dir)
                        end)
                        _cached_dir_cf = cam_cf
                    end
                    local raw_dirs = _cached_dirs

                    -- try cached origin first, but reject if target moved far
                    if old_origin then
                        local offset = old_origin - base_pos
                        local cache_to_target = (target_pos - old_origin)
                        if offset.Magnitude <= max_dist + 2 and cache_to_target.Magnitude < 600 then
                            local to_origin_res = workspace:Raycast(base_pos, offset, corner_shoot_params)
                            if not to_origin_res then
                                local to_target_res = workspace:Raycast(old_origin, cache_to_target, corner_shoot_params)
                                if not to_target_res or (to_target_res.Instance and to_target_res.Instance:IsDescendantOf(hitpart.Parent)) then
                                    found_origin = old_origin
                                end
                            end
                        end
                    end

                    -- full scan, 1-stud steps, 10 directions sorted toward target
                    local char_model = hitpart.Parent
                    if not found_origin then
                        local n_dirs = #raw_dirs
                        for d = 1, max_dist, 1 do
                            for _di = 1, n_dirs do
                                local dir    = raw_dirs[_di]
                                local offset = dir * d
                                local origin = base_pos + offset
                                if not workspace:Raycast(base_pos, offset, corner_shoot_params) then
                                    local r = workspace:Raycast(origin, target_pos - origin, corner_shoot_params)
                                    if not r or (r.Instance and r.Instance:IsDescendantOf(char_model)) then
                                        local buf_offset = dir * (d + 1.5)
                                        local buf_origin = base_pos + buf_offset
                                        if not workspace:Raycast(base_pos, buf_offset, corner_shoot_params) then
                                            local br = workspace:Raycast(buf_origin, target_pos - buf_origin, corner_shoot_params)
                                            if not br or (br.Instance and br.Instance:IsDescendantOf(char_model)) then
                                                found_origin = buf_origin
                                                break
                                            end
                                        end
                                        if not found_origin then found_origin = origin; break end
                                    end
                                end
                            end
                            if found_origin then break end
                        end
                    end

                    if found_origin then
                        silent_aim.manipulated = true
                        silent_aim.manipulated_origin = found_origin
                    else
                        silent_aim.manipulated_origin = nil
                    end
                    end -- throttle else
                end
            end
        else
            silent_aim.isvisible = cheat.utility.is_visible(Camera.CFrame, silent_aim.target_part.Parent, silent_aim.target_part) or false
        end
    else
        silent_aim.isvisible = false
    end

    if silent_aim.crosshair_status then
        if silent_aim.target_part then
            local _vis = silent_aim.isvisible and " (visible)" or ""
            local _npc = silent_aim.is_npc and " (ai)" or ""
            silent_aim.indicator_text = silent_aim.target_part.Parent.Name.._vis.._npc
        else
            silent_aim.indicator_text = ""
        end
    end

    if packetautoshoot then
        cheat.shoot_weapon_packet(silent_aim.isvisible, shootspeed, packetpred, packetscan, packetthruscan)
    end

    local triggerable = silent_aim.isvisible
    if silent_aim.triggerbot_manipulation and silent_aim.manipulated_origin ~= nil then
        triggerable = true
    end
    if silent_aim.triggerbot and not triggerable then
        local alt_part, alt_npc = get_closest_target(silent_aim.fov, get_silent_fov_radius(), silent_aim.part, silent_aim.target_npc, silent_aim.target_heli, true, silent_aim.triggerbot_manipulation, silent_aim.manipulated_origin)
        if alt_part then
            silent_aim.target_part = alt_part
            silent_aim.is_npc = alt_npc
            triggerable = true
        end
    end

    local tp_tbot = tpkill_enabled and tpkill_autotbot
    if (silent_aim.triggerbot or tp_tbot) and silent_aim.target_part and triggerable then
        if not silent_aim._trigger_held then
            silent_aim._trigger_held = true
            if mouse1press then mouse1press() end
        end
    else
        if silent_aim._trigger_held then
            silent_aim._trigger_held = false
            if mouse1release then mouse1release() end
        end
    end
end))






-- ================================================================
-- QUEST MODULE INTEGRATION / OBJECTIVE ESP
-- Loads the game's ReplicatedStorage.Modules.Quests data instead of
-- duplicating the 86 KB quest table into the main script.
-- Read-only: this integration does not activate, hand over, or
-- complete quests by itself.
-- ================================================================
do
    local QuestCat = VisualsPage:Section({ Name = "Quest Objectives", Side = 2 })
    local quest_module
    local quest_module_ok = false

    pcall(function()
        local mod = ReplicatedStorage:FindFirstChild("Modules")
        local quests_mod = mod and mod:FindFirstChild("Quests")
        if quests_mod then
            quest_module = require(quests_mod)
            quest_module_ok = type(quest_module) == "table"
        end
    end)

    local quest_esp_enabled = false
    local quest_info_enabled = false
    local quest_drawings = {}
    local quest_last_scan = 0
    local quest_cache = {}
    -- Quest Objective ESP uses its own fixed range and never inherits the player ESP distance slider.
    local QUEST_FIXED_DISTANCE = 5000

    local function quest_new_draw(kind, props)
        local ok, obj = pcall(Drawing.new, kind)
        if not ok or not obj then return nil end
        for k, v in pairs(props or {}) do
            pcall(function() obj[k] = v end)
        end
        table.insert(quest_drawings, obj)
        return obj
    end

    local quest_title = quest_new_draw("Text", {
        Visible = false, Center = true, Outline = true,
        Size = 16, Text = "", ZIndex = 200
    })
    local quest_lines = {}
    for i = 1, 12 do
        quest_lines[i] = quest_new_draw("Text", {
            Visible = false, Center = false, Outline = true,
            Size = 14, Text = "", ZIndex = 200
        })
    end

    local function quest_hide_drawings()
        if quest_title then quest_title.Visible = false end
        for _, d in ipairs(quest_lines) do d.Visible = false end
    end

    local function quest_get_active()
        if not quest_module_ok then return nil end
        local players_folder = ReplicatedStorage:FindFirstChild("Players")
        local pdata = players_folder and players_folder:FindFirstChild(LocalPlayer.Name)
        local status = pdata and pdata:FindFirstChild("Status")
        local journey = status and status:FindFirstChild("Journey")
        local quests_folder = journey and journey:FindFirstChild("Quests")
        if not quests_folder then return nil end

        for _, q in ipairs(quests_folder:GetChildren()) do
            if q:GetAttribute("State") == "Active" then
                return q
            end
        end
        return nil
    end

    local function quest_get_description(def, objective_obj)
        local desc = objective_obj:GetAttribute("Description")
        if type(desc) == "string" and desc ~= "" then return desc end
        if type(def) == "table" then
            local obj_def = def.Objectives
            if type(obj_def) == "table" then
                for key, value in pairs(obj_def) do
                    if key == objective_obj.Name and type(value) == "table" then
                        if type(value.Description) == "string" then
                            return value.Description
                        end
                    end
                end
            end
        end
        return objective_obj.Name
    end

    local function quest_build_cache()
        quest_cache = {}
        local active = quest_get_active()
        if not active then return nil end

        local def = quest_module and quest_module.Quests and quest_module.Quests[active.Name]
        local info = { name = active.Name, objectives = {}, definition = def }

        for _, obj in ipairs(active:GetChildren()) do
            local complete = obj:GetAttribute("Complete")
            local carrying = obj:GetAttribute("Carrying")
            local placed = obj:GetAttribute("Placed")
            local done = complete or carrying or placed
            local position

            if type(def) == "table" and type(def.Objectives) == "table" then
                local obj_def = def.Objectives[obj.Name]
                if type(obj_def) == "table" and typeof(obj_def.Position) == "Vector3" then
                    position = obj_def.Position
                end
            end

            table.insert(info.objectives, {
                object = obj,
                text = quest_get_description(def, obj),
                done = done,
                position = position
            })
        end

        quest_cache = info
        return info
    end

    QuestCat:Toggle({
        Name = "Quest Objective ESP",
        Flag = "quest_objective_esp",
        Callback = function(v)
            quest_esp_enabled = v
            if not v then quest_hide_drawings() end
        end
    })

    QuestCat:Toggle({
        Name = "Active Quest Info",
        Flag = "quest_active_info",
        Callback = function(v)
            quest_info_enabled = v
            if not v then quest_hide_drawings() end
        end
    })

    if not quest_module_ok then
        QuestCat:Label("Quest module unavailable")
    end

    cheat.utility.new_renderstepped(function()
        if not quest_esp_enabled and not quest_info_enabled then
            quest_hide_drawings()
            return
        end

        local now = tick()
        if now - quest_last_scan >= 0.5 then
            quest_last_scan = now
            pcall(quest_build_cache)
        end

        local info = quest_cache
        if not info then
            quest_hide_drawings()
            return
        end

        local cam = workspace.CurrentCamera
        local viewport = cam and cam.ViewportSize
        if not cam or not viewport then
            quest_hide_drawings()
            return
        end

        if quest_info_enabled and quest_title then
            quest_title.Text = "Quest: " .. tostring(info.name)
            quest_title.Position = Vector2.new(viewport.X * 0.5, 70)
            quest_title.Visible = true
        else
            if quest_title then quest_title.Visible = false end
        end

        local line_index = 0
        for _, obj in ipairs(info.objectives) do
            if line_index >= #quest_lines then break end
            line_index += 1

            if quest_info_enabled then
                local prefix = obj.done and "[✓] " or "[ ] "
                quest_lines[line_index].Text = prefix .. tostring(obj.text)
                quest_lines[line_index].Position = Vector2.new(25, 100 + ((line_index - 1) * 18))
                quest_lines[line_index].Visible = true
            else
                quest_lines[line_index].Visible = false
            end

            if quest_esp_enabled and obj.position and not obj.done then
                -- Missions intentionally have their own fixed 5000 m range.
                -- Do not use esp_table.main_settings.maxdistance or the normal ESP Distance slider here.
                local camera_pos = cam.CFrame.Position
                local quest_distance = (camera_pos - obj.position).Magnitude / 3
                local screen, visible = cam:WorldToViewportPoint(obj.position)

                if visible and screen.Z > 0 and quest_distance <= QUEST_FIXED_DISTANCE then
                    quest_lines[line_index].Text = tostring(obj.text) .. "  [" .. math.floor(quest_distance + 0.5) .. "m]"
                    quest_lines[line_index].Position = Vector2.new(screen.X, screen.Y)
                    quest_lines[line_index].Visible = true
                elseif quest_info_enabled then
                    -- Keep the Active Quest Info text visible even when its world marker is
                    -- outside the fixed Quest Objective ESP range.
                    quest_lines[line_index].Text = (obj.done and "[✓] " or "[ ] ") .. tostring(obj.text)
                    quest_lines[line_index].Position = Vector2.new(25, 100 + ((line_index - 1) * 18))
                    quest_lines[line_index].Visible = true
                else
                    quest_lines[line_index].Visible = false
                end
            end
        end

        for i = line_index + 1, #quest_lines do
            quest_lines[i].Visible = false
        end
    end)
end

-- Apply AutoLoad only after every UI control and callback has been created.
-- This guarantees saved flags are actually applied when the script starts.
do
    local AutoConfig = Library:GetAutoLoadConfig()
    if AutoConfig then
        local ok, data = pcall(readfile, Library.Folders.Configs .. "/" .. AutoConfig .. ".json")
        if ok and type(data) == "string" then
            local Success = Library:LoadConfig(data)
            if Success then
                Library:Notification("Auto loaded " .. AutoConfig .. ".json", 4)
            else
                Library:Notification("Auto load failed: " .. AutoConfig .. ".json", 4, FromRGB(255, 0, 0))
            end
        else
            Library:ClearAutoLoadConfig()
        end
    end
end

cheat.EspLibrary.load()
Library.Holder.Instance.Enabled = true
Library:Notification("Loaded! Welcome.", 5)


end)
