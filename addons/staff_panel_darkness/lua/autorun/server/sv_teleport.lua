-- sv_teleport.lua

-- Función para teletransportar a un jugador a una ubicación específica
local function TeleportPlayer(ply, target, location)
    if not IsValid(ply) or not IsValid(target) then return end

    target:SetPos(location)
    LogPlayerActivity(ply, "Teletransportado a " .. target:Nick() .. " a la ubicación: " .. tostring(location))
    
    -- Notificar al jugador
    target:ChatPrint("Has sido teletransportado por " .. ply:Nick())
    ply:ChatPrint("Has teletransportado a " .. target:Nick() .. " a la ubicación: " .. tostring(location))
end

-- Comando para teletransportar a un jugador a una ubicación específica
concommand.Add("!teleport", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local targetID = tonumber(args[1])
    local target = player.GetByID(targetID)

    if target and IsValid(target) then
        local location = Vector(0, 0, 0) -- Cambia esto a la ubicación a la que quieres teletransportar
        TeleportPlayer(ply, target, location)
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Comando para teletransportar al jugador a su última ubicación
concommand.Add("!bring", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local targetID = tonumber(args[1])
    local target = player.GetByID(targetID)

    if target and IsValid(target) then
        local lastPos = target:GetPos() -- Obtiene la última posición del jugador
        TeleportPlayer(ply, target, lastPos)
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Comando para devolver al jugador a su ubicación anterior
concommand.Add("!unbring", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local targetID = tonumber(args[1])
    local target = player.GetByID(targetID)

    if target and IsValid(target) then
        -- Se almacena la posición anterior en un registro
        if not target.previousPos then
            ply:ChatPrint("No hay ubicación anterior registrada.")
            return
        end

        TeleportPlayer(ply, target, target.previousPos)
        target.previousPos = target:GetPos() -- Actualiza la posición anterior
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Almacenar la posición anterior cuando un jugador muere
hook.Add("PlayerDeath", "StorePreviousPosition", function(victim, inflictor, attacker)
    if IsValid(victim) then
        victim.previousPos = victim:GetPos() -- Guardar la posición actual como anterior
    end
end)