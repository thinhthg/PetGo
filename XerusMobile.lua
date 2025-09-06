local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 550)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true

local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0,30,0,30)
minimizeButton.Position = UDim2.new(1,-35,0,5)
minimizeButton.Text = "-"

local targetLabel = Instance.new("TextLabel", frame)
targetLabel.Size = UDim2.new(1,-10,0,30)
targetLabel.Position = UDim2.new(0,5,0,35)
targetLabel.Text = "Chưa chọn ai"
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(255,255,255)

local searchBox = Instance.new("TextBox", frame)
searchBox.Size = UDim2.new(1,-10,0,30)
searchBox.Position = UDim2.new(0,5,0,70)
searchBox.PlaceholderText = "Tìm player..."
searchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)

local resetButton = Instance.new("TextButton", frame)
resetButton.Size = UDim2.new(1,-10,0,30)
resetButton.Position = UDim2.new(0,5,0,110)
resetButton.Text = "Reset"
resetButton.BackgroundColor3 = Color3.fromRGB(100,60,60)
resetButton.TextColor3 = Color3.fromRGB(255,255,255)

local indivLabel = Instance.new("TextLabel", frame)
indivLabel.Size = UDim2.new(1,-10,0,20)
indivLabel.Position = UDim2.new(0,5,0,145)
indivLabel.Text = "Danh sách cá nhân"
indivLabel.BackgroundTransparency = 1
indivLabel.TextColor3 = Color3.fromRGB(255,255,255)

local indivList = Instance.new("ScrollingFrame", frame)
indivList.Size = UDim2.new(1,-10,0,120)
indivList.Position = UDim2.new(0,5,0,170)
indivList.ScrollBarThickness = 6
indivList.AutomaticCanvasSize = Enum.AutomaticSize.Y
indivList.ClipsDescendants = true
local indivLayout = Instance.new("UIListLayout", indivList)
indivLayout.SortOrder = Enum.SortOrder.LayoutOrder
indivLayout.Padding = UDim.new(0,5)

local allLabel = Instance.new("TextLabel", frame)
allLabel.Size = UDim2.new(1,-10,0,20)
allLabel.Position = UDim2.new(0,5,0,300)
allLabel.Text = "Danh sách All Player"
allLabel.BackgroundTransparency = 1
allLabel.TextColor3 = Color3.fromRGB(255,255,255)

local allList = Instance.new("ScrollingFrame", frame)
allList.Size = UDim2.new(1,-10,0,180)
allList.Position = UDim2.new(0,5,0,325)
allList.ScrollBarThickness = 6
allList.AutomaticCanvasSize = Enum.AutomaticSize.Y
allList.ClipsDescendants = true
local allLayout = Instance.new("UIListLayout", allList)
allLayout.SortOrder = Enum.SortOrder.LayoutOrder
allLayout.Padding = UDim.new(0,5)

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(1,-10,0,40)
toggleButton.Position = UDim2.new(0,5,1,-90)
toggleButton.Text = "OFF Slash"
toggleButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)

local toggleAllButton = Instance.new("TextButton", frame)
toggleAllButton.Size = UDim2.new(1,-10,0,40)
toggleAllButton.Position = UDim2.new(0,5,1,-45)
toggleAllButton.Text = "OFF Slash All"
toggleAllButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
toggleAllButton.TextColor3 = Color3.fromRGB(255,255,255)

local circleBtn = Instance.new("TextButton", gui)
circleBtn.Size = UDim2.new(0,50,0,50)
circleBtn.Position = UDim2.new(0,10,0.5,-25)
circleBtn.Text = ">"
circleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
circleBtn.Visible = false
circleBtn.Active = true
circleBtn.Draggable = true

local selectedTarget = nil
local slashing = false
local slashingAll = false
local excludedFromAll = {}

local function doSlash(target)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SlapHand") then
        local args = {"slash", target.Character, Vector3.new(0,0,0)}
        LocalPlayer.Character.SlapHand.Event:FireServer(unpack(args))
    end
end

local function stopSlashing()
    slashing = false
    slashingAll = false
    toggleButton.Text = "OFF Slash"
    toggleAllButton.Text = "OFF Slash All"
end

LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(stopSlashing)
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(stopSlashing)
end)

local function updateIndividualList()
    indivList:ClearAllChildren()
    local noneBtn = Instance.new("TextButton", indivList)
    noneBtn.Size = UDim2.new(1,-10,0,30)
    noneBtn.Text = "None"
    noneBtn.BackgroundColor3 = Color3.fromRGB(100,50,50)
    noneBtn.TextColor3 = Color3.fromRGB(255,255,255)
    noneBtn.MouseButton1Click:Connect(function()
        selectedTarget = nil
        targetLabel.Text = "Chưa chọn ai"
    end)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if searchBox.Text == "" or string.find(p.Name:lower(),searchBox.Text:lower()) then
                local btn = Instance.new("TextButton", indivList)
                btn.Size = UDim2.new(1,-10,0,30)
                btn.Text = p.Name
                btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.MouseButton1Click:Connect(function()
                    selectedTarget = p
                    targetLabel.Text = "Đã chọn: "..p.Name
                end)
            end
        end
    end
end

local function updateAllList()
    allList:ClearAllChildren()
    local noneBtn = Instance.new("TextButton", allList)
    noneBtn.Size = UDim2.new(1,-10,0,30)
    noneBtn.Text = "None"
    noneBtn.BackgroundColor3 = Color3.fromRGB(100,50,50)
    noneBtn.TextColor3 = Color3.fromRGB(255,255,255)
    noneBtn.MouseButton1Click:Connect(function()
        excludedFromAll = {}
        updateAllList()
    end)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if searchBox.Text == "" or string.find(p.Name:lower(),searchBox.Text:lower()) then
                local btn = Instance.new("TextButton", allList)
                btn.Size = UDim2.new(1,-10,0,30)
                btn.Text = p.Name
                btn.BackgroundColor3 = excludedFromAll[p] and Color3.fromRGB(150,50,50) or Color3.fromRGB(70,70,70)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.MouseButton1Click:Connect(function()
                    if excludedFromAll[p] then
                        excludedFromAll[p] = nil
                        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
                    else
                        excludedFromAll[p] = true
                        btn.BackgroundColor3 = Color3.fromRGB(150,50,50)
                    end
                end)
            end
        end
    end
end

local function updateLists()
    updateIndividualList()
    updateAllList()
end

searchBox:GetPropertyChangedSignal("Text"):Connect(updateLists)
Players.PlayerAdded:Connect(updateLists)
Players.PlayerRemoving:Connect(updateLists)

resetButton.MouseButton1Click:Connect(function()
    stopSlashing()
    selectedTarget = nil
    targetLabel.Text = "Chưa chọn ai"
    excludedFromAll = {}
    updateLists()
end)

updateLists()

toggleButton.MouseButton1Click:Connect(function()
    if not selectedTarget then
        targetLabel.Text = "Chưa chọn ai!"
        return
    end
    slashing = not slashing
    toggleButton.Text = slashing and "ON Slash" or "OFF Slash"
    if slashing then
        task.spawn(function()
            while slashing and selectedTarget do
                doSlash(selectedTarget)
                task.wait(0.1)
            end
        end)
    end
end)

toggleAllButton.MouseButton1Click:Connect(function()
    slashingAll = not slashingAll
    toggleAllButton.Text = slashingAll and "ON Slash All" or "OFF Slash All"
    if slashingAll then
        task.spawn(function()
            while slashingAll do
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and not excludedFromAll[p] then
                        doSlash(p)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

minimizeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    circleBtn.Visible = true
end)

circleBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    circleBtn.Visible = false
end)
