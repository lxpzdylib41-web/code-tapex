local API_URL = "https://0df0d4ce-f84e-423b-971d-a243eea7e01f-00-1pzapgoozo9mk.picard.replit.dev/api/keys/validate"
local HUB_URL = "https://raw.githubusercontent.com/lxpzdylib41-web/code-tapex/main/hubcodesmv.lua"

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui

-- ── Función HTTP compatible con todos los executors ──────────
local function httpPost(url, body)
    local encoded = HttpService:JSONEncode(body)
    local headers = { ["Content-Type"] = "application/json" }

    -- Synapse X / Script-Ware
    if syn and syn.request then
        return syn.request({ Url = url, Method = "POST", Headers = headers, Body = encoded })
    end
    -- KRNL / Fluxus / Solara / Delta / ejecutores modernos
    if request then
        return request({ Url = url, Method = "POST", Headers = headers, Body = encoded })
    end
    -- http.request (algunos ejecutores)
    if http and http.request then
        return http.request({ Url = url, Method = "POST", Headers = headers, Body = encoded })
    end
    -- HttpService nativo (fallback)
    return HttpService:RequestAsync({ Url = url, Method = "POST", Headers = headers, Body = encoded })
end

-- ── Limpiar instancia anterior ───────────────────────────────
if playerGui:FindFirstChild("X23Loader") then
    playerGui.X23Loader:Destroy()
end

-- ── ScreenGui principal ──────────────────────────────────────
local gui = Instance.new("ScreenGui")
gui.Name = "X23Loader"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui
local hubIcon = Instance.new("ImageButton")
hubIcon.Name = "HubIcon"
hubIcon.Parent = gui
hubIcon.Size = UDim2.new(0,60,0,60)
hubIcon.Position = UDim2.new(0,20,0.5,-30)
hubIcon.BackgroundTransparency = 1
hubIcon.Image = "rbxassetid://124556602865900"
hubIcon.Visible = false
hubIcon.Active = true
hubIcon.ZIndex = 999
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.45
overlay.BorderSizePixel = 0
overlay.Parent = gui

local win = Instance.new("Frame")

local mobile = game:GetService("UserInputService").TouchEnabled

if mobile then
    win.Size = UDim2.new(0.9,0,0,220)
    win.Position = UDim2.new(0.05,0,0.5,-110)
else
    win.Size = UDim2.new(0,320,0,210)
    win.Position = UDim2.new(0.5,-160,0.5,-105)
end
win.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
win.BorderSizePixel = 0
win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 200, 255)
stroke.Thickness = 1.8
stroke.Parent = win

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 12)
title.BackgroundTransparency = 1
title.Text = "✦ X23 HUB"
title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = win
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-38,0,8)
minimize.BackgroundColor3 = Color3.fromRGB(30,30,40)
minimize.BorderSizePixel = 0
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.Parent = win

Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,6)
local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0, 48)
sub.BackgroundTransparency = 1
sub.Text = "Ingresa tu key para continuar"
sub.TextColor3 = Color3.fromRGB(100, 140, 160)
sub.Font = Enum.Font.Gotham
sub.TextSize = 12
sub.Parent = win

local inputBg = Instance.new("Frame")
inputBg.Size = UDim2.new(1, -40, 0, 38)
inputBg.Position = UDim2.new(0, 20, 0, 80)
inputBg.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
inputBg.BorderSizePixel = 0
inputBg.Parent = win
Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 8)

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(40, 60, 80)
inputStroke.Thickness = 1.2
inputStroke.Parent = inputBg

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -16, 1, 0)
input.Position = UDim2.new(0, 8, 0, 0)
input.BackgroundTransparency = 1
input.PlaceholderText = "X23-XXXX-XXXX-XXXX"
input.PlaceholderColor3 = Color3.fromRGB(60, 80, 100)
input.TextColor3 = Color3.fromRGB(220, 240, 255)
input.Font = Enum.Font.GothamBold
input.TextSize = 14
input.ClearTextOnFocus = false
input.Text = ""
input.Parent = inputBg

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -40, 0, 38)
btn.Position = UDim2.new(0, 20, 0, 132)
btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
btn.BorderSizePixel = 0
btn.Text = "Verificar Key"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Parent = win
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

local statusMsg = Instance.new("TextLabel")
statusMsg.Size = UDim2.new(1, -40, 0, 30)
statusMsg.Position = UDim2.new(0, 20, 0, 176)
statusMsg.BackgroundTransparency = 1
statusMsg.Text = ""
statusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
statusMsg.Font = Enum.Font.Gotham
statusMsg.TextSize = 11
statusMsg.TextWrapped = true
statusMsg.Parent = win

-- ── Animación de borde ───────────────────────────────────────
local animating = true
task.spawn(function()
    while animating do
        for hue = 0, 1, 0.015 do
            if not animating then break end
            stroke.Color = Color3.fromHSV(hue, 0.75, 1)
            task.wait(0.04)
        end
    end
end)

-- ── Verificación ─────────────────────────────────────────────
local function verify()
    local key = input.Text:match("^%s*(.-)%s*$")
    if key == "" then
        statusMsg.TextColor3 = Color3.fromRGB(255, 200, 0)
        statusMsg.Text = "⚠ Escribe tu key primero"
        return
    end

    btn.Active = false
    btn.Text = "Verificando..."
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    statusMsg.Text = ""

    local ok, response = pcall(httpPost, API_URL, { key = key })

    if not ok or not response then
        btn.Active = true
        btn.Text = "Verificar Key"
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
        statusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusMsg.Text = "❌ Sin conexión con el servidor. Intenta de nuevo."
        return
    end

    -- Algunos executors usan StatusCode, otros Success
    local isOk = response.Success or (response.StatusCode and response.StatusCode >= 200 and response.StatusCode < 300)
    if not isOk then
        btn.Active = true
        btn.Text = "Verificar Key"
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
        statusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusMsg.Text = "❌ Error del servidor (" .. tostring(response.StatusCode or "?") .. ")"
        return
    end

    local parseOk, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not parseOk or type(data) ~= "table" then
        btn.Active = true
        btn.Text = "Verificar Key"
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
        statusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusMsg.Text = "❌ Respuesta inválida del servidor."
        return
    end

    if not data.valid then
        btn.Active = true
        btn.Text = "Verificar Key"
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
        statusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusMsg.Text = "❌ " .. (data.message or "Key inválida o expirada")
        return
    end

    -- ✅ Key válida
    animating = false
    task.wait(0.05)
    stroke.Color = Color3.fromRGB(80, 255, 160)
    btn.BackgroundColor3 = Color3.fromRGB(30, 200, 100)
    btn.Text = "✅ Acceso concedido"
    statusMsg.TextColor3 = Color3.fromRGB(80, 255, 160)
    statusMsg.Text = data.type == "timed"
        and ("Expira: " .. tostring(data.expiresAt or ""):sub(1, 10))
        or "Key permanente ✨"

    task.wait(1)
    gui:Destroy()

    loadstring(game:HttpGet(HUB_URL))()
end

btn.MouseButton1Click:Connect(verify)
input.FocusLost:Connect(function(enter)
    if enter then verify() end
end)
minimize.MouseButton1Click:Connect(function()
    win.Visible = false
    hubIcon.Visible = true
end)

hubIcon.MouseButton1Click:Connect(function()
    hubIcon.Visible = false
    win.Visible = true
end)