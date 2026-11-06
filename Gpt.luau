--[[
    RobloxUI - settings-panel style UI library (dark theme, sidebar tabs)

    local RobloxUI = loadstring(readfile("RobloxUI.lua"))()
    local window = RobloxUI:CreateWindow({Title = "Settings"})
    local tab = window:AddTab("General")
    tab:AddToggle({Name = "Option", Default = true, Callback = function(on) end})

    Elements: AddSection, AddLabel, AddButton, AddToggle, AddSlider,
              AddDropdown, AddTextbox
    Window:   Notify, Toggle, Destroy
]]

local library = {}

local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local coreGui = game:GetService("CoreGui")

local theme = {
    Window = Color3.fromRGB(32, 33, 35),
    Selected = Color3.fromRGB(52, 53, 65),
    Hover = Color3.fromRGB(64, 65, 79),
    Divider = Color3.fromRGB(64, 65, 75),
    Border = Color3.fromRGB(110, 112, 130),
    Text = Color3.fromRGB(236, 236, 241),
    SubText = Color3.fromRGB(142, 142, 160),
    Accent = Color3.fromRGB(16, 163, 127),
    AccentHover = Color3.fromRGB(26, 184, 146),
    Danger = Color3.fromRGB(185, 28, 28),
    DangerHover = Color3.fromRGB(220, 38, 38),
    Off = Color3.fromRGB(86, 88, 105),
}
library.Theme = theme

local windowClass = {}
windowClass.__index = windowClass

local tabClass = {}
tabClass.__index = tabClass

-- helpers ---------------------------------------------------------------

local function create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    inst.Parent = parent
    return inst
end

local function tween(inst, props, time)
    tweenService:Create(inst, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function safe(callback, ...)
    if typeof(callback) == "function" then
        local ok, err = pcall(callback, ...)
        if not ok then
            warn("[RobloxUI] callback error: " .. tostring(err))
        end
    end
end

local function corner(inst, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius)}, inst)
end

local function stroke(inst, color, thickness)
    return create("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, inst)
end

local function label(parent, text, size, color, font)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = font or Enum.Font.Gotham,
        Text = text,
        TextColor3 = color or theme.Text,
        TextSize = size or 15,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, parent)
end

local function getParent()
    if typeof(gethui) == "function" then
        local ok, ui = pcall(gethui)
        if ok and ui then
            return ui
        end
    end
    local reachable = pcall(function()
        return coreGui:GetChildren()
    end)
    if reachable then
        return coreGui
    end
    return players.LocalPlayer:WaitForChild("PlayerGui")
end

local function makeDraggable(window, handle, target)
    local dragging = false
    local dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end
    end)
    window:_connect(userInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    window:_connect(userInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- builds one settings row: title (+ description) on the left, control area on the right
local function newRow(tab, name, description, reserve)
    if not tab.Fresh then
        tab.Order = tab.Order + 1
        create("Frame", {
            BackgroundColor3 = theme.Divider,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            LayoutOrder = tab.Order,
        }, tab.Page)
    end
    tab.Fresh = false
    tab.Order = tab.Order + 1
    local row = create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = tab.Order,
    }, tab.Page)
    local holder = create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -reserve, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, row)
    create("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12)}, holder)
    create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, holder)
    local title = label(holder, name, 16, theme.Text, Enum.Font.GothamMedium)
    title.LayoutOrder = 1
    if description and description ~= "" then
        local desc = label(holder, description, 13, theme.SubText)
        desc.LayoutOrder = 2
    end
    return row
end

-- window ----------------------------------------------------------------

function library:CreateWindow(options)
    options = options or {}
    local parent = getParent()
    local old = parent:FindFirstChild("RobloxUI")
    if old then
        old:Destroy()
    end

    local window = setmetatable({Tabs = {}, Connections = {}, Selected = nil}, windowClass)

    local gui = create("ScreenGui", {
        Name = "RobloxUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, nil)
    gui.Parent = parent

    local main = create("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = options.Size or UDim2.fromOffset(560, 340),
        BackgroundColor3 = theme.Window,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
    }, gui)
    corner(main, 12)
    stroke(main, theme.Divider, 1)

    local top = create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 52)}, main)
    create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 24, 0, 0),
        Size = UDim2.new(1, -80, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = options.Title or "Settings",
        TextColor3 = theme.Text,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, top)
    local close = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -16, 0.5, 0),
        Size = UDim2.fromOffset(28, 28),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = theme.SubText,
        TextSize = 16,
    }, top)
    close.MouseEnter:Connect(function()
        tween(close, {TextColor3 = theme.Text})
    end)
    close.MouseLeave:Connect(function()
        tween(close, {TextColor3 = theme.SubText})
    end)
    close.MouseButton1Click:Connect(function()
        window:Destroy()
    end)
    create("Frame", {
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = theme.Divider,
        BorderSizePixel = 0,
    }, top)

    local sidebar = create("Frame", {
        Position = UDim2.new(0, 0, 0, 52),
        Size = UDim2.new(0, 160, 1, -52),
        BackgroundTransparency = 1,
    }, main)
    create("UIPadding", {
        PaddingTop = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    }, sidebar)
    create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, sidebar)

    local content = create("Frame", {
        Position = UDim2.new(0, 160, 0, 52),
        Size = UDim2.new(1, -160, 1, -52),
        BackgroundTransparency = 1,
    }, main)

    local notes = create("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.new(0, 280, 1, -32),
        BackgroundTransparency = 1,
    }, gui)
    create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
    }, notes)

    window.Gui = gui
    window.Main = main
    window.Sidebar = sidebar
    window.Content = content
    window.Notes = notes

    makeDraggable(window, top, main)

    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    window:_connect(userInputService.InputBegan, function(input, processed)
        if not processed and input.KeyCode == toggleKey then
            main.Visible = not main.Visible
        end
    end)

    return window
end

function windowClass:_connect(signal, fn)
    local connection = signal:Connect(fn)
    table.insert(self.Connections, connection)
    return connection
end

function windowClass:Toggle()
    self.Main.Visible = not self.Main.Visible
end

function windowClass:Destroy()
    for _, connection in ipairs(self.Connections) do
        connection:Disconnect()
    end
    self.Connections = {}
    self.Gui:Destroy()
end

function windowClass:Select(tab)
    local current = self.Selected
    if current then
        current.Page.Visible = false
        tween(current.Button, {BackgroundTransparency = 1})
        tween(current.Label, {TextColor3 = theme.SubText})
        if current.Glyph then
            tween(current.Glyph, {ImageColor3 = theme.SubText})
        end
    end
    self.Selected = tab
    tab.Page.Visible = true
    tween(tab.Button, {BackgroundTransparency = 0})
    tween(tab.Label, {TextColor3 = theme.Text})
    if tab.Glyph then
        tween(tab.Glyph, {ImageColor3 = theme.Text})
    end
end

function windowClass:Notify(options)
    options = options or {}
    local toast = create("Frame", {
        BackgroundColor3 = theme.Selected,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, self.Notes)
    corner(toast, 8)
    stroke(toast, theme.Divider, 1)
    create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    }, toast)
    create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, toast)
    local title = label(toast, options.Title or "Notice", 15, theme.Text, Enum.Font.GothamBold)
    title.LayoutOrder = 1
    if options.Content then
        local body = label(toast, options.Content, 13, theme.SubText)
        body.LayoutOrder = 2
    end
    task.delay(options.Duration or 4, function()
        if toast.Parent then
            toast:Destroy()
        end
    end)
end

-- icon (optional): "rbxassetid://123", a number asset id, or a spritesheet table
-- {Image = "rbxassetid://123", RectOffset = Vector2.new(x, y), RectSize = Vector2.new(w, h)}
function windowClass:AddTab(name, icon)
    local tab = setmetatable({Window = self, Name = name, Order = 0, Fresh = true}, tabClass)

    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = theme.Selected,
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = #self.Tabs + 1,
    }, self.Sidebar)
    corner(button, 8)
    local text = create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, icon and 40 or 12, 0, 0),
        Size = UDim2.new(1, icon and -40 or -12, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = name,
        TextColor3 = theme.SubText,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, button)

    local glyph
    if icon then
        local spec = type(icon) == "table" and icon or {Image = icon}
        local image = spec.Image
        if type(image) == "number" then
            image = "rbxassetid://" .. image
        end
        glyph = create("ImageLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 12, 0.5, 0),
            Size = UDim2.fromOffset(18, 18),
            BackgroundTransparency = 1,
            Image = image,
            ImageColor3 = theme.SubText,
            ImageRectOffset = spec.RectOffset or Vector2.new(),
            ImageRectSize = spec.RectSize or Vector2.new(),
        }, button)
    end

    local page = create("ScrollingFrame", {
        Visible = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Off,
    }, self.Content)
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 24),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 12),
    }, page)
    create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, page)

    tab.Button = button
    tab.Label = text
    tab.Glyph = glyph
    tab.Page = page

    button.MouseEnter:Connect(function()
        if self.Selected ~= tab then
            tween(button, {BackgroundTransparency = 0.6})
        end
    end)
    button.MouseLeave:Connect(function()
        if self.Selected ~= tab then
            tween(button, {BackgroundTransparency = 1})
        end
    end)
    button.MouseButton1Click:Connect(function()
        self:Select(tab)
    end)

    table.insert(self.Tabs, tab)
    if not self.Selected then
        self:Select(tab)
    end
    return tab
end

-- elements --------------------------------------------------------------

function tabClass:AddSection(name)
    self.Order = self.Order + 1
    local frame = create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = self.Order,
    }, self.Page)
    create("UIPadding", {PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 4)}, frame)
    label(frame, string.upper(name), 12, theme.Accent, Enum.Font.GothamBold)
    self.Fresh = true
end

function tabClass:AddLabel(text)
    self.Order = self.Order + 1
    local frame = create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = self.Order,
    }, self.Page)
    create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)}, frame)
    local line = label(frame, text, 14, theme.SubText)
    self.Fresh = true
    local api = {}
    function api:Set(newText)
        line.Text = newText
    end
    return api
end

function tabClass:AddButton(options)
    options = options or {}
    local row = newRow(self, options.Name or "Button", options.Description, 140)
    local style = options.Style or "Default"
    local base, hover = theme.Selected, theme.Hover
    if style == "Danger" then
        base, hover = theme.Danger, theme.DangerHover
    elseif style == "Accent" then
        base, hover = theme.Accent, theme.AccentHover
    end
    local button = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(0, 34),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = base,
        AutoButtonColor = false,
        Font = Enum.Font.GothamMedium,
        Text = options.ButtonText or "Click",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 15,
    }, row)
    corner(button, 6)
    create("UIPadding", {PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16)}, button)
    create("UISizeConstraint", {MinSize = Vector2.new(88, 34)}, button)
    if style == "Default" then
        stroke(button, theme.Border, 1)
    end
    button.MouseEnter:Connect(function()
        tween(button, {BackgroundColor3 = hover})
    end)
    button.MouseLeave:Connect(function()
        tween(button, {BackgroundColor3 = base})
    end)
    button.MouseButton1Click:Connect(function()
        safe(options.Callback)
    end)
    local api = {}
    function api:SetText(newText)
        button.Text = newText
    end
    return api
end

function tabClass:AddToggle(options)
    options = options or {}
    local row = newRow(self, options.Name or "Toggle", options.Description, 76)
    local state = options.Default == true

    local switch = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(44, 24),
        BackgroundColor3 = theme.Off,
        AutoButtonColor = false,
        Text = "",
    }, row)
    corner(switch, 12)
    local knob = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    }, switch)
    corner(knob, 9)

    local function render(animate)
        local goal = state and theme.Accent or theme.Off
        local pos = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        if animate then
            tween(switch, {BackgroundColor3 = goal})
            tween(knob, {Position = pos})
        else
            switch.BackgroundColor3 = goal
            knob.Position = pos
        end
    end
    render(false)

    local toggle = {}
    function toggle:Set(value, silent)
        state = value == true
        render(true)
        if not silent then
            safe(options.Callback, state)
        end
    end
    function toggle:Get()
        return state
    end
    switch.MouseButton1Click:Connect(function()
        toggle:Set(not state)
    end)
    return toggle
end

function tabClass:AddSlider(options)
    options = options or {}
    local window = self.Window
    local min, max = options.Min or 0, options.Max or 100
    local inc = options.Increment or 1
    local suffix = options.Suffix or ""
    local row = newRow(self, options.Name or "Slider", options.Description, 220)

    local holder = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(200, 24),
        BackgroundTransparency = 1,
    }, row)
    local track = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, -56, 0, 6),
        BackgroundColor3 = theme.Off,
        BorderSizePixel = 0,
    }, holder)
    corner(track, 3)
    local fill = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
    }, track)
    corner(fill, 3)
    local knob = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    }, track)
    corner(knob, 7)
    local readout = create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(48, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextColor3 = theme.SubText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, holder)
    local hit = create("TextButton", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, -56, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
    }, holder)

    local value = min
    local dragging = false

    local function setValue(v, silent)
        v = math.clamp(v, min, max)
        v = math.floor((v - min) / inc + 0.5) * inc + min
        v = math.clamp(tonumber(string.format("%.4f", v)), min, max)
        value = v
        local alpha = max > min and (v - min) / (max - min) or 0
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        readout.Text = tostring(v) .. suffix
        if not silent then
            safe(options.Callback, v)
        end
    end

    local function fromInput(input)
        local alpha = math.clamp((input.Position.X - hit.AbsolutePosition.X) / hit.AbsoluteSize.X, 0, 1)
        setValue(min + (max - min) * alpha)
    end

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            fromInput(input)
        end
    end)
    window:_connect(userInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            fromInput(input)
        end
    end)
    window:_connect(userInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    setValue(options.Default or min, true)

    local slider = {}
    function slider:Set(v, silent)
        setValue(v, silent)
    end
    function slider:Get()
        return value
    end
    return slider
end

function tabClass:AddDropdown(options)
    options = options or {}
    local list = options.Options or {}
    local selected = options.Default or list[1]
    local row = newRow(self, options.Name or "Dropdown", options.Description, 190)

    local box = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(170, 34),
        BackgroundColor3 = theme.Selected,
        AutoButtonColor = false,
        Text = "",
    }, row)
    corner(box, 6)
    stroke(box, theme.Border, 1)
    local current = create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -34, 1, 0),
        Font = Enum.Font.GothamMedium,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, box)
    create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "v",
        TextColor3 = theme.SubText,
        TextSize = 12,
    }, box)

    local overlay

    local function show()
        current.Text = selected == nil and "" or tostring(selected)
    end
    show()

    local function close()
        if overlay then
            overlay:Destroy()
            overlay = nil
        end
    end

    local function apply(option, silent)
        selected = option
        show()
        if not silent then
            safe(options.Callback, option)
        end
    end

    local function open()
        close()
        overlay = create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            ZIndex = 50,
        }, self.Window.Gui)
        overlay.MouseButton1Click:Connect(close)

        local menu = create("ScrollingFrame", {
            Position = UDim2.fromOffset(box.AbsolutePosition.X, box.AbsolutePosition.Y + box.AbsoluteSize.Y + 4),
            Size = UDim2.fromOffset(box.AbsoluteSize.X, math.min(#list * 32 + 8, 168)),
            BackgroundColor3 = theme.Selected,
            BorderSizePixel = 0,
            Active = true,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3,
            ZIndex = 51,
        }, overlay)
        corner(menu, 6)
        stroke(menu, theme.Border, 1)
        create("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
        }, menu)
        create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, menu)

        for i, option in ipairs(list) do
            local item = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = theme.Hover,
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Font = Enum.Font.Gotham,
                Text = tostring(option),
                TextColor3 = option == selected and theme.Accent or theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = i,
            }, menu)
            corner(item, 4)
            create("UIPadding", {PaddingLeft = UDim.new(0, 10)}, item)
            item.MouseEnter:Connect(function()
                item.BackgroundTransparency = 0.4
            end)
            item.MouseLeave:Connect(function()
                item.BackgroundTransparency = 1
            end)
            item.MouseButton1Click:Connect(function()
                apply(option)
                close()
            end)
        end
    end

    box.MouseButton1Click:Connect(function()
        if overlay then
            close()
        else
            open()
        end
    end)

    local dropdown = {}
    function dropdown:Set(option, silent)
        apply(option, silent)
    end
    function dropdown:Get()
        return selected
    end
    function dropdown:Refresh(newList, keep)
        list = newList or {}
        if not keep or not table.find(list, selected) then
            apply(list[1], true)
        end
    end
    return dropdown
end

function tabClass:AddTextbox(options)
    options = options or {}
    local row = newRow(self, options.Name or "Textbox", options.Description, 190)
    local box = create("TextBox", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(170, 34),
        BackgroundColor3 = theme.Selected,
        ClearTextOnFocus = false,
        Font = Enum.Font.Gotham,
        PlaceholderColor3 = theme.SubText,
        PlaceholderText = options.Placeholder or "Type here...",
        Text = options.Default or "",
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    corner(box, 6)
    local outline = stroke(box, theme.Border, 1)
    create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, box)
    box.Focused:Connect(function()
        tween(outline, {Color = theme.Accent})
    end)
    box.FocusLost:Connect(function(enter)
        tween(outline, {Color = theme.Border})
        safe(options.Callback, box.Text, enter)
    end)
    local api = {}
    function api:Set(newText)
        box.Text = newText
    end
    function api:Get()
        return box.Text
    end
    return api
end

return library
