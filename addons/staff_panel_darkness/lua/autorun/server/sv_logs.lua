-- sv_logs.lua

-- Crear una tabla para almacenar los registros
local logs = {}

-- Función para agregar un registro
local function AddLog(player, action)
    local logEntry = {
        player = player:Nick(),
        steamID = player:SteamID(),
        action = action,
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
    }
    table.insert(logs, logEntry)
    PrintLogToFile(logEntry)  -- Guarda en archivo
end

-- Función para guardar registros en un archivo
local function PrintLogToFile(logEntry)
    local filePath = "data/player_activity_logs.txt"
    local logLine = string.format("[%s] %s (%s): %s\n", logEntry.timestamp, logEntry.player, logEntry.steamID, logEntry.action)
    file.Append(filePath, logLine)
end

-- Comando para mostrar registros al staff
concommand.Add("view_logs", function(ply)
    if ply:IsAdmin() then
        -- Crea un panel para mostrar registros (opcional)
        local logFrame = vgui.Create("DFrame")
        logFrame:SetSize(600, 400)
        logFrame:SetTitle("Registro de Actividades")
        logFrame:Center()
        logFrame:MakePopup()

        local logList = vgui.Create("DListView", logFrame)
        logList:SetPos(10, 30)
        logList:SetSize(580, 360)
        logList:AddColumn("Fecha y Hora")
        logList:AddColumn("Jugador")
        logList:AddColumn("Acción")

        for _, log in ipairs(logs) do
            logList:AddLine(log.timestamp, log.player, log.action)
        end
    else
        ply:ChatPrint("No tienes permiso para ver los registros.")
    end
end)

-- Ejemplo de uso: registrar la acción de un jugador
hook.Add("PlayerSpawn", "LogPlayerSpawn", function(ply)
    AddLog(ply, "ha aparecido en el juego.")
end)

hook.Add("PlayerSay", "LogPlayerChat", function(ply, text)
    AddLog(ply, "dijo: " .. text)
end)

hook.Add("PlayerDisconnect", "LogPlayerDisconnect", function(ply)
    AddLog(ply, "se ha desconectado.")
end)

-- Comando para limpiar registros más antiguos de 3 meses
concommand.Add("clear_old_logs", function(ply)
    if ply:IsAdmin() then
        local cutoffTime = os.time() - (90 * 24 * 60 * 60)  -- 90 días en segundos
        for i = #logs, 1, -1 do
            if os.time(logs[i].timestamp) < cutoffTime then
                table.remove(logs, i)
            end
        end
        ply:ChatPrint("Registros antiguos han sido eliminados.")
    else
        ply:ChatPrint("No tienes permiso para limpiar los registros.")
    end
end)