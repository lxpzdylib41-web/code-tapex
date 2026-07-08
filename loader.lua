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
