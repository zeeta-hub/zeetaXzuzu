local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- 1. CLEANUP GUI
if player.PlayerGui:FindFirstChild("ZeetaAtelierGui") then player.PlayerGui.ZeetaAtelierGui:Destroy() end

-- 2. GUI BASE
local screenGui = Instance.new("ScreenGui", player.PlayerGui); screenGui.Name = "ZeetaAtelierGui"
local iconButton = Instance.new("ImageButton", screenGui)
iconButton.Size = UDim2.new(0, 50, 0, 50); iconButton.Position = UDim2.new(0.1, 0, 0.1, 0); iconButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128); iconButton.Draggable = true
Instance.new("UICorner", iconButton).CornerRadius = UDim.new(1, 0)

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 300, 0, 450); menuFrame.Position = UDim2.new(0.2, 0, 0.2, 0); menuFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 40); menuFrame.Visible = false; menuFrame.Active = true; menuFrame.Draggable = true
Instance.new("UICorner", menuFrame)

-- Header (Biru)
local header = Instance.new("Frame", menuFrame)
header.Size = UDim2.new(1, 0, 0, 40); header.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Instance.new("UICorner", header)
local title = Instance.new("TextLabel", header); title.Size = UDim2.new(1, 0, 1, 0); title.Text = "Zeeta Atelier Hub"; title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold

-- Layout
local leftFrame = Instance.new("ScrollingFrame", menuFrame); leftFrame.Size = UDim2.new(0.35, 0, 1, -40); leftFrame.Position = UDim2.new(0, 0, 0, 40); leftFrame.BackgroundTransparency = 1
local rightFrame = Instance.new("Frame", menuFrame); rightFrame.Size = UDim2.new(0.65, 0, 1, -40); rightFrame.Position = UDim2.new(0.35, 0, 0, 40); rightFrame.BackgroundTransparency = 1

local pages = {}
local function createTab(name)
    local tabBtn = Instance.new("TextButton", leftFrame); tabBtn.Size = UDim2.new(1, 0, 0, 40); tabBtn.Text = name; tabBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150); tabBtn.TextColor3 = Color3.new(1,1,1)
    local page = Instance.new("ScrollingFrame", rightFrame); page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1; Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    pages[name] = page
    tabBtn.MouseButton1Click:Connect(function() for _,p in pairs(pages) do p.Visible = false end; page.Visible = true end)
end
createTab("Local"); createTab("ESP"); createTab("Teleport")

-- UI Helpers
local function createToggle(parent, name, callback)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(1, -10, 0, 30); btn.Text = name..": OFF"; btn.BackgroundColor3 = Color3.fromRGB(120, 0, 120); btn.TextColor3 = Color3.new(1,1,1)
    local isOn = false
    btn.MouseButton1Click:Connect(function() isOn = not isOn; btn.Text = name..(isOn and ": ON" or ": OFF"); callback(isOn) end)
end

-- Tab Local
createToggle(pages["Local"], "Inf Jump", function(v) _G.InfJump = v end)
UserInputService.JumpRequest:Connect(function() if _G.InfJump then player.Character.Humanoid:ChangeState("Jumping") end end)

local slider = Instance.new("TextButton", pages["Local"]); slider.Size = UDim2.new(1, -10, 0, 30); slider.Text = "Walkspeed: 16"; slider.BackgroundColor3 = Color3.fromRGB(80, 0, 80); slider.TextColor3 = Color3.new(1,1,1)
slider.MouseButton1Down:Connect(function()
    local conn; conn = RunService.RenderStepped:Connect(function()
        local pos = math.clamp((mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local val = math.floor(pos * 150) -- Max 150
        slider.Text = "Walkspeed: " .. val
        if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = val end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() end
    end)
end)

-- Tab ESP (Logic)
_G.ESP = {Players = false, Fruits = false, Seeds = false, Pets = false}
createToggle(pages["ESP"], "ESP Players", function(v) _G.ESP.Players = v end)
createToggle(pages["ESP"], "ESP Fruits", function(v) _G.ESP.Fruits = v end)
createToggle(pages["ESP"], "ESP Seeds", function(v) _G.ESP.Seeds = v end)
createToggle(pages["ESP"], "ESP Pets", function(v) _G.ESP.Pets = v end)

RunService.RenderStepped:Connect(function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        local isTarget = false; local labelText = ""
        if _G.ESP.Players and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= player.Name then isTarget = true; labelText = obj.Name .. "\n" .. math.floor((player.Character.Head.Position - obj.Head.Position).Magnitude) .. "m"
        elseif _G.ESP.Fruits and obj.Name == "Fruit" then isTarget = true; labelText = "Fruit"
        elseif _G.ESP.Seeds and obj.Name == "Seed" then isTarget = true; labelText = "Seed"
        elseif _G.ESP.Pets and obj:FindFirstChild("PetName") then isTarget = true; labelText = obj.PetName.Value end
        
        if isTarget and obj:FindFirstChild("HumanoidRootPart") then
            if not obj.HumanoidRootPart:FindFirstChild("EspTag") then
                local b = Instance.new("BillboardGui", obj.HumanoidRootPart); b.Name = "EspTag"; b.Size = UDim2.new(0, 100, 0, 50); Instance.new("TextLabel", b).Size = UDim2.new(1,0,1,0)
            end
            obj.HumanoidRootPart.EspTag.TextLabel.Text = labelText
        elseif obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart:FindFirstChild("EspTag") then
            obj.HumanoidRootPart.EspTag:Destroy()
        end
    end
end)

-- Tab Teleport
local tpEnabled = true
createToggle(pages["Teleport"], "TP Toggle", function(v) tpEnabled = v end)
local locs = {Seed = Vector3.new(265, 146, -147), Gears = Vector3.new(243, 146, -144), Props = Vector3.new(237, 146, -123), Sell = Vector3.new(271, 146, -125), Guilds = Vector3.new(255, 146, -113)}
for name, pos in pairs(locs) do
    local btn = Instance.new("TextButton", pages["Teleport"]); btn.Size = UDim2.new(1, -10, 0, 30); btn.Text = "TP: "..name; btn.BackgroundColor3 = Color3.fromRGB(150, 50, 150); btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function() if tpEnabled and player.Character then player.Character.HumanoidRootPart.CFrame = CFrame.new(pos) end end)
end

iconButton.MouseButton1Click:Connect(function() menuFrame.Visible = not menuFrame.Visible end)
