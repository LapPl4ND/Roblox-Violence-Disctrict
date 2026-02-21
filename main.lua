-- =========================
-- SERVICES
-- =========================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local rgbSliders = {}

-- =========================
-- GUI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "DBDMenu"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 600)
frame.Position = UDim2.new(0.5, -180, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

--------------------------------------------------
-- RGB BORDER
--------------------------------------------------

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(255,0,0)
stroke.Parent = frame

-- =========================
-- ESP FOLDER
-- =========================

local espFolder = Instance.new("Folder")
espFolder.Name = "ESPObjects"
espFolder.Parent = gui

-- =========================
-- TITLE BAR
-- =========================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
titleBar.Parent = frame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 4)

--------------------------------------------------
-- TITLE RGB BORDER
--------------------------------------------------

local titleStroke = Instance.new("UIStroke")
titleStroke.Thickness = 2
titleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
titleStroke.Color = Color3.fromRGB(255,0,0)
titleStroke.Parent = titleBar


local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "TX Menu DBD"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = titleBar


--------------------------------------------------
-- RGB ANIMATION
--------------------------------------------------

local hue = 0

RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.1) % 1
	local rgb = Color3.fromHSV(hue, 1, 1)

	title.TextColor3 = rgb
	stroke.Color = rgb
	titleStroke.Color = rgb

	-- Boutons / Strokes
	for _, obj in ipairs(gui:GetDescendants()) do
	
		if obj:IsA("UIStroke") and obj ~= stroke and obj ~= titleStroke then
			obj.Color = rgb
		end
	
		if obj:IsA("TextButton") and obj:GetAttribute("IsCheckbox") then
			if obj:GetAttribute("Active") then
				obj.BackgroundColor3 = rgb
			end
		end
	end

	-- Sliders (en dehors de la boucle)
	for _, sliderFill in ipairs(rgbSliders) do
		sliderFill.BackgroundColor3 = rgb
	end
end)

-- =========================
-- CONTAINER
-- =========================

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 68)
container.BackgroundTransparency = 1
container.Parent = frame

-- =========================
-- PAGE SYSTEM
-- =========================

local function createPage()
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1,0,1,0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = container
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,10)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page
	
	return page
end

local mainPage = createPage()
local mainLayout = mainPage:FindFirstChildOfClass("UIListLayout")
if mainLayout then
	mainLayout.Padding = UDim.new(0,28)
end
local survivorPage = createPage()
local killerPage = createPage()
local skillPage = createPage()
local objectPage = createPage()

mainPage.Visible = true

local function switchPage(page)
	for _,v in pairs(container:GetChildren()) do
		if v:IsA("Frame") then
			v.Visible = false
		end
	end
	page.Visible = true
end


-- =========================
-- SURVIVOR ESP STATES
-- =========================
local SurvivorESP = {
	Box = false,
	Line = false,
	Nickname = false,
	Skeleton = false,
	Health = false
}

-- =========================
-- KILLER ESP STATES
-- =========================
local KillerESP = {
	Box = false,
	Line = false,
	Nickname = false,
	Skeleton = false,
	Health = false
}

-- =========================
-- Items
-- =========================

local ObjectESP = {
	Generator = false,
	Palletwrong = false,
	Window = false,
	ExitLever = false,
	Gate = false
}

-- =========================
-- BUTTON FUNCTION
-- =========================

local function createButton(parent, text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	btn.Parent = parent
	
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

	-- RGB Stroke
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 2
	btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	btnStroke.Color = Color3.fromRGB(255,0,0)
	btnStroke.Parent = btn
	
	return btn
end

-- =========================
-- CHECKBOX FUNCTION
-- =========================

local function createCheckbox(parent, text)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 40)
	holder.BackgroundTransparency = 1
	holder.Parent = parent
	
	
	local box = Instance.new("TextButton")
	box.Size = UDim2.new(0, 30, 0, 30)
	box.Position = UDim2.new(0, 0, 0.5, -15)
	box.BackgroundColor3 = Color3.fromRGB(50,50,50)
	box.Text = ""
	box.Parent = holder
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)
	
	box:SetAttribute("IsCheckbox", true)
	box:SetAttribute("Active", false)
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -40, 1, 0)
	label.Position = UDim2.new(0, 40, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder
	
	return holder, box
end

-- =========================
-- SLIDER FUNCTION
-- =========================

local function createSlider(parent, text, minValue, maxValue, defaultValue)

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 60)
	holder.BackgroundTransparency = 1
	holder.Parent = parent
	
	local currentValue = defaultValue
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = text .. ": " .. currentValue
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder
	
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, 0, 0, 8)
	bar.Position = UDim2.new(0, 0, 0, 35)
	bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
	bar.Parent = holder
	
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((defaultValue-minValue)/(maxValue-minValue),0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(255,0,0) -- couleur temporaire
	fill.Parent = bar

	table.insert(rgbSliders, fill)
	
	local dragging = false

	bar.InputBegan:Connect(function(input)
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
			
			local percent = math.clamp(
				(input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
				0,1
			)

			fill.Size = UDim2.new(percent,0,1,0)
			currentValue = math.floor(minValue + (maxValue-minValue)*percent)
			label.Text = text .. ": " .. currentValue
		end
	end)
	
	return holder, function()
		return currentValue
	end
end

-- =========================
-- MAIN BUTTONS
-- =========================

local survivorBtn = createButton(mainPage,"SURVIVOR")
local killerBtn = createButton(mainPage,"KILLER")
local skillBtn = createButton(mainPage,"SKILLCHECKS")
local objectBtn = createButton(mainPage,"OBJECTS ESP")

survivorBtn.MouseButton1Click:Connect(function()
	switchPage(survivorPage)
end)

killerBtn.MouseButton1Click:Connect(function()
	switchPage(killerPage)
end)

skillBtn.MouseButton1Click:Connect(function()
	switchPage(skillPage)
end)

objectBtn.MouseButton1Click:Connect(function()
	switchPage(objectPage)
end)

-- =========================
-- SUBPAGES
-- =========================

local function setupSubPage(page, name)
	local backBtn = createButton(page,"← BACK")
	backBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
	backBtn.LayoutOrder = 1
	backBtn.MouseButton1Click:Connect(function()
		switchPage(mainPage)
	end)
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,0,40)
	label.BackgroundTransparency = 1
	label.Text = name.." SETTINGS"
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 16
	label.LayoutOrder = 2
	label.Parent = page
end

setupSubPage(survivorPage,"SURVIVOR")
setupSubPage(killerPage,"KILLER")
setupSubPage(skillPage,"SKILLCHECK")
setupSubPage(objectPage,"OBJECT")

-- =========================
-- SURVIVOR OPTIONS
-- =========================

local order = 3

local function addCheckbox(text, tableKey)
	local holder, button = createCheckbox(survivorPage, text)
	holder.LayoutOrder = order
	order += 1
	
	button.MouseButton1Click:Connect(function()
		SurvivorESP[tableKey] = not SurvivorESP[tableKey]
		
		button:SetAttribute("Active", SurvivorESP[tableKey])

		if not SurvivorESP[tableKey] then
			button.BackgroundColor3 = Color3.fromRGB(50,50,50)
		end
	end)
end

addCheckbox("Box 2D","Box")
addCheckbox("Line","Line")
addCheckbox("Nickname","Nickname")
addCheckbox("Skeleton","Skeleton")
addCheckbox("Health State","Health")

local sliderHolder, getSurvivorDistance = createSlider(survivorPage,"Distance Render",50,1000,300)
sliderHolder.LayoutOrder = order
order += 1


-- =========================
-- KILLER OPTIONS
-- =========================

local killerOrder = 3

local function addKillerCheckbox(text, tableKey)
	local holder, button = createCheckbox(killerPage, text)
	holder.LayoutOrder = killerOrder
	killerOrder += 1
	
	button.MouseButton1Click:Connect(function()
		KillerESP[tableKey] = not KillerESP[tableKey]
		
		button:SetAttribute("Active", KillerESP[tableKey])

		if not KillerESP[tableKey] then
			button.BackgroundColor3 = Color3.fromRGB(50,50,50)
		end
	end)
end

addKillerCheckbox("Box 2D","Box")
addKillerCheckbox("Line","Line")
addKillerCheckbox("Nickname","Nickname")
addKillerCheckbox("Skeleton","Skeleton")
addKillerCheckbox("Health State","Health")

local killerSliderHolder, getKillerDistance = createSlider(killerPage,"Distance Render",50,1000,300)
killerSliderHolder.LayoutOrder = killerOrder
killerOrder += 1

-- =========================
-- SKILL PAGE OPTIONS
-- =========================

local skillOrder = 3

-- ===== SPEED =====

local speedHolder, speedButton = createCheckbox(skillPage, "Speed")
speedHolder.LayoutOrder = skillOrder
skillOrder += 1

local speedSlider, getSpeedValue = createSlider(skillPage, "Speed Amount", 10, 200, 50)
speedSlider.LayoutOrder = skillOrder
speedSlider.Visible = false
skillOrder += 1

local speedEnabled = false

speedButton.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedButton:SetAttribute("Active", speedEnabled)

	if not speedEnabled then
		speedButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
	end

	speedSlider.Visible = speedEnabled
end)

-- =========================
-- SPEED SYSTEM
-- =========================

local defaultWalkSpeed = 16

RunService.RenderStepped:Connect(function()

	local character = player.Character
	if not character then return end
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	
	if speedEnabled then
		humanoid.WalkSpeed = getSpeedValue()
	else
		humanoid.WalkSpeed = defaultWalkSpeed
	end
	
end)

-- ===== FLY =====

local flyHolder, flyButton = createCheckbox(skillPage, "Fly")
flyHolder.LayoutOrder = skillOrder
skillOrder += 1

local flySlider, getFlySpeed = createSlider(skillPage, "Fly Speed", 10, 300, 75)
flySlider.LayoutOrder = skillOrder
flySlider.Visible = false
skillOrder += 1

local flying = false
local bodyVelocity
local bodyGyro

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	flyButton:SetAttribute("Active", flying)

	if not flying then
		flyButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
	end

	flySlider.Visible = flying

	local character = player.Character
	if not character then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	if flying then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
		bodyVelocity.Parent = hrp
		
		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
		bodyGyro.CFrame = hrp.CFrame
		bodyGyro.Parent = hrp
	else
		if bodyVelocity then bodyVelocity:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
	end
end)

RunService.RenderStepped:Connect(function()
	if flying and bodyVelocity then
		
		local character = player.Character
		if not character then return end
		
		local humanoid = character:FindFirstChild("Humanoid")
		if not humanoid then return end
		
		local moveDir = humanoid.MoveDirection
		local speed = getFlySpeed()
		
		local y = 0
		
		-- Monter avec Espace
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			y = speed
			
		-- Descendre avec Ctrl gauche
		elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			y = -speed
		end
		
		bodyVelocity.Velocity = Vector3.new(
			moveDir.X * speed,
			y,
			moveDir.Z * speed
		)
	end
end)

-- ===== NO CLIP =====

local noclipHolder, noclipButton = createCheckbox(skillPage, "No Clip")
noclipHolder.LayoutOrder = skillOrder
skillOrder += 1

local noclipEnabled = false

noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipButton:SetAttribute("Active", noclipEnabled)

	if not noclipEnabled then
		noclipButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
	end
end)

-- ===== FOV =====

local fovHolder, fovButton = createCheckbox(skillPage, "FOV")
fovHolder.LayoutOrder = skillOrder
skillOrder += 1

local fovSlider, getFovValue = createSlider(skillPage, "FOV Amount", 40, 120, 70)
fovSlider.LayoutOrder = skillOrder
fovSlider.Visible = false
skillOrder += 1

local fovEnabled = false
local defaultFOV = workspace.CurrentCamera.FieldOfView

fovButton.MouseButton1Click:Connect(function()
	fovEnabled = not fovEnabled
	
	fovButton:SetAttribute("Active", fovEnabled)

	if not fovEnabled then
		fovButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
	end

	fovSlider.Visible = fovEnabled
	
	if not fovEnabled then
		workspace.CurrentCamera.FieldOfView = defaultFOV
	end
end)

-- =========================
-- OBJECT ESP OPTIONS
-- =========================

local objectOrder = 3

local function addObjectCheckbox(displayName, objectName)
	local holder, button = createCheckbox(objectPage, displayName)
	holder.LayoutOrder = objectOrder
	objectOrder += 1
	
	button.MouseButton1Click:Connect(function()
		ObjectESP[objectName] = not ObjectESP[objectName]
		
	button:SetAttribute("Active", ObjectESP[objectName])

	if not ObjectESP[objectName] then
		button.BackgroundColor3 = Color3.fromRGB(50,50,50)
	end
	end)
end

addObjectCheckbox("Generators","Generator")
addObjectCheckbox("Pallet","Palletwrong")
addObjectCheckbox("Window","Window")
local holder, button = createCheckbox(objectPage, "Escape Door")
holder.LayoutOrder = objectOrder
objectOrder += 1

button.MouseButton1Click:Connect(function()
	
	local newState = not (ObjectESP.ExitLever and ObjectESP.Gate)
	
	ObjectESP.ExitLever = newState
	ObjectESP.Gate = newState
	
	button:SetAttribute("Active", newState)

	if not newState then
		button.BackgroundColor3 = Color3.fromRGB(50,50,50)
	end
end)

local objectSliderHolder, getObjectDistance = createSlider(objectPage,"Render Distance",50,2000,500)
objectSliderHolder.LayoutOrder = objectOrder
objectOrder += 1

-- =========================
-- NOCLIP SYSTEM
-- =========================

RunService.Stepped:Connect(function()
	if noclipEnabled then
		local character = player.Character
		if character then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)


-- =========================
-- OBJECT ESP SYSTEM
-- =========================

local TARGETS = {
	Window = Color3.fromRGB(255,255,0),      -- 🟡 Jaune
	Palletwrong = Color3.fromRGB(0,170,255), -- 🔵 Bleu
	Generator = Color3.fromRGB(255,0,0),     -- 🔴 Rouge
	ExitLever = Color3.fromRGB(0,255,0),     -- 🟢 Vert
	Gate = Color3.fromRGB(0,255,0)           -- 🟢 Vert
}

local trackedObjects = {}

local function scanWorkspace()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if TARGETS[obj.Name] then
			table.insert(trackedObjects, obj)
		end
	end
end

scanWorkspace()

workspace.DescendantAdded:Connect(function(obj)
	if TARGETS[obj.Name] then
		table.insert(trackedObjects, obj)
	end
end)


local function GetMainPart(obj)
	if obj:IsA("Model") then
		return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
	elseif obj:IsA("BasePart") then
		return obj
	end
	return nil
end

local function AddObjectESP(obj)

	if not ObjectESP[obj.Name] then return end
	if obj:FindFirstChild("ESP_ACTIVE") then return end
	
	local mainPart = GetMainPart(obj)
	if not mainPart then return end
	
	local tag = Instance.new("BoolValue")
	tag.Name = "ESP_ACTIVE"
	tag.Parent = obj
	
	local highlight = Instance.new("Highlight")
	highlight.FillColor = TARGETS[obj.Name]
	highlight.OutlineColor = Color3.new(1,1,1)
	highlight.FillTransparency = 0.4
	highlight.Parent = obj
	
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0,150,0,40)
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0,3,0)
	billboard.Adornee = mainPart
	billboard.Parent = obj
	
	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.TextScaled = true
	text.Font = Enum.Font.SourceSansBold
	text.TextColor3 = TARGETS[obj.Name]
	text.Text = obj.Name
	text.Parent = billboard
end

RunService.RenderStepped:Connect(function()

	for _, obj in ipairs(trackedObjects) do
		if TARGETS[obj.Name] then

			local mainPart = GetMainPart(obj)
if not mainPart then continue end

local myChar = player.Character
local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

if myHrp then
	local distance = (myHrp.Position - mainPart.Position).Magnitude
	
	local maxDistance = 500
	if typeof(getObjectDistance) == "function" then
		maxDistance = getObjectDistance()
	end
	
	if distance > maxDistance then
		-- Trop loin → on retire ESP si actif
		if obj:FindFirstChild("ESP_ACTIVE") then
			obj:FindFirstChild("ESP_ACTIVE"):Destroy()
			
			for _, v in pairs(obj:GetChildren()) do
				if v:IsA("Highlight") or v:IsA("BillboardGui") then
					v:Destroy()
				end
			end
		end
		
		continue
	end
end
			
			if ObjectESP[obj.Name] then
				AddObjectESP(obj)
			else
				if obj:FindFirstChild("ESP_ACTIVE") then
					obj:FindFirstChild("ESP_ACTIVE"):Destroy()
					
					for _, v in pairs(obj:GetChildren()) do
						if v:IsA("Highlight") or v:IsA("BillboardGui") then
							v:Destroy()
						end
					end
				end
			end
			
		end
	end
	
end)


-- =========================
-- ESP Survivor (DRAWING VERSION - STABLE)
-- =========================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espBoxes = {}
local espLines = {}
local espNames = {}
local espSkeletons = {}
local espHealthBars = {}

-- ===== CREATE BOX =====
local function createBox()
	local box = Drawing.new("Square")
	box.Visible = false
	box.Filled = false
	box.Color = Color3.fromRGB(0,255,0)
	box.Thickness = 2
	box.Transparency = 1
	return box
end

-- ===== CREATE Line =====
local function createLine()
	local line = Drawing.new("Line")
	line.Visible = false
	line.Color = Color3.fromRGB(0,255,0)
	line.Thickness = 1
	line.Transparency = 1
	return line
end

-- ===== CREATE name =====
local function createName()
	local text = Drawing.new("Text")
	text.Visible = false
	text.Center = true
	text.Outline = true
	text.Size = 16
	text.Color = Color3.fromRGB(0,255,0)
	text.Font = 2
	text.Transparency = 1
	return text
end

-- ===== CREATE Skeleton =====
local function createSkeleton()
	local lines = {}
	
	for i = 1, 20 do -- large pour R6 + R15
		local line = Drawing.new("Line")
		line.Visible = false
		line.Color = Color3.fromRGB(0,255,0)
		line.Thickness = 2
		line.Transparency = 1
		table.insert(lines, line)
	end
	
	return lines
end

-- ===== CREATE Health Bar =====
local function createHealthBar()

	local outline = Drawing.new("Square")
	outline.Visible = false
	outline.Filled = false
	outline.Color = Color3.fromRGB(0,0,0)
	outline.Thickness = 1
	outline.Transparency = 1

	local bar = Drawing.new("Square")
	bar.Visible = false
	bar.Filled = true
	bar.Color = Color3.fromRGB(0,255,0)
	bar.Thickness = 0
	bar.Transparency = 1

	return {
		Outline = outline,
		Bar = bar
	}
end

-- ===== TRACK PLAYER =====
local function trackPlayer(plr)
	if plr == LocalPlayer then return end
	if espBoxes[plr] then return end
	
	espBoxes[plr] = createBox()
	espLines[plr] = createLine()
	espNames[plr] = createName()
	espSkeletons[plr] = createSkeleton()
	espHealthBars[plr] = createHealthBar()
end

local function untrackPlayer(plr)
	if espBoxes[plr] then
		espBoxes[plr]:Remove()
		espBoxes[plr] = nil
	end

	if espLines[plr] then
		espLines[plr]:Remove()
		espLines[plr] = nil
	end

	if espNames[plr] then
		espNames[plr]:Remove()
		espNames[plr] = nil
	end

	if espSkeletons[plr] then
		for _, line in ipairs(espSkeletons[plr]) do
			line:Remove()
		end
		espSkeletons[plr] = nil
	end

	if espHealthBars[plr] then
		espHealthBars[plr].Outline:Remove()
		espHealthBars[plr].Bar:Remove()
		espHealthBars[plr] = nil
	end

end

-- Track existing players
for _, plr in ipairs(Players:GetPlayers()) do
	trackPlayer(plr)
end

Players.PlayerAdded:Connect(trackPlayer)
Players.PlayerRemoving:Connect(untrackPlayer)

-- ===== RENDER LOOP =====
RunService.RenderStepped:Connect(function()

	for plr, box in pairs(espBoxes) do

		local line = espLines[plr]

		box.Visible = false
		if line then
			line.Visible = false
		end

		local name = espNames[plr]

		if name then
			name.Visible = false
		end

		local skeleton = espSkeletons[plr]
		if skeleton then
    		for _, l in ipairs(skeleton) do
        		l.Visible = false
    		end
		end

		local healthBar = espHealthBars[plr]
		if healthBar then
			healthBar.Outline.Visible = false
			healthBar.Bar.Visible = false
		end

		
			-- ===== TEAM FILTER =====
			if not plr.Team then
				continue
			end

			local isSurvivor = plr.Team.Name == "Survivors"
			local isKiller = plr.Team.Name == "Killer"

			-- Si aucun des deux, skip
			if not isSurvivor and not isKiller then
				continue
			end


		local char = plr.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		
		if not char or not hrp or not hum or hum.Health <= 0 then
			box.Visible = false
			continue
		end
		
		-- Screen projection
		local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
		if not onScreen then
			box.Visible = false
			continue
		end
		
		-- Distance check (optionnel)
		local myChar = LocalPlayer.Character
		local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
		
		if myHrp then
			local dist = (myHrp.Position - hrp.Position).Magnitude
	
			local maxDistance = 800 -- fallback sécurité

			if isSurvivor and typeof(getSurvivorDistance) == "function" then
				maxDistance = getSurvivorDistance()
			elseif isKiller and typeof(getKillerDistance) == "function" then
				maxDistance = getKillerDistance()
			end
	
			if dist > maxDistance then
				continue
			end
		end
		
		-- EXACT ANCIEN CALCUL
		local humanoidHeight = hum.HipHeight + 2.5
		local topWorld = hrp.Position + Vector3.new(0, humanoidHeight, 0)
		local bottomWorld = hrp.Position - Vector3.new(0, humanoidHeight, 0)
		
		local topPos = Camera:WorldToViewportPoint(topWorld)
		local bottomPos = Camera:WorldToViewportPoint(bottomWorld)
		
		local height = math.abs(topPos.Y - bottomPos.Y)
		local width = height * 0.5
		
		box.Size = Vector2.new(width, height)
		box.Position = Vector2.new(
			hrpPos.X - width / 2,
			topPos.Y
		)
		
		if isSurvivor then
			box.Color = Color3.fromRGB(0,255,0)
			box.Visible = SurvivorESP.Box
		elseif isKiller then
			box.Color = Color3.fromRGB(255,0,0)
			box.Visible = KillerESP.Box
		end -- ton toggle


				-- ===== NICKNAME ESP =====
				if name and (
					(isSurvivor and SurvivorESP.Nickname) or
					(isKiller and KillerESP.Nickname)
				) then

					if isSurvivor then
						name.Color = Color3.fromRGB(0,255,0)
					else
						name.Color = Color3.fromRGB(255,0,0)
					end
	
					name.Text = plr.Name
	
					name.Position = Vector2.new(
						hrpPos.X,
						topPos.Y - 18 -- au dessus de la box
					)
	
					name.Visible = true
				end

-- ===== SKELETON FINAL FIX =====
local skeleton = espSkeletons[plr]

if skeleton then
    if (isSurvivor and SurvivorESP.Skeleton) or
   		(isKiller and KillerESP.Skeleton) then

		local color = isSurvivor and
			Color3.fromRGB(0,255,0) or
			Color3.fromRGB(255,0,0)

		for _, line in ipairs(skeleton) do
			line.Color = color
		end
        
        local screenSize = Camera.ViewportSize
        
        -- Si le HRP est hors écran → on cache tout
        if not onScreen 
        or hrpPos.X < 0 or hrpPos.X > screenSize.X
        or hrpPos.Y < 0 or hrpPos.Y > screenSize.Y then
            
            for _, line in ipairs(skeleton) do
                line.Visible = false
            end
            
        else
            
            local rigType = hum.RigType
            local rigBones
            
            if rigType == Enum.HumanoidRigType.R15 then
                rigBones = {
                    {"Head","UpperTorso"},
                    {"UpperTorso","LowerTorso"},
                    {"UpperTorso","LeftUpperArm"},
                    {"LeftUpperArm","LeftLowerArm"},
                    {"LeftLowerArm","LeftHand"},
                    {"UpperTorso","RightUpperArm"},
                    {"RightUpperArm","RightLowerArm"},
                    {"RightLowerArm","RightHand"},
                    {"LowerTorso","LeftUpperLeg"},
                    {"LeftUpperLeg","LeftLowerLeg"},
                    {"LeftLowerLeg","LeftFoot"},
                    {"LowerTorso","RightUpperLeg"},
                    {"RightUpperLeg","RightLowerLeg"},
                    {"RightLowerLeg","RightFoot"},
                }
            else
                rigBones = {
                    {"Head","Torso"},
                    {"Torso","Left Arm"},
                    {"Torso","Right Arm"},
                    {"Torso","Left Leg"},
                    {"Torso","Right Leg"},
                }
            end

            -- Reset avant redraw
            for _, line in ipairs(skeleton) do
                line.Visible = false
            end

            for i, bone in ipairs(rigBones) do
                local part0 = char:FindFirstChild(bone[1])
                local part1 = char:FindFirstChild(bone[2])

                if part0 and part1 then

                    local pos0, vis0 = Camera:WorldToViewportPoint(part0.Position)
                    local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)

                    if vis0 and vis1
                    and pos0.X >= 0 and pos0.X <= screenSize.X
                    and pos0.Y >= 0 and pos0.Y <= screenSize.Y
                    and pos1.X >= 0 and pos1.X <= screenSize.X
                    and pos1.Y >= 0 and pos1.Y <= screenSize.Y then

                        skeleton[i].From = Vector2.new(pos0.X, pos0.Y)
                        skeleton[i].To = Vector2.new(pos1.X, pos1.Y)
                        skeleton[i].Visible = true
                    else
                        skeleton[i].Visible = false
                    end
                else
                    skeleton[i].Visible = false
                end
            end
        end
        
    else
        -- Toggle OFF
        for _, line in ipairs(skeleton) do
            line.Visible = false
        end
    end
end


-- ===== HEALTH BAR =====
local healthBar = espHealthBars[plr]

if healthBar then
	
	if (isSurvivor and SurvivorESP.Health) or
		(isKiller and KillerESP.Health) then
		
		local healthPercent = hum.Health / hum.MaxHealth
		healthPercent = math.clamp(healthPercent, 0, 1)

		local barHeight = height * healthPercent
		local barWidth = 4
		
		local barX = box.Position.X - 12
		local barY = box.Position.Y + (height - barHeight)

		-- Outline
		healthBar.Outline.Size = Vector2.new(barWidth, height)
		healthBar.Outline.Position = Vector2.new(barX, box.Position.Y)
		healthBar.Outline.Visible = true

		-- Fill
		healthBar.Bar.Size = Vector2.new(barWidth, barHeight)
		healthBar.Bar.Position = Vector2.new(barX, barY)
		healthBar.Bar.Visible = true

		-- 🎨 COLOR SYSTEM
		if healthPercent > 0.75 then
			healthBar.Bar.Color = Color3.fromRGB(0,255,0) -- Vert
			
		elseif healthPercent > 0.5 then
			healthBar.Bar.Color = Color3.fromRGB(255,255,0) -- Jaune
			
		elseif healthPercent > 0.25 then
			healthBar.Bar.Color = Color3.fromRGB(255,165,0) -- Orange
			
		else
			healthBar.Bar.Color = Color3.fromRGB(255,0,0) -- Rouge
		end

	else
		healthBar.Outline.Visible = false
		healthBar.Bar.Visible = false
	end
end

		
		-- ===== LINE ESP =====
		if line then
			if (isSurvivor and SurvivorESP.Line) or
   				(isKiller and KillerESP.Line) then

				if isSurvivor then
					line.Color = Color3.fromRGB(0,255,0)
				else
					line.Color = Color3.fromRGB(255,0,0)
				end

			local screenSize = Camera.ViewportSize
		
			line.From = Vector2.new(
				screenSize.X / 2,
				screenSize.Y
			)
		
			-- centre bas EXACT de la box
			line.To = Vector2.new(
				box.Position.X + box.Size.X / 2,
				box.Position.Y + box.Size.Y
			)
		
				line.Visible = true
			else
				line.Visible = false
			end
		end
	end
	
end)


for _, plr in ipairs(game.Players:GetPlayers()) do
	print("-----")
	print("Name:", plr.Name)
	print("Team:", plr.Team)
	print("TeamColor:", plr.TeamColor)
	print("leaderstats:", plr:FindFirstChild("leaderstats"))
	print("Attr Team:", plr:GetAttribute("Team"))
	print("Attr Faction:", plr:GetAttribute("Faction"))
end


RunService.RenderStepped:Connect(function()

	if fovEnabled then
		workspace.CurrentCamera.FieldOfView = getFovValue()
	end

end)

-- =========================
-- DRAG SYSTEM
-- =========================

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- =========================
-- INSERT KEY
-- =========================

local isOpen = true

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		isOpen = not isOpen
		frame.Visible = isOpen
	end
end)
