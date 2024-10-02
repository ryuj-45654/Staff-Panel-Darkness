-- cl_player_tracking.lua

-- Crear un panel para el seguimiento de jugadores
local function OpenPlayerTrackingPanel()
    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 400)
    frame:SetTitle("Seguimiento de Jugadores")
    frame:Center()
    frame:MakePopup()

    -- Crear una lista para mostrar los jugadores
    local playerList = vgui.Create("DListView", frame)
    playerList:SetPos(10, 30)
    playerList:SetSize(580, 360)
    playerList:AddColumn("Nombre del Jugador")
    playerList:AddColumn("Ubicación")
    playerList:AddColumn("Acciones")

    -- Actualizar la lista de jugadores
    local function UpdatePlayerList()
        playerList:Clear()

        for _, ply in ipairs(player.GetAll()) do
            if ply:IsValid() and ply:Alive() then
                local location = ply:GetPos()
                local action = "N/A"  -- Placeholder para acciones
                playerList:AddLine(ply:Nick(), string.format("X: %.1f Y: %.1f Z: %.1f", location.x, location.y, location.z), action)
            end
        end
    end

    -- Botón para actualizar manualmente la lista
    local refreshButton = vgui.Create("DButton", frame)
    refreshButton:SetPos(10, 5)
    refreshButton:SetSize(100, 20)
    refreshButton:SetText("Actualizar")

    refreshButton.DoClick = function()
        UpdatePlayerList()
        notification.AddLegacy("Lista de jugadores actualizada.", NOTIFY_HINT, 5)
    end

    -- Actualizar automáticamente cada 5 segundos
    timer.Create("PlayerTrackingUpdate", 5, 0, UpdatePlayerList)
    UpdatePlayerList()  -- Llamar la función para la primera carga
end

-- Comando para abrir el panel
concommand.Add("open_player_tracking_panel", OpenPlayerTrackingPanel)

-- Añadir un enlace al panel en el menú del jugador
hook.Add("OnContextMenuOpen", "AddPlayerTrackingPanelToMenu", function()
    local menu = DermaMenu()

    menu:AddOption("Seguimiento de Jugadores", function()
        OpenPlayerTrackingPanel()
    end)

    menu:Open()
end)