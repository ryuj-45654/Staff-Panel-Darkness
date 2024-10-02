-- sv_teleport.lua

-- Funci�n para teletransportar a un jugador a una ubicaci�n espec�fica
local function TeleportPlayer(ply, target, location)
    if not IsValid(ply) or not IsValid(target) then return end

    target:SetPos(location)
    LogPlayerActivity(ply, "Teletransportado a " .. target:Nick() .. " a la ubicaci�n: " .. tostring(location))
    
    -- Notificar al jugador
    target:ChatPrint("Has sido teletransportado por " .. ply:Nick())
    ply:ChatPrint("Has teletransportado a " .. target:Nick() .. " a la ubicaci�n: " .. tostring(location))
end

-- Comando para teletransportar a un jugador a una ubicaci�n espec�fica
concommand.Add("!teleport", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local targetID = tonumber(args[1])
    local target = player.GetByID(targetID)

    if target and IsValid(target) then
        local location = Vector(0, 0, 0) -- Cambia esto a la ubicaci�n a la que quieres teletransportar
        TeleportPlayer(ply, target, location)
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Comando para teletransportar al jugador a su �ltima ubicaci�n
concommand.Add("!bring", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local targetID = tonumber(args[1])
    local target = player.GetByID(targetID)

    if target and IsValid(target) then
        local lastPos = target:GetPos() -- Obtiene la �ltima posici�n del jugador
        TeleportPlayer(ply, target, lastPos)
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Comando para devolver al jugador a su ubicaci�n anterior
concommand.Add("!unbring", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local targetID = tonumber(args[1])
    local target = player.GetByID(targetID)

    if target and IsValid(target) then
        -- Se almacena la posici�n anterior en un registro
        if not target.previousPos then
            ply:ChatPrint("No hay ubicaci�n anterior registrada.")
            return
        end

        TeleportPlayer(ply, target, target.previousPos)
        target.previousPos = target:GetPos() -- Actualiza la posici�n anterior
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Almacenar la posici�n anterior cuando un jugador muere
hook.Add("PlayerDeath", "StorePreviousPosition", function(victim, inflictor, attacker)
    if IsValid(victim) then
        victim.previousPos = victim:GetPos() -- Guardar la posici�n actual como anterior
    end
end)