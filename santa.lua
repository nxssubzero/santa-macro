local plr = game.Players.LocalPlayer
local pg = plr:WaitForChild("PlayerGui")

for _, gui in pairs(pg:GetChildren()) do
    if gui.Name == "SantaGui" then
        gui:Destroy()
    end
end

if getgenv().v9running then
    getgenv().v9daddy = false
    task.wait(0.5)
end
getgenv().v9running = true

local function savecount(c)
    writefile("santa_count.txt", tostring(c))
end

local function loadcount()
    if isfile("santa_count.txt") then
        return tonumber(readfile("santa_count.txt")) or 0
    end
    return 0
end

local sg = Instance.new("ScreenGui")
sg.Name = "SantaGui"
local f = Instance.new("Frame")
local t = Instance.new("TextLabel")
local btn = Instance.new("TextButton")
local savebtn = Instance.new("TextButton")
local status = Instance.new("TextLabel")
local uptime = Instance.new("TextLabel")
local c1 = Instance.new("UICorner")
local c2 = Instance.new("UICorner")
local c3 = Instance.new("UICorner")
local c4 = Instance.new("UICorner")

sg.Parent = pg
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.ResetOnSpawn = false

f.Parent = sg
f.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
f.BorderSizePixel = 0
f.Position = UDim2.new(0.4, 0, 0.3, 0)
f.Size = UDim2.new(0, 280, 0, 185)
f.Active = true
f.Draggable = true

c1.Parent = f
c1.CornerRadius = UDim.new(0, 8)

t.Parent = f
t.BackgroundTransparency = 1
t.Size = UDim2.new(1, 0, 0, 35)
t.Font = Enum.Font.GothamBold
t.Text = "Santa Farm"
t.TextColor3 = Color3.fromRGB(255, 255, 255)
t.TextSize = 16

btn.Parent = f
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.BorderSizePixel = 0
btn.Position = UDim2.new(0.1, 0, 0.28, 0)
btn.Size = UDim2.new(0.8, 0, 0, 35)
btn.Font = Enum.Font.GothamBold
btn.Text = "Start"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 14

c2.Parent = btn
c2.CornerRadius = UDim.new(0, 6)

savebtn.Parent = f
savebtn.BackgroundColor3 = Color3.fromRGB(60, 120, 160)
savebtn.BorderSizePixel = 0
savebtn.Position = UDim2.new(0.1, 0, 0.55, 0)
savebtn.Size = UDim2.new(0.8, 0, 0, 35)
savebtn.Font = Enum.Font.GothamBold
savebtn.Text = "Save Pos"
savebtn.TextColor3 = Color3.fromRGB(255, 255, 255)
savebtn.TextSize = 13

c3.Parent = savebtn
c3.CornerRadius = UDim.new(0, 6)

status.Parent = f
status.BackgroundTransparency = 1
status.Position = UDim2.new(0, 0, 0.73, 0)
status.Size = UDim2.new(1, 0, 0, 20)
status.Font = Enum.Font.Gotham
status.Text = "Total: 0 | Pos: not saved | Timer: 60s"
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.TextSize = 11

uptime.Parent = f
uptime.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
uptime.BorderSizePixel = 0
uptime.Position = UDim2.new(0.1, 0, 0.87, 0)
uptime.Size = UDim2.new(0.8, 0, 0, 20)
uptime.Font = Enum.Font.GothamBold
uptime.Text = "uptime: 00:00:00"
uptime.TextColor3 = Color3.fromRGB(100, 200, 255)
uptime.TextSize = 11

c4.Parent = uptime
c4.CornerRadius = UDim.new(0, 4)

getgenv().v9daddy = false
local vim = Instance.new("VirtualInputManager")
local pps = game:GetService("ProximityPromptService")
local uis = game:GetService("UserInputService")
local count = loadcount()
local busy = false
local savedpos = nil
local cam = workspace.CurrentCamera
local timer = false
local timerem = 0
local collecting = false
local init = false
local start = os.time()
local loop
local connections = {}

local function getSanta()
    local npcs = workspace:FindFirstChild("NPCs")
    if npcs then
        local sleigh = npcs:FindFirstChild("Santa's Sleigh")
        if sleigh then
            local deer = sleigh:FindFirstChild("Deer")
            if deer then
                return deer:FindFirstChild("Body.006")
            end
        end
    end
    return nil
end

local santa = getSanta()
if not santa then
    warn("Santa not found!")
    return
end

local function fmttime(s)
    local h = math.floor(s / 3600)
    local m = math.floor((s % 3600) / 60)
    local sec = s % 60
    return string.format("%02d:%02d:%02d", h, m, sec)
end

task.spawn(function()
    while true do
        task.wait(1)
        local ut = os.time() - start
        uptime.Text = "uptime: " .. fmttime(ut)
    end
end)

savebtn.MouseButton1Click:Connect(function()
    local hrp = plr.Character.HumanoidRootPart
    savedpos = hrp.CFrame
    status.Text = "Total: " .. count .. " | Pos: saved! | Timer: " .. timerem .. "s"
    savebtn.BackgroundColor3 = Color3.fromRGB(50, 160, 50)
    task.wait(0.5)
    savebtn.BackgroundColor3 = Color3.fromRGB(60, 120, 160)
end)

local function startm1()
    task.spawn(function()
        while getgenv().v9daddy and not collecting do
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.1)
        end
    end)
end

local function stopm1()
    vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

local function updatestatus()
    status.Text = "total: " .. count .. (savedpos and " | pos: saved" or " | pos: not saved") .. " | timer: " .. timerem .. "s"
end

local function checkspecial()
    local notif = pg:FindFirstChild("Notifications")
    if notif then
        local frame = notif:FindFirstChild("Frame")
        if frame then
            for _, grp in pairs(frame:GetChildren()) do
                if grp:IsA("Frame") or grp.Name:find("Group") then
                    local txt = ""
                    for _, d in pairs(grp:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Visible then
                            local t = d.Text or ""
                            if t ~= "" then
                                txt = txt .. " " .. t
                            end
                        end
                    end
                    local low = txt:lower()
                    if low:find("race") and low:find("reroll") then
                        return true, "race reroll - " .. txt
                    end
                    if low:find("new title") or low:find("new item") or low:find("unlocked") or low:find("obtained") or low:find("max capacity") then
                        return true, txt
                    end
                end
            end
        end
    end
    
    for _, gui in pairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, frame in pairs(gui:GetDescendants()) do
                if frame:IsA("Frame") and frame.Name:find("Group") then
                    local txt = ""
                    for _, d in pairs(frame:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Visible then
                            local t = d.Text or ""
                            if t ~= "" then
                                txt = txt .. " " .. t
                            end
                        end
                    end
                    local low = txt:lower()
                    if low:find("race") and low:find("reroll") then
                        return true, "race reroll - " .. txt
                    end
                    if low:find("new title") or low:find("new item") or low:find("unlocked") or low:find("obtained") or low:find("max capacity") then
                        return true, txt
                    end
                end
            end
        end
    end
    return false, nil
end

local function collectnearby()
    if not savedpos then return end
    collecting = true
    stopm1()
    task.wait(0.2)
    
    for sweep = 1, 2 do
        local presents = {}
        for _, p in pairs(workspace.Effects:GetChildren()) do
            if p.Name == "Present" and getgenv().v9daddy and p.Parent then
                local dist = (savedpos.Position - p.Position).Magnitude
                if dist <= 60 then
                    if p:FindFirstChild("ProximityPrompt") and p:FindFirstChild("ProximityPrompt").Enabled == true then
                        table.insert(presents, {present = p, distance = dist})
                    end
                end
            end
        end
        
        table.sort(presents, function(a, b)
            return a.distance < b.distance
        end)
        
        for _, data in ipairs(presents) do
            local p = data.present
            if getgenv().v9daddy and p.Parent then
                local cpos = cam.CFrame.Position
                cam.CFrame = CFrame.lookAt(cpos, p.Position)
                task.wait(0.1)
                
                local distToPresent = (plr.Character.HumanoidRootPart.Position - p.Position).Magnitude
                if distToPresent <= 20 then
                    plr.Character.HumanoidRootPart.CFrame = CFrame.new(p.Position)
                    task.wait(0.1)
                else
                    plr.Character.Humanoid:MoveTo(p.Position)
                    task.wait(0.35)
                end
                
                if p.Parent and p:FindFirstChild("ProximityPrompt") and p:FindFirstChild("ProximityPrompt").Enabled == true then
                    for i = 1, 6 do
                        if p.Parent and p:FindFirstChild("ProximityPrompt") and p:FindFirstChild("ProximityPrompt").Enabled == true then
                            fireproximityprompt(p.ProximityPrompt)
                            task.wait(0.1)
                        else
                            break
                        end
                    end
                end
                
                if savedpos and getgenv().v9daddy then
                    local distToSaved = (plr.Character.HumanoidRootPart.Position - savedpos.Position).Magnitude
                    if distToSaved <= 100 then
                        plr.Character.HumanoidRootPart.CFrame = savedpos
                        task.wait(0.1)
                    else
                        plr.Character.Humanoid:MoveTo(savedpos.Position)
                        task.wait(0.35)
                    end
                end
            end
        end
        
        if sweep < 2 then
            task.wait(0.5)
        end
    end
    
    task.wait(0.3)
    
    if savedpos and getgenv().v9daddy then
        local distToSaved = (plr.Character.HumanoidRootPart.Position - savedpos.Position).Magnitude
        if distToSaved <= 20 then
            plr.Character.HumanoidRootPart.CFrame = savedpos
            task.wait(0.1)
        else
            plr.Character.Humanoid:MoveTo(savedpos.Position)
            task.wait(0.35)
        end
    end
    
    local cpos = cam.CFrame.Position
    cam.CFrame = CFrame.lookAt(cpos, santa.Position)
    
    collecting = false
    if getgenv().v9daddy then
        startm1()
    end
end

local function starttimer()
    timer = true
    timerem = 60
    updatestatus()
    
    task.spawn(function()
        while timer and timerem > 0 and getgenv().v9daddy do
            task.wait(1)
            timerem = timerem - 1
            updatestatus()
        end
        
        if getgenv().v9daddy then
            timer = false
            busy = true
            collectnearby()
            busy = false
            if getgenv().v9daddy then
                task.wait(1)
                starttimer()
            end
        end
    end)
end

pps.PromptShown:Connect(function(p)
    if getgenv().v9daddy and not collecting then
        fireproximityprompt(p, 10)
    end
end)

local function sendhook(data)
    if getgenv().hook and getgenv().hook ~= "" then
        pcall(function()
            request({
                Url = getgenv().hook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = game:GetService("HttpService"):JSONEncode(data)
            })
        end)
    end
end

workspace.Effects.ChildRemoved:Connect(function(c)
    if c.Name == "Present" and getgenv().v9daddy then
        count += 1
        savecount(count)
        updatestatus()
        
        local special, msg = checkspecial()
        if special then
            local payload = {
                content = "@everyone",
                embeds = {{
                    title = "gpo - special drop!",
                    description = "gift wrapped special item detected",
                    type = "rich",
                    color = tonumber(0xFFD700),
                    fields = {
                        {name = "total wrapped:", value = count, inline = false},
                        {name = "item:", value = msg, inline = false}
                    },
                    footer = {icon_url = "", text = "santa farm (" .. os.date("%X") .. ")"}
                }}
            }
            sendhook(payload)
        end
    end
end)

workspace.Effects.ChildAdded:Connect(function(c)
    if not getgenv().v9daddy or timer or collecting then return end
    task.wait(0.1)
    if c.Name == "ChristmasGift" and c.Highlight.FillColor ~= Color3.fromRGB(109, 0, 0) then
        if busy then return end
        busy = true
        while c.Parent and c.Parent == workspace.Effects and getgenv().v9daddy and not timer and not collecting do
            if connections.moveConn then 
                connections.moveConn:Disconnect() 
            end
            
            plr.Character.Humanoid:MoveTo(c.Top.TopMiddle.Position)
            connections.moveConn = plr.Character.Humanoid.MoveToFinished:Connect(function()
                for _, p in pairs(workspace.Effects:GetChildren()) do
                    if p.Name == "Present" and p.Parent then
                        local dist = (plr.Character.HumanoidRootPart.Position - p.Position).Magnitude
                        if dist <= 50 then
                            if p:FindFirstChild("ProximityPrompt") and p:FindFirstChild("ProximityPrompt").Enabled == true then
                                fireproximityprompt(p.ProximityPrompt)
                            end
                        end
                        task.wait(0.35)
                    end
                end
            end)
            task.wait(1)
        end
        busy = false
        
        if savedpos and getgenv().v9daddy and not timer and not collecting then
            task.wait(0.2)
            plr.Character.Humanoid:MoveTo(savedpos.Position)
        end
    end
end)

local function collectclose()
    for _, p in pairs(workspace.Effects:GetChildren()) do
        if p.Name == "Present" and getgenv().v9daddy and p.Parent then
            if savedpos then
                local dist = (savedpos.Position - p.Position).Magnitude
                if dist <= 30 then
                    if p:FindFirstChild("ProximityPrompt") and p:FindFirstChild("ProximityPrompt").Enabled == true then
                        plr.Character.Humanoid:MoveTo(p.Position)
                        task.wait(0.35)
                        for i = 1, 3 do
                            if p.Parent and p:FindFirstChild("ProximityPrompt") and p:FindFirstChild("ProximityPrompt").Enabled == true then
                                fireproximityprompt(p.ProximityPrompt)
                                task.wait(0.15)
                            else
                                break
                            end
                        end
                        if savedpos and getgenv().v9daddy then
                            plr.Character.Humanoid:MoveTo(savedpos.Position)
                            task.wait(0.35)
                        end
                    end
                end
            end
        end
    end
    if savedpos and getgenv().v9daddy then
        plr.Character.Humanoid:MoveTo(savedpos.Position)
        task.wait(0.35)
    end
end

uis.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.C and not gp then
        getgenv().v9daddy = not getgenv().v9daddy
        
        if getgenv().v9daddy then
            btn.Text = "Stop"
            btn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
            
            if loop then task.cancel(loop) end
            loop = task.spawn(function()
                if not init then
                    init = true
                    vim:SendKeyEvent(true, Enum.KeyCode.I, false, game)
                    task.wait(0.1)
                    vim:SendKeyEvent(false, Enum.KeyCode.I, false, game)
                    task.wait(0.5)
                    vim:SendKeyEvent(true, Enum.KeyCode.O, false, game)
                    task.wait(0.1)
                    vim:SendKeyEvent(false, Enum.KeyCode.O, false, game)
                    task.wait(0.5)
                end
                
                if savedpos then
                    plr.Character.Humanoid:MoveTo(savedpos.Position)
                    plr.Character.Humanoid.MoveToFinished:Wait()
                    task.wait(0.3)
                end
                
                startm1()
                starttimer()
                task.wait(0.5)
                
                while getgenv().v9daddy do
                    task.wait(0.05)
                    
                    if not busy and not collecting then
                        local cpos = cam.CFrame.Position
                        cam.CFrame = CFrame.lookAt(cpos, santa.Position)
                    end
                end
                stopm1()
            end)
        else
            btn.Text = "Start"
            btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            stopm1()
            timer = false
            collecting = false
            if loop then
                task.cancel(loop)
                loop = nil
            end
        end
    end
end)

sg.Destroying:Connect(function()
    getgenv().v9daddy = false
    getgenv().v9running = false
    stopm1()
    timer = false
    
    for _, conn in pairs(connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    
    if loop then
        task.cancel(loop)
        loop = nil
    end
end)

btn.MouseButton1Click:Connect(function()
    getgenv().v9daddy = not getgenv().v9daddy
    
    if getgenv().v9daddy then
        btn.Text = "Stop"
        btn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        if loop then task.cancel(loop) end
        loop = task.spawn(function()
            if not init then
                init = true
                vim:SendKeyEvent(true, Enum.KeyCode.I, false, game)
                task.wait(0.1)
                vim:SendKeyEvent(false, Enum.KeyCode.I, false, game)
                task.wait(0.5)
                vim:SendKeyEvent(true, Enum.KeyCode.O, false, game)
                task.wait(0.1)
                vim:SendKeyEvent(false, Enum.KeyCode.O, false, game)
                task.wait(0.5)
            end
            
            if savedpos then
                plr.Character.Humanoid:MoveTo(savedpos.Position)
                plr.Character.Humanoid.MoveToFinished:Wait()
                task.wait(0.3)
            end
            
            startm1()
            starttimer()
            task.wait(0.5)
            
            while getgenv().v9daddy do
                task.wait(0.05)
                
                if not busy and not collecting then
                    local cpos = cam.CFrame.Position
                    cam.CFrame = CFrame.lookAt(cpos, santa.Position)
                end
            end
            stopm1()
        end)
    else
        btn.Text = "Start"
        btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        stopm1()
        timer = false
        collecting = false
        if loop then
            task.cancel(loop)
            loop = nil
        end
    end
end)

plr.CharacterRemoving:Connect(function()
    getgenv().v9daddy = false
    getgenv().v9running = false
end)
