-- sv_rewards_punishments.lua

-- Crear una tabla para almacenar los registros de recompensas y castigos
local rewardsAndPunishments = {}

-- Función para agregar un registro de recompensa o castigo
local function AddRewardPunishment(player, type, reason)
    local entry = {
        player = player:Nick(),
        steamID = player:SteamID(),
        type = type,
        reason = reason,
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
    }
    table.insert(rewardsAndPunishments, entry)
    PrintRewardPunishmentToFile(entry)  -- Guarda en archivo
end

-- Función para guardar en un archivo
local function PrintRewardPunishmentToFile(entry)
    local filePath = "data/rewards_punishments_logs.txt"
    local logLine = string.format("[%s] %s (%s): %s - %s\n", entry.timestamp, entry.player, entry.steamID, entry.type, entry.reason)
    file.Append(filePath, logLine)
end

-- Comando para otorgar una recompensa
concommand.Add("give_reward", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local target = player.GetByID(args[1])
    local rewardReason = args[2] or "Sin razón especificada"
    if target then
        AddRewardPunishment(target, "Recompensa", rewardReason)
        target:ChatPrint("Has recibido una recompensa: " .. rewardReason)
        ply:ChatPrint("Recompensa otorgada a " .. target:Nick() .. ": " .. rewardReason)
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Comando para aplicar un castigo
concommand.Add("give_punishment", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local target = player.GetByID(args[1])
    local punishmentReason = args[2] or "Sin razón especificada"
    if target then
        AddRewardPunishment(target, "Castigo", punishmentReason)
        target:ChatPrint("Has recibido un castigo: " .. punishmentReason)
        ply:ChatPrint("Castigo aplicado a " .. target:Nick() .. ": " .. punishmentReason)
    else
        ply:ChatPrint("Jugador no encontrado.")
    end
end)

-- Comando para ver el historial de recompensas y castigos
concommand.Add("view_rewards_punishments", function(ply)
    if ply:IsAdmin() then
        local rpFrame = vgui.Create("DFrame")
        rpFrame:SetSize(600, 400)
        rpFrame:SetTitle("Registro de Recompensas y Castigos")
        rpFrame:Center()
        rpFrame:MakePopup()

        local rpList = vgui.Create("DListView", rpFrame)
        rpList:SetPos(10, 30)
        rpList:SetSize(580, 360)
        rpList:AddColumn("Fecha y Hora")
        rpList:AddColumn("Jugador")
        rpList:AddColumn("Tipo")
        rpList:AddColumn("Razón")

        for _, entry in ipairs(rewardsAndPunishments) do
            rpList:AddLine(entry.timestamp, entry.player, entry.type, entry.reason)
        end
    else
        ply:ChatPrint("No tienes permiso para ver este registro.")
    end
end)

-- Comando para limpiar el historial
concommand.Add("clear_rewards_punishments", function(ply)
    if ply:IsAdmin() then
        rewardsAndPunishments = {}
        file.Write("data/rewards_punishments_logs.txt", "")  -- Limpia el archivo
        ply:ChatPrint("Historial de recompensas y castigos ha sido limpiado.")
    else
        ply:ChatPrint("No tienes permiso para limpiar este registro.")
    end
end)

-- Ejemplo de uso: registrar una recompensa o castigo en el evento correspondiente
hook.Add("PlayerSpawn", "LogPlayerSpawnRP", function(ply)
    AddRewardPunishment(ply, "Recompensa", "Apareció en el juego por primera vez.")
end)