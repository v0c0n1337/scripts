--// Proton Admin
local Admin = {
    Name = "Proton Admin",
    Prefix = "/",
    Invite = "6DJReS2qFZ",
    Info = {}
}
--// inserting info shit into Admin.Info table
table.insert(Admin.Info,tostring(Admin.Name))
table.insert(Admin.Info,"Prefix is set to "..Admin.Prefix)
table.insert(Admin.Info,"Discord Invite: "..Admin.Invite)
--// custom chat function so i don't gotta use Players:Chatted or the chat event or any of that bullshit
local function chat(text)
	StarterGui = game:GetService('StarterGui')
	A = false
	ChatBar = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('Chat'):WaitForChild('Frame'):WaitForChild('ChatBarParentFrame'):WaitForChild('Frame'):WaitForChild('BoxFrame'):WaitForChild('Frame'):FindFirstChildOfClass('TextBox')
	A = StarterGui:GetCore('ChatActive')
	StarterGui:SetCore('ChatActive', true)
	ChatBar:CaptureFocus()
	ChatBar.Text = text
    ChatBar.TextEditable = false
	ChatBar:ReleaseFocus(true)
    ChatBar.TextEditable = true
	StarterGui:SetCore('ChatActive', A)
end
--// Printing out info on execution
for i,v in pairs(Admin.Info) do
    print(v)
end
--// Variables
local players = game:GetService("Players")
local p = players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ws = game:GetService("Workspace")
local whitelisted = {p}
local Commands = {}
local connected = {}
local target
local speaker
local args
local regargs
local prefix = "/"
local guiprefix = ";"
local gui
local guicons = {}
local main
local cmdbar
local cmdbartextbox
local cmdlist
local cmdlisttext
local cmdlistsearchtextbox
local cmdlistclose
local main
--// getplayer function
local function getplayer(Name)
    Name = Name:lower():gsub(" ","")
    for _,x in next, players:GetPlayers() do
        if x ~= p then
            if x.Name:lower():match("^"..Name) then
                return x
            elseif x.DisplayName:lower():match("^"..Name) then
                return x
            end
        end
    end
end
--// addcmd function with onchatted connecting
function addcmd(Name, callback)
    if Name:match(", ") then
        Commands[Name] = Name:split(", ")
    else
        Commands[Name] = {}
        Commands[Name].Name = Name
        Commands[Name].callback = callback
    end
    cmdlisttext.Text = cmdlisttext.Text.."\n"..Name
    table.insert(connected,game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(messagedata)
        local wl = players:FindFirstChild(messagedata.FromSpeaker)
        msg = messagedata.Message
        if wl and table.find(whitelisted, wl) then
            speaker = wl
            msg = msg:lower()
            args = msg:split(' ')
            if args[1] == prefix..Name then
                if args[2] then
                    if args[2] == "all" then
                        target = players:GetPlayers()
                    elseif args[2] == "others" then
                        local plrtable = {}
                        for i,v in pairs(players:GetPlayers()) do
                               if v ~= p then
                                table.insert(plrtable,v)
                            end
                        end
                        target = plrtable
                    elseif args[2] == "me" then
                        target = speaker
                    else
                        target = getplayer(args[2])
                    end
                else
                    target = speaker
                end
                local success, err = pcall(function()
                    coroutine.wrap(function()
                        callback()
                    end)()
                end)
            end
        end
    end))
end
--// UI stuff
local function loadui(id)
    if gui then
        gui:Destroy()
        for i,v in pairs(guicons) do
            v:Disconnect()
        end
    end
    gui = game:GetObjects("rbxassetid://"..id)[1]
    if gui:IsA("ScreenGui") then
        main = gui:FindFirstChild("ProtonMain", true)
        cmdbar = gui:FindFirstChild("ProtonCommandBar", true)
        cmdbartextbox = gui:FindFirstChild("ProtonCommandBarTextbox", true)
        cmdlist = gui:FindFirstChild("ProtonCommandList", true)
        cmdlisttext = gui:FindFirstChild("ProtonCommandListText", true)
        cmdlistsearchtextbox = gui:FindFirstChild("ProtonCommandListSearchTextbox", true)
        cmdlistclose = gui:FindFirstChild("ProtonCommandListClose", true)
        main = gui:FindFirstChild("ProtonMain", true) or cmdbar
        local belowpos = UDim2.new(0.5,main.AbsoluteSize.X/2,1,main.AbsoluteSize.Y/2)
        gui.Parent = p.PlayerGui
        gui.ResetOnSpawn = false
        main.Visible = false
        cmdlist.Visible = false
        cmdlist.Draggable = true
        cmdlist.Active = true
        cmdlist.Selectable = true
        cmdlistclose.MouseButton1Click:Connect(function()
            cmdlist.Visible = false
        end)
        for i,v in pairs(main:GetDescendants()) do
            if (pcall(function() return v.BackgroundTransparency; end)) then
                pcall(function()
                    local val = Instance.new("NumberValue", v)
                    val.Name = "backtrans"
                    val.Value = v.BackgroundTransparency
                    v.BackgroundTransparency = 1
                end)
            end
        end
        for i,v in pairs(main:GetDescendants()) do
            pcall(function()
                if (pcall(function() return v.TextTransparency; end)) then
                    pcall(function()
                        local val = Instance.new("NumberValue", v)
                        val.Name = "texttrans"
                        val.Value = v.TextTransparency
                        v.TextTransparency = 1
                    end)
                end
            end)
        end
        for i,v in pairs(main:GetDescendants()) do
            if (pcall(function() return v.ImageTransparency; end)) then
                pcall(function()
                    local val = Instance.new("NumberValue", v)
                    val.Name = "imagetrans"
                    val.Value = v.ImageTransparency
                    v.ImageTransparency = 1
                end)
            end
        end
        table.insert(guicons,p:GetMouse().KeyDown:Connect(function(key)
            if key == guiprefix then
                main.Visible = true
                local tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(0.25, Enum.EasingStyle.Linear)
                for i,v in pairs(main:GetDescendants()) do
                    if (pcall(function() return v.BackgroundTransparency; end)) then
                        pcall(function()
                            tweenService:Create(v, tweenInfo, {BackgroundTransparency = v.backtrans.Value}):Play()
                        end)
                    end
                end
                for i,v in pairs(main:GetDescendants()) do
                    if (pcall(function() return v.TextTransparency; end)) then
                        pcall(function()
                            tweenService:Create(v, tweenInfo, {TextTransparency = v.texttrans.Value}):Play()
                        end)
                    end
                end
                for i,v in pairs(main:GetDescendants()) do
                    if (pcall(function() return v.ImageTransparency; end)) then
                        pcall(function()
                            tweenService:Create(v, tweenInfo, {ImageTransparency = v.imagetrans.Value}):Play()
                        end)
                    end
                end
                task.wait()
                cmdbartextbox:CaptureFocus()
                --[[local currentmessage
                local focused = true
                coroutine.wrap(function()
                    while focused do
                        currentmessage = cmdbartextbox.Text
                        task.wait()
                    end
                end)()]]
                cmdbartextbox.FocusLost:Wait()
                local wl = p
                --msg = currentmessage
                msg = cmdbartextbox.Text
                if wl and table.find(whitelisted, wl) then
                    speaker = wl
                    msg = msg:lower()
                    args = msg:split(' ')
                    if Commands[args[1]] or Commands[args[1]:split(prefix)[1]] then
                        local commandname = Commands[args[1]] or Commands[args[1]:split(prefix)[1]]
                        if args[2] then
                            if args[2] == "all" then
                                target = players:GetPlayers()
                            elseif args[2] == "others" then
                                local plrtable = {}
                                for i,v in pairs(players:GetPlayers()) do
                                    if v ~= p then
                                        table.insert(plrtable,v)
                                    end
                                end
                                target = plrtable
                            elseif args[2] == "me" and speaker then
                                target = speaker
                            elseif (pcall(function() return(getplayer(args[2])) end)) then
                                target = getplayer(args[2])
                            end
                        else
                            target = speaker
                        end
                        local success, err = pcall(function()
                            coroutine.wrap(function()
                                commandname.callback()
                            end)()
                        end)
                    end
                end
                for i,v in pairs(main:GetDescendants()) do
                    if (pcall(function() return v.BackgroundTransparency; end)) then
                        pcall(function()
                            tweenService:Create(v, tweenInfo, {BackgroundTransparency = 1}):Play()
                        end)
                    end
                end
                for i,v in pairs(main:GetDescendants()) do
                    if (pcall(function() return v.TextTransparency; end)) then
                        pcall(function()
                            tweenService:Create(v, tweenInfo, {TextTransparency = 1}):Play()
                        end)
                    end
                end
                for i,v in pairs(main:GetDescendants()) do
                    if (pcall(function() return v.ImageTransparency; end)) then
                        pcall(function()
                            tweenService:Create(v, tweenInfo, {ImageTransparency = 1}):Play()
                        end)
                    end
                end
                task.wait(0.25)
                main.Visible = false
            end
        end))
    end
end
--// Load UI
if not _G.UI_Id or _G.UI_Id and _G.UI_Id == "default" then
    loadui(10981707755)
else
    loadui(_G.UI_Id)
end
--// Functions
local function breakvel(part)
    local stay = Instance.new("BodyVelocity")
    stay.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    stay.P = math.huge
    stay.Velocity = Vector3.new(0, 0, 0)
    stay.Parent = part
    local brv = true
    coroutine.wrap(function()
        while brv do
            for i,v in pairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Velocity = Vector3.new()
                    v.RotVelocity = Vector3.new()
                end
            end
            game:GetService("RunService").Heartbeat:Wait()
        end
    end)()
    task.wait()
    brv = false
    stay:Destroy()
end
local function fakechar()
    local clone = game:GetObjects("rbxassetid://8370047840")[1]
    clone.Parent = game:GetService("Workspace")
    clone:MoveTo(p.Character.PrimaryPart.Position)
    clone:FindFirstChild("HumanoidRootPart").Anchored = false
    for i,v in pairs(clone:GetDescendants()) do
        if (pcall(function() return v.Transparency; end)) then
		    pcall(function()
			    v.Transparency = 1
		    end)
        end
    end
    for i,v in pairs(clone:GetDescendants()) do
        if v:IsA("Accessory") then
            v:Destroy()
        end
    end
    p.Character = clone
    game:GetService("Workspace").CurrentCamera.CameraSubject = clone:FindFirstChild("Humanoid")
end
local function replacechar()
    local c = p.Character
    p.Character = nil
    p.Character = c
end
local function replacehum()
    local h = p.Character:FindFirstChild("Humanoid"):Clone()
    p.Character:FindFirstChild("Humanoid"):Destroy()
    h.Parent = p.Character
end
local function massless(model)
    for i,v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Massless = true
        end
    end
end
local function anchorchar()
    for i,v in pairs(p.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = true
        end
    end
end
local function unanchorchar()
    for i,v in pairs(p.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = false
        end
    end
end
local function breakjoints(model)
    for i,v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v:BreakJoints()
        end
    end
end
local function getnetlessvelocity(realPartVelocity)
    if (realPartVelocity.Y > 1) or (realPartVelocity.Y < -1) then
        return realPartVelocity * (25.1 / realPartVelocity.Y)
    end
    realPartVelocity = realPartVelocity * Vector3.new(1, 0, 1)
    local mag = realPartVelocity.Magnitude
    if mag > 1 then
        realPartVelocity = realPartVelocity * 100 / mag
    end
    return realPartVelocity + Vector3.new(0, 26, 0)
end
local function align(Part1,Part0,CFrameOffset)
	local AlignPos = Instance.new('AlignPosition', Part1)
    AlignPos.Name = "alignpos"
	AlignPos.Parent.CanCollide = false
	AlignPos.ApplyAtCenterOfMass = true
	AlignPos.MaxForce = 67752
	AlignPos.MaxVelocity = math.huge/9e110
	AlignPos.ReactionForceEnabled = false
	AlignPos.Responsiveness = 200
	AlignPos.RigidityEnabled = false
	local AlignOri = Instance.new('AlignOrientation', Part1)
    AlignOri.Name = "alignori"
	AlignOri.MaxAngularVelocity = math.huge/9e110
	AlignOri.MaxTorque = 67752
	AlignOri.PrimaryAxisOnly = false
	AlignOri.ReactionTorqueEnabled = false
	AlignOri.Responsiveness = 200
	AlignOri.RigidityEnabled = false
	local AttachmentA=Instance.new('Attachment',Part1)
    AttachmentA.Name = "aa"
	local AttachmentB=Instance.new('Attachment',Part0)
    AttachmentB.Name = "ab"
	AttachmentB.CFrame = AttachmentB.CFrame * CFrameOffset
	AlignPos.Attachment0 = AttachmentA
	AlignPos.Attachment1 = AttachmentB
	AlignOri.Attachment0 = AttachmentA
	AlignOri.Attachment1 = AttachmentB
    local realVelocity = Vector3.new(0,30,0)
    local steppedcon = game:GetService("RunService").Stepped:Connect(function()
        Part1.Velocity = realVelocity
    end)
    local heartbeatcon = game:GetService("RunService").Heartbeat:Connect(function()
        realVelocity = Part1.Velocity
        Part1.Velocity = getnetlessvelocity(realVelocity)
    end)
    Part1.Destroying:Connect(function()
        Part1 = nil
        steppedcon:Disconnect()
        heartbeatcon:Disconnect()
    end)
end
local x = Instance.new("BindableEvent")
for _, v in ipairs({game:GetService("RunService").RenderStepped, game:GetService("RunService").Heartbeat, game:GetService("RunService").Stepped}) do
    v.Connect(v, function()
        return x.Fire(x, tick())
    end)
end
local superstepped = x.Event
local function superwait()
    x.Event:Wait()
end
local function unalign(Part1,Part0)
    Part1:FindFirstChild("alignpos"):Destroy()
    Part1:FindFirstChild("alignori"):Destroy()
    Part1:FindFirstChild("aa"):Destroy()
    Part0:FindFirstChild("ab"):Destroy()
end
local mouse = p:GetMouse()
local FLYING = false
local QEfly = true
local flyspeed = 1
local vehicleflyspeed = 1
local function sFLY(vfly)
	repeat task.wait() until p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid")
	repeat task.wait() until mouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = p.Character:FindFirstChild("HumanoidRootPart")
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 10e5
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(10e11, 10e11, 10e11)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new()
		BV.maxForce = Vector3.new(10e11, 10e11, 10e11)
		task.spawn(function()
			repeat wait()
				if not vfly and p.Character:FindFirstChildOfClass('Humanoid') then
					p.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = ws.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if p.Character:FindFirstChildOfClass('Humanoid') then
				p.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	local flyKeyDown = mouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or flyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or flyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or flyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or flyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or flyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or flyspeed)*2
		end
		pcall(function() ws.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	local flyKeyUp = mouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

local function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if p.Character:FindFirstChildOfClass('Humanoid') then
		p.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end
--//RHS Commands
if game.PlaceId == 9689581 then
    addcmd("carmod", function()
        if ws:FindFirstChild("vehicle_"..p.Name) then
            for i,v in pairs(ws:FindFirstChild("vehicle_"..p.Name):FindFirstChild("Configuration"):GetChildren()) do
                if v:IsA("NumberValue") then
                    v.Value = math.huge
                end
            end
        end
    end)
    addcmd("removebarriers", function()
        ws:FindFirstChild("CarStoppers"):Destroy()
    end)
    addcmd("skill", function()
        rs.RemoteFunctions.RequestToEquipGear:InvokeServer(234)
        p.Character:WaitForChild("Deluxe Blue Roped")
        wait()
        p.Character:FindFirstChild("HumanoidRootPart").Anchored = true
        wait()
        p.Character:FindFirstChild("Deluxe Blue Roped").Parent = ws
        coroutine.wrap(function()
            wait(0.4)
            p.Character:FindFirstChild("HumanoidRootPart").Anchored = false
        end)()
        repeat task.wait()
            if true then
                firetouchinterest(ws:FindFirstChild("Deluxe Blue Roped"):FindFirstChild("Handle"),target.Character:FindFirstChild("HumanoidRootPart"),0)
                firetouchinterest(ws:FindFirstChild("Deluxe Blue Roped"):FindFirstChild("Handle"),target.Character:FindFirstChild("HumanoidRootPart"),1)
            else
                ws:FindFirstChild("Deluxe Blue Roped"):FindFirstChild("Handle").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
            end
        until not ws:FindFirstChild("Deluxe Blue Roped")
        task.wait(10)
        rs.RemoteFunctions.RequestToEquipGear:InvokeServer(329)
        p.Character:FindFirstChild("Sparkler").Parent = ws
        repeat task.wait()
            if true then
                firetouchinterest(ws:FindFirstChild("Sparkler"):FindFirstChild("Handle"),target.Character:FindFirstChild("HumanoidRootPart"),0)
                firetouchinterest(ws:FindFirstChild("Sparkler"):FindFirstChild("Handle"),target.Character:FindFirstChild("HumanoidRootPart"),1)
            else
               ws:FindFirstChild("Sparkler"):FindFirstChild("Handle").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
            end
        until not ws:FindFirstChild("Sparkler")
    end)
    addcmd("fat", function()
        local item = "Frost Potion"
        local location = "Club Red"
        if type(target) == "table" then
            for i,v in pairs(target) do
                game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
                local fp = p.Backpack:FindFirstChild(item)
                fp.Parent = p.Character
                fp:Activate()
                fp.Parent = ws
                if true then
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 0)
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 1)
                else
                    repeat
                        fp:FindFirstChild("Handle").CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame
                        task.wait()
                    until fp.Parent == v.Character
                end
            end
        else
            game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
            local fp = p.Backpack:FindFirstChild(item)
            fp.Parent = p.Character
            fp:Activate()
            fp.Parent = ws
            if true then
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 0)
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 1)
            else
                repeat
                    fp:FindFirstChild("Handle").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
                    task.wait()
                until fp.Parent == target.Character
            end
        end
    end)
    addcmd("spin", function()
        local item = "Spice-It-Up Drink"
        local location = "Club Red"
        if type(target) == "table" then
            for i,v in pairs(target) do
                game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
                local fp = p.Backpack:FindFirstChild(item)
                fp.Parent = p.Character
                fp:Activate()
                fp.Parent = ws
                if true then
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 0)
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 1)
                else
                    repeat
                        fp:FindFirstChild("Handle").CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame
                        task.wait()
                    until fp.Parent == v.Character
                end
            end
        else
            game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
            local fp = p.Backpack:FindFirstChild(item)
            fp.Parent = p.Character
            fp:Activate()
            fp.Parent = ws
            if true then
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 0)
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 1)
            else
                repeat
                    fp:FindFirstChild("Handle").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
                    task.wait()
                until fp.Parent == target.Character
            end
        end
    end)
    addcmd("moonwalk", function()
        local item = "The Michael Jackson"
        local location = "Club Red"
        if type(target) == "table" then
            for i,v in pairs(target) do
                game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
                local fp = p.Backpack:FindFirstChild(item)
                fp.Parent = p.Character
                fp:Activate()
                fp.Parent = ws
                if true then
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 0)
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 1)
                else
                    repeat
                        fp:FindFirstChild("Handle").CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame
                        task.wait()
                    until fp.Parent == v.Character
                end
            end
        else
            game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
            local fp = p.Backpack:FindFirstChild(item)
            fp.Parent = p.Character
            fp:Activate()
            fp.Parent = ws
            if true then
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 0)
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 1)
            else
                repeat
                    fp:FindFirstChild("Handle").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
                    task.wait()
                until fp.Parent == target.Character
            end
        end
    end)
    addcmd("cola", function()
        local item = "Bloxy Cola"
        local location = "Club Red"
        if type(target) == "table" then
            for i,v in pairs(target) do
                game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
                local fp = p.Backpack:FindFirstChild(item)
                fp.Parent = p.Character
                fp:Activate()
                fp.Parent = ws
                if true then
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 0)
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 1)
                else
                    repeat
                        fp:FindFirstChild("Handle").CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame
                        task.wait()
                    until fp.Parent == v.Character
                end
            end
        else
            game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
            local fp = p.Backpack:FindFirstChild(item)
            fp.Parent = p.Character
            fp:Activate()
            fp.Parent = ws
            if true then
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 0)
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 1)
            else
                repeat
                    fp:FindFirstChild("Handle").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
                    task.wait()
                until fp.Parent == target.Character
            end
        end
    end)
    addcmd("bighead", function()
        local item = "Witches Brew"
        local location = "Club Red"
        if type(target) == "table" then
            for i,v in pairs(target) do
                game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
                local fp = p.Backpack:FindFirstChild(item)
                fp.Parent = p.Character
                fp:Activate()
                fp.Parent = ws
                if true then
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 0)
                    firetouchinterest(fp:FindFirstChild("Handle"), v.Character:FindFirstChild("HumanoidRootPart"), 1)
                else
                    repeat
                        fp:FindFirstChild("Handle").CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame
                        task.wait()
                    until fp.Parent == v.Character
                end
            end
        else
            game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer(location, item)
            local fp = p.Backpack:FindFirstChild(item)
            fp.Parent = p.Character
            fp:Activate()
            fp.Parent = ws
            if true then
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 0)
                firetouchinterest(fp:FindFirstChild("Handle"), target.Character:FindFirstChild("HumanoidRootPart"), 1)
            else
                repeat
                    fp:FindFirstChild("Handle").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
                    task.wait()
                until fp.Parent == target.Character
            end
        end
    end)
    addcmd("bigheaddupe", function()
        local c = game.Players.LocalPlayer.Character
        for i, v in pairs(c.Humanoid:GetChildren()) do
            if v:IsA("NumberValue") then
                for i, v1 in pairs(c:GetChildren()) do
                    if v1:FindFirstChild("AvatarPartScaleType", true) then
                        repeat
                            wait()
                        until v1:FindFirstChild("OriginalSize", true)
                        v1:FindFirstChild("OriginalSize", true):Destroy()
                        v:Destroy()
                    end
                end
            end
        end
        c:FindFirstChild("Head"):FindFirstChild("Mesh"):Destroy()
        for i,v in pairs(args) do
            print(v)
        end
        if args[2] then
            print(args[2])
            for i = 1, tonumber(args[2]) do
                game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer("Club Red", "Decoy Deploy")
                local fp = p.Backpack:FindFirstChild("Decoy Deploy")
                fp.Parent = c
                fp:Activate()
            end
        else
            game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer("Club Red", "Decoy Deploy")
            local fp = p.Backpack:FindFirstChild("Decoy Deploy")
            fp.Parent = c
            fp:Activate()
        end
    end)
    addcmd("clone", function()
        local c = game.Players.LocalPlayer.Character
        for i,v in pairs(args) do
            print(v)
        end
        if args[2] then
            print(args[2])
            for i = 1, tonumber(args[2]) do
                game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer("Club Red", "Decoy Deploy")
                local fp = p.Backpack:FindFirstChild("Decoy Deploy")
                fp.Parent = c
                fp:Activate()
            end
        else
            game:GetService("ReplicatedStorage").RemoteFunctions.PurchaseTemporaryItem:InvokeServer("Club Red", "Decoy Deploy")
            local fp = p.Backpack:FindFirstChild("Decoy Deploy")
            fp.Parent = c
            fp:Activate()
        end
    end)
    addcmd("fishautofarm", function()
        while task.wait(3) do
            game:GetService("ReplicatedStorage").RemoteFunctions.fishUpdate:InvokeServer(p.UserId)
        end
    end)
    addcmd("starautofarm", function()
        local p = game:GetService("Players").LocalPlayer
        while task.wait(0.5) do
            if p.Character and p.Character.PrimaryPart and game.Workspace:FindFirstChild("ShootingStar") then
                firetouchinterest(p.Character.PrimaryPart,game.Workspace:FindFirstChild("ShootingStar"),0)
                firetouchinterest(p.Character.PrimaryPart,game.Workspace:FindFirstChild("ShootingStar"),1)
            end
        end
    end)
    addcmd("phone", function()
        connected.annoycon = game:GetService("RunService").Stepped:Connect(function()
            game:GetService("ReplicatedStorage").RemoteFunctions.SendTextMessage:InvokeServer(target,target.textingdata.messages:FindFirstChild(p.Name),tostring(math.random(0,999999)))
        end)
    end)
    addcmd("unphone", function()
        for i,v in pairs(connected) do
            connected.annoycon:Disconnect()
        end
    end)
    addcmd("item", function()
        game:GetService("ReplicatedStorage").RemoteFunctions.EnterHouseEditMode:FireServer()
        local house = game:GetService("Workspace"):FindFirstChild("!home_"..p.Name)
        local itemtab = regargs[2]:split("_")
        local item = table.concat(itemtab," ")
        local function getitem()
            if game:GetService("ReplicatedStorage").Objects:FindFirstChild("gear_"..item) then
                local old = p.Character:FindFirstChild("HumanoidRootPart").CFrame
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = house:FindFirstChild("Lock Button"):FindFirstChild("LockButton")
                pcall(function()
                    game:GetService("ReplicatedStorage").RemoteFunctions.GetFurniture:InvokeServer("gear_"..item)
                end)
                local gearval = house:WaitForChild("gear_"..item)
                repeat game:GetService("RunService").Heartbeat:Wait() until gearval:FindFirstChildWhichIsA("Tool") and gearval:FindFirstChildWhichIsA("Tool"):FindFirstChild("Handle")
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = old
                local gear = gearval:FindFirstChildWhichIsA("Tool")
                gear:FindFirstChild("Handle").CFrame = p.Character:FindFirstChild("HumanoidRootPart").CFrame
                p.Character.ChildAdded:Wait()
                gear.Parent = p.Backpack
                gearval:Destroy()
            end
        end
        if args[3] then
            for i = 1, args[3] do
                getitem()
            end
        else
            getitem()
        end
    end)
    end
--// Commands
addcmd("cmds", function()
    if target == p then
        cmdlist.Visible = true
    end
end)
addcmd("stopadmin", function()
    if gui then
        gui:Destroy()
        for i,v in pairs(guicons) do
            v:Disconnect()
        end
    end
    for i,v in pairs(connected) do
        v:Disconnect()
    end
end)
addcmd("info", function()
    task.wait(0.1)
    for i,v in pairs(Admin.Info) do
        chat(v)
        task.wait(0.1)
    end
end)
addcmd("prefix", function()
    prefix = args[2]
end)
addcmd("cmdbarprefix", function()
    guiprefix = args[2]
end)
addcmd("admin", function()
    if speaker == p then
        if type(target) == "table" then
            for i,v in pairs(target) do
                if not table.find(whitelisted,v) then
                    table.insert(whitelisted,v)
                end
            end
        else
            if not table.find(whitelisted,target) then
                table.insert(whitelisted,target)
            end
        end
    end
end)
addcmd("unadmin", function()
    if speaker == p then
        if type(target) == "table" then
            for i,v in pairs(target) do
                if v ~= p then
                    if table.find(whitelisted,v) then
                        table.remove(whitelisted,table.find(whitelisted,v))
                    end
                end
            end
        else
            if target ~= p then
                if table.find(whitelisted,target) then
                    table.remove(whitelisted,table.find(whitelisted,target))
                end
            end
        end
    end
end)
addcmd("rj", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
end)
addcmd("to", function()
    if type(target) == "table" then
        for i,target in pairs(target) do
            breakvel(p.Character:FindFirstChild("HumanoidRootPart"))
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
        end
    else
        breakvel(p.Character:FindFirstChild("HumanoidRootPart"))
        p.Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
    end
end)
local noclippedtab = {}
addcmd("noclip", function()
    table.insert(noclippedtab, game:GetService("RunService").Stepped:Connect(function()
        local t = target
        for i,v in pairs(target.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end))
end)
addcmd("clip", function()
    for i,v in pairs(noclippedtab) do
        v:Disconnect()
    end
end)
addcmd("hipheight", function()
    p.Character:FindFirstChild("Humanoid").HipHeight = args[2]
end)

addcmd("jumppower", function()
    p.Character:FindFirstChild("Humanoid").JumpPower = args[2]
end)
addcmd("speed", function()
    p.Character:FindFirstChild("Humanoid").WalkSpeed = args[2]
end)
addcmd("equiptools", function()
    for i,v in pairs(p.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            p.Character:FindFirstChild("Humanoid"):EquipTool(v)
        end
    end
end)
local netlagtab = {}
addcmd("netlag", function()
    table.insert(netlagtab, game:GetService("RunService").Heartbeat:Connect(function()
        for i,v in pairs(target.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                sethiddenproperty(v, "NetworkIsSleeping", true)
            end
        end
    end))
end)
addcmd("unnetlag", function()
    for i,v in pairs(netlagtab) do
        v:Disconnect()
    end
end)
addcmd("loopflingall", function()
    game:GetService("Workspace").FallenPartsDestroyHeight = tonumber("nan")
    local function flung(plr)
        if plr.Character and plr.Character.PrimaryPart then
            if
                plr.Character.PrimaryPart.Velocity.X >= 100 or plr.Character.PrimaryPart.Velocity.Y >= 100 or
                    plr.Character.PrimaryPart.Velocity.Z >= 100
             then
                return true
            else
                return false
            end
        end
    end
    local stay = Instance.new("BodyVelocity")
    stay.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    stay.P = math.huge
    stay.Velocity = Vector3.new(0, 0, 0)
    local c = game.Players.LocalPlayer.Character
    c.Archivable = true
    local clone = c:Clone()
    clone.Parent = game:GetService("Workspace")
    clone.PrimaryPart.Anchored = true
    for i, v in pairs(clone:GetDescendants()) do
        if
            (pcall(
                function()
                    return v.Transparency
                end
            ))
         then
            v.Transparency = 1
        end
    end
    for i, v in pairs(clone:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
    c:FindFirstChild("HumanoidRootPart").CFrame =
        c:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(9999, 9999, 9999)
    for i, v in pairs(c:GetDescendants()) do
        if v:IsA("BasePart") then
            stay:Clone().Parent = v
        end
    end
    for i, v in pairs(c.Humanoid:GetChildren()) do
        if v:IsA("NumberValue") then
            for i, v1 in pairs(c:GetChildren()) do
                if v1:FindFirstChild("AvatarPartScaleType", true) then
                    repeat
                        wait()
                    until v1:FindFirstChild("OriginalSize", true)
                    v1:FindFirstChild("OriginalSize", true):Destroy()
                    v:Destroy()
                end
            end
        end
    end
    --DROP ALL ACCESSORIES IN R6 AND R15 BY ShownApe#7272
    local block = false
    
    local character = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Character = nil
    game.Players.LocalPlayer.Character = character
    wait(game.Players.RespawnTime + 0.05)
    game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v.Name == "Torso" or v.Name == "UpperTorso" then
            v:Destroy()
        end
    end
    
    character.HumanoidRootPart:Destroy()
    
    for i, v in pairs(character:GetChildren()) do
        if v:IsA("Accessory") then
            sethiddenproperty(v, "BackendAccoutrementState", 0) --any integer 0-3 works but 4, as 4 is the default state for in character, 0 is for when it has collision in character or other circumstances, 2 is workspace, 1 is unknown if you know or figure out please let me know
        --BackendAccoutrementState is a replicated property similar to NetworkIsSleeping and is further documented in reweld
        end
    end
    
    if block == true then
        for i, v in pairs(character:GetDescendants()) do
            if v:IsA("SpecialMesh") then
                v:Destroy()
            end
        end
    end
    character:FindFirstChild("Body Colors"):Destroy()
    game:GetService("Workspace").CurrentCamera.CameraSubject = clone:FindFirstChild("Humanoid")
    local stoploop = false
    coroutine.wrap(
        function()
            while true do
                if stoploop == true then
                    break
                end
                for i, v in pairs(game.Players:GetPlayers()) do
                    if
                        v ~= game:GetService("Players").LocalPlayer and v.Character and
                            v.Character:FindFirstChild("HumanoidRootPart") and
                            not flung(v)
                     then
                        for i, v1 in pairs(c:GetDescendants()) do
                            if v1:IsA("BasePart") then
                                v1.Velocity = Vector3.new(0, 100, 0)
                                v1.RotVelocity = Vector3.new(9e11, 9e11, 9e11)
                                v1.Position = v.Character:FindFirstChild("HumanoidRootPart").Position
                            end
                        end
                        game:GetService("RunService").Heartbeat:Wait()
                    elseif clone and clone:FindFirstChild("HumanoidRootPart") then
                        for i, v1 in pairs(c:GetDescendants()) do
                            if v1:IsA("BasePart") then
                                v1.Velocity = Vector3.new(0, 100, 0)
                                v1.RotVelocity = Vector3.new()
                                v1.Rotation = Vector3.new()
                                v1.Orientation = Vector3.new()
                                v1.Position = clone:FindFirstChild("HumanoidRootPart").Position
                            end
                        end
                        game:GetService("RunService").Heartbeat:Wait()
                    end
                end
            end
        end
    )()
    local resetBindable = Instance.new("BindableEvent")
    local connection2
    connection2 =
        resetBindable.Event:connect(
        function()
            clone:Destroy()
            local stoploop = true
            connection2:Disconnect()
            c:FindFirstChild("Humanoid"):Destroy()
            resetBindable:Destroy()
            game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
            game:GetService("StarterGui"):SetCore(
                "SendNotification",
                {
                    Title = "Information",
                    Text = "Wait approximately " .. game:GetService("Players").RespawnTime .. " seconds to fully respawn."
                }
            )
        end
    )
    game:GetService("StarterGui"):SetCore("ResetButtonCallback", resetBindable)    
end)
addcmd("toolflingall", function()
    local c = p.Character
    local function flung(plr)
        if plr.Character and plr.Character.PrimaryPart then
            if plr.Character.PrimaryPart.Velocity.X >= 100 or plr.Character.PrimaryPart.Velocity.Y >= 100 or plr.Character.PrimaryPart.Velocity.Z >= 100 then
                return true
            else
                return false
            end
        end
    end
    for i, v in pairs(p.Character:GetChildren()) do
        if v:IsA("Tool") then
            v.Parent = p.Backpack
        end
    end
    for i, v in pairs(p.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            v.Parent = c
            v.Parent = game:GetService("Workspace")
            firetouchinterest(v:FindFirstChild("Handle"), c:FindFirstChild("HumanoidRootPart"), 0)
            firetouchinterest(v:FindFirstChild("Handle"), c:FindFirstChild("HumanoidRootPart"), 1)
            c.ChildAdded:wait()
            task.wait()
            for i, v in pairs(c:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = p.Backpack
                    v.Parent = c
                    v.Parent = c:FindFirstChild("Humanoid")
                    v.Parent = p.Backpack
                    v.Parent = c:FindFirstChild("Humanoid")
                    if v:FindFirstChild("Handle") then
                        v:FindFirstChild("Handle").CFrame = c:FindFirstChild("HumanoidRootPart").CFrame
                        if v:FindFirstChild("Handle"):FindFirstChild("TouchInterest") then
                            v:FindFirstChild("Handle"):FindFirstChild("TouchInterest"):Destroy()
                        else
                            repeat task.wait() until v:FindFirstChild("Handle") and v:FindFirstChild("Handle"):FindFirstChild("TouchInterest")
                            v:FindFirstChild("Handle"):FindFirstChild("TouchInterest"):Destroy()
                        end
                    end
                end
            end
        end
    end
    
    for i, v in pairs(c:FindFirstChild("Humanoid"):GetChildren()) do
        if v:IsA("Tool") then
            for i, vprt in pairs(v:GetChildren()) do
                if vprt:IsA("BasePart") then
                    vprt:BreakJoints()
                    coroutine.wrap(function()
                        while true do
                            for i, pr in pairs(game.Players:GetChildren()) do
                                if not v.Parent == c or v.Parent == p.Backpack then
                                    break
                                end
                                if pr ~= p and pr and pr.Character and pr.Character:FindFirstChild("HumanoidRootPart") and not pr.Character:FindFirstChild("HumanoidRootPart"):IsGrounded() and not flung(pr) then
                                    vprt.CanCollide = false
                                    vprt.Velocity = Vector3.new(50,0,0)
                                    vprt.CFrame = pr.Character:FindFirstChild("HumanoidRootPart").CFrame
                                    vprt.RotVelocity = Vector3.new(9e11,9e11,9e11)
                                else
                                    vprt.CanCollide = false
                                    vprt.Velocity = Vector3.new(50,0,0)
                                    vprt.CFrame = c:FindFirstChild("HumanoidRootPart").CFrame
                                    vprt.RotVelocity = Vector3.new()
                                end
                                game:GetService("RunService").Heartbeat:Wait()
                            end
                        end
                    end)()
                end
            end
        end
    end
end)
addcmd("jump", function()
    local oldpos = p.Character:FindFirstChild("HumanoidRootPart").CFrame
    if type(target) == "table" then
        for i,v in pairs(target) do
            local jump = true
            coroutine.wrap(function()
                while jump do
                    for i,v in pairs(p.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                    game:GetService("RunService").Stepped:Wait()
                end
            end)()
            local tp = true
            coroutine.wrap(function()
                while tp do
                    p.Character:FindFirstChild("HumanoidRootPart").CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,-4,0)
                   game:GetService("RunService").RenderStepped:Wait()
                end
            end)()
            wait()
            tp = false
            p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0,54,0)
            repeat task.wait() until p.Character:FindFirstChild("HumanoidRootPart").Velocity.Y < 4
            jump = false
            for i = 1, 1000 do
                p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new()
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = oldpos + Vector3.new(0,-50,0)
            end
        end
        for i = 1, 1000 do
            p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new()
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = oldpos
        end
    else
        local jump = true
        coroutine.wrap(function()
            while jump do
                for i,v in pairs(p.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
                game:GetService("RunService").Stepped:Wait()
            end
        end)()
        local tp = true
        coroutine.wrap(function()
            while tp do
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,-4,0)
               game:GetService("RunService").RenderStepped:Wait()
            end
        end)()
        wait()
        tp = false
        p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0,54,0)
        repeat task.wait() until p.Character:FindFirstChild("HumanoidRootPart").Velocity.Y < 4
        jump = false
        for i = 1, 1000 do
            p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new()
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = oldpos
        end
    end
end)
addcmd("fling", function()
    local oldpos = p.Character:FindFirstChild("HumanoidRootPart").CFrame
    local fpdh = game:GetService("Workspace").FallenPartsDestroyHeight
    game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
    if type(target) == "table" then
        for i,v in pairs(target) do
            if v.Character:FindFirstChild("HumanoidRootPart") and not v.Character:FindFirstChild("HumanoidRootPart"):IsGrounded() then
                local fling = true
                coroutine.wrap(function()
                    while fling do
                        for i,v in pairs(p.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                        game:GetService("RunService").Stepped:Wait()
                    end
                end)()
                local tp = true
                local flinging = true
                coroutine.wrap(function()
                    while tp do
                        p.Character:FindFirstChild("HumanoidRootPart").CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,-10,0)
                        p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0,10e5,0)
                        game:GetService("RunService").Heartbeat:Wait()
                        p.Character:FindFirstChild("HumanoidRootPart").CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,10,0)
                        p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0,10e5,0)
                        game:GetService("RunService").Heartbeat:Wait()
                    end
                end)()
                coroutine.wrap(function()
                    wait(0.5)
                    flinging = false
                end)()
                repeat task.wait() until v.Character:FindFirstChild("HumanoidRootPart").Velocity.Y > 100 or not flinging
                tp = false
                fling = false
                for i,v in pairs(p.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Velocity = Vector3.new()
                        v.RotVelocity = Vector3.new()
                        stay:Clone().Parent = v
                    end
                end
                p.Character:FindFirstChild("Humanoid"):ChangeState(8)
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = oldpos
                task.wait()
                for i,v in pairs(p.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Velocity = Vector3.new()
                        v.RotVelocity = Vector3.new()
                        v:FindFirstChild(stay.Name):Destroy()
                    end
                end
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = oldpos
            end
        end
    else
        if target.Character:FindFirstChild("HumanoidRootPart") and not target.Character:FindFirstChild("HumanoidRootPart"):IsGrounded() then
            local fling = true
            coroutine.wrap(function()
                while fling do
                    for i,v in pairs(p.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                    game:GetService("RunService").Stepped:Wait()
                end
            end)()
            local tp = true
            local flinging = true
            coroutine.wrap(function()
                while tp do
                    p.Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,-10,0) + target.Character:FindFirstChild("HumanoidRootPart").Velocity / 1.75
                    p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0,10e5,0)
                    game:GetService("RunService").Heartbeat:Wait()
                    p.Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,10,0) + target.Character:FindFirstChild("HumanoidRootPart").Velocity / 1.75
                    p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0,10e5,0)
                    game:GetService("RunService").Heartbeat:Wait()
                end
            end)()
            coroutine.wrap(function()
                wait(0.5)
                flinging = false
            end)()
            repeat task.wait() until target.Character:FindFirstChild("HumanoidRootPart").Velocity.Y > 100 or not flinging
            tp = false
            fling = false
            breakvel(p.Character:FindFirstChild("HumanoidRootPart"))
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = oldpos
        end
    end
    game:GetService("Workspace").FallenPartsDestroyHeight = fpdh
end)
addcmd("re", function()
    replacechar()
    p.Character:FindFirstChild("Humanoid").BreakJointsOnDeath = false
    p.Character:FindFirstChild("Humanoid").RequiresNeck = false
    task.wait(game:GetService("Players").RespawnTime - 0.05)
    p.Character:FindFirstChild("HumanoidRootPart").Anchored = true
    local old = p.Character:FindFirstChild("HumanoidRootPart").CFrame
    p.Character:FindFirstChild("Humanoid").BreakJointsOnDeath = false
    p.Character:FindFirstChild("Humanoid").RequiresNeck = false
    p.Character:FindFirstChild("Neck", true):Destroy()
    p.CharacterAdded:Wait()
    p.Character:WaitForChild("HumanoidRootPart").CFrame = old
end)
addcmd("dupe", function()
    local dupedtools = {}
    if args[2] then
        local fpdh = game:GetService("Workspace").FallenPartsDestroyHeight
        game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
        for i = 1, args[2] do
            p.Character:WaitForChild("Humanoid").BreakJointsOnDeath = false
            p.Character:WaitForChild("Humanoid").RequiresNeck = false
            replacehum()
            task.wait(0.5)
            p.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(math.huge,math.huge,math.huge)
            task.wait(0.5)
            for i,v in pairs(p.Backpack:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = p.Character
                end
            end
            task.wait()
            for i,v in pairs(p.Character:GetChildren()) do
                if v:IsA("Tool") then
                    table.insert(dupedtools, v)
                    v.Parent = game:GetService("Workspace")
                end
            end
            p.CharacterAdded:Wait()
            p.Character:WaitForChild("HumanoidRootPart")
            p.Character:WaitForChild("Humanoid")
        end
        for i,v in pairs(dupedtools) do
            if v.Parent == game:GetService("Workspace") then
                if true then
                    firetouchinterest(v:FindFirstChild("Handle"), p.Character:FindFirstChild("HumanoidRootPart"), 0)
                    firetouchinterest(v:FindFirstChild("Handle"), p.Character:FindFirstChild("HumanoidRootPart"), 1)
                else
                    repeat
                        v:FindFirstChild("Handle").CFrame = p.Character:FindFirstChild("HumanoidRootPart").CFrame
                        game:GetService("RunService").Heartbeat:Wait()
                    until v.Parent ~= game:GetService("Workspace")
                end
            end
        end
        task.wait(0.5)
        game:GetService("Workspace").FallenPartsDestroyHeight = fpdh
    end
end)
addcmd("punish", function()
    if type(target) == "table" then
        local old = p.Character:FindFirstChild("HumanoidRootPart").CFrame
        local fpdh = game:GetService("Workspace").FallenPartsDestroyHeight
        game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
        for i,target in pairs(target) do
            if target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("HumanoidRootPart") then
                local attachtool = p.Character:FindFirstChildWhichIsA("Tool") or p.Backpack:FindFirstChildWhichIsA("Tool")
                attachtool.Parent = p.Backpack
                replacehum()
                attachtool.Parent = p.Character
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(Vector3.new(-100000, 1000000000000000000000, -100000))
                attachtool:FindFirstChild("Handle").ChildAdded:Wait()
                if true then
                    firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),0)
                    firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),1)
                    repeat task.wait() until attachtool.Parent == target.Character or target.Character:FindFirstChild("Humanoid").Health == 0 or target.Character.Parent ~= game:GetService("Workspace")
                else
                    repeat
                        target.Character:FindFirstChild("HumanoidRootPart").CFrame = attachtool:FindFirstChild("Handle").CFrame
                        game:GetService("RunService").Heartbeat:Wait()
                    until attachtool.Parent == target.Character or target.Character:FindFirstChild("Humanoid").Health == 0 or target.Character.Parent ~= game:GetService("Workspace")
                end
                breakvel(p.Character:FindFirstChild("HumanoidRootPart"))
            end
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = old
            superwait()
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = old
            game:GetService("Workspace").FallenPartsDestroyHeight = fpdh
        end
    else
        local old = p.Character:FindFirstChild("HumanoidRootPart").CFrame
        local fpdh = game:GetService("Workspace").FallenPartsDestroyHeight
        game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
        local attachtool = p.Character:FindFirstChildWhichIsA("Tool") or p.Backpack:FindFirstChildWhichIsA("Tool")
        attachtool.Parent = p.Backpack
        replacehum()
        attachtool.Parent = p.Character
        attachtool:FindFirstChild("Handle").ChildAdded:Wait()
        if true then
            firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),0)
            firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),1)
            repeat task.wait() until attachtool.Parent == target.Character or target.Character:FindFirstChild("Humanoid").Health == 0 or target.Character.Parent ~= game:GetService("Workspace")
        else
            repeat
                target.Character:FindFirstChild("HumanoidRootPart").CFrame = attachtool:FindFirstChild("Handle").CFrame
                game:GetService("RunService").Heartbeat:Wait()
            until attachtool.Parent == target.Character or target.Character:FindFirstChild("Humanoid").Health == 0 or target.Character.Parent ~= game:GetService("Workspace")
        end
        p.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(Vector3.new(-100000, 1000000000000000000000, -100000))
        task.wait(0.5)
        destroyrg()
        p.Character:WaitForChild("HumanoidRootPart")
        breakvel(p.Character:FindFirstChild("HumanoidRootPart"))
        p.Character:FindFirstChild("HumanoidRootPart").CFrame = old
        game:GetService("Workspace").FallenPartsDestroyHeight = fpdh
    end
end)
addcmd("void", function()
    if type(target) == "table" then
        local old = p.Character:FindFirstChild("HumanoidRootPart").CFrame
        local fpdh = game:GetService("Workspace").FallenPartsDestroyHeight
        game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
        for i,target in pairs(target) do
            if target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("HumanoidRootPart") then
                local attachtool = p.Character:FindFirstChildWhichIsA("Tool") or p.Backpack:FindFirstChildWhichIsA("Tool")
                attachtool.Parent = p.Backpack
                replacehum()
                attachtool.Parent = p.Character
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(math.huge,math.huge,math.huge)
                attachtool:FindFirstChild("Handle").ChildAdded:Wait()
                if true then
                    firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),0)
                    firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),1)
                    repeat task.wait() until attachtool.Parent == target.Character or target.Character:FindFirstChild("Humanoid").Health == 0 or target.Character.Parent ~= game:GetService("Workspace")
                else
                    repeat
                        target.Character:FindFirstChild("HumanoidRootPart").CFrame = attachtool:FindFirstChild("Handle").CFrame
                        game:GetService("RunService").Heartbeat:Wait()
                    until attachtool.Parent == target.Character or target.Character:FindFirstChild("Humanoid").Health == 0 or target.Character.Parent ~= game:GetService("Workspace")
                end
                breakvel(p.Character:FindFirstChild("HumanoidRootPart"))
            end
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = old
            superwait()
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = old
            game:GetService("Workspace").FallenPartsDestroyHeight = fpdh
        end
    else
        local old = p.Character:FindFirstChild("HumanoidRootPart").CFrame
        local fpdh = game:GetService("Workspace").FallenPartsDestroyHeight
        local fw
        game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
        p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0,-10e30,0)
        local attachtool = p.Character:FindFirstChildWhichIsA("Tool") or p.Backpack:FindFirstChildWhichIsA("Tool")
        attachtool.Parent = p.Backpack
        replacehum()
        attachtool.Parent = p.Character
        wait()
        if true then
            firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),0)
            firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),1)
        else
            repeat
                target.Character:FindFirstChild("HumanoidRootPart").CFrame = attachtool:FindFirstChild("Handle").CFrame
                game:GetService("RunService").Heartbeat:Wait()
            until attachtool.Parent == target.Character or target.Character:FindFirstChild("Humanoid").Health == 0 or target.Character.Parent ~= game:GetService("Workspace")
        end
        task.wait(0.5)
        game:GetService("Workspace").FallenPartsDestroyHeight = fpdh
    end
end)
addcmd("kick", function()
    local old = p.Character:FindFirstChild("HumanoidRootPart").CFrame
    local fpdh = game:GetService("Workspace").FallenPartsDestroyHeight
    game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
    if target.Character:FindFirstChild("HumanoidRootPart") and not target.Character:FindFirstChild("HumanoidRootPart"):IsGrounded() then
        local fling = true
        coroutine.wrap(function()
            while fling do
                for i,v in pairs(p.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
                game:GetService("RunService").Stepped:Wait()
            end
        end)()
        local tp = true
        local flinging = true
        coroutine.wrap(function()
            while tp do
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,-10,0) + target.Character:FindFirstChild("HumanoidRootPart").Velocity / 1.75
                p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0,10e5,0)
                game:GetService("RunService").Heartbeat:Wait()
                p.Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,10,0) + target.Character:FindFirstChild("HumanoidRootPart").Velocity / 1.75
                p.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0,10e5,0)
                game:GetService("RunService").Heartbeat:Wait()
            end
        end)()
        coroutine.wrap(function()
            wait(0.5)
            flinging = false
        end)()
        repeat task.wait() until target.Character:FindFirstChild("HumanoidRootPart").Velocity.Y > 100 or not flinging
        tp = false
        fling = false
        breakvel(p.Character:FindFirstChild("HumanoidRootPart"))
        p.Character:FindFirstChild("HumanoidRootPart").CFrame = old
    end
    local kicktp = true
    coroutine.wrap(function()
        while kicktp do
            for i,v in pairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Velocity = Vector3.new()
                    v.RotVelocity = Vector3.new()
                end
            end
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
            task.wait()
        end
    end)()
    task.wait(2)
    kicktp = false
    local c = p.Character
    for i,v in pairs(c:GetDescendants()) do
        if v:IsA("BaseWrap") and v.Parent.Name == "Handle" then
            v.Parent.Parent:Destroy()
        end
    end
    for i,v in pairs(c:GetDescendants()) do
        if v:IsA("Motor") and v.Name ~= "Neck" then
            local par = v.Parent
            v:Destroy()
            par.CFrame = CFrame.new(10e11*i,1000,10e11*i)
            par.Velocity = Vector3.new(1e36*i,1000,1e36*i)
           task.wait()
        end
    end
    p.CharacterAdded:Wait()
    p.Character:WaitForChild("HumanoidRootPart")
    breakvel(p.Character:FindFirstChild("HumanoidRootPart"))
    p.Character:FindFirstChild("HumanoidRootPart").CFrame = old
    game:GetService("Workspace").FallenPartsDestroyHeight = fpdh
end)
addcmd("tkick", function()
    local old = p.Character:FindFirstChild("HumanoidRootPart").CFrame
    local fpdh = game:GetService("Workspace").FallenPartsDestroyHeight
    local tkickcf = CFrame.new(old.Position.X+1000000,old.Position.Y+100000,old.Position.Z+1000000)
    replacechar()
    task.wait(players.RespawnTime - 0.5)
    game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
    local attachtool = p.Character:FindFirstChildWhichIsA("Tool") or p.Backpack:FindFirstChildWhichIsA("Tool")
    attachtool.Parent = p.Backpack
    replacehum()
    attachtool.Parent = p.Character
    attachtool:FindFirstChild("Handle").ChildAdded:Wait()
    if true then
        firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),0)
        firetouchinterest(target.Character:FindFirstChild("HumanoidRootPart"),attachtool:FindFirstChild("Handle"),1)
        repeat task.wait() until attachtool.Parent == target.Character or target.Character:FindFirstChild("Humanoid").Health == 0 or target.Character.Parent ~= game:GetService("Workspace")
    else
        repeat
            target.Character:FindFirstChild("HumanoidRootPart").CFrame = attachtool:FindFirstChild("Handle").CFrame
            game:GetService("RunService").Heartbeat:Wait()
        until attachtool.Parent == target.Character or target.Character:FindFirstChild("Humanoid").Health == 0 or target.Character.Parent ~= game:GetService("Workspace")
    end
    p.Character:FindFirstChild("HumanoidRootPart").CFrame = tkickcf
    p.CharacterAdded:Wait()
    local c = p.Character
    local function findbasewrap()
        for i,v in pairs(c:GetDescendants()) do
            if v:IsA("BaseWrap") and v.Parent.Name == "Handle" then
                return true
            end
        end
    end
    repeat task.wait() until findbasewrap()
    task.wait(0.3)
    local tkicktp = true
    coroutine.wrap(function()
        while tkicktp do
            p.Character:FindFirstChild("HumanoidRootPart").CFrame = tkickcf
            task.wait()
        end
    end)()
    task.wait(0.5)
    tkicktp = false
    for i,v in pairs(c:GetDescendants()) do
        if v:IsA("BaseWrap") and v.Parent.Name == "Handle" then
            v.Parent.Parent:Destroy()
        end
    end
    for i,v in pairs(c:GetDescendants()) do
        if v:IsA("Motor") and v.Name ~= "Neck" then
            local par = v.Parent
            v:Destroy()
            par.CFrame = CFrame.new(old.Position.X+10e11,old.Position.Y+1000,old.Position.Z+10e11)
            par.Velocity = Vector3.new(10e11*i,1000,10e11*i)
           task.wait()
        end
    end
    task.wait(1)
    if c.Humanoid:FindFirstChild("BodyTypeScale") then
        c.Humanoid.BodyTypeScale:Remove()
        elseif c.Humanoid:FindFirstChild("BodyWidthScale") then
        c.Humanoid.BodyWidthScale:Remove()
        elseif c.Humanoid:FindFirstChild("BodyHeightScale") then
        c.Humanoid.BodyHeightScale:Remove()
        elseif c.Humanoid:FindFirstChild("BodyDepthScale") then
        c.Humanoid.BodyDepthScale:Remove()
        elseif c.Humanoid:FindFirstChild("HeadScale") then
        c.Humanoid.HeadScale:Remove()
    end
    breakvel(p.Character:FindFirstChild("HumanoidRootPart"))
    p.Character:FindFirstChild("HumanoidRootPart").CFrame = old
    game:GetService("Workspace").FallenPartsDestroyHeight = fpdh
end)
addcmd("crash", function()
    local c = p.Character
    for i,v in pairs(c:GetDescendants()) do
        if v:IsA("BaseWrap") and v.Parent.Name == "Handle" then
            v.Parent.Parent:Destroy()
        end
    end
    for i,v in pairs(c:GetDescendants()) do
        if v:IsA("Motor") and v.Name ~= "Neck" then
            local par = v.Parent
            v:Destroy()
            par.CFrame = CFrame.new(10e11*i,1000,10e11*i)
            par.Velocity = Vector3.new(1e36*i,1000,1e36*i)
           task.wait()
        end
    end
end)
local view
local viewing
addcmd("view", function()
    viewing = true
    if ws.CurrentCamera.CameraSubject:IsDescendantOf(ws) then
        view = ws.CurrentCamera.CameraSubject
    else
        view = p.Character:FindFirstChild("Humanoid")
    end
    ws.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
    coroutine.wrap(function()
        while viewing do
            ws.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Wait()
            if not target.Character and not target.Character:FindFirstChild("Humanoid") then
                repeat task.wait() until target.Character and target.Character:FindFirstChild("Humanoid")
            end
            ws.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
        end
    end)()
end)
addcmd("unview", function()
    viewing = false
    ws.CurrentCamera.CameraSubject = view or p.Character:FindFirstChild("Humanoid")
end)
addcmd("fly", function()
    NOFLY()
	sFLY()
    if args[2] and tonumber(args[2]) then
	    flyspeed = tonumber(args[2])
    end
end)
addcmd("flyspeed", function()
    local speed = args[2] or 1
	if tonumber(speed) then
		flyspeed = tonumber(speed)
	end
end)
addcmd("unfly", function()
    NOFLY()
end)
