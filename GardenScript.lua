local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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

local iconButton = Instance.new("ImageButton", screenGui)
iconButton.Size = UDim2.new(0, 60, 0, 60)
iconButton.Position = UDim2.new(0.1, 0, 0.1, 0)
iconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
iconButton.Active = true
iconButton.Draggable = true
Instance.new("UICorner", iconButton).CornerRadius = UDim.new(1, 0)

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0.4, 0, 0.5, 0)
menuFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
menuFrame.Active = true
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 8)

-- --- HELPER FUNGSI ---
local function createToggle(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name .. " : OFF"
    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.Text = name .. (isOn and " : ON" or " : OFF")
        callback(isOn)
    end)
    return btn
end

-- --- TAB LOGIC ---
local leftFrame = Instance.new("Frame", menuFrame)
leftFrame.Size = UDim2.new(0.3, 0, 1, 0); leftFrame.BackgroundTransparency = 1
local rightFrame = Instance.new("Frame", menuFrame)
rightFrame.Size = UDim2.new(0.7, 0, 1, 0); rightFrame.Position = UDim2.new(0.3, 0, 0, 0); rightFrame.BackgroundTransparency = 1

local pages = {}
local function addTab(name)
    local tabBtn = Instance.new("TextButton", leftFrame)
    tabBtn.Size = UDim2.new(1, 0, 0, 40); tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    local page = Instance.new("ScrollingFrame", rightFrame)
    page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    pages[name] = page
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
end

addTab("Local"); addTab("ESP"); addTab("Teleport")

-- 3. FITUR LOCAL
local lpPage = pages["Local"]
local infJump = false
UserInputService.JumpRequest:Connect(function()
    if infJump then player.Character:FindFirstChild("Humanoid"):ChangeState("Jumping") end
end)
createToggle(lpPage, "Infinite Jump", function(v) infJump = v end)

-- Slider Speed
local sliderBg = Instance.new("Frame", lpPage)
sliderBg.Size = UDim2.new(1, -10, 0, 40); sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
local sliderBar = Instance.new("Frame", sliderBg)
sliderBar.Size = UDim2.new(0.16, 0, 1, 0); sliderBar.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
local sliderLabel = Instance.new("TextLabel", sliderBg)
sliderLabel.Size = UDim2.new(1, 0, 1, 0); sliderLabel.Text = "Walkspeed: 16"; sliderLabel.BackgroundTransparency = 1

sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local relX = math.clamp((mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderBar.Size = UDim2.new(relX, 0, 1, 0)
            local speed = math.floor(relX * 100)
            sliderLabel.Text = "Walkspeed: " .. speed
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = speed
            end
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end end)
    end
end)

-- 4. FITUR ESP
local espPage = pages["ESP"]
local espEnabled = false
createToggle(espPage, "ESP Player", function(v) 
    espEnabled = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("EspTag") then p.Character.EspTag:Destroy() end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and not p.Character:FindFirstChild("EspTag") then
            local bill = Instance.new("BillboardGui", p.Character)
            bill.Name = "EspTag"; bill.Size = UDim2.new(0, 100, 0, 50); bill.StudsOffset = Vector3.new(0, 2, 0)
            local label = Instance.new("TextLabel", bill)
            label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.new(1, 1, 1)
            spawn(function()
                while bill.Parent and espEnabled do
                    local dist = (player.Character.Head.Position - p.Character.Head.Position).Magnitude
                    label.Text = p.Name .. "\n" .. math.floor(dist) .. " studs"
                    task.wait(0.1)
                end
            end)
        end
    end
end)

-- 5. FITUR TELEPORT
-- Tambahkan bagian ini ke dalam setup Teleport Anda
local tpPage = pages["Teleport"]

-- 1. Status Teleport Global
local teleportEnabled = true
createToggle(tpPage, "Teleport Status", function(v) teleportEnabled = v end)

-- 2. Dropdown Utama
local dropdownFrame = Instance.new("Frame", tpPage)
dropdownFrame.Size = UDim2.new(1, -10, 0, 40)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdownFrame.BorderSizePixel = 0

local dropdownBtn = Instance.new("TextButton", dropdownFrame)
dropdownBtn.Size = UDim2.new(1, 0, 1, 0)
dropdownBtn.Text = "Pilih Lokasi Teleport ▼"
dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdownBtn.TextColor3 = Color3.new(1, 1, 1)
dropdownBtn.Font = Enum.Font.GothamBold

-- 3. Container List Lokasi
local listFrame = Instance.new("ScrollingFrame", dropdownFrame)
listFrame.Size = UDim2.new(1, 0, 0, 150)
listFrame.Position = UDim2.new(0, 0, 1, 5)
listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
listFrame.Visible = false
listFrame.ScrollBarThickness = 5
Instance.new("UIListLayout", listFrame).Padding = UDim.new(0, 2)

dropdownBtn.MouseButton1Click:Connect(function() 
    listFrame.Visible = not listFrame.Visible 
end)

-- 4. Daftar Lokasi
local locations = {
    ["Seed"] = Vector3.new(265.64, 146.56, -147.83),
    ["Gears"] = Vector3.new(243.08, 146.56, -144.90),
    ["Props"] = Vector3.new(237.62, 146.56, -123.65),
    ["Sell"] = Vector3.new(271.91, 146.56, -125.33),
    ["Guilds"] = Vector3.new(255.86, 146.56, -113.30)
}

for name, pos in pairs(locations) do
    local btn = Instance.new("TextButton", listFrame)
    btn.Size = UDim2.new(1, -5, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    btn.MouseButton1Click:Connect(function()
        if teleportEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
            listFrame.Visible = false -- Tutup otomatis setelah memilih
        end
    end)
end

iconButton.MouseButton1Click:Connect(function() menuFrame.Visible = not menuFrame.Visible end)
