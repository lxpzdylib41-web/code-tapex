-- ============================================================
-- X23HUB — VERSIÓN PC  v2
-- · Minimizar → ícono flotante con imagen (click para restaurar)
-- · Traductor EN→ES en logs y mensajes
-- ============================================================
local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui
if playerGui:FindFirstChild("X23HUB") then playerGui.X23HUB:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "X23HUB"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local ICON_ID = "rbxassetid://101579838151121" -- 🔁 Cambia por tu imagen

-- ============================================================
-- TRADUCTOR EN → ES
-- ============================================================
local dict = {
    -- palabras sueltas
    ["mutation"]      = "mutación",
    ["mutations"]     = "mutaciones",
    ["favourite"]     = "favorito",
    ["favorite"]      = "favorito",
    ["admin"]         = "admin",
    ["wars"]          = "guerras",
    ["brainrot"]      = "brainrot",
    ["code"]          = "código",
    ["codes"]         = "códigos",
    ["redeem"]        = "canjear",
    ["reward"]        = "recompensa",
    ["rewards"]       = "recompensas",
    ["earned"]        = "ganaste",
    ["joined"]        = "entró",
    ["left"]          = "salió",
    ["riddle"]        = "adivinanza",
    ["answer"]        = "respuesta",
    ["hint"]          = "pista",
    ["winner"]        = "ganador",
    ["winners"]       = "ganadores",
    ["event"]         = "evento",
    ["update"]        = "actualización",
    ["new"]           = "nuevo",
    ["secret"]        = "secreto",
    ["owner"]         = "dueño",
    ["facts"]         = "datos",
    ["question"]      = "pregunta",
    ["what"]          = "qué",
    ["who"]           = "quién",
    ["is"]            = "es",
    ["the"]           = "el",
    ["and"]           = "y",
    ["or"]            = "o",
    ["your"]          = "tu",
    ["you"]           = "tú",
    ["has"]           = "tiene",
    ["have"]          = "tienen",
    ["get"]           = "obtén",
    ["free"]          = "gratis",
    ["limited"]       = "limitado",
    ["time"]          = "tiempo",
    ["now"]           = "ahora",
    ["players"]       = "jugadores",
    ["player"]        = "jugador",
    ["server"]        = "servidor",
    ["game"]          = "juego",
    ["win"]           = "ganar",
    ["lost"]          = "perdiste",
    ["congrats"]      = "felicidades",
    ["congratulations"] = "felicitaciones",
    ["correct"]       = "correcto",
    ["wrong"]         = "incorrecto",
    ["first"]         = "primero",
    ["second"]        = "segundo",
    ["third"]         = "tercero",
    ["type"]          = "escribe",
    ["enter"]         = "ingresa",
    ["box"]           = "caja",
    ["number"]        = "número",
    ["next"]          = "siguiente",
    ["round"]         = "ronda",
}

local function translate(text)
    if not text or text == "" then return text end
    -- reemplaza palabra por palabra (case-insensitive)
    local result = text:gsub("(%a+)", function(word)
        local lower = word:lower()
        local translated = dict[lower]
        if translated then
            -- mantener mayúscula inicial si la original la tenía
            if word:sub(1,1):match("%u") then
                return translated:sub(1,1):upper() .. translated:sub(2)
            end
            return translated
        end
        return word
    end)
    return result
end

-- ============================================================
-- UTILIDADES
-- ============================================================
local function makeCorner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 10); c.Parent = p; return c
end
local function makeStroke(p, col, tr, th)
    local s = Instance.new("UIStroke"); s.Color = col; s.Transparency = tr or 0.5
    s.Thickness = th or 1; s.Parent = p; return s
end

-- ============================================================
-- ÍCONO FLOTANTE — bug fix: usa InputEnded + umbral de arrastre
-- ============================================================
local function makeFloatIcon(pos, imageId, tint)
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 44, 0, 44)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    btn.Image = imageId
    btn.ImageColor3 = tint
    btn.ScaleType = Enum.ScaleType.Fit
    btn.Visible = false
    btn.Parent = screenGui
    makeCorner(btn, 12)
    makeStroke(btn, tint, 0.35, 2)
    return btn
end

-- Conecta drag + click (separados para evitar el bug)
local function connectFloatIcon(btn, onRestore)
    local dragging, dragStart, startPos, didDrag = false, nil, nil, false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
            didDrag = false
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
            local wasDrag = didDrag
            dragging = false; didDrag = false
            if not wasDrag then
                -- fue un click real → restaurar ventana
                onRestore()
            end
        end
    end)
end

-- ============================================================
-- RAINBOW
-- ============================================================
local rainbowA, rainbowB = {}, {}
task.spawn(function()
    while true do
        for h = 0, 1, 0.01 do
            local rgb = Color3.fromHSV(h, 0.35, 0.35)
            for _, cb in ipairs(rainbowA) do pcall(cb, rgb) end
            task.wait(0.03)
        end
    end
end)
task.spawn(function()
    while true do
        for h = 0, 1, 0.01 do
            local rgb = Color3.fromHSV(h, 1, 1)
            for _, cb in ipairs(rainbowB) do pcall(cb, rgb) end
            task.wait(0.03)
        end
    end
end)

-- ============================================================
-- VENTANA PRINCIPAL
-- ============================================================
local MAIN_H = 210
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 240, 0, MAIN_H)
main.Position = UDim2.new(0.5, -120, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui
makeCorner(main, 14)
local mainStroke = makeStroke(main, Color3.fromRGB(0,200,255), 0.5, 1)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
header.BackgroundTransparency = 0.85
header.BorderSizePixel = 0
header.Parent = main
makeCorner(header, 14)

local hIcon = Instance.new("ImageLabel")
hIcon.Size = UDim2.new(0, 20, 0, 20)
hIcon.Position = UDim2.new(0, 6, 0.5, -10)
hIcon.BackgroundTransparency = 1
hIcon.Image = ICON_ID
hIcon.ImageColor3 = Color3.fromRGB(0, 220, 255)
hIcon.ScaleType = Enum.ScaleType.Fit
hIcon.Parent = header

local hTitle = Instance.new("TextLabel")
hTitle.Size = UDim2.new(1, -60, 1, 0)
hTitle.Position = UDim2.new(0, 30, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "CODE PASTE X23"
hTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
hTitle.Font = Enum.Font.GothamBold
hTitle.TextSize = 11
hTitle.TextXAlignment = Enum.TextXAlignment.Left
hTitle.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 18)
minBtn.Position = UDim2.new(1, -28, 0.5, -9)
minBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
minBtn.BackgroundTransparency = 0.2
minBtn.BorderSizePixel = 0
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.Parent = header
makeCorner(minBtn, 5)

-- Ícono flotante principal
local mainIcon = makeFloatIcon(UDim2.new(0.5,-22,0,20), ICON_ID, Color3.fromRGB(0,220,255))
connectFloatIcon(mainIcon, function()
    mainIcon.Visible = false
    main.Visible = true
end)

minBtn.MouseButton1Click:Connect(function()
    mainIcon.Position = UDim2.new(
        main.Position.X.Scale, main.Position.X.Offset,
        main.Position.Y.Scale, main.Position.Y.Offset)
    main.Visible = false
    mainIcon.Visible = true
end)

-- Drag header
local drag, dStart, dPos
header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true; dStart = i.Position; dPos = main.Position end
end)
header.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dStart
        main.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset+d.X, dPos.Y.Scale, dPos.Y.Offset+d.Y) end
end)
header.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)

-- Rainbow main
table.insert(rainbowA, function(rgb)
    mainStroke.Color = rgb; hTitle.TextColor3 = rgb; hIcon.ImageColor3 = rgb
    header.BackgroundColor3 = rgb; main.BackgroundColor3 = rgb:Lerp(Color3.fromRGB(10,10,14),0.65)
    mainIcon.ImageColor3 = rgb
    local s = mainIcon:FindFirstChildOfClass("UIStroke"); if s then s.Color = rgb end
end)

-- Botones main
local autoCodeBtn = Instance.new("TextButton")
autoCodeBtn.Size = UDim2.new(1,-20,0,28)
autoCodeBtn.Position = UDim2.new(0,10,0,36)
autoCodeBtn.BackgroundColor3 = Color3.fromRGB(0,180,255)
autoCodeBtn.BackgroundTransparency = 0.85; autoCodeBtn.BorderSizePixel = 0
autoCodeBtn.Text = "AUTO CODE: OFF"
autoCodeBtn.TextColor3 = Color3.fromRGB(0,220,255)
autoCodeBtn.Font = Enum.Font.GothamBold; autoCodeBtn.TextSize = 12
autoCodeBtn.Parent = main
makeCorner(autoCodeBtn, 8)
local autoStroke = makeStroke(autoCodeBtn, Color3.fromRGB(0,200,255), 0.6, 1)

local upperBtn = Instance.new("TextButton")
upperBtn.Size = UDim2.new(0.5,-13,0,24)
upperBtn.Position = UDim2.new(0,10,0,70)
upperBtn.BackgroundColor3 = Color3.fromRGB(0,180,255)
upperBtn.BackgroundTransparency = 0.75; upperBtn.BorderSizePixel = 0
upperBtn.Text = "UPPER"; upperBtn.TextColor3 = Color3.fromRGB(0,220,255)
upperBtn.Font = Enum.Font.GothamBold; upperBtn.TextSize = 11
upperBtn.Parent = main
makeCorner(upperBtn, 6)
local upperStroke = makeStroke(upperBtn, Color3.fromRGB(0,200,255), 0.5, 1)

local lowerBtn = Instance.new("TextButton")
lowerBtn.Size = UDim2.new(0.5,-13,0,24)
lowerBtn.Position = UDim2.new(0.5,3,0,70)
lowerBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
lowerBtn.BackgroundTransparency = 0.93; lowerBtn.BorderSizePixel = 0
lowerBtn.Text = "lower"; lowerBtn.TextColor3 = Color3.fromRGB(150,150,170)
lowerBtn.Font = Enum.Font.Gotham; lowerBtn.TextSize = 11
lowerBtn.Parent = main
makeCorner(lowerBtn, 6)
local lowerStroke = makeStroke(lowerBtn, Color3.fromRGB(100,100,120), 0.7, 1)

local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1,-20,0,14); logLabel.Position = UDim2.new(0,10,0,102)
logLabel.BackgroundTransparency = 1; logLabel.Text = "HISTORIAL DE CÓDIGOS"
logLabel.TextColor3 = Color3.fromRGB(120,200,230); logLabel.Font = Enum.Font.GothamBold
logLabel.TextSize = 10; logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.Parent = main

local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1,-20,0,92); logFrame.Position = UDim2.new(0,10,0,118)
logFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
logFrame.BackgroundTransparency = 0.95; logFrame.BorderSizePixel = 0
logFrame.Parent = main
makeCorner(logFrame, 8)

local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1,-8,1,-8); logScroll.Position = UDim2.new(0,4,0,4)
logScroll.BackgroundTransparency = 1; logScroll.BorderSizePixel = 0
logScroll.ScrollBarThickness = 3; logScroll.CanvasSize = UDim2.new(0,0,0,0)
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; logScroll.Parent = logFrame
local logList = Instance.new("UIListLayout")
logList.SortOrder = Enum.SortOrder.LayoutOrder; logList.Padding = UDim.new(0,2); logList.Parent = logScroll

-- ============================================================
-- LOG ENTRIES
-- ============================================================
local function addLogEntry(text, kind)
    local color = Color3.fromRGB(0,220,255)
    if kind == "riddle_solved" then color = Color3.fromRGB(80,255,160)
    elseif kind == "riddle_unknown" then color = Color3.fromRGB(255,170,60) end
    local e = Instance.new("TextLabel")
    e.Size = UDim2.new(1,0,0,0); e.AutomaticSize = Enum.AutomaticSize.Y
    e.BackgroundTransparency = 1; e.Text = text; e.TextColor3 = color
    e.Font = Enum.Font.Gotham; e.TextSize = 10
    e.TextWrapped = true; e.TextXAlignment = Enum.TextXAlignment.Left
    e.Parent = logScroll
    local cnt = 0
    for _,c in ipairs(logScroll:GetChildren()) do if c:IsA("TextLabel") then cnt+=1 end end
    if cnt > 30 then
        for _,c in ipairs(logScroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy(); break end end
    end
    task.defer(function() logScroll.CanvasPosition = Vector2.new(0,logScroll.AbsoluteCanvasSize.Y) end)
end

-- ============================================================
-- LÓGICA
-- ============================================================
local autoCodeEnabled = false
local caseMode = "upper"

local function setCase(mode)
    caseMode = mode
    if mode == "upper" then
        upperBtn.BackgroundTransparency=0.75; upperBtn.TextColor3=Color3.fromRGB(0,220,255); upperStroke.Transparency=0.5
        lowerBtn.BackgroundTransparency=0.93; lowerBtn.TextColor3=Color3.fromRGB(150,150,170); lowerStroke.Transparency=0.7
    else
        lowerBtn.BackgroundTransparency=0.75; lowerBtn.TextColor3=Color3.fromRGB(0,220,255); lowerStroke.Transparency=0.5
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
    {keywords={"admin","wars"}, answer=""},
    {keywords={"2nd mutation"}, answer=""},
    {keywords={"favourite","brainrot"}, answer=""},
    {keywords={"facts","owner"}, answer=""},
}
local function findRiddleAnswer(text)
    local low = text:lower()
    for _,e in ipairs(riddleTable) do
        if e.answer ~= "" then
            local ok=true
            for _,kw in ipairs(e.keywords) do if not low:find(kw:lower(),1,true) then ok=false; break end end
            if ok then return e.answer end
        end
    end
end
local function typeIntoCodeBox(raw)
    local fmt = caseMode=="upper" and raw:upper() or raw:lower()
    local box = playerGui.Codes.Codes.CodeRedeem.TextBox
    if box then box:CaptureFocus(); box.Text=(box.Text or "")..fmt; print("TYPED:",box.Text) end
    return fmt
end

autoCodeBtn.MouseButton1Click:Connect(function()
    autoCodeEnabled = not autoCodeEnabled
    if autoCodeEnabled then
        autoCodeBtn.Text="AUTO CODE: ON"; autoCodeBtn.TextColor3=Color3.fromRGB(80,255,160); autoStroke.Color=Color3.fromRGB(80,255,160)
        task.spawn(function() while autoCodeEnabled do if not isCodesOpen() then openCodesMenu() end; task.wait(0.5) end end)
    else
        autoCodeBtn.Text="AUTO CODE: OFF"; autoCodeBtn.TextColor3=Color3.fromRGB(0,220,255); autoStroke.Color=Color3.fromRGB(0,200,255)
    end
end)

-- ============================================================
-- VENTANA RIDDLE
-- ============================================================
local riddleWin = Instance.new("Frame")
riddleWin.Size = UDim2.new(0,240,0,306)
riddleWin.Position = UDim2.new(0.5,-120,0,250)
riddleWin.BackgroundColor3 = Color3.fromRGB(10,10,14)
riddleWin.BackgroundTransparency = 0.1; riddleWin.BorderSizePixel = 0
riddleWin.ClipsDescendants = true; riddleWin.Parent = screenGui
makeCorner(riddleWin, 14)
local riddleStroke = makeStroke(riddleWin, Color3.fromRGB(255,170,60), 0.5, 1)

local rHeader = Instance.new("Frame")
rHeader.Size = UDim2.new(1,0,0,30)
rHeader.BackgroundColor3 = Color3.fromRGB(255,170,60)
rHeader.BackgroundTransparency = 0.85; rHeader.BorderSizePixel = 0
rHeader.Parent = riddleWin
makeCorner(rHeader, 14)

local rIcon = Instance.new("ImageLabel")
rIcon.Size = UDim2.new(0,20,0,20); rIcon.Position = UDim2.new(0,6,0.5,-10)
rIcon.BackgroundTransparency = 1; rIcon.Image = ICON_ID
rIcon.ImageColor3 = Color3.fromRGB(255,190,90); rIcon.ScaleType = Enum.ScaleType.Fit
rIcon.Parent = rHeader

local rTitle = Instance.new("TextLabel")
rTitle.Size = UDim2.new(1,-60,1,0); rTitle.Position = UDim2.new(0,30,0,0)
rTitle.BackgroundTransparency = 1; rTitle.Text = "HISTORIAL DE ANUNCIOS"
rTitle.TextColor3 = Color3.fromRGB(255,190,90); rTitle.Font = Enum.Font.GothamBold
rTitle.TextSize = 11; rTitle.TextXAlignment = Enum.TextXAlignment.Left; rTitle.Parent = rHeader

local rMinBtn = Instance.new("TextButton")
rMinBtn.Size = UDim2.new(0,24,0,18); rMinBtn.Position = UDim2.new(1,-28,0.5,-9)
rMinBtn.BackgroundColor3 = Color3.fromRGB(20,20,30); rMinBtn.BackgroundTransparency = 0.2
rMinBtn.BorderSizePixel = 0; rMinBtn.Text = "–"; rMinBtn.TextColor3 = Color3.fromRGB(255,255,255)
rMinBtn.Font = Enum.Font.GothamBold; rMinBtn.TextSize = 14; rMinBtn.Parent = rHeader
makeCorner(rMinBtn, 5)

-- Ícono flotante riddle
local riddleIcon = makeFloatIcon(UDim2.new(0.5,-22,0,250), ICON_ID, Color3.fromRGB(255,190,90))
connectFloatIcon(riddleIcon, function()
    riddleIcon.Visible = false
    riddleWin.Visible = true
end)

rMinBtn.MouseButton1Click:Connect(function()
    riddleIcon.Position = UDim2.new(
        riddleWin.Position.X.Scale, riddleWin.Position.X.Offset,
        riddleWin.Position.Y.Scale, riddleWin.Position.Y.Offset)
    riddleWin.Visible = false
    riddleIcon.Visible = true
end)

-- Drag riddle header
local rDrag, rDStart, rDPos
rHeader.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        rDrag=true; rDStart=i.Position; rDPos=riddleWin.Position end
end)
rHeader.InputChanged:Connect(function(i)
    if rDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d=i.Position-rDStart
        riddleWin.Position=UDim2.new(rDPos.X.Scale,rDPos.X.Offset+d.X,rDPos.Y.Scale,rDPos.Y.Offset+d.Y) end
end)
rHeader.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then rDrag=false end
end)

-- Rainbow riddle
table.insert(rainbowB, function(rgb)
    riddleStroke.Color=rgb; rHeader.BackgroundColor3=rgb; rTitle.TextColor3=rgb; rIcon.ImageColor3=rgb
    riddleWin.BackgroundColor3=rgb:Lerp(Color3.fromRGB(10,10,14),0.65)
    riddleIcon.ImageColor3=rgb
    local s=riddleIcon:FindFirstChildOfClass("UIStroke"); if s then s.Color=rgb end
end)

-- Riddle input
local rInputFrame = Instance.new("Frame")
rInputFrame.Size=UDim2.new(1,-20,0,56); rInputFrame.Position=UDim2.new(0,10,0,38)
rInputFrame.BackgroundColor3=Color3.fromRGB(255,255,255)
rInputFrame.BackgroundTransparency=0.95; rInputFrame.BorderSizePixel=0
rInputFrame.Parent=riddleWin; makeCorner(rInputFrame, 8)

local rInputBox = Instance.new("TextBox")
rInputBox.Size=UDim2.new(1,-12,1,-8); rInputBox.Position=UDim2.new(0,6,0,4)
rInputBox.BackgroundTransparency=1
rInputBox.PlaceholderText="Pega el texto del riddle aquí..."
rInputBox.PlaceholderColor3=Color3.fromRGB(120,120,130); rInputBox.Text=""
rInputBox.TextColor3=Color3.fromRGB(230,230,235); rInputBox.Font=Enum.Font.Gotham; rInputBox.TextSize=12
rInputBox.TextWrapped=true; rInputBox.MultiLine=true; rInputBox.ClearTextOnFocus=false
rInputBox.TextXAlignment=Enum.TextXAlignment.Left; rInputBox.TextYAlignment=Enum.TextYAlignment.Top
rInputBox.Parent=rInputFrame

local rResult = Instance.new("TextLabel")
rResult.Size=UDim2.new(1,-20,0,16); rResult.Position=UDim2.new(0,10,0,98)
rResult.BackgroundTransparency=1; rResult.Text="La respuesta aparecerá aquí"
rResult.TextColor3=Color3.fromRGB(150,150,170); rResult.Font=Enum.Font.GothamBold; rResult.TextSize=11
rResult.TextWrapped=true; rResult.TextXAlignment=Enum.TextXAlignment.Left; rResult.Parent=riddleWin

local solveBtn = Instance.new("TextButton")
solveBtn.Size=UDim2.new(0.6,-13,0,26); solveBtn.Position=UDim2.new(0,10,0,130)
solveBtn.BackgroundColor3=Color3.fromRGB(255,170,60); solveBtn.BackgroundTransparency=0.75; solveBtn.BorderSizePixel=0
solveBtn.Text="RESOLVER Y PEGAR"; solveBtn.TextColor3=Color3.fromRGB(255,200,110)
solveBtn.Font=Enum.Font.GothamBold; solveBtn.TextSize=10; solveBtn.Parent=riddleWin
makeCorner(solveBtn, 6)

local clearBtn = Instance.new("TextButton")
clearBtn.Size=UDim2.new(0.4,-7,0,26); clearBtn.Position=UDim2.new(0.6,10,0,130)
clearBtn.BackgroundColor3=Color3.fromRGB(255,255,255); clearBtn.BackgroundTransparency=0.93; clearBtn.BorderSizePixel=0
clearBtn.Text="LIMPIAR"; clearBtn.TextColor3=Color3.fromRGB(150,150,170)
clearBtn.Font=Enum.Font.Gotham; clearBtn.TextSize=11; clearBtn.Parent=riddleWin
makeCorner(clearBtn, 6)

solveBtn.MouseButton1Click:Connect(function()
    local txt=rInputBox.Text
    if not txt or txt:gsub("%s","")=="" then
        rResult.Text="Escribe o pega un riddle primero"; rResult.TextColor3=Color3.fromRGB(255,170,60); return
    end
    local ans=findRiddleAnswer(txt)
    if ans then
        typeIntoCodeBox(ans)
        rResult.Text="Respuesta: "..ans.." (pegado)"; rResult.TextColor3=Color3.fromRGB(80,255,160)
        addLogEntry("✓ RESUELTO → "..ans, "riddle_solved")
    else
        rResult.Text="Sin coincidencia en la tabla"; rResult.TextColor3=Color3.fromRGB(255,100,100)
        addLogEntry("✕ DESCONOCIDO: "..translate(txt), "riddle_unknown")
    end
end)
clearBtn.MouseButton1Click:Connect(function()
    rInputBox.Text=""; rResult.Text="La respuesta aparecerá aquí"; rResult.TextColor3=Color3.fromRGB(150,150,170)
end)

-- Hint logger
local hintToggle = Instance.new("TextButton")
hintToggle.Size=UDim2.new(1,-20,0,24); hintToggle.Position=UDim2.new(0,10,0,164)
hintToggle.BackgroundColor3=Color3.fromRGB(255,170,60); hintToggle.BackgroundTransparency=0.85; hintToggle.BorderSizePixel=0
hintToggle.Text="LOGGER DE PISTAS: OFF"; hintToggle.TextColor3=Color3.fromRGB(255,190,90)
hintToggle.Font=Enum.Font.GothamBold; hintToggle.TextSize=11; hintToggle.Parent=riddleWin
makeCorner(hintToggle, 6)
local hintStroke = makeStroke(hintToggle, Color3.fromRGB(255,170,60), 0.5, 1)

local hintListLbl = Instance.new("TextLabel")
hintListLbl.Size=UDim2.new(1,-20,0,14); hintListLbl.Position=UDim2.new(0,10,0,194)
hintListLbl.BackgroundTransparency=1; hintListLbl.Text="HISTORIAL DE MENSAJES"
hintListLbl.TextColor3=Color3.fromRGB(255,190,90); hintListLbl.Font=Enum.Font.GothamBold
hintListLbl.TextSize=10; hintListLbl.TextXAlignment=Enum.TextXAlignment.Left; hintListLbl.Parent=riddleWin

local hintFrame = Instance.new("Frame")
hintFrame.Size=UDim2.new(1,-20,0,82); hintFrame.Position=UDim2.new(0,10,0,210)
hintFrame.BackgroundColor3=Color3.fromRGB(255,255,255)
hintFrame.BackgroundTransparency=0.95; hintFrame.BorderSizePixel=0
hintFrame.Parent=riddleWin; makeCorner(hintFrame, 8)

local hintScroll = Instance.new("ScrollingFrame")
hintScroll.Size=UDim2.new(1,-8,1,-8); hintScroll.Position=UDim2.new(0,4,0,4)
hintScroll.BackgroundTransparency=1; hintScroll.BorderSizePixel=0
hintScroll.ScrollBarThickness=3; hintScroll.CanvasSize=UDim2.new(0,0,0,0)
hintScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; hintScroll.Parent=hintFrame
local hintList = Instance.new("UIListLayout")
hintList.SortOrder=Enum.SortOrder.LayoutOrder; hintList.Padding=UDim.new(0,2); hintList.Parent=hintScroll

local hintLoggerEnabled = false
local function addHintEntry(text)
    local ts=os.date("%H:%M:%S")
    local translated = translate(text)
    local e=Instance.new("TextLabel")
    e.Size=UDim2.new(1,0,0,0); e.AutomaticSize=Enum.AutomaticSize.Y
    e.BackgroundTransparency=1; e.Text="["..ts.."] "..translated
    e.TextColor3=Color3.fromRGB(220,220,230); e.Font=Enum.Font.Gotham; e.TextSize=10
    e.TextWrapped=true; e.TextXAlignment=Enum.TextXAlignment.Left; e.Parent=hintScroll
    local cnt=0
    for _,c in ipairs(hintScroll:GetChildren()) do if c:IsA("TextLabel") then cnt+=1 end end
    if cnt>100 then for _,c in ipairs(hintScroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy(); break end end end
    task.defer(function() hintScroll.CanvasPosition=Vector2.new(0,hintScroll.AbsoluteCanvasSize.Y) end)
end

hintToggle.MouseButton1Click:Connect(function()
    hintLoggerEnabled = not hintLoggerEnabled
    if hintLoggerEnabled then
        hintToggle.Text="LOGGER DE PISTAS: ON"; hintToggle.TextColor3=Color3.fromRGB(80,255,160); hintStroke.Color=Color3.fromRGB(80,255,160)
    else
        hintToggle.Text="LOGGER DE PISTAS: OFF"; hintToggle.TextColor3=Color3.fromRGB(255,190,90); hintStroke.Color=Color3.fromRGB(255,170,60)
    end
end)

local function handleNotif(text)
    if text=="" then return end
    if hintLoggerEnabled then addHintEntry(text) end
    if not autoCodeEnabled then return end
    local ans=findRiddleAnswer(text)
    if ans then
        typeIntoCodeBox(ans)
        addLogEntry("✓ ADIVINANZA → "..ans, "riddle_solved")
    else
        local looksRiddle=text:lower():find("who") or text:lower():find("what")
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
