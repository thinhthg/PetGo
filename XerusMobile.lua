local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 220, 0, 600)
f.Position = UDim2.new(0.3, 0, 0.3, 0)
f.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
f.Active = true
f.Draggable = true

local minimizeButton = Instance.new("TextButton", f)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.Text = "-"

local targetLabel = Instance.new("TextLabel", f)
targetLabel.Size = UDim2.new(1, -10, 0, 30)
targetLabel.Position = UDim2.new(0, 5, 0, 35)
targetLabel.Text = "Chưa chọn ai"
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(255,255,255)

local toggleBtn = Instance.new("TextButton", f)
toggleBtn.Size = UDim2.new(1, -10, 0, 40)
toggleBtn.Position = UDim2.new(0, 5, 1, -45)
toggleBtn.Text = "OFF Slash"
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)

local circleBtn = Instance.new("TextButton", gui)
circleBtn.Size = UDim2.new(0, 50, 0, 50)
circleBtn.Position = UDim2.new(0, 10, 0.5, -25)
circleBtn.Text = ">"
circleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
circleBtn.Visible = false
circleBtn.Active = true
circleBtn.Draggable = true

local selectedTarget = nil
local slashing = false
local selectedAll = {}
local slashingAll = false

local function doSlash(target)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SlapHand") then
        local args = {"slash", target.Character, Vector3.new(0,0,0)}
        LocalPlayer.Character.SlapHand.Event:FireServer(unpack(args))
    end
end

local indivHeader = Instance.new("TextButton", f)
indivHeader.Size = UDim2.new(1, -10, 0, 30)
indivHeader.Position = UDim2.new(0, 5, 0, 70)
indivHeader.Text = "- Cá nhân"
indivHeader.BackgroundColor3 = Color3.fromRGB(60,60,60)
indivHeader.TextColor3 = Color3.fromRGB(255,255,255)
local indivCollapsed = false

local searchBox = Instance.new("TextBox", f)
searchBox.Size = UDim2.new(1, -10, 0, 30)
searchBox.Position = UDim2.new(0, 5, 0, 105)
searchBox.PlaceholderText = "Tìm player..."
searchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)

local resetBtn = Instance.new("TextButton", f)
resetBtn.Size = UDim2.new(1, -10, 0, 30)
resetBtn.Position = UDim2.new(0, 5, 0, 140)
resetBtn.Text = "Reset danh sách"
resetBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
resetBtn.TextColor3 = Color3.fromRGB(255,255,255)

local indivList = Instance.new("ScrollingFrame", f)
indivList.Size = UDim2.new(1, -10, 0, 180)
indivList.Position = UDim2.new(0, 5, 0, 175)
indivList.ScrollBarThickness = 6
indivList.AutomaticCanvasSize = Enum.AutomaticSize.Y
indivList.ClipsDescendants = true
local layout = Instance.new("UIListLayout", indivList)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

local allHeader = Instance.new("TextButton", f)
allHeader.Size = UDim2.new(1, -10, 0, 30)
allHeader.Position = UDim2.new(0, 5, 0, 370)
allHeader.Text = "- All Player"
allHeader.BackgroundColor3 = Color3.fromRGB(60,60,60)
allHeader.TextColor3 = Color3.fromRGB(255,255,255)
local allCollapsed = false

local searchAll = Instance.new("TextBox", f)
searchAll.Size = UDim2.new(1, -10, 0, 30)
searchAll.Position = UDim2.new(0, 5, 0, 405)
searchAll.PlaceholderText = "Tìm All..."
searchAll.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchAll.TextColor3 = Color3.fromRGB(255,255,255)

local resetAll = Instance.new("TextButton", f)
resetAll.Size = UDim2.new(1, -10, 0, 30)
resetAll.Position = UDim2.new(0, 5, 0, 440)
resetAll.Text = "Reset All"
resetAll.BackgroundColor3 = Color3.fromRGB(100,60,60)
resetAll.TextColor3 = Color3.fromRGB(255,255,255)

local allList = Instance.new("ScrollingFrame", f)
allList.Size = UDim2.new(1, -10, 0, 180)
allList.Position = UDim2.new(0,5,0,475)
allList.ScrollBarThickness = 6
allList.AutomaticCanvasSize = Enum.AutomaticSize.Y
allList.ClipsDescendants = true
local layout2 = Instance.new("UIListLayout", allList)
layout2.SortOrder = Enum.SortOrder.LayoutOrder
layout2.Padding = UDim.new(0,5)

local toggleAllBtn = Instance.new("TextButton", f)
toggleAllBtn.Size = UDim2.new(1, -10, 0, 40)
toggleAllBtn.Position = UDim2.new(0, 5, 1, -90)
toggleAllBtn.Text = "OFF Slash All"
toggleAllBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleAllBtn.TextColor3 = Color3.fromRGB(255,255,255)

local function updateMenuHeight()
    local baseHeight = 70
    local toggleHeight = toggleBtn.Size.Y.Offset + 10
    local toggleAllHeight = toggleAllBtn.Size.Y.Offset + 10
    local indivHeight = indivCollapsed and 0 or (searchBox.Size.Y.Offset + resetBtn.Size.Y.Offset + indivList.Size.Y.Offset + 10)
    local allHeight = allCollapsed and 0 or (searchAll.Size.Y.Offset + resetAll.Size.Y.Offset + allList.Size.Y.Offset + 10)
    f.Size = UDim2.new(0, 220, 0, baseHeight + toggleHeight + toggleAllHeight + indivHeight + allHeight)
end

local function updatePlayers()
    indivList:ClearAllChildren()
    allList:ClearAllChildren()
    local noneBtn = Instance.new("TextButton", indivList)
    noneBtn.Size = UDim2.new(1, -10, 0, 30)
    noneBtn.Text = "None"
    noneBtn.BackgroundColor3 = Color3.fromRGB(100,50,50)
    noneBtn.TextColor3 = Color3.fromRGB(255,255,255)
    noneBtn.MouseButton1Click:Connect(function()
        selectedTarget = nil
        targetLabel.Text = "Chưa chọn ai"
    end)
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if searchBox.Text == "" or string.find(p.Name:lower(), searchBox.Text:lower()) then
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
            if searchAll.Text == "" or string.find(p.Name:lower(), searchAll.Text:lower()) then
                local btn = Instance.new("TextButton", allList)
                btn.Size = UDim2.new(1,-10,0,30)
                btn.Text = p.Name
                btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                local selected = false
                selectedAll[p] = false
                btn.MouseButton1Click:Connect(function()
                    selected = not selected
                    selectedAll[p] = selected
                    btn.BackgroundColor3 = selected and Color3.fromRGB(120,70,70) or Color3.fromRGB(70,70,70)
                end)
            end
        end
    end
    updateMenuHeight()
end

searchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayers)
searchAll:GetPropertyChangedSignal("Text"):Connect(updatePlayers)
resetBtn.MouseButton1Click:Connect(updatePlayers)
resetAll.MouseButton1Click:Connect(updatePlayers)
Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

toggleBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then
        targetLabel.Text = "Chưa chọn ai!"
        return
    end
    slashing = not slashing
    toggleBtn.Text = slashing and "ON Slash" or "OFF Slash"
    if slashing then
        task.spawn(function()
            while slashing and selectedTarget do
                doSlash(selectedTarget)
                task.wait(0.1)
            end
        end)
    end
end)

toggleAllBtn.MouseButton1Click:Connect(function()
    slashingAll = not slashingAll
    toggleAllBtn.Text = slashingAll and "ON Slash All" or "OFF Slash All"
    if slashingAll then
        task.spawn(function()
            while slashingAll do
                for _,p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and not selectedAll[p] then
                        doSlash(p)
                    end
                end
                task.wait(0.1)
            end
        end)
        end
