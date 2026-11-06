local v0_1 = {}
local v0_2 = game:GetService("TweenService")
local v0_3 = game:GetService("UserInputService")
local v0_4 = game:GetService("Players")
local v0_5 = game:GetService("CoreGui")
local v0_6 = {
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
v0_1.Theme = v0_6
local v0_7 = {}
v0_7.__index = v0_7
local v0_8 = {}
v0_8.__index = v0_8
local function v0_9(v0_10, v0_11, v0_12)
local v0_13 = Instance.new(v0_10)
for v0_14, v0_15 in pairs(v0_11) do
v0_13[v0_14] = v0_15
end
v0_13.Parent = v0_12
return v0_13
end
local function v0_16(v0_13, v0_11, v0_17)
v0_2:Create(v0_13, TweenInfo.new(v0_17 or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v0_11):Play()
end
local function v0_18(v0_19, ...)
if typeof(v0_19) == "function" then
local v0_20, v0_21 = pcall(v0_19, ...)
if not v0_20 then
warn("[RobloxUI] callback error: " .. tostring(v0_21))
end
end
end
local function v0_22(v0_13, v0_23)
return v0_9("UICorner", {CornerRadius = UDim.new(0, v0_23)}, v0_13)
end
local function v0_24(v0_13, v0_25, v0_26)
return v0_9("UIStroke", {
Color = v0_25,
Thickness = v0_26 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, v0_13)
end
local function v0_27(v0_12, v0_28, v0_29, v0_25, v0_30)
return v0_9("TextLabel", {
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
Font = v0_30 or Enum.Font.Gotham,
Text = v0_28,
TextColor3 = v0_25 or v0_6.Text,
TextSize = v0_29 or 15,
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left,
}, v0_12)
end
local function v0_31()
if typeof(gethui) == "function" then
local v0_20, v0_32 = pcall(gethui)
if v0_20 and v0_32 then
return v0_32
end
end
local v0_33 = pcall(function()
return v0_5:GetChildren()
end)
if v0_33 then
return v0_5
end
return v0_4.LocalPlayer:WaitForChild("PlayerGui")
end
local function v0_34(v0_35, v0_36, v0_37)
local v0_38 = false
local v0_39, v0_40
v0_36.InputBegan:Connect(function(v0_41)
if v0_41.UserInputType == Enum.UserInputType.MouseButton1 or v0_41.UserInputType == Enum.UserInputType.Touch then
v0_38 = true
v0_39 = v0_41.Position
v0_40 = v0_37.Position
end
end)
v0_35:_connect(v0_3.InputChanged, function(v0_41)
if v0_38 and (v0_41.UserInputType == Enum.UserInputType.MouseMovement or v0_41.UserInputType == Enum.UserInputType.Touch) then
local v0_42 = v0_41.Position - v0_39
v0_37.Position = UDim2.new(v0_40.X.Scale, v0_40.X.Offset + v0_42.X, v0_40.Y.Scale, v0_40.Y.Offset + v0_42.Y)
end
end)
v0_35:_connect(v0_3.InputEnded, function(v0_41)
if v0_41.UserInputType == Enum.UserInputType.MouseButton1 or v0_41.UserInputType == Enum.UserInputType.Touch then
v0_38 = false
end
end)
end
local function v0_43(v0_44, v0_45, v0_46, v0_47)
if not v0_44.Fresh then
v0_44.Order = v0_44.Order + 1
v0_9("Frame", {
BackgroundColor3 = v0_6.Divider,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 1),
LayoutOrder = v0_44.Order,
}, v0_44.Page)
end
v0_44.Fresh = false
v0_44.Order = v0_44.Order + 1
local v0_48 = v0_9("Frame", {
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 48),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = v0_44.Order,
}, v0_44.Page)
local v0_49 = v0_9("Frame", {
BackgroundTransparency = 1,
Size = UDim2.new(1, -v0_47, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
}, v0_48)
v0_9("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12)}, v0_49)
v0_9("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, v0_49)
local v0_50 = v0_27(v0_49, v0_45, 16, v0_6.Text, Enum.Font.GothamMedium)
v0_50.LayoutOrder = 1
if v0_46 and v0_46 ~= "" then
local v0_51 = v0_27(v0_49, v0_46, 13, v0_6.SubText)
v0_51.LayoutOrder = 2
end
return v0_48
end
function v0_1:CreateWindow(v0_52)
v0_52 = v0_52 or {}
local v0_12 = v0_31()
local v0_53 = v0_12:FindFirstChild("RobloxUI")
if v0_53 then
v0_53:Destroy()
end
local v0_35 = setmetatable({Tabs = {}, Connections = {}, Selected = nil}, v0_7)
local v0_54 = v0_9("ScreenGui", {
Name = "RobloxUI",
ResetOnSpawn = false,
IgnoreGuiInset = true,
DisplayOrder = 999,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, nil)
v0_54.Parent = v0_12
local v0_55 = v0_9("Frame", {
Name = "Main",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.new(0.5, 0, 0.5, 0),
Size = v0_52.Size or UDim2.fromOffset(560, 340),
BackgroundColor3 = v0_6.Window,
BorderSizePixel = 0,
ClipsDescendants = true,
Active = true,
}, v0_54)
v0_22(v0_55, 12)
v0_24(v0_55, v0_6.Divider, 1)
local v0_56 = v0_9("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 52)}, v0_55)
v0_9("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 24, 0, 0),
Size = UDim2.new(1, -80, 1, 0),
Font = Enum.Font.GothamBold,
Text = v0_52.Title or "Settings",
TextColor3 = v0_6.Text,
TextSize = 20,
TextXAlignment = Enum.TextXAlignment.Left,
}, v0_56)
local v0_57 = v0_9("TextButton", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -16, 0.5, 0),
Size = UDim2.fromOffset(28, 28),
BackgroundTransparency = 1,
AutoButtonColor = false,
Font = Enum.Font.GothamBold,
Text = "X",
TextColor3 = v0_6.SubText,
TextSize = 16,
}, v0_56)
v0_57.MouseEnter:Connect(function()
v0_16(v0_57, {TextColor3 = v0_6.Text})
end)
v0_57.MouseLeave:Connect(function()
v0_16(v0_57, {TextColor3 = v0_6.SubText})
end)
v0_57.MouseButton1Click:Connect(function()
v0_35:Destroy()
end)
v0_9("Frame", {
Position = UDim2.new(0, 0, 1, -1),
Size = UDim2.new(1, 0, 0, 1),
BackgroundColor3 = v0_6.Divider,
BorderSizePixel = 0,
}, v0_56)
local v0_58 = v0_9("Frame", {
Position = UDim2.new(0, 0, 0, 52),
Size = UDim2.new(0, 160, 1, -52),
BackgroundTransparency = 1,
}, v0_55)
v0_9("UIPadding", {
PaddingTop = UDim.new(0, 16),
PaddingLeft = UDim.new(0, 12),
PaddingRight = UDim.new(0, 12),
}, v0_58)
v0_9("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, v0_58)
local v0_59 = v0_9("Frame", {
Position = UDim2.new(0, 160, 0, 52),
Size = UDim2.new(1, -160, 1, -52),
BackgroundTransparency = 1,
}, v0_55)
local v0_60 = v0_9("Frame", {
AnchorPoint = Vector2.new(1, 1),
Position = UDim2.new(1, -16, 1, -16),
Size = UDim2.new(0, 280, 1, -32),
BackgroundTransparency = 1,
}, v0_54)
v0_9("UIListLayout", {
Padding = UDim.new(0, 8),
SortOrder = Enum.SortOrder.LayoutOrder,
VerticalAlignment = Enum.VerticalAlignment.Bottom,
}, v0_60)
v0_35.Gui = v0_54
v0_35.Main = v0_55
v0_35.Sidebar = v0_58
v0_35.Content = v0_59
v0_35.Notes = v0_60
v0_34(v0_35, v0_56, v0_55)
local v0_61 = v0_52.ToggleKey or Enum.KeyCode.RightShift
v0_35:_connect(v0_3.InputBegan, function(v0_41, v0_62)
if not v0_62 and v0_41.KeyCode == v0_61 then
v0_55.Visible = not v0_55.Visible
end
end)
return v0_35
end
function v0_7:_connect(v0_63, v0_64)
local v0_65 = v0_63:Connect(v0_64)
table.insert(self.Connections, v0_65)
return v0_65
end
function v0_7:Toggle()
self.Main.Visible = not self.Main.Visible
end
function v0_7:Destroy()
for v0_66, v0_65 in ipairs(self.Connections) do
v0_65:Disconnect()
end
self.Connections = {}
self.Gui:Destroy()
end
function v0_7:Select(v0_44)
local v0_67 = self.Selected
if v0_67 then
v0_67.Page.Visible = false
v0_16(v0_67.Button, {BackgroundTransparency = 1})
v0_16(v0_67.Label, {TextColor3 = v0_6.SubText})
if v0_67.Glyph then
v0_16(v0_67.Glyph, {ImageColor3 = v0_6.SubText})
end
end
self.Selected = v0_44
v0_44.Page.Visible = true
v0_16(v0_44.Button, {BackgroundTransparency = 0})
v0_16(v0_44.Label, {TextColor3 = v0_6.Text})
if v0_44.Glyph then
v0_16(v0_44.Glyph, {ImageColor3 = v0_6.Text})
end
end
function v0_7:Notify(v0_52)
v0_52 = v0_52 or {}
local v0_68 = v0_9("Frame", {
BackgroundColor3 = v0_6.Selected,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
}, self.Notes)
v0_22(v0_68, 8)
v0_24(v0_68, v0_6.Divider, 1)
v0_9("UIPadding", {
PaddingTop = UDim.new(0, 10),
PaddingBottom = UDim.new(0, 10),
PaddingLeft = UDim.new(0, 12),
PaddingRight = UDim.new(0, 12),
}, v0_68)
v0_9("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, v0_68)
local v0_50 = v0_27(v0_68, v0_52.Title or "Notice", 15, v0_6.Text, Enum.Font.GothamBold)
v0_50.LayoutOrder = 1
if v0_52.Content then
local v0_69 = v0_27(v0_68, v0_52.Content, 13, v0_6.SubText)
v0_69.LayoutOrder = 2
end
task.delay(v0_52.Duration or 4, function()
if v0_68.Parent then
v0_68:Destroy()
end
end)
end
function v0_7:AddTab(v0_45, v0_70)
local v0_44 = setmetatable({Window = self, Name = v0_45, Order = 0, Fresh = true}, v0_8)
local v0_71 = v0_9("TextButton", {
Size = UDim2.new(1, 0, 0, 36),
BackgroundColor3 = v0_6.Selected,
BackgroundTransparency = 1,
AutoButtonColor = false,
Text = "",
LayoutOrder = #self.Tabs + 1,
}, self.Sidebar)
v0_22(v0_71, 8)
local v0_28 = v0_9("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, v0_70 and 40 or 12, 0, 0),
Size = UDim2.new(1, v0_70 and -40 or -12, 1, 0),
Font = Enum.Font.GothamMedium,
Text = v0_45,
TextColor3 = v0_6.SubText,
TextSize = 15,
TextXAlignment = Enum.TextXAlignment.Left,
}, v0_71)
local v0_72
if v0_70 then
local v0_73 = type(v0_70) == "table" and v0_70 or {Image = v0_70}
local v0_74 = v0_73.Image
if type(v0_74) == "number" then
v0_74 = "rbxassetid://" .. v0_74
end
v0_72 = v0_9("ImageLabel", {
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 12, 0.5, 0),
Size = UDim2.fromOffset(18, 18),
BackgroundTransparency = 1,
Image = v0_74,
ImageColor3 = v0_6.SubText,
ImageRectOffset = v0_73.RectOffset or Vector2.new(),
ImageRectSize = v0_73.RectSize or Vector2.new(),
}, v0_71)
end
local v0_75 = v0_9("ScrollingFrame", {
Visible = false,
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0),
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollBarThickness = 3,
ScrollBarImageColor3 = v0_6.Off,
}, self.Content)
v0_9("UIPadding", {
PaddingLeft = UDim.new(0, 12),
PaddingRight = UDim.new(0, 24),
PaddingTop = UDim.new(0, 4),
PaddingBottom = UDim.new(0, 12),
}, v0_75)
v0_9("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, v0_75)
v0_44.Button = v0_71
v0_44.Label = v0_28
v0_44.Glyph = v0_72
v0_44.Page = v0_75
v0_71.MouseEnter:Connect(function()
if self.Selected ~= v0_44 then
v0_16(v0_71, {BackgroundTransparency = 0.6})
end
end)
v0_71.MouseLeave:Connect(function()
if self.Selected ~= v0_44 then
v0_16(v0_71, {BackgroundTransparency = 1})
end
end)
v0_71.MouseButton1Click:Connect(function()
self:Select(v0_44)
end)
table.insert(self.Tabs, v0_44)
if not self.Selected then
self:Select(v0_44)
end
return v0_44
end
function v0_8:AddSection(v0_45)
self.Order = self.Order + 1
local v0_76 = v0_9("Frame", {
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = self.Order,
}, self.Page)
v0_9("UIPadding", {PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 4)}, v0_76)
v0_27(v0_76, string.upper(v0_45), 12, v0_6.Accent, Enum.Font.GothamBold)
self.Fresh = true
end
function v0_8:AddLabel(v0_28)
self.Order = self.Order + 1
local v0_76 = v0_9("Frame", {
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = self.Order,
}, self.Page)
v0_9("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)}, v0_76)
local v0_77 = v0_27(v0_76, v0_28, 14, v0_6.SubText)
self.Fresh = true
local v0_78 = {}
function v0_78:Set(v0_79)
v0_77.Text = v0_79
end
return v0_78
end
function v0_8:AddButton(v0_52)
v0_52 = v0_52 or {}
local v0_48 = v0_43(self, v0_52.Name or "Button", v0_52.Description, 140)
local v0_80 = v0_52.Style or "Default"
local v0_81, v0_82 = v0_6.Selected, v0_6.Hover
if v0_80 == "Danger" then
v0_81, v0_82 = v0_6.Danger, v0_6.DangerHover
elseif v0_80 == "Accent" then
v0_81, v0_82 = v0_6.Accent, v0_6.AccentHover
end
local v0_71 = v0_9("TextButton", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, 0, 0.5, 0),
Size = UDim2.fromOffset(0, 34),
AutomaticSize = Enum.AutomaticSize.X,
BackgroundColor3 = v0_81,
AutoButtonColor = false,
Font = Enum.Font.GothamMedium,
Text = v0_52.ButtonText or "Click",
TextColor3 = Color3.new(1, 1, 1),
TextSize = 15,
}, v0_48)
v0_22(v0_71, 6)
v0_9("UIPadding", {PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16)}, v0_71)
v0_9("UISizeConstraint", {MinSize = Vector2.new(88, 34)}, v0_71)
if v0_80 == "Default" then
v0_24(v0_71, v0_6.Border, 1)
end
v0_71.MouseEnter:Connect(function()
v0_16(v0_71, {BackgroundColor3 = v0_82})
end)
v0_71.MouseLeave:Connect(function()
v0_16(v0_71, {BackgroundColor3 = v0_81})
end)
v0_71.MouseButton1Click:Connect(function()
v0_18(v0_52.Callback)
end)
local v0_78 = {}
function v0_78:SetText(v0_79)
v0_71.Text = v0_79
end
return v0_78
end
function v0_8:AddToggle(v0_52)
v0_52 = v0_52 or {}
local v0_48 = v0_43(self, v0_52.Name or "Toggle", v0_52.Description, 76)
local v0_83 = v0_52.Default == true
local v0_84 = v0_9("TextButton", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, 0, 0.5, 0),
Size = UDim2.fromOffset(44, 24),
BackgroundColor3 = v0_6.Off,
AutoButtonColor = false,
Text = "",
}, v0_48)
v0_22(v0_84, 12)
local v0_85 = v0_9("Frame", {
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 3, 0.5, 0),
Size = UDim2.fromOffset(18, 18),
BackgroundColor3 = Color3.new(1, 1, 1),
BorderSizePixel = 0,
}, v0_84)
v0_22(v0_85, 9)
local function v0_86(v0_87)
local v0_88 = v0_83 and v0_6.Accent or v0_6.Off
local v0_89 = v0_83 and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
if v0_87 then
v0_16(v0_84, {BackgroundColor3 = v0_88})
v0_16(v0_85, {Position = v0_89})
else
v0_84.BackgroundColor3 = v0_88
v0_85.Position = v0_89
end
end
v0_86(false)
local v0_90 = {}
function v0_90:Set(v0_91, v0_92)
v0_83 = v0_91 == true
v0_86(true)
if not v0_92 then
v0_18(v0_52.Callback, v0_83)
end
end
function v0_90:Get()
return v0_83
end
v0_84.MouseButton1Click:Connect(function()
v0_90:Set(not v0_83)
end)
return v0_90
end
function v0_8:AddSlider(v0_52)
v0_52 = v0_52 or {}
local v0_35 = self.Window
local v0_93, v0_94 = v0_52.Min or 0, v0_52.Max or 100
local v0_95 = v0_52.Increment or 1
local v0_96 = v0_52.Suffix or ""
local v0_48 = v0_43(self, v0_52.Name or "Slider", v0_52.Description, 220)
local v0_49 = v0_9("Frame", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, 0, 0.5, 0),
Size = UDim2.fromOffset(200, 24),
BackgroundTransparency = 1,
}, v0_48)
local v0_97 = v0_9("Frame", {
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 0, 0.5, 0),
Size = UDim2.new(1, -56, 0, 6),
BackgroundColor3 = v0_6.Off,
BorderSizePixel = 0,
}, v0_49)
v0_22(v0_97, 3)
local v0_98 = v0_9("Frame", {
Size = UDim2.new(0, 0, 1, 0),
BackgroundColor3 = v0_6.Accent,
BorderSizePixel = 0,
}, v0_97)
v0_22(v0_98, 3)
local v0_85 = v0_9("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.new(0, 0, 0.5, 0),
Size = UDim2.fromOffset(14, 14),
BackgroundColor3 = Color3.new(1, 1, 1),
BorderSizePixel = 0,
}, v0_97)
v0_22(v0_85, 7)
local v0_99 = v0_9("TextLabel", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, 0, 0.5, 0),
Size = UDim2.fromOffset(48, 20),
BackgroundTransparency = 1,
Font = Enum.Font.GothamMedium,
TextColor3 = v0_6.SubText,
TextSize = 14,
TextXAlignment = Enum.TextXAlignment.Right,
}, v0_49)
local v0_100 = v0_9("TextButton", {
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 0, 0.5, 0),
Size = UDim2.new(1, -56, 1, 0),
BackgroundTransparency = 1,
Text = "",
}, v0_49)
local v0_91 = v0_93
local v0_38 = false
local function v0_101(v0_15, v0_92)
v0_15 = math.clamp(v0_15, v0_93, v0_94)
v0_15 = math.floor((v0_15 - v0_93) / v0_95 + 0.5) * v0_95 + v0_93
v0_15 = math.clamp(tonumber(string.format("%.4f", v0_15)), v0_93, v0_94)
v0_91 = v0_15
local v0_102 = v0_94 > v0_93 and (v0_15 - v0_93) / (v0_94 - v0_93) or 0
v0_98.Size = UDim2.new(v0_102, 0, 1, 0)
v0_85.Position = UDim2.new(v0_102, 0, 0.5, 0)
v0_99.Text = tostring(v0_15) .. v0_96
if not v0_92 then
v0_18(v0_52.Callback, v0_15)
end
end
local function v0_103(v0_41)
local v0_102 = math.clamp((v0_41.Position.X - v0_100.AbsolutePosition.X) / v0_100.AbsoluteSize.X, 0, 1)
v0_101(v0_93 + (v0_94 - v0_93) * v0_102)
end
v0_100.InputBegan:Connect(function(v0_41)
if v0_41.UserInputType == Enum.UserInputType.MouseButton1 or v0_41.UserInputType == Enum.UserInputType.Touch then
v0_38 = true
v0_103(v0_41)
end
end)
v0_35:_connect(v0_3.InputChanged, function(v0_41)
if v0_38 and (v0_41.UserInputType == Enum.UserInputType.MouseMovement or v0_41.UserInputType == Enum.UserInputType.Touch) then
v0_103(v0_41)
end
end)
v0_35:_connect(v0_3.InputEnded, function(v0_41)
if v0_41.UserInputType == Enum.UserInputType.MouseButton1 or v0_41.UserInputType == Enum.UserInputType.Touch then
v0_38 = false
end
end)
v0_101(v0_52.Default or v0_93, true)
local v0_104 = {}
function v0_104:Set(v0_15, v0_92)
v0_101(v0_15, v0_92)
end
function v0_104:Get()
return v0_91
end
return v0_104
end
function v0_8:AddDropdown(v0_52)
v0_52 = v0_52 or {}
local v0_105 = v0_52.Options or {}
local v0_106 = v0_52.Default or v0_105[1]
local v0_48 = v0_43(self, v0_52.Name or "Dropdown", v0_52.Description, 190)
local v0_107 = v0_9("TextButton", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, 0, 0.5, 0),
Size = UDim2.fromOffset(170, 34),
BackgroundColor3 = v0_6.Selected,
AutoButtonColor = false,
Text = "",
}, v0_48)
v0_22(v0_107, 6)
v0_24(v0_107, v0_6.Border, 1)
local v0_67 = v0_9("TextLabel", {
BackgroundTransparency = 1,
Position = UDim2.new(0, 12, 0, 0),
Size = UDim2.new(1, -34, 1, 0),
Font = Enum.Font.GothamMedium,
TextColor3 = v0_6.Text,
TextSize = 14,
TextTruncate = Enum.TextTruncate.AtEnd,
TextXAlignment = Enum.TextXAlignment.Left,
}, v0_107)
v0_9("TextLabel", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -10, 0.5, 0),
Size = UDim2.fromOffset(16, 16),
BackgroundTransparency = 1,
Font = Enum.Font.GothamBold,
Text = "v",
TextColor3 = v0_6.SubText,
TextSize = 12,
}, v0_107)
local v0_108
local function v0_109()
v0_67.Text = v0_106 == nil and "" or tostring(v0_106)
end
v0_109()
local function v0_57()
if v0_108 then
v0_108:Destroy()
v0_108 = nil
end
end
local function v0_110(v0_111, v0_92)
v0_106 = v0_111
v0_109()
if not v0_92 then
v0_18(v0_52.Callback, v0_111)
end
end
local function v0_112()
v0_57()
v0_108 = v0_9("TextButton", {
Size = UDim2.new(1, 0, 1, 0),
BackgroundTransparency = 1,
AutoButtonColor = false,
Text = "",
ZIndex = 50,
}, self.Window.Gui)
v0_108.MouseButton1Click:Connect(v0_57)
local v0_113 = v0_9("ScrollingFrame", {
Position = UDim2.fromOffset(v0_107.AbsolutePosition.X, v0_107.AbsolutePosition.Y + v0_107.AbsoluteSize.Y + 4),
Size = UDim2.fromOffset(v0_107.AbsoluteSize.X, math.min(#v0_105 * 32 + 8, 168)),
BackgroundColor3 = v0_6.Selected,
BorderSizePixel = 0,
Active = true,
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollBarThickness = 3,
ZIndex = 51,
}, v0_108)
v0_22(v0_113, 6)
v0_24(v0_113, v0_6.Border, 1)
v0_9("UIPadding", {
PaddingTop = UDim.new(0, 4),
PaddingBottom = UDim.new(0, 4),
PaddingLeft = UDim.new(0, 4),
PaddingRight = UDim.new(0, 4),
}, v0_113)
v0_9("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, v0_113)
for v0_114, v0_111 in ipairs(v0_105) do
local v0_115 = v0_9("TextButton", {
Size = UDim2.new(1, 0, 0, 32),
BackgroundColor3 = v0_6.Hover,
BackgroundTransparency = 1,
AutoButtonColor = false,
Font = Enum.Font.Gotham,
Text = tostring(v0_111),
TextColor3 = v0_111 == v0_106 and v0_6.Accent or v0_6.Text,
TextSize = 14,
TextXAlignment = Enum.TextXAlignment.Left,
LayoutOrder = v0_114,
}, v0_113)
v0_22(v0_115, 4)
v0_9("UIPadding", {PaddingLeft = UDim.new(0, 10)}, v0_115)
v0_115.MouseEnter:Connect(function()
v0_115.BackgroundTransparency = 0.4
end)
v0_115.MouseLeave:Connect(function()
v0_115.BackgroundTransparency = 1
end)
v0_115.MouseButton1Click:Connect(function()
v0_110(v0_111)
v0_57()
end)
end
end
v0_107.MouseButton1Click:Connect(function()
if v0_108 then
v0_57()
else
v0_112()
end
end)
local v0_116 = {}
function v0_116:Set(v0_111, v0_92)
v0_110(v0_111, v0_92)
end
function v0_116:Get()
return v0_106
end
function v0_116:Refresh(v0_117, v0_118)
v0_105 = v0_117 or {}
if not v0_118 or not table.find(v0_105, v0_106) then
v0_110(v0_105[1], true)
end
end
return v0_116
end
function v0_8:AddTextbox(v0_52)
v0_52 = v0_52 or {}
local v0_48 = v0_43(self, v0_52.Name or "Textbox", v0_52.Description, 190)
local v0_107 = v0_9("TextBox", {
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, 0, 0.5, 0),
Size = UDim2.fromOffset(170, 34),
BackgroundColor3 = v0_6.Selected,
ClearTextOnFocus = false,
Font = Enum.Font.Gotham,
PlaceholderColor3 = v0_6.SubText,
PlaceholderText = v0_52.Placeholder or "Type here...",
Text = v0_52.Default or "",
TextColor3 = v0_6.Text,
TextSize = 14,
TextXAlignment = Enum.TextXAlignment.Left,
}, v0_48)
v0_22(v0_107, 6)
local v0_119 = v0_24(v0_107, v0_6.Border, 1)
v0_9("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, v0_107)
v0_107.Focused:Connect(function()
v0_16(v0_119, {Color = v0_6.Accent})
end)
v0_107.FocusLost:Connect(function(v0_120)
v0_16(v0_119, {Color = v0_6.Border})
v0_18(v0_52.Callback, v0_107.Text, v0_120)
end)
local v0_78 = {}
function v0_78:Set(v0_79)
v0_107.Text = v0_79
end
function v0_78:Get()
return v0_107.Text
end
return v0_78
end
return v0_1
