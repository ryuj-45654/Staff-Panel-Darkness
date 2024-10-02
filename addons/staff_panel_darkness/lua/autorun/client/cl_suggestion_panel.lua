-- cl_suggestion_panel.lua

-- A�adimos la red para recibir notificaciones
net.Receive("SendNotification", function()
    local message = net.ReadString()
    local notificationType = net.ReadUInt(3)
    local duration = net.ReadUInt(8)

    -- Crear la notificaci�n
    if notificationType == 1 then
        -- Notificaci�n gen�rica
        notification.AddLegacy(message, NOTIFY_GENERIC, duration)
    elseif notificationType == 2 then
        -- Notificaci�n de advertencia
        notification.AddLegacy(message, NOTIFY_ERROR, duration)
    else
        -- Notificaci�n predeterminada
        notification.AddLegacy(message, NOTIFY_HINT, duration)
    end
    surface.PlaySound("ambient/levels/labs/electric_explosion1.wav") -- Sonido de notificaci�n
end)

-- Crear el panel de sugerencias
local function OpenSuggestionPanel()
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:SetTitle("Panel de Sugerencias")
    frame:Center()
    frame:MakePopup()

    -- �rea de texto para la sugerencia
    local suggestionText = vgui.Create("DTextEntry", frame)
    suggestionText:SetPos(10, 30)
    suggestionText:SetSize(380, 200)
    suggestionText:SetMultiline(true)
    suggestionText:SetPlaceholderText("Escribe tu sugerencia aqu�...")

    -- Bot�n para enviar la sugerencia
    local submitButton = vgui.Create("DButton", frame)
    submitButton:SetPos(150, 240)
    submitButton:SetSize(100, 30)
    submitButton:SetText("Enviar Sugerencia")

    -- Acci�n al presionar el bot�n
    submitButton.DoClick = function()
        local suggestion = suggestionText:GetValue()
        
        if suggestion == "" then
            notification.AddLegacy("�Por favor, escribe una sugerencia!", NOTIFY_ERROR, 5)
            return
        end

        -- Enviar la sugerencia al servidor
        net.Start("SubmitSuggestion")
        net.WriteString(suggestion)
        net.SendToServer()

        -- Notificaci�n de env�o
        notification.AddLegacy("Sugerencia enviada, gracias por tu aporte!", NOTIFY_HINT, 5)
        frame:Close()
    end
end

-- Comando para abrir el panel
concommand.Add("open_suggestion_panel", OpenSuggestionPanel)

-- A�adir un enlace al panel en el men� del jugador
hook.Add("OnContextMenuOpen", "AddSuggestionPanelToMenu", function()
    local menu = DermaMenu()

    menu:AddOption("Enviar Sugerencia", function()
        OpenSuggestionPanel()
    end)

    menu:Open()
end)