local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEANUP TOTAL
local GUI_NAME = "ZeetaAtelierGui"
if playerGui:FindFirstChild(GUI_NAME) then playerGui:FindFirstChild(GUI_NAME):Destroy() end
if _G.ZeetaConnections then
    for _, conn in pairs(_G.ZeetaConnections) do conn:Disconnect() end
end
_G.ZeetaConnections = {}

-- 2. GUI BASE
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false

-- Ikon Tombol
local iconButton = Instance.new("ImageButton", screenGui)
iconButton.Size = UDim2.new(0, 60, 0, 60)
iconButton.Position = UDim2.new(0.1, 0, 0.1, 0)
iconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
iconButton.Active = true
iconButton.Draggable = true
Instance.new("UICorner", iconButton).CornerRadius = UDim.new(1, 0)

-- Menu Utama
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
menuFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
menuFrame.Active = true
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame", menuFrame)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel", header)
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.Text = "Zeeta Atelier Hub"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 20
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- Dragging Header
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = menuFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- Panel Konten
local leftFrame = Instance.new("Frame", menuFrame)
leftFrame.Size = UDim2.new(0.3, 0, 1, -45)
leftFrame.Position = UDim2.new(0, 0, 0, 45)
leftFrame.BackgroundTransparency = 1
Instance.new("UIListLayout", leftFrame).Padding = UDim.new(0, 5)

local rightFrame = Instance.new("Frame", menuFrame)
rightFrame.Size = UDim2.new(0.7, 0, 1, -45)
rightFrame.Position = UDim2.new(0.3, 0, 0, 45)
rightFrame.BackgroundTransparency = 1

-- FUNGSI TAB
local pages = {}
local function addMenuTab(name)
    local tabBtn = Instance.new("TextButton", leftFrame)
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    
    local page = Instance.new("ScrollingFrame", rightFrame)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    pages[name] = page
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
end

-- HELPER UI
local function createToggle(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name .. " : OFF"
    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.Text = name .. (isOn and " : ON" or " : OFF")
        callback(isOn)
    end)
end

-- SETUP MENU
addMenuTab("Local Player")
addMenuTab("ESP")

-- FITUR LOCAL PLAYER
local lpPage = pages["Local Player"]
local infJump = false
UserInputService.JumpRequest:Connect(function()
    if infJump then player.Character:FindFirstChild("Humanoid"):ChangeState("Jumping") end
end)
createToggle(lpPage, "Infinite Jump", function(v) infJump = v end)

local wsInput = Instance.new("TextBox", lpPage)
wsInput.Size = UDim2.new(1, -10, 0, 30)
wsInput.PlaceholderText = "Input WalkSpeed"
wsInput.FocusLost:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = tonumber(wsInput.Text) or 16
    end
end)

-- FITUR ESP
local espPage = pages["ESP"]
local function createHighlight(target, color)
    local h = Instance.new("Highlight", target)
    h.FillColor = color
    h.OutlineColor = Color3.new(1, 1, 1)
    return h
end

createToggle(espPage, "ESP Players", function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            if v then createHighlight(p.Character, Color3.fromRGB(255, 0, 0))
            else if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end end
        end
    end
end)

-- Buka Menu
iconButton.MouseButton1Click:Connect(function() menuFrame.Visible = not menuFrame.Visible end)
