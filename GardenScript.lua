local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEANUP
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

-- Link Discord
local discordBtn = Instance.new("TextButton", titleBar)
discordBtn.Size = UDim2.new(0, 100, 0, 30)
discordBtn.Position = UDim2.new(1, -110, 0.1, 0)
discordBtn.Text = "Discord"
discordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
discordBtn.Parent = titleBar
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

-- ScrollingFrame di dalam Kanan
local scrollingFrame = Instance.new("ScrollingFrame", rightFrame)
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.BackgroundTransparency = 1
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
    -- (tambahkan logika inputChanged & inputEnded yang sama seperti sebelumnya...)
end

makeDraggable(iconButton)
makeDraggable(titleBar) -- Geser lewat title bar saja agar lebih enak

iconButton.MouseButton1Click:Connect(function() menuFrame.Visible = not menuFrame.Visible end)

-- 4. FUNGSI BUKA/TUTUP
iconButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

print("ZeetaAtelier UI Berhasil Dimuat!")

-- === 3. Membuat Daftar Pilihan di dalam menuFrame ===
local scrollingFrame = Instance.new("ScrollingFrame", menuFrame)
scrollingFrame.Size = UDim2.new(1, -10, 1, -50) -- Mengambil hampir seluruh area menu
scrollingFrame.Position = UDim2.new(0, 5, 0, 45)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 5

-- Fungsi untuk menambah pilihan ke daftar
local function addOption(name, callback)
    local btn = Instance.new("TextButton", scrollingFrame)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, (#scrollingFrame:GetChildren() - 1) * 45) -- Posisi otomatis
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(callback)
end

- Bagian Kiri (List Panel)
local leftFrame = Instance.new("Frame", menuFrame)
leftFrame.Size = UDim2.new(0.25, 0, 1, -40) -- 25% lebar, tinggi dikurangi tinggi titleBar
leftFrame.Position = UDim2.new(0, 0, 0, 40) -- Di bawah titleBar
leftFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
leftFrame.BorderSizePixel = 0

-- Bagian Kanan (Content Panel)
local rightFrame = Instance.new("Frame", menuFrame)
rightFrame.Size = UDim2.new(0.75, 0, 1, -40) -- 75% lebar
rightFrame.Position = UDim2.new(0.25, 0, 0, 40) -- Di samping kiri
rightFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
rightFrame.BorderSizePixel = 0

-- Contoh menambah tombol di kiri (1/4)
local function addMenuTab(name, callback)
    local tabBtn = Instance.new("TextButton", leftFrame)
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.Font = Enum.Font.Gotham

    -- Mengatur posisi otomatis ke bawah
    Instance.new("UIListLayout", leftFrame).Padding = UDim.new(0, 5)
    
    tabBtn.MouseButton1Click:Connect(callback)
end

-- Menambah tab contoh
addMenuTab("Farming", function()
    -- Bersihkan rightFrame lalu isi dengan menu farming
    print("Membuka menu Farming")
end)

addMenuTab("Combat", function()
    print("Membuka menu Combat")
end)

-- Update CanvasSize agar bisa di-scroll
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #scrollingFrame:GetChildren() * 45)
