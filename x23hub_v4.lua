local player   = game.Players.LocalPlayer
local playerGui = player.PlayerGui
local UIS      = game:GetService("UserInputService")

if playerGui:FindFirstChild("X23HUB_M") then playerGui.X23HUB_M:Destroy() end

local screenGui        = Instance.new("ScreenGui")
screenGui.Name         = "X23HUB_M"
screenGui.ResetOnSpawn = false
screenGui.Parent       = playerGui

local ICON_ID = "rbxassetid://105853546905051"

-- ============================================================
-- TRADUCTOR EN → ES
-- ============================================================
local dict = {
    ["mutation"]="mutación",["mutations"]="mutaciones",["favourite"]="favorito",
    ["favorite"]="favorito",["admin"]="admin",["wars"]="guerras",
    ["brainrot"]="brainrot",["code"]="código",["codes"]="códigos",
    ["redeem"]="canjear",["reward"]="recompensa",["rewards"]="recompensas",
    ["earned"]="ganaste",["joined"]="entró",["left"]="salió",
    ["riddle"]="adivinanza",["answer"]="respuesta",["hint"]="pista",
    ["winner"]="ganador",["winners"]="ganadores",["event"]="evento",
    ["update"]="actualización",["new"]="nuevo",["secret"]="secreto",
    ["owner"]="dueño",["facts"]="datos",["question"]="pregunta",
    ["what"]="qué",["who"]="quién",["is"]="es",["the"]="el",
    ["and"]="y",["or"]="o",["your"]="tu",["you"]="tú",
    ["has"]="tiene",["have"]="tienen",["get"]="obtén",["free"]="gratis",
    ["limited"]="limitado",["time"]="tiempo",["now"]="ahora",
    ["players"]="jugadores",["player"]="jugador",["server"]="servidor",
    ["game"]="juego",["win"]="ganar",["lost"]="perdiste",
    ["congrats"]="felicidades",["congratulations"]="felicitaciones",
    ["correct"]="correcto",["wrong"]="incorrecto",["first"]="primero",
    ["second"]="segundo",["third"]="tercero",["type"]="escribe",
    ["enter"]="ingresa",["box"]="caja",["number"]="número",
    ["next"]="siguiente",["round"]="ronda",["announced"]="anunciado",
    ["welcome"]="bienvenido",["spawn"]="aparición",["spawns"]="apariciones",
    ["chance"]="probabilidad",["rate"]="tasa",["rarity"]="rareza",
    ["rare"]="raro",["common"]="común",["uncommon"]="poco común",
    ["legendary"]="legendario",["mythic"]="mítico",["divine"]="divino",
    ["secret"]="secreto",["how"]="cómo",["many"]="cuántos",
    ["name"]="nombre",["color"]="color",["colour"]="color",
}
local function translate(text)
    if not text or text=="" then return text end
    return text:gsub("(%a+)", function(w)
        local t=dict[w:lower()]
        if t then return w:sub(1,1):match("%u") and (t:sub(1,1):upper()..t:sub(2)) or t end
        return w
    end)
end

-- ============================================================
-- UTILIDADES UI
-- ============================================================
local function makeCorner(p,r)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 12); c.Parent=p; return c
end
local function makeStroke(p,col,tr,th)
    local s=Instance.new("UIStroke"); s.Color=col; s.Transparency=tr or 0.5
    s.Thickness=th or 1; s.Parent=p; return s
end

-- ============================================================
-- DRAG HELPER — UIS global (no pierde el touch fuera del frame)
-- excludeList: tabla de GuiObjects que NO deben iniciar el drag
-- ============================================================
local function attachDrag(handle, target, excludeList)
    local dragging,dragStart,startPos=false,nil,nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            -- Si el toque está sobre un botón excluido (ej: minimizar), ignorar
            if excludeList then
                local hits = playerGui:GetGuiObjectsAtPosition(i.Position.X, i.Position.Y)
                for _,hit in ipairs(hits) do
                    for _,ex in ipairs(excludeList) do
                        if hit == ex then return end
                    end
                end
            end
            dragging=true; dragStart=i.Position; startPos=target.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement
        or i.UserInputType==Enum.UserInputType.Touch then
            local d=i.Position-dragStart
            target.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,
                                      startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
end

-- ============================================================
-- ÍCONO FLOTANTE
-- ============================================================
local function makeFloatIcon(pos,tint)
    local btn=Instance.new("ImageButton")
    btn.Size=UDim2.new(0,50,0,50); btn.Position=pos
    btn.BackgroundColor3=Color3.fromRGB(10,10,14); btn.BackgroundTransparency=0.05
    btn.BorderSizePixel=0; btn.Image=ICON_ID; btn.ImageColor3=tint
    btn.ScaleType=Enum.ScaleType.Fit; btn.Visible=false; btn.Parent=screenGui
    makeCorner(btn,14); makeStroke(btn,tint,0.3,2)
    return btn
end
local function connectFloatIcon(btn,onRestore)
    local dragging,dragStart,startPos,didDrag=false,nil,nil,false
    btn.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=i.Position; startPos=btn.Position; didDrag=false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement
        or i.UserInputType==Enum.UserInputType.Touch then
            local d=i.Position-dragStart
            if d.Magnitude>8 then didDrag=true end
            btn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,
                                   startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if not dragging then return end  -- solo actuar si el toque empezó en el ícono
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            local was=didDrag; dragging=false; didDrag=false
            if not was then onRestore() end
        end
    end)
end

-- ============================================================
-- RAINBOW
-- ============================================================
local rainbowCbs={}
task.spawn(function()
    while true do
        for h=0,1,0.01 do
            local rgb=Color3.fromHSV(h,0.4,0.4)
            for _,cb in ipairs(rainbowCbs) do pcall(cb,rgb) end
            task.wait(0.03)
        end
    end
end)

-- ============================================================
-- VENTANA PRINCIPAL (260 × 330)
-- ============================================================
local WIN_W,WIN_H,HDR_H=260,330,40

local win=Instance.new("Frame")
win.Size=UDim2.new(0,WIN_W,0,WIN_H)
win.Position=UDim2.new(0.5,-WIN_W/2,1,-(WIN_H+20))
win.BackgroundColor3=Color3.fromRGB(10,10,14)
win.BackgroundTransparency=0.05; win.BorderSizePixel=0
win.ClipsDescendants=true; win.Parent=screenGui
makeCorner(win,16)
local winStroke=makeStroke(win,Color3.fromRGB(0,200,255),0.4,1.5)

local header=Instance.new("Frame")
header.Size=UDim2.new(1,0,0,HDR_H)
header.BackgroundColor3=Color3.fromRGB(0,180,255)
header.BackgroundTransparency=0.82; header.BorderSizePixel=0; header.Parent=win
makeCorner(header,16)

local hIcon=Instance.new("ImageLabel")
hIcon.Size=UDim2.new(0,24,0,24); hIcon.Position=UDim2.new(0,8,0.5,-12)
hIcon.BackgroundTransparency=1; hIcon.Image=ICON_ID
hIcon.ImageColor3=Color3.fromRGB(0,220,255); hIcon.ScaleType=Enum.ScaleType.Fit
hIcon.Parent=header

local hTitle=Instance.new("TextLabel")
hTitle.Size=UDim2.new(1,-90,1,0); hTitle.Position=UDim2.new(0,38,0,0)
hTitle.BackgroundTransparency=1; hTitle.Text="X23 HUB"
hTitle.TextColor3=Color3.fromRGB(0,220,255); hTitle.Font=Enum.Font.GothamBold
hTitle.TextSize=13; hTitle.TextXAlignment=Enum.TextXAlignment.Left; hTitle.Parent=header

local minBtn=Instance.new("TextButton")
minBtn.Size=UDim2.new(0,36,0,28); minBtn.Position=UDim2.new(1,-42,0.5,-14)
minBtn.BackgroundColor3=Color3.fromRGB(20,20,30); minBtn.BackgroundTransparency=0.2
minBtn.BorderSizePixel=0; minBtn.Text="–"; minBtn.TextColor3=Color3.fromRGB(255,255,255)
minBtn.Font=Enum.Font.GothamBold; minBtn.TextSize=18; minBtn.Parent=header
makeCorner(minBtn,8)

local floatIcon=makeFloatIcon(UDim2.new(0.5,-25,1,-70),Color3.fromRGB(0,220,255))
connectFloatIcon(floatIcon,function() floatIcon.Visible=false; win.Visible=true end)
-- InputEnded directo en el botón: más fiable en móvil que Activated
do
    local pressing = false
    minBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            pressing = true
        end
    end)
    minBtn.InputEnded:Connect(function(i)
        if pressing and (i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch) then
            pressing = false
            floatIcon.Position = UDim2.new(win.Position.X.Scale, win.Position.X.Offset,
                                           win.Position.Y.Scale, win.Position.Y.Offset)
            win.Visible = false
            floatIcon.Visible = true
        end
    end)
end

table.insert(rainbowCbs,function(rgb)
    winStroke.Color=rgb; header.BackgroundColor3=rgb
    hTitle.TextColor3=rgb; hIcon.ImageColor3=rgb
    win.BackgroundColor3=rgb:Lerp(Color3.fromRGB(10,10,14),0.7)
    floatIcon.ImageColor3=rgb
    local s=floatIcon:FindFirstChildOfClass("UIStroke"); if s then s.Color=rgb end
end)

attachDrag(header, win, {minBtn})

-- ============================================================
-- TAB BAR
-- ============================================================
local TAB_H=34
local tabBar=Instance.new("Frame")
tabBar.Size=UDim2.new(1,0,0,TAB_H); tabBar.Position=UDim2.new(0,0,0,HDR_H)
tabBar.BackgroundColor3=Color3.fromRGB(15,15,20); tabBar.BackgroundTransparency=0.3
tabBar.BorderSizePixel=0; tabBar.Parent=win

local CONTENT_Y=HDR_H+TAB_H
local CONTENT_H=WIN_H-CONTENT_Y
local tabBtns,tabPages={},{}
local activeTab=1

for i=1,3 do
    local page=Instance.new("Frame")
    page.Size=UDim2.new(1,0,0,CONTENT_H); page.Position=UDim2.new(0,0,0,CONTENT_Y)
    page.BackgroundTransparency=1; page.BorderSizePixel=0
    page.Visible=(i==1); page.Parent=win
    tabPages[i]=page
end

local function setActiveTab(idx)
    for j,b in ipairs(tabBtns) do
        b.BackgroundTransparency=0.7; b.TextColor3=Color3.fromRGB(100,100,120)
        b.BackgroundColor3=Color3.fromRGB(20,20,28); tabPages[j].Visible=false
    end
    tabBtns[idx].BackgroundTransparency=0.5; tabBtns[idx].TextColor3=Color3.fromRGB(0,220,255)
    tabBtns[idx].BackgroundColor3=Color3.fromRGB(0,160,220); tabPages[idx].Visible=true
    activeTab=idx
end

for i,name in ipairs({"CODE","RIDDLE","LOG"}) do
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(1/3,-2,1,-6); btn.Position=UDim2.new((i-1)/3,1,0,3)
    btn.BackgroundColor3=i==1 and Color3.fromRGB(0,160,220) or Color3.fromRGB(20,20,28)
    btn.BackgroundTransparency=i==1 and 0.5 or 0.7; btn.BorderSizePixel=0; btn.Text=name
    btn.TextColor3=i==1 and Color3.fromRGB(0,220,255) or Color3.fromRGB(100,100,120)
    btn.Font=Enum.Font.GothamBold; btn.TextSize=11; btn.Parent=tabBar
    makeCorner(btn,7); tabBtns[i]=btn
    btn.MouseButton1Click:Connect(function() setActiveTab(i) end)
end
table.insert(rainbowCbs,function(rgb)
    tabBtns[activeTab].TextColor3=rgb
    tabBtns[activeTab].BackgroundColor3=rgb:Lerp(Color3.fromRGB(10,10,14),0.6)
end)

-- ============================================================
-- PÁGINA 1: CODE
-- ============================================================
local codePage=tabPages[1]

local autoBtn=Instance.new("TextButton")
autoBtn.Size=UDim2.new(1,-16,0,48); autoBtn.Position=UDim2.new(0,8,0,8)
autoBtn.BackgroundColor3=Color3.fromRGB(0,180,255); autoBtn.BackgroundTransparency=0.8
autoBtn.BorderSizePixel=0; autoBtn.Text="AUTO CODE: OFF"
autoBtn.TextColor3=Color3.fromRGB(0,220,255)
autoBtn.Font=Enum.Font.GothamBold; autoBtn.TextSize=14; autoBtn.Parent=codePage
makeCorner(autoBtn,12)
local autoBtnStroke=makeStroke(autoBtn,Color3.fromRGB(0,200,255),0.5,1)

local upperBtn=Instance.new("TextButton")
upperBtn.Size=UDim2.new(0.5,-12,0,40); upperBtn.Position=UDim2.new(0,8,0,64)
upperBtn.BackgroundColor3=Color3.fromRGB(0,180,255); upperBtn.BackgroundTransparency=0.7
upperBtn.BorderSizePixel=0; upperBtn.Text="UPPER"; upperBtn.TextColor3=Color3.fromRGB(0,220,255)
upperBtn.Font=Enum.Font.GothamBold; upperBtn.TextSize=12; upperBtn.Parent=codePage
makeCorner(upperBtn,10)
local upperStroke=makeStroke(upperBtn,Color3.fromRGB(0,200,255),0.4,1)

local lowerBtn=Instance.new("TextButton")
lowerBtn.Size=UDim2.new(0.5,-12,0,40); lowerBtn.Position=UDim2.new(0.5,4,0,64)
lowerBtn.BackgroundColor3=Color3.fromRGB(255,255,255); lowerBtn.BackgroundTransparency=0.93
lowerBtn.BorderSizePixel=0; lowerBtn.Text="lower"; lowerBtn.TextColor3=Color3.fromRGB(150,150,170)
lowerBtn.Font=Enum.Font.Gotham; lowerBtn.TextSize=12; lowerBtn.Parent=codePage
makeCorner(lowerBtn,10)
local lowerStroke=makeStroke(lowerBtn,Color3.fromRGB(100,100,120),0.7,1)

local statusLbl=Instance.new("TextLabel")
statusLbl.Size=UDim2.new(1,-16,0,26); statusLbl.Position=UDim2.new(0,8,0,112)
statusLbl.BackgroundTransparency=1; statusLbl.Text="Estado: INACTIVO"
statusLbl.TextColor3=Color3.fromRGB(100,100,120)
statusLbl.Font=Enum.Font.Gotham; statusLbl.TextSize=12
statusLbl.TextXAlignment=Enum.TextXAlignment.Center; statusLbl.Parent=codePage

-- ============================================================
-- PÁGINA 2: RIDDLE
-- ============================================================
local riddlePage=tabPages[2]

-- Etiqueta: riddle recibido
local rInputLbl=Instance.new("TextLabel")
rInputLbl.Size=UDim2.new(1,-16,0,14); rInputLbl.Position=UDim2.new(0,8,0,4)
rInputLbl.BackgroundTransparency=1; rInputLbl.Text="RIDDLE RECIBIDO:"
rInputLbl.TextColor3=Color3.fromRGB(200,150,60); rInputLbl.Font=Enum.Font.GothamBold
rInputLbl.TextSize=10; rInputLbl.TextXAlignment=Enum.TextXAlignment.Left
rInputLbl.Parent=riddlePage

-- Caja: riddle recibido (o pegar)
local rInputFrame=Instance.new("Frame")
rInputFrame.Size=UDim2.new(1,-16,0,58); rInputFrame.Position=UDim2.new(0,8,0,20)
rInputFrame.BackgroundColor3=Color3.fromRGB(255,255,255); rInputFrame.BackgroundTransparency=0.93
rInputFrame.BorderSizePixel=0; rInputFrame.Parent=riddlePage
makeCorner(rInputFrame,9)
makeStroke(rInputFrame,Color3.fromRGB(200,150,60),0.6,1)

local rInput=Instance.new("TextBox")
rInput.Size=UDim2.new(1,-14,1,-8); rInput.Position=UDim2.new(0,7,0,4)
rInput.BackgroundTransparency=1
rInput.PlaceholderText="El riddle aparece aquí automáticamente o pégalo..."
rInput.PlaceholderColor3=Color3.fromRGB(90,90,100); rInput.Text=""
rInput.TextColor3=Color3.fromRGB(230,230,235); rInput.Font=Enum.Font.Gotham; rInput.TextSize=11
rInput.TextWrapped=true; rInput.MultiLine=true; rInput.ClearTextOnFocus=false
rInput.TextXAlignment=Enum.TextXAlignment.Left; rInput.TextYAlignment=Enum.TextYAlignment.Top
rInput.Parent=rInputFrame

-- Etiqueta: tu respuesta
local rAnsLbl=Instance.new("TextLabel")
rAnsLbl.Size=UDim2.new(1,-16,0,14); rAnsLbl.Position=UDim2.new(0,8,0,82)
rAnsLbl.BackgroundTransparency=1; rAnsLbl.Text="TU RESPUESTA:"
rAnsLbl.TextColor3=Color3.fromRGB(80,200,120); rAnsLbl.Font=Enum.Font.GothamBold
rAnsLbl.TextSize=10; rAnsLbl.TextXAlignment=Enum.TextXAlignment.Left
rAnsLbl.Parent=riddlePage

-- Caja: escribe la respuesta manualmente
local rAnsFrame=Instance.new("Frame")
rAnsFrame.Size=UDim2.new(1,-16,0,36); rAnsFrame.Position=UDim2.new(0,8,0,98)
rAnsFrame.BackgroundColor3=Color3.fromRGB(255,255,255); rAnsFrame.BackgroundTransparency=0.92
rAnsFrame.BorderSizePixel=0; rAnsFrame.Parent=riddlePage
makeCorner(rAnsFrame,9)
makeStroke(rAnsFrame,Color3.fromRGB(80,200,120),0.6,1)

local rAnsInput=Instance.new("TextBox")
rAnsInput.Size=UDim2.new(1,-14,1,-8); rAnsInput.Position=UDim2.new(0,7,0,4)
rAnsInput.BackgroundTransparency=1
rAnsInput.PlaceholderText="Escribe la respuesta aquí..."
rAnsInput.PlaceholderColor3=Color3.fromRGB(80,80,90); rAnsInput.Text=""
rAnsInput.TextColor3=Color3.fromRGB(200,255,200); rAnsInput.Font=Enum.Font.GothamBold; rAnsInput.TextSize=13
rAnsInput.ClearTextOnFocus=false
rAnsInput.TextXAlignment=Enum.TextXAlignment.Left; rAnsInput.Parent=rAnsFrame

-- Botones: Enviar | Guardar | Copiar | Limpiar
local sendBtn=Instance.new("TextButton")
sendBtn.Size=UDim2.new(0.5,-10,0,36); sendBtn.Position=UDim2.new(0,8,0,140)
sendBtn.BackgroundColor3=Color3.fromRGB(80,200,120); sendBtn.BackgroundTransparency=0.7
sendBtn.BorderSizePixel=0; sendBtn.Text="▶ ENVIAR"; sendBtn.TextColor3=Color3.fromRGB(160,255,180)
sendBtn.Font=Enum.Font.GothamBold; sendBtn.TextSize=12; sendBtn.Parent=riddlePage
makeCorner(sendBtn,9)
makeStroke(sendBtn,Color3.fromRGB(80,200,120),0.5,1)

local saveBtn=Instance.new("TextButton")
saveBtn.Size=UDim2.new(0.5,-10,0,36); saveBtn.Position=UDim2.new(0.5,2,0,140)
saveBtn.BackgroundColor3=Color3.fromRGB(0,180,255); saveBtn.BackgroundTransparency=0.75
saveBtn.BorderSizePixel=0; saveBtn.Text="💾 GUARDAR"; saveBtn.TextColor3=Color3.fromRGB(120,220,255)
saveBtn.Font=Enum.Font.GothamBold; saveBtn.TextSize=12; saveBtn.Parent=riddlePage
makeCorner(saveBtn,9)
makeStroke(saveBtn,Color3.fromRGB(0,180,255),0.5,1)

local copyBtn=Instance.new("TextButton")
copyBtn.Size=UDim2.new(0.5,-10,0,32); copyBtn.Position=UDim2.new(0,8,0,182)
copyBtn.BackgroundColor3=Color3.fromRGB(255,150,40); copyBtn.BackgroundTransparency=0.8
copyBtn.BorderSizePixel=0; copyBtn.Text="📋 COPIAR RIDDLE"; copyBtn.TextColor3=Color3.fromRGB(255,200,100)
copyBtn.Font=Enum.Font.GothamBold; copyBtn.TextSize=11; copyBtn.Parent=riddlePage
makeCorner(copyBtn,8)

local clearRBtn=Instance.new("TextButton")
clearRBtn.Size=UDim2.new(0.5,-10,0,32); clearRBtn.Position=UDim2.new(0.5,2,0,182)
clearRBtn.BackgroundColor3=Color3.fromRGB(255,255,255); clearRBtn.BackgroundTransparency=0.93
clearRBtn.BorderSizePixel=0; clearRBtn.Text="✕ LIMPIAR"; clearRBtn.TextColor3=Color3.fromRGB(150,150,170)
clearRBtn.Font=Enum.Font.Gotham; clearRBtn.TextSize=11; clearRBtn.Parent=riddlePage
makeCorner(clearRBtn,8)

-- Feedback
local rFeedback=Instance.new("TextLabel")
rFeedback.Size=UDim2.new(1,-16,0,18); rFeedback.Position=UDim2.new(0,8,0,220)
rFeedback.BackgroundTransparency=1; rFeedback.Text=""
rFeedback.TextColor3=Color3.fromRGB(80,255,160); rFeedback.Font=Enum.Font.GothamBold; rFeedback.TextSize=11
rFeedback.TextWrapped=true; rFeedback.TextXAlignment=Enum.TextXAlignment.Center
rFeedback.Parent=riddlePage

-- ============================================================
-- PÁGINA 3: LOG
-- ============================================================
local logPage=tabPages[3]

local function makeLogSection(parent,labelText,labelColor,yPos,height)
    local lbl=Instance.new("TextLabel")
    lbl.Size=UDim2.new(1,-16,0,14); lbl.Position=UDim2.new(0,8,0,yPos)
    lbl.BackgroundTransparency=1; lbl.Text=labelText; lbl.TextColor3=labelColor
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=10
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=parent

    local frame=Instance.new("Frame")
    frame.Size=UDim2.new(1,-16,0,height); frame.Position=UDim2.new(0,8,0,yPos+16)
    frame.BackgroundColor3=Color3.fromRGB(255,255,255); frame.BackgroundTransparency=0.95
    frame.BorderSizePixel=0; frame.Parent=parent; makeCorner(frame,7)

    local scroll=Instance.new("ScrollingFrame")
    scroll.Size=UDim2.new(1,-8,1,-8); scroll.Position=UDim2.new(0,4,0,4)
    scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=3; scroll.CanvasSize=UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.Parent=frame

    local layout=Instance.new("UIListLayout")
    layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,2); layout.Parent=scroll
    return scroll
end

local logScroll  = makeLogSection(logPage,"HISTORIAL DE CÓDIGOS", Color3.fromRGB(120,200,230),4,102)
local hintScroll = makeLogSection(logPage,"HISTORIAL DE MENSAJES",Color3.fromRGB(255,190,90),132,102)

-- ============================================================
-- FUNCIONES DE LOG
-- ============================================================
local function addToScroll(scroll,text,color,maxEntries)
    local e=Instance.new("TextLabel")
    e.Size=UDim2.new(1,0,0,0); e.AutomaticSize=Enum.AutomaticSize.Y
    e.BackgroundTransparency=1; e.Text=text; e.TextColor3=color
    e.Font=Enum.Font.Gotham; e.TextSize=10
    e.TextWrapped=true; e.TextXAlignment=Enum.TextXAlignment.Left; e.Parent=scroll
    local cnt=0
    for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextLabel") then cnt+=1 end end
    if cnt>maxEntries then
        for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy(); break end end
    end
    task.defer(function() scroll.CanvasPosition=Vector2.new(0,scroll.AbsoluteCanvasSize.Y) end)
end
local function addLogEntry(text,kind)
    local color=Color3.fromRGB(0,220,255)
    if kind=="riddle_solved" then color=Color3.fromRGB(80,255,160)
    elseif kind=="riddle_unknown" then color=Color3.fromRGB(255,170,60)
    elseif kind=="saved" then color=Color3.fromRGB(120,200,255) end
    addToScroll(logScroll,text,color,30)
end
local function addHintEntry(text)
    local ts=os.date("%H:%M:%S")
    addToScroll(hintScroll,"["..ts.."] "..translate(text),Color3.fromRGB(220,220,230),100)
end

-- Feedback temporal
local feedTimer
local function showFeedback(msg,color)
    rFeedback.Text=msg; rFeedback.TextColor3=color
    if feedTimer then task.cancel(feedTimer) end
    feedTimer=task.delay(3,function() rFeedback.Text="" end)
end

-- ============================================================
-- TABLA DE RIDDLES (crece en tiempo real con GUARDAR)
-- ============================================================
local riddleTable={
    -- {keywords={"...","..."}, answer="..."},
    -- Agrega tus riddles conocidos aquí o usa el botón GUARDAR
    {keywords={"mutation","favourite"}, answer="Candy24Sammy"},
}

-- Tabla en memoria para las guardadas en runtime
local savedAnswers={}  -- {riddle=text, answer=text}

local function findRiddleAnswer(text)
    local low=text:lower()
    -- 1) Buscar en tabla estática
    for _,e in ipairs(riddleTable) do
        if e.answer~="" then
            local ok=true
            for _,kw in ipairs(e.keywords) do
                if not low:find(kw:lower(),1,true) then ok=false; break end
            end
            if ok then return e.answer end
        end
    end
    -- 2) Buscar en guardadas (coincidencia exacta o parcial del riddle)
    for _,s in ipairs(savedAnswers) do
        if low:find(s.riddle:lower(),1,true) then return s.answer end
    end
    return nil
end

-- ============================================================
-- LÓGICA: UPPER / LOWER
-- ============================================================
local caseMode="upper"
local function setCase(mode)
    caseMode=mode
    if mode=="upper" then
        upperBtn.BackgroundTransparency=0.7; upperBtn.TextColor3=Color3.fromRGB(0,220,255); upperStroke.Transparency=0.4
        lowerBtn.BackgroundTransparency=0.93; lowerBtn.TextColor3=Color3.fromRGB(150,150,170); lowerStroke.Transparency=0.7
    else
        lowerBtn.BackgroundTransparency=0.7; lowerBtn.TextColor3=Color3.fromRGB(0,220,255); lowerStroke.Transparency=0.4
        upperBtn.BackgroundTransparency=0.93; upperBtn.TextColor3=Color3.fromRGB(150,150,170); upperStroke.Transparency=0.7
    end
end
upperBtn.MouseButton1Click:Connect(function() setCase("upper") end)
lowerBtn.MouseButton1Click:Connect(function() setCase("lower") end)

-- ============================================================
-- LÓGICA: AUTO CODE
-- ============================================================
local autoCodeEnabled=false
local function openCodesMenu()
    local b=playerGui.LeftCenter.LeftCenter.Buttons.Codes
    if b then for _,c in ipairs(getconnections(b.Activated)) do c:Fire() end end
end
local function isCodesOpen()
    local cg=playerGui:FindFirstChild("Codes")
    if cg then local i=cg:FindFirstChild("Codes"); if i then return i.Visible end; return cg.Enabled end
    return false
end
local function typeIntoCodeBox(raw)
    local fmt=caseMode=="upper" and raw:upper() or raw:lower()
    local box=playerGui.Codes.Codes.CodeRedeem.TextBox
    if box then box:CaptureFocus(); box.Text=(box.Text or "")..fmt end
    return fmt
end

autoBtn.MouseButton1Click:Connect(function()
    autoCodeEnabled=not autoCodeEnabled
    if autoCodeEnabled then
        autoBtn.Text="AUTO CODE: ON ✓"; autoBtn.TextColor3=Color3.fromRGB(80,255,160); autoBtnStroke.Color=Color3.fromRGB(80,255,160)
        statusLbl.Text="Estado: ACTIVO 🟢"; statusLbl.TextColor3=Color3.fromRGB(80,255,160)
        task.spawn(function() while autoCodeEnabled do if not isCodesOpen() then openCodesMenu() end; task.wait(0.5) end end)
    else
        autoBtn.Text="AUTO CODE: OFF"; autoBtn.TextColor3=Color3.fromRGB(0,220,255); autoBtnStroke.Color=Color3.fromRGB(0,200,255)
        statusLbl.Text="Estado: INACTIVO"; statusLbl.TextColor3=Color3.fromRGB(100,100,120)
    end
end)

-- ============================================================
-- LÓGICA: RIDDLE — ENVIAR
-- ============================================================
sendBtn.MouseButton1Click:Connect(function()
    local ans=rAnsInput.Text
    if not ans or ans:gsub("%s","")=="" then
        showFeedback("Escribe una respuesta primero",Color3.fromRGB(255,170,60)); return
    end
    typeIntoCodeBox(ans)
    addLogEntry("▶ ENVIADO → "..ans,"riddle_solved")
    showFeedback("✓ Enviado: "..ans,Color3.fromRGB(80,255,160))
end)

-- GUARDAR: guarda riddle+respuesta para uso futuro automático
saveBtn.MouseButton1Click:Connect(function()
    local riddle=rInput.Text
    local ans=rAnsInput.Text
    if not riddle or riddle:gsub("%s","")=="" then
        showFeedback("No hay riddle que guardar",Color3.fromRGB(255,170,60)); return
    end
    if not ans or ans:gsub("%s","")=="" then
        showFeedback("Escribe la respuesta antes de guardar",Color3.fromRGB(255,170,60)); return
    end
    -- Evitar duplicados
    for _,s in ipairs(savedAnswers) do
        if s.riddle:lower()==riddle:lower() then
            s.answer=ans
            addLogEntry("💾 ACTUALIZADO → "..ans,"saved")
            showFeedback("✓ Respuesta actualizada",Color3.fromRGB(120,200,255)); return
        end
    end
    table.insert(savedAnswers,{riddle=riddle:lower():sub(1,60), answer=ans})
    addLogEntry("💾 GUARDADO → \""..riddle:sub(1,30).."...\" = "..ans,"saved")
    showFeedback("✓ Guardado para próximas veces",Color3.fromRGB(120,200,255))
end)

-- COPIAR RIDDLE al portapapeles
copyBtn.MouseButton1Click:Connect(function()
    local txt=rInput.Text
    if not txt or txt:gsub("%s","")=="" then
        showFeedback("No hay riddle para copiar",Color3.fromRGB(255,170,60)); return
    end
    pcall(function() setclipboard(txt) end)
    showFeedback("📋 Riddle copiado al portapapeles",Color3.fromRGB(255,200,100))
end)

-- LIMPIAR
clearRBtn.MouseButton1Click:Connect(function()
    rInput.Text=""; rAnsInput.Text=""; rFeedback.Text=""
end)

-- ============================================================
-- LÓGICA: NOTIFICACIONES AUTOMÁTICAS
-- ============================================================
local function handleNotif(text)
    if text=="" then return end
    addHintEntry(text)   -- siempre loguea mensajes

    -- Auto-rellenar el campo de riddle en la pestaña
    if rInput.Text=="" then
        rInput.Text=text
    end

    -- Intentar resolver automáticamente
    local ans=findRiddleAnswer(text)
    if ans then
        rAnsInput.Text=ans
        showFeedback("✓ Respuesta automática: "..ans,Color3.fromRGB(80,255,160))
        addLogEntry("✓ AUTO → "..ans,"riddle_solved")
        if autoCodeEnabled then typeIntoCodeBox(ans) end
    else
        -- Si no hay respuesta: copiar automáticamente al portapapeles
        pcall(function() setclipboard(text) end)
        addLogEntry("? SIN RESPUESTA (copiado): "..translate(text):sub(1,50),"riddle_unknown")
        -- Cambiar a pestaña RIDDLE para que el usuario vea el riddle
        setActiveTab(2)
        showFeedback("⚠ Riddle copiado — escribe la respuesta",Color3.fromRGB(255,190,60))
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
