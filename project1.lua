
local TestHub = {}
TestHub.Config = {
    HubName = "Test Hub",
    DefaultColor = Color3.fromRGB(138, 43, 226),
    BackgroundColor = Color3.fromRGB(20, 20, 25),
    SecondaryColor = Color3.fromRGB(30, 30, 35),
    Settings = {}
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local toggleCallbacks = {}
local sliderCallbacks = {}
local uiElements = {}
local currentTab = nil
local tabs = {}

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local configFolder = "TestHub"
if not isfolder(configFolder) then
    makefolder(configFolder)
end

local function CreateNotification(message, duration)
    local ScreenGui = playerGui:FindFirstChild("TestHubUI")
    if not ScreenGui then return end
    
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 300, 0, 60)
    Notification.Position = UDim2.new(1, -310, 0, 10)
    Notification.BackgroundColor3 = TestHub.Config.SecondaryColor
    Notification.BorderSizePixel = 0
    Notification.ZIndex = 1000
    Notification.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = Notification
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = TestHub.Config.DefaultColor
    NotifStroke.Thickness = 2
    NotifStroke.Parent = Notification
    
    local NotifLabel = Instance.new("TextLabel")
    NotifLabel.Size = UDim2.new(1, -20, 1, -20)
    NotifLabel.Position = UDim2.new(0, 10, 0, 10)
    NotifLabel.BackgroundTransparency = 1
    NotifLabel.Text = message
    NotifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifLabel.Font = Enum.Font.GothamBold
    NotifLabel.TextSize = 14
    NotifLabel.TextWrapped = true
    NotifLabel.TextXAlignment = Enum.TextXAlignment.Center
    NotifLabel.Parent = Notification
    
    Notification.Position = UDim2.new(1, 0, 0, 10)
    TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -310, 0, 10)
    }):Play()
    
    wait(duration or 3)
    TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, 0, 0, 10)
    }):Play()
    wait(0.3)
    Notification:Destroy()
end

local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TestHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MobileToggleButton = Instance.new("ImageButton")
    MobileToggleButton.Name = "MobileToggleButton"
    MobileToggleButton.Size = UDim2.new(0, 50, 0, 50)
    MobileToggleButton.Position = UDim2.new(0, 10, 0, 10)
    MobileToggleButton.BackgroundColor3 = TestHub.Config.SecondaryColor
    MobileToggleButton.Image = "rbxassetid://7733674079"
    MobileToggleButton.ImageColor3 = TestHub.Config.DefaultColor
    MobileToggleButton.ZIndex = 1001
    MobileToggleButton.Visible = isMobile
    MobileToggleButton.Parent = ScreenGui
    
    local MobileToggleCorner = Instance.new("UICorner")
    MobileToggleCorner.CornerRadius = UDim.new(0, 10)
    MobileToggleCorner.Parent = MobileToggleButton
    
    local MobileToggleStroke = Instance.new("UIStroke")
    MobileToggleStroke.Color = TestHub.Config.DefaultColor
    MobileToggleStroke.Thickness = 2
    MobileToggleStroke.Parent = MobileToggleButton
    
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(1, 0, 1, 0)
    MainContainer.BackgroundTransparency = 1
    MainContainer.Parent = ScreenGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    if isMobile then
        MainFrame.Size = UDim2.new(0.95, 0, 0.8, 0)
        MainFrame.Position = UDim2.new(0.025, 0, 0.1, 0)
    else
        MainFrame.Size = UDim2.new(0, 900, 0, 600)
        MainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
    end
    MainFrame.BackgroundColor3 = TestHub.Config.BackgroundColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = MainContainer
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = TestHub.Config.SecondaryColor
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 12)
    TopBarCover.Position = UDim2.new(0, 0, 1, -12)
    TopBarCover.BackgroundColor3 = TestHub.Config.SecondaryColor
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar
    
    local HubIcon = Instance.new("ImageLabel")
    HubIcon.Name = "HubIcon"
    HubIcon.Size = UDim2.new(0, 32, 0, 32)
    HubIcon.Position = UDim2.new(0, 15, 0, 9)
    HubIcon.BackgroundTransparency = 1
    HubIcon.Image = "rbxassetid://7733674079"
    HubIcon.ImageColor3 = TestHub.Config.DefaultColor
    HubIcon.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 55, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TestHub.Config.HubName
    Title.TextColor3 = TestHub.Config.DefaultColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 300, 1, 0)
    TabContainer.Position = UDim2.new(1, -310, 0, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = TopBar
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -60)
    ContentContainer.Position = UDim2.new(0, 10, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    local mobileDragging = false
    local mobileDragInput, mobileDragStart, mobileStartPos
    local wasDragged = false
    local dragThreshold = 10
    
    MobileToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mobileDragging = true
            wasDragged = false
            mobileDragStart = input.Position
            mobileStartPos = MobileToggleButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    mobileDragging = false
                    
                    if not wasDragged then
                        MainContainer.Visible = not MainContainer.Visible
                    end
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if mobileDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            mobileDragInput = input
            
            if mobileDragStart then
                local delta = input.Position - mobileDragStart
                local distance = math.sqrt(delta.X * delta.X + delta.Y * delta.Y)
                
                if distance > dragThreshold then
                    wasDragged = true
                end
            end
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if mobileDragging and mobileDragInput and wasDragged then
            local delta = mobileDragInput.Position - mobileDragStart
            MobileToggleButton.Position = UDim2.new(
                mobileStartPos.X.Scale,
                mobileStartPos.X.Offset + delta.X,
                mobileStartPos.Y.Scale,
                mobileStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
            MainContainer.Visible = not MainContainer.Visible
        end
    end)
    
    local dragging = false
    local dragInput, mousePos, framePos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - mousePos
            MainFrame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
    
    return ScreenGui, MainFrame, TabContainer, ContentContainer, Title, HubIcon, MobileToggleButton
end

local function CreateTab(parent, name, icon, contentContainer)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(0, 90, 1, -10)
    TabButton.BackgroundColor3 = TestHub.Config.BackgroundColor
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    TabButton.Parent = parent

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = name .. "Content"
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false
    ContentFrame.Parent = contentContainer
    
    local LeftColumn = Instance.new("ScrollingFrame")
    LeftColumn.Name = "LeftColumn"
    LeftColumn.Size = UDim2.new(0.48, -5, 1, 0)
    LeftColumn.Position = UDim2.new(0, 10, 0, 0)
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.BorderSizePixel = 0
    LeftColumn.ScrollBarThickness = 8
    LeftColumn.ScrollBarImageColor3 = TestHub.Config.DefaultColor
    LeftColumn.ScrollBarImageTransparency = 0.5
    LeftColumn.ScrollingEnabled = true
    LeftColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
    LeftColumn.Parent = ContentFrame

    local LeftPadding = Instance.new("UIPadding")
    LeftPadding.PaddingTop = UDim.new(0, 4)
    LeftPadding.PaddingLeft = UDim.new(0, 3)
    LeftPadding.PaddingRight = UDim.new(0, 15)
    LeftPadding.PaddingBottom = UDim.new(0, 4)
    LeftPadding.Parent = LeftColumn

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.Padding = UDim.new(0, 10)
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.Parent = LeftColumn

    local VerticalDivider = Instance.new("Frame")
    VerticalDivider.Name = "VerticalDivider"
    VerticalDivider.Size = UDim2.new(0, 2, 1, 0)
    VerticalDivider.Position = UDim2.new(0.5, -1, 0, 0)
    VerticalDivider.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    VerticalDivider.BorderSizePixel = 0
    VerticalDivider.Parent = ContentFrame

    local RightColumn = Instance.new("ScrollingFrame")
    RightColumn.Name = "RightColumn"
    RightColumn.Size = UDim2.new(0.48, -5, 1, 0)
    RightColumn.Position = UDim2.new(1, -10, 0, 0)
    RightColumn.AnchorPoint = Vector2.new(1, 0)
    RightColumn.BackgroundTransparency = 1
    RightColumn.BorderSizePixel = 0
    RightColumn.ScrollBarThickness = 8
    RightColumn.ScrollBarImageColor3 = TestHub.Config.DefaultColor
    RightColumn.ScrollBarImageTransparency = 0.5
    RightColumn.ScrollingEnabled = true
    RightColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
    RightColumn.Parent = ContentFrame

    local RightPadding = Instance.new("UIPadding")
    RightPadding.PaddingTop = UDim.new(0, 4)
    RightPadding.PaddingLeft = UDim.new(0, 15)
    RightPadding.PaddingRight = UDim.new(0, 3)
    RightPadding.PaddingBottom = UDim.new(0, 4)
    RightPadding.Parent = RightColumn

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.Padding = UDim.new(0, 10)
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Parent = RightColumn

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.Button.BackgroundColor3 = TestHub.Config.BackgroundColor
            tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            tab.Content.Visible = false
        end
        
        TabButton.BackgroundColor3 = TestHub.Config.DefaultColor
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ContentFrame.Visible = true
        currentTab = name
    end)
    
    local tabData = {
        Button = TabButton,
        Content = ContentFrame,
        LeftColumn = LeftColumn,
        RightColumn = RightColumn,
        LeftCount = 0,
        RightCount = 0,
        CreateDivider = function(self)
            local column = self.LeftColumn
            if self.LeftCount > self.RightCount then
                column = self.RightColumn
                self.RightCount = self.RightCount + 1
            else
                self.LeftCount = self.LeftCount + 1
            end
            
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, 0, 0, 2)
            Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            Divider.BorderSizePixel = 0
            Divider.Parent = column
            
            return Divider
        end,
        CreateButton = function(self, options)
            local column = self.LeftColumn
            if self.LeftCount > self.RightCount then
                column = self.RightColumn
                self.RightCount = self.RightCount + 1
            else
                self.LeftCount = self.LeftCount + 1
            end
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.BackgroundColor3 = TestHub.Config.DefaultColor
            Button.Text = options.Name
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.AutoButtonColor = false
            Button.Parent = column
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            table.insert(uiElements, {element = Button, type = "button"})
            
            Button.MouseButton1Click:Connect(function()
                if options.Callback then 
                    options.Callback() 
                end
                
                local originalSize = Button.Size
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 33)}):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = originalSize}):Play()
            end)
            
            Button.MouseEnter:Connect(function()
                local brightColor = Color3.fromRGB(
                    math.clamp(TestHub.Config.DefaultColor.R * 255 + 20, 0, 255),
                    math.clamp(TestHub.Config.DefaultColor.G * 255 + 20, 0, 255),
                    math.clamp(TestHub.Config.DefaultColor.B * 255 + 20, 0, 255)
                )
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = brightColor}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = TestHub.Config.DefaultColor}):Play()
            end)
            
            return Button
        end,
        CreateToggle = function(self, options)
            local column = self.LeftColumn
            if self.LeftCount > self.RightCount then
                column = self.RightColumn
                self.RightCount = self.RightCount + 1
            else
                self.LeftCount = self.LeftCount + 1
            end
            
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 35)
            Container.BackgroundColor3 = TestHub.Config.SecondaryColor
            Container.BorderSizePixel = 0
            Container.Parent = column
            
            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(0, 6)
            ContainerCorner.Parent = Container
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name
            Label.TextColor3 = Color3.fromRGB(150, 150, 150)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(0, 40, 0, 20)
            ToggleFrame.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Container
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Size = UDim2.new(0, 16, 0, 16)
            ToggleButton.Position = UDim2.new(0, 2, 0.5, -8)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleButton
            
            local toggled = options.CurrentValue or false
            
            table.insert(uiElements, {element = ToggleFrame, type = "toggle", toggled = toggled, name = options.Name, button = ToggleButton, label = Label})
            
            local function UpdateToggle(animate)
                if toggled then
                    if animate then
                        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = TestHub.Config.DefaultColor}):Play()
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                        TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    else
                        ToggleFrame.BackgroundColor3 = TestHub.Config.DefaultColor
                        ToggleButton.Position = UDim2.new(1, -18, 0.5, -8)
                        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                else
                    if animate then
                        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                        TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    else
                        ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                        ToggleButton.Position = UDim2.new(0, 2, 0.5, -8)
                        Label.TextColor3 = Color3.fromRGB(150, 150, 150)
                    end
                end
                if options.Callback then 
                    options.Callback(toggled) 
                end
                TestHub.Config.Settings[options.Name] = toggled
            end
            
            toggleCallbacks[options.Name] = function(state)
                toggled = state
                for _, item in pairs(uiElements) do
                    if item.element == ToggleFrame then
                        item.toggled = state
                    end
                end
                UpdateToggle(false)
            end
            
            UpdateToggle(false)
            
            local ClickDetector = Instance.new("TextButton")
            ClickDetector.Size = UDim2.new(1, 0, 1, 0)
            ClickDetector.BackgroundTransparency = 1
            ClickDetector.Text = ""
            ClickDetector.Parent = Container
            
            ClickDetector.MouseButton1Click:Connect(function()
                toggled = not toggled
                for _, item in pairs(uiElements) do
                    if item.element == ToggleFrame then
                        item.toggled = toggled
                    end
                end
                UpdateToggle(true)
            end)
            
            return Container
        end,
        CreateSlider = function(self, options)
            local column = self.LeftColumn
            if self.LeftCount > self.RightCount then
                column = self.RightColumn
                self.RightCount = self.RightCount + 1
            else
                self.LeftCount = self.LeftCount + 1
            end
            
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 75)
            Container.BackgroundColor3 = TestHub.Config.SecondaryColor
            Container.BorderSizePixel = 0
            Container.Parent = column
            
            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(0, 6)
            ContainerCorner.Parent = Container
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container
            
            local ValueBox = Instance.new("TextBox")
            ValueBox.Size = UDim2.new(0, 50, 0, 20)
            ValueBox.Position = UDim2.new(1, -55, 0, 5)
            ValueBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            ValueBox.Text = tostring(options.CurrentValue)
            ValueBox.TextColor3 = TestHub.Config.DefaultColor
            ValueBox.Font = Enum.Font.GothamBold
            ValueBox.TextSize = 14
            ValueBox.TextXAlignment = Enum.TextXAlignment.Center
            ValueBox.ClearTextOnFocus = false
            ValueBox.Parent = Container
            
            local ValueBoxCorner = Instance.new("UICorner")
            ValueBoxCorner.CornerRadius = UDim.new(0, 4)
            ValueBoxCorner.Parent = ValueBox
            
            local SliderBack = Instance.new("Frame")
            SliderBack.Size = UDim2.new(1, -30, 0, 6)
            SliderBack.Position = UDim2.new(0, 15, 1, -30)
            SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            SliderBack.BorderSizePixel = 0
            SliderBack.Parent = Container
            
            local SliderBackCorner = Instance.new("UICorner")
            SliderBackCorner.CornerRadius = UDim.new(1, 0)
            SliderBackCorner.Parent = SliderBack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((options.CurrentValue - options.Min) / (options.Max - options.Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBack
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderGradient = Instance.new("UIGradient")
            SliderGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1, TestHub.Config.DefaultColor)
            })
            SliderGradient.Parent = SliderFill
            
            local SliderDot = Instance.new("Frame")
            SliderDot.Size = UDim2.new(0, 14, 0, 14)
            SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderDot.Position = UDim2.new((options.CurrentValue - options.Min) / (options.Max - options.Min), 0, 0.5, 0)
            SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderDot.BorderSizePixel = 0
            SliderDot.Parent = SliderBack
            
            local SliderDotCorner = Instance.new("UICorner")
            SliderDotCorner.CornerRadius = UDim.new(1, 0)
            SliderDotCorner.Parent = SliderDot
            
            table.insert(uiElements, {
                element = SliderFill, 
                type = "slider", 
                name = options.Name, 
                value = options.CurrentValue, 
                min = options.Min, 
                max = options.Max, 
                valueBox = ValueBox, 
                dot = SliderDot,
                gradient = SliderGradient,
                fill = SliderFill
            })
            table.insert(uiElements, {element = ValueBox, type = "textbox"})
            
            local dragging = false
            
            local function UpdateSlider(value)
                value = math.clamp(value, options.Min, options.Max)
                local percent = (value - options.Min) / (options.Max - options.Min)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderDot.Position = UDim2.new(percent, 0, 0.5, 0)
                ValueBox.Text = tostring(value)
                if options.Callback then
                    options.Callback(value)
                end
                TestHub.Config.Settings[options.Name] = value
            end
            
            sliderCallbacks[options.Name] = function(value)
                UpdateSlider(value)
            end
            
            ValueBox.FocusLost:Connect(function(enterPressed)
                local newValue = tonumber(ValueBox.Text)
                if newValue then
                    newValue = math.clamp(math.floor(newValue), options.Min, options.Max)
                    UpdateSlider(newValue)
                    
                    for _, item in pairs(uiElements) do
                        if item.element == SliderFill and item.name == options.Name then
                            item.value = newValue
                        end
                    end
                else
                    ValueBox.Text = tostring(TestHub.Config.Settings[options.Name] or options.CurrentValue)
                end
            end)
            
            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = input.Position.X
                    local sliderPos = SliderBack.AbsolutePosition.X
                    local sliderSize = SliderBack.AbsoluteSize.X
                    local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                    local actualValue = math.floor(options.Min + (options.Max - options.Min) * value)
                    
                    UpdateSlider(actualValue)
                    
                    for _, item in pairs(uiElements) do
                        if item.element == SliderFill and item.name == options.Name then
                            item.value = actualValue
                        end
                    end
                end
            end)
            
            return Container
        end,
        CreateDropdown = function(self, options)
            local column = self.LeftColumn
            if self.LeftCount > self.RightCount then
                column = self.RightColumn
                self.RightCount = self.RightCount + 1
            else
                self.LeftCount = self.LeftCount + 1
            end
            
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 35)
            Container.BackgroundColor3 = TestHub.Config.SecondaryColor
            Container.BorderSizePixel = 0
            Container.Parent = column
            
            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(0, 6)
            ContainerCorner.Parent = Container
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, -10, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0.5, -15, 0, 28)
            DropdownButton.Position = UDim2.new(0.5, 5, 0, 3.5)
            DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            DropdownButton.Text = options.CurrentOption
            DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 13
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = Container
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownButton
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Size = UDim2.new(0, 15, 0, 15)
            Arrow.Position = UDim2.new(1, -16, 0, (DropdownButton.Size.Y.Offset - 14) / 2)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = "rbxassetid://10709790948"
            Arrow.ImageColor3 = Color3.fromRGB(150, 150, 150)
            Arrow.ScaleType = Enum.ScaleType.Fit
            Arrow.Parent = DropdownButton

            local OptionsList = Instance.new("ScrollingFrame")
            OptionsList.Size = UDim2.new(0.5, -15, 0, math.min(#options.Options * 30, 150))
            OptionsList.Position = UDim2.new(0.5, 5, 0, 38)
            OptionsList.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            OptionsList.BorderSizePixel = 0
            OptionsList.Visible = false
            OptionsList.ZIndex = 5
            OptionsList.ScrollBarThickness = 4
            OptionsList.ScrollBarImageColor3 = TestHub.Config.DefaultColor
            OptionsList.Parent = Container
            
            local OptionsCorner = Instance.new("UICorner")
            OptionsCorner.CornerRadius = UDim.new(0, 6)
            OptionsCorner.Parent = OptionsList
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Parent = OptionsList
            
            Container.Size = UDim2.new(1, 0, 0, 35)
            
            DropdownButton.MouseButton1Click:Connect(function()
                OptionsList.Visible = not OptionsList.Visible
                if OptionsList.Visible then
                    Container.Size = UDim2.new(1, 0, 0, 35 + math.min(#options.Options * 30, 150) + 8)
                    Arrow.Rotation = 180
                else
                    Container.Size = UDim2.new(1, 0, 0, 35)
                    Arrow.Rotation = 0
                end
            end)
            
            local dropdown = {
                Button = DropdownButton,
                UpdateOptions = function(newOptions)
                    for _, child in pairs(OptionsList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for i, option in ipairs(newOptions) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Size = UDim2.new(1, 0, 0, 30)
                        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                        OptionButton.Text = option
                        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.TextSize = 13
                        OptionButton.AutoButtonColor = false
                        OptionButton.Parent = OptionsList
                        
                        OptionButton.MouseEnter:Connect(function()
                            OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                        end)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            DropdownButton.Text = option
                            OptionsList.Visible = false
                            Container.Size = UDim2.new(1, 0, 0, 35)
                            Arrow.Rotation = 0
                            if options.Callback then 
                                options.Callback(option) 
                            end
                            TestHub.Config.Settings[options.Name] = option
                        end)
                    end
                    
                    OptionsList.CanvasSize = UDim2.new(0, 0, 0, #newOptions * 30)
                end
            }
            
            dropdown.UpdateOptions(options.Options)
            
            return Container, dropdown
        end,
        CreateColorPicker = function(self, options)
            local column = self.LeftColumn
            if self.LeftCount > self.RightCount then
                column = self.RightColumn
                self.RightCount = self.RightCount + 1
            else
                self.LeftCount = self.LeftCount + 1
            end
            
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 35)
            Container.BackgroundColor3 = TestHub.Config.SecondaryColor
            Container.BorderSizePixel = 0
            Container.Parent = column
            
            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(0, 6)
            ContainerCorner.Parent = Container
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Size = UDim2.new(0, 35, 0, 25)
            ColorDisplay.Position = UDim2.new(1, -40, 0.5, -12.5)
            ColorDisplay.BackgroundColor3 = options.CurrentColor or TestHub.Config.DefaultColor
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = Container
            
            local ColorDisplayCorner = Instance.new("UICorner")
            ColorDisplayCorner.CornerRadius = UDim.new(0, 6)
            ColorDisplayCorner.Parent = ColorDisplay
            
            local ColorDisplayStroke = Instance.new("UIStroke")
            ColorDisplayStroke.Color = Color3.fromRGB(100, 100, 105)
            ColorDisplayStroke.Thickness = 1
            ColorDisplayStroke.Parent = ColorDisplay
            
            local ColorPickerPopup = Instance.new("Frame")
            ColorPickerPopup.Name = "ColorPickerPopup"
            ColorPickerPopup.Size = UDim2.new(0, 280, 0, 340)
            ColorPickerPopup.Position = UDim2.new(0.5, -140, 0.5, -170)
            ColorPickerPopup.BackgroundColor3 = TestHub.Config.BackgroundColor
            ColorPickerPopup.BorderSizePixel = 0
            ColorPickerPopup.Visible = false
            ColorPickerPopup.ZIndex = 100
            
            local PopupCorner = Instance.new("UICorner")
            PopupCorner.CornerRadius = UDim.new(0, 10)
            PopupCorner.Parent = ColorPickerPopup
            
            local PopupStroke = Instance.new("UIStroke")
            PopupStroke.Color = TestHub.Config.DefaultColor
            PopupStroke.Thickness = 2
            PopupStroke.Parent = ColorPickerPopup
            
            local PopupTitle = Instance.new("TextLabel")
            PopupTitle.Size = UDim2.new(1, -60, 0, 30)
            PopupTitle.Position = UDim2.new(0, 10, 0, 5)
            PopupTitle.BackgroundTransparency = 1
            PopupTitle.Text = "Pick a Color"
            PopupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            PopupTitle.Font = Enum.Font.GothamBold
            PopupTitle.TextSize = 16
            PopupTitle.TextXAlignment = Enum.TextXAlignment.Left
            PopupTitle.Parent = ColorPickerPopup
            
            local CloseButton = Instance.new("TextButton")
            CloseButton.Size = UDim2.new(0, 30, 0, 30)
            CloseButton.Position = UDim2.new(1, -35, 0, 5)
            CloseButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
            CloseButton.Text = "X"
            CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CloseButton.Font = Enum.Font.GothamBold
            CloseButton.TextSize = 14
            CloseButton.Parent = ColorPickerPopup
            
            local CloseCorner = Instance.new("UICorner")
            CloseCorner.CornerRadius = UDim.new(0, 6)
            CloseCorner.Parent = CloseButton
            
            local currentColor = options.CurrentColor or TestHub.Config.DefaultColor
            local currentHue = 0
            local currentSat = 1
            local currentVal = 1
            
            local function RGBtoHSV(color)
                local r, g, b = color.R, color.G, color.B
                local max = math.max(r, g, b)
                local min = math.min(r, g, b)
                local delta = max - min
                
                local h, s, v = 0, 0, max
                
                if delta > 0 then
                    s = delta / max
                    
                    if max == r then
                        h = ((g - b) / delta) % 6
                    elseif max == g then
                        h = (b - r) / delta + 2
                    else
                        h = (r - g) / delta + 4
                    end
                    
                    h = h / 6
                end
                
                return h, s, v
            end
            
            local function HSVtoRGB(h, s, v)
                local r, g, b
                
                local i = math.floor(h * 6)
                local f = h * 6 - i
                local p = v * (1 - s)
                local q = v * (1 - f * s)
                local t = v * (1 - (1 - f) * s)
                
                i = i % 6
                
                if i == 0 then r, g, b = v, t, p
                elseif i == 1 then r, g, b = q, v, p
                elseif i == 2 then r, g, b = p, v, t
                elseif i == 3 then r, g, b = p, q, v
                elseif i == 4 then r, g, b = t, p, v
                elseif i == 5 then r, g, b = v, p, q
                end
                
                return Color3.fromRGB(r * 255, g * 255, b * 255)
            end
            
            currentHue, currentSat, currentVal = RGBtoHSV(currentColor)
            
            local ColorCanvas = Instance.new("ImageButton")
            ColorCanvas.Size = UDim2.new(0, 240, 0, 180)
            ColorCanvas.Position = UDim2.new(0, 20, 0, 45)
            ColorCanvas.BackgroundColor3 = HSVtoRGB(currentHue, 1, 1)
            ColorCanvas.BorderSizePixel = 0
            ColorCanvas.AutoButtonColor = false
            ColorCanvas.Parent = ColorPickerPopup
            
            local CanvasCorner = Instance.new("UICorner")
            CanvasCorner.CornerRadius = UDim.new(0, 6)
            CanvasCorner.Parent = ColorCanvas
            
            local WhiteGradient = Instance.new("Frame")
            WhiteGradient.Size = UDim2.new(1, 0, 1, 0)
            WhiteGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            WhiteGradient.BackgroundTransparency = 0
            WhiteGradient.BorderSizePixel = 0
            WhiteGradient.Parent = ColorCanvas
            
            local WhiteCorner = Instance.new("UICorner")
            WhiteCorner.CornerRadius = UDim.new(0, 6)
            WhiteCorner.Parent = WhiteGradient
            
            local WhiteGrad = Instance.new("UIGradient")
            WhiteGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
            WhiteGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            WhiteGrad.Rotation = 0
            WhiteGrad.Parent = WhiteGradient
            
            local BlackGradient = Instance.new("Frame")
            BlackGradient.Size = UDim2.new(1, 0, 1, 0)
            BlackGradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            BlackGradient.BackgroundTransparency = 0
            BlackGradient.BorderSizePixel = 0
            BlackGradient.Parent = ColorCanvas
            
            local BlackCorner = Instance.new("UICorner")
            BlackCorner.CornerRadius = UDim.new(0, 6)
            BlackCorner.Parent = BlackGradient
            
            local BlackGrad = Instance.new("UIGradient")
            BlackGrad.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
            BlackGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0)
            })
            BlackGrad.Rotation = 90
            BlackGrad.Parent = BlackGradient
            
            local PickerCursor = Instance.new("Frame")
            PickerCursor.Size = UDim2.new(0, 10, 0, 10)
            PickerCursor.AnchorPoint = Vector2.new(0.5, 0.5)
            PickerCursor.Position = UDim2.new(currentSat, 0, 1 - currentVal, 0)
            PickerCursor.BackgroundTransparency = 1
            PickerCursor.BorderSizePixel = 0
            PickerCursor.ZIndex = 5
            PickerCursor.Parent = ColorCanvas
            
            local CursorOuter = Instance.new("Frame")
            CursorOuter.Size = UDim2.new(1, 0, 1, 0)
            CursorOuter.BackgroundTransparency = 1
            CursorOuter.BorderSizePixel = 3
            CursorOuter.BorderColor3 = Color3.fromRGB(255, 255, 255)
            CursorOuter.Parent = PickerCursor
            
            local CursorOuterCorner = Instance.new("UICorner")
            CursorOuterCorner.CornerRadius = UDim.new(1, 0)
            CursorOuterCorner.Parent = CursorOuter
            
            local CursorStroke = Instance.new("UIStroke")
            CursorStroke.Color = Color3.fromRGB(0, 0, 0)
            CursorStroke.Thickness = 1
            CursorStroke.Parent = CursorOuter
            
            local HueBar = Instance.new("ImageButton")
            HueBar.Size = UDim2.new(0, 15, 0, 180)
            HueBar.Position = UDim2.new(1, -35, 0, 45)
            HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueBar.BorderSizePixel = 0
            HueBar.AutoButtonColor = false
            HueBar.Parent = ColorPickerPopup
            
            local HueCorner = Instance.new("UICorner")
            HueCorner.CornerRadius = UDim.new(0, 4)
            HueCorner.Parent = HueBar
            
            local HueGradient = Instance.new("UIGradient")
            HueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
            HueGradient.Rotation = 90
            HueGradient.Parent = HueBar
            
            local HueSelector = Instance.new("Frame")
            HueSelector.Size = UDim2.new(1, 6, 0, 3)
            HueSelector.AnchorPoint = Vector2.new(0.5, 0.5)
            HueSelector.Position = UDim2.new(0.5, 0, currentHue, 0)
            HueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSelector.BorderSizePixel = 0
            HueSelector.ZIndex = 5
            HueSelector.Parent = HueBar
            
            local HueSelectorStroke = Instance.new("UIStroke")
            HueSelectorStroke.Color = Color3.fromRGB(0, 0, 0)
            HueSelectorStroke.Thickness = 1
            HueSelectorStroke.Parent = HueSelector
            
            local PreviewLabel = Instance.new("TextLabel")
            PreviewLabel.Size = UDim2.new(1, -40, 0, 20)
            PreviewLabel.Position = UDim2.new(0, 20, 0, 235)
            PreviewLabel.BackgroundTransparency = 1
            PreviewLabel.Text = "Preview:"
            PreviewLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            PreviewLabel.Font = Enum.Font.GothamBold
            PreviewLabel.TextSize = 14
            PreviewLabel.TextXAlignment = Enum.TextXAlignment.Left
            PreviewLabel.Parent = ColorPickerPopup
            
            local PreviewBox = Instance.new("Frame")
            PreviewBox.Size = UDim2.new(1, -40, 0, 40)
            PreviewBox.Position = UDim2.new(0, 20, 0, 260)
            PreviewBox.BackgroundColor3 = currentColor
            PreviewBox.BorderSizePixel = 0
            PreviewBox.Parent = ColorPickerPopup
            
            local PreviewCorner = Instance.new("UICorner")
            PreviewCorner.CornerRadius = UDim.new(0, 6)
            PreviewCorner.Parent = PreviewBox
            
            local ConfirmButton = Instance.new("TextButton")
            ConfirmButton.Size = UDim2.new(1, -40, 0, 30)
            ConfirmButton.Position = UDim2.new(0, 20, 0, 305)
            ConfirmButton.BackgroundColor3 = TestHub.Config.DefaultColor
            ConfirmButton.Text = "Confirm"
            ConfirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ConfirmButton.Font = Enum.Font.GothamBold
            ConfirmButton.TextSize = 14
            ConfirmButton.Parent = ColorPickerPopup
            
            local ConfirmCorner = Instance.new("UICorner")
            ConfirmCorner.CornerRadius = UDim.new(0, 6)
            ConfirmCorner.Parent = ConfirmButton
            
            table.insert(uiElements, {element = ConfirmButton, type = "button"})
            table.insert(uiElements, {element = PopupStroke, type = "stroke"})
            
            local function UpdateColor()
                local newColor = HSVtoRGB(currentHue, currentSat, currentVal)
                PreviewBox.BackgroundColor3 = newColor
                currentColor = newColor
                ColorCanvas.BackgroundColor3 = HSVtoRGB(currentHue, 1, 1)
            end
            
            local canvasDragging = false
            
            ColorCanvas.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    canvasDragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    canvasDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if canvasDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = input.Position
                    local canvasPos = ColorCanvas.AbsolutePosition
                    local canvasSize = ColorCanvas.AbsoluteSize
                    
                    local relativeX = math.clamp((mousePos.X - canvasPos.X) / canvasSize.X, 0, 1)
                    local relativeY = math.clamp((mousePos.Y - canvasPos.Y) / canvasSize.Y, 0, 1)
                    
                    currentSat = relativeX
                    currentVal = 1 - relativeY
                    
                    PickerCursor.Position = UDim2.new(currentSat, 0, 1 - currentVal, 0)
                    UpdateColor()
                end
            end)
            
            local hueDragging = false
            
            HueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = input.Position
                    local huePos = HueBar.AbsolutePosition
                    local hueSize = HueBar.AbsoluteSize
                    
                    local relativeY = math.clamp((mousePos.Y - huePos.Y) / hueSize.Y, 0, 1)
                    
                    currentHue = relativeY
                    HueSelector.Position = UDim2.new(0.5, 0, currentHue, 0)
                    UpdateColor()
                end
            end)
            
            local ClickDetector = Instance.new("TextButton")
            ClickDetector.Size = UDim2.new(1, 0, 1, 0)
            ClickDetector.BackgroundTransparency = 1
            ClickDetector.Text = ""
            ClickDetector.ZIndex = 2
            ClickDetector.Parent = Container
            
            spawn(function()
                local attempts = 0
                while not playerGui:FindFirstChild("TestHubUI") and attempts < 50 do
                    wait(0.1)
                    attempts = attempts + 1
                end
                
                local screenGui = playerGui:FindFirstChild("TestHubUI")
                if screenGui then
                    ColorPickerPopup.Parent = screenGui
                end
            end)
            
            ClickDetector.MouseButton1Click:Connect(function()
                if not ColorPickerPopup.Parent then
                    local screenGui = playerGui:FindFirstChild("TestHubUI")
                    if screenGui then
                        ColorPickerPopup.Parent = screenGui
                    end
                end
                ColorPickerPopup.Visible = true
            end)
            
            CloseButton.MouseButton1Click:Connect(function()
                ColorPickerPopup.Visible = false
            end)
            
            ConfirmButton.MouseButton1Click:Connect(function()
                ColorDisplay.BackgroundColor3 = currentColor
                ColorPickerPopup.Visible = false
                if options.Callback then
                    options.Callback(currentColor)
                end
            end)
            
            return Container, {
                UpdateColor = function(newColor)
                    currentHue, currentSat, currentVal = RGBtoHSV(newColor)
                    ColorDisplay.BackgroundColor3 = newColor
                    PreviewBox.BackgroundColor3 = newColor
                    ColorCanvas.BackgroundColor3 = HSVtoRGB(currentHue, 1, 1)
                    PickerCursor.Position = UDim2.new(currentSat, 0, 1 - currentVal, 0)
                    HueSelector.Position = UDim2.new(0.5, 0, currentHue, 0)
                    currentColor = newColor
                end
            }
        end
    }
    tabs[name] = tabData
    
    return tabData
end

function TestHub:SaveConfig(configName, colorDropdown)
    local currentColorName = colorDropdown and colorDropdown.Button.Text or "Purple"
    
    local configData = {
        Settings = TestHub.Config.Settings,
        ThemeColor = {TestHub.Config.DefaultColor.R, TestHub.Config.DefaultColor.G, TestHub.Config.DefaultColor.B},
        ThemeColorName = currentColorName
    }
    
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(configData)
    end)
    
    if success then
        local finalSuccess = pcall(function()
            writefile(configFolder .. "/" .. configName .. ".json", encoded)
        end)
        if finalSuccess then
            spawn(function()
                CreateNotification("Config Saved: " .. configName, 3)
            end)
        else
            spawn(function()
                CreateNotification("Failed to save config", 3)
            end)
        end
        return finalSuccess
    end
    return false
end

function TestHub:LoadConfig(configName, colorDropdown, colorPicker)
    local success, fileContent = pcall(function()
        return readfile(configFolder .. "/" .. configName .. ".json")
    end)
    
    if success then
        local decodeSuccess, configData = pcall(function()
            return HttpService:JSONDecode(fileContent)
        end)
        
        if decodeSuccess and configData then
            if configData.Settings then
                TestHub.Config.Settings = configData.Settings
                
                for name, state in pairs(configData.Settings) do
                    if toggleCallbacks[name] and type(state) == "boolean" then
                        toggleCallbacks[name](state)
                    end
                end
                
                for name, value in pairs(configData.Settings) do
                    if sliderCallbacks[name] and type(value) == "number" then
                        sliderCallbacks[name](value)
                    end
                end
            end
            
            if configData.ThemeColor then
                TestHub.Config.DefaultColor = Color3.fromRGB(
                    configData.ThemeColor[1] * 255,
                    configData.ThemeColor[2] * 255,
                    configData.ThemeColor[3] * 255
                )
            end
            
            if configData.ThemeColorName and colorDropdown then
                colorDropdown.Button.Text = configData.ThemeColorName
            end
            
            if colorPicker and configData.ThemeColor then
                local loadedColor = Color3.fromRGB(
                    configData.ThemeColor[1] * 255,
                    configData.ThemeColor[2] * 255,
                    configData.ThemeColor[3] * 255
                )
                colorPicker.UpdateColor(loadedColor)
            end
            
            spawn(function()
                CreateNotification("Config Loaded: " .. configName, 3)
            end)
            return true, configData
        end
    end
    
    spawn(function()
        CreateNotification("Config Not Found: " .. configName, 3)
    end)
    return false
end

function TestHub:DeleteConfig(configName)
    local success = pcall(function()
        delfile(configFolder .. "/" .. configName .. ".json")
    end)
    
    if success then
        spawn(function()
            CreateNotification("Config Deleted: " .. configName, 3)
        end)
    else
        spawn(function()
            CreateNotification("Failed to Delete Config", 3)
        end)
    end
    
    return success
end

function TestHub:ListConfigs()
    local configs = {}
    local success = pcall(function()
        local files = listfiles(configFolder)
        for _, file in pairs(files) do
            local configName = file:match("([^/\\]+)%.json$")
            if configName then
                table.insert(configs, configName)
            end
        end
    end)
    return configs
end

function TestHub:UpdateAllColors(TitleLabel, HubIcon, MobileToggleButton)
    for _, item in pairs(uiElements) do
        if item.type == "button" then
            item.element.BackgroundColor3 = TestHub.Config.DefaultColor
        elseif item.type == "toggle" and item.toggled then
            item.element.BackgroundColor3 = TestHub.Config.DefaultColor
        elseif item.type == "slider" then
            if item.element:IsA("Frame") then
                item.gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, TestHub.Config.DefaultColor)
                })
            end
        elseif item.type == "textbox" then
            if item.element:IsA("TextBox") then
                item.element.TextColor3 = TestHub.Config.DefaultColor
            end
        elseif item.type == "stroke" then
            item.element.Color = TestHub.Config.DefaultColor
        end
    end
    
    for name, tab in pairs(tabs) do
        tab.LeftColumn.ScrollBarImageColor3 = TestHub.Config.DefaultColor
        tab.RightColumn.ScrollBarImageColor3 = TestHub.Config.DefaultColor
        
        if currentTab == name then
            tab.Button.BackgroundColor3 = TestHub.Config.DefaultColor
            tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            tab.Button.BackgroundColor3 = TestHub.Config.BackgroundColor
            tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    if TitleLabel then
        TitleLabel.TextColor3 = TestHub.Config.DefaultColor
    end
    if HubIcon then
        HubIcon.ImageColor3 = TestHub.Config.DefaultColor
    end
    if MobileToggleButton then
        MobileToggleButton.ImageColor3 = TestHub.Config.DefaultColor
        for _, child in pairs(MobileToggleButton:GetChildren()) do
            if child:IsA("UIStroke") then
                child.Color = TestHub.Config.DefaultColor
            end
        end
    end
end

function TestHub:Init(config)
    if config then
        if config.HubName then
            self.Config.HubName = config.HubName
        end
        if config.HubIcon then
            self.Config.HubIcon = config.HubIcon
        end
        if config.DefaultColor then
            self.Config.DefaultColor = config.DefaultColor
        end
    end
    
    local ScreenGui, MainFrame, TabContainer, ContentContainer, TitleLabel, HubIcon, MobileToggleButton = CreateUI()
    
    table.insert(uiElements, {element = MobileToggleButton, type = "mobilebutton"})
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.Parent = TabContainer
    
    ScreenGui.Parent = playerGui
    
    local Window = {
        CreateTab = function(self, name, icon)
            return CreateTab(TabContainer, name, icon, ContentContainer)
        end
    }
    
    return Window
end

return TestHub
