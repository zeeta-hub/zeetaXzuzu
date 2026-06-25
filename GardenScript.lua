local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEANUP TOTAL (Menggunakan _G untuk kompatibilitas semua executor)
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
iconButton.Image = "rbxassetid://0" 
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

-- Fungsi Dragging yang Diperbarui agar lebih stabil
local function makeDraggable(object)
    local dragging = false
    local dragInput = nil
    local dragStart = Vector3.new(0,0,0)
    local startPos = UDim2.new(0,0,0,0)

    local c1 = object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = Vector3.new(input.Position.X, input.Position.Y, 0)
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    local c2 = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = Vector3.new(input.Position.X, input.Position.Y, 0) - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    table.insert(_G.ZeetaConnections, c1)
    table.insert(_G.ZeetaConnections, c2)
end

-- SISTEM TAB
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

-- INISIALISASI TAB
addMenuTab("Farming")
addMenuTab("Combat")
showPage("Farming")

iconButton.MouseButton1Click:Connect(function() menuFrame.Visible = not menuFrame.Visible end)
