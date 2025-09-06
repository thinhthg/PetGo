local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 600)
frame.Position = UDim2.new(0.3,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true

local circleBtn = Instance.new("TextButton", gui)
circleBtn.Size = UDim2.new(0,50,0,50)
circleBtn.Position = UDim2.new(0,10,0.5,-25)
circleBtn.Text = ">"
circleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
circleBtn.Visible = false
circleBtn.Active = true
circleBtn.Draggable = true

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0,30,0,30)
minimizeBtn.Position = UDim2.new(1,-35,0,5)
minimizeBtn.Text = "-"
minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    circleBtn.Visible = true
end)
circleBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    circleBtn.Visible = false
end)

local targetLabel = Instance.new("TextLabel", frame)
targetLabel.Size = UDim2.new(1,-10,0,30)
targetLabel.Position = UDim2.new(0,5,0,35)
targetLabel.Text = "Chưa chọn ai"
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(255,255,255)

local searchBox = Instance.new("TextBox", frame)
searchBox.Size = UDim2.new(1,-10,0,30)
searchBox.Position = UDim2.new(0,5,0,70)
searchBox.PlaceholderText = "Tìm player cá nhân..."
searchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)

local indivList = Instance.new("ScrollingFrame", frame)
indivList.Size = UDim2.new(1,-10,0,150)
indivList.Position = UDim2.new(0,5,0,110)
indivList.ScrollBarThickness = 6
indivList.ClipsDescendants = true
local indivLayout = Instance.new("UIListLayout", indivList)
indivLayout.SortOrder = Enum.SortOrder.LayoutOrder
indivLayout.Padding = UDim.new(0,5)

local selectedTarget = nil

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
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (searchBox.Text == "" or string.find(p.Name:lower(),searchBox.Text:lower())) then
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
searchBox:GetPropertyChangedSignal("Text"):Connect(updateIndividualList)
Players.PlayerAdded:Connect(updateIndividualList)
Players.PlayerRemoving:Connect(updateIndividualList)
updateIndividualList()

local slashBtn = Instance.new("TextButton", frame)
slashBtn.Size = UDim2.new(1,-10,0,40)
slashBtn.Position = UDim2.new(0,5,1,-45)
slashBtn.Text = "OFF Slash"
slashBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
slashBtn.TextColor3 = Color3.fromRGB(255,255,255)

local slashing = false
local function doSlash(target)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SlapHand") then
        local args = {"slash", target.Character, Vector3.new(0,0,0)}
        LocalPlayer.Character.SlapHand.Event:FireServer(unpack(args))
    end
end
slashBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then targetLabel.Text="Chưa chọn ai!" return end
    slashing = not slashing
    slashBtn.Text = slashing and "ON Slash" or "OFF Slash"
    if slashing then
        task.spawn(function()
            while slashing and selectedTarget do
                doSlash(selectedTarget)
                task.wait(0.1)
            end
        end)
    end
end)

local allSearchBox = Instance.new("TextBox", frame)
allSearchBox.Size = UDim2.new(1,-10,0,30)
allSearchBox.Position = UDim2.new(0,5,0,270)
allSearchBox.PlaceholderText = "Tìm player All..."
allSearchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
allSearchBox.TextColor3 = Color3.fromRGB(255,255,255)

local allList = Instance.new("ScrollingFrame", frame)
allList.Size = UDim2.new(1,-10,0,150)
allList.Position = UDim2.new(0,5,0,300)
allList.ScrollBarThickness = 6
allList.ClipsDescendants = true
local allLayout = Instance.new("UIListLayout", allList)
allLayout.SortOrder = Enum.SortOrder.LayoutOrder
allLayout.Padding = UDim.new(0,5)

local excludedFromAll = {}

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
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and (allSearchBox.Text=="" or string.find(p.Name:lower(),allSearchBox.Text:lower())) then
            local btn = Instance.new("TextButton", allList)
            btn.Size = UDim2.new(1,-10,0,30)
            btn.Text = p.Name
            btn.BackgroundColor3 = excludedFromAll[p] and Color3.fromRGB(150,50,50) or Color3.fromRGB(70,70,70)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.MouseButton1Click:Connect(function()
                if excludedFromAll[p] then
                    excludedFromAll[p]=nil
                    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
                else
                    excludedFromAll[p]=true
                    btn.BackgroundColor3 = Color3.fromRGB(150,50,50)
                end
            end)
        end
    end
end
allSearchBox:GetPropertyChangedSignal("Text"):Connect(updateAllList)
Players.PlayerAdded:Connect(updateAllList)
Players.PlayerRemoving:Connect(updateAllList)
updateAllList()

local slashAllBtn = Instance.new("TextButton", frame)
slashAllBtn.Size = UDim2.new(1,-10,0,40)
slashAllBtn.Position = UDim2.new(0,5,1,-90)
slashAllBtn.Text = "OFF Slash All"
slashAllBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
slashAllBtn.TextColor3 = Color3.fromRGB(255,255,255)

local slashingAll = false
slashAllBtn.MouseButton1Click:Connect(function()
    slashingAll = not slashingAll
    slashAllBtn.Text = slashingAll and "ON Slash All" or "OFF Slash All"
    if slashingAll then
        task.spawn(function()
            while slashingAll do
                for _,p in ipairs(Players:GetPlayers()) do
                    if p~=LocalPlayer and not excludedFromAll[p] then
                        doSlash(p)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)
