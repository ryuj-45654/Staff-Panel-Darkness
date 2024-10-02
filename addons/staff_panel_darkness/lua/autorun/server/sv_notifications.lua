-- sv_notifications.lua

-- Crear una tabla para almacenar las notificaciones
local notifications = {}

-- Función para agregar una notificación
local function AddNotification(player, message, duration)
    local notification = {
        player = player,
        message = message,
        duration = duration,
        timestamp = CurTime()
    }
    table.insert(notifications, notification)
end

-- Función para enviar notificaciones a un jugador
local function SendNotification(player)
    for _, notification in ipairs(notifications) do
        if notification.player == player then
            net.Start("SendNotification")
            net.WriteString(notification.message)
            net.WriteUInt(1, 3) -- Tipo de notificación (1 = genérica)
            net.WriteUInt(notification.duration, 8) -- Duración
            net.Send(player)
        end
    end
end

-- Hook para limpiar las notificaciones después de cierto tiempo
hook.Add("Think", "CleanNotifications", function()
    for k = #notifications, 1, -1 do
        local notification = notifications[k]
        if CurTime() - notification.timestamp > notification.duration then
            table.remove(notifications, k)
        end
    end
end)

-- Comando para enviar una notificación a un jugador
concommand.Add("send_notification", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local target = player.GetByID(args[1])
    local message = args[2] or "Sin mensaje especificado"
    local duration = tonumber(args[3]) or 5 -- Duración por defecto de 5 segundos

    if target then
        AddNotification(target, message, duration)
        SendNotification(target)
        ply:ChatPrint("Notificación enviada a " .. target:Nick() .. ": " .. message)
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Registro de la red para el cliente
util.AddNetworkString("SendNotification")

-- Comando para enviar una notificación a todos los jugadores
concommand.Add("send_notification_all", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local message = args[1] or "Sin mensaje especificado"
    local duration = tonumber(args[2]) or 5 -- Duración por defecto de 5 segundos

    for _, player in ipairs(player.GetAll()) do
        AddNotification(player, message, duration)
        SendNotification(player)
    end
    ply:ChatPrint("Notificación enviada a todos los jugadores: " .. message)
end)