local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

for _, gui in pairs(playerGui:GetChildren()) do
    if gui.Name == "SantaFarmGui" then
        gui:Destroy()
    end
end

if getgenv().KeremDaddyRunning then
    getgenv().KeremDaddy = false
    task.wait(0.5)
end

getgenv().KeremDaddyRunning = true

getgenv().Webhook = "https://ptb.discord.com/api/webhooks/1462124356288254168/eZs6NJTls00R-rm5RfTw9M1naKowXkcBTML1yInguUFLc8s-Ki_mBYiumY8EUurNfb_L"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SantaFarmGui"
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StartButton = Instance.new("TextButton")
local SavePosButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")

ScreenGui.Parent = playerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.4, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 280, 0, 160)
Frame.Active = true
Frame.Draggable = true

UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 8)

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "Santa Gift Farm"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

StartButton.Parent = Frame
StartButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StartButton.BorderSizePixel = 0
StartButton.Position = UDim2.new(0.1, 0, 0.28, 0)
StartButton.Size = UDim2.new(0.8, 0, 0, 35)
StartButton.Font = Enum.Font.GothamBold
StartButton.Text = "START"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextSize = 14

UICorner2.Parent = StartButton
UICorner2.CornerRadius = UDim.new(0, 6)

SavePosButton.Parent = Frame
SavePosButton.BackgroundColor3 = Color3.fromRGB(60, 120, 160)
SavePosButton.BorderSizePixel = 0
SavePosButton.Position = UDim2.new(0.1, 0, 0.55, 0)
SavePosButton.Size = UDim2.new(0.8, 0, 0, 35)
SavePosButton.Font = Enum.Font.GothamBold
SavePosButton.Text = "SAVE POSITION"
SavePosButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SavePosButton.TextSize = 13

UICorner3.Parent = SavePosButton
UICorner3.CornerRadius = UDim.new(0, 6)

StatusLabel.Parent = Frame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.83, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Total: 0 | Position: Not Saved | Timer: 60s"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 11

getgenv().KeremDaddy = false
local v0=Instance.new("VirtualInputManager")
local v1=game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local v2=false
local v3=0
local v4=workspace.NPCs["Santa's Sleigh"].Deer["Body.006"]
local v5=false
local v6=nil
local v7=true
local v8=workspace.CurrentCamera
local holdingM1 = false
local timerActive = false
local timeRemaining = 0
local collectingPresents = false
local hasInitialized = false

SavePosButton.MouseButton1Click:Connect(function()
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    v6 = hrp.CFrame
    StatusLabel.Text = "Total: " .. v3 .. " | Position: Saved! | Timer: " .. timeRemaining .. "s"
    SavePosButton.BackgroundColor3 = Color3.fromRGB(50, 160, 50)
    task.wait(0.5)
    SavePosButton.BackgroundColor3 = Color3.fromRGB(60, 120, 160)
end)

local function StartM1Hold()
    holdingM1 = true
    task.spawn(function()
        while getgenv().KeremDaddy and not collectingPresents do
            v0:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.1)
        end
    end)
end

local function StopM1Hold()
    holdingM1 = false
    v0:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

local function UpdateTimer()
    StatusLabel.Text = "Total: " .. v3 .. (v6 and " | Position: Saved" or " | Position: Not Saved") .. " | Timer: " .. timeRemaining .. "s"
end

local function CheckForSpecialMessage()
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, descendant in pairs(gui:GetDescendants()) do
                if (descendant:IsA("TextLabel") or descendant:IsA("TextBox")) and descendant.Visible then
                    local text = descendant.Text
                    if text:find("New Title") or text:find("New Item") then
                        return true, text
                    end
                end
            end
        end
    end
    return false, nil
end

local function CollectNearbyPresents()
    if not v6 then return end
    
    collectingPresents = true
    StopM1Hold()
    task.wait(0.3)
    
    local presentsToCollect = {}
    for _, present in pairs(workspace.Effects:GetChildren()) do
        if present.Name == "Present" and getgenv().KeremDaddy then
            local distance = (v6.Position - present.Position).Magnitude
            if distance <= 80 then
                if present:FindFirstChild("ProximityPrompt") and present:FindFirstChild("ProximityPrompt").Enabled == true then
                    table.insert(presentsToCollect, present)
                end
            end
        end
    end
    
    for _, present in ipairs(presentsToCollect) do
        if getgenv().KeremDaddy and present.Parent then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = present.CFrame
            task.wait(0.2)
            
            if present.Parent and present:FindFirstChild("ProximityPrompt") and present:FindFirstChild("ProximityPrompt").Enabled == true then
                for i = 1, 3 do
                    if present.Parent and present:FindFirstChild("ProximityPrompt") and present:FindFirstChild("ProximityPrompt").Enabled == true then
                        fireproximityprompt(present.ProximityPrompt)
                        task.wait(0.15)
                    else
                        break
                    end
                end
            end
        end
    end
    
    task.wait(0.5)
    
    if v6 and getgenv().KeremDaddy then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v6
        task.wait(0.3)
    end
    
    collectingPresents = false
    if getgenv().KeremDaddy then
        task.wait(0.2)
        StartM1Hold()
    end
end

local function StartTimer()
    timerActive = true
    timeRemaining = 60
    UpdateTimer()
    
    task.spawn(function()
        while timerActive and timeRemaining > 0 and getgenv().KeremDaddy do
            task.wait(1)
            timeRemaining = timeRemaining - 1
            UpdateTimer()
        end
        
        if getgenv().KeremDaddy then
            timerActive = false
            v5 = true
            
            CollectNearbyPresents()
            
            v5 = false
            
            if getgenv().KeremDaddy then
                task.wait(1)
                StartTimer()
            end
        end
    end)
end

v1.PromptShown:Connect(function(v13)
    if getgenv().KeremDaddy and not collectingPresents then
        fireproximityprompt(v13, 10)
    end
end)

local function v9(v14)
    if getgenv().Webhook and getgenv().Webhook ~= "" then
        pcall(function()
            request({
                Url=getgenv().Webhook,
                Method="POST",
                Headers={["Content-Type"]="application/json"},
                Body=game:GetService("HttpService"):JSONEncode(v14)
            })
        end)
    end
end

local function v10()
    v0:SendKeyEvent(true,Enum.KeyCode.Two,false,game)
    task.wait(0.1)
    v0:SendKeyEvent(false,Enum.KeyCode.Two,false,game)
end

workspace.Effects.ChildRemoved:Connect(function(v16)
    if v16.Name=="Present" and getgenv().KeremDaddy then
        v3+=1
        UpdateTimer()
        
        local hasSpecialMessage, messageText = CheckForSpecialMessage()
        if hasSpecialMessage then
            local v23={
                content="@everyone",
                embeds={{
                    title="Grand Piece Online - SPECIAL DROP!",
                    description="Gift Wrapped - Special Item Detected!",
                    type="rich",
                    color=tonumber(0xFFD700),
                    fields={
                        {name="Total Wrapped Gift:",value=v3,inline=false},
                        {name="Special Message:",value=messageText,inline=false}
                    },
                    footer={icon_url="",text="Farm (" .. os.date("%X") .. ")"}
                }}
            }
            v9(v23)
        end
    end
end)

local v11
workspace.Effects.ChildAdded:Connect(function(v17)
    if not getgenv().KeremDaddy or timerActive or collectingPresents then return end
    task.wait(0.1)
    if v17.Name=="ChristmasGift" and v17.Highlight.FillColor~=Color3.fromRGB(109,0,0) then
        if v5 then return end
        v5=true
        while v17.Parent and v17.Parent==workspace.Effects and getgenv().KeremDaddy and not timerActive and not collectingPresents do
            if v11 then v11:Disconnect() end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v17.Top.TopMiddle.Position)
            task.wait(0.2)
            
            for v34,v35 in pairs(workspace.Effects:GetChildren()) do
                if v35.Name=="Present" and v35.Parent then
                    local v38=(game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v35.Position).Magnitude
                    if v38<=50 then
                        if v35:FindFirstChild("ProximityPrompt") and v35:FindFirstChild("ProximityPrompt").Enabled==true then
                            for i = 1, 3 do
                                if v35.Parent and v35:FindFirstChild("ProximityPrompt") and v35:FindFirstChild("ProximityPrompt").Enabled==true then
                                    fireproximityprompt(v35.ProximityPrompt)
                                    task.wait(0.15)
                                else
                                    break
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
        v5=false
        
        if v6 and getgenv().KeremDaddy and not timerActive and not collectingPresents then
            task.wait(0.2)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v6
        end
    end
end)

local function v12()
    for v20,v21 in pairs(workspace.Effects:GetChildren()) do
        if v21.Name=="Present" and getgenv().KeremDaddy and v21.Parent then
            if v6 then
                local v26=(v6.Position-v21.Position).Magnitude
                if v26<=30 then
                    if v21:FindFirstChild("ProximityPrompt") and v21:FindFirstChild("ProximityPrompt").Enabled==true then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=v21.CFrame
                        task.wait(0.2)
                        for i = 1, 3 do
                            if v21.Parent and v21:FindFirstChild("ProximityPrompt") and v21:FindFirstChild("ProximityPrompt").Enabled==true then
                                fireproximityprompt(v21.ProximityPrompt)
                                task.wait(0.15)
                            else
                                break
                            end
                        end
                        
                        if v6 and getgenv().KeremDaddy then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v6
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
    
    if v6 and getgenv().KeremDaddy then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v6
        task.wait(0.2)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.C and not gameProcessed then
        getgenv().KeremDaddy = not getgenv().KeremDaddy
        
        if getgenv().KeremDaddy then
            StartButton.Text = "STOP"
            StartButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
            
            if farmLoop then task.cancel(farmLoop) end
            farmLoop = task.spawn(function()
                if not hasInitialized then
                    hasInitialized = true
                    v0:SendKeyEvent(true, Enum.KeyCode.I, false, game)
                    task.wait(1)
                    v0:SendKeyEvent(false, Enum.KeyCode.I, false, game)
                    task.wait(0.2)
                    v0:SendKeyEvent(true, Enum.KeyCode.O, false, game)
                    task.wait(1.5)
                    v0:SendKeyEvent(false, Enum.KeyCode.O, false, game)
                    task.wait(0.5)
                end
                
                StartM1Hold()
                task.wait(0.5)
                StartTimer()
                
                while getgenv().KeremDaddy do
                    task.wait(0.05)
                    
                    if not v5 and not collectingPresents then
                        local v18=v8.CFrame.Position
                        v8.CFrame=CFrame.lookAt(v18,v4.Position)
                    end
                    
                    if v7 and not v2 and not timerActive and not collectingPresents then
                        task.wait(1)
                        v2=true
                        spawn(function()
                            v7=false
                            v0:SendKeyEvent(true,Enum.KeyCode.X,false,game)
                            task.delay(13,function()
                                v0:SendKeyEvent(false,Enum.KeyCode.X,false,game)
                                task.wait(1)
                                v12()
                                if v6 then
                                    game.Players.LocalPlayer.Character.Humanoid:MoveTo(v6.Position)
                                end
                                local v32=game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Connect(function(v36)
                                    v7=true
                                end)
                                task.delay(19,function()
                                    v2=false
                                end)
                            end)
                        end)
                    end
                end
                
                StopM1Hold()
            end)
        else
            StartButton.Text = "START"
            StartButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            StopM1Hold()
            timerActive = false
            collectingPresents = false
            if farmLoop then 
                task.cancel(farmLoop)
                farmLoop = nil
            end
        end
    end
end)

ScreenGui.Destroying:Connect(function()
    getgenv().KeremDaddy = false
    getgenv().KeremDaddyRunning = false
    StopM1Hold()
    timerActive = false
    if farmLoop then
        task.cancel(farmLoop)
        farmLoop = nil
    end
end)

local farmLoop
StartButton.MouseButton1Click:Connect(function()
    getgenv().KeremDaddy = not getgenv().KeremDaddy
    
    if getgenv().KeremDaddy then
        StartButton.Text = "STOP"
        StartButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        if farmLoop then task.cancel(farmLoop) end
        farmLoop = task.spawn(function()
            if not hasInitialized then
                hasInitialized = true
                v0:SendKeyEvent(true, Enum.KeyCode.I, false, game)
                task.wait(1)
                v0:SendKeyEvent(false, Enum.KeyCode.I, false, game)
                task.wait(0.2)
                v0:SendKeyEvent(true, Enum.KeyCode.O, false, game)
                task.wait(1.5)
                v0:SendKeyEvent(false, Enum.KeyCode.O, false, game)
                task.wait(0.5)
            end
            
            StartM1Hold()
            task.wait(0.5)
            StartTimer()
            
            while getgenv().KeremDaddy do
                task.wait(0.05)
                
                if not v5 and not collectingPresents then
                    local v18=v8.CFrame.Position
                    v8.CFrame=CFrame.lookAt(v18,v4.Position)
                end
                
                if v7 and not v2 and not timerActive and not collectingPresents then
                    task.wait(1)
                    v2=true
                    spawn(function()
                        v7=false
                        v0:SendKeyEvent(true,Enum.KeyCode.X,false,game)
                        task.delay(13,function()
                            v0:SendKeyEvent(false,Enum.KeyCode.X,false,game)
                            task.wait(1)
                            v12()
                            if v6 then
                                game.Players.LocalPlayer.Character.Humanoid:MoveTo(v6.Position)
                            end
                            local v32=game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Connect(function(v36)
                                v7=true
                            end)
                            task.delay(19,function()
                                v2=false
                            end)
                        end)
                    end)
                end
            end
            
            StopM1Hold()
        end)
    else
        StartButton.Text = "START"
        StartButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        StopM1Hold()
        timerActive = false
        collectingPresents = false
        if farmLoop then 
            task.cancel(farmLoop)
            farmLoop = nil
        end
    end
end)

game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    getgenv().KeremDaddy = false
    getgenv().KeremDaddyRunning = false
end)
