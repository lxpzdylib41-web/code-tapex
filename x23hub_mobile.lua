-- ============================================================
-- X23HUB — VERSIÓN MOBILE v2
-- · Tabs: CODE | RIDDLE | LOG
-- · Minimizar → ícono flotante (click/tap para restaurar, arrastrable)
-- · Traductor EN→ES en todos los logs y mensajes
-- ============================================================
local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui
if playerGui:FindFirstChild("X23HUB_M") then playerGui.X23HUB_M:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "X23HUB_M"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local ICON_ID = "rbxassetid://105942777284630" -- 🔁 Cambia por tu imagen

-- ============================================================
-- TRADUCTOR EN → ES
-- ============================================================
local dict = {
    ["mutation"]        = "mutación",
    ["mutations"]       = "mutaciones",
    ["favourite"]       = "favorito",
    ["favorite"]        = "favorito",
    ["admin"]           = "admin",
    ["wars"]            = "guerras",
    ["brainrot"]        = "brainrot",
    ["code"]            = "código",
    ["codes"]           = "códigos",
    ["redeem"]          = "canjear",
    ["reward"]          = "recompensa",
    ["rewards"]         = "recompensas",
    ["earned"]          = "ganaste",
    ["joined"]          = "entró",
    ["left"]            = "salió",
    ["riddle"]          = "adivinanza",
    ["answer"]          = "respuesta",
    ["hint"]            = "pista",
    ["winner"]          = "ganador",
    ["winners"]         = "ganadores",
    ["event"]           = "evento",
    ["update"]          = "actualización",
    ["new"]             = "nuevo",
    ["secret"]          = "secreto",
    ["owner"]           = "dueño",
    ["facts"]           = "datos",
    ["question"]        = "pregunta",
    ["what"]            = "qué",
    ["who"]             = "quién",
    ["is"]              = "es",
    ["the"]             = "el",
    ["and"]             = "y",
    ["or"]              = "o",
    ["your"]            = "tu",
    ["you"]             = "tú",
    ["has"]             = "tiene",
    ["have"]            = "tienen",
    ["get"]             = "obtén",
    ["free"]            = "gratis",
    ["limited"]         = "limitado",
    ["time"]            = "tiempo",
    ["now"]             = "ahora",
    ["players"]         = "jugadores",
    ["player"]          = "jugador",
    ["server"]          = "servidor",
    ["game"]            = "juego",
    ["win"]             = "ganar",
    ["lost"]            = "perdiste",
    ["congrats"]        = "felicidades",
    ["congratulations"] = "felicitaciones",
    ["correct"]         = "correcto",
    ["wrong"]           = "incorrecto",
    ["first"]           = "primero",
    ["second"]          = "segundo",
    ["third"]           = "tercero",
    ["type"]            = "escribe",
    ["enter"]           = "ingresa",
    ["box"]             = "caja",
    ["number"]          = "número",
    ["next"]            = "siguiente",
    ["round"]           = "ronda",
    ["announced"]       = "anunciado",
    ["welcome"]         = "bienvenido",
    ["congratulate"]    = "felicitar",
    ["server"]          = "servidor",
    ["announce"]        = "anunciar",
    ["notice"]          = "aviso",
}

local function translate(text)
    if not text or text == "" then return text end
    return text:gsub("(%a+)", function(word)
        local t = dict[word:lower()]
        if t then
            return word:sub(1,1):match("%u") and (t:sub(1,1):upper()..t:sub(2)) or t
        end
        return word
    end)
end

-- ============================================================
-- UTILIDADES
-- ============================================================
local function makeCorner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 12); c.Parent = p; return c
end
local function makeStroke(p, col, tr, th)
    local s = Instance.new("UIStroke"); s.Color = col; s.Transparency = tr or 0.5
    s.Thickness = th or 1; s.Parent = p; return s
end

-- ============================================================
-- ÍCONO FLOTANTE con fix de click vs drag
-- ============================================================
local function makeFloatIcon(pos, tint)
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 56, 0, 56)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    btn.BackgroundTransparency = 0.05
    btn.BorderSizePixel = 0
    btn.Image = ICON_ID
    btn.ImageColor3 = tint
    btn.ScaleType = Enum.ScaleType.Fit
    btn.Visible = false
    btn.Parent = screenGui
    makeCorner(btn, 16)
    makeStroke(btn, tint, 0.3, 2)
    return btn
end

local function connectFloatIcon(btn, onRestore)
    local dragging, dragStart, startPos, didDrag = false, nil, nil, false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position
            startPos = btn.Position; didDrag = false
        end
    end)
    btn.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 8 then didDrag = true end
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                     startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            local was = didDrag; dragging = false; didDrag = false
            if not was then onRestore() end
        end
    end)
end

-- ============================================================
-- RAINBOW
-- ============================================================
local rainbowCbs = {}
task.spawn(function()
    while true do
        for h = 0, 1, 0.01 do
            local rgb = Color3.fromHSV(h, 0.4, 0.4)
            for _, cb in ipairs(rainbowCbs) do pcall(cb, rgb) end
            task.wait(0.03)
        end
    end
end)

-- ============================================================
-- VENTANA PRINCIPAL
-- ============================================================
local WIN_W  = 300
local WIN_H  = 380
local HDR_H  = 46

local win = Instance.new("Frame")
win.Size = UDim2.new(0, WIN_W, 0, WIN_H)
win.Position = UDim2.new(0.5, -WIN_W/2, 1, -(WIN_H + 20))
win.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
win.BackgroundTransparency = 0.05
win.BorderSizePixel = 0
win.ClipsDescendants = true
win.Parent = screenGui
makeCorner(win, 18)
local winStroke = makeStroke(win, Color3.fromRGB(0,200,255), 0.4, 1.5)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, HDR_H)
header.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
header.BackgroundTransparency = 0.82
header.BorderSizePixel = 0
header.Parent = win
makeCorner(header, 18)

local hIcon = Instance.new("ImageLabel")
hIcon.Size = UDim2.new(0, 28, 0, 28)
hIcon.Position = UDim2.new(0, 10, 0.5, -14)
hIcon.BackgroundTransparency = 1
hIcon.Image = ICON_ID
hIcon.ImageColor3 = Color3.fromRGB(0, 220, 255)
hIcon.ScaleType = Enum.ScaleType.Fit
hIcon.Parent = header

local hTitle = Instance.new("TextLabel")
hTitle.Size = UDim2.new(1, -100, 1, 0)
hTitle.Position = UDim2.new(0, 46, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "X23 HUB"
hTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
hTitle.Font = Enum.Font.GothamBold
hTitle.TextSize = 14
hTitle.TextXAlignment = Enum.TextXAlignment.Left
hTitle.Parent = header

-- Botón minimizar grande (touch)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 40, 0, 32)
minBtn.Position = UDim2.new(1, -48, 0.5, -16)
minBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
minBtn.BackgroundTransparency = 0.2
minBtn.BorderSizePixel = 0
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.Parent = header
makeCorner(minBtn, 8)

-- Ícono flotante
local floatIcon = makeFloatIcon(UDim2.new(0.5,-28,1,-76), Color3.fromRGB(0,220,255))
connectFloatIcon(floatIcon, function()
    floatIcon.Visible = false
    win.Visible = true
end)

minBtn.MouseButton1Click:Connect(function()
    floatIcon.Position = UDim2.new(
        win.Position.X.Scale, win.Position.X.Offset,
        win.Position.Y.Scale, win.Position.Y.Offset)
    win.Visible = false
    floatIcon.Visible = true
end)

-- Rainbow
table.insert(rainbowCbs, function(rgb)
    winStroke.Color = rgb; header.BackgroundColor3 = rgb
    hTitle.TextColor3 = rgb; hIcon.ImageColor3 = rgb
    win.BackgroundColor3 = rgb:Lerp(Color3.fromRGB(10,10,14), 0.7)
    floatIcon.ImageColor3 = rgb
    local s = floatIcon:FindFirstChildOfClass("UIStroke"); if s then s.Color = rgb end
end)

-- Drag header (touch + mouse)
local drag, dStart, dPos
header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        drag=true; dStart=i.Position; dPos=win.Position end
end)
header.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
    or i.UserInputType == Enum.UserInputType.Touch) then
        local d=i.Position-dStart
        win.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y) end
end)
header.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then drag=false end
end)

-- ============================================================
-- TAB BAR
-- ============================================================
local TAB_H = 40
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, TAB_H)
tabBar.Position = UDim2.new(0, 0, 0, HDR_H)
tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
tabBar.BackgroundTransparency = 0.3
tabBar.BorderSizePixel = 0
tabBar.Parent = win

local CONTENT_Y = HDR_H + TAB_H
local CONTENT_H = WIN_H - CONTENT_Y
local tabNames = {"CODE", "RIDDLE", "LOG"}
local tabBtns, tabPages = {}, {}
local activeTab = 1

for i = 1, 3 do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 0, CONTENT_H)
    page.Position = UDim2.new(0, 0, 0, CONTENT_Y)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = (i == 1)
    page.Parent = win
    tabPages[i] = page
end

local function setActiveTab(idx)
    for j, b in ipairs(tabBtns) do
        b.BackgroundTransparency = 0.7
        b.TextColor3 = Color3.fromRGB(100,100,120)
        b.BackgroundColor3 = Color3.fromRGB(20,20,28)
        tabPages[j].Visible = false
    end
    tabBtns[idx].BackgroundTransparency = 0.5
    tabBtns[idx].TextColor3 = Color3.fromRGB(0,220,255)
    tabBtns[idx].BackgroundColor3 = Color3.fromRGB(0,160,220)
    tabPages[idx].Visible = true
    activeTab = idx
end

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/3, -2, 1, -6)
    btn.Position = UDim2.new((i-1)/3, 1, 0, 3)
    btn.BackgroundColor3 = i==1 and Color3.fromRGB(0,160,220) or Color3.fromRGB(20,20,28)
    btn.BackgroundTransparency = i==1 and 0.5 or 0.7
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = i==1 and Color3.fromRGB(0,220,255) or Color3.fromRGB(100,100,120)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
    btn.Parent = tabBar
    makeCorner(btn, 8)
    tabBtns[i] = btn
    btn.MouseButton1Click:Connect(function() setActiveTab(i) end)
end

-- Rainbow tab activo
table.insert(rainbowCbs, function(rgb)
    tabBtns[activeTab].TextColor3 = rgb
    tabBtns[activeTab].BackgroundColor3 = rgb:Lerp(Color3.fromRGB(10,10,14), 0.6)
end)

-- ============================================================
-- PÁGINA 1: CODE
-- ============================================================
local codePage = tabPages[1]

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1,-20,0,54)
autoBtn.Position = UDim2.new(0,10,0,10)
autoBtn.BackgroundColor3 = Color3.fromRGB(0,180,255)
autoBtn.BackgroundTransparency = 0.8; autoBtn.BorderSizePixel = 0
autoBtn.Text = "AUTO CODE: OFF"
autoBtn.TextColor3 = Color3.fromRGB(0,220,255)
autoBtn.Font = Enum.Font.GothamBold; autoBtn.TextSize = 15
autoBtn.Parent = codePage
makeCorner(autoBtn, 12)
local autoBtnStroke = makeStroke(autoBtn, Color3.fromRGB(0,200,255), 0.5, 1)

local upperBtn = Instance.new("TextButton")
upperBtn.Size = UDim2.new(0.5,-14,0,46)
upperBtn.Position = UDim2.new(0,10,0,72)
upperBtn.BackgroundColor3 = Color3.fromRGB(0,180,255)
upperBtn.BackgroundTransparency = 0.7; upperBtn.BorderSizePixel = 0
upperBtn.Text = "UPPER"; upperBtn.TextColor3 = Color3.fromRGB(0,220,255)
upperBtn.Font = Enum.Font.GothamBold; upperBtn.TextSize = 13
upperBtn.Parent = codePage
makeCorner(upperBtn, 10)
local upperStroke = makeStroke(upperBtn, Color3.fromRGB(0,200,255), 0.4, 1)

local lowerBtn = Instance.new("TextButton")
lowerBtn.Size = UDim2.new(0.5,-14,0,46)
lowerBtn.Position = UDim2.new(0.5,4,0,72)
lowerBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
lowerBtn.BackgroundTransparency = 0.93; lowerBtn.BorderSizePixel = 0
lowerBtn.Text = "lower"; lowerBtn.TextColor3 = Color3.fromRGB(150,150,170)
lowerBtn.Font = Enum.Font.Gotham; lowerBtn.TextSize = 13
lowerBtn.Parent = codePage
makeCorner(lowerBtn, 10)
local lowerStroke = makeStroke(lowerBtn, Color3.fromRGB(100,100,120), 0.7, 1)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1,-20,0,30)
statusLbl.Position = UDim2.new(0,10,0,126)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Estado: INACTIVO"
statusLbl.TextColor3 = Color3.fromRGB(100,100,120)
statusLbl.Font = Enum.Font.Gotham; statusLbl.TextSize = 13
statusLbl.TextXAlignment = Enum.TextXAlignment.Center
statusLbl.Parent = codePage

-- ============================================================
-- PÁGINA 2: RIDDLE
-- ============================================================
local riddlePage = tabPages[2]

local rInputLbl = Instance.new("TextLabel")
rInputLbl.Size = UDim2.new(1,-20,0,18); rInputLbl.Position = UDim2.new(0,10,0,8)
rInputLbl.BackgroundTransparency = 1; rInputLbl.Text = "PEGA EL RIDDLE AQUÍ:"
rInputLbl.TextColor3 = Color3.fromRGB(200,150,60); rInputLbl.Font = Enum.Font.GothamBold
rInputLbl.TextSize = 11; rInputLbl.TextXAlignment = Enum.TextXAlignment.Left
rInputLbl.Parent = riddlePage

local rInputFrame = Instance.new("Frame")
rInputFrame.Size = UDim2.new(1,-20,0,72); rInputFrame.Position = UDim2.new(0,10,0,28)
rInputFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
rInputFrame.BackgroundTransparency = 0.93; rInputFrame.BorderSizePixel = 0
rInputFrame.Parent = riddlePage
makeCorner(rInputFrame, 10)
makeStroke(rInputFrame, Color3.fromRGB(200,150,60), 0.6, 1)

local rInput = Instance.new("TextBox")
rInput.Size = UDim2.new(1,-16,1,-10); rInput.Position = UDim2.new(0,8,0,5)
rInput.BackgroundTransparency = 1
rInput.PlaceholderText = "Pega el texto del riddle aquí..."
rInput.PlaceholderColor3 = Color3.fromRGB(100,100,110); rInput.Text = ""
rInput.TextColor3 = Color3.fromRGB(230,230,235); rInput.Font = Enum.Font.Gotham; rInput.TextSize = 13
rInput.TextWrapped = true; rInput.MultiLine = true; rInput.ClearTextOnFocus = false
rInput.TextXAlignment = Enum.TextXAlignment.Left; rInput.TextYAlignment = Enum.TextYAlignment.Top
rInput.Parent = rInputFrame

local rResult = Instance.new("TextLabel")
rResult.Size = UDim2.new(1,-20,0,22); rResult.Position = UDim2.new(0,10,0,106)
rResult.BackgroundTransparency = 1; rResult.Text = "La respuesta aparecerá aquí"
rResult.TextColor3 = Color3.fromRGB(120,120,140); rResult.Font = Enum.Font.GothamBold; rResult.TextSize = 12
rResult.TextWrapped = true; rResult.TextXAlignment = Enum.TextXAlignment.Left
rResult.Parent = riddlePage

local solveBtn = Instance.new("TextButton")
solveBtn.Size = UDim2.new(0.58,-12,0,52); solveBtn.Position = UDim2.new(0,10,0,134)
solveBtn.BackgroundColor3 = Color3.fromRGB(255,150,40)
solveBtn.BackgroundTransparency = 0.7; solveBtn.BorderSizePixel = 0
solveBtn.Text = "✓ RESOLVER"; solveBtn.TextColor3 = Color3.fromRGB(255,210,120)
solveBtn.Font = Enum.Font.GothamBold; solveBtn.TextSize = 13
solveBtn.Parent = riddlePage
makeCorner(solveBtn, 12)
makeStroke(solveBtn, Color3.fromRGB(255,150,40), 0.5, 1)

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.42,-8,0,52); clearBtn.Position = UDim2.new(0.58,4,0,134)
clearBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
clearBtn.BackgroundTransparency = 0.93; clearBtn.BorderSizePixel = 0
clearBtn.Text = "✕ LIMPIAR"; clearBtn.TextColor3 = Color3.fromRGB(150,150,170)
clearBtn.Font = Enum.Font.Gotham; clearBtn.TextSize = 13
clearBtn.Parent = riddlePage
makeCorner(clearBtn, 12)

local hintBtn = Instance.new("TextButton")
hintBtn.Size = UDim2.new(1,-20,0,42); hintBtn.Position = UDim2.new(0,10,0,196)
hintBtn.BackgroundColor3 = Color3.fromRGB(255,150,40)
hintBtn.BackgroundTransparency = 0.82; hintBtn.BorderSizePixel = 0
hintBtn.Text = "LOGGER DE PISTAS: OFF"; hintBtn.TextColor3 = Color3.fromRGB(255,190,90)
hintBtn.Font = Enum.Font.GothamBold; hintBtn.TextSize = 12
hintBtn.Parent = riddlePage
makeCorner(hintBtn, 10)
local hintBtnStroke = makeStroke(hintBtn, Color3.fromRGB(255,150,40), 0.5, 1)

-- ============================================================
-- PÁGINA 3: LOG
-- ============================================================
local logPage = tabPages[3]

local function makeLogSection(parent, labelText, labelColor, yPos, height)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-16,0,16); lbl.Position = UDim2.new(0,8,0,yPos)
    lbl.BackgroundTransparency = 1; lbl.Text = labelText
    lbl.TextColor3 = labelColor; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-16,0,height); frame.Position = UDim2.new(0,8,0,yPos+18)
    frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    frame.BackgroundTransparency = 0.95; frame.BorderSizePixel = 0
    frame.Parent = parent; makeCorner(frame, 8)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-8,1,-8); scroll.Position = UDim2.new(0,4,0,4)
    scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4; scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0,2); layout.Parent = scroll

    return scroll
end

local logScroll  = makeLogSection(logPage, "HISTORIAL DE CÓDIGOS",  Color3.fromRGB(120,200,230), 6,  118)
local hintScroll = makeLogSection(logPage, "HISTORIAL DE MENSAJES", Color3.fromRGB(255,190,90),  152, 118)

-- ============================================================
-- FUNCIONES DE LOG
-- ============================================================
local function addToScroll(scroll, text, color, maxEntries)
    local e = Instance.new("TextLabel")
    e.Size = UDim2.new(1,0,0,0); e.AutomaticSize = Enum.AutomaticSize.Y
    e.BackgroundTransparency = 1; e.Text = text; e.TextColor3 = color
    e.Font = Enum.Font.Gotham; e.TextSize = 11
    e.TextWrapped = true; e.TextXAlignment = Enum.TextXAlignment.Left
    e.Parent = scroll
    local cnt = 0
    for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextLabel") then cnt+=1 end end
    if cnt > maxEntries then
        for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy(); break end end
    end
    task.defer(function() scroll.CanvasPosition = Vector2.new(0, scroll.AbsoluteCanvasSize.Y) end)
end

local function addLogEntry(text, kind)
    local color = Color3.fromRGB(0,220,255)
    if kind == "riddle_solved" then color = Color3.fromRGB(80,255,160)
    elseif kind == "riddle_unknown" then color = Color3.fromRGB(255,170,60) end
    addToScroll(logScroll, text, color, 30)
end

local function addHintEntry(text)
    local ts = os.date("%H:%M:%S")
    addToScroll(hintScroll, "["..ts.."] "..translate(text), Color3.fromRGB(220,220,230), 100)
end

-- ============================================================
-- LÓGICA
-- ============================================================
local autoCodeEnabled = false
local caseMode = "upper"

local function setCase(mode)
    caseMode = mode
    if mode == "upper" then
        upperBtn.BackgroundTransparency=0.7; upperBtn.TextColor3=Color3.fromRGB(0,220,255); upperStroke.Transparency=0.4
        lowerBtn.BackgroundTransparency=0.93; lowerBtn.TextColor3=Color3.fromRGB(150,150,170); lowerStroke.Transparency=0.7
    else
        lowerBtn.BackgroundTransparency=0.7; lowerBtn.TextColor3=Color3.fromRGB(0,220,255); lowerStroke.Transparency=0.4
        upperBtn.BackgroundTransparency=0.93; upperBtn.TextColor3=Color3.fromRGB(150,150,170); upperStroke.Transparency=0.7
    end
end
upperBtn.MouseButton1Click:Connect(function() setCase("upper") end)
lowerBtn.MouseButton1Click:Connect(function() setCase("lower") end)

local function openCodesMenu()
    local b = playerGui.LeftCenter.LeftCenter.Buttons.Codes
    if b then for _,c in ipairs(getconnections(b.Activated)) do c:Fire() end end
end
local function isCodesOpen()
    local cg = playerGui:FindFirstChild("Codes")
    if cg then local i=cg:FindFirstChild("Codes"); if i then return i.Visible end; return cg.Enabled end
    return false
end

local riddleTable = {
    {keywords={"mutation","favourite"}, answer="Candy24Sammy"},
    {keywords={"admin","wars"},         answer=""},
    {keywords={"2nd mutation"},         answer=""},
    {keywords={"favourite","brainrot"}, answer=""},
    {keywords={"facts","owner"},        answer=""},
}
local function findRiddleAnswer(text)
    local low = text:lower()
    for _,e in ipairs(riddleTable) do
        if e.answer ~= "" then
            local ok = true
            for _,kw in ipairs(e.keywords) do if not low:find(kw:lower(),1,true) then ok=false; break end end
            if ok then return e.answer end
        end
    end
end
local function typeIntoCodeBox(raw)
    local fmt = caseMode=="upper" and raw:upper() or raw:lower()
    local box = playerGui.Codes.Codes.CodeRedeem.TextBox
    if box then box:CaptureFocus(); box.Text=(box.Text or "")..fmt end
    return fmt
end

autoBtn.MouseButton1Click:Connect(function()
    autoCodeEnabled = not autoCodeEnabled
    if autoCodeEnabled then
        autoBtn.Text="AUTO CODE: ON ✓"; autoBtn.TextColor3=Color3.fromRGB(80,255,160); autoBtnStroke.Color=Color3.fromRGB(80,255,160)
        statusLbl.Text="Estado: ACTIVO 🟢"; statusLbl.TextColor3=Color3.fromRGB(80,255,160)
        task.spawn(function() while autoCodeEnabled do if not isCodesOpen() then openCodesMenu() end; task.wait(0.5) end end)
    else
        autoBtn.Text="AUTO CODE: OFF"; autoBtn.TextColor3=Color3.fromRGB(0,220,255); autoBtnStroke.Color=Color3.fromRGB(0,200,255)
        statusLbl.Text="Estado: INACTIVO"; statusLbl.TextColor3=Color3.fromRGB(100,100,120)
    end
end)

solveBtn.MouseButton1Click:Connect(function()
    local txt = rInput.Text
    if not txt or txt:gsub("%s","") == "" then
        rResult.Text="Escribe o pega un riddle primero"; rResult.TextColor3=Color3.fromRGB(255,170,60); return
    end
    local ans = findRiddleAnswer(txt)
    if ans then
        typeIntoCodeBox(ans)
        rResult.Text="✓ Respuesta: "..ans.." (pegado)"; rResult.TextColor3=Color3.fromRGB(80,255,160)
        addLogEntry("✓ RESUELTO → "..ans, "riddle_solved")
    else
        rResult.Text="✕ Sin coincidencia en la tabla"; rResult.TextColor3=Color3.fromRGB(255,100,100)
        addLogEntry("✕ DESCONOCIDO: "..translate(txt), "riddle_unknown")
    end
end)
clearBtn.MouseButton1Click:Connect(function()
    rInput.Text=""; rResult.Text="La respuesta aparecerá aquí"; rResult.TextColor3=Color3.fromRGB(120,120,140)
end)

local hintLoggerEnabled = false
hintBtn.MouseButton1Click:Connect(function()
    hintLoggerEnabled = not hintLoggerEnabled
    if hintLoggerEnabled then
        hintBtn.Text="LOGGER DE PISTAS: ON ✓"; hintBtn.TextColor3=Color3.fromRGB(80,255,160); hintBtnStroke.Color=Color3.fromRGB(80,255,160)
    else
        hintBtn.Text="LOGGER DE PISTAS: OFF"; hintBtn.TextColor3=Color3.fromRGB(255,190,90); hintBtnStroke.Color=Color3.fromRGB(255,150,40)
    end
end)

local function handleNotif(text)
    if text == "" then return end
    if hintLoggerEnabled then addHintEntry(text) end
    if not autoCodeEnabled then return end
    local ans = findRiddleAnswer(text)
    if ans then
        typeIntoCodeBox(ans)
        addLogEntry("✓ ADIVINANZA → "..ans, "riddle_solved")
    else
        local looksRiddle = text:lower():find("who") or text:lower():find("what")
            or text:lower():find("riddle") or text:lower():find("favourite") or text:lower():find("favorite")
        if looksRiddle then
            addLogEntry("? RIDDLE SIN RESPUESTA: "..translate(text), "riddle_unknown")
        else
            typeIntoCodeBox(text)
            addLogEntry("📋 CÓDIGO → "..text, "code")
        end
    end
end

playerGui.DescendantAdded:Connect(function(v)
    if v:IsA("TextLabel") and v.Name=="Template" and v:FindFirstAncestor("TopNotification") then
        task.defer(function()
            handleNotif(v.Text)
            v:GetPropertyChangedSignal("Text"):Connect(function() handleNotif(v.Text) end)
        end)
    end
end)
