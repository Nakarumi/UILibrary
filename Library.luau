local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

Library.Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(85, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Shadow = Color3.fromRGB(0, 0, 0)
}

Library.Notifications = {}

function Library:Notify(config)
    local title = type(config) == "string" and config or config.Title or "Notification"
    local description = type(config) == "table" and config.Description or ""
    local duration = type(config) == "table" and config.Duration or 3
    
    local ScreenGui = game.CoreGui:FindFirstChild("LibraryNotifications")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "LibraryNotifications"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = game.CoreGui
    end
    
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 300, 0, 0)
    Notification.Position = UDim2.new(1, -320, 1, 20)
    Notification.BackgroundColor3 = self.Theme.Secondary
    Notification.BorderSizePixel = 0
    Notification.BackgroundTransparency = 1
    Notification.Parent = ScreenGui
    
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 1
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex = Notification.ZIndex - 1
    Shadow.Parent = Notification
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Notification
    
    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.BackgroundColor3 = self.Theme.Accent
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = Notification
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = AccentBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTransparency = 1
    TitleLabel.Parent = Notification
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -20, 0, 20)
    DescLabel.Position = UDim2.new(0, 15, 0, 33)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = description
    DescLabel.TextColor3 = self.Theme.TextDark
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 13
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.TextTransparency = 1
    DescLabel.Parent = Notification
    
    local height = description ~= "" and 70 or 45
    
    for _, notif in pairs(ScreenGui:GetChildren()) do
        if notif:IsA("Frame") and notif ~= Notification then
            TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(notif.Position.X.Scale, notif.Position.X.Offset, 
                                     notif.Position.Y.Scale, notif.Position.Y.Offset - height - 10)
            }):Play()
        end
    end
    
    TweenService:Create(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, height),
        Position = UDim2.new(1, -320, 1, -20 - height),
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(DescLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.wait(duration)
    TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 20, Notification.Position.Y.Scale, Notification.Position.Y.Offset),
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    TweenService:Create(DescLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    
    task.wait(0.3)
    Notification:Destroy()
end

function Library:SetTheme(theme)
    for key, value in pairs(theme) do
        if self.Theme[key] then
            self.Theme[key] = value
        end
    end
    
    self:UpdateTheme()
end

function Library:UpdateTheme()
    if self.Main then
        self.Main.BackgroundColor3 = self.Theme.Background
    end
    
    if self.TitleBar then
        self.TitleBar.BackgroundColor3 = self.Theme.Secondary
        local TitleFix = self.TitleBar:FindFirstChild("TitleFix")
        if TitleFix then
            TitleFix.BackgroundColor3 = self.Theme.Secondary
        end
    end
    
    if self.Tabs then
        for _, tab in pairs(self.Tabs) do
            if tab.Button then
                local isActive = tab.Container.Visible
                tab.Button.BackgroundColor3 = isActive and self.Theme.Accent or self.Theme.Secondary
            end
            if tab.Container then
                tab.Container.ScrollBarImageColor3 = self.Theme.Accent
            end
        end
    end
    
    for _, element in pairs(self.Elements or {}) do
        if element and element.Parent then
            if element:IsA("Frame") or element:IsA("TextButton") then
                element.BackgroundColor3 = self.Theme.Secondary
            end
            
            for _, child in pairs(element:GetDescendants()) do
                if child:IsA("TextLabel") then
                    if child.Name == "SectionLabel" or child.Name == "ConfigLabel" then
                        child.TextColor3 = self.Theme.Accent
                    elseif child.Name == "ValueLabel" or child.Name == "SelectedLabel" then
                        child.TextColor3 = self.Theme.Accent
                    elseif child.Name ~= "Arrow" then
                        child.TextColor3 = self.Theme.Text
                    end
                end
                
                if child.Name == "SliderFill" then
                    child.BackgroundColor3 = self.Theme.Accent
                elseif child.Name == "ToggleButton" then
                    if child.BackgroundColor3 ~= Color3.fromRGB(50, 50, 60) then
                        child.BackgroundColor3 = self.Theme.Accent
                    end
                elseif child.Name == "KeybindDisplay" then
                    child.BackgroundColor3 = self.Theme.Accent
                end
            end
        end
    end
end

local function CreateShadow(parent)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex = parent.ZIndex - 1
    Shadow.Parent = parent
    return Shadow
end

function Library:CreateWindow(config)
    local Window = setmetatable({}, {__index = self})
    Window.Elements = {}
    Window.Tabs = {}
    Window.Theme = self.Theme
    Window.ToggleKey = Enum.KeyCode.RightControl
    Window.CurrentTab = nil
    Window.IsVisible = true
    Window.ConfigData = {}
    
    local title = type(config) == "string" and config or config.Title or "GUI Library"
    local size = type(config) == "table" and config.Size or UDim2.new(0, 500, 0, 400)
    local toggleKey = type(config) == "table" and config.ToggleKey or Enum.KeyCode.RightControl
    
    Window.ToggleKey = toggleKey
    Window.ConfigFolder = title .. "/configs"
    
    if not isfolder(title) then
        makefolder(title)
    end
    
    if not isfolder(Window.ConfigFolder) then
        makefolder(Window.ConfigFolder)
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LibraryGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Window.Theme.Background
    Main.BorderSizePixel = 0
    Main.BackgroundTransparency = 1
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    CreateShadow(Main)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Main
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Window.Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local TitleFix = Instance.new("Frame")
    TitleFix.Name = "TitleFix"
    TitleFix.Size = UDim2.new(1, 0, 0, 12)
    TitleFix.Position = UDim2.new(0, 0, 1, -12)
    TitleFix.BackgroundColor3 = Window.Theme.Secondary
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Window.Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 17
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTransparency = 1
    TitleLabel.Parent = TitleBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0.5, -17.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.BackgroundTransparency = 1
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Window.Theme.Text
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 24
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        for _, element in pairs(Main:GetDescendants()) do
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                TweenService:Create(element, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            end
            if element:IsA("ImageLabel") then
                TweenService:Create(element, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            end
        end
        
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, -24, 0, 35)
    TabBar.Position = UDim2.new(0, 12, 0, 55)
    TabBar.BackgroundTransparency = 1
    TabBar.BorderSizePixel = 0
    TabBar.ScrollBarThickness = 0
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.Parent = Main
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabBar
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 10, 0, 0)
    end)
    
    local TabContainerHolder = Instance.new("Frame")
    TabContainerHolder.Name = "TabContainerHolder"
    TabContainerHolder.Size = UDim2.new(1, -24, 1, -105)
    TabContainerHolder.Position = UDim2.new(0, 12, 0, 100)
    TabContainerHolder.BackgroundTransparency = 1
    TabContainerHolder.ClipsDescendants = true
    TabContainerHolder.Parent = Main
    
    local dragging, dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Window.ToggleKey then
            Window.IsVisible = not Window.IsVisible
            
            if not Window.IsVisible then
                TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1
                }):Play()
                
                for _, element in pairs(Main:GetDescendants()) do
                    if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                        TweenService:Create(element, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                    end
                    if element:IsA("ImageLabel") and element.Name == "Shadow" then
                        TweenService:Create(element, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                    end
                end
            else
                TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = size,
                    BackgroundTransparency = 0
                }):Play()
                
                task.wait(0.2)
                
                for _, element in pairs(Main:GetDescendants()) do
                    if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                        TweenService:Create(element, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
                    end
                    if element:IsA("ImageLabel") and element.Name == "Shadow" then
                        TweenService:Create(element, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
                    end
                end
            end
        end
    end)
    
    Window.Main = Main
    Window.TitleBar = TitleBar
    Window.TabBar = TabBar
    Window.TabContainerHolder = TabContainerHolder
    
    task.wait()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = size,
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(TitleLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    return Window
end

function Library:SaveConfig(name)
    local configPath = self.ConfigFolder .. "/" .. name .. ".json"
    local configData = {}
    
    for key, data in pairs(self.ConfigData) do
        configData[key] = data.Value
    end
    
    local success, err = pcall(function()
        writefile(configPath, game:GetService("HttpService"):JSONEncode(configData))
    end)
    
    if success then
        self:Notify({Title = "Config Saved", Description = "Configuration saved to " .. name, Duration = 2})
    else
        self:Notify({Title = "Save Error", Description = "Failed to save config: " .. tostring(err), Duration = 3})
    end
end

function Library:LoadConfig(name)
    local configPath = self.ConfigFolder .. "/" .. name .. ".json"
    
    if not isfile(configPath) then
        self:Notify({Title = "Load Error", Description = "Config file not found", Duration = 2})
        return
    end
    
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(configPath))
    end)
    
    if not success then
        self:Notify({Title = "Load Error", Description = "Failed to decode config", Duration = 3})
        return
    end
    
    for key, value in pairs(result) do
        if self.ConfigData[key] then
            self.ConfigData[key].Callback(value)
            self.ConfigData[key].Value = value
        end
    end
    
    self:Notify({Title = "Config Loaded", Description = "Configuration loaded from " .. name, Duration = 2})
end

function Library:DeleteConfig(name)
    local configPath = self.ConfigFolder .. "/" .. name .. ".json"
    
    if not isfile(configPath) then
        self:Notify({Title = "Delete Error", Description = "Config file not found", Duration = 2})
        return
    end
    
    local success, err = pcall(function()
        delfile(configPath)
    end)
    
    if success then
        self:Notify({Title = "Config Deleted", Description = "Configuration " .. name .. " deleted", Duration = 2})
    else
        self:Notify({Title = "Delete Error", Description = "Failed to delete config", Duration = 3})
    end
end

function Library:GetConfigs()
    local configs = {}
    
    if not isfolder(self.ConfigFolder) then
        makefolder(self.ConfigFolder)
        return configs
    end
    
    for _, file in pairs(listfiles(self.ConfigFolder)) do
        local name = file:match("([^/\\]+)%.json$")
        if name then
            table.insert(configs, name)
        end
    end
    
    return configs
end

function Library:CreateConfiguration()
    local ConfigSection = Instance.new("Frame")
    ConfigSection.Name = "ConfigSection"
    ConfigSection.Size = UDim2.new(1, 0, 0, 230)
    ConfigSection.BackgroundColor3 = self.Theme.Secondary
    ConfigSection.BorderSizePixel = 0
    ConfigSection.BackgroundTransparency = 1
    ConfigSection.Parent = self.Container
    
    CreateShadow(ConfigSection)
    
    local ConfigCorner = Instance.new("UICorner")
    ConfigCorner.CornerRadius = UDim.new(0, 8)
    ConfigCorner.Parent = ConfigSection
    
    local ConfigLabel = Instance.new("TextLabel")
    ConfigLabel.Size = UDim2.new(1, -20, 0, 30)
    ConfigLabel.Position = UDim2.new(0, 10, 0, 8)
    ConfigLabel.BackgroundTransparency = 1
    ConfigLabel.Text = "Configuration Manager"
    ConfigLabel.TextColor3 = self.Theme.Accent
    ConfigLabel.Font = Enum.Font.GothamBold
    ConfigLabel.TextSize = 16
    ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
    ConfigLabel.TextTransparency = 1
    ConfigLabel.Parent = ConfigSection
    
    local ConfigName = Instance.new("TextBox")
    ConfigName.Size = UDim2.new(1, -20, 0, 35)
    ConfigName.Position = UDim2.new(0, 10, 0, 45)
    ConfigName.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ConfigName.BorderSizePixel = 0
    ConfigName.Text = ""
    ConfigName.PlaceholderText = "Enter config name..."
    ConfigName.TextColor3 = self.Theme.Text
    ConfigName.PlaceholderColor3 = self.Theme.TextDark
    ConfigName.Font = Enum.Font.Gotham
    ConfigName.TextSize = 13
    ConfigName.Parent = ConfigSection
    
    local NameCorner = Instance.new("UICorner")
    NameCorner.CornerRadius = UDim.new(0, 6)
    NameCorner.Parent = ConfigName
    
    local ConfigDropdown = Instance.new("Frame")
    ConfigDropdown.Size = UDim2.new(1, -20, 0, 35)
    ConfigDropdown.Position = UDim2.new(0, 10, 0, 88)
    ConfigDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ConfigDropdown.BorderSizePixel = 0
    ConfigDropdown.ClipsDescendants = true
    ConfigDropdown.Parent = ConfigSection
    
    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 6)
    DropCorner.Parent = ConfigDropdown
    
    local SelectedConfig = Instance.new("TextLabel")
    SelectedConfig.Size = UDim2.new(1, -35, 1, 0)
    SelectedConfig.Position = UDim2.new(0, 10, 0, 0)
    SelectedConfig.BackgroundTransparency = 1
    SelectedConfig.Text = "Select config..."
    SelectedConfig.TextColor3 = self.Theme.TextDark
    SelectedConfig.Font = Enum.Font.Gotham
    SelectedConfig.TextSize = 13
    SelectedConfig.TextXAlignment = Enum.TextXAlignment.Left
    SelectedConfig.Parent = ConfigDropdown
    
    local DropArrow = Instance.new("TextButton")
    DropArrow.Size = UDim2.new(0, 25, 1, 0)
    DropArrow.Position = UDim2.new(1, -25, 0, 0)
    DropArrow.BackgroundTransparency = 1
    DropArrow.Text = "▼"
    DropArrow.TextColor3 = self.Theme.TextDark
    DropArrow.Font = Enum.Font.Gotham
    DropArrow.TextSize = 10
    DropArrow.Parent = ConfigDropdown
    
    local ConfigList = Instance.new("ScrollingFrame")
    ConfigList.Size = UDim2.new(1, 0, 0, 0)
    ConfigList.Position = UDim2.new(0, 0, 1, 3)
    ConfigList.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ConfigList.BorderSizePixel = 0
    ConfigList.ScrollBarThickness = 4
    ConfigList.Visible = false
    ConfigList.CanvasSize = UDim2.new(0, 0, 0, 0)
    ConfigList.Parent = ConfigDropdown
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = ConfigList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = ConfigList
    
    -- GŁÓWNA ZMIANA: updateConfigList teraz działa poprawnie
    local function updateConfigList()
        -- Wyczyść wszystkie istniejące elementy
        for _, child in pairs(ConfigList:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Pobierz listę configów BEZPOŚREDNIO z plików
        local configs = self:GetConfigs()
        
        print("DEBUG: Znaleziono configów:", #configs) -- Debug
        for _, name in pairs(configs) do
            print("  - " .. name) -- Debug
        end
        
        local listHeight = math.max(#configs * 32, 32)
        ConfigList.CanvasSize = UDim2.new(0, 0, 0, listHeight)
        
        if #configs == 0 then
            local NoConfigs = Instance.new("TextLabel")
            NoConfigs.Size = UDim2.new(1, 0, 0, 30)
            NoConfigs.BackgroundTransparency = 1
            NoConfigs.Text = "No configs found"
            NoConfigs.TextColor3 = self.Theme.TextDark
            NoConfigs.Font = Enum.Font.Gotham
            NoConfigs.TextSize = 12
            NoConfigs.Parent = ConfigList
            return
        end
        
        -- Twórz przyciski dla każdego configa
        for _, configName in pairs(configs) do
            local ConfigButton = Instance.new("TextButton")
            ConfigButton.Size = UDim2.new(1, -8, 0, 30)
            ConfigButton.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            ConfigButton.BorderSizePixel = 0
            ConfigButton.Text = configName
            ConfigButton.TextColor3 = self.Theme.Text
            ConfigButton.Font = Enum.Font.Gotham
            ConfigButton.TextSize = 12
            ConfigButton.AutoButtonColor = false
            ConfigButton.Parent = ConfigList
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = ConfigButton
            
            ConfigButton.MouseButton1Click:Connect(function()
                SelectedConfig.Text = configName
                SelectedConfig.TextColor3 = self.Theme.Text
                ConfigList.Visible = false
                TweenService:Create(ConfigDropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, 35)}):Play()
                TweenService:Create(DropArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            end)
            
            ConfigButton.MouseEnter:Connect(function()
                TweenService:Create(ConfigButton, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.Accent}):Play()
            end)
            
            ConfigButton.MouseLeave:Connect(function()
                TweenService:Create(ConfigButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
            end)
        end
    end
    
    -- GŁÓWNA ZMIANA: Odśwież listę za każdym razem gdy dropdown jest otwierany
    DropArrow.MouseButton1Click:Connect(function()
        ConfigList.Visible = not ConfigList.Visible
        
        -- Zawsze odśwież listę gdy otwierasz dropdown
        if ConfigList.Visible then
            updateConfigList()
        end
        
        local configs = self:GetConfigs()
        local listHeight = math.min(math.max(#configs, 1) * 32, 120)
        
        TweenService:Create(ConfigDropdown, TweenInfo.new(0.2), {
            Size = ConfigList.Visible and UDim2.new(1, -20, 0, 35 + listHeight + 3) or UDim2.new(1, -20, 0, 35)
        }):Play()
        
        TweenService:Create(ConfigList, TweenInfo.new(0.2), {
            Size = ConfigList.Visible and UDim2.new(1, 0, 0, listHeight) or UDim2.new(1, 0, 0, 0)
        }):Play()
        
        TweenService:Create(DropArrow, TweenInfo.new(0.2), {
            Rotation = ConfigList.Visible and 180 or 0
        }):Play()
    end)
    
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, -20, 0, 70)
    ButtonContainer.Position = UDim2.new(0, 10, 0, 150)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = ConfigSection
    
    local function createConfigButton(text, position, color, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.48, 0, 0, 30)
        Button.Position = position
        Button.BackgroundColor3 = color
        Button.BorderSizePixel = 0
        Button.Text = text
        Button.TextColor3 = self.Theme.Text
        Button.Font = Enum.Font.GothamSemibold
        Button.TextSize = 13
        Button.AutoButtonColor = false
        Button.Parent = ButtonContainer
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(callback)
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(
                    math.min(color.R * 255 + 20, 255),
                    math.min(color.G * 255 + 20, 255),
                    math.min(color.B * 255 + 20, 255)
                )
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
        end)
        
        return Button
    end
    
    -- GŁÓWNA ZMIANA: Po zapisaniu, nie trzeba już odświeżać - zrobi się to automatycznie gdy użytkownik otworzy dropdown
    createConfigButton("Save", UDim2.new(0, 0, 0, 0), Color3.fromRGB(70, 180, 80), function()
        local name = ConfigName.Text
        if name ~= "" then
            self:SaveConfig(name)
            -- Config został zapisany, lista zostanie odświeżona gdy użytkownik otworzy dropdown
        else
            self:Notify({Title = "Error", Description = "Enter a config name", Duration = 2})
        end
    end)
    
    createConfigButton("Load", UDim2.new(0.52, 0, 0, 0), Color3.fromRGB(85, 170, 255), function()
        if SelectedConfig.Text ~= "Select config..." then
            self:LoadConfig(SelectedConfig.Text)
        else
            self:Notify({Title = "Error", Description = "Select a config first", Duration = 2})
        end
    end)
    
    createConfigButton("Overwrite", UDim2.new(0, 0, 0, 38), Color3.fromRGB(255, 165, 50), function()
        if SelectedConfig.Text ~= "Select config..." then
            self:SaveConfig(SelectedConfig.Text)
            self:Notify({Title = "Config Overwritten", Description = SelectedConfig.Text .. " has been updated", Duration = 2})
        else
            self:Notify({Title = "Error", Description = "Select a config first", Duration = 2})
        end
    end)
    
    createConfigButton("Delete", UDim2.new(0.52, 0, 0, 38), Color3.fromRGB(255, 70, 70), function()
        if SelectedConfig.Text ~= "Select config..." then
            self:DeleteConfig(SelectedConfig.Text)
            SelectedConfig.Text = "Select config..."
            SelectedConfig.TextColor3 = self.Theme.TextDark
            -- Config został usunięty, lista zostanie odświeżona gdy użytkownik otworzy dropdown
        else
            self:Notify({Title = "Error", Description = "Select a config first", Duration = 2})
        end
    end)
    
    TweenService:Create(ConfigSection, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(ConfigLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    table.insert(self.Elements, ConfigSection)
    return ConfigSection
end

function Library:CreateTab(name)
    local Tab = {}
    Tab.Name = name
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "TabButton_" .. name
    TabButton.Size = UDim2.new(0, 120, 1, 0)
    TabButton.BackgroundColor3 = self.Theme.Secondary
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.TextColor3 = self.Theme.Text
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    TabButton.BackgroundTransparency = 1
    TabButton.TextTransparency = 1
    TabButton.Parent = self.TabBar
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer_" .. name
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 5
    TabContainer.ScrollBarImageColor3 = self.Theme.Accent
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Visible = false
    TabContainer.Parent = self.TabContainerHolder
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.Parent = TabContainer
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    Tab.Button = TabButton
    Tab.Container = TabContainer
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Container.Visible = false
            TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.Secondary
            }):Play()
        end
        
        TabContainer.Visible = true
        self.CurrentTab = Tab
        self.Container = TabContainer
        
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Accent
        }):Play()
    end)
    
    TabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= Tab then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(
                    math.min(self.Theme.Secondary.R * 255 + 15, 255),
                    math.min(self.Theme.Secondary.G * 255 + 15, 255),
                    math.min(self.Theme.Secondary.B * 255 + 15, 255)
                )
            }):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= Tab then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.Secondary
            }):Play()
        end
    end)
    
    TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(TabButton, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then
        TabContainer.Visible = true
        self.CurrentTab = Tab
        self.Container = TabContainer
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Accent
        }):Play()
    end
    
    return Tab
end

function Library:CreateButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 0, 42)
    Button.BackgroundColor3 = self.Theme.Secondary
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = self.Theme.Text
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 14
    Button.AutoButtonColor = false
    Button.BackgroundTransparency = 1
    Button.TextTransparency = 1
    Button.Parent = self.Container
    
    CreateShadow(Button)
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Button, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = self.Theme.Accent}):Play()
        wait(0.15)
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Secondary}):Play()
        
        if callback then 
            pcall(callback)
        end
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(
                math.min(self.Theme.Secondary.R * 255 + 15, 255),
                math.min(self.Theme.Secondary.G * 255 + 15, 255),
                math.min(self.Theme.Secondary.B * 255 + 15, 255)
            )
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Secondary}):Play()
    end)
    
    table.insert(self.Elements, Button)
    return Button
end

function Library:CreateToggle(name, default, callback)
    local toggled = default or false
    local configKey = "Toggle_" .. name
    
    local Toggle = Instance.new("Frame")
    Toggle.Name = "Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 42)
    Toggle.BackgroundColor3 = self.Theme.Secondary
    Toggle.BorderSizePixel = 0
    Toggle.BackgroundTransparency = 1
    Toggle.Parent = self.Container
    
    CreateShadow(Toggle)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -65, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = self.Theme.Text
    ToggleLabel.Font = Enum.Font.GothamSemibold
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.TextTransparency = 1
    ToggleLabel.Parent = Toggle
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 44, 0, 22)
    ToggleButton.Position = UDim2.new(1, -54, 0.5, -11)
    ToggleButton.BackgroundColor3 = toggled and self.Theme.Accent or Color3.fromRGB(50, 50, 60)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = Toggle
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    ToggleCircle.BackgroundColor3 = self.Theme.Text
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(ToggleLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    self.ConfigData[configKey] = {
        Value = toggled,
        Callback = function(value)
            toggled = value
            TweenService:Create(ToggleButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                BackgroundColor3 = toggled and self.Theme.Accent or Color3.fromRGB(50, 50, 60)
            }):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            }):Play()
        end
    }
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        self.ConfigData[configKey].Value = toggled
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = toggled and self.Theme.Accent or Color3.fromRGB(50, 50, 60)
        }):Play()
        
        TweenService:Create(ToggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        
        if callback then 
            pcall(callback, toggled)
        end
    end)
    
    table.insert(self.Elements, Toggle)
    return Toggle
end

function Library:CreateKeybind(name, default, callback)
    local currentKey = default or Enum.KeyCode.E
    local binding = false
    local configKey = "Keybind_" .. name
    
    local Keybind = Instance.new("Frame")
    Keybind.Name = "Keybind"
    Keybind.Size = UDim2.new(1, 0, 0, 42)
    Keybind.BackgroundColor3 = self.Theme.Secondary
    Keybind.BorderSizePixel = 0
    Keybind.BackgroundTransparency = 1
    Keybind.Parent = self.Container
    
    CreateShadow(Keybind)
    
    local KeybindCorner = Instance.new("UICorner")
    KeybindCorner.CornerRadius = UDim.new(0, 8)
    KeybindCorner.Parent = Keybind
    
    local KeybindLabel = Instance.new("TextLabel")
    KeybindLabel.Size = UDim2.new(1, -90, 1, 0)
    KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = name
    KeybindLabel.TextColor3 = self.Theme.Text
    KeybindLabel.Font = Enum.Font.GothamSemibold
    KeybindLabel.TextSize = 14
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeybindLabel.TextTransparency = 1
    KeybindLabel.Parent = Keybind
    
    local KeybindDisplay = Instance.new("TextButton")
    KeybindDisplay.Name = "KeybindDisplay"
    KeybindDisplay.Size = UDim2.new(0, 75, 0, 28)
    KeybindDisplay.Position = UDim2.new(1, -85, 0.5, -14)
    KeybindDisplay.BackgroundColor3 = self.Theme.Accent
    KeybindDisplay.BorderSizePixel = 0
    KeybindDisplay.Text = currentKey.Name
    KeybindDisplay.TextColor3 = self.Theme.Text
    KeybindDisplay.Font = Enum.Font.GothamBold
    KeybindDisplay.TextSize = 12
    KeybindDisplay.AutoButtonColor = false
    KeybindDisplay.Parent = Keybind
    
    local DisplayCorner = Instance.new("UICorner")
    DisplayCorner.CornerRadius = UDim.new(0, 6)
    DisplayCorner.Parent = KeybindDisplay
    
    TweenService:Create(Keybind, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(KeybindLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    self.ConfigData[configKey] = {
        Value = currentKey.Name,
        Callback = function(value)
            currentKey = Enum.KeyCode[value]
            KeybindDisplay.Text = currentKey.Name
        end
    }
    
    KeybindDisplay.MouseButton1Click:Connect(function()
        binding = true
        KeybindDisplay.Text = "..."
        TweenService:Create(KeybindDisplay, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        }):Play()
    end)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
            binding = false
            currentKey = input.KeyCode
            KeybindDisplay.Text = currentKey.Name
            self.ConfigData[configKey].Value = currentKey.Name
            
            TweenService:Create(KeybindDisplay, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.Accent
            }):Play()
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == currentKey and not binding then
            if callback then callback() end
        end
    end)
    
    table.insert(self.Elements, Keybind)
    return Keybind
end

function Library:CreateSlider(name, min, max, default, callback)
    local value = default or min
    local configKey = "Slider_" .. name
    
    local Slider = Instance.new("Frame")
    Slider.Name = "Slider"
    Slider.Size = UDim2.new(1, 0, 0, 58)
    Slider.BackgroundColor3 = self.Theme.Secondary
    Slider.BorderSizePixel = 0
    Slider.BackgroundTransparency = 1
    Slider.Parent = self.Container
    
    CreateShadow(Slider)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = Slider
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -70, 0, 22)
    SliderLabel.Position = UDim2.new(0, 12, 0, 8)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name
    SliderLabel.TextColor3 = self.Theme.Text
    SliderLabel.Font = Enum.Font.GothamSemibold
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.TextTransparency = 1
    SliderLabel.Parent = Slider
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "ValueLabel"
    ValueLabel.Size = UDim2.new(0, 55, 0, 22)
    ValueLabel.Position = UDim2.new(1, -65, 0, 8)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(value)
    ValueLabel.TextColor3 = self.Theme.Accent
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.TextTransparency = 1
    ValueLabel.Parent = Slider
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -24, 0, 6)
    SliderBar.Position = UDim2.new(0, 12, 1, -18)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Slider
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = self.Theme.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    TweenService:Create(Slider, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(SliderLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(ValueLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    self.ConfigData[configKey] = {
        Value = value,
        Callback = function(newValue)
            value = newValue
            local percent = (value - min) / (max - min)
            TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = UDim2.new(percent, 0, 1, 0)
            }):Play()
            ValueLabel.Text = tostring(value)
        end
    }
    
    local dragging = false
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = game.Players.LocalPlayer:GetMouse()
            local percent = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * percent)
            self.ConfigData[configKey].Value = value
            
            TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = UDim2.new(percent, 0, 1, 0)
            }):Play()
            ValueLabel.Text = tostring(value)
            
            if callback then callback(value) end
        end
    end)
    
    table.insert(self.Elements, Slider)
    return Slider
end

function Library:CreateTextbox(name, placeholder, callback)
    local Textbox = Instance.new("Frame")
    Textbox.Name = "Textbox"
    Textbox.Size = UDim2.new(1, 0, 0, 42)
    Textbox.BackgroundColor3 = self.Theme.Secondary
    Textbox.BorderSizePixel = 0
    Textbox.BackgroundTransparency = 1
    Textbox.Parent = self.Container
    
    CreateShadow(Textbox)
    
    local TextboxCorner = Instance.new("UICorner")
    TextboxCorner.CornerRadius = UDim.new(0, 8)
    TextboxCorner.Parent = Textbox
    
    local TextboxLabel = Instance.new("TextLabel")
    TextboxLabel.Size = UDim2.new(0, 110, 1, 0)
    TextboxLabel.Position = UDim2.new(0, 12, 0, 0)
    TextboxLabel.BackgroundTransparency = 1
    TextboxLabel.Text = name
    TextboxLabel.TextColor3 = self.Theme.Text
    TextboxLabel.Font = Enum.Font.GothamSemibold
    TextboxLabel.TextSize = 14
    TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextboxLabel.TextTransparency = 1
    TextboxLabel.Parent = Textbox
    
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -136, 0, 32)
    Input.Position = UDim2.new(0, 122, 0.5, -16)
    Input.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Input.BorderSizePixel = 0
    Input.Text = ""
    Input.PlaceholderText = placeholder or "Enter text..."
    Input.TextColor3 = self.Theme.Text
    Input.PlaceholderColor3 = self.Theme.TextDark
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 13
    Input.TextTransparency = 1
    Input.Parent = Textbox
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = Input
    
    TweenService:Create(Textbox, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(TextboxLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(Input, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    Input.Focused:Connect(function()
        TweenService:Create(Input, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Accent}):Play()
    end)
    
    Input.FocusLost:Connect(function(enter)
        TweenService:Create(Input, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        if enter and callback then
            callback(Input.Text)
        end
    end)
    
    table.insert(self.Elements, Textbox)
    return Textbox
end

function Library:CreateDropdown(name, options, callback)
    local selected = options[1] or "None"
    local opened = false
    local configKey = "Dropdown_" .. name
    
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = "Dropdown"
    Dropdown.Size = UDim2.new(1, 0, 0, 42)
    Dropdown.BackgroundColor3 = self.Theme.Secondary
    Dropdown.BorderSizePixel = 0
    Dropdown.ClipsDescendants = true
    Dropdown.BackgroundTransparency = 1
    Dropdown.Parent = self.Container
    
    CreateShadow(Dropdown)
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = Dropdown
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 42)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = Dropdown
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(0.5, -15, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = name
    DropdownLabel.TextColor3 = self.Theme.Text
    DropdownLabel.Font = Enum.Font.GothamSemibold
    DropdownLabel.TextSize = 14
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.TextTransparency = 1
    DropdownLabel.Parent = Dropdown
    
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Name = "SelectedLabel"
    SelectedLabel.Size = UDim2.new(0.5, -24, 1, 0)
    SelectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = selected
    SelectedLabel.TextColor3 = self.Theme.Accent
    SelectedLabel.Font = Enum.Font.GothamSemibold
    SelectedLabel.TextSize = 13
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    SelectedLabel.TextTransparency = 1
    SelectedLabel.Parent = Dropdown
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Name = "Arrow"
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -28, 0.5, -10)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = self.Theme.TextDark
    Arrow.Font = Enum.Font.Gotham
    Arrow.TextSize = 12
    Arrow.TextTransparency = 1
    Arrow.Parent = Dropdown
    
    local OptionsList = Instance.new("Frame")
    OptionsList.Size = UDim2.new(1, 0, 0, #options * 36)
    OptionsList.Position = UDim2.new(0, 0, 0, 42)
    OptionsList.BackgroundTransparency = 1
    OptionsList.Parent = Dropdown
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 3)
    ListLayout.Parent = OptionsList
    
    self.ConfigData[configKey] = {
        Value = selected,
        Callback = function(value)
            selected = value
            SelectedLabel.Text = selected
        end
    }
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, -12, 0, 33)
        OptionButton.Position = UDim2.new(0, 6, 0, 0)
        OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = option
        OptionButton.TextColor3 = self.Theme.Text
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.TextSize = 13
        OptionButton.AutoButtonColor = false
        OptionButton.Parent = OptionsList
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 6)
        OptionCorner.Parent = OptionButton
        
        OptionButton.MouseButton1Click:Connect(function()
            selected = option
            SelectedLabel.Text = selected
            self.ConfigData[configKey].Value = selected
            opened = false
            
            TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, 42)
            }):Play()
            
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            
            if callback then callback(selected) end
        end)
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.15), {BackgroundColor3 = self.Theme.Accent}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
        end)
    end
    
    TweenService:Create(Dropdown, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(DropdownLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(SelectedLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(Arrow, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    DropdownButton.MouseButton1Click:Connect(function()
        opened = not opened
        
        TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = opened and UDim2.new(1, 0, 0, 42 + #options * 36 + 12) or UDim2.new(1, 0, 0, 42)
        }):Play()
        
        TweenService:Create(Arrow, TweenInfo.new(0.2), {
            Rotation = opened and 180 or 0
        }):Play()
    end)
    
    table.insert(self.Elements, Dropdown)
    return Dropdown
end

function Library:CreateColorPicker(name, default, callback)
    local currentColor = default or Color3.fromRGB(255, 255, 255)
    local pickerOpen = false
    local configKey = "ColorPicker_" .. name
    
    local ColorPicker = Instance.new("Frame")
    ColorPicker.Name = "ColorPicker"
    ColorPicker.Size = UDim2.new(1, 0, 0, 42)
    ColorPicker.BackgroundColor3 = self.Theme.Secondary
    ColorPicker.BorderSizePixel = 0
    ColorPicker.BackgroundTransparency = 1
    ColorPicker.ClipsDescendants = true
    ColorPicker.Parent = self.Container
    
    CreateShadow(ColorPicker)
    
    local PickerCorner = Instance.new("UICorner")
    PickerCorner.CornerRadius = UDim.new(0, 8)
    PickerCorner.Parent = ColorPicker
    
    local PickerLabel = Instance.new("TextLabel")
    PickerLabel.Size = UDim2.new(1, -50, 0, 42)
    PickerLabel.Position = UDim2.new(0, 12, 0, 0)
    PickerLabel.BackgroundTransparency = 1
    PickerLabel.Text = name
    PickerLabel.TextColor3 = self.Theme.Text
    PickerLabel.Font = Enum.Font.GothamSemibold
    PickerLabel.TextSize = 14
    PickerLabel.TextXAlignment = Enum.TextXAlignment.Left
    PickerLabel.TextTransparency = 1
    PickerLabel.Parent = ColorPicker
    
    local ColorDisplay = Instance.new("TextButton")
    ColorDisplay.Size = UDim2.new(0, 32, 0, 32)
    ColorDisplay.Position = UDim2.new(1, -42, 0, 5)
    ColorDisplay.BackgroundColor3 = currentColor
    ColorDisplay.BorderSizePixel = 0
    ColorDisplay.Text = ""
    ColorDisplay.AutoButtonColor = false
    ColorDisplay.Parent = ColorPicker
    
    local DisplayCorner = Instance.new("UICorner")
    DisplayCorner.CornerRadius = UDim.new(0, 6)
    DisplayCorner.Parent = ColorDisplay
    
    local ColorWheel = Instance.new("ImageButton")
    ColorWheel.Size = UDim2.new(0, 160, 0, 160)
    ColorWheel.Position = UDim2.new(0.5, -80, 0, 52)
    ColorWheel.BackgroundTransparency = 1
    ColorWheel.Image = "rbxassetid://698052001"
    ColorWheel.AutoButtonColor = false
    ColorWheel.Parent = ColorPicker
    
    local WheelCorner = Instance.new("UICorner")
    WheelCorner.CornerRadius = UDim.new(1, 0)
    WheelCorner.Parent = ColorWheel
    
    local function createSlider(yPos, colorName, colorValue)
        local Slider = Instance.new("Frame")
        Slider.Size = UDim2.new(1, -24, 0, 20)
        Slider.Position = UDim2.new(0, 12, 0, yPos)
        Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        Slider.BorderSizePixel = 0
        Slider.Parent = ColorPicker
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 4)
        Corner.Parent = Slider
        
        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new(colorValue, 0, 1, 0)
        Fill.BackgroundColor3 = colorName == "R" and Color3.fromRGB(255, 0, 0) or 
                                colorName == "G" and Color3.fromRGB(0, 255, 0) or 
                                Color3.fromRGB(0, 0, 255)
        Fill.BorderSizePixel = 0
        Fill.Parent = Slider
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(0, 4)
        FillCorner.Parent = Fill
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 20, 1, 0)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = colorName
        Label.TextColor3 = self.Theme.Text
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 12
        Label.Parent = Slider
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 35, 1, 0)
        ValueLabel.Position = UDim2.new(1, -40, 0, 0)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(math.floor(colorValue * 255))
        ValueLabel.TextColor3 = self.Theme.TextDark
        ValueLabel.Font = Enum.Font.Gotham
        ValueLabel.TextSize = 11
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Slider
        
        return Slider, Fill, ValueLabel
    end
    
    local RSlider, RFill, RValue = createSlider(222, "R", currentColor.R)
    local GSlider, GFill, GValue = createSlider(247, "G", currentColor.G)
    local BSlider, BFill, BValue = createSlider(272, "B", currentColor.B)
    
    TweenService:Create(ColorPicker, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(PickerLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    self.ConfigData[configKey] = {
        Value = {R = currentColor.R, G = currentColor.G, B = currentColor.B},
        Callback = function(value)
            currentColor = Color3.fromRGB(value.R * 255, value.G * 255, value.B * 255)
            ColorDisplay.BackgroundColor3 = currentColor
            RFill.Size = UDim2.new(value.R, 0, 1, 0)
            GFill.Size = UDim2.new(value.G, 0, 1, 0)
            BFill.Size = UDim2.new(value.B, 0, 1, 0)
            RValue.Text = tostring(math.floor(value.R * 255))
            GValue.Text = tostring(math.floor(value.G * 255))
            BValue.Text = tostring(math.floor(value.B * 255))
        end
    }
    
    local function updateColor()
        local r = RFill.Size.X.Scale
        local g = GFill.Size.X.Scale
        local b = BFill.Size.X.Scale
        currentColor = Color3.fromRGB(r * 255, g * 255, b * 255)
        ColorDisplay.BackgroundColor3 = currentColor
        
        RValue.Text = tostring(math.floor(r * 255))
        GValue.Text = tostring(math.floor(g * 255))
        BValue.Text = tostring(math.floor(b * 255))
        
        self.ConfigData[configKey].Value = {R = r, G = g, B = b}
        
        if callback then callback(currentColor) end
    end
    
    local function setupSlider(slider, fill)
        local dragging = false
        
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = game.Players.LocalPlayer:GetMouse()
                local percent = math.clamp((mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                
                TweenService:Create(fill, TweenInfo.new(0.05), {
                    Size = UDim2.new(percent, 0, 1, 0)
                }):Play()
                
                task.wait(0.05)
                updateColor()
            end
        end)
    end
    
    setupSlider(RSlider, RFill)
    setupSlider(GSlider, GFill)
    setupSlider(BSlider, BFill)
    
    ColorWheel.MouseButton1Down:Connect(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local relX = mouse.X - ColorWheel.AbsolutePosition.X
        local relY = mouse.Y - ColorWheel.AbsolutePosition.Y
        
        local centerX = ColorWheel.AbsoluteSize.X / 2
        local centerY = ColorWheel.AbsoluteSize.Y / 2
        
        local angle = math.atan2(relY - centerY, relX - centerX)
        local hue = (angle + math.pi) / (2 * math.pi)
        
        local color = Color3.fromHSV(hue, 1, 1)
        
        RFill.Size = UDim2.new(color.R, 0, 1, 0)
        GFill.Size = UDim2.new(color.G, 0, 1, 0)
        BFill.Size = UDim2.new(color.B, 0, 1, 0)
        
        updateColor()
    end)
    
    ColorDisplay.MouseButton1Click:Connect(function()
        pickerOpen = not pickerOpen
        
        TweenService:Create(ColorPicker, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = pickerOpen and UDim2.new(1, 0, 0, 305) or UDim2.new(1, 0, 0, 42)
        }):Play()
    end)
    
    table.insert(self.Elements, ColorPicker)
    return ColorPicker
end

function Library:CreateThemeEditor()
    local ThemeWindow = self:CreateWindow({Title = "Theme Editor", Size = UDim2.new(0, 450, 0, 450)})
    
    local ColorsTab = ThemeWindow:CreateTab("Colors")
    
    ThemeWindow.Container = ColorsTab.Container
    
    ThemeWindow:CreateColorPicker("Background Color", self.Theme.Background, function(color)
        self.Theme.Background = color
        self:UpdateTheme()
    end)
    
    ThemeWindow:CreateColorPicker("Secondary Color", self.Theme.Secondary, function(color)
        self.Theme.Secondary = color
        self:UpdateTheme()
    end)
    
    ThemeWindow:CreateColorPicker("Accent Color", self.Theme.Accent, function(color)
        self.Theme.Accent = color
        self:UpdateTheme()
    end)
    
    ThemeWindow:CreateColorPicker("Text Color", self.Theme.Text, function(color)
        self.Theme.Text = color
        self:UpdateTheme()
    end)
    
    local PresetsTab = ThemeWindow:CreateTab("Presets")
    ThemeWindow.Container = PresetsTab.Container
    
    ThemeWindow:CreateButton("Dark Blue", function()
        self:SetTheme({
            Background = Color3.fromRGB(25, 25, 35),
            Secondary = Color3.fromRGB(35, 35, 45),
            Accent = Color3.fromRGB(85, 170, 255)
        })
    end)
    
    ThemeWindow:CreateButton("Purple Dream", function()
        self:SetTheme({
            Background = Color3.fromRGB(30, 20, 40),
            Secondary = Color3.fromRGB(40, 30, 50),
            Accent = Color3.fromRGB(180, 100, 255)
        })
    end)
    
    ThemeWindow:CreateButton("Green Matrix", function()
        self:SetTheme({
            Background = Color3.fromRGB(15, 25, 15),
            Secondary = Color3.fromRGB(20, 35, 20),
            Accent = Color3.fromRGB(50, 255, 100)
        })
    end)
    
    ThemeWindow:CreateButton("Red Danger", function()
        self:SetTheme({
            Background = Color3.fromRGB(30, 15, 15),
            Secondary = Color3.fromRGB(40, 20, 20),
            Accent = Color3.fromRGB(255, 70, 70)
        })
    end)
    
    ThemeWindow:CreateButton("Cyan Wave", function()
        self:SetTheme({
            Background = Color3.fromRGB(15, 25, 30),
            Secondary = Color3.fromRGB(20, 35, 40),
            Accent = Color3.fromRGB(0, 255, 255)
        })
    end)
    
    ThemeWindow:CreateButton("Orange Sunset", function()
        self:SetTheme({
            Background = Color3.fromRGB(30, 20, 15),
            Secondary = Color3.fromRGB(40, 30, 20),
            Accent = Color3.fromRGB(255, 150, 50)
        })
    end)
    
    return ThemeWindow
end

return Library

