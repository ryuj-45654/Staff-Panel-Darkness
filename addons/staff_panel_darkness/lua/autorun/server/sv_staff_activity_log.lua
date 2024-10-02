-- sv_staff_activity_log.lua

-- Tabla para almacenar los registros de actividades del staff
local staffActivityLogs = {}

-- Función para registrar una actividad del personal
local function LogStaffActivity(staffMember, action)
    local logEntry = {
        staffMember = staffMember:Nick(),
        action = action,
        timestamp = os.time()
    }

    table.insert(staffActivityLogs, logEntry)

    -- También puedes guardar en un archivo si es necesario
    file.Append("staff_activity_logs.txt", logEntry.staffMember .. " | " .. os.date("%Y-%m-%d %H:%M:%S", logEntry.timestamp) .. " | " .. action .. "\n")
end

-- Comando para mostrar las actividades registradas (solo para administradores)
concommand.Add("!showstafflogs", function(ply)
    if not ply:IsAdmin() then return end

    ply:ChatPrint("Registro de Actividades del Personal:")
    for _, log in ipairs(staffActivityLogs) do
        ply:ChatPrint("[" .. os.date("%Y-%m-%d %H:%M:%S", log.timestamp) .. "] " .. log.staffMember .. ": " .. log.action)
    end
end)

-- Ejemplo de uso del registro de actividades
hook.Add("PlayerSay", "LogStaffChat", function(ply, text)
    if ply:IsAdmin() then
        LogStaffActivity(ply, "Dijo: " .. text)
    end
end)

hook.Add("PlayerSpawn", "LogStaffSpawn", function(ply)
    if ply:IsAdmin() then
        LogStaffActivity(ply, "Se ha unido al juego.")
    end
end)

hook.Add("PlayerDisconnect", "LogStaffDisconnect", function(ply)
    if ply:IsAdmin() then
        LogStaffActivity(ply, "Se ha desconectado.")
    end
end)

-- Comando para limpiar los registros (solo para administradores)
concommand.Add("!clearstafflogs", function(ply)
    if not ply:IsAdmin() then return end

    staffActivityLogs = {}
    file.Delete("staff_activity_logs.txt") -- Borra el archivo de logs
    ply:ChatPrint("Todos los registros de actividades del personal han sido eliminados.")
end)