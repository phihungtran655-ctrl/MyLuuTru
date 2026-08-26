local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Xoá UI cũ nếu có
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("CustomMobileMenu") then
    CoreGui.CustomMobileMenu:Destroy()
end

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomMobileMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Nút mở/tắt menu ngoài màn hình
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleMenuBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleMenuBtn.Text = "MENU"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.Draggable = true
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.TextSize = 14
ToggleMenuBtn.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 10)
UICornerBtn.Parent = ToggleMenuBtn

-- Khung Menu Chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 220)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

-- Thanh bên (Sidebar chứa các Tab)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 3
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.Parent = MainFrame

local UICornerSide = Instance.new("UICorner")
UICornerSide.CornerRadius = UDim.new(0, 12)
UICornerSide.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 5)
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 10)
SidePadding.PaddingLeft = UDim.new(0, 5)
SidePadding.PaddingRight = UDim.new(0, 5)
SidePadding.Parent = Sidebar

-- Khu vực nội dung bên phải
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -100, 1, 0)
ContentArea.Position = UDim2.new(0, 100, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Tiêu đề trang hiện tại
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -10, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Movement"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = ContentArea

-- Khung chứa các trang tính năng
local PagesFrame = Instance.new("Frame")
PagesFrame.Size = UDim2.new(1, -10, 1, -40)
PagesFrame.Position = UDim2.new(0, 5, 0, 35)
PagesFrame.BackgroundTransparency = 1
PagesFrame.Parent = ContentArea

-- Quản lý Chuyển Tab
local pages = {}
local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.SourceSans
    tabBtn.TextSize = 14
    tabBtn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabBtn

    local page = Instance.new("ScrollingFrame")
    page.BorderSizePixel = 0
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = PagesFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = page

    pages[name] = {Button = tabBtn, Page = page}

    tabBtn.MouseButton1Click:Connect(function()
        for k, v in pairs(pages) do
            v.Page.Visible = false
            v.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            v.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.Text = name
    end)

    return page
end

-- Hàm hỗ trợ tạo UI Elements
local function createTextBox(parent, placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.95, 0, 0, 35)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    return box
end

local function createToggle(parent, text, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(40, 60, 40)
            btn.Text = text .. ": ON"
            btn.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
            btn.Text = text .. ": OFF"
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        callback(state)
    end)
    return btn
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- NGĂN 1: MOVEMENT
-- ==========================================
local movePage = createTab("Movement")

-- Biến lưu trạng thái On/Off để tự nạp lại khi chết
local isSpeedOn = false
local isJumpOn = false

-- Phần Speed
local speedBox = createTextBox(movePage, "Nhập tốc độ (VD: 50)...")
createToggle(movePage, "Toggle Speed", function(active)
    isSpeedOn = active
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = active and (tonumber(speedBox.Text) or 50) or 16
    end
end)

-- Phần Jump
local jumpBox = createTextBox(movePage, "Nhập lực nhảy (VD: 100)...")
createToggle(movePage, "Toggle Jump", function(active)
    isJumpOn = active
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = active and (tonumber(jumpBox.Text) or 100) or 50
    end
end)

-- Tự động bật lại chỉ số Speed/Jump khi chết hồi sinh
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    local hum = newCharacter:WaitForChild("Humanoid")
    if isSpeedOn then
        hum.WalkSpeed = tonumber(speedBox.Text) or 50
    end
    if isJumpOn then
        hum.UseJumpPower = true
        hum.JumpPower = tonumber(jumpBox.Text) or 100
    end
end)


local singlePlatform = nil
createToggle(movePage, "AirWalk (Sàn Cố Định)", function(active)
    if active then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if singlePlatform then singlePlatform:Destroy() end
            singlePlatform = Instance.new("Part")
            singlePlatform.Size = Vector3.new(100000, 1, 100000)
            singlePlatform.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
            singlePlatform.Anchored = true
            singlePlatform.Transparency = 1
            singlePlatform.Parent = workspace
        end
    else
        if singlePlatform then
            singlePlatform:Destroy()
            singlePlatform = nil
        end
    end
end)

local airWalkLoop, dynamicPlatform = nil, nil
createToggle(movePage, "AirWalk (Đi Trên Không)", function(active)
    if active then
        dynamicPlatform = Instance.new("Part")
        dynamicPlatform.Size = Vector3.new(5, 1, 5)
        dynamicPlatform.Anchored = true
        dynamicPlatform.Transparency = 1
        dynamicPlatform.Parent = workspace

        airWalkLoop = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and dynamicPlatform then
                local hrp = char.HumanoidRootPart
                dynamicPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
            end
        end)
    else
        if airWalkLoop then airWalkLoop:Disconnect() airWalkLoop = nil end
        if dynamicPlatform then dynamicPlatform:Destroy() dynamicPlatform = nil end
    end
end)

local noclipConnection = nil
createToggle(movePage, "Noclip (Xuyên Tường)", function(active)
    if active then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end)

local tpBox = createTextBox(movePage, "Nhập tên hoặc 'random'...")
createButton(movePage, "Teleport Đến Người Chơi", function()
    local targetText = string.lower(tpBox.Text)
    if targetText == "" then return end

    if targetText == "random" then
        local otherPlayers = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(otherPlayers, p)
            end
        end
        if #otherPlayers > 0 then
            local randomTarget = otherPlayers[math.random(1, #otherPlayers)]
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = randomTarget.Character.HumanoidRootPart.CFrame
            end
        end
    else
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= LocalPlayer and (string.find(string.lower(targetPlayer.Name), targetText) or string.find(string.lower(targetPlayer.DisplayName), targetText)) then
                if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                    break
                end
            end
        end
    end
end)

-- Infinite Jump
local infJumpConnection = nil
createToggle(movePage, "Infinite Jump", function(active)
    if active then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
            infJumpConnection = nil
        end
    end
end)

-- Fly (Bay kiểu Admin Real)
local flySpeedBox = createTextBox(movePage, "Nhập tốc độ bay (VD: 50)...")
local isFlying = false
local flyConnection = nil
local flyBodyVel = nil
local flyBodyGyro = nil

createToggle(movePage, "Toggle Fly (Bay)", function(active)
    isFlying = active
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local camera = workspace.CurrentCamera

    if isFlying and hrp and hum then
        -- 1. CHUYỂN TRẠNG THÁI "ĐÓNG BĂNG" NHÂN VẬT (Admin Style)
        hum.PlatformStand = true -- Giúp nhân vật không bị vấp ngã khi va chạm
        task.wait() -- Đợi một xíu cho chắc
        hum:ChangeState(Enum.HumanoidStateType.Physics) -- Ép trạng thái cứng

        -- 2. Tạo lực bay và xoay nhân vật (như cũ)
        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBodyVel.Velocity = Vector3.zero
        flyBodyVel.Parent = hrp

        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBodyGyro.CFrame = camera.CFrame
        flyBodyGyro.Parent = hrp

        -- Vòng lặp cập nhật di chuyển liên tục theo Joystick và Camera
        flyConnection = RunService.RenderStepped:Connect(function()
            if not isFlying or not hrp or not hum then return end
            
            -- Ép trạng thái liên tục để chắc chắn nhân vật không tự động đổi tư thế
            if hum:GetState() ~= Enum.HumanoidStateType.Physics then
                hum:ChangeState(Enum.HumanoidStateType.Physics)
            end

            -- Xoay nhân vật theo hướng nhìn của Camera
            flyBodyGyro.CFrame = camera.CFrame
            
            -- Lấy hướng di chuyển từ Joystick mặc định của Roblox
            local moveDir = hum.MoveDirection
            local speed = tonumber(flySpeedBox.Text) or 50
            
            if moveDir.Magnitude > 0 then
                -- Bay theo hướng Joystick hướng tới dựa trên góc nhìn Camera
                local flyDir = (camera.CFrame.Rotation * moveDir).Unit
                flyBodyVel.Velocity = flyDir * speed
            else
                -- Đứng yên trên không khi thả Joystick
                flyBodyVel.Velocity = Vector3.zero
            end
        end)
    else
        -- 3. DỌN DẸP VÀ KHÔI PHỤC KHI TẮT FLY
        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.Running) -- Trả về trạng thái chạy bình thường
        end

        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    end
end)

-- ==========================================
-- NGĂN 2: VISUALS
-- ==========================================
local visualsPage = createTab("Visuals")

local espConnection = nil
local function applyESP(v)
    if v ~= LocalPlayer and v.Character and not v.Character:FindFirstChild("ESPHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "ESPHighlight"
        hl.Adornee = v.Character
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.FillColor = v.TeamColor and v.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        hl.OutlineColor = v.TeamColor and v.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        hl.Parent = v.Character
    end
end

createToggle(visualsPage, "ESP Highlight (Viền Team)", function(active)
    if active then
        for _, v in pairs(Players:GetPlayers()) do applyESP(v) end
        espConnection = Players.PlayerAdded:Connect(function(v)
            v.CharacterAdded:Connect(function() task.wait(0.5) applyESP(v) end)
        end)
    else
        if espConnection then espConnection:Disconnect() espConnection = nil end
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("ESPHighlight") then
                v.Character.ESPHighlight:Destroy()
            end
        end
    end
end)

local nameConnection = nil
local function applyNameESP(v)
    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and not v.Character.Head:FindFirstChild("ESPName") then
        local bg = Instance.new("BillboardGui")
        bg.Name = "ESPName"
        bg.Size = UDim2.new(0, 100, 0, 30)
        bg.StudsOffset = Vector3.new(0, 2, 0)
        bg.AlwaysOnTop = true
        bg.Adornee = v.Character.Head
        bg.Parent = v.Character.Head

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = v.DisplayName
        txt.TextColor3 = v.TeamColor and v.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        txt.Font = Enum.Font.SourceSansBold
        txt.TextSize = 14
        txt.Parent = bg
    end
end

createToggle(visualsPage, "ESP Name (Hiện Tên)", function(active)
    if active then
        for _, v in pairs(Players:GetPlayers()) do applyNameESP(v) end
        nameConnection = Players.PlayerAdded:Connect(function(v)
            v.CharacterAdded:Connect(function() task.wait(0.5) applyNameESP(v) end)
        end)
    else
        if nameConnection then nameConnection:Disconnect() nameConnection = nil end
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("ESPName") then
                v.Character.Head.ESPName:Destroy()
            end
        end
    end
end)

-- Thanh chỉnh FOV Camera
local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(0.95, 0, 0, 45)
fovFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
fovFrame.Parent = visualsPage

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 6)
fovCorner.Parent = fovFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, 0, 0, 20)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV Camera: 70"
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.Font = Enum.Font.SourceSansBold
fovLabel.TextSize = 13
fovLabel.Parent = fovFrame

local fovSlider = Instance.new("TextButton")
fovSlider.Size = UDim2.new(0.9, 0, 0, 15)
fovSlider.Position = UDim2.new(0.05, 0, 0.5, 0)
fovSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
fovSlider.Text = ""
fovSlider.Parent = fovFrame

local fovFill = Instance.new("Frame")
fovFill.Size = UDim2.new(0.5, 0, 1, 0)
fovFill.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
fovFill.BorderSizePixel = 0
fovFill.Parent = fovSlider

local isDraggingFov = false
fovSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingFov = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingFov = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingFov and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local relativeX = math.clamp(input.Position.X - fovSlider.AbsolutePosition.X, 0, fovSlider.AbsoluteSize.X)
        local percentage = relativeX / fovSlider.AbsoluteSize.X
        fovFill.Size = UDim2.new(percentage, 0, 1, 0)
        local fovValue = math.floor(70 + (percentage * 50))
        fovLabel.Text = "FOV Camera: " .. tostring(fovValue)
        workspace.CurrentCamera.FieldOfView = fovValue
    end
end)
-- ==========================================
-- NGĂN 3: WORLD
-- ==========================================
local worldPage = createTab("World")

-- 1. Sáng trưng (Fullbright)
local fullbrightConn = nil
createToggle(worldPage, "Sáng Trưng (Fullbright)", function(active)
    if active then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        fullbrightConn = RunService.RenderStepped:Connect(function()
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end)
    else
        if fullbrightConn then fullbrightConn:Disconnect() fullbrightConn = nil end
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
    end
end)

-- 2. Thời gian (Slider)
local timeFrame = Instance.new("Frame")
timeFrame.Size = UDim2.new(0.95, 0, 0, 45)
timeFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
timeFrame.Parent = worldPage

local timeCorner = Instance.new("UICorner")
timeCorner.CornerRadius = UDim.new(0, 6)
timeCorner.Parent = timeFrame

local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(1, 0, 0, 20)
timeLabel.BackgroundTransparency = 1
timeLabel.Text = "Thời Gian: 14:00"
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.Font = Enum.Font.SourceSansBold
timeLabel.TextSize = 13
timeLabel.Parent = timeFrame

local timeSlider = Instance.new("TextButton")
timeSlider.Size = UDim2.new(0.9, 0, 0, 15)
timeSlider.Position = UDim2.new(0.05, 0, 0.5, 0)
timeSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
timeSlider.Text = ""
timeSlider.Parent = timeFrame

local timeFill = Instance.new("Frame")
timeFill.Size = UDim2.new(14/24, 0, 1, 0)
timeFill.BackgroundColor3 = Color3.fromRGB(200, 160, 80)
timeFill.BorderSizePixel = 0
timeFill.Parent = timeSlider

local isDraggingTime = false
timeSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingTime = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingTime = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingTime and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local relativeX = math.clamp(input.Position.X - timeSlider.AbsolutePosition.X, 0, timeSlider.AbsoluteSize.X)
        local percentage = relativeX / timeSlider.AbsoluteSize.X
        timeFill.Size = UDim2.new(percentage, 0, 1, 0)
        local hours = math.floor(percentage * 24)
        local minutes = math.floor(((percentage * 24) - hours) * 60)
        timeLabel.Text = string.format("Thời Gian: %02d:%02d", hours, minutes)
        Lighting.ClockTime = percentage * 24
    end
end)

-- 3. Xóa sương mù (Remove Fog)
local savedFogEnd = Lighting.FogEnd
createToggle(worldPage, "Xóa Sương Mù", function(active)
    if active then
        savedFogEnd = Lighting.FogEnd
        Lighting.FogEnd = 1000000
    else
        Lighting.FogEnd = savedFogEnd or 100000
    end
end)

-- 4. Trọng lực (Gravity)
local gravBox = createTextBox(worldPage, "Nhập trọng lực (VD: 50)...")
createToggle(worldPage, "Toggle Gravity", function(active)
    if active then
        workspace.Gravity = tonumber(gravBox.Text) or 196.2
    else
        workspace.Gravity = 196.2
    end
end)

-- ==========================================
-- NGĂN 4: AIMBOT (Tính năng mới)
-- ==========================================
local aimbotPage = createTab("Aimbot")

local aimbotEnabled = false
local aimbotRadius = 100
local aimPartName = "Head"
local wallCheck = false
local teamCheck = false

-- Vòng tròn FOV Aimbot
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.Color = Color3.fromRGB(255, 50, 50)
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Visible = false

-- 1. Nút Toggle Aimbot
createToggle(aimbotPage, "Aimbot", function(active)
    aimbotEnabled = active
    fovCircle.Visible = active
end)

-- 2. Slider chỉnh bán kính FOV
local aimFovFrame = Instance.new("Frame")
aimFovFrame.Size = UDim2.new(0.95, 0, 0, 45)
aimFovFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
aimFovFrame.Parent = aimbotPage

local aimFovCorner = Instance.new("UICorner")
aimFovCorner.CornerRadius = UDim.new(0, 6)
aimFovCorner.Parent = aimFovFrame

local aimFovLabel = Instance.new("TextLabel")
aimFovLabel.Size = UDim2.new(1, 0, 0, 20)
aimFovLabel.BackgroundTransparency = 1
aimFovLabel.Text = "Aimbot FOV: 100"
aimFovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
aimFovLabel.Font = Enum.Font.SourceSansBold
aimFovLabel.TextSize = 13
aimFovLabel.Parent = aimFovFrame

local aimFovSlider = Instance.new("TextButton")
aimFovSlider.Size = UDim2.new(0.9, 0, 0, 15)
aimFovSlider.Position = UDim2.new(0.05, 0, 0.5, 0)
aimFovSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
aimFovSlider.Text = ""
aimFovSlider.Parent = aimFovFrame

local aimFovFill = Instance.new("Frame")
aimFovFill.Size = UDim2.new(100/300, 0, 1, 0)
aimFovFill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
aimFovFill.BorderSizePixel = 0
aimFovFill.Parent = aimFovSlider

local isDraggingAimFov = false
aimFovSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingAimFov = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingAimFov = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingAimFov and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local relativeX = math.clamp(input.Position.X - aimFovSlider.AbsolutePosition.X, 0, aimFovSlider.AbsoluteSize.X)
        local percentage = relativeX / aimFovSlider.AbsoluteSize.X
        aimFovFill.Size = UDim2.new(percentage, 0, 1, 0)
        aimbotRadius = math.floor(30 + (percentage * 270))
        aimFovLabel.Text = "Aimbot FOV: " .. tostring(aimbotRadius)
    end
end)

-- 3. Nút chọn bộ phận nhắm (Đầu, Thân, Tay, Chân)
local bodyParts = {
    {name = "Đầu (Head)", part = "Head"},
    {name = "Thân (Torso)", part = "HumanoidRootPart"},
    {name = "Tay Trái", part = "Left Arm"},
    {name = "Tay Phải", part = "Right Arm"},
    {name = "Chân Trái", part = "Left Leg"},
    {name = "Chân Phải", part = "Right Leg"}
}
local partIndex = 1
local partBtn = createButton(aimbotPage, "Mục tiêu: " .. bodyParts[1].name, function() end)

partBtn.MouseButton1Click:Connect(function()
    partIndex = partIndex % #bodyParts + 1
    aimPartName = bodyParts[partIndex].part
    partBtn.Text = "Mục tiêu: " .. bodyParts[partIndex].name
end)

-- 4. Toggle Kiểm tra Tường & Team
createToggle(aimbotPage, "Kiểm Tra Tường (Wall Check)", function(active)
    wallCheck = active
end)

createToggle(aimbotPage, "Kiểm Tra Đồng Đội (Team Check)", function(active)
    teamCheck = active
end)

-- Logic Nhận Diện Cảm Ứng Xoay Màn Hình (Mobile Smart-Lock)
local isUserTouchingScreen = false
UserInputService.TouchStarted:Connect(function(touch, gpe)
    if not gpe then isUserTouchingScreen = true end
end)

UserInputService.TouchEnded:Connect(function()
    isUserTouchingScreen = false
end)

-- Logic Aimbot
local function getTargetPart(player, partName)
    local char = player.Character
    if not char then return nil end
    local p = char:FindFirstChild(partName)
    if p then return p end
    -- Fallback R15 / R6
    if partName == "HumanoidRootPart" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
    if partName == "Left Arm" then return char:FindFirstChild("LeftUpperArm") end
    if partName == "Right Arm" then return char:FindFirstChild("RightUpperArm") end
    if partName == "Left Leg" then return char:FindFirstChild("LeftUpperLeg") end
    if partName == "Right Leg" then return char:FindFirstChild("RightUpperLeg") end
    return char:FindFirstChild("Head")
end

local function isPartVisible(targetPart, targetCharacter)
    local localCharacter = LocalPlayer.Character
    if not localCharacter or not targetPart then return false end
    
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local ignoreList = {localCharacter, camera}
    if targetCharacter then
        table.insert(ignoreList, targetCharacter)
    end
    raycastParams.FilterDescendantsInstances = ignoreList
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

    fovCircle.Position = center
    fovCircle.Radius = aimbotRadius

    if not aimbotEnabled or isUserTouchingScreen then return end

    local closestTarget = nil
    local shortestDistance = aimbotRadius

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if not (teamCheck and p.Team == LocalPlayer.Team) then
                local targetPart = getTargetPart(p, aimPartName)
                if targetPart then
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if distance <= shortestDistance then
                            if not wallCheck or isPartVisible(targetPart, p.Character) then
                                closestTarget = targetPart
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end
        end
    end

    if closestTarget then
        camera.CFrame = CFrame.new(camera.CFrame.Position, closestTarget.Position)
    end
end)

-- ==========================================
-- NGĂN 5: SETTINGS
-- ==========================================
local settingsPage = createTab("Settings")

createButton(settingsPage, "Destroy Gui (Xoá Menu)", function()
    if fovCircle then fovCircle:Remove() end
    if ToggleMenuBtn then ToggleMenuBtn:Destroy() end
    if ScreenGui then ScreenGui:Destroy() end
end)

createToggle(settingsPage, "Anti-AFK (Chống văng game)", function(active)
    if active then
        getgenv().AntiAfkConnection = LocalPlayer.Idled:Connect(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end)
    else
        if getgenv().AntiAfkConnection then
            getgenv().AntiAfkConnection:Disconnect()
            getgenv().AntiAfkConnection = nil
        end
    end
end)

local function autoExecuteOnTeleport()
    local autoExecScript = [[
        repeat task.wait() until game:IsLoaded()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/phihungtran655-ctrl/MyLuuTru/refs/heads/main/Menu1.lua"))()
    ]]
    local queueFunction = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    if queueFunction then
        queueFunction(autoExecScript)
    end
end

createButton(settingsPage, "Rejoin Server (Vào lại)", function()
    autoExecuteOnTeleport()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

createButton(settingsPage, "Server Hop (Đổi Server)", function()
    autoExecuteOnTeleport()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/0?sortOrder=Asc&limit=100")).data
    
    for _, s in ipairs(servers) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            break
        end
    end
end)

createButton(settingsPage, "Server Ít Người (Vắng nhất)", function()
    autoExecuteOnTeleport()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/0?sortOrder=Asc&limit=100")).data
    
    table.sort(servers, function(a, b)
        return a.playing < b.playing
    end)
    
    for _, s in ipairs(servers) do
        if s.id ~= game.JobId and s.playing > 0 and s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            break
        end
    end
end)


-- Mặc định mở Tab Movement ban đầu
pages["Movement"].Page.Visible = true
pages["Movement"].Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
pages["Movement"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Bật / Tắt Menu bằng nút bấm ngoài
ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
