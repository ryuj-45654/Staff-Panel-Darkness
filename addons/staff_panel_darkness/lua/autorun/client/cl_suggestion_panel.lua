-- cl_suggestion_panel.lua

-- Añadimos la red para recibir notificaciones
net.Receive("SendNotification", function()
    local message = net.ReadString()
    local notificationType = net.ReadUInt(3)
    local duration = net.ReadUInt(8)

    -- Crear la notificación
    if notificationType == 1 then
        -- Notificación genérica
        notification.AddLegacy(message, NOTIFY_GENERIC, duration)
    elseif notificationType == 2 then
        -- Notificación de advertencia
        notification.AddLegacy(message, NOTIFY_ERROR, duration)
    else
        -- Notificación predeterminada
        notification.AddLegacy(message, NOTIFY_HINT, duration)
    end
    surface.PlaySound("ambient/levels/labs/electric_explosion1.wav") -- Sonido de notificación
end)

-- Crear el panel de sugerencias
local function OpenSuggestionPanel()
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:SetTitle("Panel de Sugerencias")
    frame:Center()
    frame:MakePopup()

    -- Área de texto para la sugerencia
    local suggestionText = vgui.Create("DTextEntry", frame)
    suggestionText:SetPos(10, 30)
    suggestionText:SetSize(380, 200)
    suggestionText:SetMultiline(true)
    suggestionText:SetPlaceholderText("Escribe tu sugerencia aquí...")

    -- Botón para enviar la sugerencia
    local submitButton = vgui.Create("DButton", frame)
    submitButton:SetPos(150, 240)
    submitButton:SetSize(100, 30)
    submitButton:SetText("Enviar Sugerencia")

    -- Acción al presionar el botón
    submitButton.DoClick = function()
        local suggestion = suggestionText:GetValue()
        
        if suggestion == "" then
            notification.AddLegacy("¡Por favor, escribe una sugerencia!", NOTIFY_ERROR, 5)
            return
        end

        -- Enviar la sugerencia al servidor
        net.Start("SubmitSuggestion")
        net.WriteString(suggestion)
        net.SendToServer()

        -- Notificación de envío
        notification.AddLegacy("Sugerencia enviada, gracias por tu aporte!", NOTIFY_HINT, 5)
        frame:Close()
    end
end

-- Comando para abrir el panel
concommand.Add("open_suggestion_panel", OpenSuggestionPanel)

-- Añadir un enlace al panel en el menú del jugador
hook.Add("OnContextMenuOpen", "AddSuggestionPanelToMenu", function()
    local menu = DermaMenu()

    menu:AddOption("Enviar Sugerencia", function()
        OpenSuggestionPanel()
    end)

    menu:Open()
end)