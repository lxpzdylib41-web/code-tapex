-- ================================================================
-- X23 HUB LOADER — VERSIÓN MOBILE
-- Sube este archivo a GitHub y comparte su URL raw
-- Compatible con: Synapse X, KRNL, Fluxus, Solara, Delta
-- ================================================================

local API_URL = "https://0df0d4ce-f84e-423b-971d-a243eea7e01f-00-1pzapgoozo9mk.picard.replit.dev/api/keys/validate"
local HUB_URL = "https://raw.githubusercontent.com/lxpzdylib41-web/code-tapex/main/x23hub_mobile.lua"

local HttpService = game:GetService("HttpService")
local player      = game.Players.LocalPlayer
local playerGui   = player.PlayerGui

-- ── HTTP compatible con todos los executors ──────────────────
local function httpPost(url, body)
    local encoded = HttpService:JSONEncode(body)
    local headers = { ["Content-Type"] = "application/json" }
    if syn and syn.request then
        return syn.request({ Url=url, Method="POST", Headers=headers, Body=encoded })
    end
    if request then
        return request({ Url=url, Method="POST", Headers=headers, Body=encoded })
    end
    if http and http.request then
        return http.request({ Url=url, Method="POST", Headers=headers, Body=encoded })
    end
    return HttpService:RequestAsync({ Url=url, Method="POST", Headers=headers, Body=encoded })
end

-- ── Limpiar instancia anterior ────────────────────────────────
if playerGui:FindFirstChild("X23LoaderMobile") then
    playerGui.X23LoaderMobile:Destroy()
end

-- ── ScreenGui ────────────────────────────────────────────────
local gui = Instance.new("ScreenGui")
gui.Name            = "X23LoaderMobile"
gui.ResetOnSpawn    = false
gui.DisplayOrder    = 999
gui.Parent          = playerGui

-- Fondo semiopaco
local overlay = Instance.new("Frame")
overlay.Size                  = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3      = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.45
overlay.BorderSizePixel       = 0
overlay.Parent                = gui

-- Ventana centrada — ancha para móvil
local win = Instance.new("Frame")
win.Size             = UDim2.new(0, 310, 0, 260)
win.Position         = UDim2.new(0.5, -155, 0.5, -130)
win.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
win.BorderSizePixel  = 0
win.Parent           = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 18)

local stroke = Instance.new("UIStroke")
stroke.Color     = Color3.fromRGB(0, 200, 255)
stroke.Thickness = 2
stroke.Parent    = win

-- ── Ícono / logo ─────────────────────────────────────────────
-- 🔁 Cambia este ID por tu imagen
local logo = Instance.new("ImageLabel")
logo.Size                  = UDim2.new(0, 48, 0, 48)
logo.Position              = UDim2.new(0.5, -24, 0, 14)
logo.BackgroundTransparency = 1
logo.Image                 = "rbxassetid://101579838151121"
logo.ImageColor3           = Color3.fromRGB(0, 220, 255)
logo.ScaleType             = Enum.ScaleType.Fit
logo.Parent                = win

-- ── Título ───────────────────────────────────────────────────
local title = Instance.new("TextLabel")
title.Size                  = UDim2.new(1, 0, 0, 28)
title.Position              = UDim2.new(0, 0, 0, 66)
title.BackgroundTransparency = 1
title.Text                  = "✦ X23 HUB  MOBILE"
title.TextColor3            = Color3.fromRGB(0, 220, 255)
title.Font                  = Enum.Font.GothamBold
title.TextSize              = 17
title.Parent                = win

local sub = Instance.new("TextLabel")
sub.Size                  = UDim2.new(1, 0, 0, 18)
sub.Position              = UDim2.new(0, 0, 0, 95)
sub.BackgroundTransparency = 1
sub.Text                  = "Ingresa tu key para continuar"
sub.TextColor3            = Color3.fromRGB(100, 140, 160)
sub.Font                  = Enum.Font.Gotham
sub.TextSize              = 12
sub.Parent                = win

-- ── Input de key (grande para teclado táctil) ─────────────────
local inputBg = Instance.new("Frame")
inputBg.Size             = UDim2.new(1, -36, 0, 48)
inputBg.Position         = UDim2.new(0, 18, 0, 118)
inputBg.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
inputBg.BorderSizePixel  = 0
inputBg.Parent           = win
Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 10)

local inputStroke = Instance.new("UIStroke")
inputStroke.Color     = Color3.fromRGB(40, 60, 80)
inputStroke.Thickness = 1.4
inputStroke.Parent    = inputBg

local input = Instance.new("TextBox")
input.Size               = UDim2.new(1, -20, 1, 0)
input.Position           = UDim2.new(0, 10, 0, 0)
input.BackgroundTransparency = 1
input.PlaceholderText    = "X23-XXXX-XXXX-XXXX"
input.PlaceholderColor3  = Color3.fromRGB(60, 80, 100)
input.TextColor3         = Color3.fromRGB(220, 240, 255)
input.Font               = Enum.Font.GothamBold
input.TextSize           = 15
input.ClearTextOnFocus   = false
input.Text               = ""
input.Parent             = inputBg

-- ── Botón verificar (alto para que sea fácil de tocar) ────────
local btn = Instance.new("TextButton")
btn.Size             = UDim2.new(1, -36, 0, 52)
btn.Position         = UDim2.new(0, 18, 0, 176)
btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
btn.BorderSizePixel  = 0
btn.Text             = "Verificar Key"
btn.TextColor3       = Color3.fromRGB(255, 255, 255)
btn.Font             = Enum.Font.GothamBold
btn.TextSize         = 16
btn.Parent           = win
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

-- ── Mensaje de estado ─────────────────────────────────────────
local statusMsg = Instance.new("TextLabel")
statusMsg.Size                  = UDim2.new(1, -36, 0, 30)
statusMsg.Position              = UDim2.new(0, 18, 0, 232)
statusMsg.BackgroundTransparency = 1
statusMsg.Text                  = ""
statusMsg.TextColor3            = Color3.fromRGB(255, 80, 80)
statusMsg.Font                  = Enum.Font.Gotham
statusMsg.TextSize              = 12
statusMsg.TextWrapped           = true
statusMsg.TextXAlignment        = Enum.TextXAlignment.Center
statusMsg.Parent                = win

-- Ampliar la ventana para el mensaje de estado
win.Size = UDim2.new(0, 310, 0, 270)

-- ── Animación de borde arcoíris ───────────────────────────────
local animating = true
task.spawn(function()
    while animating do
        for hue = 0, 1, 0.015 do
            if not animating then break end
            local rgb = Color3.fromHSV(hue, 0.75, 1)
            stroke.Color   = rgb
            logo.ImageColor3 = rgb
            task.wait(0.04)
        end
    end
end)

-- ── Lógica de verificación ────────────────────────────────────
local function verify()
    local key = input.Text:match("^%s*(.-)%s*$")
    if key == "" then
        statusMsg.TextColor3 = Color3.fromRGB(255, 200, 0)
        statusMsg.Text       = "⚠ Escribe tu key primero"
        return
    end

    btn.Active           = false
    btn.Text             = "Verificando..."
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    statusMsg.Text       = ""

    local ok, response = pcall(httpPost, API_URL, { key = key })

    if not ok or not response then
        btn.Active           = true
        btn.Text             = "Verificar Key"
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
        statusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusMsg.Text       = "❌ Sin conexión con el servidor. Intenta de nuevo."
        return
    end

    local isOk = response.Success
        or (response.StatusCode and response.StatusCode >= 200 and response.StatusCode < 300)

    if not isOk then
        btn.Active           = true
        btn.Text             = "Verificar Key"
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
        statusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusMsg.Text       = "❌ Error del servidor (" .. tostring(response.StatusCode or "?") .. ")"
        return
    end

    local parseOk, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not parseOk or type(data) ~= "table" then
        btn.Active           = true
        btn.Text             = "Verificar Key"
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
        statusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusMsg.Text       = "❌ Respuesta inválida del servidor."
        return
    end

    if not data.valid then
        btn.Active           = true
        btn.Text             = "Verificar Key"
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
        statusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusMsg.Text       = "❌ " .. (data.message or "Key inválida o expirada")
        return
    end

    -- ✅ Key válida — animar y lanzar el hub
    animating = false
    task.wait(0.05)

    stroke.Color         = Color3.fromRGB(80, 255, 160)
    logo.ImageColor3     = Color3.fromRGB(80, 255, 160)
    btn.BackgroundColor3 = Color3.fromRGB(30, 200, 100)
    btn.Text             = "✅ Acceso concedido"
    statusMsg.TextColor3 = Color3.fromRGB(80, 255, 160)
    statusMsg.Text       = data.type == "timed"
        and ("Expira: " .. tostring(data.expiresAt or ""):sub(1, 10))
        or  "Key permanente ✨"

    task.wait(1)
    gui:Destroy()

    -- Carga el hub mobile
    loadstring(game:HttpGet(HUB_URL))()
end

btn.MouseButton1Click:Connect(verify)
input.FocusLost:Connect(function(enter)
    if enter then verify() end
end)
