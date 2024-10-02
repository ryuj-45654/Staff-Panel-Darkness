-- sv_suggestion_system.lua

-- Tabla para almacenar las sugerencias
local suggestions = {}

-- Función para guardar una sugerencia
local function SaveSuggestion(player, suggestion)
    local suggestionID = #suggestions + 1
    suggestions[suggestionID] = {
        id = suggestionID,
        player = player:Nick(),
        suggestion = suggestion,
        timestamp = os.time()
    }

    -- Notificar al jugador que su sugerencia ha sido recibida
    player:ChatPrint("Tu sugerencia ha sido recibida con ID: " .. suggestionID)
    LogPlayerActivity(player, "Sugerencia enviada: " .. suggestion)
end

-- Función para mostrar todas las sugerencias
local function ShowSuggestions(ply)
    if not ply:IsAdmin() then return end

    ply:ChatPrint("Sugerencias recibidas:")
    for _, suggestion in pairs(suggestions) do
        ply:ChatPrint("ID: " .. suggestion.id .. " | Jugador: " .. suggestion.player .. " | Sugerencia: " .. suggestion.suggestion)
    end
end

-- Comando para enviar una sugerencia
concommand.Add("!suggest", function(ply, cmd, args)
    if #args < 1 then
        ply:ChatPrint("Uso: !suggest <tu sugerencia>")
        return
    end

    local suggestion = table.concat(args, " ")
    SaveSuggestion(ply, suggestion)
end)

-- Comando para mostrar todas las sugerencias (solo para administradores)
concommand.Add("!showsuggestions", function(ply, cmd, args)
    ShowSuggestions(ply)
end)

-- Comando para eliminar una sugerencia (solo para administradores)
concommand.Add("!deletesuggestion", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    local suggestionID = tonumber(args[1])
    if suggestions[suggestionID] then
        table.remove(suggestions, suggestionID)
        ply:ChatPrint("Sugerencia con ID " .. suggestionID .. " ha sido eliminada.")
    else
        ply:ChatPrint("No se encontró la sugerencia con ID " .. suggestionID)
    end
end)

-- Comando para limpiar sugerencias (solo para administradores)
concommand.Add("!clearsuggestions", function(ply, cmd, args)
    if not ply:IsAdmin() then return end

    suggestions = {}
    ply:ChatPrint("Todas las sugerencias han sido eliminadas.")
end)