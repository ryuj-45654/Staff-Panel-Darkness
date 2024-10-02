-- sv_activity_logging.lua
-- Este script registra actividades del jugador y las envía a un canal de Discord mediante un webhook

-- Función para enviar un mensaje al webhook de Discord
function sendToDiscord(content)
    local webhookURL = "TU_WEBHOOK_URL_AQUÍ" -- Reemplaza con tu URL del webhook

    -- Crea la tabla con los datos del mensaje
    local data = {
        content = content
    }

    -- Envía el mensaje al webhook
    http.Post(webhookURL, data, function(response) 
        print("Mensaje enviado a Discord: " .. content) 
    end, function(error) 
        print("Error al enviar mensaje a Discord: " .. error) 
    end)
end

-- Registra cuando un jugador aparece en el servidor
hook.Add("PlayerSpawn", "LogPlayerSpawn", function(ply)
    local message = ply:Nick() .. " ha aparecido en el servidor."
    sendToDiscord(message)
end)

-- Registra cuando un jugador dice algo en el chat
hook.Add("PlayerSay", "LogPlayerChat", function(ply, text)
    local message = ply:Nick() .. " dice: " .. text
    sendToDiscord(message)
end)

-- Registra cuando un jugador se une al servidor
hook.Add("PlayerInitialSpawn", "LogPlayerJoin", function(ply)
    local message = ply:Nick() .. " se ha unido al servidor."
    sendToDiscord(message)
end)

-- Registra cuando un jugador se desconecta del servidor
hook.Add("PlayerDisconnected", "LogPlayerDisconnect", function(ply)
    local message = ply:Nick() .. " se ha desconectado del servidor."
    sendToDiscord(message)
end)

-- Registra cuando un jugador gana un premio
hook.Add("PlayerGiveAchievement", "LogPlayerAchievement", function(ply, achievement)
    local message = ply:Nick() .. " ha ganado el logro: " .. achievement
    sendToDiscord(message)
end)

-- Registra cuando un jugador recibe un castigo
hook.Add("PlayerPunish", "LogPlayerPunishment", function(ply, reason)
    local message = ply:Nick() .. " ha sido castigado por: " .. reason
    sendToDiscord(message)
end)