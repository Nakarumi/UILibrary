-- Roblox GUI Library v2.5
-- Użycie: loadstring(game:HttpGet("URL_DO_TEGO_SKRYPTU"))()

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

-- Domyślne kolory (można je łatwo zmienić)
Library.Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(85, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- Notification System
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
    
    -- Oblicz wysokość na podstawie opisu
    local height = description ~= "" and 70 or 45
    
    -- Przesuń istniejące notyfikacje w górę
    for _, notif in pairs(ScreenGui:GetChildren()) do
        if notif:IsA("Frame") and notif ~= Notification then
            TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(notif.Position.X.Scale, notif.Position.X.Offset, 
                                     notif.Position.Y.Scale, notif.Position.Y.Offset - height - 10)
            }):Play()
        end
    end
    
    -- Animacja wejścia
    TweenService:Create(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, height),
        Position = UDim2.new(1, -320, 1, -20 - height),
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(DescLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    -- Animacja wyjścia
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

-- Funkcja do zmiany koloru w czasie rzeczywistym
function Library:SetTheme(theme)
    for key, value in pairs(theme) do
        if self.Theme[key] then
            self.Theme[key] = value
        end
    end
    
    if self.Elements then
        self:UpdateTheme()
    end
end

-- Aktualizacja motywu
function Library:UpdateTheme()
    if self.Main then
        TweenService:Create(self.Main, TweenInfo.new(0.3), {BackgroundColor3 = self.Theme.Background}):Play()
    end
    
    if self.TitleBar then
        TweenService:Create(self.TitleBar, TweenInfo.new(0.3), {BackgroundColor3 = self.Theme.Secondary}):Play()
        local TitleFix = self.TitleBar:FindFirstChild("TitleFix")
        if TitleFix then
            TweenService:Create(TitleFix, TweenInfo.new(0.3), {BackgroundColor3 = self.Theme.Secondary}):Play()
        end
    end
    
    if self.Container then
        TweenService:Create(self.Container, TweenInfo.new(0.3), {ScrollBarImageColor3 = self.Theme.Accent}):Play()
    end
    
    for _, element in pairs(self.Elements) do
        if element and element.Parent then
            if element:IsA("Frame") or element:IsA("TextButton") then
                TweenService:Create(element, TweenInfo.new(0.3), {BackgroundColor3 = self.Theme.Secondary}):Play()
            end
            
            for _, child in pairs(element:GetDescendants()) do
                if child:IsA("TextLabel") then
                    if child.Name == "SectionLabel" then
                        TweenService:Create(child, TweenInfo.new(0.3), {TextColor3 = self.Theme.Accent}):Play()
                    elseif child.Name == "ValueLabel" or child.Name == "SelectedLabel" then
                        TweenService:Create(child, TweenInfo.new(0.3), {TextColor3 = self.Theme.Accent}):Play()
                    elseif child.Name ~= "Arrow" then
                        TweenService:Create(child, TweenInfo.new(0.3), {TextColor3 = self.Theme.Text}):Play()
                    end
                end
                
                if child.Name == "SliderFill" then
                    TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = self.Theme.Accent}):Play()
                elseif child.Name == "ToggleButton" then
                    if child.BackgroundColor3 ~= Color3.fromRGB(50, 50, 60) then
                        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = self.Theme.Accent}):Play()
                    end
                elseif child.Name == "KeybindDisplay" then
                    TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = self.Theme.Accent}):Play()
                end
            end
        end
    end
end

-- Funkcja pomocnicza do tworzenia cienia
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

-- Funkcja do tworzenia głównego okna
function Library:CreateWindow(config)
    local Window = setmetatable({}, {__index = self})
    Window.Elements = {}
    Window.Theme = self.Theme
    Window.ToggleKey = Enum.KeyCode.RightControl
    
    local title = type(config) == "string" and config or config.Title or "GUI Library"
    local size = type(config) == "table" and config.Size or UDim2.new(0, 500, 0, 400)
    local toggleKey = type(config) == "table" and config.ToggleKey or Enum.KeyCode.RightControl
    
    Window.ToggleKey = toggleKey
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LibraryGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Window.Theme.Background
    Main.BorderSizePixel = 0
    Main.BackgroundTransparency = 1
    Main.Parent = ScreenGui
    
    CreateShadow(Main)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Main
    
    -- Title Bar
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
    
    -- Close Button
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
    
    -- Container
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -24, 1, -65)
    Container.Position = UDim2.new(0, 12, 0, 55)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 5
    Container.ScrollBarImageColor3 = Window.Theme.Accent
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = Main
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 10)
    Layout.Parent = Container
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Dragging
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
    
    -- Toggle GUI z keybindem
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Window.ToggleKey then
            local visible = Main.BackgroundTransparency == 0
            
            if visible then
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
    
    Window.Container = Container
    Window.Main = Main
    Window.TitleBar = TitleBar
    
    -- Animacja wejścia
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

-- Tworzenie sekcji
function Library:CreateSection(name)
    local Section = Instance.new("Frame")
    Section.Name = "Section"
    Section.Size = UDim2.new(1, 0, 0, 38)
    Section.BackgroundColor3 = self.Theme.Secondary
    Section.BorderSizePixel = 0
    Section.BackgroundTransparency = 1
    Section.Parent = self.Container
    
    CreateShadow(Section)
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Name = "SectionLabel"
    SectionLabel.Size = UDim2.new(1, -20, 1, 0)
    SectionLabel.Position = UDim2.new(0, 12, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = name
    SectionLabel.TextColor3 = self.Theme.Accent
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 15
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.TextTransparency = 1
    SectionLabel.Parent = Section
    
    TweenService:Create(Section, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(SectionLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    table.insert(self.Elements, Section)
    return Section
end

-- Tworzenie buttona
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
        
        if callback then callback() end
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

-- Tworzenie toggle
function Library:CreateToggle(name, default, callback)
    local toggled = default or false
    
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
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = toggled and self.Theme.Accent or Color3.fromRGB(50, 50, 60)
        }):Play()
        
        TweenService:Create(ToggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        
        if callback then callback(toggled) end
    end)
    
    table.insert(self.Elements, Toggle)
    return Toggle
end

-- Tworzenie keybindu
function Library:CreateKeybind(name, default, callback)
    local currentKey = default or Enum.KeyCode.E
    local binding = false
    
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

-- Tworzenie slidera
function Library:CreateSlider(name, min, max, default, callback)
    local value = default or min
    
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

-- Tworzenie textboxa
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

-- Tworzenie dropdownu
function Library:CreateDropdown(name, options, callback)
    local selected = options[1] or "None"
    local opened = false
    
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

-- Color Picker z kołem kolorów
function Library:CreateColorPicker(name, default, callback)
    local currentColor = default or Color3.fromRGB(255, 255, 255)
    local pickerOpen = false
    
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
    
    -- Koło kolorów
    local ColorWheel = Instance.new("Frame")
    ColorWheel.Size = UDim2.new(0, 180, 0, 180)
    ColorWheel.Position = UDim2.new(0.5, -90, 0, 52)
    ColorWheel.BackgroundTransparency = 1
    ColorWheel.Parent = ColorPicker
    
    local WheelImage = Instance.new("ImageLabel")
    WheelImage.Size = UDim2.new(1, 0, 1, 0)
    WheelImage.BackgroundTransparency = 1
    WheelImage.Image = "rbxassetid://698052001"
    WheelImage.Parent = ColorWheel
    
    local WheelCorner = Instance.new("UICorner")
    WheelCorner.CornerRadius = UDim.new(1, 0)
    WheelCorner.Parent = WheelImage
    
    -- RGB Sliders
    local RSlider = Instance.new("Frame")
    RSlider.Size = UDim2.new(1, -24, 0, 20)
    RSlider.Position = UDim2.new(0, 12, 0, 242)
    RSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    RSlider.BorderSizePixel = 0
    RSlider.Parent = ColorPicker
    
    local RCorner = Instance.new("UICorner")
    RCorner.CornerRadius = UDim.new(0, 4)
    RCorner.Parent = RSlider
    
    local RFill = Instance.new("Frame")
    RFill.Size = UDim2.new(currentColor.R, 0, 1, 0)
    RFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    RFill.BorderSizePixel = 0
    RFill.Parent = RSlider
    
    local RFillCorner = Instance.new("UICorner")
    RFillCorner.CornerRadius = UDim.new(0, 4)
    RFillCorner.Parent = RFill
    
    local RLabel = Instance.new("TextLabel")
    RLabel.Size = UDim2.new(0, 15, 1, 0)
    RLabel.Position = UDim2.new(0, 5, 0, 0)
    RLabel.BackgroundTransparency = 1
    RLabel.Text = "R"
    RLabel.TextColor3 = self.Theme.Text
    RLabel.Font = Enum.Font.GothamBold
    RLabel.TextSize = 12
    RLabel.Parent = RSlider
    
    TweenService:Create(ColorPicker, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(PickerLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    ColorDisplay.MouseButton1Click:Connect(function()
        pickerOpen = not pickerOpen
        
        TweenService:Create(ColorPicker, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = pickerOpen and UDim2.new(1, 0, 0, 300) or UDim2.new(1, 0, 0, 42)
        }):Play()
    end)
    
    table.insert(self.Elements, ColorPicker)
    return ColorPicker
end

return Library
