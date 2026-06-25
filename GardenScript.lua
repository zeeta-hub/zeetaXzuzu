local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEANUP TOTAL
local GUI_NAME = "ZeetaAtelierGui"
if playerGui:FindFirstChild(GUI_NAME) then playerGui:FindFirstChild(GUI_NAME):Destroy() end
if getgenv().ZeetaConnections then
    for _, conn in pairs(getgenv().ZeetaConnections) do conn:Disconnect() end
end
getgenv().ZeetaConnections = {}

-- 2. GUI BASE
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = GUI_NAME

-- Ikon
local iconButton = Instance.new("ImageButton", screenGui)
iconButton.Size = UDim2.new(0, 60, 0, 60)
iconButton.Position = UDim2.new(0.1, 0, 0.1, 0)
iconButton.Image = "rbxassetid://0" -- GANTI ID
iconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", iconButton).CornerRadius = UDim.new(1, 0)

-- Menu Utama
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
menuFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 8)

-- Title Bar
local titleBar = Instance.new("Frame", menuFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(0.6, 0, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "Zeeta Atelier Hub"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold

local discordBtn = Instance.new("TextButton", titleBar)
discordBtn.Size = UDim2.new(0, 80, 0, 25)
discordBtn.Position = UDim2.new(0.8, 0, 0.15, 0)
discordBtn.Text = "Discord"
discordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/link-anda") end)

-- KIRI (1/4 Tab)
local leftFrame = Instance.new("Frame", menuFrame)
leftFrame.Size = UDim2.new(0.25, 0, 1, -40)
leftFrame.Position = UDim2.new(0, 0, 0, 40)
leftFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIListLayout", leftFrame).Padding = UDim.new(0, 5)

-- KANAN (3/4 Isi Menu)
local rightFrame = Instance.new("Frame", menuFrame)
rightFrame.Size = UDim2.new(0.75, 0, 1, -40)
rightFrame.Position = UDim2.new(0.25, 0, 0, 40)
rightFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

-- ScrollingFrame di dalam KANAN
local scrollingFrame = Instance.new("ScrollingFrame", rightFrame)
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 5
Instance.new("UIListLayout", scrollingFrame).Padding = UDim.new(0, 5)

-- Fungsi Dragging
local function makeDraggable(object)
    local dragging, dragStart, startPos
    local conn1 = object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
        end
    end)
    table.insert(getgenv().ZeetaConnections, conn1)
    
    local conn2 = UserInputService.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    table.insert(getgenv().ZeetaConnections, conn2)
    
    local conn3 = UserInputService.InputEnded:Connect(function() dragging = false end)
    table.insert(getgenv().ZeetaConnections, conn3)
end

makeDraggable(iconButton)
makeDraggable(titleBar) -- Geser hanya lewat title bar

-- Fungsi Add Tab
local function addMenuTab(name)
    local tabBtn = Instance.new("TextButton", leftFrame)
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    return tabBtn
end

-- Contoh isi konten
addMenuTab("Farming")
addMenuTab("Combat")

iconButton.MouseButton1Click:Connect(function() menuFrame.Visible = not menuFrame.Visible end)
