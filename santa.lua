local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StartButton = Instance.new("TextButton")
local SavePosButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Frame.Position = UDim2.new(0.4, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 320, 0, 200)
Frame.Active = true
Frame.Draggable = true

UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 10)

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Santa Gift Farm"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

StartButton.Parent = Frame
StartButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
StartButton.Position = UDim2.new(0.1, 0, 0.25, 0)
StartButton.Size = UDim2.new(0.8, 0, 0, 40)
StartButton.Font = Enum.Font.GothamBold
StartButton.Text = "START"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextSize = 16

UICorner2.Parent = StartButton
UICorner2.CornerRadius = UDim.new(0, 8)

SavePosButton.Parent = Frame
SavePosButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
SavePosButton.Position = UDim2.new(0.1, 0, 0.5, 0)
SavePosButton.Size = UDim2.new(0.8, 0, 0, 40)
SavePosButton.Font = Enum.Font.GothamBold
SavePosButton.Text = "SAVE POSITION"
SavePosButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SavePosButton.TextSize = 14

UICorner3.Parent = SavePosButton
UICorner3.CornerRadius = UDim.new(0, 8)

StatusLabel.Parent = Frame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Total: 0 | Position: Not Saved | Timer: 60s"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12

getgenv().KeremDaddy = false
local v0=Instance.new("VirtualInputManager")
local v1=game:GetService("ProximityPromptService")
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
local holdLoop = nil

SavePosButton.MouseButton1Click:Connect(function()
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    v6 = hrp.CFrame
    StatusLabel.Text = "Total: " .. v3 .. " | Position: Saved! | Timer: " .. timeRemaining .. "s"
    SavePosButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    task.wait(1)
    SavePosButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
end)

local function StartM1Hold()
    if holdLoop then task.cancel(holdLoop) end
    holdingM1 = true
    holdLoop = task.spawn(function()
        while holdingM1 and getgenv().KeremDaddy do
            v0:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait()
        end
    end)
end

local function StopM1Hold()
    holdingM1 = false
    if holdLoop then 
        task.cancel(holdLoop)
        holdLoop = nil
    end
    v0:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

local function UpdateTimer()
    StatusLabel.Text = "Total: " .. v3 .. (v6 and " | Position: Saved" or " | Position: Not Saved") .. " | Timer: " .. timeRemaining .. "s"
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
            StopM1Hold()
            v5 = true
            
            for v20,v21 in pairs(workspace.Effects:GetChildren()) do
                if v21.Name=="Present" and getgenv().KeremDaddy then
                    if v6 then
                        local v26=(v6.Position-v21.Position).Magnitude
                        if v26<=80 then
                            if v21:FindFirstChild("ProximityPrompt") and v21:FindFirstChild("ProximityPrompt").Enabled==true then
                                game.Players.LocalPlayer.Character.Humanoid:MoveTo(v21.Position)
                                game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
            
            if v6 and getgenv().KeremDaddy then
                task.wait(0.5)
                game.Players.LocalPlayer.Character.Humanoid:MoveTo(v6.Position)
                game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
            end
            
            v5 = false
            
            if getgenv().KeremDaddy then
                task.wait(1)
                StartTimer()
            end
        end
    end)
end

local holdCycleLoop = nil
local function StartHoldCycle()
    if holdCycleLoop then task.cancel(holdCycleLoop) end
    holdCycleLoop = task.spawn(function()
        while getgenv().KeremDaddy and not timerActive do
            StartM1Hold()
            task.wait(6)
            StopM1Hold()
            task.wait(6)
        end
    end)
end

v1.PromptShown:Connect(function(v13)
    if getgenv().KeremDaddy then
        fireproximityprompt(v13,10)
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
        local v23={
            content="",
            embeds={{
                title="Grand Piece Online",
                description="Gift Wrapped",
                type="rich",
                color=tonumber(47103),
                fields={{name="Total Wrapped Gift:",value=v3,inline=false}},
                footer={icon_url="",text="Farm (" .. os.date("%X") .. ")"}
            }}
        }
        v9(v23)
    end
end)

local v11
workspace.Effects.ChildAdded:Connect(function(v17)
    if not getgenv().KeremDaddy or timerActive then return end
    task.wait(0.1)
    if v17.Name=="ChristmasGift" and v17.Highlight.FillColor~=Color3.fromRGB(109,0,0) then
        if v5 then return end
        v5=true
        while v17.Parent and v17.Parent==workspace.Effects and getgenv().KeremDaddy and not timerActive do
            if v11 then v11:Disconnect() end
            game.Players.LocalPlayer.Character.Humanoid:MoveTo(v17.Top.TopMiddle.Position)
            v11=game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Connect(function(v33)
                for v34,v35 in pairs(workspace.Effects:GetChildren()) do
                    if v35.Name=="Present" then
                        local v37=v35
                        local v38=(game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v37.Position).Magnitude
                        if v38<=50 then
                            if v37:FindFirstChild("ProximityPrompt") and v37:FindFirstChild("ProximityPrompt").Enabled==true then
                                fireproximityprompt(v35.ProximityPrompt)
                            end
                        end
                        task.wait(0.35)
                    end
                end
            end)
            task.wait(1)
        end
        v5=false
        
        if v6 and getgenv().KeremDaddy and not timerActive then
            task.wait(0.5)
            game.Players.LocalPlayer.Character.Humanoid:MoveTo(v6.Position)
        end
    end
end)

local function v12()
    for v20,v21 in pairs(workspace.Effects:GetChildren()) do
        if v21.Name=="Present" then
            local v25=v21
            if v6 then
                local v26=(v6.Position-v25.Position).Magnitude
                if v26<=30 then
                    if v25:FindFirstChild("ProximityPrompt") and v25:FindFirstChild("ProximityPrompt").Enabled==true then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=v25.CFrame
                    end
                end
            end
            task.wait(0.5)
        end
    end
end

local farmLoop
StartButton.MouseButton1Click:Connect(function()
    getgenv().KeremDaddy = not getgenv().KeremDaddy
    
    if getgenv().KeremDaddy then
        StartButton.Text = "STOP"
        StartButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        if farmLoop then task.cancel(farmLoop) end
        farmLoop = task.spawn(function()
            StartHoldCycle()
            task.wait(12)
            StartTimer()
            
            while getgenv().KeremDaddy do
                task.wait()
                if v5 or timerActive then continue end
                local v18=v8.CFrame.Position
                v8.CFrame=CFrame.lookAt(v18,v4.Position)
                if v7 and not v2 then
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
        end)
    else
        StartButton.Text = "START"
        StartButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        StopM1Hold()
        timerActive = false
        if holdCycleLoop then 
            task.cancel(holdCycleLoop)
            holdCycleLoop = nil
        end
        if farmLoop then 
            task.cancel(farmLoop)
            farmLoop = nil
        end
    end
end)
