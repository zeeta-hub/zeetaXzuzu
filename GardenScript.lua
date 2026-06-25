local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEANUP TOTAL (Mencegah Double/Triple UI)
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
iconButton.Image = "rbxassetid://0" -- GANTI DENGAN ID GAMBAR ANDA
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

-- Title Bar (Area Dragging)
local titleBar = Instance.new("Frame", menuFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.Active = true
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(50, 0, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "Zeeta Atelier Hub"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold

local discordBtn = Instance.new("TextButton", titleBar)
discordBtn.Size = UDim2.new(50, 50, 0.15, 25)
discordBtn.Position = UDim2.new(0.8, 50, 0.15, 0)
discordBtn.Text = "DISCORD"
discordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
discordBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 5)
discordBtn.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/link-anda") end)

-- LAYOUT KIRI DAN KANAN
local leftFrame = Instance.new("Frame", menuFrame)
leftFrame.Size = UDim2.new(0.25, 0, 1, -40)
leftFrame.Position = UDim2.new(0, 0, 0, 40)
leftFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIListLayout", leftFrame).Padding = UDim.new(0, 5)

local rightFrame = Instance.new("Frame", menuFrame)
rightFrame.Size = UDim2.new(0.75, 0, 1, -40)
rightFrame.Position = UDim2.new(0.25, 0, 0, 40)
rightFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

-- Fungsi Dragging Stabil
local function makeDraggable(object)
    local dragging, dragStart, startPos
    local c1 = object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
        end
    end)
    local c2 = UserInputService.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    local c3 = UserInputService.InputEnded:Connect(function() dragging = false end)
    table.insert(_G.ZeetaConnections, c1); table.insert(_G.ZeetaConnections, c2); table.insert(_G.ZeetaConnections, c3)
end

makeDraggable(iconButton)
makeDraggable(titleBar)

-- SISTEM TAB (Pages)
local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame", rightFrame)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = false
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    pages[name] = page
    return page
end

local function showPage(name)
    for _, p in pairs(pages) do p.Visible = false end
    if pages[name] then pages[name].Visible = true end
end

local function addMenuTab(name)
    local tabBtn = Instance.new("TextButton", leftFrame)
    tabBtn.Size = UDim2.new(1, 0, 0, 40); tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.MouseButton1Click:Connect(function() showPage(name) end)
    createPage(name)
end

-- INISIALISASI
addMenuTab("Farming")
addMenuTab("Combat")
showPage("Farming")
iconButton.MouseButton1Click:Connect(function() menuFrame.Visible = not menuFrame.Visible end)

print("ZeetaAtelier UI Berhasil Dimuat!")
