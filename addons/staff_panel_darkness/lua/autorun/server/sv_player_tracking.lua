-- sv_player_tracking.lua

-- Crear una tabla para almacenar la actividad de los jugadores
local playerActivityLogs = {}

-- Función para registrar la actividad de un jugador
local function LogPlayerActivity(player, action)
    if not IsValid(player) then return end

    local logEntry = {
        steamID = player:SteamID(),
        name = player:Nick(),
        action = action,
        timestamp = os.date("%Y-%m-%d %H:%M:%S")
    }

    table.insert(playerActivityLogs, logEntry)

    -- Guardar el registro en el archivo
    file.Append("player_activity_logs.txt", util.TableToJSON(logEntry) .. "\n")
end

-- Función para obtener el registro de un jugador
local function GetPlayerActivity(player)
    local logs = {}
    for _, log in ipairs(playerActivityLogs) do
        if log.steamID == player:SteamID() then
            table.insert(logs, log)
        end
    end
    return logs
end

-- Comando para registrar la ubicación del jugador
concommand.Add("track_player_location", function(ply)
    if not ply:IsAdmin() then return end

    for _, target in ipairs(player.GetAll()) do
        if IsValid(target) then
            local location = target:GetPos()
            LogPlayerActivity(ply, "Ubicación de " .. target:Nick() .. ": " .. tostring(location))
        end
    end
end)

-- Comando para mostrar la actividad de un jugador específico
concommand.Add("show_player_activity", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local targetID = args[1]
    local target = player.GetByID(tonumber(targetID))

    if target and IsValid(target) then
        local activityLogs = GetPlayerActivity(target)
        for _, log in ipairs(activityLogs) do
            ply:ChatPrint("[" .. log.timestamp .. "] " .. log.name .. ": " .. log.action)
        end
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Comando para limpiar los registros de actividad después de 3 meses
timer.Create("ClearOldLogs", 60 * 60 * 24 * 30, 0, function() -- Cada mes
    local cutoffTime = os.time() - (60 * 60 * 24 * 90) -- 90 días
    for k = #playerActivityLogs, 1, -1 do
        if os.time() > cutoffTime then
            table.remove(playerActivityLogs, k)
        end
    end
end)