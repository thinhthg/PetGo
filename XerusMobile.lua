local P = game:GetService("Players")
local L = P.LocalPlayer
local PlayerGui = L:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local gui = Instance.new("ScreenGui")
gui.Parent = PlayerGui
gui.ResetOnSpawn = false

local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 220, 0, 700)
f.Position = UDim2.new(0.3, 0, 0.2, 0)
f.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
f.Active = true
f.Draggable = true

local circleBtn = Instance.new("TextButton", gui)
circleBtn.Size = UDim2.new(0, 50, 0, 50)
circleBtn.Position = UDim2.new(0, 10, 0.5, -25)
circleBtn.Text = ">"
circleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
circleBtn.Visible = false
circleBtn.Active = true
circleBtn.Draggable = true

local minBtn = Instance.new("TextButton", f)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "-"
minBtn.MouseButton1Click:Connect(function()
    f.Visible = false
    circleBtn.Visible = true
end)
circleBtn.MouseButton1Click:Connect(function()
    f.Visible = true
    circleBtn.Visible = false
end)

local targetLabel = Instance.new("TextLabel", f)
targetLabel.Size = UDim2.new(1, -10, 0, 30)
targetLabel.Position = UDim2.new(0, 5, 0, 35)
targetLabel.Text = "Chưa chọn ai"
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Cá nhân
local indivHeader = Instance.new("TextButton", f)
indivHeader.Size = UDim2.new(1, -10, 0, 30)
indivHeader.Position = UDim2.new(0, 5, 0, 70)
indivHeader.Text = "- Cá nhân"
indivHeader.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
indivHeader.TextColor3 = Color3.fromRGB(255, 255, 255)

local searchBox = Instance.new("TextBox", f)
searchBox.Size = UDim2.new(1, -10, 0, 30)
searchBox.Position = UDim2.new(0, 5, 0, 105)
searchBox.PlaceholderText = "Tìm player cá nhân..."
searchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local resetBtn = Instance.new("TextButton", f)
resetBtn.Size = UDim2.new(1, -10, 0, 30)
resetBtn.Position = UDim2.new(0, 5, 0, 140)
resetBtn.Text = "Reset danh sách"
resetBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local indivList = Instance.new("ScrollingFrame", f)
indivList.Size = UDim2.new(1, -10, 0, 150)
indivList.Position = UDim2.new(0, 5, 0, 175)
indivList.ScrollBarThickness = 6
indivList.ClipsDescendants = true
local indivLayout = Instance.new("UIListLayout", indivList)
indivLayout.SortOrder = Enum.SortOrder.LayoutOrder
indivLayout.Padding = UDim.new(0, 5)

local toggleBtn = Instance.new("TextButton", f)
toggleBtn.Size = UDim2.new(1, -10, 0, 40)
toggleBtn.Position = UDim2.new(0, 5, 0, 335)
toggleBtn.Text = "OFF Slash"
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- All
local allHeader = Instance.new("TextButton", f)
allHeader.Size = UDim2.new(1, -10, 0, 385)
allHeader.Position = UDim2.new(0, 5, 0, 385)
allHeader.Text = "- All Player"
allHeader.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
allHeader.TextColor3 = Color3.fromRGB(255, 255, 255)

local searchAll = Instance.new("TextBox", f)
searchAll.Size = UDim2.new(1, -10, 0, 30)
searchAll.Position = UDim2.new(0, 5, 0, 420)
searchAll.PlaceholderText = "Tìm player All..."
searchAll.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
searchAll.TextColor3 = Color3.fromRGB(255, 255, 255)

local resetAll = Instance.new("TextButton", f)
resetAll.Size = UDim2.new(1, -10, 0, 30)
resetAll.Position = UDim2.new(0, 5, 0, 455)
resetAll.Text = "Reset All"
resetAll.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
resetAll.TextColor3 = Color3.fromRGB(255, 255, 255)

local allList = Instance.new("ScrollingFrame", f)
allList.Size = UDim2.new(1, -10, 0, 150)
allList.Position = UDim2.new(0, 5, 0, 490)
allList.ScrollBarThickness = 6
allList.ClipsDescendants = true
local allLayout = Instance.new("UIListLayout", allList)
allLayout.SortOrder = Enum.SortOrder.LayoutOrder
allLayout.Padding = UDim.new(0, 5)

local selectedTarget = nil
local selectedAll = {}
local slashing = false

local function doSlash(target)
    if L.Character and L.Character:FindFirstChild("SlapHand") and target.Character then
        pcall(function()
            L.Character.SlapHand.Event:FireServer({"slash", target.Character, Vector3.new(-3.96,0,0.56)})
        end)
    end
end

local function updateIndividualList()
    indivList:ClearAllChildren()
    local noneBtn = Instance.new("TextButton", indivList)
    noneBtn.Size = UDim2.new(1, -10, 0, 30)
    noneBtn.Text = "None"
    noneBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    noneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noneBtn.MouseButton1Click:Connect(function()
        selectedTarget = nil
        targetLabel.Text = "Chưa chọn ai"
    end)
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= L and (searchBox.Text == "" or string.find(p.Name:lower(), searchBox.Text:lower())) then
            local btn = Instance.new("TextButton", indivList)
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.MouseButton1Click:Connect(function()
                selectedTarget = p
                targetLabel.Text = "Đã chọn: "..p.Name
            end)
        end
    end
end

local function updateAllList()
    allList:ClearAllChildren()
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= L then
            if searchAll.Text == "" or string.find(p.Name:lower(), searchAll.Text:lower()) then
                local btn = Instance.new("TextButton", allList)
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Text = p.Name
                btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.MouseButton1Click:Connect(function()
                    selectedAll[p] = not selectedAll[p]
                    btn.BackgroundColor3 = selectedAll[p] and Color3.fromRGB(120, 70, 70) or Color3.fromRGB(70, 70, 70)
                end)
            end
        end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(updateIndividualList)
searchAll:GetPropertyChangedSignal("Text"):Connect(updateAllList)
resetBtn.MouseButton1Click:Connect(updateIndividualList)
resetAll.MouseButton1Click:Connect(updateAllList)
P.PlayerAdded:Connect(function()
    updateIndividualList()
    updateAllList()
end)
P.PlayerRemoving:Connect(function()
    updateIndividualList()
    updateAllList()
end)
updateIndividualList()
updateAllList()

toggleBtn.MouseButton1Click:Connect(function()
    if not selectedTarget and next(selectedAll) == nil then
        targetLabel.Text = "Chưa chọn ai!"
        return
    end
    slashing = not slashing
    toggleBtn.Text = slashing and "ON Slash" or "OFF Slash"
    if slashing then
        task.spawn(function()
            while slashing do
                if selectedTarget then doSlash(selectedTarget) end
                for p,_ in pairs(selectedAll) do
                    if selectedAll[p] then doSlash(p) end
                end
                task.wait(0.1)
            end
        end)
    end
end)

L.CharacterAdded:Connect(function()
    slashing = false
    toggleBtn.Text = "OFF Slash"
end)


local indivCollapsed = false
indivHeader.MouseButton1Click:Connect(function()
    indivCollapsed = not indivCollapsed
    indivList.Visible = not indivCollapsed
    searchBox.Visible = not indivCollapsed
    resetBtn.Visible = not indivCollapsed
    indivHeader.Text = indivCollapsed and "+ Cá nhân" or "- Cá nhân"
    f.Size = UDim2.new(0,220,0, indivCollapsed and (allCollapsed and 120 or 540) or 700)
end)

local allCollapsed = false
allHeader.MouseButton1Click:Connect(function()
    allCollapsed = not allCollapsed
    allList.Visible = not allCollapsed
    searchAll.Visible = not allCollapsed
    resetAll.Visible = not allCollapsed
    allHeader.Text = allCollapsed and "+ All Player" or "- All Player"
    f.Size = UDim2.new(0,220,0, allCollapsed and (indivCollapsed and 120 or 540) or 700)
end)
