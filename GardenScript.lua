local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BananaCatHub"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Membuat Window Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Header / Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Banana Cat Hub - Blox Fruit"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TitleBar

-- Sidebar (Kiri)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0.3, 0, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout", Sidebar)
ListLayout.Padding = UDim.new(0, 5)

-- Fungsi membuat tombol sidebar
local function addTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Parent = Sidebar
end

addTab("Shop")
addTab("Status")
addTab("Settings")

-- Content Area (Kanan)
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Size = UDim2.new(0.7, 0, 1, -40)
ContentArea.Position = UDim2.new(0.3, 0, 0, 40)
ContentArea.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

-- Fungsi membuat item row seperti di image_154afa.jpg
local function addFeature(name)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    row.Parent = ContentArea
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
    nameLabel.Parent = row
    
    local clickBtn = Instance.new("TextButton")
    clickBtn.Text = "Click"
    clickBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
    clickBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
    clickBtn.BackgroundColor3 = Color3.fromRGB(200, 170, 100) -- Warna kuning keemasan
    clickBtn.Parent = row
end

addFeature("Redeem Code")
addFeature("Teleport Old World")
addFeature("Teleport New World")
addFeature("Buy Dual Flintlock")

-- Agar bisa didrag (Script sederhana)
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
