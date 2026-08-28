-- [[ CHILLI UI LIBRARY FOR MOBILE - FULL ELEMENTS ]] --
local Chilli = {}
Chilli.__index = Chilli

player = game:GetService("Players").LocalPlayer
character = player.Character or player.CharacterAdded:Wait()
humanoid = character:WaitForChild("Humanoid")
humanoidrootpart = character:WaitForChild("HumanoidRootPart")
allplayer = {}

local function updateAllPlayers()
    allplayer = {}
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player then
            table.insert(allplayer, p)
        end
    end
end
updateAllPlayers()
game:GetService("Players").PlayerAdded:Connect(updateAllPlayers)
game:GetService("Players").PlayerRemoving:Connect(updateAllPlayers)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidrootpart = newChar:WaitForChild("HumanoidRootPart")
end)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChilliUI"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 260)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 40)
Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 14)
TopbarCorner.Parent = Topbar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "Chilli UI"
TitleLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = Topbar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Topbar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

local ToggleUIBtn = Instance.new("TextButton")
ToggleUIBtn.Name = "ChilliToggleMobile"
ToggleUIBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleUIBtn.Position = UDim2.new(0, 15, 0.2, 0)
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleUIBtn.Text = "🌶️"
ToggleUIBtn.TextSize = 22
ToggleUIBtn.Parent = ScreenGui
ToggleUIBtn.Active = true
ToggleUIBtn.Draggable = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleUIBtn

local uiVisible = true
local function toggleUI()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
end
CloseBtn.MouseButton1Click:Connect(toggleUI)
ToggleUIBtn.MouseButton1Click:Connect(toggleUI)

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.Parent = TabBar

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -20, 1, -85)
ContentContainer.Position = UDim2.new(0, 10, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local dragging, dragInput, dragStart, startPos
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

function Chilli:NewWindow(titleText)
    TitleLabel.Text = titleText or "Chilli UI"
    return Chilli
end

local activeTab = nil
function Chilli:NewTab(tabName)
    local Tab = {}
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabName .. "Btn"
    TabBtn.Size = UDim2.new(0, 80, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 12
    TabBtn.AutoButtonColor = false
    TabBtn.Parent = TabBar

    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabBtn

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = tabName .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 3
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 85, 85)
    TabContent.Visible = false
    TabContent.Parent = ContentContainer

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 6)
    ContentLayout.Parent = TabContent

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)

    if activeTab == nil then
        activeTab = {Btn = TabBtn, Content = TabContent}
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
    end

    TabBtn.MouseButton1Click:Connect(function()
        if activeTab then
            activeTab.Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            activeTab.Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            activeTab.Content.Visible = false
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        activeTab = {Btn = TabBtn, Content = TabContent}
    end)

    -- Toggle
    function Tab:NewToggle(textOff, textOn, callback)
        local state = false
        callback = callback or function() end

        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -6, 0, 36)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        ToggleFrame.Parent = TabContent

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleFrame

        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
        ToggleBtn.BackgroundTransparency = 1
        ToggleBtn.Text = "  " .. textOff
        ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        ToggleBtn.Font = Enum.Font.GothamMedium
        ToggleBtn.TextSize = 13
        ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
        ToggleBtn.Parent = ToggleFrame

        local StatusIndicator = Instance.new("Frame")
        StatusIndicator.Size = UDim2.new(0, 16, 0, 16)
        StatusIndicator.Position = UDim2.new(1, -26, 0.5, -8)
        StatusIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        StatusIndicator.Parent = ToggleFrame

        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = StatusIndicator

        ToggleBtn.MouseButton1Click:Connect(function()
            state = not state
            if state then
                ToggleBtn.Text = "  " .. (textOn or textOff)
                ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                TweenService:Create(StatusIndicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 85, 85)}):Play()
            else
                ToggleBtn.Text = "  " .. textOff
                ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                TweenService:Create(StatusIndicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            end
            pcall(callback, state)
        end)
    end

    -- Button
    function Tab:NewButton(btnText, callback)
        callback = callback or function() end

        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, -6, 0, 36)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        ButtonFrame.Parent = TabContent

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = ButtonFrame

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundTransparency = 1
        Btn.Text = btnText
        Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 13
        Btn.Parent = ButtonFrame

        Btn.MouseButton1Click:Connect(function()
            TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 85, 85)}):Play()
            task.wait(0.1)
            TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
            pcall(callback)
        end)
    end

    -- Slider (Kéo chọn giá trị)
    function Tab:NewSlider(sliderText, min, max, default, callback)
        callback = callback or function() end
        min, max, default = min or 0, max or 100, default or min

        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -6, 0, 45)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        SliderFrame.Parent = TabContent

        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 8)
        SliderCorner.Parent = SliderFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -12, 0, 20)
        Label.Position = UDim2.new(0, 10, 0, 4)
        Label.Text = sliderText .. ": " .. tostring(default)
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = SliderFrame

        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -20, 0, 6)
        SliderBar.Position = UDim2.new(0, 10, 0, 28)
        SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        SliderBar.Parent = SliderFrame

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        Fill.Parent = SliderBar

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        local isDragging = false
        local function update(input)
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + ((max - min) * pos))
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Label.Text = sliderText .. ": " .. tostring(val)
            pcall(callback, val)
        end

        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                update(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)
    end

    -- Dropdown (Menu danh sách chọn)
    function Tab:NewDropdown(dropdownText, options, callback)
        callback = callback or function() end
        options = options or {}

        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, -6, 0, 36)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = TabContent

        local DropCorner = Instance.new("UICorner")
        DropCorner.CornerRadius = UDim.new(0, 8)
        DropCorner.Parent = DropdownFrame

        local DropBtn = Instance.new("TextButton")
        DropBtn.Size = UDim2.new(1, 0, 0, 36)
        DropBtn.BackgroundTransparency = 1
        DropBtn.Text = "  " .. dropdownText .. " 🔻"
        DropBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        DropBtn.Font = Enum.Font.GothamMedium
        DropBtn.TextSize = 13
        DropBtn.TextXAlignment = Enum.TextXAlignment.Left
        DropBtn.Parent = DropdownFrame

        local OptionContainer = Instance.new("Frame")
        OptionContainer.Size = UDim2.new(1, 0, 0, #options * 30)
        OptionContainer.Position = UDim2.new(0, 0, 0, 36)
        OptionContainer.BackgroundTransparency = 1
        OptionContainer.Parent = DropdownFrame

        local OptionLayout = Instance.new("UIListLayout")
        OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        OptionLayout.Parent = OptionContainer

        local isExpanded = false
        DropBtn.MouseButton1Click:Connect(function()
            isExpanded = not isExpanded
            if isExpanded then
                DropdownFrame.Size = UDim2.new(1, -6, 0, 36 + (#options * 30))
            else
                DropdownFrame.Size = UDim2.new(1, -6, 0, 36)
            end
        end)

        for _, opt in ipairs(options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Size = UDim2.new(1, 0, 0, 30)
            OptBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            OptBtn.Text = opt
            OptBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextSize = 12
            OptBtn.Parent = OptionContainer

            OptBtn.MouseButton1Click:Connect(function()
                DropBtn.Text = "  " .. dropdownText .. ": " .. opt .. " 🔻"
                DropdownFrame.Size = UDim2.new(1, -6, 0, 36)
                isExpanded = false
                pcall(callback, opt)
            end)
        end
    end

    -- Input (Ô nhập liệu có tùy chọn executeOnEnter)
    function Tab:NewInput(placeholder, executeOnEnter, callback)
        
        if type(executeOnEnter) == "function" then
        callback = executeOnEnter
        executeOnEnter = true
        end
        
        callback = callback or function() end

        local InputFrame = Instance.new("Frame")
        InputFrame.Size = UDim2.new(1, -6, 0, 36)
        InputFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        InputFrame.Parent = TabContent

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 8)
        InputCorner.Parent = InputFrame

        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.new(1, -20, 1, 0)
        TextBox.Position = UDim2.new(0, 10, 0, 0)
        TextBox.BackgroundTransparency = 1
        TextBox.PlaceholderText = placeholder or "Nhập ở đây..."
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
        TextBox.Font = Enum.Font.GothamMedium
        TextBox.TextSize = 13
        TextBox.TextXAlignment = Enum.TextXAlignment.Left
        TextBox.ClearTextOnFocus = false -- Quản lý bằng code dưới
        TextBox.Parent = InputFrame

        -- Trả về Object để đọc Text từ bên ngoài (nếu dùng button/toggle để xử)
        local InputObj = {
            Text = "",
            GetText = function() return TextBox.Text end
        }

        TextBox.Focused:Connect(function()
            -- Nếu executeOnEnter = true -> Bấm vô ô sẽ tự xóa chữ cũ
            if executeOnEnter then
                TextBox.Text = ""
            end
        end)

        TextBox.FocusLost:Connect(function(enterPressed)
            InputObj.Text = TextBox.Text
            if executeOnEnter then
                if enterPressed then
                    pcall(callback, TextBox.Text)
                end
            else
                -- Không executeOnEnter -> Gọi callback mỗi khi chỉnh sửa xong text
                pcall(callback, TextBox.Text)
            end
        end)

        return InputObj
    end

    return Tab
end

return Chilli
