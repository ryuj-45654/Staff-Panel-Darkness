-- sv_staff_commands.lua

-- Añadimos las redes para enviar notificaciones
util.AddNetworkString("SendNotification")

-- Comando para congelar a un jugador
function FreezePlayer(ply, target)
    if not IsValid(target) then return end
    target:Freeze(true)

    -- Envía la notificación al staff (ply) que ejecutó el comando
    net.Start("SendNotification")
    net.WriteString("You have frozen " .. target:Nick())
    net.WriteUInt(1, 3) -- Tipo de notificación (1 = genérica)
    net.WriteUInt(5, 8) -- Duración de 5 segundos
    net.Send(ply) -- Envía al staff

    -- Notifica al jugador congelado
    net.Start("SendNotification")
    net.WriteString("You have been frozen by staff.")
    net.WriteUInt(2, 3) -- Tipo de notificación (2 = advertencia)
    net.WriteUInt(5, 8) -- Duración de 5 segundos
    net.Send(target) -- Envía al jugador objetivo
end

-- Comando para descongelar a un jugador
function UnfreezePlayer(ply, target)
    if not IsValid(target) then return end
    target:Freeze(false)

    -- Envía la notificación al staff (ply) que ejecutó el comando
    net.Start("SendNotification")
    net.WriteString("You have unfrozen " .. target:Nick())
    net.WriteUInt(1, 3) -- Tipo de notificación (1 = genérica)
    net.WriteUInt(5, 8) -- Duración de 5 segundos
    net.Send(ply)

    -- Notifica al jugador descongelado
    net.Start("SendNotification")
    net.WriteString("You have been unfrozen by staff.")
    net.WriteUInt(1, 3) -- Tipo de notificación (1 = genérica)
    net.WriteUInt(5, 8) -- Duración de 5 segundos
    net.Send(target)
end

-- Comando para llevar a un jugador hacia el staff
function BringPlayer(ply, target)
    if not IsValid(target) then return end
    target:SetPos(ply:GetPos() + ply:GetForward() * 50) -- Lleva al jugador al staff

    -- Envía la notificación al staff (ply)
    net.Start("SendNotification")
    net.WriteString("You have brought " .. target:Nick() .. " to your location.")
    net.WriteUInt(1, 3)
    net.WriteUInt(5, 8)
    net.Send(ply)

    -- Notifica al jugador movido
    net.Start("SendNotification")
    net.WriteString("You have been brought by staff.")
    net.WriteUInt(1, 3)
    net.WriteUInt(5, 8)
    net.Send(target)
end

-- Comando para devolver a un jugador a su posición original
local playerLastPosition = {} -- Almacena las posiciones originales

function UnbringPlayer(ply, target)
    if not IsValid(target) then return end
    if not playerLastPosition[target:SteamID()] then
        ply:ChatPrint("No saved position for " .. target:Nick() .. ".")
        return
    end

    -- Devuelve al jugador a su última posición conocida
    target:SetPos(playerLastPosition[target:SteamID()])

    -- Envía la notificación al staff (ply)
    net.Start("SendNotification")
    net.WriteString("You have returned " .. target:Nick() .. " to their original position.")
    net.WriteUInt(1, 3)
    net.WriteUInt(5, 8)
    net.Send(ply)

    -- Notifica al jugador movido
    net.Start("SendNotification")
    net.WriteString("You have been returned to your original position by staff.")
    net.WriteUInt(1, 3)
    net.WriteUInt(5, 8)
    net.Send(target)
end

-- Comando para guardar la posición original del jugador antes de usar !bring
function SavePlayerPosition(target)
    if not IsValid(target) then return end
    playerLastPosition[target:SteamID()] = target:GetPos()
end

-- Sistema de logs de actividad de comandos
local function LogStaffCommand(ply, command, target)
    if not IsValid(ply) then return end
    local logText = "[" .. os.date() .. "] " .. ply:Nick() .. " executed " .. command .. " on " .. target:Nick() .. ".\n"
    
    -- Guardar los logs en el servidor
    file.Append("staff_command_logs.txt", logText)
end

-- Hook para comandos !freeze, !unfreeze, !bring, !unbring
hook.Add("PlayerSay", "StaffCommandsHandler", function(ply, text)
    local args = string.Explode(" ", text)
    local command = args[1]
    local targetName = args[2]
    local target = player.GetByName(targetName)

    if command == "!freeze" and IsValid(target) then
        FreezePlayer(ply, target)
        LogStaffCommand(ply, "!freeze", target)
        return ""
    elseif command == "!unfreeze" and IsValid(target) then
        UnfreezePlayer(ply, target)
        LogStaffCommand(ply, "!unfreeze", target)
        return ""
    elseif command == "!bring" and IsValid(target) then
        SavePlayerPosition(target)
        BringPlayer(ply, target)
        LogStaffCommand(ply, "!bring", target)
        return ""
    elseif command == "!unbring" and IsValid(target) then
        UnbringPlayer(ply, target)
        LogStaffCommand(ply, "!unbring", target)
        return ""
    end
end)