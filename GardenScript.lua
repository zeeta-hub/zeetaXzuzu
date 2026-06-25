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

-- Ikon Tombol
local iconButton = Instance.new("ImageButton", screenGui)
iconButton.Size = UDim2.new(0, 60, 0, 60)
iconButton.Position = UDim2.new(0.1, 0, 0.1, 0)
iconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
iconButton.Active = true
Instance.new("UICorner", iconButton).CornerRadius = UDim.new(1, 0)

-- Menu Utama
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
menuFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
menuFrame.Active = true
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 8)

-- HEADER (Title Bar & Discord) - Posisikan paling atas secara visual
local header = Instance.new("Frame", menuFrame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.Active = true
header.ZIndex = 5
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel", header)
titleText.Size = UDim2.new(0.6, -10, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "Zeeta Atelier Hub"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 6

local discordBtn = Instance.new("TextButton", header)
discordBtn.Size = UDim2.new(0, 70, 0, 25)
discordBtn.Position = UDim2.new(1, -80, 0.5, -12.5)
discordBtn.Text = "Discord"
discordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.Font = Enum.Font.GothamBold
discordBtn.ZIndex = 6
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 5)
discordBtn.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/link-anda") end)

-- PANEL KIRI (Tab) & KANAN (Konten) - Ditempatkan di bawah Header
local leftFrame = Instance.new("Frame", menuFrame)
leftFrame.Size = UDim2.new(0.25, 0, 1, -40)
leftFrame.Position = UDim2.new(0, 0, 0, 40)
leftFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
leftFrame.BorderSizePixel = 0

local rightFrame = Instance.new("Frame", menuFrame)
rightFrame.Size = UDim2.new(0.75, 0, 1, -40)
rightFrame.Position = UDim2.new(0.25, 0, 0, 40)
rightFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
rightFrame.BorderSizePixel = 0

Instance.new("UIListLayout", leftFrame).Padding = UDim.new(0, 5)

-- Fungsi Dragging (Ditarik lewat Header)
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

-- FUNGSI TAB
local pages = {}
local function addMenuTab(name)
    local tabBtn = Instance.new("TextButton", leftFrame)
    tabBtn.Size = UDim2.new(1, 0, 0, 40); tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); tabBtn.TextColor3 = Color3.new(1, 1, 1)
    
    local page = Instance.new("ScrollingFrame", rightFrame)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = false
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    pages[name] = page
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
end

addMenuTab("Farming")
addMenuTab("Combat")
iconButton.MouseButton1Click:Connect(function() menuFrame.Visible = not menuFrame.Visible end)
