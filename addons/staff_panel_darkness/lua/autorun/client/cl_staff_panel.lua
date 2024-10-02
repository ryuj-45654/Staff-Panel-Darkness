-- cl_staff_panel.lua

local function openStaffPanel()
    local frame = vgui.Create("DFrame")
    frame:SetSize(500, 600)
    frame:SetTitle("Staff Panel")
    frame:Center()
    frame:MakePopup()

    -- Botón para traer a un jugador
    local bringButton = vgui.Create("DButton", frame)
    bringButton:SetSize(480, 40)
    bringButton:SetPos(10, 50)
    bringButton:SetText("Bring Player")
    bringButton.DoClick = function()
        Derma_StringRequest("Bring Player", "Enter the Player ID to bring:", "", function(text)
            RunConsoleCommand("say", "!bring " .. text)
        end)
    end

    -- Botón para congelar a un jugador
    local freezeButton = vgui.Create("DButton", frame)
    freezeButton:SetSize(480, 40)
    freezeButton:SetPos(10, 100)
    freezeButton:SetText("Freeze Player")
    freezeButton.DoClick = function()
        Derma_StringRequest("Freeze Player", "Enter the Player ID to freeze:", "", function(text)
            RunConsoleCommand("say", "!freeze " .. text)
        end)
    end

    -- Botón para descongelar a un jugador
    local unfreezeButton = vgui.Create("DButton", frame)
    unfreezeButton:SetSize(480, 40)
    unfreezeButton:SetPos(10, 150)
    unfreezeButton:SetText("Unfreeze Player")
    unfreezeButton.DoClick = function()
        Derma_StringRequest("Unfreeze Player", "Enter the Player ID to unfreeze:", "", function(text)
            RunConsoleCommand("say", "!unfreeze " .. text)
        end)
    end

    -- Botón para teletransportarse a un jugador
    local teleportButton = vgui.Create("DButton", frame)
    teleportButton:SetSize(480, 40)
    teleportButton:SetPos(10, 200)
    teleportButton:SetText("Teleport to Player")
    teleportButton.DoClick = function()
        Derma_StringRequest("Teleport to Player", "Enter the Player ID to teleport to:", "", function(text)
            RunConsoleCommand("say", "!tp " .. text)
        end)
    end

    -- Botón para devolver a un jugador a su posición original
    local unbringButton = vgui.Create("DButton", frame)
    unbringButton:SetSize(480, 40)
    unbringButton:SetPos(10, 250)
    unbringButton:SetText("Unbring Player")
    unbringButton.DoClick = function()
        Derma_StringRequest("Unbring Player", "Enter the Player ID to return:", "", function(text)
            RunConsoleCommand("say", "!unbring " .. text)
        end)
    end

    -- Botón para ver las sugerencias de los jugadores
    local suggestionsButton = vgui.Create("DButton", frame)
    suggestionsButton:SetSize(480, 40)
    suggestionsButton:SetPos(10, 300)
    suggestionsButton:SetText("View Player Suggestions")
    suggestionsButton.DoClick = function()
        RunConsoleCommand("say", "!viewsuggestions")
    end
end

-- Comando para abrir el panel de staff
concommand.Add("open_staff_panel", openStaffPanel)